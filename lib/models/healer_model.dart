class HealerModel {
  final String id;
  final String name;
  final String photo;
  final String bio;
  final List<String> specialties;
  final List<String> serviceVenueIds;

  const HealerModel({
    required this.id,
    required this.name,
    required this.photo,
    required this.bio,
    required this.specialties,
    required this.serviceVenueIds,
  });
}
