import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:qr_scanner/qr_scanner.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../domain/models/qr_model.dart';

part 'qr_scanner_event.dart';
part 'qr_scanner_state.dart';

class QrScannerBloc extends Bloc<QrScannerEvent, QrScannerState> {
  final QrScannerRepositoryImpl qrScannerRepository;
  final Box<QrModel> _qrBox;
  final List<QrModel> _scannedCodes = [];

  QrScannerBloc(this.qrScannerRepository)
      : _qrBox = Hive.box<QrModel>('qrs'),
        super(QrScannerInitial()) {
    on<QrScanned>(_onQrScanned);
    on<LoadSavedQrs>(_onLoadSavedQrs);
    on<DeleteQr>(_onDeleteQr);
    add(LoadSavedQrs());
  }

  void _onLoadSavedQrs(LoadSavedQrs event, Emitter<QrScannerState> emit) {
    _scannedCodes.clear();
    _scannedCodes.addAll(_qrBox.values);
    emit(QrScannerSuccess(scannedCodes: List.from(_scannedCodes)));
  }

  void _onQrScanned(QrScanned event, Emitter<QrScannerState> emit) async {
    final result = await qrScannerRepository.getResult();
    if (result.isNotEmpty) {
      final qrModel = QrModel.create(result);
      _scannedCodes.insert(0, qrModel);
      await _qrBox.add(qrModel);
      emit(QrScannerSuccess(scannedCodes: List.from(_scannedCodes)));
    }
  }

  void _onDeleteQr(DeleteQr event, Emitter<QrScannerState> emit) async {
    final qrKey = _qrBox.values.toList().indexWhere((qr) => qr.id == event.qr.id);
    if (qrKey != -1) {
      await _qrBox.deleteAt(qrKey);
      _scannedCodes.removeWhere((qr) => qr.id == event.qr.id);
      emit(QrScannerSuccess(scannedCodes: List.from(_scannedCodes)));
    }
  }
}
