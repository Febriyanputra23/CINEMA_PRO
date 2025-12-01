import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

class BookingModel_Febriyan {
  final String booking_id;
  final String user_id;
  final String movie_title;
  final List<String> seats;
  final int total_price;
  final DateTime booking_date;
  final String? status; // ACTIVE, USED, CANCELLED
  final String? theater_name;
  final String? showtime;
  final String? poster_url;

  BookingModel_Febriyan({
    required this.booking_id,
    required this.user_id,
    required this.movie_title,
    required this.seats,
    required this.total_price,
    required this.booking_date,
    this.status = 'ACTIVE',
    this.theater_name,
    this.showtime,
    this.poster_url,
  });

  // Convert to Map
  Map<String, dynamic> toMap() {
    return {
      'booking_id': booking_id,
      'user_id': user_id,
      'movie_title': movie_title,
      'seats': seats,
      'total_price': total_price,
      'booking_date': booking_date,
      'status': status,
      'theater_name': theater_name,
      'showtime': showtime,
      'poster_url': poster_url,
    };
  }

  // Convert from Map
  factory BookingModel_Febriyan.fromMap(Map<String, dynamic> map) {
    DateTime parseBookingDate(dynamic date) {
      if (date is Timestamp) {
        return date.toDate();
      } else if (date is DateTime) {
        return date;
      } else if (date is String) {
        return DateTime.parse(date);
      } else {
        return DateTime.now();
      }
    }

    return BookingModel_Febriyan(
      booking_id: map['booking_id']?.toString() ?? '',
      user_id: map['user_id']?.toString() ?? '',
      movie_title: map['movie_title']?.toString() ?? '',
      seats: List<String>.from(map['seats'] ?? []),
      total_price: (map['total_price'] ?? 0).toInt(),
      booking_date: parseBookingDate(map['booking_date']),
      status: map['status']?.toString() ?? 'ACTIVE',
      theater_name: map['theater_name']?.toString(),
      showtime: map['showtime']?.toString(),
      poster_url: map['poster_url']?.toString(),
    );
  }

  // Convert to JSON
  String toJson() => json.encode(toMap());

  // Convert from JSON
  factory BookingModel_Febriyan.fromJson(String source) =>
      BookingModel_Febriyan.fromMap(json.decode(source));

  // Copy with
  BookingModel_Febriyan copyWith({
    String? booking_id,
    String? user_id,
    String? movie_title,
    List<String>? seats,
    int? total_price,
    DateTime? booking_date,
    String? status,
    String? theater_name,
    String? showtime,
    String? poster_url,
  }) {
    return BookingModel_Febriyan(
      booking_id: booking_id ?? this.booking_id,
      user_id: user_id ?? this.user_id,
      movie_title: movie_title ?? this.movie_title,
      seats: seats ?? this.seats,
      total_price: total_price ?? this.total_price,
      booking_date: booking_date ?? this.booking_date,
      status: status ?? this.status,
      theater_name: theater_name ?? this.theater_name,
      showtime: showtime ?? this.showtime,
      poster_url: poster_url ?? this.poster_url,
    );
  }

  // Helper methods
  bool get isActive => (status?.toUpperCase() ?? 'ACTIVE') == 'ACTIVE';
  bool get isUsed => (status?.toUpperCase() ?? '') == 'USED';
  bool get isCancelled => (status?.toUpperCase() ?? '') == 'CANCELLED';
}