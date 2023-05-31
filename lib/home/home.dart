import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'camera.dart';
import 'face_controller.dart';
import 'face_model.dart';
// import 'package:google_ml_example/features/home/controller/camera_controller.dart';
// import 'package:google_ml_example/features/home/controller/face_detention_controller.dart';
// import 'package:google_ml_example/features/home/module/face_model.dart';
// import 'package:google_ml_kit/google_ml_kit.dart';

class HomeController extends GetxController {
  CameraManager? _cameraManager;
  CameraController? cameraController;
  FaceDetetorController? _faceDetect;
  bool _isDetecting = false;
  List<FaceModel>? faces;
  String? faceAtMoment = 'normal_face.png';
  String? label = 'Normal';
  String? label1 = 'Normal';
  String? label2 = 'Normal';
  String? label3 = 'Normal';
  String? label4 = 'Normal';

  HomeController() {
    _cameraManager = CameraManager();
    _faceDetect = FaceDetetorController();
  }

  Future<void> loadCamera() async {
    cameraController = await _cameraManager?.load();
    update();
  }

  Future<void> startImageStream() async {
    CameraDescription camera = cameraController!.description;

    cameraController?.startImageStream((cameraImage) async {
      if (_isDetecting) return;

      _isDetecting = true;

      final WriteBuffer allBytes = WriteBuffer();
      for (Plane plane in cameraImage.planes) {
        allBytes.putUint8List(plane.bytes);
      }
      final bytes = allBytes.done().buffer.asUint8List();

      final Size imageSize =
          Size(cameraImage.width.toDouble(), cameraImage.height.toDouble());

      final InputImageRotation imageRotation =
          InputImageRotationValue.fromRawValue(camera.sensorOrientation) ??
              InputImageRotation.rotation0deg;

      final InputImageFormat inputImageFormat =
          InputImageFormatValue.fromRawValue(cameraImage.format.raw) ??
              InputImageFormat.nv21;

      final planeData = cameraImage.planes.map(
        (Plane plane) {
          return InputImagePlaneMetadata(
            bytesPerRow: plane.bytesPerRow,
            height: plane.height,
            width: plane.width,
          );
        },
      ).toList();

      final inputImageData = InputImageData(
        size: imageSize,
        imageRotation: imageRotation,
        inputImageFormat: inputImageFormat,
        planeData: planeData,
      );

      final inputImage = InputImage.fromBytes(
        bytes: bytes,
        inputImageData: inputImageData,
      );

      processImage(inputImage);
    });
  }

  Future<void> processImage(inputImage) async {
    faces = await _faceDetect?.processImage(inputImage);

    if (faces != null && faces!.isNotEmpty) {
      FaceModel? face = faces?.first;
      label = detectSmile(face?.smile);
      label1 = detectSmile(face?.smile);
      label2 = detectSmile(face?.smile);
      label3 = detectSmile(face?.smile);
      label4 = detectSmile(face?.smile);
    } else {
      faceAtMoment = 'normal_face.png';
      label = 'NF';
      label1 = 'NF';
      label2 = 'NF';
      label3 = 'NF';
      label4 = 'NF';
    }
    _isDetecting = false;
    update();
  }

  String detectSmile(smileProb) {
    if (smileProb > 0.9 && smileProb < 1) {

      return '+ 10';
    } else if (smileProb > 0.8 && smileProb <= 0.9) {

      return '+ 9';
    } else if (smileProb > 0.7 && smileProb <= 0.8) {

      return '+ 8';
    } else if (smileProb > 0.6 && smileProb <= 0.7) {

      return '+ 7';
    }else if (smileProb > 0.5 && smileProb <= 0.6) {

      return '+ 6';
    }else if (smileProb > 0.4 && smileProb <= 0.5) {

      return '+ 5';
    }else if (smileProb > 0.3 && smileProb <= 0.4) {

      return '+ 4';
    }else if (smileProb > 0.2 && smileProb <= 0.3) {

      return '+ 3';
    }else if (smileProb > 0.1 && smileProb <= 0.2) {

      return '+ 2';
    }else if (smileProb > 0.0 && smileProb <= 0.1) {

      return '+ 1';
    }else {

      return '+ 0';
    }
  }
}