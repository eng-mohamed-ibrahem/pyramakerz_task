import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';

/// Displays the most recently recognized words and the sound level.
class RecognitionResultsWidget extends StatelessWidget {
  const RecognitionResultsWidget({
    super.key,
    required this.recognizedTextStream,
  });
  final Stream<String> recognizedTextStream;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Center(
          child: Text(
            'speech.recognized_words'.tr(),
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        StreamBuilder<String>(
          stream: recognizedTextStream,
          initialData: "speech.hint".tr(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text(
                snapshot.error.toString(),
              );
            }
            return Container(
              constraints: const BoxConstraints(
                minHeight: 200,
              ),
              color: Theme.of(context).secondaryHeaderColor,
              child: Center(
                child: Text(
                  snapshot.hasData ? snapshot.data! : "",
                  textAlign: TextAlign.center,
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
