import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pyramakerz_task/config/navigation/routes_enum.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                fixedSize: const Size(250, 50),
              ),
              onPressed: () => context.goNamed(Routes.speachRecognition.name),
              label: Text("speech.title".tr()),
              icon: const Icon(Icons.mic),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                fixedSize: const Size(250, 50),
              ),
              onPressed: () => context.goNamed(Routes.objectDetection.name),
              label: Text("detection.title".tr()),
              icon: const Icon(Icons.camera),
            ),
          ],
        ),
      ),
    );
  }
}
