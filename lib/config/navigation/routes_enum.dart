enum Routes {
  home('/', 'home'),
  speachRecognition("speach-recognition", "speech_recognition"),
  objectDetection('object-detection', 'object_detection'),
  historyRecognition('history-recognition', 'history_recognition');

  const Routes(this.path, this.name);
  final String path;
  final String name;
}
