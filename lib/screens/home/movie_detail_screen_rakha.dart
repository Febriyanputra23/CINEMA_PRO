import 'package:flutter/material.dart';
import '../../models/movie_model_all_febriyan.dart';

class MovieDetailScreen_Rakha extends StatelessWidget {
  final MovieModel_Febriyan movie;

  const MovieDetailScreen_Rakha({Key? key, required this.movie})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 350,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: 'movie-${movie.movie_id}',
                child: Image.network(
                  movie.posterior1,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[300],
                      child: Center(
                        child: Icon(
                          Icons.movie,
                          size: 100,
                          color: Colors.grey[500],
                        ),
                      ),
                    );
                  },
                ),
              ),
              title: Text(
                movie.title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      color: Colors.black.withOpacity(0.8),
                      blurRadius: 10,
                    ),
                  ],
                ),
              ),
              centerTitle: true,
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Movie Title
                  Text(
                    movie.title,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[900],
                    ),
                  ),
                  SizedBox(height: 8),
                  
                  // Rating and Duration
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.amber[50],
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.amber),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.star,
                              color: Colors.amber[700],
                              size: 18,
                            ),
                            SizedBox(width: 4),
                            Text(
                              movie.rating.toStringAsFixed(1),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.amber[900],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 12),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue[50],
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.blue),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.schedule,
                              color: Colors.blue[700],
                              size: 18,
                            ),
                            SizedBox(width: 4),
                            Text(
                              '${movie.duration} min',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blue[900],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  
                  // Price Info
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.green[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.green[200]),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Base Price',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Rp ${movie.base_price}',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.green[800],
                              ),
                            ),
                          ],
                        ),
                        if (movie.title.length > 10)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'Additional Tax',
                                style: TextStyle(
                                  color: Colors.orange[700],
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Rp 2.500',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange[800],
                                ),
                              ),
                              Text(
                                '(Long Title)',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  
                  // Movie Description
                  Text(
                    'About the Movie',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[900],
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Experience the magic of cinema with "${movie.title}". '
                    'This highly-rated film (${movie.rating}/5.0) offers ${movie.duration} minutes '
                    'of unforgettable entertainment. Perfect for movie lovers of all ages.',
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.6,
                      color: Colors.grey[700],
                    ),
                  ),
                  SizedBox(height: 20),
                  
                  // Features
                  Text(
                    'Features',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[900],
                    ),
                  ),
                  SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildFeatureChip_Rakha(Icons.hd, 'HD Quality'),
                      _buildFeatureChip_Rakha(Icons.audiotrack, 'Dolby Audio'),
                      _buildFeatureChip_Rakha(Icons.airline_seat_recline_normal, 'Comfort Seats'),
                      _buildFeatureChip_Rakha(Icons.local_cafe, 'Snack Bar'),
                      _buildFeatureChip_Rakha(Icons.wheelchair_pickup, 'Accessible'),
                      _buildFeatureChip_Rakha(Icons.family_restroom, 'Family Friendly'),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        width: double.infinity,
        child: FloatingActionButton.extended(
          onPressed: () {
            // Navigate to seat selection
            // TODO: Add navigation to seat selection
          },
          icon: Icon(Icons.confirmation_number, color: Colors.white),
          label: Text(
            'BOOK TICKET NOW',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.blue,
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildFeatureChip_Rakha(IconData icon, String label) {
    return Chip(
      avatar: Icon(icon, size: 18, color: Colors.blue),
      label: Text(
        label,
        style: TextStyle(fontSize: 12),
      ),
      backgroundColor: Colors.blue[50],
      side: BorderSide(color: Colors.blue[100]!),
    );
  }
}