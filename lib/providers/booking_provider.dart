import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/movie_model_all_febriyan.dart';
import '../models/booking_model_febriyan.dart';
import '../services/movie_service_febriyan.dart';
import '../utils/logic_trap_utils_tio.dart';
class BookingProvider_Tio with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
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

  // ==================== LOGIC TRAP IMPLEMENTATION ====================
void _calculateTotalPrice_Tio() {
  if (_selectedMovie == null) {
    _totalPrice = 0;
    return;
  }

  // Gunakan fungsi manual dari LogicTrapUtils_Tio
  _totalPrice = LogicTrapUtils_Tio.calculateTotalPriceManual_Tio(
    movieTitle: _selectedMovie!.title,
    basePrice: _selectedMovie!.base_price,
    selectedSeats: _selectedSeats,
  );
  
  notifyListeners();
}

  // Fungsi manual untuk parse angka dari string
  int _parseSeatNumber_Tio(String seatNumberStr) {
    try {
      return int.parse(seatNumberStr);
    } catch (e) {
      return 0;
    }
  }

  // Fungsi manual untuk hitung diskon (TIDAK pakai library)
  int _calculateDiscount_Tio(int price, int discountPercent) {
    double discountMultiplier = (100 - discountPercent) / 100;
    return (price * discountMultiplier).round();
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

  // ==================== CHECKOUT METHOD (INTEGRASI FIREBASE) ====================
  Future<void> checkout_Tio(String userId) async {
    try {
      // Validasi data
      if (_selectedMovie == null) {
        throw 'No movie selected';
      }
      if (_selectedSeats.isEmpty) {
        throw 'No seats selected';
      }

      // Generate booking ID
      String bookingId = 'BOOK_${DateTime.now().millisecondsSinceEpoch}';

      // Create booking data sesuai struktur Firestore
      Map<String, dynamic> bookingData = {
        'booking_id': bookingId,
        'user_id': userId,
        'movie_title': _selectedMovie!.title,
        'seats': _selectedSeats,
        'total_price': _totalPrice,
        'booking_date': DateTime.now(),
      };

      // Kirim ke Firebase menggunakan service dari Febri
      // Note: Uncomment line di bawah setelah FirebaseService_Riz siap
      // await FirebaseService_Riz().createBooking_Riz(bookingData);
      
      // Simulate Firebase call untuk testing
      await _simulateFirebaseCall_Tio(bookingData);

      // Clear selection after successful checkout
      _selectedSeats.clear();
      _selectedMovie = null;
      _totalPrice = 0;
      notifyListeners();

    } catch (e) {
      // Error handling untuk offline scenario (Tes Crash)
      if (e.toString().contains('offline') || e.toString().contains('network')) {
        throw 'Connection error. Please check your internet connection.';
      } else {
        throw 'Checkout failed: $e';
      }
    }
  }

  // Simulate Firebase call untuk testing
  Future<void> _simulateFirebaseCall_Tio(Map<String, dynamic> bookingData) async {
    await Future.delayed(Duration(seconds: 2));
    
    // Simulate success
    print('Booking data sent to Firebase: $bookingData');
  }

  // ==================== MANUAL CALCULATION FOR TESTING ====================
  int calculateSeatPriceManual_Tio(String seatNumber, int basePrice, bool hasLongTitle) {
    String seatNumberStr = seatNumber.substring(1);
    int seatNumberInt = _parseSeatNumber_Tio(seatNumberStr);
    
    // Logic Trap 1: Long Title Tax
    int titleTax = hasLongTitle ? 2500 : 0;
    int price = basePrice + titleTax;
    
    // Logic Trap 2: Odd/Even Seat Rule
    if (seatNumberInt % 2 == 0) {
      price = _calculateDiscount_Tio(price, 10);
    }
    
    return price;
  }

  // ==================== DEBUG & TESTING METHODS ====================
  void debugLogicTrap_Tio() {
    print('=== DEBUG LOGIC TRAP (TIO) ===');
    if (_selectedMovie != null) {
      print('Movie: ${_selectedMovie!.title}');
      print('Title Length: ${_selectedMovie!.title.length}');
      print('Long Title Tax (>10 chars): ${_selectedMovie!.title.length > 10}');
      print('Base Price: ${_selectedMovie!.base_price}');
    }
    print('Selected Seats: $_selectedSeats');
    print('Total Price: $_totalPrice');
    
    // Detailed calculation
    if (_selectedMovie != null && _selectedSeats.isNotEmpty) {
      print('\nDetailed Calculation:');
      for (String seat in _selectedSeats) {
        String seatNum = seat.substring(1);
        int seatNumInt = _parseSeatNumber_Tio(seatNum);
        bool isEven = seatNumInt % 2 == 0;
        print('$seat: ${isEven ? "Even (10% discount)" : "Odd (normal price)"}');
      }
    }
  }

  // ==================== TEST SCENARIOS FOR QA ====================
  Map<String, dynamic> testLogicTrapScenarios_Tio() {
    Map<String, dynamic> results = {};
    
    // Test 1: Judul panjang vs pendek
    MovieModel_Febriyan shortMovie = MovieModel_Febriyan(
      movie_id: "test1",
      title: "Avatar",
      posterior1: "",
      base_price: 35000,
      rating: 4.5,
      duration: 162,
    );
    
    MovieModel_Febriyan longMovie = MovieModel_Febriyan(
      movie_id: "test2",
      title: "Spider-Man: No Way Home",
      posterior1: "",
      base_price: 40000,
      rating: 4.8,
      duration: 148,
    );
    
    // Test harga untuk kursi A1 (ganjil) dan A2 (genap)
    _selectedMovie = shortMovie;
    _selectedSeats = ['A1', 'A2'];
    _calculateTotalPrice_Tio();
    results['shortMovie_2seats'] = _totalPrice;
    
    _selectedMovie = longMovie;
    _selectedSeats = ['A1', 'A2'];
    _calculateTotalPrice_Tio();
    results['longMovie_2seats'] = _totalPrice;
    
    // Reset
    _selectedSeats.clear();
    _selectedMovie = null;
    _totalPrice = 0;
    notifyListeners();
    
    return results;
  }

  // ==================== TESTING FUNCTIONS FOR QA ====================
  Map<String, dynamic> testLogicTrap_Tio() {
    if (_selectedMovie == null) {
      return {'error': 'No movie selected'};
    }

    int basePrice = _selectedMovie!.base_price;
    bool isLongTitle = _selectedMovie!.title.length > 10;
    int titleTax = isLongTitle ? 2500 : 0;

    List<Map<String, dynamic>> seatCalculations = [];

    for (String seat in _selectedSeats) {
      String seatNumberStr = seat.substring(1);
      int seatNumber = _parseSeatNumber_Tio(seatNumberStr);
      bool isEven = seatNumber % 2 == 0;
      
      int seatPrice = basePrice + titleTax;
      int originalPrice = seatPrice;
      
      if (isEven) {
        seatPrice = _calculateDiscount_Tio(seatPrice, 10);
      }

      seatCalculations.add({
        'seat': seat,
        'seat_number': seatNumber,
        'is_even': isEven,
        'original_price': originalPrice,
        'final_price': seatPrice,
      });
    }

    return {
      'movie_title': _selectedMovie!.title,
      'title_length': _selectedMovie!.title.length,
      'is_long_title': isLongTitle,
      'title_tax': titleTax,
      'base_price': basePrice,
      'selected_seats': _selectedSeats,
      'seat_calculations': seatCalculations,
      'total_price': _totalPrice,
    };
  }

  // ==================== RESET METHOD ====================
  void resetAll_Tio() {
    _selectedSeats.clear();
    _selectedMovie = null;
    _totalPrice = 0;
    notifyListeners();
  }

  // ==================== VALIDATION METHODS ====================
  bool isSeatEven_Tio(String seatNumber) {
    String seatNumStr = seatNumber.substring(1);
    int seatNum = _parseSeatNumber_Tio(seatNumStr);
    return seatNum % 2 == 0;
  }

  bool hasLongTitleTax_Tio() {
    return _selectedMovie != null && _selectedMovie!.title.length > 10;
  }

  // ==================== PRICE BREAKDOWN FOR UI ====================
  Map<String, dynamic> getPriceBreakdown_Tio() {
    if (_selectedMovie == null) {
      return {
        'base_price': 0,
        'title_tax': 0,
        'seat_details': [],
        'total': 0
      };
    }

    List<Map<String, dynamic>> seatDetails = [];
    int basePrice = _selectedMovie!.base_price;
    int titleTax = _selectedMovie!.title.length > 10 ? 2500 : 0;

    for (String seat in _selectedSeats) {
      String seatNumStr = seat.substring(1);
      int seatNum = _parseSeatNumber_Tio(seatNumStr);
      bool isEven = seatNum % 2 == 0;
      
      int seatPrice = basePrice + titleTax;
      int discount = 0;
      
      if (isEven) {
        discount = _calculateDiscount_Tio(seatPrice, 10);
        seatPrice -= discount;
      }
      
      seatDetails.add({
        'seat': seat,
        'is_even': isEven,
        'base_price': basePrice,
        'title_tax': titleTax,
        'discount': discount,
        'final_price': seatPrice
      });
    }

    return {
      'base_price': basePrice,
      'title_tax': titleTax,
      'seat_details': seatDetails,
      'total': _totalPrice
    };
  }

  // ==================== FIREBASE INTEGRATION METHODS ====================
  Future<void> saveBookingToFirebase_Tio() async {
    if (_selectedMovie == null || _selectedSeats.isEmpty) {
      throw 'Cannot save: No movie or seats selected';
    }

    try {
      // Generate booking ID
      String bookingId = 'BOOK_${DateTime.now().millisecondsSinceEpoch}';
      
      // Create booking document
      await _firestore.collection('bookings').doc(bookingId).set({
        'booking_id': bookingId,
        'user_id': 'user_${DateTime.now().millisecondsSinceEpoch}', // Placeholder
        'movie_title': _selectedMovie!.title,
        'seats': _selectedSeats,
        'total_price': _totalPrice,
        'booking_date': Timestamp.now(),
      });

      // Reset after successful save
      _selectedSeats.clear();
      _selectedMovie = null;
      _totalPrice = 0;
      notifyListeners();

    } catch (e) {
      throw 'Failed to save booking: $e';
    }
  }

  // ==================== ERROR HANDLING FOR CRASH TEST ====================
  Future<void> testCrashScenario_Tio() async {
    try {
      // Simulate network failure
      await Future.delayed(Duration(seconds: 1));
      throw Exception('Simulated network error');
    } catch (e) {
      // Aplikasi tidak boleh crash, hanya tampilkan error message
      print('Error handled gracefully: $e');
      // Kembalikan error message untuk ditampilkan di UI
      throw 'Payment failed: Please check your internet connection and try again.';
    }
  }
}