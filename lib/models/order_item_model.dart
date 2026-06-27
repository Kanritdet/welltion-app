class OrderItemModel {
  final String id;
  final String orderId;
  final String variantId;
  final int quantity;
  final double unitPrice;

  const OrderItemModel({
    required this.id,
    required this.orderId,
    required this.variantId,
    required this.quantity,
    required this.unitPrice,
  });
}
