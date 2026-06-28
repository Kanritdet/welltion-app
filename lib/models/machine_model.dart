enum MachineStatus { available, inUse, maintenance }

class MachineModel {
  final String id;
  final String name;
  final String venueName;
  final String address;
  final MachineStatus status;
  final double distanceKm;
  final String priceInfo;

  const MachineModel({
    required this.id,
    required this.name,
    required this.venueName,
    required this.address,
    required this.status,
    required this.distanceKm,
    required this.priceInfo,
  });
}
