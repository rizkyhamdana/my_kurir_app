part of 'kurir_history_cubit.dart';

sealed class KurirHistoryState extends Equatable {
  const KurirHistoryState();

  @override
  List<Object> get props => [];
}

final class KurirHistoryInitial extends KurirHistoryState {}

final class KurirHistoryLoading extends KurirHistoryState {}

final class KurirHistoryLoaded extends KurirHistoryState {
  final List<OrderModel> orders;
  const KurirHistoryLoaded(this.orders);

  @override
  List<Object> get props => [orders];
}

final class KurirHistoryFailure extends KurirHistoryState {
  final String message;
  const KurirHistoryFailure(this.message);

  @override
  List<Object> get props => [message];
}
