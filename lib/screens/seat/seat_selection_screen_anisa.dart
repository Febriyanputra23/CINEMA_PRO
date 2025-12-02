import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/movie_model_all_febriyan.dart';
import '../../providers/booking_provider.dart';

class SeatSelectionScreen_Anisa extends StatelessWidget {
  final List<String> rowLabels = ['A', 'B', 'C', 'D', 'E', 'F'];
  final int seatsPerRow = 8;

  @override
  Widget build(BuildContext context) {
    final bookingProvider = Provider.of<BookingProvider_Tio>(context);
    final movie = bookingProvider.selectedMovie;

    if (movie == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Select Seats'),
          backgroundColor: Colors.blue,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 60, color: Colors.red),
              SizedBox(height: 20),
              Text('No Movie Selected',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Go Back'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Select Seats'),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          _buildMovieInfo_Anisa(movie),
          _buildScreenLabel_Anisa(),
          _buildSeatGrid_Anisa(bookingProvider),
          _buildLegend_Anisa(),
          _buildCheckoutSection_Anisa(bookingProvider, context),
        ],
      ),
    );
  }

  Widget _buildMovieInfo_Anisa(MovieModel_Febriyan movie) {
    // Logika Long Title Tax sesuai spesifikasi
    bool hasLongTitleTax = movie.title.length > 10;
    int taxAmount = hasLongTitleTax ? 2500 : 0;
    
    return Card(
      margin: EdgeInsets.all(16),
      child: ListTile(
        leading: Image.network(
          movie.poster_url,
          width: 60,
          height: 80,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Icon(Icons.movie, size: 40),
        ),
        title: Text(movie.title,
            style: TextStyle(fontWeight: FontWeight.bold), maxLines: 2),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Base Price: Rp ${movie.base_price}'),
            if (hasLongTitleTax)
              Text('+ Long Title Tax: Rp 2.500',
                  style: TextStyle(color: Colors.orange)),
            Text('Duration: ${movie.duration} min'),
            Text('Rating: ${movie.rating}/5.0'),
          ],
        ),
      ),
    );
  }

  Widget _buildScreenLabel_Anisa() {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 20),
          height: 20,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.grey[300]!, Colors.grey[100]!, Colors.grey[300]!],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Center(
            child: Text('SCREEN',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.black54,
                    letterSpacing: 5)),
          ),
        ),
        SizedBox(height: 10),
      ],
    );
  }

  Widget _buildSeatGrid_Anisa(BookingProvider_Tio provider) {
    // Contoh data kursi yang sudah terbooking (harusnya dari Firebase)
    // Untuk testing, kita buat beberapa kursi yang sudah terjual
    List<String> bookedSeats = ['A2', 'B5', 'C3', 'D7', 'E1', 'F4', 'F8'];

    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16),
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: rowLabels.length,
          itemBuilder: (context, rowIndex) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 30,
                    alignment: Alignment.center,
                    child: Text(rowLabels[rowIndex],
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List.generate(seatsPerRow, (colIndex) {
                          String seatNumber =
                              '${rowLabels[rowIndex]}${colIndex + 1}';
                          bool isBooked = bookedSeats.contains(seatNumber);
                          
                          return SeatItem_Anisa(
                            seatNumber: seatNumber,
                            isSelected: provider.selectedSeats.contains(seatNumber),
                            isBooked: isBooked,
                            onTap: () {
                              if (!isBooked) {
                                provider.toggleSeat_Tio(seatNumber);
                              }
                            },
                          );
                        }),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildLegend_Anisa() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildLegendItem_Anisa(
            Colors.grey[300]!,
            'Available',
            Icons.event_seat,
          ),
          _buildLegendItem_Anisa(
            Colors.blue[400]!,
            'Selected',
            Icons.event_seat,
          ),
          _buildLegendItem_Anisa(
            Colors.red[400]!,
            'Booked',
            Icons.event_seat,
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem_Anisa(Color color, String text, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: color, size: 30),
        SizedBox(height: 4),
        Text(text, style: TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _buildCheckoutSection_Anisa(
      BookingProvider_Tio provider, BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          // Row dengan Expanded untuk menghindari overflow
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Selected Seats', 
                        style: TextStyle(color: Colors.grey, fontSize: 14)),
                    SizedBox(height: 4),
                    Container(
                      height: 40,
                      child: provider.selectedSeats.isNotEmpty
                          ? ListView(
                              scrollDirection: Axis.horizontal,
                              children: provider.selectedSeats.map((seat) {
                                return Container(
                                  margin: EdgeInsets.only(right: 8),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.blue[50],
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: Colors.blue[100]!),
                                  ),
                                  child: Text(seat,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                );
                              }).toList(),
                            )
                          : Text('No seats selected',
                              style: TextStyle(fontStyle: FontStyle.italic)),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('Total Price', 
                      style: TextStyle(color: Colors.grey, fontSize: 14)),
                  SizedBox(height: 4),
                  Text(
                    'Rp ${provider.totalPrice}',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.green[700]),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: provider.selectedSeats.isEmpty
                  ? null
                  : () => _checkout_Anisa(context, provider),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 3,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.confirmation_number, color: Colors.white),
                  SizedBox(width: 10),
                  Text('CHECKOUT', 
                      style: TextStyle(fontSize: 16, color: Colors.white)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _checkout_Anisa(BuildContext context, BookingProvider_Tio provider) {
    if (FirebaseAuth.instance.currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: Anda harus Login/Register sebelum Checkout!"),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirm Booking'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Movie: ${provider.selectedMovie!.title}',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text('Seats: ${provider.selectedSeats.join(', ')}'),
              SizedBox(height: 8),
              Text('Total: Rp ${provider.totalPrice}'),
              SizedBox(height: 8),
              Divider(),
              // Tampilkan breakdown harga sesuai spesifikasi
              if (provider.selectedMovie!.title.length > 10)
                Text('• Long Title Tax: Rp 2,500 x ${provider.selectedSeats.length} seat(s)'),
              // Tampilkan discount untuk kursi genap
              _buildPriceBreakdown_Anisa(provider),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              _showLoadingDialog_Anisa(context);

              try {
                await provider.checkout_Tio();
                Navigator.pop(context);
                _showSuccessDialog_Anisa(context, provider);
              } catch (e) {
                Navigator.pop(context);
                String errorMessage = e.toString().contains("Permission Denied")
                    ? "Gagal Simpan: Cek Security Rules Firebase Anda."
                    : "Gagal Booking: Pastikan koneksi internet dan kursi terpilih.";

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(errorMessage),
                    backgroundColor: Colors.red,
                    duration: Duration(seconds: 3),
                  ),
                );
              }
            },
            child: Text('Confirm & Pay'),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceBreakdown_Anisa(BookingProvider_Tio provider) {
    // Hitung jumlah kursi genap yang mendapat diskon
    int evenSeatsCount = provider.selectedSeats
        .where((seat) {
          int seatNumber = int.tryParse(seat.substring(1)) ?? 0;
          return seatNumber % 2 == 0;
        })
        .length;
    
    if (evenSeatsCount > 0) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 8),
          Text('• Even Seat Discount (10%): $evenSeatsCount seat(s)'),
        ],
      );
    }
    return SizedBox();
  }

  void _showLoadingDialog_Anisa(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Row(
          children: [
            CircularProgressIndicator(),
            SizedBox(width: 20),
            Expanded(
              child: Text("Processing booking... Please wait."),
            ),
          ],
        ),
      ),
    );
  }

  void _showSuccessDialog_Anisa(
      BuildContext context, BookingProvider_Tio provider) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 80),
              SizedBox(height: 16),
              Text('Booking Successful!',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.green)),
              SizedBox(height: 12),
              Text('Movie: ${provider.selectedMovie!.title}',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text('Seats: ${provider.selectedSeats.join(', ')}'),
              SizedBox(height: 8),
              Text('Total Paid: Rp ${provider.totalPrice}'),
              SizedBox(height: 16),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    Icon(Icons.qr_code, size: 40, color: Colors.blue),
                    SizedBox(height: 8),
                    Text('Show this QR Code at cinema',
                        style: TextStyle(fontSize: 12, color: Colors.grey)),
                    SizedBox(height: 8),
                    // Simulasi QR Code (bisa diganti dengan library qr_flutter)
                    Container(
                      width: 120,
                      height: 120,
                      color: Colors.grey[200],
                      child: Center(
                        child: Text('QR CODE',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black54)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              child: Text('Back to Home'),
            ),
          ),
        ],
      ),
    );
  }
}

class SeatItem_Anisa extends StatelessWidget {
  final String seatNumber;
  final bool isSelected;
  final bool isBooked;
  final VoidCallback onTap;

  const SeatItem_Anisa({
    Key? key,
    required this.seatNumber,
    required this.isSelected,
    required this.isBooked,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Tentukan warna berdasarkan status kursi
    Color seatColor;
    if (isBooked) {
      seatColor = Colors.red[400]!;
    } else if (isSelected) {
      seatColor = Colors.blue[400]!;
    } else {
      seatColor = Colors.grey[300]!;
    }

    // Parse nomor kursi untuk menentukan ganjil/genap (untuk styling)
    int seatNum = int.tryParse(seatNumber.substring(1)) ?? 0;
    bool isEven = seatNum % 2 == 0;

    return GestureDetector(
      onTap: isBooked ? null : onTap,
      child: Container(
        width: 35,
        height: 35,
        margin: EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: seatColor,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: isSelected ? Colors.blue[700]! : Colors.grey[400]!,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 2,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                seatNumber.substring(0, 1), // Huruf baris
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: isBooked ? Colors.white70 : Colors.black87,
                ),
              ),
              Text(
                seatNum.toString(), // Nomor kursi
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: isBooked ? Colors.white : Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}