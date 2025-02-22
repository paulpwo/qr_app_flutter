# QR App

[![Build Status](https://github.com/paulpwo/qr_app_flutter/actions/workflows/build_apk.yml/badge.svg?branch=main)](https://github.com/paulpwo/qr_app_flutter/actions/workflows/build_apk.yml)
[![Tests Status](https://github.com/paulpwo/qr_app_flutter/actions/workflows/build_apk.yml/badge.svg?branch=main&job=test)](https://github.com/paulpwo/qr_app_flutter/actions/workflows/build_apk.yml)

# 📱 QR App

A Flutter project for handling and reading QR codes with native performance optimization. 

## 🚀 Features  
- **QR Code Scanning:** Uses the device camera to scan QR codes efficiently.  
- **Native Processing:** Optimized QR recognition using platform-specific code (Android/iOS).  
- **Biometric Authentication:** Supports Face ID (iOS) and Fingerprint (Android) for secure access.  
- **History Management:** Stores scanned QR codes persistently.  
- **Clean Architecture:** Implements BLoC for state management. 

## 📸 Screenshots
| | | |
|------------|----------------|------------|
| <img src="/images/1.jpeg" width="100"/> | <img src="/images/2.jpeg" width="100"/> | <img src="/images/3.jpeg" width="100"/> |
| <img src="/images/4.jpeg" width="100"/> | <img src="/images/5.jpeg" width="100"/> | <img src="/images/6.jpeg" width="100"/> |

## 🛠️ Tech Stack  
- **Flutter** (Dart)  
- **BLoC for state management**  
- **Pigeon for native integration**  
- **Melos for monorepo management**  
- **Mockito for unit testing**  
- **Fastlane for deployment automation**  

## 📖 Setup  
1. **Clone the repository:**  
```sh
git clone https://github.com/paulpwo/qr_app_flutter
cd qr_app_flutter
```

2. **Install dependencies:**  
```sh
flutter pub get
```
2 - Activate Melos
```bash
dart pub global activate melos 
```
3 - Run melos bootstrap
```bash
melos bootstrap
```
## Run pigeon Example
```bash
dart run pigeon --input FILE_PATH
```
<!-- runr test -->
## 🧪 Running Tests
```sh
melos run test
```
## Checklist
- [x] Create a Flutter project
- [x] Add Melos
- [x] Add Pigeon
- [x] Setup Pigeon packages
- [x] Create a QR code reader native plugin (Android)
- [ ] Create a QR code reader native plugin (iOS)
- [x] Create a QR code Bloc and UI
- [x] Create a Biometric native plugin (Android)
- [ ] Create a Biometric native plugin (iOS)
- [x] Create a Biometric Bloc and UI
- [x] Add support secure storage for Login
- [x] Create Splash screen & Navigation
- [x] Add session validation on Splash screen
- [x] Create a Home screen with Bottom Navigation
- [x] Create a QR code reader screen
- [x] Create a Profile screen
- [x] Enhance the UI for history QR codes
- [x] Enhance the UI for the profile screen
- [x] Enhance Theme and Colors
- [x] Add support to theme switcher
- [x] Add support to Hive for Storage for QR codes
- [x] Add support delete QR codes
- [x] Enhance the UI for the QR code Card
- [x] Add support to delete QR codes
- [x] Add support to validate security for QR code scanned
- [x] Other improvements
- [x] Add Android Flavors


## This project has the following flavors:
production: flutter run --flavor production
development: flutter run --flavor development
````
