part of 'order_cubit.dart';

abstract class OrderState extends Equatable {
  const OrderState();

  @override
  List<Object?> get props => [];
}

class OrderInitial extends OrderState {}

class OrderLoading extends OrderState {}

class OrderSuccess extends OrderState {
  final OrderModel order;
  const OrderSuccess(this.order);

  @override
  List<Object?> get props => [order];
}

class OrderFailure extends OrderState {
  final String message;
  const OrderFailure(this.message);

  @override
  List<Object?> get props => [message];
}
