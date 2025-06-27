part of 'kurir_home_cubit.dart';

sealed class KurirHomeState extends Equatable {
  const KurirHomeState();

  @override
  List<Object> get props => [];
}

final class KurirHomeInitial extends KurirHomeState {}

final class KurirHomeStatusLoading extends KurirHomeState {}

final class KurirHomeStatusSuccess extends KurirHomeState {
  final bool isOnline;
  const KurirHomeStatusSuccess(this.isOnline);

  @override
  List<Object> get props => [isOnline];
}

final class KurirHomeStatusFailure extends KurirHomeState {
  final String message;
  const KurirHomeStatusFailure(this.message);

  @override
  List<Object> get props => [message];
}
