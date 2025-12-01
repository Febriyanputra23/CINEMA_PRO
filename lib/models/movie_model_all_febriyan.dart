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

  // PERUBAHAN DISINI: Tambahkan parameter 'String id'
  factory MovieModel_Febriyan.fromMap(Map<String, dynamic> map, String id) {
    return MovieModel_Febriyan(
      movie_id: id, // Pakai ID dari dokumen Firestore
      title: map['title'] ?? 'No Title',
      posterior1: map['posterior1'] ?? 'https://via.placeholder.com/150',
      base_price: map['base_price'] ?? 0,
      // Konversi aman untuk rating (bisa int atau double)
      rating: (map['rating'] is int)
          ? (map['rating'] as int).toDouble()
          : (map['rating'] as double?) ?? 0.0,
      duration: map['duration'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'posterior1': posterior1,
      'base_price': base_price,
      'rating': rating,
      'duration': duration,
    };
  }
}