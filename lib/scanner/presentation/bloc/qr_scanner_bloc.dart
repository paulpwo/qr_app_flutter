import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:qr_scanner/qr_scanner.dart';
import '../../domain/models/qr_model.dart';

part 'qr_scanner_event.dart';
part 'qr_scanner_state.dart';

class QrScannerBloc extends Bloc<QrScannerEvent, QrScannerState> {
  final QrScannerRepositoryImpl qrScannerRepository;
  final List<QrModel> _scannedCodes = [];

  QrScannerBloc(this.qrScannerRepository) : super(QrScannerInitial()) {
    on<QrScanned>(_onQrScanned);
  }

  void _onQrScanned(QrScanned event, Emitter<QrScannerState> emit) async {
    final result = await qrScannerRepository.getResult();
    if (result.isNotEmpty) {
      _scannedCodes.insert(0, QrModel.create(result));
      emit(QrScannerSuccess(scannedCodes: List.from(_scannedCodes)));
    }
  }
}
