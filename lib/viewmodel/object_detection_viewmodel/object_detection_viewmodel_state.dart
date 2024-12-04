part of 'object_detection_viewmodel.dart';

abstract class ObjectDetectionState {}

class ObjectDetectionInitial extends ObjectDetectionState {}

class ObjectdetectionInitializing extends ObjectDetectionState {}

class ObjectdetectionInitialized extends ObjectDetectionState {}

class ObjectdetectionInitializationError extends ObjectDetectionState {
  final String error;

  ObjectdetectionInitializationError({required this.error});
}

class ObjectdetectionSuccess extends ObjectDetectionState {}
