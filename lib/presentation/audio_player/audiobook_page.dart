import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/di/injection.dart';
import '../../domain/modules/audiobooks/audiobooks.dart';
import 'audiobook_view.dart';
import 'bloc/audiobook_player_bloc.dart';

@RoutePage()
class AudiobookPlayerPage extends StatelessWidget {
  const AudiobookPlayerPage({super.key, required this.audiobook});

  final Audiobook audiobook;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      lazy: false,
      create: (_) => getIt<AudiobookPlayerBloc>(),
      child: BlocListener<AudiobookPlayerBloc, AudiobookPlayerState>(
        listenWhen: (_, state) => state is AudiobookPlayerListenable,
        listener: (context, listenable) {},
        child: AudiobookPlayerView(
          audiobook: audiobook,
        ),
      ),
    );
  }
}
