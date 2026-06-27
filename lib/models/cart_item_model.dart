class CartItemModel {
  final String id;
  final String userId;
  final String variantId;
  final int quantity;

  const CartItemModel({
    required this.id,
    required this.userId,
    required this.variantId,
    required this.quantity,
  });
}
