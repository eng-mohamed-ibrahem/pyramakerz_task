import 'dart:developer';

import 'package:camera/camera.dart';
import 'package:flutter_tflite/flutter_tflite.dart';
import 'package:pyramakerz_task/core/error/failure.dart';
import 'package:pyramakerz_task/core/result_handler/result_handler.dart';
import 'package:pyramakerz_task/model/bounding_box.dart';

class ObjectDetectionRepo {
  late List<CameraDescription> _cameras;
  late CameraController controller;

  Future<ResultHandler<CameraController, Failure>> initalizeCamera() async {
    try {
      _cameras = await availableCameras();
      controller = CameraController(_cameras[0], ResolutionPreset.medium);
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

  Future<BoundingBox?> objectDetection(CameraImage img) async {
    var recognitions = await Tflite.detectObjectOnFrame(
      bytesList: img.planes.map((plane) {
        return plane.bytes;
      }).toList(),
      model: "SSDMobileNet",
      imageHeight: img.height,
      imageWidth: img.width,
      imageMean: 127.5,
      imageStd: 127.5,
      rotation: 90,
      threshold: 0.1,
      asynch: true,
      numResultsPerClass: 2,
    );

    if (recognitions != null) {
      log("detect objects: $recognitions");
      // if (recognitions['confidenceInClass'] * 100 > 50) {}
      // return recognitions
      //     .map(
      //       (recognition) => BoundingBox.fromRecognition(
      //         (recognition as Map).cast<String, dynamic>(),
      //       ),
      //     )
      //     .toList();
      if (recognitions[0]['confidenceInClass'] * 100 > 45) {
        return BoundingBox.fromRecognition(recognitions[0]);
      }
    }
    return null;
  }

  Future<void> dispose() async {
    await controller.dispose();
    await Tflite.close();
  }
}
