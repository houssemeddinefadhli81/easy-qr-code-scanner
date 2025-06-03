# Universal Code Scanner

A simple and lightweight Flutter widget for scanning **QR codes and barcodes** using the device camera, built with `camera` and `google_mlkit_barcode_scanning`. It provides a fullscreen camera preview with real-time multi-format detection.

## Features

- Real-time detection of QR codes and various barcode formats
- Fullscreen native camera preview
- Android and iOS support
- Easy integration with a single widget
- Built with `camera` and `google_mlkit_barcode_scanning`

---

## Installation

Add this to your `pubspec.yaml`:

```yaml
dependencies:
  universal_code_scanner: ^0.0.1
```


Setup

1. Import the package
```
import 'package:universal_code_scanner/universal_code_scanner.dart';
```
2. Minimum iOS Deployment Target

In your ios/Podfile, set:
```
platform :ios, '16.0'
```
3. Permissions

Android

In android/app/src/main/AndroidManifest.xml, add:
```
<uses-permission android:name="android.permission.CAMERA" />
```
Inside the <application> tag, also add:
```
<uses-feature android:name="android.hardware.camera" android:required="true"/>
```
iOS

In ios/Runner/Info.plist, add:
```
<key>NSCameraUsageDescription</key>
<string>We need camera access to scan codes</string>
```


Usage
```
UniversalCodeScannerWidget(
  onDetect: (String code) {
    // Handle the scanned code (QR, barcode, etc.)
    print('Scanned Code: $code');
  },
)
```
This widget will automatically initialize the camera and start scanning for supported barcode formats. When a code is detected, it will trigger the onDetect callback with the decoded value.

Supported Formats
```
- QR Code
- Code 128, Code 39, Code 93
- EAN-13, EAN-8
- UPC-A, UPC-E
- ITF, Codabar
- Data Matrix
- PDF-417
- Aztec
```

License

This project is licensed under the MIT License. See the LICENSE file for details.


Contributions

Contributions are welcome. Please open issues or submit pull requests to help improve this package.

If you find this package useful, consider giving it a star on GitHub or pub.dev.