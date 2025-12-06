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
  bool _isCheckingOut = false;
  List<String> _bookedSeatsForMovie = [];
  bool _isLoadingBookedSeats = false;

  List<String> get selectedSeats => _selectedSeats;
  MovieModel_Febriyan? get selectedMovie => _selectedMovie;
  int get totalPrice => _totalPrice;
  List<BookingModel_Febriyan> get bookingHistory => _bookingHistory;
  bool get isLoadingHistory => _isLoadingHistory;
  bool get isCheckingOut => _isCheckingOut;
  List<String> get bookedSeatsForMovie => _bookedSeatsForMovie;
  bool get isLoadingBookedSeats => _isLoadingBookedSeats;

  void setSelectedMovie_Tio(MovieModel_Febriyan movie) {
    if (_selectedMovie?.movie_id != movie.movie_id) {
      _selectedSeats.clear();
      _bookedSeatsForMovie.clear();
    }
    _selectedMovie = movie;
    _calculateTotalPrice_Tio();
    
    // Load booked seats untuk film ini
    loadBookedSeatsForMovie(movie.title);
    
    notifyListeners();
  }

  void toggleSeat_Tio(String seatNumber) {
    // Cek apakah seat sudah dibooking
    if (_bookedSeatsForMovie.contains(seatNumber)) {
      return; // Jangan izinkan pilih seat yang sudah dibooking
    }
    
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
  }

  Future<void> loadBookedSeatsForMovie(String movieTitle) async {
    try {
      _isLoadingBookedSeats = true;
      notifyListeners();

      _bookedSeatsForMovie = [];

      final now = Timestamp.now();
      final threeHoursAgo = Timestamp.fromDate(
        DateTime.now().subtract(Duration(hours: 3)),
      );

      // Query sederhana tanpa index yang kompleks
      final snapshot = await FirebaseFirestore.instance
          .collection('bookings')
          .where('movie_title', isEqualTo: movieTitle)
          .get();

      final List<String> allBookedSeats = [];
      final currentTime = DateTime.now();
      
      for (var doc in snapshot.docs) {
        final data = doc.data();
        final bookingDate = (data['booking_date'] as Timestamp).toDate();
        
        // Cek apakah booking masih valid (dalam 3 jam terakhir)
        if (currentTime.difference(bookingDate).inHours < 3) {
          final seats = List<String>.from(data['seats'] ?? []);
          allBookedSeats.addAll(seats);
        }
      }

      // Remove duplicates
      _bookedSeatsForMovie = allBookedSeats.toSet().toList();
      
      _isLoadingBookedSeats = false;
      notifyListeners();
      
    } catch (e) {
      print('Error loading booked seats: $e');
      _bookedSeatsForMovie = [];
      _isLoadingBookedSeats = false;
      notifyListeners();
    }
  }

  Future<void> loadBookingHistory_Tio() async {
    try {
      _isLoadingHistory = true;
      notifyListeners();

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

  Future<String> checkout_Tio() async {
    if (_isCheckingOut) {
      throw 'Booking in progress. Please wait...';
    }

    try {
      _isCheckingOut = true;
      notifyListeners();

      if (_selectedMovie == null) throw 'No movie selected';
      if (_selectedSeats.isEmpty) throw 'No seats selected';

      // Cek apakah ada seat yang tiba-tiba sudah dibooking
      for (String seat in _selectedSeats) {
        if (_bookedSeatsForMovie.contains(seat)) {
          throw 'Seat $seat is already booked! Please refresh and select different seats.';
        }
      }

      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw 'User not logged in';

      // Simpan data sebelum di-clear
      final movieTitle = _selectedMovie!.title;
      final selectedSeatsCopy = List<String>.from(_selectedSeats);
      final totalPriceCopy = _totalPrice;

      // Delay kecil untuk mencegah rapid clicks
      await Future.delayed(Duration(milliseconds: 300));

      // Tambahkan dokumen baru
      final docRef = await FirebaseFirestore.instance.collection('bookings').add({
        'user_id': user.uid,
        'movie_title': movieTitle,
        'seats': selectedSeatsCopy,
        'total_price': totalPriceCopy,
        'booking_date': Timestamp.now(),
      });

      // Update dengan booking_id
      await docRef.update({'booking_id': docRef.id});

      // Tambahkan ke local history
      final newBooking = BookingModel_Febriyan(
        booking_id: docRef.id,
        user_id: user.uid,
        movie_title: movieTitle,
        seats: selectedSeatsCopy,
        total_price: totalPriceCopy,
        booking_date: Timestamp.now(),
      );

      _bookingHistory.insert(0, newBooking);
      
      // Tambahkan seat yang baru dibooking ke list booked seats
      _bookedSeatsForMovie.addAll(selectedSeatsCopy);
      
      // Tidak langsung clear seats - biarkan UI yang handle
      notifyListeners();

      // Return booking ID untuk ditampilkan di UI
      return docRef.id;

    } catch (e) {
      print('Checkout error: $e');
      throw 'Checkout failed: $e';
    } finally {
      _isCheckingOut = false;
      notifyListeners();
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
    _bookedSeatsForMovie.clear();
    _isCheckingOut = false;
    _isLoadingBookedSeats = false;
    notifyListeners();
  }
}