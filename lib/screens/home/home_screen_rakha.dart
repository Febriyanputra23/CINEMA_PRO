import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/movie_model_all_febriyan.dart';
import '../../services/movie_service_febriyan.dart';
import '../home/movie_detail_screen_rakha.dart';
import '../auth/login_screen_rakha.dart';

class HomeScreen_Rakha extends StatefulWidget {
  @override
  _HomeScreen_RakhaState createState() => _HomeScreen_RakhaState();
}

class _HomeScreen_RakhaState extends State<HomeScreen_Rakha> {
  final FirebaseService_Febriyan _movieService = FirebaseService_Febriyan();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CineBooking'),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: Icon(Icons.person, color: Colors.white),
            onPressed: () {
              print("🎯 Navigating to profile screen...");
              Navigator.pushNamed(context, '/profile');
            },
          ),
        ],
      ),
      drawer: _buildDrawer_Rakha(context),
      body: Column(
        children: [
          _buildHeaderSection(),
          Expanded(
            child: StreamBuilder<List<MovieModel_Febriyan>>(
              stream: _movieService.getMovies_Febriyan(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(
                      child: Text("Error loading movies: ${snapshot.error}"));
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.movie_filter, size: 60, color: Colors.grey),
                        SizedBox(height: 10),
                        Text("Belum ada film di Database"),
                        SizedBox(height: 10),
                      ],
                    ),
                  );
                }

                final movies = snapshot.data!;

                return GridView.builder(
                  padding: EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.7,
                  ),
                  itemCount: movies.length,
                  itemBuilder: (context, index) {
                    final movie = movies[index];
                    return _buildMovieCard_Rakha(movie, context);
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildHeaderSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.blue[50],
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Welcome!',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[900])),
          Text('Book your favorite movies easily',
              style: TextStyle(color: Colors.grey[600])),
        ],
      ),
    );
  }

  Widget _buildMovieCard_Rakha(
      MovieModel_Febriyan movie, BuildContext context) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MovieDetailScreen_Rakha(movie: movie),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                child: Image.network(
                  movie.poster_url,
                  fit: BoxFit.cover,
                  errorBuilder: (ctx, err, stack) =>
                      Center(child: Icon(Icons.error)),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(movie.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text("Rp ${movie.base_price}",
                      style: TextStyle(color: Colors.green)),
                  Row(children: [
                    Icon(Icons.star, size: 14, color: Colors.amber),
                    Text(" ${movie.rating}")
                  ]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawer_Rakha(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(child: Center(child: Text("Menu"))),
          ListTile(
            title: Text("Logout"),
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pop(context);
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen_Rakha()),
                  (route) => false);
            },
          )
        ],
      ),
    );
  }
}