import 'package:audiobook/core/extensions/text_extensions.dart';
import 'package:audiobook/core/widgets/common/common_elevated_button.dart';
import 'package:flutter/material.dart';

class AudiobookErrorWidget extends StatelessWidget {
  const AudiobookErrorWidget(
      {super.key, required this.callback, required this.offlinePlane});

  final VoidCallback callback;
  final VoidCallback offlinePlane;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      height: MediaQuery.of(context).size.height * 1,
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
              child: "Qayta urinish".w(500).s(16).c(Colors.black)),
          const SizedBox(height: 16),
          CommonElevatedButton(
              callback: offlinePlane,
              onLoading: false,
              child: "Off-line rejimga o'tish".w(500).s(16).c(Colors.black)),
        ],
      ),
    );
  }
}
