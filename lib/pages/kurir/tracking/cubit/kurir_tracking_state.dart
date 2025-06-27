part of 'kurir_tracking_cubit.dart';

sealed class KurirTrackingState extends Equatable {
  const KurirTrackingState();

  @override
  List<Object> get props => [];
}

final class KurirTrackingInitial extends KurirTrackingState {}

final class KurirTrackingLoading extends KurirTrackingState {}

final class KurirTrackingLoaded extends KurirTrackingState {
  final List<OrderModel> orders;
  const KurirTrackingLoaded(this.orders);

  @override
  List<Object> get props => [orders];
}

final class KurirTrackingFailure extends KurirTrackingState {
  final String message;
  const KurirTrackingFailure(this.message);

  @override
  List<Object> get props => [message];
}
