class Playlist {
  final String id;
  final String title;
  final String description;
  final String thumbnailUrl;

  Playlist({
    required this.id,
    required this.title,
    required this.description,
    required this.thumbnailUrl,
  });

  factory Playlist.fromMap(Map<String, dynamic> snippet) {
    return Playlist(
      id: snippet['id'],
      title: snippet['snippet']['title'],
      description: snippet['snippet']['description'],
      thumbnailUrl: snippet['snippet']['thumbnails']['high']['url'],
    );
  }
}
