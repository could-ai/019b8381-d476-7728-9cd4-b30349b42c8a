class Drama {
  final String title;
  final String? posterUrl;
  final String? id;
  final String? synopsis;
  final String? status;
  final String? genres;

  Drama({
    required this.title,
    this.posterUrl,
    this.id,
    this.synopsis,
    this.status,
    this.genres,
  });

  factory Drama.fromJson(Map<String, dynamic> json) {
    return Drama(
      title: json['title'] ?? 'Unknown Title',
      posterUrl: json['thumbnail'] ?? json['poster'] ?? 'https://via.placeholder.com/300x450?text=No+Image',
      id: json['id']?.toString() ?? json['url'], // Some APIs use URL as ID
      synopsis: json['synopsis'] ?? 'No synopsis available.',
      status: json['status'],
      genres: json['genres'],
    );
  }
}

class Episode {
  final String title;
  final String id; // or url
  final String? date;

  Episode({
    required this.title,
    required this.id,
    this.date,
  });

  factory Episode.fromJson(Map<String, dynamic> json) {
    return Episode(
      title: json['title'] ?? 'Episode',
      id: json['id'] ?? json['url'] ?? '',
      date: json['date'],
    );
  }
}
