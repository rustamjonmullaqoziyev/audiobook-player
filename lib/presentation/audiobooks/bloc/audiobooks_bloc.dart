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
    on<GetAudiobook>(_getAudiobooks);
    on<GetAudiobookFromLocalDatabase>(_getAudiobooksFromLocalDatabase);
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
      build((buildable) =>
          buildable.copyWith(audiobooksLoadingState: LoadingState.loading));
      final audiobooks = await _audiobooksRepository.getAudiobooks();
      if (audiobooks.isNotEmpty) {
        build((buildable) => buildable.copyWith(
            audiobooks: audiobooks,
            audiobooksLoadingState: LoadingState.loaded));
      } else {
        build((buildable) =>
            buildable.copyWith(audiobooksLoadingState: LoadingState.empty));
      }
    } catch (e) {
      build((buildable) =>
          buildable.copyWith(audiobooksLoadingState: LoadingState.error));
    }
  }

  _getAudiobooks(GetAudiobook event, Emitter<AudiobooksState> emit) async {
    await getAudiobooks();
  }

  _getAudiobooksFromLocalDatabase(GetAudiobookFromLocalDatabase event,
      Emitter<AudiobooksState> emit) async {
    try {
      build((buildable) =>
          buildable.copyWith(audiobooksLoadingState: LoadingState.loading));
      final audiobooks = await _audiobooksRepository.getAudiobooksFormLocalDatabase();
      if (audiobooks.isNotEmpty) {
        build((buildable) => buildable.copyWith(
            audiobooks: audiobooks,
            audiobooksLoadingState: LoadingState.loaded));
      } else {
        build((buildable) =>
            buildable.copyWith(audiobooksLoadingState: LoadingState.empty));
      }
    } catch (e) {
      build((buildable) =>
          buildable.copyWith(audiobooksLoadingState: LoadingState.error));
    }
  }
}
