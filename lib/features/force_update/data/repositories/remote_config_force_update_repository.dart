import 'dart:io';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../../core/utils/app_logger.dart';
import '../../../../core/utils/version_compare.dart';
import '../../domain/models/force_update_info.dart';
import '../../domain/repositories/force_update_repository.dart';

class RemoteConfigForceUpdateRepository implements ForceUpdateRepository {
  static const _defaultMessage =
      '새로운 버전이 출시되었습니다.\n원활한 이용을 위해 업데이트해주세요.';

  static const _notRequired = ForceUpdateInfo(
    isRequired: false,
    message: _defaultMessage,
    storeUrl: '',
  );

  @override
  Future<ForceUpdateInfo> check() async {
    // 이 메서드는 실패해서는 안 됨: 어떤 예외든 사용자를 영구히 막지 않도록
    // 항상 안전한 기본값(강제 업데이트 없음)으로 fail-open 한다.
    try {
      final remoteConfig = FirebaseRemoteConfig.instance;
      await remoteConfig.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(seconds: 10),
          minimumFetchInterval: const Duration(hours: 1),
        ),
      );
      await remoteConfig.setDefaults(const {
        'min_supported_version_android': '0.0.0',
        'min_supported_version_ios': '0.0.0',
        'force_update_message': _defaultMessage,
        'android_store_url': '',
        'ios_store_url': '',
      });

      try {
        await remoteConfig.fetchAndActivate();
      } catch (e, st) {
        // 네트워크 실패 시 캐시(또는 기본값)로 계속 진행 — 강제 업데이트 체크가
        // 오프라인 사용을 막아서는 안 됨.
        appLogger.w('Remote Config fetchAndActivate 실패, 캐시값 사용', error: e, stackTrace: st);
      }

      final minVersion = Platform.isIOS
          ? remoteConfig.getString('min_supported_version_ios')
          : remoteConfig.getString('min_supported_version_android');
      final storeUrl = Platform.isIOS
          ? remoteConfig.getString('ios_store_url')
          : remoteConfig.getString('android_store_url');

      final packageInfo = await PackageInfo.fromPlatform();
      final isRequired = storeUrl.isNotEmpty &&
          isVersionBelow(packageInfo.version, minVersion);

      return ForceUpdateInfo(
        isRequired: isRequired,
        message: remoteConfig.getString('force_update_message'),
        storeUrl: storeUrl,
      );
    } catch (e, st) {
      appLogger.e('강제 업데이트 확인 실패, 강제 업데이트 없이 진행', error: e, stackTrace: st);
      return _notRequired;
    }
  }
}
