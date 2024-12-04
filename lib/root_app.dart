import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:pyramakerz_task/config/navigation/navigation.dart';

class RootApp extends StatelessWidget {
  const RootApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Pyramakerz Task',
      routerConfig: NavigationConfig.config(),
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
    );
  }
}
