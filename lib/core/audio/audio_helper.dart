import 'package:injectable/injectable.dart';
import 'package:just_audio/just_audio.dart';

import '../../domain/modules/audio/audio.dart';

@lazySingleton
class AudioProvider {
  final audioPlayer = AudioPlayer();

  ConcatenatingAudioSource defaultPlaylist = ConcatenatingAudioSource(
      useLazyPreparation: true,
      shuffleOrder: DefaultShuffleOrder(),
      children: []);

  Future<void> audioPlay(
      {required int currentIndex, required Duration currentPosition}) async {
    await audioPlayer.setAudioSource(defaultPlaylist,
        initialIndex: currentIndex, initialPosition: currentPosition);
    await audioPlayer.play();
  }

  Future<void> audioPlayOnIndex(int currentIndex) async {
    await audioPlayer.setAudioSource(defaultPlaylist,
        initialIndex: currentIndex, initialPosition: Duration.zero);
    await audioPlayer.play();
  }

  Future<void> audioPause() async {
    await audioPlayer.pause();
  }

  Future<void> audioStop() async {
    await audioPlayer.stop();
  }

  Future<void> nextAudio() async {
    await audioPlayer.seekToNext();
  }

  Future<void> previousAudio() async {
    await audioPlayer.seekToPrevious();
  }

  Future<void> setLoopingMode(LoopMode loopMode) async {
    await audioPlayer.setLoopMode(loopMode);
  }

  Future<void> setShuffleMode({required bool isShuffleModeEnabled}) async {
    await audioPlayer.setShuffleModeEnabled(isShuffleModeEnabled);
  }

  Future<void> setAudios(List<Audio> audios) async {
    for (var element in audios) {
      defaultPlaylist.add(AudioSource.uri(Uri.parse(element.url)));
    }
    await audioPlayer.setAudioSource(defaultPlaylist);
  }

  Future<void> reverseOrder() async {
    await defaultPlaylist.move(0, defaultPlaylist.length - 1);
  }
}
