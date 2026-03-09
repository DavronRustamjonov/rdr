//monitoring_service.dart
import 'dart:async';
import 'dart:ui';
import 'package:camera/camera.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:flutter/foundation.dart';

typedef EarCallback = void Function(double ear, bool isOpen);

class MonitoringService {
  CameraController? _cameraController;
  FaceDetector? _faceDetector;
  bool _isRunning = false;
  bool _isProcessing = false;
  int _closedFrames = 0;

  static const int closedThresholdFrames = 3; // Biroz ko'paytirildi (xatolik kamayishi uchun)

  EarCallback? onEarUpdate;
  VoidCallback? onDrowsinessDetected;
  VoidCallback? onSleepDetected;

  bool get isRunning => _isRunning;

  Future<void> initialize(List<CameraDescription> cameras) async {
    if (cameras.isEmpty) return;

    final frontCamera = cameras.firstWhere(
      (c) => c.lensDirection == CameraLensDirection.front,
      orElse: () => cameras.first,
    );

    _cameraController = CameraController(
      frontCamera,
      ResolutionPreset.low, // Tezlik uchun past aniqlik yaxshi
      imageFormatGroup: ImageFormatGroup.nv21, // Android uchun eng barqarori
      enableAudio: false,
    );

    await _cameraController!.initialize();

    _faceDetector = FaceDetector(
      options: FaceDetectorOptions(
        enableLandmarks: true,
        enableClassification: true, // KO'ZLAR UCHUN SHART!
        performanceMode: FaceDetectorMode.fast,
      ),
    );
  }

  Future<void> startMonitoring() async {
    if (_isRunning || _cameraController == null || _faceDetector == null) return;
    _isRunning = true;
    _closedFrames = 0;

    _cameraController!.startImageStream((image) async {
      if (_isProcessing || !_isRunning) return;
      _isProcessing = true;

      try {
        final inputImage = _buildInputImage(image);
        if (inputImage == null) {
          _isProcessing = false;
          return;
        }

        final faces = await _faceDetector!.processImage(inputImage);

        if (faces.isEmpty) {
          onEarUpdate?.call(0.0, false); // Yuz yo'q bo'lsa
          _isProcessing = false;
          return;
        }

        final face = faces.first;
        final leftOpen = face.leftEyeOpenProbability ?? 1.0;
        final rightOpen = face.rightEyeOpenProbability ?? 1.0;
        final eyeOpenness = (leftOpen + rightOpen) / 2.0;
        
        // EAR (Eye Aspect Ratio) simulyatsiyasi
        final ear = eyeOpenness * 0.4;

        onEarUpdate?.call(ear, eyeOpenness > 0.35);

        if (eyeOpenness < 0.35) {
          _closedFrames++;
          if (_closedFrames == 2) {
            onDrowsinessDetected?.call();
          } else if (_closedFrames >= closedThresholdFrames) {
            onSleepDetected?.call();
          }
        } else {
          _closedFrames = 0;
        }
      } catch (e) {
        debugPrint('Monitoring error: $e');
      } finally {
        _isProcessing = false;
      }
    });
  }

  InputImage? _buildInputImage(CameraImage image) {
    final camera = _cameraController?.description;
    if (camera == null) return null;

    final sensorOrientation = camera.sensorOrientation;
    final rotation = InputImageRotationValue.fromRawValue(sensorOrientation);
    if (rotation == null) return null;

    final format = InputImageFormatValue.fromRawValue(image.format.raw);
    if (format == null) return null;

    // ML Kit uchun barcha planelarni bitta byte massiviga yig'ish
    final WriteBuffer allBytes = WriteBuffer();
    for (final Plane plane in image.planes) {
      allBytes.putUint8List(plane.bytes);
    }
    final bytes = allBytes.done().buffer.asUint8List();

    // YANGI ML KIT VERSIYASIDA METADATA SHU KO'RINISHDA BO'LADI
    return InputImage.fromBytes(
      bytes: bytes,
      metadata: InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: rotation,
        format: format,
        bytesPerRow: image.planes.first.bytesPerRow,
      ),
    );
  }

  Future<void> stopMonitoring() async {
    _isRunning = false;
    _closedFrames = 0;
    try {
      if (_cameraController != null && _cameraController!.value.isStreamingImages) {
        await _cameraController?.stopImageStream();
      }
    } catch (_) {}
  }

  Future<void> dispose() async {
    await stopMonitoring();
    await _faceDetector?.close();
    await _cameraController?.dispose();
    _cameraController = null;
    _faceDetector = null;
  }
}