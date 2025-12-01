import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/movie_model_all_febriyan.dart';
import '../models/booking_model_febriyan.dart';
import '../utils/logic_trap_utils_tio.dart';

class BookingProvider_Tio with ChangeNotifier {
  // ==================== STATE VARIABLES ====================
  List<String> _selectedSeats = [];
  MovieModel_Febriyan? _selectedMovie;
  int _totalPrice = 0;

  // Untuk riwayat tiket
  List<BookingModel_Febriyan> _bookingHistory = [];
  bool _isLoadingHistory = false;

  // ==================== GETTERS ====================
  List<String> get selectedSeats => _selectedSeats;
  MovieModel_Febriyan? get selectedMovie => _selectedMovie;
  int get totalPrice => _totalPrice;
  List<BookingModel_Febriyan> get bookingHistory => _bookingHistory;
  bool get isLoadingHistory => _isLoadingHistory;

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

  // ==================== PRICE CALCULATION ====================
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

  // ==================== HISTORY TICKET (REALTIME FIREBASE) ====================

  Future<void> loadBookingHistory_Tio() async {
    try {
      _isLoadingHistory = true;
      // notifyListeners(); // Hindari notify saat build widget

      // 1. Ambil User ID yang sedang login
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        _bookingHistory = [];
        _isLoadingHistory = false;
        notifyListeners();
        return;
      }

      // 2. Ambil data dari koleksi 'bookings' milik user ini
      final snapshot = await FirebaseFirestore.instance
          .collection('bookings')
          .where('user_id', isEqualTo: user.uid)
          .orderBy('booking_date', descending: true)
          .get();

      // 3. Ubah jadi List BookingModel
      _bookingHistory = snapshot.docs.map((doc) {
        final data = doc.data();
        data['booking_id'] = doc.id;
        return BookingModel_Febriyan.fromMap(data);
      }).toList();

      _isLoadingHistory = false;
      notifyListeners();
    } catch (e) {
      _isLoadingHistory = false;
      notifyListeners();
      print('Error loading booking history: $e');
    }
  }

  // ==================== CHECKOUT (FIXED: BISA BOOKING BERULANG) ====================
  Future<void> checkout_Tio() async {
    try {
      if (_selectedMovie == null) throw 'No movie selected';
      if (_selectedSeats.isEmpty) throw 'No seats selected';

      // 1. Ambil User ID Otomatis
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw 'User not logged in';

      String bookingId = 'BOOK_${DateTime.now().millisecondsSinceEpoch}';

      // 2. Siapkan Data
      Map<String, dynamic> bookingData = {
        'booking_id': bookingId,
        'user_id': user.uid,
        'movie_title': _selectedMovie!.title,
        'seats': _selectedSeats,
        'total_price': _totalPrice,
        'booking_date': DateTime.now().toIso8601String(),
        'status': 'ACTIVE',
        'poster_url': _selectedMovie!.posterior1,
        'theater_name': 'Cinema XXI',
        'showtime': '19:00',
      };

      // 3. SIMPAN KE FIREBASE
      await FirebaseFirestore.instance
          .collection('bookings')
          .doc(bookingId)
          .set(bookingData);

      print("✅ Berhasil simpan ke Firebase!");

      // 4. Update History Lokal biar langsung muncul
      final newBooking = BookingModel_Febriyan.fromMap(bookingData);
      _bookingHistory.insert(0, newBooking);

      // 5. Reset Kursi SAJA (Movie jangan di-reset)
      _selectedSeats.clear();
      _totalPrice = 0;

      // --- PERBAIKAN DI SINI ---
      // Baris di bawah ini dikomentari/dimatikan agar kamu bisa booking lagi
      // _selectedMovie = null;

      notifyListeners();
    } catch (e) {
      print("Error Checkout: $e");
      throw 'Checkout failed: $e';
    }
  }

  // ==================== QR CODE & HELPER ====================

  String generateQRData_Tio(BookingModel_Febriyan booking) {
    final data = {
      'booking_id': booking.booking_id,
      'movie': booking.movie_title,
      'seats': booking.seats,
      'total': booking.total_price,
      'verification': _generateVerificationHash_Tio(booking.booking_id),
    };
    return jsonEncode(data);
  }

  String _generateVerificationHash_Tio(String bookingId) {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final hash = (bookingId.hashCode + timestamp).toRadixString(16);
    return hash.substring(0, 8).toUpperCase();
  }

  // Method ini dipanggil HANYA kalau logout atau benar-benar keluar app
  void resetAll_Tio() {
    _selectedSeats.clear();
    _selectedMovie = null;
    _totalPrice = 0;
    _bookingHistory.clear();
    notifyListeners();
  }
}
