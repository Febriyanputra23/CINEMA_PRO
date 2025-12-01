// File: lib/screens/history/history_ticket_screen.dart
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class HistoryTicketScreen_Anisa extends StatefulWidget {
  @override
  _HistoryTicketScreen_AnisaState createState() => 
      _HistoryTicketScreen_AnisaState();
}

class _HistoryTicketScreen_AnisaState extends State<HistoryTicketScreen_Anisa> {
  // Data dummy untuk testing
  final List<Map<String, dynamic>> _dummyBookings = [
    {
      'id': 'BOOK001',
      'movie': 'Spider-Man: No Way Home',
      'date': '2024-01-15 14:30',
      'seats': ['A1', 'A2'],
      'total': 115500,
      'theater': 'Studio 1',
    },
    {
      'id': 'BOOK002',
      'movie': 'Avatar',
      'date': '2024-01-10 19:00',
      'seats': ['B3'],
      'total': 35000,
      'theater': 'Studio 2',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ticket History'),
        backgroundColor: Colors.blue,
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: _dummyBookings.length,
        itemBuilder: (context, index) {
          return _buildTicketCard_Anisa(_dummyBookings[index]);
        },
      ),
    );
  }

  Widget _buildTicketCard_Anisa(Map<String, dynamic> booking) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  booking['movie'],
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Chip(
                  label: Text('Completed'),
                  backgroundColor: Colors.green[100],
                ),
              ],
            ),
            SizedBox(height: 12),
            
            // Info
            _buildInfoRow_Anisa('Booking ID:', booking['id']),
            _buildInfoRow_Anisa('Date:', booking['date']),
            _buildInfoRow_Anisa('Seats:', booking['seats'].join(', ')),
            _buildInfoRow_Anisa('Theater:', booking['theater']),
            
            Divider(height: 24),
            
            // Total Price
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total Price',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Rp ${_formatPrice_Anisa(booking['total'])}',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[700],
                  ),
                ),
              ],
            ),
            
            SizedBox(height: 16),
            
            // QR Code Button
            ElevatedButton(
              onPressed: () => _showQrDialog_Anisa(booking['id']),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.qr_code),
                  SizedBox(width: 8),
                  Text('Show QR Code'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow_Anisa(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey[600],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  String _formatPrice_Anisa(int price) {
    // Format manual tanpa intl package
    return price.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (match) => '${match[1]}.',
    );
  }

  void _showQrDialog_Anisa(String bookingId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Your Ticket QR Code'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            QrImageView(
              data: bookingId,
              version: QrVersions.auto,
              size: 200,
              backgroundColor: Colors.white,
            ),
            SizedBox(height: 16),
            Text(
              'Booking ID: $bookingId',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Scan at cinema entrance',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }
}