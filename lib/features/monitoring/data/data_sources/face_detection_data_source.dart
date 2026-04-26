import 'dart:async';
import 'dart:ui';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import '../../../../core/enums/monitoring_status.dart';
import '../../domain/entities/monitoring_result.dart';

abstract class FaceDetectionDataSource {
  Future<void> initialize(List<CameraDescription> cameras);
  Stream<MonitoringResult> startStream();
  Future<void> stopStream();
  Future<void> dispose();
}

class FaceDetectionDataSourceImpl implements FaceDetectionDataSource {
  CameraController? _cameraController;
  FaceDetector? _faceDetector;
  StreamController<MonitoringResult>? _streamController;
  bool _isRunning = false;
  bool _isProcessing = false;
  int _closedFrames = 0;

  static const _closedThreshold = 3;

  @override
  Future<void> initialize(List<CameraDescription> cameras) async {
    if (cameras.isEmpty) return;
    final front = cameras.firstWhere(
      (c) => c.lensDirection == CameraLensDirection.front,
      orElse: () => cameras.first,
    );
    _cameraController = CameraController(
      front,
      ResolutionPreset.low,
      imageFormatGroup: ImageFormatGroup.nv21,
      enableAudio: false,
    );
    await _cameraController!.initialize();
    _faceDetector = FaceDetector(
      options: FaceDetectorOptions(
        enableClassification: true,
        performanceMode: FaceDetectorMode.fast,
      ),
    );
  }

  @override
  Stream<MonitoringResult> startStream() {
    _streamController = StreamController<MonitoringResult>.broadcast();
    _isRunning = true;
    _closedFrames = 0;

    _cameraController?.startImageStream((image) async {
      if (_isProcessing || !_isRunning) return;
      _isProcessing = true;
      try {
        final inputImage = _buildInputImage(image);
        if (inputImage == null) return;

        final faces = await _faceDetector!.processImage(inputImage);
        if (faces.isEmpty) {
          _streamController?.add(const MonitoringResult(
            ear: 0.0,
            isEyeOpen: false,
            status: MonitoringStatus.monitoring,
          ));
          return;
        }

        final face = faces.first;
        final leftOpen = face.leftEyeOpenProbability ?? 1.0;
        final rightOpen = face.rightEyeOpenProbability ?? 1.0;
        final eyeOpenness = (leftOpen + rightOpen) / 2.0;
        final ear = eyeOpenness * 0.4;
        final isOpen = eyeOpenness > 0.35;

        MonitoringStatus status;
        if (!isOpen) {
          _closedFrames++;
          if (_closedFrames >= _closedThreshold) {
            status = MonitoringStatus.sleeping;
          } else if (_closedFrames >= 2) {
            status = MonitoringStatus.warning;
          } else {
            status = MonitoringStatus.monitoring;
          }
        } else {
          _closedFrames = 0;
          status = MonitoringStatus.monitoring;
        }

        _streamController?.add(MonitoringResult(
          ear: ear,
          isEyeOpen: isOpen,
          status: status,
        ));
      } catch (e) {
        debugPrint('FaceDetection error: $e');
      } finally {
        _isProcessing = false;
      }
    });

    return _streamController!.stream;
  }

  InputImage? _buildInputImage(CameraImage image) {
    final camera = _cameraController?.description;
    if (camera == null) return null;
    final rotation = InputImageRotationValue.fromRawValue(camera.sensorOrientation);
    if (rotation == null) return null;
    final format = InputImageFormatValue.fromRawValue(image.format.raw);
    if (format == null) return null;
    final allBytes = WriteBuffer();
    for (final plane in image.planes) {
      allBytes.putUint8List(plane.bytes);
    }
    return InputImage.fromBytes(
      bytes: allBytes.done().buffer.asUint8List(),
      metadata: InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: rotation,
        format: format,
        bytesPerRow: image.planes.first.bytesPerRow,
      ),
    );
  }

  @override
  Future<void> stopStream() async {
    _isRunning = false;
    _closedFrames = 0;
    try {
      if (_cameraController?.value.isStreamingImages == true) {
        await _cameraController?.stopImageStream();
      }
    } catch (_) {}
    await _streamController?.close();
    _streamController = null;
  }

  @override
  Future<void> dispose() async {
    await stopStream();
    await _faceDetector?.close();
    await _cameraController?.dispose();
    _cameraController = null;
    _faceDetector = null;
  }
}
