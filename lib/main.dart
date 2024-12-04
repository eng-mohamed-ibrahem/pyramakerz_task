import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pyramakerz_task/core/utils/cubit_observer/cubit_observer.dart';
import 'package:pyramakerz_task/root_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  Bloc.observer = CubitObserver();
  runApp(
    EasyLocalization(
      path: 'lib/config/localization',
      supportedLocales: const [
        Locale('en'),
        Locale('ar'),
      ],
      fallbackLocale: const Locale('en'),
      startLocale: const Locale('en'),
      // saveLocale: true,
      child: const RootApp(),
    ),
  );
}
