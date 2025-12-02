class MovieModel_Febriyan {
  final String movie_id;
  final String title;
  final String poster_url;
  final int base_price;
  final double rating;
  final int duration;

  MovieModel_Febriyan({
    required this.movie_id,
    required this.title,
    required this.poster_url,
    required this.base_price,
    required this.rating,
    required this.duration,
  });

  factory MovieModel_Febriyan.fromMap(Map<String, dynamic> map, String id) {
    return MovieModel_Febriyan(
      movie_id: id,
      title: map['title'] ?? 'No Title',
      poster_url: map['poster_url'] ?? 'https://via.placeholder.com/150',
      base_price: map['base_price'] ?? 0,
      rating: (map['rating'] is int)
          ? (map['rating'] as int).toDouble()
          : (map['rating'] as double?) ?? 0.0,
      duration: map['duration'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'poster_url': poster_url,
      'base_price': base_price,
      'rating': rating,
      'duration': duration,
    };
  }
}