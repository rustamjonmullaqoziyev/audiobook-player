import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:just_audio/just_audio.dart';

import '../../../core/audio/audio_helper.dart';
import '../../../core/utils/utils.dart';
import '../../../domain/modules/audio/audio.dart';
import '../../../domain/modules/audiobooks/audiobooks.dart';
import '../../../domain/repositories/audiobook_repository.dart';

part 'audiobook_bloc.freezed.dart';

part 'audiobook_event.dart';

part 'audiobook_state.dart';

@Injectable()
class AudiobookBloc extends Bloc<AudiobookEvent, AudiobookState> {
  late AudiobookBuildable _built;
  final AudiobookRepository _audiobooksRepository;
  final AudioProvider _audioHelper;

  AudiobookBloc(this._audiobooksRepository, this._audioHelper)
      : super(const AudiobookBuildable()) {
    _built = state as AudiobookBuildable;

    playerStateStream();
    shuffleModeEnabledStream();
    loopModeStream();
    positionStream();
    currentIndexStream();

    on<SetAudiobookEvent>(_onSetAudiobookEvent);
    on<GetAudiosEvent>(_onGetAudiosEvent);
    on<GetAudiosFromLocalDatabaseEvent>(_onGetAudiosFromLocalDatabaseEvent);
    on<AudioDownload>(_onAudioDownloadEvent);

    on<AudiobookPlaying>(_onAudiobookPlayingEvent);
    on<AudioPlaying>(_onAudioPlayingEvent);
    on<AudioPause>(_onAudioPauseEvent);
    on<NextAudio>(_onNextAudioEvent);
    on<PreviousAudio>(_onPreviousAudioEvent);
    on<AudioShuffle>(_onAudioShuffleEvent);
    on<AudioRepeat>(_onAudioRepeatEvent);
    on<AudioOrder>(_onAudioOrderEvent);
  }

  build(
    AudiobookBuildable Function(AudiobookBuildable buildable) builder,
  ) {
    _built = builder(_built);
    emit(_built);
  }

  void playerStateStream() async {
    _audioHelper.audioPlayer.playerStateStream.listen((state) {
      if (state.playing) {
        build((buildable) => buildable.copyWith(isPlaying: true));
      } else {
        build((buildable) => buildable.copyWith(isPlaying: false));
      }

      switch (state.processingState) {
        case ProcessingState.idle:
          build((buildable) => buildable.copyWith(audioLoading: true));
        case ProcessingState.loading:
          build((buildable) => buildable.copyWith(audioLoading: true));
        case ProcessingState.buffering:
          build((buildable) => buildable.copyWith(audioLoading: true));
        case ProcessingState.ready:
          build((buildable) => buildable.copyWith(audioLoading: false));
        case ProcessingState.completed:
          {
            build((buildable) => buildable.copyWith(audioLoading: false));
          }
      }
    });
  }

  void shuffleModeEnabledStream() {
    _audioHelper.audioPlayer.shuffleModeEnabledStream.listen((value) {
      build((buildable) => buildable.copyWith(isShuffleModeEnabled: value));
    });
  }

  void loopModeStream() {
    _audioHelper.audioPlayer.loopModeStream.listen((value) {
      build((buildable) => buildable.copyWith(loopMode: value));
    });
  }

  void positionStream() {
    _audioHelper.audioPlayer.positionStream.listen((value) {
      build((buildable) => buildable.copyWith(positionDuration: value));
    });
  }

  void currentIndexStream() {
    _audioHelper.audioPlayer.currentIndexStream.listen((value) {
      build((buildable) => buildable.copyWith(currentIndex: value ?? 0));
    });
  }

  Future<void> getAudios({required int id}) async {
    try {
      build((buildable) =>
          buildable.copyWith(audiosLoadingState: LoadingState.loading));
      final audios = await _audiobooksRepository.getAudios(id: id);
      if (audios.isNotEmpty) {
        build((buildable) => buildable.copyWith(
            audios: audios, audiosLoadingState: LoadingState.loaded));
        _audioHelper.setAudios(audios);
      } else {
        build((buildable) =>
            buildable.copyWith(audiosLoadingState: LoadingState.empty));
      }
    } catch (e) {
      build((buildable) =>
          buildable.copyWith(audiosLoadingState: LoadingState.error));
    }
  }

  Future<void> getAudioFromLocalDatabase({required int id}) async {
    try {
      build((buildable) =>
          buildable.copyWith(audiosLoadingState: LoadingState.loading));
      final audios =
          await _audiobooksRepository.getAudiosFromLocalDatabase(id: id);
      if (audios.isNotEmpty) {
        build((buildable) => buildable.copyWith(
            audios: audios, audiosLoadingState: LoadingState.loaded));
        _audioHelper.setAudios(audios);
      } else {
        build((buildable) =>
            buildable.copyWith(audiosLoadingState: LoadingState.empty));
      }
    } catch (e) {
      print(e.toString());
      build((buildable) =>
          buildable.copyWith(audiosLoadingState: LoadingState.error));
    }
  }

  _onSetAudiobookEvent(
      SetAudiobookEvent event, Emitter<AudiobookState> emit) async {
    if (_built.audios.isEmpty &&
        _built.audiosLoadingState != LoadingState.error &&
        _built.audiosLoadingState != LoadingState.empty) {
      await getAudios(id: event.audiobook.id);
    }
  }

  _onGetAudiosEvent(GetAudiosEvent event, Emitter<AudiobookState> emit) async {
    if (_built.audios.isEmpty) {
      await getAudios(id: event.audiobook.id);
    }
  }

  _onGetAudiosFromLocalDatabaseEvent(GetAudiosFromLocalDatabaseEvent event,
      Emitter<AudiobookState> emit) async {
    await getAudioFromLocalDatabase(id: event.audiobook.id);
  }

  _onAudioDownloadEvent(
      AudioDownload event, Emitter<AudiobookState> emit) async {
    await _audiobooksRepository.downloadAudio(
        audioId: event.audiobook.id,
        url: event.audiobook.url,
        name: event.audiobook.name);

    emit(const AudiobookListenable(effect: AudiobookEffect.audioDownload));
  }

  _onAudiobookPlayingEvent(
      AudiobookPlaying event, Emitter<AudiobookState> emit) async {
    await _audioHelper.audioPlay(
        currentIndex: _built.currentIndex,
        currentPosition: _built.positionDuration);
  }

  _onAudioPauseEvent(AudioPause event, Emitter<AudiobookState> emit) async {
    await _audioHelper.audioPause();
  }

  _onAudioPlayingEvent(AudioPlaying event, Emitter<AudiobookState> emit) async {
    await _audioHelper.audioPlayOnIndex(event.index);
  }

  _onNextAudioEvent(NextAudio event, Emitter<AudiobookState> emit) async {
    await _audioHelper.nextAudio();
  }

  _onPreviousAudioEvent(
      PreviousAudio event, Emitter<AudiobookState> emit) async {
    await _audioHelper.previousAudio();
  }

  _onAudioShuffleEvent(AudioShuffle event, Emitter<AudiobookState> emit) async {
    await _audioHelper.setShuffleMode(
        isShuffleModeEnabled: !_built.isShuffleModeEnabled);
  }

  _onAudioRepeatEvent(AudioRepeat event, Emitter<AudiobookState> emit) async {
    await _audioHelper.setLoopingMode(event.loopMode);
  }

  _onAudioOrderEvent(AudioOrder event, Emitter<AudiobookState> emit) async {
    await _audioHelper.reverseOrder();
    build((buildable) => buildable.copyWith(
        isReorderAudios: !buildable.isReorderAudios,
        audios: buildable.audios.reversed.toList()));
  }
}
