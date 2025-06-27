import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../models/order_model.dart';
import '../../../../util/session_manager.dart';

part 'kurir_history_state.dart';

class KurirHistoryCubit extends Cubit<KurirHistoryState> {
  KurirHistoryCubit() : super(KurirHistoryInitial());

  Future<void> fetchHistory() async {
    emit(KurirHistoryLoading());
    try {
      final kurirId = await SessionManager.getUserId();
      final query = await FirebaseFirestore.instance
          .collection('orders')
          .where('courierId', isEqualTo: kurirId)
          .where(
            'status',
            whereIn: [OrderStatus.delivered.name, OrderStatus.cancelled.name],
          )
          .orderBy('createdAt', descending: true)
          .get();
      final orders = query.docs
          .map((doc) => OrderModel.fromFirestore(doc))
          .toList();
      emit(KurirHistoryLoaded(orders));
    } catch (e) {
      emit(KurirHistoryFailure('Gagal memuat riwayat pesanan'));
    }
  }
}
