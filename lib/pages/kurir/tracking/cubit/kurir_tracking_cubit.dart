import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../models/order_model.dart';
import '../../../../util/session_manager.dart';

part 'kurir_tracking_state.dart';

class KurirTrackingCubit extends Cubit<KurirTrackingState> {
  KurirTrackingCubit() : super(KurirTrackingInitial());

  Future<void> fetchActiveOrders() async {
    emit(KurirTrackingLoading());
    try {
      final kurirId = await SessionManager.getUserId();
      final query = await FirebaseFirestore.instance
          .collection('orders')
          .where('courierId', isEqualTo: kurirId)
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
          .get();

      final orders = query.docs
          .map((doc) => OrderModel.fromFirestore(doc))
          .toList();
      emit(KurirTrackingLoaded(orders));
    } catch (e) {
      emit(KurirTrackingFailure('Gagal memuat pesanan aktif'));
    }
  }

  // Tambahkan fungsi update status jika perlu
  Future<void> updateOrderStatus(String orderId, OrderStatus newStatus) async {
    emit(KurirTrackingLoading());
    try {
      final Map<String, dynamic> updateData = {'status': newStatus.name};
      if (newStatus == OrderStatus.pickingUp) {
        updateData['pickingUpAt'] = DateTime.now();
      } else if (newStatus == OrderStatus.onTheWay) {
        updateData['onTheWayAt'] = DateTime.now();
      } else if (newStatus == OrderStatus.confirmed) {
        updateData['confirmedAt'] = DateTime.now();
      } else if (newStatus == OrderStatus.cancelled) {
        updateData['cancelledAt'] = DateTime.now();
      }
      await FirebaseFirestore.instance
          .collection('orders')
          .doc(orderId)
          .update(updateData);
      await fetchActiveOrders();
    } catch (e) {
      emit(KurirTrackingFailure('Gagal update status pesanan'));
    }
  }
}
