class PlaylistItem {
  final String id;
  final String title;
  final String description;
  final String thumbnailUrl;
  final String playlistId;
  final String videoId;

  PlaylistItem({
    required this.id,
    required this.title,
    required this.description,
    required this.thumbnailUrl,
    required this.playlistId,
    required this.videoId,
  });

  factory PlaylistItem.fromMap(Map<String, dynamic> snippet) {
    return PlaylistItem(
      id: snippet['id'],
      title: snippet['snippet']['title'],
      description: snippet['snippet']['description'],
      thumbnailUrl: snippet['snippet']['thumbnails']['high']['url'],
      playlistId: snippet['snippet']['playlistId'],
      videoId: snippet['snippet']['resourceId']['videoId'],
    );
  }
}
