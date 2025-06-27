part of 'history_cubit.dart';

abstract class HistoryState extends Equatable {
  const HistoryState();

  @override
  List<Object?> get props => [];
}

class HistoryInitial extends HistoryState {}

class HistoryLoading extends HistoryState {}

class HistoryLoaded extends HistoryState {
  final List<OrderModel> orders;
  const HistoryLoaded(this.orders);

  @override
  List<Object?> get props => [orders];
}

class HistoryFailure extends HistoryState {
  final String message;
  const HistoryFailure(this.message);

  @override
  List<Object?> get props => [message];
}
