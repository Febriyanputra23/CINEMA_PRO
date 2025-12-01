import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/booking_provider.dart';
import '../../models/movie_model_all_febriyan.dart';
import '../home/movie_detail_screen_rakha.dart';

class HomeScreen_Rakha extends StatefulWidget {
  @override
  _HomeScreen_RakhaState createState() => _HomeScreen_RakhaState();
}

class _HomeScreen_RakhaState extends State<HomeScreen_Rakha> {
  // Data dummy movie untuk sementara (jika Firebase belum siap)
  List<MovieModel_Febriyan> dummyMovies_Rakha = [
    MovieModel_Febriyan(
      movie_id: "1",
      title: "Avatar",
      posterior1: "https://via.placeholder.com/300x450/007BFF/FFFFFF?text=Avatar",
      base_price: 35000,
      rating: 4.5,
      duration: 162,
    ),
    MovieModel_Febriyan(
      movie_id: "2",
      title: "Spider-Man: No Way Home",
      posterior1: "https://via.placeholder.com/300x450/DC3545/FFFFFF?text=Spider-Man",
      base_price: 40000,
      rating: 4.8,
      duration: 148,
    ),
    MovieModel_Febriyan(
      movie_id: "3",
      title: "Titanic",
      posterior1: "https://via.placeholder.com/300x450/28A745/FFFFFF?text=Titanic",
      base_price: 30000,
      rating: 4.7,
      duration: 195,
    ),
    MovieModel_Febriyan(
      movie_id: "4",
      title: "The Avengers: Endgame",
      posterior1: "https://via.placeholder.com/300x450/FF6B6B/FFFFFF?text=Avengers",
      base_price: 45000,
      rating: 4.9,
      duration: 181,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.movie, color: Colors.white),
            SizedBox(width: 8),
            Text(
              'CineBooking',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.white,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.blue,
        elevation: 4,
        actions: [
          IconButton(
            icon: Icon(Icons.person, color: Colors.white),
            onPressed: () {
              // Navigate to profile screen menggunakan named route
              Navigator.pushNamed(context, '/profile');
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Header Section
          Container(
            padding: EdgeInsets.all(16),
            color: Colors.blue[50],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome to CineBooking!',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[900],
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Book your favorite movies easily',
                  style: TextStyle(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          
          // Movies Grid
          Expanded(
            child: Consumer<BookingProvider_Tio>(
              builder: (context, bookingProvider, child) {
                // Gunakan data dari provider jika ada, jika tidak gunakan dummy data
                List<MovieModel_Febriyan> movies;
                
                // Coba ambil data dari provider terlebih dahulu
                try {
                  movies = bookingProvider.getDummyMovies_Tio();
                } catch (e) {
                  movies = dummyMovies_Rakha; // Fallback ke dummy data
                }
                
                return Padding(
                  padding: EdgeInsets.all(12),
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: _getCrossAxisCount_Rakha(context),
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.65,
                    ),
                    itemCount: movies.length,
                    itemBuilder: (context, index) {
                      final movie = movies[index];
                      return _buildMovieCard_Rakha(movie, context, bookingProvider);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  int _getCrossAxisCount_Rakha(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 800) return 4;
    if (width > 600) return 3;
    if (width > 400) return 2;
    return 1;
  }

  Widget _buildMovieCard_Rakha(
    MovieModel_Febriyan movie, 
    BuildContext context,
    BookingProvider_Tio bookingProvider
  ) {
    return Hero(
      tag: 'movie-${movie.movie_id}',
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: InkWell(
          onTap: () {
            // Simpan movie yang dipilih ke provider (untuk logic trap)
            bookingProvider.setSelectedMovie_Tio(movie);
            
            // Navigasi ke detail screen
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MovieDetailScreen_Rakha(movie: movie),
              ),
            );
          },
          borderRadius: BorderRadius.circular(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Movie Poster
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                child: Container(
                  height: 180,
                  color: Colors.grey[200],
                  child: Image.network(
                    movie.posterior1,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[300],
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.movie,
                                size: 50,
                                color: Colors.grey[500],
                              ),
                              SizedBox(height: 8),
                              Text(
                                movie.title,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              
              // Movie Info
              Padding(
                padding: EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      movie.title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 8),
                    
                    Row(
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.star,
                              color: Colors.amber,
                              size: 16,
                            ),
                            SizedBox(width: 4),
                            Text(
                              movie.rating.toStringAsFixed(1),
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        Spacer(),
                        Row(
                          children: [
                            Icon(
                              Icons.schedule,
                              color: Colors.blue,
                              size: 16,
                            ),
                            SizedBox(width: 4),
                            Text(
                              '${movie.duration} min',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    
                    Divider(height: 1, color: Colors.grey[300]),
                    SizedBox(height: 8),
                    
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Price',
                          style: TextStyle(
                            color: Colors.grey[600],
                          ),
                        ),
                        Text(
                          'Rp ${movie.base_price}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.green[700],
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    
                    if (movie.title.length > 10)
                      Container(
                        margin: EdgeInsets.only(top: 8),
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.orange[50],
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: Colors.orange[200]!,
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: Colors.orange[700],
                              size: 12,
                            ),
                            SizedBox(width: 4),
                            Text(
                              '+Rp 2.500 tax',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.orange[700],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}