class SingleVideo {
  final String id;
  final String title;
  final String channelTitle;
  final String description;
  final String publishedAt;
  final String views;

  SingleVideo({
    required this.id,
    required this.title,
    required this.channelTitle,
    required this.description,
    required this.publishedAt,
    required this.views,
  });

  factory SingleVideo.fromMap(Map<String, dynamic> snippet) {
    return SingleVideo(
      id: snippet['id'],
      title: snippet['snippet']['title'],
      channelTitle: snippet['snippet']['channelTitle'],
      description: snippet['snippet']['description'],
      publishedAt: snippet['snippet']['publishedAt'],
      views: snippet['statistics']['viewCount'],
    );
  }
}
