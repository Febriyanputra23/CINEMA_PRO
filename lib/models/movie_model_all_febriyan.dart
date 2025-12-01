class MovieModel_Febriyan {
  final String movie_id;
  final String title;
  final String posterior1;
  final int base_price;
  final double rating;
  final int duration;

  MovieModel_Febriyan({
    required this.movie_id,
    required this.title,
    required this.posterior1,
    required this.base_price,
    required this.rating,
    required this.duration,
  });

  factory MovieModel_Febriyan.fromMap(Map<String, dynamic> map) {
    return MovieModel_Febriyan(
      movie_id: map['movie_id'] ?? '',
      title: map['title'] ?? '',
      posterior1: map['posterior1'] ?? '',
      base_price: map['base_price'] ?? 0,
      rating: (map['rating'] is int)
          ? (map['rating'] as int).toDouble()
          : map['rating']?.toDouble() ?? 0.0,
      duration: map['duration'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'movie_id': movie_id,
      'title': title,
      'posterior1': posterior1,
      'base_price': base_price,
      'rating': rating,
      'duration': duration,
    };
  }
}
