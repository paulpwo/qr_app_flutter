part of 'qr_scanner_bloc.dart';

abstract class QrScannerState extends Equatable {
  @override
  List<Object?> get props => [];
}

class QrScannerInitial extends QrScannerState {}

class QrScannerSuccess extends QrScannerState {
  final List<QrModel> scannedCodes;

  QrScannerSuccess({required this.scannedCodes});

  @override
  List<Object?> get props => [scannedCodes];
}
