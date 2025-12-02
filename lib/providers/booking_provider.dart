import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/movie_model_all_febriyan.dart';
import '../models/booking_model_febriyan.dart';
import '../utils/logic_trap_utils_tio.dart';

class BookingProvider_Tio with ChangeNotifier {
  List<String> _selectedSeats = [];
  MovieModel_Febriyan? _selectedMovie;
  int _totalPrice = 0;
  List<BookingModel_Febriyan> _bookingHistory = [];
  bool _isLoadingHistory = false;

  List<String> get selectedSeats => _selectedSeats;
  MovieModel_Febriyan? get selectedMovie => _selectedMovie;
  int get totalPrice => _totalPrice;
  List<BookingModel_Febriyan> get bookingHistory => _bookingHistory;
  bool get isLoadingHistory => _isLoadingHistory;

  void setSelectedMovie_Tio(MovieModel_Febriyan movie) {
    _selectedMovie = movie;
    _calculateTotalPrice_Tio();
    notifyListeners();
  }

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

  void _calculateTotalPrice_Tio() {
    if (_selectedMovie == null) {
      _totalPrice = 0;
      return;
    }
    _totalPrice = LogicTrapUtils_Tio.calculateTotalPriceManual_Tio(
      movieTitle: _selectedMovie!.title,
      basePrice: _selectedMovie!.base_price,
      selectedSeats: _selectedSeats,
    );
    notifyListeners();
  }

  Future<void> loadBookingHistory_Tio() async {
    try {
      _isLoadingHistory = true;
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        _bookingHistory = [];
        _isLoadingHistory = false;
        notifyListeners();
        return;
      }
      final snapshot = await FirebaseFirestore.instance
          .collection('bookings')
          .where('user_id', isEqualTo: user.uid)
          .orderBy('booking_date', descending: true)
          .get();
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
    }
  }

  Future<void> checkout_Tio() async {
    try {
      if (_selectedMovie == null) throw 'No movie selected';
      if (_selectedSeats.isEmpty) throw 'No seats selected';
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw 'User not logged in';

      String bookingId = 'BOOK_${DateTime.now().millisecondsSinceEpoch}';
      Map<String, dynamic> bookingData = {
        'booking_id': bookingId,
        'user_id': user.uid,
        'movie_title': _selectedMovie!.title,
        'seats': _selectedSeats,
        'total_price': _totalPrice,
        'booking_date': Timestamp.now(),
      };

      await FirebaseFirestore.instance
          .collection('bookings')
          .doc(bookingId)
          .set(bookingData);

      final newBooking = BookingModel_Febriyan.fromMap(bookingData);
      _bookingHistory.insert(0, newBooking);
      _selectedSeats.clear();
      _totalPrice = 0;
      notifyListeners();
    } catch (e) {
      throw 'Checkout failed: $e';
    }
  }

  String generateQRData_Tio(BookingModel_Febriyan booking) {
    return booking.booking_id;
  }

  void resetAll_Tio() {
    _selectedSeats.clear();
    _selectedMovie = null;
    _totalPrice = 0;
    _bookingHistory.clear();
    notifyListeners();
  }
}