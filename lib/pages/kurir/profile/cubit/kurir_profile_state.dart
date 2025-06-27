part of 'kurir_profile_cubit.dart';

sealed class KurirProfileState extends Equatable {
  const KurirProfileState();

  @override
  List<Object> get props => [];
}

final class KurirProfileInitial extends KurirProfileState {}

final class KurirProfileLoading extends KurirProfileState {}

final class KurirProfileLoaded extends KurirProfileState {
  final UserModel user;
  const KurirProfileLoaded(this.user);

  @override
  List<Object> get props => [user];
}

final class KurirProfileFailure extends KurirProfileState {
  final String message;
  const KurirProfileFailure(this.message);

  @override
  List<Object> get props => [message];
}
