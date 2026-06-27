enum PlaylistType { special, healer }

class PlaylistModel {
  final String id;
  final String title;
  final String coverImage;
  final PlaylistType type;
  final String? healerId;
  final List<String> trackIds;

  const PlaylistModel({
    required this.id,
    required this.title,
    required this.coverImage,
    required this.type,
    this.healerId,
    required this.trackIds,
  });
}