enum DeviceStatus { owned, rented }

class DeviceModel {
  final String id;
  final String serialNumber;
  final String productId;
  final String ownerUserId;
  final DeviceStatus status;
  final String? venueId;
  final DateTime? rentalExpiresAt;
  final DateTime connectedAt;
  final String customName;
  final String modelName;
  final String firmwareVersion;
  final bool isOnline;
  final int batteryPercent;
  final DateTime? lastUsedAt;

  const DeviceModel({
    required this.id,
    required this.serialNumber,
    required this.productId,
    required this.ownerUserId,
    required this.status,
    this.venueId,
    this.rentalExpiresAt,
    required this.connectedAt,
    this.customName = '',
    this.modelName = 'WeLLzen Classic',
    this.firmwareVersion = 'v2.4.1',
    this.isOnline = false,
    this.batteryPercent = 50,
    this.lastUsedAt,
  });
}
