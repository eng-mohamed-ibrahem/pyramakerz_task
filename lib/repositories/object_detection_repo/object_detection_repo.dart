import 'dart:developer';

import 'package:camera/camera.dart';
// import 'package:flutter_tflite/flutter_tflite.dart';
import 'package:tflite_v2/tflite_v2.dart';
import 'package:pyramakerz_task/core/error/failure.dart';
import 'package:pyramakerz_task/core/result_handler/result_handler.dart';
import 'package:pyramakerz_task/model/bounding_box.dart';

class ObjectDetectionRepo {
  late List<CameraDescription> _cameras;
  late CameraController controller;

  Future<ResultHandler<CameraController, Failure>> initalizeCamera() async {
    try {
      _cameras = await availableCameras();
      controller = CameraController(
        _cameras[0],
        ResolutionPreset.medium,
        enableAudio: false,
      );
      await controller.initialize();
      return ResultHandler.success(data: controller);
    } catch (e) {
      if (e is CameraException) {
        return ResultHandler.failure(
          error: CameraFailure(e.description!),
        );
      } else {
        return ResultHandler.failure(
          error: UnknownFailure(e.toString()),
        );
      }
    }
  }

  Future<void> takePicture() async {}

  Future<void> initTFLite() async {
    await Tflite.loadModel(
      model: "assets/object_dataset/ssd_mobilenet.tflite",
      labels: "assets/object_dataset/ssd_mobilenet.txt",
      numThreads: 1,
      isAsset: true,
      useGpuDelegate: false,
    );
  }

  Future<List<BoundingBox>?> objectDetection(CameraImage img) async {
    var recognitions = await Tflite.detectObjectOnFrame(
       bytesList: img.planes.map((plane) => plane.bytes).toList(),
        imageHeight: img.height,
        imageWidth: img.width,
        imageMean: 127.5,
        imageStd: 127.5,
        numResultsPerClass: 2,
        threshold: 0.2,
    );

    if (recognitions != null) {
      log("detect objects: $recognitions");
      return recognitions
          .map(
            (recognition) => BoundingBox.fromRecognition(
              (recognition as Map).cast<String, dynamic>(),
            ),
          )
          .toList();
    }
    return null;
  }

  Future<void> dispose() async {
    await controller.dispose();
    await Tflite.close();
  }
}
