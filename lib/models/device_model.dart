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

  const DeviceModel({
    required this.id,
    required this.serialNumber,
    required this.productId,
    required this.ownerUserId,
    required this.status,
    this.venueId,
    this.rentalExpiresAt,
    required this.connectedAt,
  });
}
