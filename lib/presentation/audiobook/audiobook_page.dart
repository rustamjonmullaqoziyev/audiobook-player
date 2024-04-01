import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/di/injection.dart';
import '../../domain/modules/audiobooks/audiobooks.dart';
import 'audiobook_view.dart';
import 'bloc/audiobook_bloc.dart';

@RoutePage()
class AudiobookPage extends StatelessWidget {
  const AudiobookPage({super.key, required this.audiobook});

  final Audiobook audiobook;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      lazy: false,
      create: (_) => getIt<AudiobookBloc>(),
      child: BlocListener<AudiobookBloc, AudiobookState>(
        listenWhen: (_, state) => state is AudiobookListenable,
        listener: (context, listenable) {
          final effect = (listenable as AudiobookListenable).effect;
          switch (effect) {
            case AudiobookEffect.audioDownload:
              ScaffoldMessenger.of(context)
                  .showSnackBar(const SnackBar(content: Text("download")));
          }
        },
        child: AudiobookView(
          audiobook: audiobook,
        ),
      ),
    );
  }
}
