class HealerService {
  const HealerService({required this.name, required this.price, required this.durationMin});
  final String name;
  final double price;
  final int durationMin;
}

class HealerModel {
  final String id;
  final String name;
  final String photo;
  final String bio;
  final List<String> specialties;
  final List<String> serviceVenueIds;
  final double rating;
  final int yearsExp;
  final int followerCount;
  final List<HealerService> services;
  final String? line;
  final String? phone;
  final String? instagram;

  const HealerModel({
    required this.id,
    required this.name,
    required this.photo,
    required this.bio,
    required this.specialties,
    required this.serviceVenueIds,
    this.rating = 4.8,
    this.yearsExp = 10,
    this.followerCount = 1000,
    this.services = const [],
    this.line,
    this.phone,
    this.instagram,
  });
}
