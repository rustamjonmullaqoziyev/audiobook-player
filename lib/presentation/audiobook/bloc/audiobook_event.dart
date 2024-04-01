part of 'audiobook_bloc.dart';

abstract class AudiobookEvent {}

class SetAudiobookEvent extends AudiobookEvent {
  SetAudiobookEvent(this.audiobook);

  final Audiobook audiobook;
}

class GetAudiosEvent extends AudiobookEvent {
  GetAudiosEvent(this.audiobook);

  final Audiobook audiobook;
}

class GetAudiosFromLocalDatabaseEvent extends AudiobookEvent {
  GetAudiosFromLocalDatabaseEvent(this.audiobook);

  final Audiobook audiobook;
}

class AudioDownload extends AudiobookEvent{
  AudioDownload(this.audiobook);
  final Audiobook audiobook;
}

class AudiobookPlaying extends AudiobookEvent {}

class AudioPlaying extends AudiobookEvent {
  AudioPlaying(this.index, this.audio);

  final int index;
  final Audio audio;
}

class AudioPause extends AudiobookEvent {}

class NextAudio extends AudiobookEvent {}

class PreviousAudio extends AudiobookEvent {}

class AudioShuffle extends AudiobookEvent {}

class AudioRepeat extends AudiobookEvent {
  AudioRepeat(this.loopMode);

  final LoopMode loopMode;
}

class AudioOrder extends AudiobookEvent {}
