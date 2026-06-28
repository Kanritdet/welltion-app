enum NotifType { booking, payment, cancellation, system }

class NotificationModel {
  final String id;
  final NotifType type;
  final String title;
  final String body;
  final String timestamp;
  bool isRead;

  NotificationModel({
    required this.id,
    required this.type,
    required this.title,
    required this.body,
    required this.timestamp,
    this.isRead = false,
  });
}
