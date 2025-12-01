import 'package:cloud_firestore/cloud_firestore.dart';

class BookingModel_Febriyan {
  final String booking_id;
  final String user_id;
  final String movie_title;
  final List<String> seats;
  final int total_price;
  final DateTime booking_date;

  BookingModel_Febriyan({
    required this.booking_id,
    required this.user_id,
    required this.movie_title,
    required this.seats,
    required this.total_price,
    required this.booking_date,
  });

  // Manual mapping
  factory BookingModel_Febriyan.fromMap(Map<String, dynamic> map) {
    return BookingModel_Febriyan(
      booking_id: map['booking_id'] ?? '',
      user_id: map['user_id'] ?? '',
      movie_title: map['movie_title'] ?? '',
      seats: List<String>.from(map['seats'] ?? []),
      total_price: map['total_price'] ?? 0,
      booking_date: (map['booking_date'] as Timestamp).toDate(),
    );
  }

  // Manual mapping
  Map<String, dynamic> toMap() {
    return {
      'booking_id': booking_id,
      'user_id': user_id,
      'movie_title': movie_title,
      'seats': seats,
      'total_price': total_price,
      'booking_date': Timestamp.fromDate(booking_date),
    };
  }
}