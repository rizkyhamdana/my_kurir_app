import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_kurir_app/models/user_model.dart';
import 'package:my_kurir_app/util/session_manager.dart';
import 'package:my_kurir_app/util/utility.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final FirebaseAuth _firebaseAuth;

  AuthCubit({FirebaseAuth? firebaseAuth})
    : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
      super(AuthInitial());

  Future<void> registerWithPhone({
    required String phone,
    required String password, // dari input user

    required String name,
    required String
    address, // alamat tidak digunakan di sini, tapi bisa disimpan di Firestore jika perlu
  }) async {
    emit(AuthLoading());
    try {
      final email = Utility.phoneToEmail(phone);
      final UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(
            email: email,
            password: password, // dari input user
          );
      final userId = userCredential.user?.uid;

      if (userId != null) {
        final userModel = UserModel(
          id: userId,
          name: name,
          email: email,
          phone: phone,
          role: UserRole.customer, // ← ini enum-nya
          fcmToken: await SessionManager.getFcmToken(),
          location: null,

          createdAt: DateTime.now(),
          lastLogin: DateTime.now(),
        );

        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .set(userModel.toFirestore());
      }

      emit(AuthSuccess(userCredential.user));
    } on FirebaseAuthException catch (e, stackTrace) {
      log('FirebaseAuthException: $e\n$stackTrace');
      emit(AuthFailure(e.message ?? 'Registrasi gagal'));
    } catch (e) {
      emit(AuthFailure('Terjadi kesalahan'));
    }
  }

  // Tambahkan login, logout, dsb jika perlu
  Future<void> loginWithEmail({
    required String email,
    required String password,
    required String expectedRole, // 'kurir' atau 'pelanggan'
  }) async {
    emit(AuthLoading());
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      // Cek role user di Firestore
      final userId = userCredential.user?.uid;
      final userDocRef = FirebaseFirestore.instance
          .collection('users')
          .doc(userId);
      final userDoc = await userDocRef.get();
      final role = userDoc['role'] ?? 'customer';
      log('User role: $role');
      log('Expected role: $expectedRole');
      log('User Role Courier: ${UserRole.courier.name}');
      log('User Role Customer: ${UserRole.customer.name}');
      // Validasi role jika perlu
      if ((expectedRole == UserRole.courier.name &&
              role != UserRole.courier.name) ||
          (expectedRole == UserRole.customer.name &&
              role != UserRole.customer.name)) {
        emit(AuthFailure('Role akun tidak sesuai'));
        return;
      }

      final fcmToken = await SessionManager.getFcmToken();
      await userDocRef.update({
        'fcmToken': fcmToken,
        'lastLogin': DateTime.now(),
        'isOnline': true,
      });

      emit(AuthSuccess(userCredential.user));
    } on FirebaseAuthException catch (e) {
      emit(AuthFailure(e.message ?? 'Login gagal'));
    } catch (e) {
      emit(AuthFailure('Terjadi kesalahan'));
    }
  }
}
