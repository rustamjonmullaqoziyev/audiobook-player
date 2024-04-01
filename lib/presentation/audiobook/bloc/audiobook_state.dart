part of 'audiobook_bloc.dart';

abstract class AudiobookState {}

@freezed
class AudiobookBuildable extends AudiobookState with _$AudiobookBuildable {
  const factory AudiobookBuildable({
    @Default([]) List<Audio> audios,
    @Default(LoadingState.loading) LoadingState audiosLoadingState,
    @Default(false) bool isPlaying,
    @Default(LoopMode.off) LoopMode loopMode,
    @Default(true) bool audioLoading,
    @Default(false) bool isShuffleModeEnabled,
    @Default(true) bool isReorderAudios,
    @Default(Duration.zero) Duration positionDuration,
    @Default(0) int currentIndex,
  }) = _AudiobookBuildable;
}

@freezed
class AudiobookListenable extends AudiobookState with _$AudiobookListenable {
  const factory AudiobookListenable({
    required AudiobookEffect effect,
    String? message,
  }) = _AudiobookListenable;
}

enum AudiobookEffect { audioDownload }
