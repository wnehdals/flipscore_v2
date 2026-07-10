class ForceUpdateInfo {
  const ForceUpdateInfo({
    required this.isRequired,
    required this.message,
    required this.storeUrl,
  });

  final bool isRequired;
  final String message;
  final String storeUrl;
}
