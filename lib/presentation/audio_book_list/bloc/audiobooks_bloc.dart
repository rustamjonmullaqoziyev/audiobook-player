import 'package:audiobook/domain/repositories/audiobook_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../core/utils/utils.dart';
import '../../../domain/modules/audiobooks/audiobooks.dart';

part 'audiobooks_bloc.freezed.dart';

part 'audiobooks_event.dart';

part 'audiobooks_state.dart';

@Injectable()
class AudiobooksBloc extends Bloc<AudiobooksEvent, AudiobooksState> {
  late AudiobooksBuildable _built;
  final AudiobookRepository _audiobooksRepository;

  AudiobooksBloc(this._audiobooksRepository)
      : super(const AudiobooksBuildable()) {
    _built = state as AudiobooksBuildable;
    getAudiobooks();
  }

  build(
    AudiobooksBuildable Function(AudiobooksBuildable buildable) builder,
  ) {
    _built = builder(_built);
    emit(_built);
  }

  Future<void> getAudiobooks() async {
    try {
      build((buildable) => buildable.copyWith(audiobooksLoadingState: LoadingState.loading));
      final audiobooks = await _audiobooksRepository.getAudiobooks();
      build((buildable) => buildable.copyWith(
          audiobooks: audiobooks,
          audiobooksLoadingState: LoadingState.loaded));
    } catch (e) {
      build((buildable) =>
          buildable.copyWith(audiobooksLoadingState: LoadingState.error));
    }
  }
}
