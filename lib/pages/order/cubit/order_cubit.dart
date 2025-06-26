import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../models/order_model.dart';

part 'order_state.dart';

class OrderCubit extends Cubit<OrderState> {
  OrderCubit() : super(OrderInitial());

  Future<void> submitOrder(OrderModel order) async {
    emit(OrderLoading());
    try {
      final activeOrder = await FirebaseFirestore.instance
          .collection('orders')
          .where('userId', isEqualTo: order.userId)
          .where(
            'status',
            whereIn: [
              OrderStatus.pending.name,
              OrderStatus.confirmed.name,
              OrderStatus.pickingUp.name,
              OrderStatus.onTheWay.name,
            ],
          )
          .limit(1)
          .get();

      if (activeOrder.docs.isNotEmpty) {
        emit(OrderFailure('Anda masih memiliki pesanan yang sedang berjalan.'));
        return;
      }
      await FirebaseFirestore.instance
          .collection('orders')
          .doc(order.id)
          .set(order.toFirestore());
      emit(OrderSuccess(order));
    } catch (e) {
      emit(OrderFailure('Gagal membuat pesanan. Silakan coba lagi.'));
    }
  }
}
