import 'package:audiobook/core/extensions/text_extensions.dart';
import 'package:audiobook/core/router/app_router.gr.dart';
import 'package:audiobook/core/widgets/audiobook/audiobook_shimmer_widget.dart';
import 'package:audiobook/core/widgets/audiobook/audiobook_widget.dart';
import 'package:audiobook/domain/modules/audiobooks/audiobooks.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/utils/utils.dart';
import '../../core/widgets/audiobook/audiobook_empty_widget.dart';
import '../../core/widgets/audiobook/audiobook_error_widget.dart';
import '../../core/widgets/common/buildable.dart';
import 'bloc/audiobooks_bloc.dart';

class AudiobooksView extends StatelessWidget {
  const AudiobooksView({super.key});

  @override
  Widget build(BuildContext context) {
    return Buildable<AudiobooksBloc, AudiobooksState, AudiobooksBuildable>(
      properties: (buildable) => [
        buildable.audiobooksLoadingState,
        buildable.audiobooks,
      ],
      builder: (BuildContext context, buildable) {
        return Scaffold(
            backgroundColor: const Color(0xFFF9F9F9),
            appBar: AppBar(
              backgroundColor: const Color(0xFFF9F9F9),
              title: "Top Audiobooks ".w(500).s(20).c(Colors.black),
            ),
            body: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                itemBuilder: (BuildContext context, int index) {
                  return switch (buildable.audiobooksLoadingState) {
                    LoadingState.loading => const AudiobookShimmerWidget(),
                    LoadingState.loaded => AudiobookWidget(
                        audiobook: buildable.audiobooks[index],
                        callback: (Audiobook audio) {
                          context.router.push(AudiobookRoute(audiobook: audio));
                        }),
                    LoadingState.error => AudiobookErrorWidget(
                        callback: () {
                          context.read<AudiobooksBloc>().add(GetAudiobook());
                        },
                        offlinePlane: () {
                          context
                              .read<AudiobooksBloc>()
                              .add(GetAudiobookFromLocalDatabase());
                        },
                      ),
                    LoadingState.empty => const AudiobookEmptyWidget()
                  };
                },
                itemCount: switch (buildable.audiobooksLoadingState) {
                  LoadingState.loading => 9,
                  LoadingState.loaded => buildable.audiobooks.length,
                  LoadingState.error => 1,
                  LoadingState.empty => 1
                }));
      },
    );
  }
}
