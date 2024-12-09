import 'package:camera/camera.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pyramakerz_task/model/bounding_box.dart';
import 'package:pyramakerz_task/repositories/object_detection_repo/object_detection_repo.dart';

part 'object_detection_viewmodel_state.dart';

class ObjectDetectionViewmodel extends Cubit<ObjectDetectionState> {
  ObjectDetectionViewmodel({required ObjectDetectionRepo objectDetectionRepo})
      : _objectDetectionRepo = objectDetectionRepo,
        super(ObjectDetectionInitial());
  final ObjectDetectionRepo _objectDetectionRepo;
  late final CameraController cameraController;
  int cameraCounts = 0;

  void initalizeCamera() async {
    emit(ObjectdetectionInitializing());
    final result = await _objectDetectionRepo.initalizeCamera();
    result.when(
      success: (cameraController) {
        this.cameraController = cameraController;
        detectObjects();
        emit(ObjectdetectionInitialized());
      },
      failure: (error) {
        emit(ObjectdetectionInitializationError(error: error.message));
      },
    );
  }

  void initTFLite() async {
    await _objectDetectionRepo.initTFLite();
  }

  List<BoundingBox> detectedObjects = [];
  BoundingBox? detectedObject;
  void detectObjects() {
    int cameraCounts = 0;
    cameraController.startImageStream(
      (image) async {
        cameraCounts++;
        if (cameraCounts % 10 == 0) {
          cameraCounts = 0;
          detectedObjects =
              await _objectDetectionRepo.objectDetection(image) ?? [];
          emit(ObjectdetectionSuccess());
        }
      },
    );
  }

  void dispose() async {
    await _objectDetectionRepo.dispose();
  }
}
