import 'package:cinema_pro/models/movie_model_all_febriyan.dart';
import 'package:cinema_pro/providers/booking_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/booking_provider.dart';

class SeatSelectionScreen_Anisa extends StatelessWidget {
  final List<String> rowLabels = ['A', 'B', 'C', 'D', 'E', 'F']; // 6 baris
  final int seatsPerRow = 8; // 8 kolom

  @override
  Widget build(BuildContext context) {
    final bookingProvider = Provider.of<BookingProvider_Tio>(context);
    final movie = bookingProvider.selectedMovie;

    if (movie == null) {
      return Scaffold(
        appBar: AppBar(title: Text('Select Seats')),
        body: Center(child: Text('No movie selected')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Select Seats'),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          // 1. INFO FILM
          _buildMovieInfo_Anisa(movie),
          
          // 2. LABEL "SCREEN"
          _buildScreenLabel_Anisa(),
          
          // 3. GRID KURSI 6x8
          _buildSeatGrid_Anisa(bookingProvider),
          
          // 4. LEGENDA WARNA
          _buildLegend_Anisa(),
          
          // 5. CHECKOUT SECTION
          _buildCheckoutSection_Anisa(bookingProvider, context),
        ],
      ),
    );
  }

  // ============= METHOD 1: INFO FILM =============
  Widget _buildMovieInfo_Anisa(MovieModel_Febriyan movie) {
    return Card(
      margin: EdgeInsets.all(16),
      child: ListTile(
        leading: Image.network(
          movie.posterior1,
          width: 60,
          height: 80,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Icon(Icons.movie, size: 40),
        ),
        title: Text(
          movie.title,
          style: TextStyle(fontWeight: FontWeight.bold),
          maxLines: 2,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Base Price: Rp ${movie.base_price}'),
            if (movie.title.length > 10)
              Text('+ Long Title Tax: Rp 2.500', 
                   style: TextStyle(color: Colors.orange)),
          ],
        ),
      ),
    );
  }

  // ============= METHOD 2: LABEL "SCREEN" =============
  Widget _buildScreenLabel_Anisa() {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 20),
          height: 3,
          width: 250,
          color: Colors.grey,
        ),
        Text('SCREEN', 
             style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        SizedBox(height: 20),
      ],
    );
  }

  // ============= METHOD 3: GRID KURSI 6x8 =============
  Widget _buildSeatGrid_Anisa(BookingProvider_Tio provider) {
    return Expanded(
      child: ListView.builder(
        itemCount: rowLabels.length,
        itemBuilder: (context, rowIndex) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
            child: Row(
              children: [
                // Label baris (A, B, C, ...)
                SizedBox(
                  width: 30, 
                  child: Text(
                    rowLabels[rowIndex], 
                    style: TextStyle(fontWeight: FontWeight.bold)
                  )
                ),
                SizedBox(width: 10),
                
                // 8 kursi per baris
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(seatsPerRow, (colIndex) {
                      String seatNumber = '${rowLabels[rowIndex]}${colIndex + 1}';
                      return SeatItem_Anisa(
                        seatNumber: seatNumber,
                        isSelected: provider.selectedSeats.contains(seatNumber),
                        onTap: () => provider.toggleSeat_Tio(seatNumber),
                      );
                    }),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // ============= METHOD 4: LEGENDA =============
  Widget _buildLegend_Anisa() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildLegendItem_Anisa(Colors.grey, 'Available'),
          _buildLegendItem_Anisa(Colors.blue, 'Selected'),
          _buildLegendItem_Anisa(Colors.red, 'Booked'),
        ],
      ),
    );
  }

  Widget _buildLegendItem_Anisa(Color color, String text) {
    return Row(
      children: [
        Container(width: 16, height: 16, color: color),
        SizedBox(width: 6),
        Text(text),
      ],
    );
  }

  // ============= METHOD 5: CHECKOUT SECTION =============
  Widget _buildCheckoutSection_Anisa(
    BookingProvider_Tio provider, 
    BuildContext context
  ) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Selected Seats', style: TextStyle(color: Colors.grey)),
                  Text(
                    provider.selectedSeats.join(', '), 
                    style: TextStyle(fontWeight: FontWeight.bold)
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('Total Price', style: TextStyle(color: Colors.grey)),
                  Text(
                    'Rp ${provider.totalPrice}', 
                    style: TextStyle(
                      fontSize: 20, 
                      fontWeight: FontWeight.bold, 
                      color: Colors.green
                    )
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: provider.selectedSeats.isEmpty 
                  ? null 
                  : () => _checkout_Anisa(context, provider),
              child: Text('CHECKOUT', style: TextStyle(fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }

  // ============= LOGIC CHECKOUT =============
  void _checkout_Anisa(BuildContext context, BookingProvider_Tio provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirm Booking'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Movie: ${provider.selectedMovie!.title}'),
            Text('Seats: ${provider.selectedSeats.join(', ')}'),
            Text('Total: Rp ${provider.totalPrice}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), 
            child: Text('Cancel')
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showSuccessDialog_Anisa(context);
            },
            child: Text('Confirm'),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog_Anisa(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 60),
            SizedBox(height: 16),
            Text('Booking Successful!', 
                 style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('Show QR Code at cinema'),
          ],
        ),
        actions: [
          Center(
            child: ElevatedButton(
              onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
              child: Text('OK'),
            ),
          ),
        ],
      ),
    );
  }
}

// ==================== WIDGET KURSI ====================
class SeatItem_Anisa extends StatelessWidget {
  final String seatNumber;
  final bool isSelected;
  final VoidCallback onTap;

  const SeatItem_Anisa({
    Key? key,
    required this.seatNumber,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Kursi yang sudah terjual (simulasi)
    List<String> bookedSeats = ['A2', 'B5', 'C3', 'D7', 'E1', 'F4'];
    bool isBooked = bookedSeats.contains(seatNumber);
    
    // LOGIC WARNA:
    Color seatColor = isBooked ? Colors.red : 
                     isSelected ? Colors.blue : Colors.grey;

    return GestureDetector(
      onTap: isBooked ? null : onTap, // Disabled jika sudah terjual
      child: Container(
        width: 35,
        height: 35,
        margin: EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: seatColor,
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
            color: isSelected ? Colors.blue[700]! : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Center(
          child: Text(
            seatNumber.substring(1), // Tampilkan hanya angka (A1 → "1")
            style: TextStyle(
              color: Colors.white, 
              fontWeight: FontWeight.bold, 
              fontSize: 12
            ),
          ),
        ),
      ),
    );
  }
}