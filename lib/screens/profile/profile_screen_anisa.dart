import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../models/booking_model_febriyan.dart';

class ProfileScreen_Anisa extends StatelessWidget {
  final List<BookingModel_Febriyan> bookings = [
    BookingModel_Febriyan(
      booking_id: "BOOK001",
      user_id: "user1",
      movie_title: "Spider-Man: No Way Home",
      seats: ["A1", "A2"],
      total_price: 115500,
      booking_date: DateTime(2024, 1, 15, 14, 30),
    ),
    BookingModel_Febriyan(
      booking_id: "BOOK002",
      user_id: "user1",
      movie_title: "Avatar",
      seats: ["B3", "B4", "B5"],
      total_price: 157500,
      booking_date: DateTime(2024, 1, 10, 19, 0),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('My Profile')),
      body: ListView(
        children: [
          // Profile Header
          Card(
            margin: EdgeInsets.all(16),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.blue,
                    child: Icon(Icons.person, color: Colors.white, size: 30),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Anisa suci', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        Text('anisa@student.poliwangi.ac.id'),
                        SizedBox(height: 4),
                        Text('Balance: Rp 250.000', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Booking History
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text('Booking History', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),

          // Booking List
          ...bookings.map((booking) => _buildBookingCard(booking)).toList(),
        ],
      ),
    );
  }

  Widget _buildBookingCard(BookingModel_Febriyan booking) {
    return Card(
      margin: EdgeInsets.all(16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: Text(booking.movie_title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
                Text('Rp ${booking.total_price}', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
              ],
            ),
            SizedBox(height: 8),
            Text('Seats: ${booking.seats.join(', ')}'),
            Text('Date: ${_formatDate(booking.booking_date)}'),
            SizedBox(height: 16),
            Center(
              child: Column(
                children: [
                  Text('Ticket QR Code', style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  QrImageView(
                    data: booking.booking_id,
                    size: 120,
                    backgroundColor: Colors.white,
                  ),
                  SizedBox(height: 4),
                  Text('Show at cinema', style: TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}