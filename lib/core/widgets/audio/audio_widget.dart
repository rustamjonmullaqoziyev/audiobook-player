import 'package:audiobook/core/extensions/text_extensions.dart';
import 'package:flutter/material.dart';

import '../../../domain/modules/audio/audio.dart';
import '../../gen/assets/assets.gen.dart';

class AudioWidget extends StatelessWidget {
  const AudioWidget(
      {super.key,
      required this.audio,
      required this.callback,
      required this.isPlaying,
      required this.download});

  final Audio audio;
  final bool isPlaying;
  final Function(Audio audio) callback;
  final Function(Audio audio) download;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          callback(audio);
        },
        child: Container(
          margin: const EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: isPlaying ? Colors.grey : Colors.white),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Assets.images.icMusic.svg(width: 24, height: 24),
              const SizedBox(width: 8),
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  audio.name.w(500).s(16).c(Colors.black).copyWith(
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.start),
                  audio.description.w(500).s(16).c(Colors.black).copyWith(
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.start)
                ],
              )),
              const SizedBox(width: 4),
              IconButton(
                  onPressed: () {
                    download(audio);
                  },
                  icon: Assets.images.icArrowDownContained.svg())
            ],
          ),
        ));
  }
}
