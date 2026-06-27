class ProductVariantModel {
  final String id;
  final String productId;
  final String materialName;
  final String colorName;
  final String image;
  final double? priceAdjust;
  final String sku;

  const ProductVariantModel({
    required this.id,
    required this.productId,
    required this.materialName,
    required this.colorName,
    required this.image,
    this.priceAdjust,
    required this.sku,
  });
}
