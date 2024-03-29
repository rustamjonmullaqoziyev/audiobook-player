part of 'audiobook_player_bloc.dart';

abstract class AudiobookPlayerState {}

@freezed
class AudiobookPlayerBuildable extends AudiobookPlayerState
    with _$AudiobookPlayerBuildable {
  const factory AudiobookPlayerBuildable() = _AudiobookPlayerBuildable;
}

@freezed
class AudiobookPlayerListenable extends AudiobookPlayerState
    with _$AudiobookPlayerListenable {
  const factory AudiobookPlayerListenable({
    required AudiobookPlayerEffect effect,
    String? message,
  }) = _AudiobookPlayerListenable;
}

enum AudiobookPlayerEffect {
  navigationToPlayer,
  loading,
  error,
  success,
}
