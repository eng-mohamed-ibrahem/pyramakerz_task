import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pyramakerz_task/config/navigation/pages.dart';
import 'package:pyramakerz_task/config/navigation/routes_enum.dart';
import 'package:pyramakerz_task/repositories/object_detection_repo/object_detection_repo.dart';
import 'package:pyramakerz_task/repositories/speech_recognition_repo/speech_recognition_repo.dart';
import 'package:pyramakerz_task/viewmodel/object_detection_viewmodel/object_detection_viewmodel.dart';

import '../../viewmodel/speech_recognition_viewmodel.dart/speech_recognition_viewmodel.dart';

class NavigationConfig {
  NavigationConfig._();
  static String initialRoute = Routes.home.path;

  static GoRouter config() => GoRouter(
        initialLocation: initialRoute,
        debugLogDiagnostics: true,
        routes: <GoRoute>[
          GoRoute(
            path: Routes.home.path,
            builder: (context, state) => const Home(),
            routes: [
              GoRoute(
                path: Routes.speachRecognition.path,
                name: Routes.speachRecognition.name,
                builder: (context, state) => BlocProvider(
                  create: (context) => SpeechRecognitionViewModel(
                    speechRecognitionRepo: SpeechRecognitionRepo(),
                  )
                    ..initialize()
                    ..getSupportedLanguages(),
                  child: const SpeechRecognitionScreen(),
                ),
                routes: [
                  GoRoute(
                    path: Routes.historyRecognition.path,
                    name: Routes.historyRecognition.name,
                    builder: (context, state) =>
                        const HistoryRecognitionScreen(),
                  ),
                ],
              ),
              GoRoute(
                path: Routes.objectDetection.path,
                name: Routes.objectDetection.name,
                builder: (context, state) => BlocProvider(
                  create: (context) => ObjectDetectionViewmodel(
                    objectDetectionRepo: ObjectDetectionRepo(),
                  )
                    ..initalizeCamera()
                    ..initTFLite(),
                  child: const ObjectDetectionScreen(),
                ),
              ),
            ],
          ),
        ],
        errorBuilder: (context, state) {
          return Scaffold(
            body: Center(
              child: Text(
                state.error!.message,
              ),
            ),
          );
        },
      );
}
