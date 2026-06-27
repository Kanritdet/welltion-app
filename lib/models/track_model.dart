class TrackModel {
  final String id;
  final String title;
  final String coverImage;
  final int durationSeconds;
  final String audioUrl;
  final String? modeId;
  final String? healerId;
  final double? frequencyHz;

  const TrackModel({
    required this.id,
    required this.title,
    required this.coverImage,
    required this.durationSeconds,
    required this.audioUrl,
    this.modeId,
    this.healerId,
    this.frequencyHz,
  });
}
