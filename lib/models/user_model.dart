// user_model.dart

import 'package:cloud_firestore/cloud_firestore.dart';

enum UserRole { courier, customer }

// ✅ Extension diletakkan di bawah enum
extension UserRoleExtension on UserRole {
  String get displayName {
    switch (this) {
      case UserRole.customer:
        return 'Pelanggan';
      case UserRole.courier:
        return 'Kurir';
    }
  }

  String get description {
    switch (this) {
      case UserRole.customer:
        return 'Buat dan lacak pesanan';
      case UserRole.courier:
        return 'Ambil dan antar pesanan';
    }
  }
}

class UserModel {
  final String id;
  final String name;
  final String? email;
  final String phone;
  final UserRole role;
  final String? fcmToken;
  final GeoPoint? location;
  final DateTime? lastLocationUpdated;
  final DateTime? lastLogin;
  final DateTime? createdAt;
  final bool isOnline;

  UserModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.role,
    this.lastLocationUpdated,
    this.email,
    this.fcmToken,
    this.location,
    this.lastLogin,
    this.createdAt,
    this.isOnline = true,
  });

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return UserModel(
      id: doc.id,
      name: data['name'] ?? '',
      email: data['email'],
      phone: data['phone'] ?? '',

      role: _stringToRole(data['role']),
      fcmToken: data['fcmToken'],
      location: data['location'],
      lastLocationUpdated: (data['lastLocationUpdated'] as Timestamp?)
          ?.toDate(),
      lastLogin: (data['lastLogin'] as Timestamp?)?.toDate(),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      isOnline: data['isOnline'] ?? true,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'role': role.name,
      'fcmToken': fcmToken,
      'location': location,
      'lastLocationUpdated': lastLocationUpdated,
      'lastLogin': lastLogin != null ? Timestamp.fromDate(lastLogin!) : null,
      'createdAt': createdAt != null
          ? Timestamp.fromDate(createdAt!)
          : Timestamp.now(),
      'isOnline': isOnline,
    };
  }

  static UserRole _stringToRole(String? role) {
    return UserRole.values.firstWhere(
      (e) => e.name == role,
      orElse: () => UserRole.customer,
    );
  }
}
