import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:pyramakerz_task/repositories/speech_recognition_repo/speech_recognition_repo.dart';

class HistoryRecognitionScreen extends StatefulWidget {
  const HistoryRecognitionScreen({super.key});

  @override
  State<HistoryRecognitionScreen> createState() =>
      _HistoryRecognitionScreenState();
}

class _HistoryRecognitionScreenState extends State<HistoryRecognitionScreen> {
  late List<String> history;
  @override
  void initState() {
    history = GetIt.I.get<SpeechRecognitionRepo>().getRecognizedHistory();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("speech.history".tr())),
      body: history.isEmpty
          ? Center(child: Text("speech.history_empty".tr()))
          : ListView.separated(
              itemCount: history.length,
              padding: const EdgeInsets.all(10),
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Theme.of(context).secondaryHeaderColor,
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Text(
                    history[index],
                  ),
                );
              },
              separatorBuilder: (context, index) => const SizedBox(height: 10),
            ),
    );
  }
}
