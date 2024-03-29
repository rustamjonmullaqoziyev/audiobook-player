import 'package:audiobook/core/extensions/text_extensions.dart';
import 'package:audiobook/domain/modules/audiobooks/audiobooks.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../core/gen/assets/assets.gen.dart';
import '../../core/widgets/common/buildable.dart';
import 'bloc/audiobook_player_bloc.dart';

class AudiobookPlayerView extends StatelessWidget {
  const AudiobookPlayerView({super.key, required this.audiobook});

  final Audiobook audiobook;

  @override
  Widget build(BuildContext context) {
    return Buildable<AudiobookPlayerBloc, AudiobookPlayerState,
        AudiobookPlayerBuildable>(
      properties: (buildable) => [],
      builder: (BuildContext context, buildable) {
        return Scaffold(
            appBar: AppBar(
              title: audiobook.name.w(400).c(Colors.black),
              centerTitle: true,
              leading: IconButton(
                onPressed: () {context.router.pop();},
                icon: Assets.images.icArrowLeft.svg(),
              ),
            ),
            backgroundColor: const Color(0xFFF0F0F0),
            body: const Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [],
            ));
      },
    );
  }
}
