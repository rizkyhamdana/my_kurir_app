import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    required String role, // 'customer' atau 'courier'
  }) async {
    emit(AuthLoading());
    try {
      final email = Utility.phoneToEmail(phone);
      final UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(
            email: email,
            password: password, // dari input user
          );
      final savedToken = await SessionManager.getFcmToken();
      final userId = userCredential.user?.uid;

      await FirebaseFirestore.instance.collection('users').doc(userId).set({
        'name': name,
        'role': role,
        'phone': phone,
        'fcmToken': savedToken,
        'address': address,
        'currentOrderId': null,
        'location': null,
        'createdAt': FieldValue.serverTimestamp(),
      });

      emit(AuthSuccess(userCredential.user));
    } on FirebaseAuthException catch (e, stackTrace) {
      print('FirebaseAuthException: $e\n$stackTrace');
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
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      final role = userDoc['role'] ?? 'customer';

      // Validasi role jika perlu
      if ((expectedRole == 'kurir' && role != 'courier' && role != 'kurir') ||
          (expectedRole == 'pelanggan' &&
              role != 'customer' &&
              role != 'pelanggan')) {
        emit(AuthFailure('Role akun tidak sesuai'));
        return;
      }

      emit(AuthSuccess(userCredential.user));
    } on FirebaseAuthException catch (e) {
      emit(AuthFailure(e.message ?? 'Login gagal'));
    } catch (e) {
      emit(AuthFailure('Terjadi kesalahan'));
    }
  }
}
