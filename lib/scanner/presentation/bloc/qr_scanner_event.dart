part of 'qr_scanner_bloc.dart';

abstract class QrScannerEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class QrScanned extends QrScannerEvent {
  final String qrData;

  QrScanned(this.qrData);

  @override
  List<Object?> get props => [qrData];
}
