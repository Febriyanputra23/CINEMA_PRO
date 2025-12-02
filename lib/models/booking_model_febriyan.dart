import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

class BookingModel_Febriyan {
  final String booking_id;
  final String user_id;
  final String movie_title;
  final List<String> seats;
  final int total_price;
  final Timestamp booking_date;

  BookingModel_Febriyan({
    required this.booking_id,
    required this.user_id,
    required this.movie_title,
    required this.seats,
    required this.total_price,
    required this.booking_date,
  });

  Map<String, dynamic> toMap() {
    return {
      'booking_id': booking_id,
      'user_id': user_id,
      'movie_title': movie_title,
      'seats': seats,
      'total_price': total_price,
      'booking_date': booking_date,
    };
  }

  factory BookingModel_Febriyan.fromMap(Map<String, dynamic> map) {
    return BookingModel_Febriyan(
      booking_id: map['booking_id']?.toString() ?? '',
      user_id: map['user_id']?.toString() ?? '',
      movie_title: map['movie_title']?.toString() ?? '',
      seats: List<String>.from(map['seats'] ?? []),
      total_price: (map['total_price'] ?? 0).toInt(),
      booking_date: map['booking_date'] is Timestamp 
          ? map['booking_date'] 
          : Timestamp.fromDate(DateTime.parse(map['booking_date'])),
    );
  }

  String toJson() => json.encode(toMap());

  factory BookingModel_Febriyan.fromJson(String source) =>
      BookingModel_Febriyan.fromMap(json.decode(source));

  BookingModel_Febriyan copyWith({
    String? booking_id,
    String? user_id,
    String? movie_title,
    List<String>? seats,
    int? total_price,
    Timestamp? booking_date,
  }) {
    return BookingModel_Febriyan(
      booking_id: booking_id ?? this.booking_id,
      user_id: user_id ?? this.user_id,
      movie_title: movie_title ?? this.movie_title,
      seats: seats ?? this.seats,
      total_price: total_price ?? this.total_price,
      booking_date: booking_date ?? this.booking_date,
    );
  }
}