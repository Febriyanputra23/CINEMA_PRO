import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Wajib
import 'package:qr_flutter/qr_flutter.dart';
import '../../models/booking_model_febriyan.dart';
import '../../providers/booking_provider.dart'; // Wajib

// 1. Ubah menjadi StatefulWidget
class ProfileScreen_Anisa extends StatefulWidget {
  @override
  _ProfileScreen_AnisaState createState() => _ProfileScreen_AnisaState();
}

class _ProfileScreen_AnisaState extends State<ProfileScreen_Anisa> {
  @override
  void initState() {
    super.initState();
    // PENTING: Panggil fungsi fetch data di initState
    // Menggunakan Future.microtask agar Provider dapat diakses dengan aman.
    Future.microtask(() {
      Provider.of<BookingProvider_Tio>(context, listen: false)
          .loadBookingHistory_Tio();
    });
  }

  @override
  Widget build(BuildContext context) {
    // 2. Gunakan Consumer untuk mendengarkan perubahan data History
    return Consumer<BookingProvider_Tio>(
        builder: (context, bookingProvider, child) {
      final bookings = bookingProvider.bookingHistory;
      final isLoading = bookingProvider.isLoadingHistory;

      return Scaffold(
        appBar: AppBar(title: Text('My Profile')),
        body: ListView(
          children: [
            // Profile Header (Data User masih Hardcoded)
            _buildProfileHeader(),

            // ----------------------------------------
            // Bagian Riwayat Booking (Live Data)
            // ----------------------------------------
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text('Booking History',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            SizedBox(height: 10),

            // 3. Tampilkan Loading atau Data
            if (isLoading)
              Center(
                  child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: CircularProgressIndicator(),
              ))
            else if (bookings.isEmpty)
              Center(
                  child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Text("Anda belum memiliki tiket yang aktif.",
                    style: TextStyle(color: Colors.grey[600])),
              ))
            else
              // 4. Tampilkan Daftar Booking dari Provider
              ...bookings
                  .map((booking) => _buildBookingCard(booking, bookingProvider))
                  .toList(),
          ],
        ),
      );
    });
  }

  // --- WIDGET PROFILE HEADER (Masih Statis/Hardcoded) ---
  Widget _buildProfileHeader() {
    // Perlu diintegrasikan dengan Firebase Auth/Service untuk data asli
    return Card(
      margin: EdgeInsets.all(16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
                radius: 30,
                backgroundColor: Colors.blue,
                child: Icon(Icons.person, color: Colors.white, size: 30)),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Anisa suci',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text('anisa@student.poliwangi.ac.id'),
                  SizedBox(height: 4),
                  Text('Balance: Rp 250.000',
                      style: TextStyle(
                          color: Colors.green, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- WIDGET CARD BOOKING ---
  Widget _buildBookingCard(
      BookingModel_Febriyan booking, BookingProvider_Tio provider) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                    child: Text(booking.movie_title,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16))),
                Text('Rp ${booking.total_price}',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.green)),
              ],
            ),
            SizedBox(height: 8),
            Text('Seats: ${booking.seats.join(', ')}'),
            Text('Date: ${_formatDate(booking.booking_date)}'),
            // ... (Detail lainnya)
            SizedBox(height: 16),
            Center(
              child: Column(
                children: [
                  Text('Ticket QR Code',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  QrImageView(
                    // Gunakan data JSON dari provider untuk QR Code
                    data: provider.generateQRData_Tio(booking),
                    size: 120,
                    backgroundColor: Colors.white,
                  ),
                  SizedBox(height: 4),
                  Text('Show at cinema',
                      style: TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- FORMAT DATE HELPER ---
  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}
