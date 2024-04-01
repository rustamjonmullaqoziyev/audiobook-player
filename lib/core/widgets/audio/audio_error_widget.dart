import 'package:audiobook/core/extensions/text_extensions.dart';
import 'package:audiobook/core/widgets/common/common_elevated_button.dart';
import 'package:flutter/material.dart';

class AudioErrorWidget extends StatelessWidget {
  const AudioErrorWidget(
      {super.key, required this.callback, required this.offlinePlan});

  final VoidCallback callback;
  final VoidCallback offlinePlan;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      height: MediaQuery.of(context).size.height * 0.4,
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          "Xatolik Yuz berdi Qayta urinib ko'ring"
              .w(500)
              .s(24)
              .c(Colors.black)
              .copyWith(textAlign: TextAlign.center),
          const SizedBox(height: 8),
          CommonElevatedButton(
              callback: callback,
              onLoading: false,
              child: "Qayta  urinish".w(500).s(16).c(Colors.black)),
          const SizedBox(height: 16),
          CommonElevatedButton(
              callback: offlinePlan,
              onLoading: false,
              child: "Off-line rejimga o'tish".w(500).s(16).c(Colors.black)),
        ],
      ),
    );
  }
}
