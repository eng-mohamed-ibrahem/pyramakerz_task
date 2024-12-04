# Pyramakerz Task

This application was created as a task for the company Pyramakerz.

The application contains two features:

1. Speech recognition: The user can tap the microphone and speak. The application will recognize the spoken words and display them on the screen.
2. Object detection: The application will detect objects in the **real-time** camera feed and display them on the screen.

The application is written in Flutter, a cross-platform mobile app development framework created by Google.

## How to build

1. Install Flutter on your machine.
2. Clone the repository.
3. Open the project in your preferred IDE.
4. Run `flutter pub get` to get all the dependencies.
5. Run `flutter run` to build and run the application.

## How to use

1. Open the application.
2. Tap the microphone to start speech recognition.
3. Speak and the application will recognize the spoken words.
4. Tap the camera to take a photo or select an image from your gallery.
5. The application will detect objects in the image and display them on the screen.

## Methodologies & Techniques

```bash
# state management
  flutter_bloc: ^8.1.6
  # to create voice commands by user
  speech_to_text: ^7.0.0
  # to navigate using Navigator 2
  go_router: ^14.6.1
  # to gengerate code
  freezed_annotation: ^2.4.4
  json_annotation: ^4.9.0
  # localization
  easy_localization: ^3.0.7
  # to save user data in locale storage
  shared_preferences: ^2.3.3
  # dependency injection
  get_it: ^8.0.2
  # to preview camera stream realtime as widget
  camera: ^0.11.0+2
  # to load dataset from tensorflow models
  flutter_tflite: ^1.0.1
  ```
