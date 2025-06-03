# Easy QR Code Scanner

A simple and lightweight Flutter widget for scanning QR codes using the device camera, built with `camera` and `google_mlkit_barcode_scanning`. It provides a fullscreen camera preview with real-time QR code detection.

## Features

- Real-time QR code detection
- Fullscreen native camera preview
- Android and iOS support
- Easy integration with a single widget

---

## Installation

Add this to your `pubspec.yaml`:

```yaml
dependencies:
  easy_qr_code_scanner: ^0.0.1
```


Setup

1. Import the package
```
import 'package:easy_qr_code_scanner/easy_qr_code_scanner.dart';
```
2. Minimum iOS Deployment Target

Set the minimum iOS deployment target to 16.0 in your ios/Podfile:
```
platform :ios, '16.0'
```
3. Permissions

Android

Add the following permissions to your android/app/src/main/AndroidManifest.xml:
```
<uses-permission android:name="android.permission.CAMERA"/>
```
Also, inside the <application> tag, add:

<uses-feature android:name="android.hardware.camera" android:required="true"/>

iOS

Add the following to your ios/Runner/Info.plist file:
```
<key>NSCameraUsageDescription</key>
<string>We need camera access to scan QR codes</string>
```


Usage
```
EasyQrCodeScannerWidget(
  onDetect: (String qrCode) {
    // Handle the scanned QR code
    print('Scanned QR: $qrCode');
  },
)
```
This widget will automatically initialize the camera and start scanning for QR codes. When a QR code is detected, it will trigger the onDetect callback with the decoded value.


## License

This project is licensed under the MIT License. See the LICENSE file for details.

## Contributions

Contributions are welcome. Please open issues or submit pull requests to help improve this package.

If you find this package useful, consider giving it a star on GitHub or pub.dev.