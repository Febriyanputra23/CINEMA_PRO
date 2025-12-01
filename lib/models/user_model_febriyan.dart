import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel_Febriyan {
  final String uid;
  final String email;
  final String username;
  final int balance;
  final DateTime created_at;

  UserModel_Febriyan({
    required this.uid,
    required this.email,
    required this.username,
    required this.balance,
    required this.created_at,
  });

  // Manual mapping
  factory UserModel_Febriyan.fromMap(Map<String, dynamic> map) {
    return UserModel_Febriyan(
      uid: map['uid'] ?? '',
      email: map['email'] ?? '',
      username: map['username'] ?? '',
      balance: map['balance'] ?? 0,
      created_at: (map['created_at'] as Timestamp).toDate(),
    );
  }

  // Manual mapping  
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'username': username,
      'balance': balance,
      'created_at': Timestamp.fromDate(created_at),
    };
  }
}