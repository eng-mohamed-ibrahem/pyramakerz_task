import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pyramakerz_task/config/navigation/routes_enum.dart';
import 'package:pyramakerz_task/viewmodel/speech_recognition_viewmodel.dart/speech_recognition_viewmodel.dart';
import 'package:pyramakerz_task/views/widgets/mic_button.dart';
import 'package:pyramakerz_task/views/widgets/recognition_result.dart';

class SpeechRecognitionScreen extends StatelessWidget {
  const SpeechRecognitionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("speech.title".tr()),
      ),
      body: BlocConsumer<SpeechRecognitionViewModel, SpeechRecognitionState>(
        listener: (context, state) {
          if (state is SpeechRecognitionError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage)),
            );
          }
          if (state is SpeechRecognitionSuccess ||
              state is SpeechRecognitionStopped) {}
        },
        builder: (context, state) {
          if (state is SpeechRecognitionInitializing) {
            return Center(
              child: Column(
                children: [
                  const CircularProgressIndicator(),
                  Text("speech.init".tr()),
                ],
              ),
            );
          } else if (state is SpeechRecognitionInitializingError) {
            return Center(
              child: Text(state.errorMessage),
            );
          }
          return SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 30),
                RecognitionResultsWidget(
                  recognizedTextStream: context
                      .read<SpeechRecognitionViewModel>()
                      .recognizedTextStream,
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton:
          BlocBuilder<SpeechRecognitionViewModel, SpeechRecognitionState>(
        builder: (context, state) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // history
              IconButton(
                icon: const Icon(Icons.history),
                onPressed: () {
                  context.read<SpeechRecognitionViewModel>().cancelListening();
                  context.goNamed(Routes.historyRecognition.name);
                },
              ),
              const SizedBox(
                width: 20,
              ),
              Transform.translate(
                offset: const Offset(0, -20),
                child: MicButton(
                  isListening: state is SpeechRecognitionListening,
                  onTap: () async {
                    if (state is SpeechRecognitionListening) {
                      await context
                          .read<SpeechRecognitionViewModel>()
                          .stopListening();
                    }
                    await context
                        .read<SpeechRecognitionViewModel>()
                        .startListening(
                          language: context.locale,
                        );
                  },
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              Row(
                children: [
                  Text(
                    context
                        .read<SpeechRecognitionViewModel>()
                        .currentLanguage
                        .languageCode,
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.language,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      _popSupportedLanguages(context);
                    },
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  void _popSupportedLanguages(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      enableDrag: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      isDismissible: true,
      showDragHandle: true,
      constraints:
          BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height * .8),
      builder: (BuildContext _) {
        return Container(
          padding: const EdgeInsets.all(10),
          child: ListView(
            children: context
                .read<SpeechRecognitionViewModel>()
                .supportedLanguages
                .map(
                  (e) => ListTile(
                    title: Text(e.name),
                    onTap: () {
                      context.read<SpeechRecognitionViewModel>().changeLanguage(
                            Locale(e.localeId),
                          );
                      Navigator.pop(context);
                    },
                  ),
                )
                .toList(),
          ),
        );
      },
    );
  }
}
