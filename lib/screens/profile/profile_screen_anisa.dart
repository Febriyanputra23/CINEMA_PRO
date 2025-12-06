import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/booking_model_febriyan.dart';
import '../../models/user_model_febriyan.dart';
import '../../providers/booking_provider.dart';

class ProfileScreen_Anisa extends StatefulWidget {
  @override
  _ProfileScreen_AnisaState createState() => _ProfileScreen_AnisaState();
}

class _ProfileScreen_AnisaState extends State<ProfileScreen_Anisa> {
  UserModel_Febriyan? _userData;
  bool _isLoadingUser = true;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      _loadUserData();
      Provider.of<BookingProvider_Tio>(context, listen: false)
          .loadBookingHistory_Tio();
    });
  }

  Future<void> _loadUserData() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        if (doc.exists) {
          setState(() {
            _userData = UserModel_Febriyan.fromMap(doc.data()!);
            _isLoadingUser = false;
          });
        }
      }
    } catch (e) {
      setState(() {
        _isLoadingUser = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BookingProvider_Tio>(
        builder: (context, bookingProvider, child) {
      final bookings = bookingProvider.bookingHistory;
      final isLoading = bookingProvider.isLoadingHistory;

      return Scaffold(
        appBar: AppBar( title: Text('My Profile'), backgroundColor: Colors.blue),
        body: RefreshIndicator(
          onRefresh: () async {
            await _loadUserData();
            await bookingProvider.loadBookingHistory_Tio();
          },
          child: ListView(
            children: [
              _buildProfileHeader(),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Text('Booking History', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
              if (isLoading)
                Center(
                    child: Padding(
                  padding: const EdgeInsets.all(20.0), child: CircularProgressIndicator()))
              else if (bookings.isEmpty)
                Center(
                    child: Padding( padding: const EdgeInsets.all(30.0),
                  child: Text("Anda belum memiliki tiket yang aktif.", style: TextStyle(color: Colors.grey[600])),
                ))
              else
                ...bookings
                    .map((booking) => _buildBookingCard(booking, bookingProvider))
                    .toList(),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildProfileHeader() {
    if (_isLoadingUser) {
      return Card(
        margin: EdgeInsets.all(16),
        child: Padding( padding: EdgeInsets.all(16), child: Center(child: CircularProgressIndicator())),
      );
    }

    return Card(
      margin: EdgeInsets.all(16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar( radius: 30, backgroundColor: Colors.blue, child: Icon(Icons.person, color: Colors.white, size: 30)),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_userData?.username ?? 'User', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text(_userData?.email ?? 'email@student.univ.ac.id'),
                  SizedBox(height: 4),
                  Text('Balance: Rp ${_userData?.balance ?? 0}', style: TextStyle( color: Colors.green, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookingCard(
      BookingModel_Febriyan booking, BookingProvider_Tio provider) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding( padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                    child: Text(booking.movie_title, style: TextStyle( fontWeight: FontWeight.bold, fontSize: 16))
                        ),
                Text('Rp ${booking.total_price}',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.green)),
              ],
            ),
            SizedBox(height: 8),
            Text('Seats: ${booking.seats.join(', ')}'),
            Text('Date: ${_formatDate(booking.booking_date.toDate())}'),
            SizedBox(height: 16),
            Center(
              child: Column(
                children: [
                  Text('Ticket QR Code',style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  QrImageView(
                    data: provider.generateQRData_Tio(booking),
                    size: 120, backgroundColor: Colors.white),
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