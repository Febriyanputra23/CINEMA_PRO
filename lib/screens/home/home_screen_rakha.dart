import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/movie_model_all_febriyan.dart';
import '../../providers/booking_provider.dart';
import '../../services/movie_service_febriyan.dart';
import '../home/movie_detail_screen_rakha.dart';
import '../auth/login_screen_rakha.dart';
import '../profile/profile_screen_anisa.dart';

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
        title: Text('CineBooking'),
        backgroundColor: Colors.blue,
        actions: [
          // Action button untuk profile
          IconButton(
            icon: Icon(Icons.person, color: Colors.white),
            onPressed: () {
              print("🎯 Navigating to profile screen...");
              Navigator.pushNamed(context, '/profile'); // ✅ Gunakan named route
            },
          ),
        ],
      ),
      drawer: _buildDrawer_Rakha(context), // Method ada di bawah
      body: Column(
        children: [
          // Header Section
          _buildHeaderSection(),

          // --- MOVIE LIST DARI SERVICE ---
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
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
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

      // --- TOMBOL TES KONEKSI (Awan Merah) ---
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        child: Icon(Icons.wifi_tethering),
        onPressed: () async {
          print(">>> MENCOBA KIRIM DATA TES...");

          try {
            // Mengirim data sederhana ke koleksi baru untuk tes
            await FirebaseFirestore.instance.collection('tes_koneksi').add({
              'waktu': DateTime.now().toString(),
              'pesan': 'Halo Firebase, Tes Koneksi Berhasil!',
            });

            print(">>> ✅ SUKSES! Data Terkirim ke 'tes_koneksi'!");
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Tes Koneksi Sukses! Cek Firebase skrg.")),
            );
          } catch (e) {
            print(">>> ❌ GAGAL: $e");
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red),
            );
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation
          .endFloat, // Pastikan tampil di kanan bawah
    );
  }

  // --- HELPER METHOD: HEADER ---
  Widget _buildHeaderSection() {
    return Container(
      padding: EdgeInsets.all(16),
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

  // --- HELPER METHOD: MOVIE CARD ---
  Widget _buildMovieCard_Rakha(
      MovieModel_Febriyan movie, BuildContext context) {
    // [Kode Movie Card seperti sebelumnya]
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
                  movie.posterior1,
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

  // --- HELPER METHOD: DRAWER ---
  Widget _buildDrawer_Rakha(BuildContext context) {
    // [Kode Drawer seperti sebelumnya]
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(child: Center(child: Text("Menu"))),
          ListTile(
            title: Text("Logout"),
            onTap: () {
              // Logika logout service bisa ditambahkan di sini
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/login');
            },
          )
        ],
      ),
    );
  }
}
