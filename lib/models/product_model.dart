enum ProductCategory { singingBowl, instrument, healthDevice }

class ProductModel {
  final String id;
  final String name;
  final ProductCategory category;
  final String description;
  final double basePrice;
  final String thumbnail;

  const ProductModel({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.basePrice,
    required this.thumbnail,
  });
}
