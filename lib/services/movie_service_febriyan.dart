import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/movie_model_all_febriyan.dart';
import '../models/booking_model_febriyan.dart';
import '../models/user_model_febriyan.dart';

class FirebaseService_Febriyan {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // ================= AUTH METHODS =================
  Future<User?> signInWithEmail_Febriyan(String email, String password) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential.user;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<User?> registerWithEmail_Febriyan(
    String email,
    String password,
    String username,
  ) async {
    try {
      if (!email.endsWith('@student.univ.ac.id')) {
        throw 'Email must be @student.univ.ac.id';
      }

      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await _firestore.collection('users').doc(credential.user!.uid).set({
        'uid': credential.user!.uid,
        'email': email,
        'username': username,
        'balance': 0,
        'created_at': Timestamp.now(),
      });

      return credential.user;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> signOut_Febriyan() async {
    await _auth.signOut();
  }

  // ================= MOVIE METHODS (YANG DIPERBAIKI) =================
  
  Stream<List<MovieModel_Febriyan>> getMovies_Febriyan() {
    return _firestore.collection('movies').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        // PERBAIKAN: Gunakan 2 parameter (Data + ID)
        return MovieModel_Febriyan.fromMap(
          doc.data() as Map<String, dynamic>, 
          doc.id
        );
      }).toList();
    });
  }

  Future<MovieModel_Febriyan> getMovieById_Febriyan(String movieId) async {
    try {
      var doc = await _firestore.collection('movies').doc(movieId).get();
      if (doc.exists) {
        // PERBAIKAN: Gunakan 2 parameter (Data + ID)
        return MovieModel_Febriyan.fromMap(
          doc.data() as Map<String, dynamic>, 
          doc.id
        );
      } else {
        throw 'Movie not found';
      }
    } catch (e) {
      throw e.toString();
    }
  }

  // ================= BOOKING METHODS =================
  
  Future<void> createBooking_Febriyan(BookingModel_Febriyan booking) async {
    try {
      await _firestore
          .collection('bookings')
          .doc(booking.booking_id)
          .set(booking.toMap());
    } catch (e) {
      throw e.toString();
    }
  }

  Stream<List<BookingModel_Febriyan>> getUserBookings_Febriyan(String userId) {
    return _firestore
        .collection('bookings')
        .where('user_id', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
            // Note: Kalau BookingModel masih versi lama (1 parameter), baris ini benar.
            // Kalau BookingModel diupdate juga, sesuaikan seperti MovieModel.
            data['booking_id'] = doc.id; 
            return BookingModel_Febriyan.fromMap(data);
          }).toList();
        });
  }

  // ================= USER METHODS =================

  Future<UserModel_Febriyan> getUserData_Febriyan(String userId) async {
    try {
      var doc = await _firestore.collection('users').doc(userId).get();
      if (doc.exists) {
        Map<String, dynamic> data = doc.data()!;
        data['uid'] = doc.id;
        return UserModel_Febriyan.fromMap(data);
      } else {
        throw 'User not found';
      }
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> updateUserBalance_Febriyan(String userId, int newBalance) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'balance': newBalance,
      });
    } catch (e) {
      throw e.toString();
    }
  }

  User? getCurrentUser_Febriyan() {
    return _auth.currentUser;
  }
}