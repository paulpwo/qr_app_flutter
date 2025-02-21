part of 'biometric_bloc.dart';

abstract class BiometricState extends Equatable {
  @override
  List<Object?> get props => [];
}

class BiometricInitial extends BiometricState {}

class BiometricLoading extends BiometricState {}

class BiometricSuccess extends BiometricState {
  final bool shouldRedirect;

  BiometricSuccess({this.shouldRedirect = false});

  @override
  List<Object?> get props => [shouldRedirect];
}

class BiometricError extends BiometricState {
  final String message;

  BiometricError(this.message);

  @override
  List<Object?> get props => [message];
}
