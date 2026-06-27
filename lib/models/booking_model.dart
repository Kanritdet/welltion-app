enum BookingRentalType { daily, session }

enum BookingStatus { pending, confirmed, cancelled, completed }

class BookingModel {
  final String id;
  final String userId;
  final String venueId;
  final String? healerId;
  final DateTime date;
  final String startTime;
  final int durationMinutes;
  final BookingRentalType rentalType;
  final double price;
  final BookingStatus status;

  const BookingModel({
    required this.id,
    required this.userId,
    required this.venueId,
    this.healerId,
    required this.date,
    required this.startTime,
    required this.durationMinutes,
    required this.rentalType,
    required this.price,
    required this.status,
  });
}
