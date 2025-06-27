import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:my_kurir_app/util/session_manager.dart';
import 'package:equatable/equatable.dart';

part 'kurir_home_state.dart';

class KurirHomeCubit extends Cubit<KurirHomeState> {
  KurirHomeCubit() : super(KurirHomeInitial());

  Timer? _locationTimer;

  Future<void> startLocationUpdates() async {
    final kurirId = await SessionManager.getUserId();
    // Minta izin lokasi
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return;
    }
    // Update lokasi setiap 20 detik
    _locationTimer = Timer.periodic(const Duration(seconds: 20), (_) async {
      Position pos = await Geolocator.getCurrentPosition();
      await FirebaseFirestore.instance.collection('users').doc(kurirId).update({
        'location': GeoPoint(pos.latitude, pos.longitude),
        'lastLocationUpdated': FieldValue.serverTimestamp(),
      });
    });
  }

  void stopLocationUpdates() {
    _locationTimer?.cancel();
  }

  Future<void> setOnlineStatus(bool isOnline) async {
    emit(KurirHomeStatusLoading());
    try {
      final kurirId = await SessionManager.getUserId();
      await FirebaseFirestore.instance.collection('users').doc(kurirId).update({
        'isOnline': isOnline,
      });
      emit(KurirHomeStatusSuccess(isOnline));
    } catch (e) {
      emit(KurirHomeStatusFailure('Gagal update status online'));
    }
  }

  @override
  Future<void> close() {
    _locationTimer?.cancel();
    return super.close();
  }
}
