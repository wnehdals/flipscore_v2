# CLAUDE.md — FlipScore

## 프로젝트 개요

**FlipScore** — 연주자가 손을 쓰지 않고도 악보를 자동으로 넘길 수 있는 핸즈프리 스마트 악보 뷰어 앱.

- 서비스 기획 전문: [flip_score_service.md](flip_score_service.md)
- Firebase 프로젝트: `flipmusicscore`
- 패키지명: `com.example.flip_score2` (배포 전 변경 필요)
- Flutter SDK: `^3.12.2` / Dart: `^3.12.2`
- 지원 플랫폼: **Android / iOS** (태블릿 우선, 가로 모드 기본)

---

## 기술 스택

| 항목 | 내용 |
|---|---|
| 프레임워크 | Flutter |
| 언어 | Dart |
| 백엔드/인프라 | Firebase (Firestore, Auth, Storage, Analytics) |
| 광고 | Google AdMob (보상형 광고) |
| 인앱 결제 | Google Play / App Store (월 구독) |

### 설치 예정 핵심 패키지

| 기능 | 패키지 |
|---|---|
| 소셜 로그인 | `google_sign_in`, `sign_in_with_apple`, `kakao_flutter_sdk` |
| 얼굴/눈 제스처 감지 | `google_mlkit_face_detection` |
| PDF 렌더링 | `pdfx` |
| 오디오 재생 | `just_audio` |
| 이미지 드래그앤드롭 정렬 | `reorderable_grid_view` |
| 카메라 스트림 | `camera` |
| 인앱 결제 | `in_app_purchase` |
| 보상형 광고 | `google_mobile_ads` |
| 라우팅 | `go_router` |
| 상태관리 | `riverpod` |

---


### 컬러 팔레트

| 이름 | 값 | 용도 |
|---|---|---|
| `primary` | `#4F5BD5` | 브랜드 컬러, 주요 액션 버튼, 활성 상태 |
| `primaryLight` | `#EEF0FF` | 배지 배경, 아이콘 배경 |
| `surface` | `#FFFFFF` | 카드, 패널 배경 |
| `background` | `#F6F7F8` | 앱 전체 배경 |
| `dark` | `#17181B` | 주요 텍스트, 다크 버튼 |
| `textSecondary` | `#6E7178` | 보조 텍스트 |
| `textTertiary` | `#9AA0A6` | 힌트, 비활성 텍스트 |
| `border` | `#EDEEF0` | 카드/패널 테두리 |
| `divider` | `#F0F1F3` | 항목 구분선 |
| `playerBg` | `#17181B` | 플레이어 바 배경 |
| `playerAccent` | `#7C87E8` | 프로그레스 바 |

### 타이포그래피

- **폰트**: Pretendard Variable (`pretendard` 패키지 또는 Google Fonts 대체)
- 제목: 30px / weight 800
- 서브제목: 17px / weight 700
- 본문: 14–15px / weight 400–600
- 캡션: 12–13px / weight 400–600

### 레이아웃

- **기본 방향**: 가로(Landscape) 고정
- **타깃 해상도**: 1184 × 824 pt (iPad Air 11")
- 사이드 네비게이션 바 너비: 78px
- 카드 반경: 16px / 컨테이너 반경: 26–44px
- 여백 기본단위: 8px
- width, height, BorderRadius.circular, EdgeInsets.symmetric 값 입력 시 Responsive.getDp(context, value) 반드시 사용하기

---

## 화면 목록

| ID | 화면명 | 경로(예정) |
|---|---|---|
| S-00 | 로그인 | `/login` |
| S-01 | 온보딩 | `/onboarding` |
| S-02 | 홈 (악보뷰어 목록) | `/` |
| S-03 | 악보뷰어 생성 — 악보 수집 | `/create/scores` |
| S-04 | 악보뷰어 생성 — 전환 방식 선택 | `/create/mode` |
| S-05 | 악보뷰어 생성 — 노래 선택 | `/create/song` |
| S-06 | 악보뷰어 생성 — 제스처 선택 | `/create/gesture` |
| S-07 | 타임라인 설정 | `/viewer/:id/timeline` |
| S-08 | 악보뷰어 실행 | `/viewer/:id` |
| S-09 | 이용시간 | `/usage-time` |
| S-10 | 구독 결제 | `/subscription` |
| S-11 | 설정 | `/settings` |

---

## 디렉토리 구조 (권장)

```
lib/
├── main.dart
├── firebase_options.dart
├── app/
│   ├── app.dart              # MaterialApp + GoRouter 설정
│   └── router.dart
├── core/
│   ├── theme/                # AppColors, AppTextStyles, AppTheme
│   ├── constants/
│   └── utils/
├── features/
│   ├── auth/                 # S-00 로그인, S-01 온보딩
│   ├── home/                 # S-02 홈
│   ├── create/               # S-03~S-06 악보뷰어 생성 플로우
│   ├── viewer/               # S-07 타임라인, S-08 악보뷰어 실행
│   ├── usage_time/           # S-09 이용시간, S-10 구독
│   └── settings/             # S-11 설정
└── shared/
    ├── widgets/              # 공통 위젯
    └── models/               # ScoreViewer, Timeline 등 모델
```

각 feature는 `presentation/`, `domain/`, `data/` 3계층으로 구성한다.

---

## 비즈니스 로직 핵심 규칙

1. **이용시간**: 악보뷰어 실행 시 초 단위로 차감. 구독 중이면 차감 없음.
2. **광고 보상**: 하루 3회 한도, 매일 자정 초기화, 완료 시에만 10분 지급.
3. **노래 ↔ 제스처**: 동시 선택 불가 — 한쪽 선택 시 나머지 비활성.
4. **PDF 순서**: 변경 불가 (원본 순서 고정). 사진만 드래그앤드롭 허용.
5. **파일 저장**: 악보뷰어 저장 완료 시 앱 내부 저장소로 복사. 복사 실패 = 저장 실패.
6. **타임라인 없이 노래 뷰어 실행 시**: 타임라인 설정 화면으로 자동 이동.

---

## Firebase 설정 현황

- Android: `android/app/google-services.json` ✅
- iOS: `ios/Runner/GoogleService-Info.plist` ✅
- Dart options: `lib/firebase_options.dart` ✅
- `firebase_core` 의존성 추가됨 ✅
- 예정 서비스: Authentication, Firestore, Storage, Analytics, Crashlytics

---

## 설치된 Skills

### Flutter Skills (flutter/skills)

| Skill | 사용 시점 |
|---|---|
| `flutter-apply-architecture-best-practices` | feature 폴더 구조, Clean Architecture 적용 시 |
| `flutter-build-responsive-layout` | iPad/Android 태블릿 가로 레이아웃 구현 시 |
| `flutter-fix-layout-issues` | 레이아웃 오버플로, 렌더링 오류 발생 시 |
| `flutter-setup-declarative-routing` | go_router 기반 라우팅 세팅 시 |
| `flutter-implement-json-serialization` | 모델 클래스에 JSON 직렬화 추가 시 |
| `flutter-setup-localization` | 다국어(한/영) 지원 추가 시 |
| `flutter-add-widget-test` | 위젯 단위 테스트 작성 시 |
| `flutter-add-integration-test` | E2E 통합 테스트 작성 시 |
| `flutter-add-widget-preview` | 위젯 미리보기(Storybook 스타일) 추가 시 |
| `flutter-tester` | 전반적인 Flutter 테스트 실행/관리 시 |
| `flutter-use-http-package` | REST API 연동 시 |
| `owasp-mobile-security-checker` | 배포 전 모바일 보안 취약점 점검 시 |

### Firebase Skills

| Skill | 사용 시점 |
|---|---|
| `firebase:firebase-basics` | Firebase CLI 버전 확인, 초기화, 프로젝트 설정 시 |
| `firebase:firebase-auth-basics` | 소셜 로그인(Google/Apple/카카오) 구현 시 |
| `firebase:firebase-firestore` | Firestore 데이터 모델 설계, 쿼리 작성 시 **항상 먼저 실행** |
| `firebase:firebase-security-rules-auditor` | Firestore 보안 규칙 작성/변경 후 |
| `firebase:firebase-crashlytics` | Crashlytics SDK 연동 및 크래시 리포팅 설정 시 |
| `firebase:firebase-remote-config-basics` | 광고 일일 횟수, 구독 가격 등 원격 설정값 관리 시 |
| `firebase:xcode-project-setup` | iOS Swift Package 추가, Xcode 프로젝트 수정 시 |

### UI/UX Plugin (활성화됨)

| Plugin | 사용 시점 |
|---|---|
| `ui-ux-pro-max` | 디자인 방향 확인, 컴포넌트 스타일 가이드 참조 시 |

---

## 사용 가능한 주요 Agents

| Agent | 사용 시점 |
|---|---|
| `ecc:flutter-reviewer` | Flutter 코드 작성/수정 후 **항상** 리뷰 실행 |
| `ecc:dart-build-resolver` | `flutter analyze` 오류, 빌드 실패 시 |
| `ecc:security-reviewer` | 인앱 결제, 인증, 파일 접근 코드 작성 후 |
| `ecc:code-architect` | 새 feature 설계, 아키텍처 결정이 필요할 때 |
| `ecc:performance-optimizer` | 악보뷰어 실행 화면, 이미지 렌더링 성능 저하 시 |
| `ecc:database-reviewer` | Firestore 스키마 설계, 쿼리 최적화 시 |
| `ecc:a11y-architect` | 접근성 기준 준수 검토 시 |
| `ecc:docs-lookup` | Flutter/Firebase 라이브러리 API 사용법 확인 시 |

---

## 개발 워크플로우

```
기능 구현
  → /flutter-apply-architecture-best-practices (구조 확인)
  → 코드 작성
  → ecc:flutter-reviewer (코드 리뷰)
  → /flutter-add-widget-test (테스트)
  → /owasp-mobile-security-checker (보안 점검, 인증·결제 관련)
```

### 빌드 명령어

> **주의**: 실행/빌드 시 반드시 `--dart-define-from-file=secrets.json` 옵션을 붙일 것.
> `secrets.json`은 gitignore된 로컬 전용 파일. 없으면 `secrets.example.json`을 복사해서 키 입력.

```bash
# 분석
flutter analyze

# 테스트
flutter test

# iOS 실행 (iPad 시뮬레이터)
flutter run -d iPad --dart-define-from-file=secrets.json

# Android 실행
flutter run -d android --dart-define-from-file=secrets.json
flutter run -d emulator-5554 --dart-define-from-file=secrets.json

# 릴리즈 빌드
flutter build apk --release --dart-define-from-file=secrets.json
flutter build ipa --release --dart-define-from-file=secrets.json

# freezed 
dart run build_runner build --delete-conflicting-outputs

```


---

## 주의사항


- **카메라 권한**: 제스처 기능 사용 시 iOS `Info.plist`, Android `AndroidManifest.xml`에 권한 선언 필요.
- **Pretendard 폰트**: 앱 번들에 포함하거나 `google_fonts` 패키지로 대체. 라이선스: OFL(무료).
- **인앱 결제 테스트**: 실제 결제 테스트는 Google Play 내부 테스터 / TestFlight 환경에서 수행.
- **광고 테스트**: AdMob 테스트 광고 ID 사용. 실제 광고 ID는 Remote Config로 관리.
- width, height, BorderRadius.circular, EdgeInsets.symmetric 값 입력 시 Responsive.getDp(context, value) 반드시 사용하기
