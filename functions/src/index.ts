import * as admin from "firebase-admin";
import * as functions from "firebase-functions";

admin.initializeApp();

const db = admin.firestore();
const auth = admin.auth();

/**
 * 신규 Firebase Auth 계정 생성 시 자동 호출.
 * Cloud Functions에서 users 문서를 생성하지 않는 경우를 대비한 폴백.
 * (클라이언트 _ensureUserDoc이 주 생성 경로이므로 여기선 merge 방식으로 보완)
 */
export const onUserCreate = functions.auth.user().onCreate(async (user) => {
  const userRef = db.collection("users").doc(user.uid);
  const snap = await userRef.get();
  if (snap.exists) return; // 클라이언트가 이미 생성함

  const now = admin.firestore.FieldValue.serverTimestamp();
  await userRef.set({
    uid: user.uid,
    email: user.email ?? null,
    displayName: user.displayName ?? null,
    photoUrl: user.photoURL ?? null,
    provider: null,
    linkedProviders: user.providerData.map((p) => p.providerId),
    isFirstLogin: true,
    createdAt: now,
    updatedAt: now,
  });

  await userRef.collection("usageTime").doc("current").set({
    remainingSeconds: 600,
    dailyAdWatchCount: 0,
    lastAdResetDate: now,
  });

  await userRef.collection("subscription").doc("current").set({
    status: "none",
    platform: null,
    productId: null,
    originalTransactionId: null,
    purchaseToken: null,
    startedAt: null,
    expiresAt: null,
    renewedAt: null,
    cancelledAt: null,
    autoRenewing: false,
    verifiedAt: null,
  });
});

/**
 * Kakao 액세스 토큰을 Firebase Custom Token으로 교환.
 * 클라이언트: FirebaseFunctions.instance.httpsCallable('kakaoTokenExchange')
 */
export const kakaoTokenExchange = functions.https.onCall(
  async (request) => {
    const kakaoUid = request.data?.kakaoUid as string | undefined;
    if (!kakaoUid) {
      throw new functions.https.HttpsError(
        "invalid-argument",
        "kakaoUid is required"
      );
    }
    const firebaseUid = `kakao:${kakaoUid}`;
    const customToken = await auth.createCustomToken(firebaseUid, {
      provider: "kakao",
    });
    return { customToken };
  }
);

/**
 * IAP 영수증/구매 토큰 서버 검증 후 subscription/current와 payments 문서 업데이트.
 * 클라이언트: FirebaseFunctions.instance.httpsCallable('verifySubscription')
 */
export const verifySubscription = functions.https.onCall(
  async (request) => {
    if (!request.auth) {
      throw new functions.https.HttpsError(
        "unauthenticated",
        "Authentication required"
      );
    }

    const { transactionId, platform } = request.data as {
      transactionId: string;
      platform: "ios" | "android";
    };

    if (!transactionId || !platform) {
      throw new functions.https.HttpsError(
        "invalid-argument",
        "transactionId and platform are required"
      );
    }

    const uid = request.auth.uid;
    const now = admin.firestore.FieldValue.serverTimestamp();

    // TODO: 실제 App Store / Google Play 서버 검증 API 호출
    // iOS: https://api.storekit.itunes.apple.com/inApps/v1/transactions/{transactionId}
    // Android: Google Play Developer API subscriptions.get
    // 검증 실패 시 HttpsError("failed-precondition", ...) throw

    // 검증 성공 가정 (expiresAt = 현재 + 30일)
    const expiresAt = admin.firestore.Timestamp.fromDate(
      new Date(Date.now() + 30 * 24 * 60 * 60 * 1000)
    );

    const batch = db.batch();

    batch.set(
      db.collection("users").doc(uid).collection("subscription").doc("current"),
      {
        status: "active",
        platform,
        expiresAt,
        renewedAt: now,
        autoRenewing: true,
        verifiedAt: now,
      },
      { merge: true }
    );

    batch.update(
      db
        .collection("users")
        .doc(uid)
        .collection("payments")
        .doc(transactionId),
      {
        verificationStatus: "verified",
        verifiedAt: now,
      }
    );

    await batch.commit();
    return { success: true, expiresAt: expiresAt.toDate().toISOString() };
  }
);

/**
 * payments/{id} 문서 생성 감지 → 자동 서버 검증 트리거.
 */
export const onSubscriptionPaymentCreate = functions.firestore
  .document("users/{uid}/payments/{paymentId}")
  .onCreate(async (snap, context) => {
    const data = snap.data();
    if (data?.verificationStatus !== "pending") return;

    const uid = context.params.uid as string;
    const now = admin.firestore.FieldValue.serverTimestamp();

    // TODO: 실제 스토어 검증 로직 연결 (verifySubscription 함수와 공유)
    // 현재는 pending 상태로 기록만 함. verifySubscription callable을 클라이언트에서 호출해야 함.

    await db
      .collection("users")
      .doc(uid)
      .collection("payments")
      .doc(snap.id)
      .update({ triggeredAt: now });
  });
