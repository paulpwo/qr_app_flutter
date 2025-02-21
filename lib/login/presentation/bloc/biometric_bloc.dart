import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:auth_biometric/auth_biometric.dart';
import '../../../core/services/secure_storage_service.dart';

part 'biometric_event.dart';
part 'biometric_state.dart';

class BiometricBloc extends Bloc<BiometricEvent, BiometricState> {
  final BiometricRepositoryImpl biometricRepository;
  final SecureStorageService _storageService;

  BiometricBloc(this.biometricRepository)
      : _storageService = SecureStorageService(),
        super(BiometricInitial()) {
    on<BiometricCheckAvailabe>(_onBiometricAuthenticate);
    on<BiometricCheckCode>(_onCheckCode);
    // Ya no necesitamos este evento
    // on<BiometricCheckStoredAuth>(_onCheckStoredAuth);
  }

  Future<void> _onBiometricAuthenticate(
    BiometricCheckAvailabe event,
    Emitter<BiometricState> emit,
  ) async {
    try {
      emit(BiometricLoading());
      final result = await biometricRepository.getResult();
      if (result) {
        await _storageService.saveAuthenticationStatus(true);
        emit(BiometricSuccess());
      } else {
        emit(BiometricError('Autenticación fallida'));
      }
    } catch (e) {
      emit(BiometricError('Error: ${e.toString()}'));
    }
  }

  Future<void> _onCheckCode(
    BiometricCheckCode event,
    Emitter<BiometricState> emit,
  ) async {
    try {
      emit(BiometricLoading());
      await Future.delayed(const Duration(seconds: 1));

      if (event.code == '123456') {
        await _storageService.saveAuthenticationStatus(true);
        emit(BiometricSuccess());
      } else {
        emit(BiometricError('Código incorrecto'));
      }
    } catch (e) {
      emit(BiometricError('Error: ${e.toString()}'));
    }
  }
}
