import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/booking_provider.dart';
import 'screens/auth/login_screen_rakha.dart';
import 'screens/home/home_screen_rakha.dart';
import 'screens/seat/seat_selection_screen_anisa.dart';
import 'screens/profile/profile_screen_anisa.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => BookingProvider_Tio(),
      child: MaterialApp(
        title: 'CineBooking',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: LoginScreen_Rakha(),
        routes: {
          '/home': (context) => HomeScreen_Rakha(),
          '/seat': (context) => SeatSelectionScreen_Anisa(),
          '/profile': (context) => ProfileScreen_Anisa(),
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}