// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'usage_time_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$usageTimeRepositoryHash() =>
    r'0029dda79445ed984fee8184649426046ab71594';

/// See also [usageTimeRepository].
@ProviderFor(usageTimeRepository)
final usageTimeRepositoryProvider = Provider<UsageTimeRepository>.internal(
  usageTimeRepository,
  name: r'usageTimeRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$usageTimeRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef UsageTimeRepositoryRef = ProviderRef<UsageTimeRepository>;
String _$currentUsageTimeHash() => r'cd90a449bf563ef7da7b1883dd48434cccba9f71';

/// See also [currentUsageTime].
@ProviderFor(currentUsageTime)
final currentUsageTimeProvider = AutoDisposeStreamProvider<UsageTime?>.internal(
  currentUsageTime,
  name: r'currentUsageTimeProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currentUsageTimeHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CurrentUsageTimeRef = AutoDisposeStreamProviderRef<UsageTime?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
