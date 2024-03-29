import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../domain/repositories/audiobook_repository.dart';

part 'audiobook_player_bloc.freezed.dart';

part 'audiobook_player_event.dart';

part 'audiobook_player_state.dart';

@Injectable()
class AudiobookPlayerBloc
    extends Bloc<AudiobookPlayerEvent, AudiobookPlayerState> {
  late AudiobookPlayerBuildable _built;
  final AudiobookRepository _audiobooksRepository;

  AudiobookPlayerBloc(this._audiobooksRepository)
      : super(const AudiobookPlayerBuildable()) {
    _built = state as AudiobookPlayerBuildable;
  }

  build(
    AudiobookPlayerBuildable Function(AudiobookPlayerBuildable buildable)
        builder,
  ) {
    _built = builder(_built);
    emit(_built);
  }
}
