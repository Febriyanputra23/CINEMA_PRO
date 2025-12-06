import 'dart:async';
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
            mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(Icons.error_outline, size: 60, color: Colors.red),
              SizedBox(height: 20),
              Text('No Movie Selected', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.pop(context), child: Text('Go Back'),
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
        actions: [
          // Tombol refresh booked seats
          if (bookingProvider.isLoadingBookedSeats)
            Padding(
              padding: EdgeInsets.only(right: 16),
              child: Center( child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator( strokeWidth: 2, color: Colors.white, ))),
            )
          else
            IconButton(
              icon: Icon(Icons.refresh), onPressed: () {
                bookingProvider.loadBookedSeatsForMovie(movie.title);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Refreshing seat availability...'), duration: Duration(seconds: 2),
                  ),
                );
              },
              tooltip: 'Refresh seat availability',
            ),
        ],
      ),
      body: Column(
        children: [
          _buildMovieInfo_Anisa(movie, context),
          _buildScreenLabel_Anisa(),
          
          // Loading indicator jika sedang load booked seats
          if (bookingProvider.isLoadingBookedSeats)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8), child: LinearProgressIndicator(),
            ),
          
          _buildSeatGrid_Anisa(bookingProvider, movie),
          _buildLegend_Anisa(),
          _CheckoutSection( provider: bookingProvider, onCheckout: () => _checkout_Anisa(context, bookingProvider)),
        ],
      ),
    );
  }

  Widget _buildMovieInfo_Anisa(MovieModel_Febriyan movie, BuildContext context) {
    bool hasLongTitleTax = movie.title.length > 10;
    int bookedSeatsCount = Provider.of<BookingProvider_Tio>(context).bookedSeatsForMovie.length;

    return Card(
      margin: EdgeInsets.all(16),
      child: ListTile(
        leading: Image.network( movie.poster_url, width: 60, height: 80, fit: BoxFit.cover, errorBuilder: (_, __, ___) => Icon(Icons.movie, size: 40)),
        title: Text(movie.title, style: TextStyle(fontWeight: FontWeight.bold), maxLines: 2),
        subtitle: Column( crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Base Price: Rp ${movie.base_price}'),
            if (hasLongTitleTax)
              Text('+ Long Title Tax: Rp 2.500', style: TextStyle(color: Colors.orange)),
            Text('Duration: ${movie.duration} min'),
            Text('Rating: ${movie.rating}/5.0'),
            SizedBox(height: 4),
            Text(
              'Booked seats: $bookedSeatsCount/${rowLabels.length * seatsPerRow}',
              style: TextStyle( fontSize: 12, color: bookedSeatsCount > 0 ? Colors.red : Colors.green, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScreenLabel_Anisa() {
    return Column(
      children: [
        Container( 
          margin: EdgeInsets.symmetric(vertical: 20), height: 20, width: double.infinity, 
          decoration: BoxDecoration( 
            gradient: LinearGradient(
              colors: [Colors.grey[300]!, Colors.grey[100]!, Colors.grey[300]!], begin: Alignment.centerLeft, end: Alignment.centerRight),
            borderRadius: BorderRadius.circular(5)),
          child: Center( child: Text('SCREEN', style: TextStyle( fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black54, letterSpacing: 5))),
        ),
        SizedBox(height: 10),
      ],
    );
  }

  Widget _buildSeatGrid_Anisa(BookingProvider_Tio provider, MovieModel_Febriyan movie) {
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
                    width: 30, alignment: Alignment.center,
                    child: Text(rowLabels[rowIndex], style: TextStyle( fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: List.generate(seatsPerRow, (colIndex) {
                          String seatNumber = '${rowLabels[rowIndex]}${colIndex + 1}';
                          
                          // Gunakan data REAL dari Firestore via provider
                          bool isBooked = provider.bookedSeatsForMovie.contains(seatNumber);

                          return SeatItem_Anisa(
                            seatNumber: seatNumber, isSelected: provider.selectedSeats.contains(seatNumber), isBooked: isBooked, onTap: () {
                              if (!isBooked) {
                                provider.toggleSeat_Tio(seatNumber);
                              } else {
                                // Beri feedback ke user bahwa seat sudah dibooking
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Seat $seatNumber is already booked!'), backgroundColor: Colors.red, duration: Duration(seconds: 2)),
                                );
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
      padding: EdgeInsets.all(16), child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildLegendItem_Anisa( Colors.grey[300]!, 'Available', Icons.event_seat),
              _buildLegendItem_Anisa( Colors.blue[400]!, 'Selected', Icons.event_seat),
              _buildLegendItem_Anisa( Colors.red[400]!, 'Booked', Icons.event_seat),
            ],
          ),
          SizedBox(height: 8),
          Text(
            'Red seats are already booked by other users',
            style: TextStyle(fontSize: 12, color: Colors.grey),
            textAlign: TextAlign.center,
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

  Future<void> _checkout_Anisa(BuildContext context, BookingProvider_Tio provider) async {
    // Simpan data untuk ditampilkan di confirmation
    final movieTitle = provider.selectedMovie?.title ?? '';
    final selectedSeats = List<String>.from(provider.selectedSeats);
    final totalPrice = provider.totalPrice;

    // Validasi login
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

    // Validasi: cek ulang apakah seat masih available
    for (String seat in selectedSeats) {
      if (provider.bookedSeatsForMovie.contains(seat)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Seat $seat is no longer available! Please refresh and select different seats.'), backgroundColor: Colors.red, duration: Duration(seconds: 3),
          ),
        );
        return;
      }
    }

    // Show confirmation dialog
    final shouldProceed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirm Booking'), content: SingleChildScrollView( child: Column( mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Movie: $movieTitle', style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text('Seats: ${selectedSeats.join(", ")}'),
              SizedBox(height: 8),
              Text('Total: Rp $totalPrice'),
              SizedBox(height: 8),
              Divider(),
              if (movieTitle.length > 10)
                Padding(
                  padding: EdgeInsets.only(bottom: 4),
                  child: Text('• Long Title Tax: Rp 2,500 x ${selectedSeats.length} seat(s)'),
                ),
              _buildPriceBreakdown_Anisa(selectedSeats),
            ],
          ),
        ),
        actions: [
          TextButton( onPressed: () => Navigator.pop(context, false), child: Text('Cancel')),
          ElevatedButton( onPressed: () => Navigator.pop(context, true), child: Text('Confirm & Pay')),
        ],
      ),
    );

    if (shouldProceed == true) {
      await _processBooking_Anisa(context, provider, movieTitle, selectedSeats, totalPrice);
    }
  }

  Widget _buildPriceBreakdown_Anisa(List<String> selectedSeats) {
    int evenSeatsCount = selectedSeats.where((seat) {
      int seatNumber = int.tryParse(seat.substring(1)) ?? 0;
      return seatNumber % 2 == 0;
    }).length;

    if (evenSeatsCount > 0) {
      return Text('• Even Seat Discount (10%): $evenSeatsCount seat(s)');
    }
    return SizedBox();
  }

  Future<void> _processBooking_Anisa(
    BuildContext context,
    BookingProvider_Tio provider,
    String movieTitle,
    List<String> selectedSeats,
    int totalPrice,
  ) async {
    // Show loading dialog
    showDialog(
      context: context, barrierDismissible: false,
      builder: (context) => AlertDialog( content: Column( mainAxisSize: MainAxisSize.min, children: [
            CircularProgressIndicator(),
            SizedBox(height: 20),
            Text('Processing booking...\nPlease wait.', textAlign: TextAlign.center),
          ],
        ),
      ),
    );

    try {
      // Proses checkout
      final bookingId = await provider.checkout_Tio();
      
      // Close loading dialog
      Navigator.pop(context);
      
      // Show success dialog dengan detail lengkap
      await showDialog(
        context: context, barrierDismissible: false,
        builder: (context) => AlertDialog( icon: Icon(Icons.check_circle, color: Colors.green, size: 60),
          title: Text(
            'Booking Successful!',
            style: TextStyle( fontWeight: FontWeight.bold, color: Colors.green),
          ),
          content: SingleChildScrollView(
            child: Column( mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Movie: $movieTitle', style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 8), Text('Seats: ${selectedSeats.join(", ")}'),
                SizedBox(height: 8), Text('Total Paid: Rp $totalPrice'),
                SizedBox(height: 8), Text('Booking ID: ${bookingId.substring(0, 8)}...', style: TextStyle(fontSize: 12, color: Colors.grey)),
                SizedBox(height: 16),
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration( border: Border.all(color: Colors.blue), borderRadius: BorderRadius.circular(8)),
                  child: Column(
                    children: [
                      Icon(Icons.qr_code, size: 40, color: Colors.blue),
                      SizedBox(height: 8),
                      Text('Show this QR Code at cinema', style: TextStyle(fontSize: 12, color: Colors.grey)),
                      SizedBox(height: 8),
                      Container( width: 120, height: 120, color: Colors.grey[200],
                        child: Center(
                          child: Text('QR CODE', style: TextStyle( fontWeight: FontWeight.bold, color: Colors.black54)),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 8),
                Text( 'Note: Your selected seats are now marked as booked (red)', style: TextStyle(fontSize: 12, color: Colors.green)),
              ],
            ),
          ),
          actions: [
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Clear seats setelah user melihat success
                  provider.clearSeats_Tio();
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
                child: Text('Back to Home'),
              ),
            ),
          ],
        ),
      );

    } catch (e) {
      // Close loading dialog
      Navigator.pop(context);
      
      // Show error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Booking failed: ${e.toString().replaceFirst("Checkout failed: ", "")}'),
          backgroundColor: Colors.red, duration: Duration(seconds: 4), action: SnackBarAction(
            label: 'RETRY', onPressed: () {
              _processBooking_Anisa(context, provider, movieTitle, selectedSeats, totalPrice);
            },
          ),
        ),
      );
    }
  }
}

// Checkout Section sebagai StatefulWidget
class _CheckoutSection extends StatefulWidget {
  final BookingProvider_Tio provider;
  final VoidCallback onCheckout;

  const _CheckoutSection({
    required this.provider,
    required this.onCheckout,
  });

  @override
  __CheckoutSectionState createState() => __CheckoutSectionState();
}

class __CheckoutSectionState extends State<_CheckoutSection> {
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    final provider = widget.provider;
    
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only( topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        boxShadow: [ BoxShadow( color: Colors.black12, blurRadius: 10, spreadRadius: 2)],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column( crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Selected Seats', style: TextStyle(color: Colors.grey, fontSize: 14)),
                    SizedBox(height: 4),
                    Container(
                      height: 40, child: provider.selectedSeats.isNotEmpty
                          ? ListView(
                              scrollDirection: Axis.horizontal,
                              children: provider.selectedSeats.map((seat) {
                                return Container(
                                  margin: EdgeInsets.only(right: 8), padding: EdgeInsets.symmetric( horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.blue[50], borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: Colors.blue[100]!)),
                                  child: Text(seat, style: TextStyle( fontWeight: FontWeight.bold)),
                                );
                              }).toList(),
                            )
                          : Text('No seats selected', style: TextStyle(fontStyle: FontStyle.italic)),
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
                    style: TextStyle( fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green[700]),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 20),
          SizedBox(
            width: double.infinity, height: 50,
            child: ElevatedButton(
              onPressed: provider.selectedSeats.isEmpty || 
                        _isProcessing || 
                        provider.isCheckingOut
                  ? null
                  : () async {
                      if (_isProcessing) return;
                      
                      setState(() => _isProcessing = true);
                      try {
                        widget.onCheckout();
                      } finally {
                        setState(() => _isProcessing = false);
                      }
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: provider.selectedSeats.isEmpty || 
                                _isProcessing || 
                                provider.isCheckingOut
                    ? Colors.grey
                    : Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 3,
              ),
              child: _isProcessing || provider.isCheckingOut
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox( width: 20, height: 20, child: CircularProgressIndicator( strokeWidth: 2, color: Colors.white)),
                        SizedBox(width: 10),
                        Text('PROCESSING...', style: TextStyle(fontSize: 16, color: Colors.white)),
                      ],
                    )
                  : Row(
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
    Color seatColor; Color borderColor; Color textColor;
    
    if (isBooked) {
      seatColor = Colors.red[400]!; borderColor = Colors.red[700]!; textColor = Colors.white;
    } else if (isSelected) {
      seatColor = Colors.blue[400]!; borderColor = Colors.blue[700]!; textColor = Colors.white;
    } else {
      seatColor = Colors.grey[300]!; borderColor = Colors.grey[400]!; textColor = Colors.black;
    }

    int seatNum = int.tryParse(seatNumber.substring(1)) ?? 0;

    return GestureDetector(
      onTap: isBooked ? null : onTap,
      child: Container(
      width: 35, height: 35, margin: EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: seatColor,
          borderRadius: BorderRadius.circular(6),
          border: Border.all( color: borderColor, width: isSelected || isBooked ? 2 : 1),
          boxShadow: [
            if (isSelected || isBooked)
              BoxShadow( color: borderColor.withOpacity(0.5), blurRadius: 3, offset: Offset(0, 1)),
          ],
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text( seatNumber.substring(0, 1), style: TextStyle( fontSize: 10, fontWeight: FontWeight.bold, color: textColor)),
              Text( seatNum.toString(), style: TextStyle( fontSize: 12, fontWeight: FontWeight.bold, color: textColor)),
            ],
          ),
        ),
      ),
    );
  }
}