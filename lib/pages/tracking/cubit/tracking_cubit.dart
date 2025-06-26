import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_kurir_app/util/session_manager.dart';
import '../../../models/order_model.dart';

part 'tracking_state.dart';

class TrackingCubit extends Cubit<TrackingState> {
  TrackingCubit() : super(TrackingInitial());

  Future<void> fetchActiveOrder() async {
    emit(TrackingLoading());
    try {
      final userId = await SessionManager.getUserId();
      final query = await FirebaseFirestore.instance
          .collection('orders')
          .where('userId', isEqualTo: userId)
          .where(
            'status',
            whereIn: [
              OrderStatus.pending.name,
              OrderStatus.confirmed.name,
              OrderStatus.pickingUp.name,
              OrderStatus.onTheWay.name,
            ],
          )
          .orderBy('createdAt', descending: true)
          .limit(1)
          .get();

      if (query.docs.isEmpty) {
        emit(TrackingNoActiveOrder());
      } else {
        final order = OrderModel.fromFirestore(query.docs.first);
        emit(TrackingLoaded(order));
      }
    } catch (e, stackTrace) {
      print('Error fetching active order: $e\n$stackTrace');
      emit(TrackingFailure('Gagal memuat pesanan aktif'));
    }
  }

  Future<void> cancelOrder(String orderId) async {
    emit(TrackingLoading());
    try {
      await FirebaseFirestore.instance
          .collection('orders')
          .doc(orderId)
          .update({
            'status': OrderStatus.cancelled.name,
            'cancelledAt': FieldValue.serverTimestamp(),
          });
      // Setelah cancel, fetch ulang pesanan aktif
      await fetchActiveOrder();
    } catch (e, stackTrace) {
      print('Error cancelling order: $e\n$stackTrace');
      emit(TrackingFailure('Gagal membatalkan pesanan'));
    }
  }
}
