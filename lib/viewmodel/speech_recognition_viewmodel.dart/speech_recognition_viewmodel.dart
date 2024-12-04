import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:pyramakerz_task/repositories/speech_recognition_repo/speech_recognition_repo.dart';
import 'package:speech_to_text/speech_to_text.dart';

part 'speech_recognition_viewmodel_state.dart';

class SpeechRecognitionViewModel extends Cubit<SpeechRecognitionState> {
  SpeechRecognitionViewModel(
      {required SpeechRecognitionRepo speechRecognitionRepo})
      : _speechRecognitionRepo = speechRecognitionRepo,
        super(SpeechRecognitionInitial()) {
    GetIt.I.isRegistered<SpeechRecognitionRepo>()
        ? null
        : GetIt.I
            .registerSingleton<SpeechRecognitionRepo>(speechRecognitionRepo);
  }

  final SpeechRecognitionRepo _speechRecognitionRepo;
  Stream<String> recognizedTextStream = const Stream<String>.empty();
  List<LocaleName> supportedLanguages = [];
  Locale currentLanguage = const Locale('en');

  Future<void> initialize() async {
    emit(SpeechRecognitionInitializing());
    final result = await _speechRecognitionRepo.initialize();
    result.when(
      success: (data) => emit(SpeechRecognitionReady()),
      failure: (error) =>
          emit(SpeechRecognitionInitializingError(error.message)),
    );
  }

  Future<void> startListening({
    Locale language = const Locale('en'),
  }) async {
    emit(SpeechRecognitionListening());

    final result = await _speechRecognitionRepo.startListening(
      newLanguage: currentLanguage,
    );
    print("language ===== ${currentLanguage.languageCode}");
    result.when(
      success: (stream) {
        StringBuffer recognizedText = StringBuffer();
        recognizedTextStream = stream;
        recognizedTextStream.listen(
          (text) {
            recognizedText.clear();
            recognizedText.write("$text ");
          },
          onDone: () async {
            debugPrint('Speech recognition Done.');
            _speechRecognitionRepo.saveRecognizedText(
              recognizedText.toString().trim(),
            );
            emit(SpeechRecognitionSuccess());
          },
          onError: (error) {
            emit(SpeechRecognitionError(error.toString()));
          },
        );
      },
      failure: (error) => emit(
        SpeechRecognitionError(error.message),
      ),
    );
  }

  Future<void> stopListening() async {
    emit(SpeechRecognitionStopped());
    await _speechRecognitionRepo.stopListening();
  }

  Future<void> cancelListening() async {
    emit(SpeechRecognitionCanceled());
    await _speechRecognitionRepo.cancelListening();
  }

  Future<void> getSupportedLanguages() async {
    try {
      emit(SpeechRecognitionGetSupportedLanguages());
      final result = await _speechRecognitionRepo.supportedLanguaages;
      supportedLanguages = result;
      supportedLanguages.insert(0, LocaleName('ar', "Arabic Egypt"));
      emit(
        SpeechRecognitionGetSupportedLanguagesSuccess(),
      );
    } catch (e) {
      emit(SpeechRecognitionGetSupportedLanguagesError(e.toString()));
    }
  }

  void changeLanguage(Locale language) {
    currentLanguage = language;
    emit(SpeechRecognitionChangeLanguage());
  }
}
