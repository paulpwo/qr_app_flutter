# qr_app

A Flutter project for handling and reading QR codes.

## Requirements
- Flutter 3.29.0
- fvm - Flutter Version Management
- Melos - Monorepo management tool
- Pigeon - Flutter plugin generator

## Getting Started
1 - activate fvm
```bash
fvm use 2.8.1
```
2 - Activate Melos
```bash
dart pub global activate melos 
```
3 - Run melos bootstrap
```bash
melos bootstrap
```


dart run pigeon \
  --input lib/native/native_qr_pigeon.dart \
  --dart_out lib/native/native_qr_pigeon.g.dart \
  --kotlin_out android/src/main/kotlin/dev/flutter/mobile_qr/QrScannerPlugin.kt\
  --kotlin_package com.example.qr_scanner