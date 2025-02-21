part of 'biometric_bloc.dart';

abstract class BiometricEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class BiometricCheckAvailabe extends BiometricEvent {
  BiometricCheckAvailabe();

  @override
  List<Object?> get props => [];
}

class BiometricAvailabe extends BiometricEvent {
  final bool data;

  BiometricAvailabe(this.data);

  @override
  List<Object?> get props => [data];
}

class BiometricCheckCode extends BiometricEvent {
  final String code;

  BiometricCheckCode(this.code);

  @override
  List<Object?> get props => [code];
}

class BiometricCheckStoredAuth extends BiometricEvent {}
