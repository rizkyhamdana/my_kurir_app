import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../models/user_model.dart';
import '../../../../util/session_manager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'kurir_profile_state.dart';

class KurirProfileCubit extends Cubit<KurirProfileState> {
  KurirProfileCubit() : super(KurirProfileInitial());

  Future<void> fetchProfile() async {
    emit(KurirProfileLoading());
    try {
      final userId = await SessionManager.getUserId();
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      if (doc.exists) {
        final user = UserModel.fromFirestore(doc);
        emit(KurirProfileLoaded(user));
      } else {
        emit(KurirProfileFailure('Data kurir tidak ditemukan.'));
      }
    } catch (e, stackTrace) {
      print('Error fetching profile: $e');
      emit(KurirProfileFailure('Gagal memuat profil.'));
    }
  }
}
