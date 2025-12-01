import 'package:cinema_pro/models/movie_model_all_febriyan.dart';
import 'package:flutter/material.dart';
import '../models/movie_model_all_febriyan.dart';

class BookingProvider_Tio with ChangeNotifier {
  // ==================== STATE VARIABLES ====================
  List<String> _selectedSeats = [];
  MovieModel_Febriyan? _selectedMovie;
  int _totalPrice = 0;

  // ==================== GETTERS ====================
  List<String> get selectedSeats => _selectedSeats;
  MovieModel_Febriyan? get selectedMovie => _selectedMovie;
  int get totalPrice => _totalPrice;

  // ==================== MOVIE METHODS ====================
  void setSelectedMovie_Tio(MovieModel_Febriyan movie) {
    _selectedMovie = movie;
    _calculateTotalPrice_Tio();
    notifyListeners();
  }

  // ==================== SEAT METHODS ====================
  void toggleSeat_Tio(String seatNumber) {
    if (_selectedSeats.contains(seatNumber)) {
      _selectedSeats.remove(seatNumber);
    } else {
      _selectedSeats.add(seatNumber);
    }
    _calculateTotalPrice_Tio();
    notifyListeners();
  }

  void clearSeats_Tio() {
    _selectedSeats.clear();
    _calculateTotalPrice_Tio();
    notifyListeners();
  }

  // ==================== PRICE CALCULATION (LOGIC TRAP) ====================
  void _calculateTotalPrice_Tio() {
    if (_selectedMovie == null) {
      _totalPrice = 0;
      return;
    }

    int total = 0;
    int basePrice = _selectedMovie!.base_price;

    // LOGIC TRAP 1: Long Title Tax
    int titleTax = _selectedMovie!.title.length > 10 ? 2500 : 0;

    // LOGIC TRAP 2: Odd/Even Seat Rule (Manual Calculation)
    for (String seat in _selectedSeats) {
      String seatNumberStr = seat.substring(1); // Remove letter (A1 → "1")
      int seatNumber = int.tryParse(seatNumberStr) ?? 0;

      int seatPrice = basePrice + titleTax;

      if (seatNumber % 2 == 0) {
        // Even seat number - 10% discount (Manual calculation)
        seatPrice = (seatPrice * 0.9).round(); // Tidak pakai library
      }
      // Odd seat number - normal price

      total += seatPrice;
    }

    _totalPrice = total;
  }

  // ==================== DUMMY DATA FOR TESTING ====================
  List<MovieModel_Febriyan> getDummyMovies_Tio() {
    return [
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
        posterior1: "https://via.placeholder.com/300x450/FFC107/000000?text=Avengers",
        base_price: 45000,
        rating: 4.9,
        duration: 181,
      ),
      MovieModel_Febriyan(
        movie_id: "5",
        title: "Inception",
        posterior1: "https://via.placeholder.com/300x450/9C27B0/FFFFFF?text=Inception",
        base_price: 38000,
        rating: 4.8,
        duration: 148,
      ),
    ];
  }

  // ==================== CHECKOUT METHOD ====================
  Future<void> checkout_Tio(String userId) async {
    if (_selectedMovie == null) {
      throw 'No movie selected';
    }

    if (_selectedSeats.isEmpty) {
      throw 'No seats selected';
    }

    // Simulate API call
    await Future.delayed(Duration(seconds: 2));

    // Clear selection after successful checkout
    _selectedSeats.clear();
    _selectedMovie = null;
    _totalPrice = 0;
    notifyListeners();
  }

  // ==================== ROUTING METHODS ====================
  void navigateToSeatSelection_Tio(BuildContext context, MovieModel_Febriyan movie) {
    setSelectedMovie_Tio(movie);
    Navigator.pushNamed(context, '/seat');
  }

  void navigateToProfile_Tio(BuildContext context) {
    Navigator.pushNamed(context, '/profile');
  }

  // ==================== MANUAL CALCULATION FOR TESTING ====================
  int calculateSeatPriceManual_Tio(String seatNumber, int basePrice, int titleTax) {
    String seatNumberStr = seatNumber.substring(1);
    int seatNumberInt = int.tryParse(seatNumberStr) ?? 0;
    
    int price = basePrice + titleTax;
    
    if (seatNumberInt % 2 == 0) {
      price = (price * 0.9).round(); // Manual discount calculation
    }
    
    return price;
  }

  // ==================== RESET METHOD ====================
  void resetAll_Tio() {
    _selectedSeats.clear();
    _selectedMovie = null;
    _totalPrice = 0;
    notifyListeners();
  }
}