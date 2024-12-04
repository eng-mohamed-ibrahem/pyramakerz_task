part of 'speech_recognition_viewmodel.dart';

abstract class SpeechRecognitionState {}

class SpeechRecognitionInitial extends SpeechRecognitionState {}

class SpeechRecognitionInitializing extends SpeechRecognitionState {}

class SpeechRecognitionInitializingError extends SpeechRecognitionState {
  final String errorMessage;
  SpeechRecognitionInitializingError(this.errorMessage);
}

class SpeechRecognitionReady extends SpeechRecognitionState {}

class SpeechRecognitionListening extends SpeechRecognitionState {}

class SpeechRecognitionSuccess extends SpeechRecognitionState {}

class SpeechRecognitionError extends SpeechRecognitionState {
  final String errorMessage;
  SpeechRecognitionError(this.errorMessage);
}

class SpeechRecognitionStopped extends SpeechRecognitionState {}

class SpeechRecognitionCanceled extends SpeechRecognitionState {}

class SpeechRecognitionGetSupportedLanguages extends SpeechRecognitionState {}

class SpeechRecognitionGetSupportedLanguagesError
    extends SpeechRecognitionState {
  final String errorMessage;
  SpeechRecognitionGetSupportedLanguagesError(this.errorMessage);
}

class SpeechRecognitionGetSupportedLanguagesSuccess
    extends SpeechRecognitionState {}

class SpeechRecognitionChangeLanguage extends SpeechRecognitionState {}
