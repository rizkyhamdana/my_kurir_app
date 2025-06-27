import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_kurir_app/models/user_model.dart';
import 'package:my_kurir_app/util/session_manager.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitial());

  Future<void> loadProfile() async {
    emit(ProfileLoading());
    try {
      final userId = await SessionManager.getUserId();
      if (userId == null || userId.isEmpty) {
        emit(ProfileNotLoggedIn());
        return;
      }
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      if (!doc.exists) {
        emit(ProfileFailure('User tidak ditemukan'));
        return;
      }
      final user = UserModel.fromFirestore(doc);
      await SessionManager.saveUserName(user.name);
      await SessionManager.saveUserPhone(user.phone);
      emit(ProfileLoaded(user));
    } catch (e) {
      emit(ProfileFailure('Gagal memuat profil'));
    }
  }

  Future<void> logout() async {
    await SessionManager.clearSession();
    emit(ProfileNotLoggedIn());
  }
}
