import 'order_item_model.dart';

enum OrderStatus { pending, paid, shipped, delivered, cancelled }

class OrderModel {
  final String id;
  final String userId;
  final List<OrderItemModel> items;
  final double subtotal;
  final double shippingFee;
  final double total;
  final OrderStatus status;
  final String shippingAddress;
  final DateTime createdAt;

  const OrderModel({
    required this.id,
    required this.userId,
    required this.items,
    required this.subtotal,
    required this.shippingFee,
    required this.total,
    required this.status,
    required this.shippingAddress,
    required this.createdAt,
  });
}
