import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';

class UniversalCodeScannerWidget extends StatefulWidget {
  final Function(String) onDetect;

  const UniversalCodeScannerWidget({super.key, required this.onDetect});

  @override
  State<UniversalCodeScannerWidget> createState() => _UniversalCodeScannerWidget();
}

class _UniversalCodeScannerWidget extends State<UniversalCodeScannerWidget> {
  late CameraController _cameraController;
  late BarcodeScanner _barcodeScanner;
  bool _isDetecting = false;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _barcodeScanner = BarcodeScanner(formats: [BarcodeFormat.all]);
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      final backCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.back,
      );

      _cameraController = CameraController(
        backCamera,
        ResolutionPreset.high,
        enableAudio: false,
        imageFormatGroup: Platform.isAndroid ? ImageFormatGroup.nv21 : ImageFormatGroup.bgra8888,
      );

      await _cameraController.initialize();
      await _cameraController.startImageStream(_processCameraImage);

      setState(() {
        _isInitialized = true;
      });
    } catch (e) {
      debugPrint("Camera initialization error: $e");
    }
  }

  Future<void> _processCameraImage(CameraImage image) async {
    if (_isDetecting) return;
    _isDetecting = true;

    try {
      final WriteBuffer allBytes = WriteBuffer();
      for (Plane plane in image.planes) {
        allBytes.putUint8List(plane.bytes);
      }
      final bytes = allBytes.done().buffer.asUint8List();

      final imageSize = Size(image.width.toDouble(), image.height.toDouble());

      final camera = _cameraController.description;
      final imageRotation =
          InputImageRotationValue.fromRawValue(camera.sensorOrientation) ??
          InputImageRotation.rotation0deg;

      final inputImageFormat =
          InputImageFormatValue.fromRawValue(image.format.raw) ?? InputImageFormat.nv21;

      final inputImageData = InputImageMetadata(
        size: imageSize,
        rotation: imageRotation,
        format: inputImageFormat,
        bytesPerRow: image.planes.first.bytesPerRow,
      );

      final inputImage = InputImage.fromBytes(bytes: bytes, metadata: inputImageData);

      final barcodes = await _barcodeScanner.processImage(inputImage);
      if (barcodes.isNotEmpty) {
        widget.onDetect(barcodes.first.rawValue ?? '');
      }
    } catch (e) {
      debugPrint("QR detection error: $e");
    } finally {
      _isDetecting = false;
    }
  }

  @override
  void dispose() {
    _cameraController.dispose();
    _barcodeScanner.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return SizedBox();
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final previewSize = _cameraController.value.previewSize!;
        final screenRatio = constraints.maxWidth / constraints.maxHeight;
        final previewRatio = previewSize.height / previewSize.width;

        return OverflowBox(
          maxHeight: screenRatio > previewRatio
              ? constraints.maxHeight
              : constraints.maxWidth / previewRatio,
          maxWidth: screenRatio > previewRatio
              ? constraints.maxHeight * previewRatio
              : constraints.maxWidth,
          child: CameraPreview(_cameraController),
        );
      },
    );
  }
}
