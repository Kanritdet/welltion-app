import 'package:flutter/foundation.dart';
import '../models/cart_item_model.dart';
import '../models/mock_data.dart';
import '../services/api_service.dart';

class CartProvider extends ChangeNotifier {
  List<CartItemModel> _items = [];

  List<CartItemModel> get items => List.unmodifiable(_items);
  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);

  double get subtotal {
    double total = 0;
    for (final item in _items) {
      final variant = MockData.variantById(item.variantId);
      if (variant == null) continue;
      final product = MockData.productById(variant.productId);
      if (product == null) continue;
      total += (product.basePrice + (variant.priceAdjust ?? 0.0)) * item.quantity;
    }
    return total;
  }

  Future<void> loadCart(String userId) async {
    _items = await ApiService().getCartItems(userId);
    notifyListeners();
  }

  Future<void> addToCart({
    required String userId,
    required String variantId,
    int quantity = 1,
  }) async {
    await ApiService().addToCart(
      userId: userId,
      variantId: variantId,
      quantity: quantity,
    );
    await loadCart(userId);
  }

  Future<void> removeItem({
    required String cartItemId,
    required String userId,
  }) async {
    await ApiService().removeFromCart(cartItemId);
    await loadCart(userId);
  }

  void clear() {
    _items = [];
    notifyListeners();
  }
}
