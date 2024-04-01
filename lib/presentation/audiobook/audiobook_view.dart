import 'package:audiobook/core/extensions/text_extensions.dart';
import 'package:audiobook/domain/modules/audiobooks/audiobooks.dart';
import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';

import '../../core/gen/assets/assets.gen.dart';
import '../../core/utils/utils.dart';
import '../../core/widgets/audio/audio_empty_widget.dart';
import '../../core/widgets/audio/audio_error_widget.dart';
import '../../core/widgets/audio/audio_shimmerr_widget.dart';
import '../../core/widgets/audio/audio_widget.dart';
import '../../core/widgets/common/buildable.dart';
import '../../domain/modules/audio/audio.dart';
import 'bloc/audiobook_bloc.dart';

class AudiobookView extends StatelessWidget {
  const AudiobookView({super.key, required this.audiobook});

  final Audiobook audiobook;

  @override
  Widget build(BuildContext context) {
    return Buildable<AudiobookBloc, AudiobookState, AudiobookBuildable>(
      properties: (buildable) => [
        buildable.audiosLoadingState,
        buildable.audios,
        buildable.loopMode,
        buildable.isPlaying,
        buildable.isShuffleModeEnabled,
        buildable.isReorderAudios,
        buildable.currentIndex,
      ],
      builder: (BuildContext context, buildable) {
        context.read<AudiobookBloc>().add(SetAudiobookEvent(audiobook));
        return Scaffold(
            appBar: AppBar(
              title: audiobook.name.w(400).c(Colors.black),
              centerTitle: true,
              leading: IconButton(
                onPressed: () => context.router.pop(),
                icon: Assets.images.icArrowLeft.svg(width: 24, height: 24),
              ),
            ),
            backgroundColor: const Color(0xFFF9F9F9),
            body: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                const SizedBox(height: 8),
                Container(
                  margin: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.1),
                  height: MediaQuery.of(context).size.height * 0.4,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(8)),
                  child: CachedNetworkImage(
                    fit: BoxFit.fill,
                    imageBuilder: (context, url) => Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        image: DecorationImage(
                          image: url,
                          fit: BoxFit.fill,
                          colorFilter: const ColorFilter.mode(
                            Colors.white,
                            BlendMode.colorBurn,
                          ),
                        ),
                      ),
                    ),
                    imageUrl: audiobook.imageUrl,
                    placeholder: (context, url) => const Center(
                        child: CircularProgressIndicator(
                      color: Colors.blue,
                    )),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                ),
                const SizedBox(height: 36),
                audiobook.name.w(500).s(20).c(Colors.black).copyWith(
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    textAlign: TextAlign.center),
                const SizedBox(width: 8),
                audiobook.author.w(500).s(20).c(Colors.black).copyWith(
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      textAlign: TextAlign.center,
                    ),
                const SizedBox(width: 8),
                audiobook.description.w(400).s(16).c(Colors.black).copyWith(
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                    textAlign: TextAlign.center),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                        onPressed: () {
                          context.read<AudiobookBloc>().add(PreviousAudio());
                        },
                        icon: Assets.images.icBack.svg()),
                    buildable.isPlaying
                        ? IconButton(
                            onPressed: () {
                              context.read<AudiobookBloc>().add(AudioPause());
                            },
                            icon: Assets.images.icPause.svg())
                        : IconButton(
                            onPressed: () {
                              context
                                  .read<AudiobookBloc>()
                                  .add(AudiobookPlaying());
                            },
                            icon: Assets.images.icPlay.svg()),
                    IconButton(
                        onPressed: () {
                          context.read<AudiobookBloc>().add(NextAudio());
                        },
                        icon: Assets.images.icNext.svg()),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(width: 16),
                    Expanded(child: "PlayList".w(400).s(16)),
                    IconButton(
                        onPressed: () {
                          context.read<AudiobookBloc>().add(AudioShuffle());
                        },
                        icon: Assets.images.icShuffle.svg(
                            color: buildable.isShuffleModeEnabled
                                ? Colors.blue
                                : Colors.black)),
                    switch (buildable.loopMode) {
                      LoopMode.off => IconButton(
                          onPressed: () {
                            context
                                .read<AudiobookBloc>()
                                .add(AudioRepeat(LoopMode.one));
                          },
                          icon: Assets.images.icRepeat.svg()),
                      LoopMode.one => InkWell(
                          onTap: () {
                            context
                                .read<AudiobookBloc>()
                                .add(AudioRepeat(LoopMode.all));
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Assets.images.icRepeat.svg(),
                              const SizedBox(width: 4),
                              "one".w(400).s(16).c(Colors.blue)
                            ],
                          )),
                      LoopMode.all => InkWell(
                          onTap: () {
                            context
                                .read<AudiobookBloc>()
                                .add(AudioRepeat(LoopMode.off));
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Assets.images.icRepeat.svg(),
                              const SizedBox(width: 4),
                              "all".w(400).s(16).c(Colors.blue)
                            ],
                          )),
                    },
                    IconButton(
                        onPressed: () {
                          context.read<AudiobookBloc>().add(AudioOrder());
                        },
                        icon: buildable.isReorderAudios
                            ? Assets.images.icDownArrow.svg()
                            : Assets.images.icArrowUp.svg()),
                  ],
                ),
                const SizedBox(height: 16),
                ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    itemBuilder: (BuildContext context, int index) {
                      return switch (buildable.audiosLoadingState) {
                        LoadingState.loading => const AudioShimmerWidget(),
                        LoadingState.loaded => AudioWidget(
                            audio: buildable.audios[index],
                            callback: (Audio audio) {
                              context
                                  .read<AudiobookBloc>()
                                  .add(AudioPlaying(index, audio));
                            },
                            isPlaying: index == buildable.currentIndex,
                            download: (Audio audio) {
                              context
                                  .read<AudiobookBloc>()
                                  .add(AudioDownload(audiobook));
                            },
                          ),
                        LoadingState.error => AudioErrorWidget(
                            callback: () {
                              context
                                  .read<AudiobookBloc>()
                                  .add(GetAudiosEvent(audiobook));
                            },
                            offlinePlan: () {
                              context.read<AudiobookBloc>().add(
                                  GetAudiosFromLocalDatabaseEvent(audiobook));
                            },
                          ),
                        LoadingState.empty => const AudioEmptyWidget()
                      };
                    },
                    itemCount: switch (buildable.audiosLoadingState) {
                      LoadingState.loading => 9,
                      LoadingState.loaded => buildable.audios.length,
                      LoadingState.error => 1,
                      LoadingState.empty => 1
                    }),
                const SizedBox(height: 16)
              ],
            ));
      },
    );
  }
}
