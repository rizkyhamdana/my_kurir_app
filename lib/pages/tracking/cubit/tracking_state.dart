part of 'tracking_cubit.dart';

abstract class TrackingState extends Equatable {
  const TrackingState();

  @override
  List<Object?> get props => [];
}

class TrackingInitial extends TrackingState {}

class TrackingLoading extends TrackingState {}

class TrackingLoaded extends TrackingState {
  final OrderModel order;
  const TrackingLoaded(this.order);

  @override
  List<Object?> get props => [order];
}

class TrackingNoActiveOrder extends TrackingState {}

class TrackingFailure extends TrackingState {
  final String message;
  const TrackingFailure(this.message);

  @override
  List<Object?> get props => [message];
}
