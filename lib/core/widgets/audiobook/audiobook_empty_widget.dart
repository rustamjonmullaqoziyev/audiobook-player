import 'package:audiobook/core/extensions/text_extensions.dart';
import 'package:flutter/material.dart';

class AudiobookEmptyWidget extends StatelessWidget {
  const AudiobookEmptyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 1,
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          "Hech nima topilmadi"
              .w(500)
              .s(24)
              .c(Colors.black)
              .copyWith(textAlign: TextAlign.center)
        ],
      ),
    );
  }
}
