import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:pyramakerz_task/core/constants/cache_contants.dart';
import 'package:pyramakerz_task/core/error/failure.dart';
import 'package:pyramakerz_task/core/result_handler/result_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speech_to_text/speech_to_text.dart';

class SpeechRecognitionRepo {
  final SpeechToText _speechToText = SpeechToText();
  late SharedPreferences _sharedPreferences;
  late StreamController<String> _streamController;

  Future<ResultHandler<bool, Failure>> initialize() async {
    bool available = await _speechToText.initialize(
      debugLogging: true,
      onStatus: (status) async {
        debugPrint('Speech recognition status: $status');
      },
      onError: (error) async {
        debugPrint('Speech recognition error: $error');
        _streamController.addError("Unrecognized speech");
      },
    );
    if (!available) {
      String error = 'speech.unavailable'.tr();
      return ResultHandler.failure(error: UnAvailableFailure(error));
    }
    _initializeSharedPreferences();
    return const ResultHandler.success(data: true);
  }

  void _initializeSharedPreferences() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  Future<ResultHandler<Stream<String>, Failure>> startListening(
      {Locale newLanguage = const Locale('en')}) async {
    try {
      _streamController = StreamController.broadcast();
      _speechToText.listen(
        onResult: (result) {
          _streamController.add(result.recognizedWords);
          if (result.finalResult) {
            _streamController.close();
          }
        },
        listenOptions: SpeechListenOptions(
          listenMode: ListenMode.confirmation,
          onDevice: false,
          cancelOnError: true,
          partialResults: true,
          autoPunctuation: true,
          enableHapticFeedback: true,
        ),
        localeId: newLanguage.languageCode,
      );
      return ResultHandler.success(data: _streamController.stream);
    } catch (e) {
      String error = 'speech.listen_error'.tr();
      _streamController.addError(error);
      return ResultHandler.failure(error: UnknownFailure(error));
    }
  }

  Future<void> stopListening() async {
    _streamController.close();
    await _speechToText.stop();
  }

  Future<void> cancelListening() async {
    await _speechToText.cancel();
    _streamController.close();
  }

  Future<List<LocaleName>> get supportedLanguaages async {
    return await _speechToText.locales();
  }

  Future<void> saveRecognizedText(String text) async {
    await _sharedPreferences.setStringList(
      CacheConstants.recognizedHistory,
      [text, ...getRecognizedHistory()],
    );
  }

  List<String> getRecognizedHistory() {
    return _sharedPreferences.getStringList(CacheConstants.recognizedHistory) ??
        [];
  }
}
