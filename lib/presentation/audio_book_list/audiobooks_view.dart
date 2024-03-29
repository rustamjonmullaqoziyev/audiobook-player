import 'package:audiobook/core/extensions/text_extensions.dart';
import 'package:audiobook/core/router/app_router.gr.dart';
import 'package:audiobook/domain/modules/audiobooks/audiobooks.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../core/gen/assets/assets.gen.dart';
import '../../core/utils/utils.dart';
import '../../core/widgets/audiobook/audiobook_shimmerr_widget.dart';
import '../../core/widgets/audiobook/audiobook_widget.dart';
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
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor:Colors.white,
              title: "Top Audiobooks ".w(500).s(20).c(Colors.black),
            ),
            body: Container(
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(32),
                        topRight: Radius.circular(32)), color: Color(0XFFEFF0F2)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                            onPressed: () {},
                            icon: Assets.images.icShuffle.svg()),
                        const SizedBox(width: 8),
                        IconButton(
                            onPressed: () {}, icon: Assets.images.icPlay.svg()),
                        const SizedBox(width: 16)
                      ],
                    ),
                    Expanded(
                      child: ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          itemBuilder: (BuildContext context, int index) {
                            return switch (buildable.audiobooksLoadingState) {
                              LoadingState.loading =>
                                const AudiobookShimmerWidget(),
                              LoadingState.loaded => AudiobookWidget(
                                  audiobook: buildable.audiobooks[index],
                                  callback: (Audiobook audio) {
                                    context.router.push(
                                        AudiobookPlayerRoute(audiobook: audio));
                                  },
                                ),
                              LoadingState.error =>
                                const AudiobookShimmerWidget(),
                            };
                          },
                          itemCount: switch (buildable.audiobooksLoadingState) {
                            LoadingState.loading => 9,
                            LoadingState.loaded => buildable.audiobooks.length,
                            LoadingState.error => 1
                          }),
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                          left: 12, right: 12, bottom: 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        color: const Color(0xFFF26B6C),
                      ),
                      padding: const EdgeInsets.all(6),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Assets.images.icMusic.svg(),
                          const SizedBox(width: 12),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              "name".w(400).s(12).c(Colors.black).copyWith(
                                  maxLines: 1, overflow: TextOverflow.ellipsis),
                              const SizedBox(height: 4),
                              "description"
                                  .w(400)
                                  .s(12)
                                  .c(Colors.black)
                                  .copyWith(
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis)
                            ],
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                              child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                  onPressed: () {},
                                  icon: Assets.images.icBack.svg()),
                              IconButton(
                                  onPressed: () {},
                                  icon: Assets.images.icPause.svg()),
                              IconButton(
                                  onPressed: () {},
                                  icon: Assets.images.icNext.svg()),
                              IconButton(
                                  onPressed: () {},
                                  icon: Assets.images.icRepeat.svg()),
                            ],
                          )),
                        ],
                      ),
                    )
                  ],
                )));
      },
    );
  }
}
