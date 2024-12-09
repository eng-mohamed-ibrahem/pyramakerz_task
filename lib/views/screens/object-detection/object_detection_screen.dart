import 'package:camera/camera.dart';
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pyramakerz_task/viewmodel/object_detection_viewmodel/object_detection_viewmodel.dart';
import 'package:pyramakerz_task/views/widgets/object_detection_painter.dart';

class ObjectDetectionScreen extends StatefulWidget {
  const ObjectDetectionScreen({super.key});

  @override
  State<ObjectDetectionScreen> createState() => _ObjectDetectionScreenState();
}

class _ObjectDetectionScreenState extends State<ObjectDetectionScreen>
    with WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController cameraController =
        context.read<ObjectDetectionViewmodel>().cameraController;

    // App state changed before we got the chance to initialize.
    if (!cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      context.read<ObjectDetectionViewmodel>().dispose();
    } else if (state == AppLifecycleState.resumed) {
      context.read<ObjectDetectionViewmodel>().initalizeCamera();
    }
  }

  @override
  void deactivate() {
    context.read<ObjectDetectionViewmodel>().dispose();
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("detection.title".tr()),
      ),
      body: BlocConsumer<ObjectDetectionViewmodel, ObjectDetectionState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is ObjectdetectionInitializing) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 10),
                  Text("detection.init".tr()),
                ],
              ),
            );
          }
          if (state is ObjectdetectionInitializationError) {
            return Center(child: Text(state.error));
          }

          return Stack(
            children: [
              Positioned.fill(
                child: CameraPreview(
                  context.read<ObjectDetectionViewmodel>().cameraController,
                ),
              ),
              Positioned.fill(
                child: CustomPaint(
                  painter: ObjectDetectionPainter(
                    context.read<ObjectDetectionViewmodel>().detectedObjects,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
