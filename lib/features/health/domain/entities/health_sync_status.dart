/// Status representing the current state of Health synchronization.
enum HealthSyncStatus {
  /// Health sync toggle is disabled by the user.
  disabled,

  /// Currently requesting authorization or fetching data.
  syncing,

  /// Successfully authorized and synced with Apple Health / Health Connect.
  authorized,

  /// User explicitly denied permission to read health data.
  permissionDenied,

  /// User previously authorized, but permission was later revoked in device settings.
  permissionRevoked,

  /// HealthKit or Health Connect is not supported or not installed on this device.
  notSupported,

  /// Authorization granted, but no activity/calorie data found for today.
  noData,

  /// An error occurred during connection or data reading.
  readError;

  bool get isConnected => this == HealthSyncStatus.authorized;
  bool get isError =>
      this == HealthSyncStatus.permissionDenied ||
      this == HealthSyncStatus.permissionRevoked ||
      this == HealthSyncStatus.notSupported ||
      this == HealthSyncStatus.readError;
}
