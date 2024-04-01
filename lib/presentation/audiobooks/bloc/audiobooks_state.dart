part of 'audiobooks_bloc.dart';

abstract class AudiobooksState {}

@freezed
class AudiobooksBuildable extends AudiobooksState with _$AudiobooksBuildable {
  const factory AudiobooksBuildable(
          {@Default([]) List<Audiobook> audiobooks,
          @Default(LoadingState.loading) LoadingState audiobooksLoadingState}) =
      _AudiobooksBuildable;
}

@freezed
class AudiobooksListenable extends AudiobooksState with _$AudiobooksListenable {
  const factory AudiobooksListenable({
    required AudiobooksEffect effect,
    String? message,
  }) = _AudiobooksListenable;
}

enum AudiobooksEffect { openAudiobook }
