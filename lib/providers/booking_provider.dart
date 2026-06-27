import 'package:flutter/foundation.dart';
import '../models/booking_model.dart';
import '../services/api_service.dart';

class BookingProvider extends ChangeNotifier {
  List<BookingModel> _bookings = [];

  List<BookingModel> get bookings => List.unmodifiable(_bookings);

  List<BookingModel> get upcoming => _bookings
      .where(
        (b) =>
            b.status == BookingStatus.confirmed &&
            b.date.isAfter(DateTime.now()),
      )
      .toList();

  List<BookingModel> get pending =>
      _bookings.where((b) => b.status == BookingStatus.pending).toList();

  Future<void> loadBookings(String userId) async {
    _bookings = await ApiService().getUserBookings(userId);
    notifyListeners();
  }

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
    final booking = await ApiService().createBooking(
      userId: userId,
      venueId: venueId,
      healerId: healerId,
      date: date,
      startTime: startTime,
      durationMinutes: durationMinutes,
      rentalType: rentalType,
      price: price,
    );
    _bookings = [..._bookings, booking];
    notifyListeners();
    return booking;
  }

  Future<void> cancelBooking(String bookingId) async {
    await ApiService().cancelBooking(bookingId);
    _bookings = _bookings.map((b) {
      if (b.id != bookingId) return b;
      return BookingModel(
        id: b.id,
        userId: b.userId,
        venueId: b.venueId,
        healerId: b.healerId,
        date: b.date,
        startTime: b.startTime,
        durationMinutes: b.durationMinutes,
        rentalType: b.rentalType,
        price: b.price,
        status: BookingStatus.cancelled,
      );
    }).toList();
    notifyListeners();
  }
}