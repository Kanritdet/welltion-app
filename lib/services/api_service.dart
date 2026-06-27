import '../models/mock_data.dart';
import '../models/user_model.dart';
import '../models/product_model.dart';
import '../models/product_variant_model.dart';
import '../models/device_model.dart';
import '../models/track_model.dart';
import '../models/healer_model.dart';
import '../models/playlist_model.dart';
import '../models/venue_model.dart';
import '../models/booking_model.dart';
import '../models/order_model.dart';
import '../models/cart_item_model.dart';
import '../models/biometric_session_model.dart';
import '../models/mode_model.dart';

/// Stub service layer — ตอนนี้ return mock data
/// Back-end engineer: แทนที่ body ของแต่ละ method ด้วย http call โดยไม่ต้องแก้ signature
class ApiService {
  // Singleton — ใช้ ApiService() ได้ทุกที่โดยไม่ต้อง new
  ApiService._();
  static final ApiService instance = ApiService._();
  factory ApiService() => instance;

  // ─────────────────────────────────────────
  // AUTH
  // ─────────────────────────────────────────

  Future<UserModel> getCurrentUser() async => MockData.currentUser;

  Future<UserModel> login({
    required String email,
    required String password,
  }) async => MockData.currentUser;

  Future<void> logout() async {}

  // ─────────────────────────────────────────
  // MODES
  // ─────────────────────────────────────────

  Future<List<ModeModel>> getModes() async => MockData.modes;

  // ─────────────────────────────────────────
  // PRODUCTS
  // ─────────────────────────────────────────

  Future<List<ProductModel>> getProducts() async => MockData.products;

  Future<ProductModel?> getProductById(String id) async =>
      MockData.productById(id);

  Future<List<ProductVariantModel>> getVariantsByProduct(
    String productId,
  ) async => MockData.variantsByProduct(productId);

  // ─────────────────────────────────────────
  // DEVICES
  // ─────────────────────────────────────────

  Future<List<DeviceModel>> getUserDevices(String userId) async =>
      MockData.devices.where((d) => d.ownerUserId == userId).toList();

  Future<void> addDevice({
    required String serialNumber,
    required String productId,
    required String ownerUserId,
  }) async {}

  Future<void> removeDevice(String deviceId) async {}

  // ─────────────────────────────────────────
  // VENUES
  // ─────────────────────────────────────────

  Future<List<VenueModel>> getVenues() async => MockData.venues;

  Future<VenueModel?> getVenueById(String id) async =>
      MockData.venueById(id);

  // ─────────────────────────────────────────
  // HEALERS
  // ─────────────────────────────────────────

  Future<List<HealerModel>> getHealers() async => MockData.healers;

  Future<HealerModel?> getHealerById(String id) async =>
      MockData.healerById(id);

  Future<List<HealerModel>> getHealersByVenue(String venueId) async =>
      MockData.healers
          .where((h) => h.serviceVenueIds.contains(venueId))
          .toList();

  // ─────────────────────────────────────────
  // TRACKS & PLAYLISTS
  // ─────────────────────────────────────────

  Future<List<TrackModel>> getTracks() async => MockData.tracks;

  Future<List<PlaylistModel>> getPlaylists() async => MockData.playlists;

  Future<List<TrackModel>> getTracksByPlaylist(PlaylistModel playlist) async =>
      MockData.tracksByPlaylist(playlist);

  // ─────────────────────────────────────────
  // BOOKINGS
  // ─────────────────────────────────────────

  Future<List<BookingModel>> getUserBookings(String userId) async =>
      MockData.bookingsByUser(userId);

  Future<BookingModel> createBooking({
    required String userId,
    required String venueId,
    String? healerId,
    required DateTime date,
    required String startTime,
    required int durationMinutes,
    required BookingRentalType rentalType,
    required double price,
  }) async {
    return BookingModel(
      id: 'b_new_${DateTime.now().millisecondsSinceEpoch}',
      userId: userId,
      venueId: venueId,
      healerId: healerId,
      date: date,
      startTime: startTime,
      durationMinutes: durationMinutes,
      rentalType: rentalType,
      price: price,
      status: BookingStatus.pending,
    );
  }

  Future<void> cancelBooking(String bookingId) async {}

  // ─────────────────────────────────────────
  // ORDERS & CART
  // ─────────────────────────────────────────

  Future<List<OrderModel>> getUserOrders(String userId) async =>
      MockData.orders.where((o) => o.userId == userId).toList();

  Future<List<CartItemModel>> getCartItems(String userId) async =>
      MockData.cartItems.where((c) => c.userId == userId).toList();

  Future<void> addToCart({
    required String userId,
    required String variantId,
    required int quantity,
  }) async {}

  Future<void> removeFromCart(String cartItemId) async {}

  Future<void> updateCartQuantity({
    required String cartItemId,
    required int quantity,
  }) async {}

  Future<OrderModel> checkout({
    required String userId,
    required List<CartItemModel> items,
    required String shippingAddress,
  }) async {
    return MockData.orders[0];
  }

  // ─────────────────────────────────────────
  // BIOMETRICS
  // ─────────────────────────────────────────

  Future<List<BiometricSessionModel>> getBiometricSessions(
    String userId,
  ) async =>
      MockData.biometricSessions.where((b) => b.userId == userId).toList();

  Future<BiometricSessionModel?> getLatestBiometricSession(
    String userId,
  ) async =>
      MockData.biometricSessions
          .where((b) => b.userId == userId)
          .lastOrNull;
}
