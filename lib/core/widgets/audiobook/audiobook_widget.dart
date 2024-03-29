import 'package:audiobook/core/extensions/text_extensions.dart';
import 'package:flutter/material.dart';

import '../../../domain/modules/audiobooks/audiobooks.dart';
import '../../gen/assets/assets.gen.dart';

class AudiobookWidget extends StatelessWidget {
  const AudiobookWidget(
      {super.key, required this.audiobook, required this.callback});

  final Audiobook audiobook;
  final Function(Audiobook audiobook) callback;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          callback(audiobook);
        },
        child: Container(
          margin: const EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12), color: Colors.white),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Assets.images.icMusic.svg(width: 24, height: 24),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  audiobook.description
                      .w(500)
                      .s(16)
                      .c(Colors.black)
                      .copyWith(maxLines: 1, overflow: TextOverflow.ellipsis),
                  audiobook.author
                      .w(500)
                      .s(16)
                      .c(Colors.black)
                      .copyWith(maxLines: 1, overflow: TextOverflow.ellipsis)
                ],
              )
            ],
          ),
        ));
  }
}
