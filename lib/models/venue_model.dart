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
  final double rating;
  final int reviewCount;
  final double distanceKm;
  final String description;
  // key = duration in minutes (30/45/60), value = price in THB
  final Map<int, int> sessionPricing;

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
    this.rating = 0.0,
    this.reviewCount = 0,
    this.distanceKm = 0.0,
    this.description = '',
    this.sessionPricing = const {},
  });
}