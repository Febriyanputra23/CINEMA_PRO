import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/booking_provider.dart';
import '../seat/seat_selection_screen_anisa.dart';
import '../../models/movie_model_all_febriyan.dart';

class MovieDetailScreen_Rakha extends StatelessWidget {
  final MovieModel_Febriyan movie;

  const MovieDetailScreen_Rakha({Key? key, required this.movie})
      : super(key: key);

  void _bookTicket(BuildContext context) {
    try {
      Provider.of<BookingProvider_Tio>(context, listen: false)
          .setSelectedMovie_Tio(movie);
          
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SeatSelectionScreen_Anisa(),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: ${e.toString()}"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: 'movie-${movie.movie_id}',
                child: Image.network(
                  movie.poster_url,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[300],
                      child: Icon(Icons.movie, size: 100, color: Colors.grey),
                    );
                  },
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movie.title,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber),
                      SizedBox(width: 4),
                      Text(movie.rating.toStringAsFixed(1)),
                      SizedBox(width: 16),
                      Icon(Icons.schedule),
                      SizedBox(width: 4),
                      Text('${movie.duration} min'),
                    ],
                  ),
                  SizedBox(height: 16),
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.green[50],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Rp ${movie.base_price}',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.green[800],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'About the Movie',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Experience the magic of cinema with "${movie.title}". '
                    'This highly-rated film offers ${movie.duration} minutes '
                    'of unforgettable entertainment.',
                    style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _bookTicket(context),
        icon: Icon(Icons.confirmation_number),
        label: Text('BOOK TICKET'),
        backgroundColor: Colors.blue,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}