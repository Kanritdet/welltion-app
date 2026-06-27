enum RentalOption { daily, session }

class VenueModel {
  final String id;
  final String name;
  final String address;
  final double lat;
  final double lng;
  final List<String> photos;
  final List<String> amenities;
  final String priceInfo;
  final List<RentalOption> rentalOptions;
  final String openingHours;

  const VenueModel({
    required this.id,
    required this.name,
    required this.address,
    required this.lat,
    required this.lng,
    required this.photos,
    required this.amenities,
    required this.priceInfo,
    required this.rentalOptions,
    required this.openingHours,
  });
}