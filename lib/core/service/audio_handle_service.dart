import 'package:audio_service/audio_service.dart';
import 'package:audiobook/core/di/injection.dart';
import 'package:injectable/injectable.dart';
import 'package:just_audio/just_audio.dart';

import '../audio/audio_helper.dart';

Future<AudioHandler> initAudioService() async {
  return await AudioService.init(
    builder: () => getIt<AudioHandlerService>(),
    config: const AudioServiceConfig(
      androidNotificationChannelId: 'rm.studio.audiobook',
      androidNotificationChannelName: 'Audio Service Demo',
      androidNotificationOngoing: true,
    ),
  );
}

@lazySingleton
class AudioHandlerService extends BaseAudioHandler {
  AudioHandlerService(this.audioProvider) {
    _notifyAudioHandlerAboutPlaybackEvents();
    _listenForDurationChanges();
    _listenForCurrentSongIndexChanges();
    _listenForSequenceStateChanges();
  }

  final AudioProvider audioProvider;

  void _notifyAudioHandlerAboutPlaybackEvents() {
    audioProvider.audioPlayer.playbackEventStream.listen((PlaybackEvent event) {
      final playing = audioProvider.audioPlayer.playing;
      playbackState.add(playbackState.value.copyWith(
        controls: [
          MediaControl.skipToPrevious,
          if (playing) MediaControl.pause else MediaControl.play,
          MediaControl.stop,
          MediaControl.skipToNext,
        ],
        systemActions: const {
          MediaAction.seek,
        },
        androidCompactActionIndices: const [0, 1, 3],
        processingState: const {
          ProcessingState.idle: AudioProcessingState.idle,
          ProcessingState.loading: AudioProcessingState.loading,
          ProcessingState.buffering: AudioProcessingState.buffering,
          ProcessingState.ready: AudioProcessingState.ready,
          ProcessingState.completed: AudioProcessingState.completed,
        }[audioProvider.audioPlayer.processingState]!,
        repeatMode: const {
          LoopMode.off: AudioServiceRepeatMode.none,
          LoopMode.one: AudioServiceRepeatMode.one,
          LoopMode.all: AudioServiceRepeatMode.all,
        }[audioProvider.audioPlayer.loopMode]!,
        shuffleMode: (audioProvider.audioPlayer.shuffleModeEnabled)
            ? AudioServiceShuffleMode.all
            : AudioServiceShuffleMode.none,
        playing: playing,
        updatePosition: audioProvider.audioPlayer.position,
        bufferedPosition: audioProvider.audioPlayer.bufferedPosition,
        speed: audioProvider.audioPlayer.speed,
        queueIndex: event.currentIndex,
      ));
    });
  }

  void _listenForDurationChanges() {
    audioProvider.audioPlayer.positionStream.listen((duration) {
      var index = audioProvider.audioPlayer.currentIndex;
      final newQueue = queue.value;
      if (index == null || newQueue.isEmpty) return;
      if (audioProvider.audioPlayer.shuffleModeEnabled) {
        index = audioProvider.audioPlayer.shuffleIndices!.indexOf(index);
      }
      final oldMediaItem = newQueue[index];
      final newMediaItem = oldMediaItem.copyWith(duration: duration);
      newQueue[index] = newMediaItem;
      queue.add(newQueue);
      mediaItem.add(newMediaItem);
    });
  }

  void _listenForCurrentSongIndexChanges() {
    audioProvider.audioPlayer.currentIndexStream.listen((index) {
      final playlist = queue.value;
      if (index == null || playlist.isEmpty) return;
      if (audioProvider.audioPlayer.shuffleModeEnabled) {
        index = audioProvider.audioPlayer.shuffleIndices!.indexOf(index);
      }
      mediaItem.add(playlist[index]);
    });
  }

  void _listenForSequenceStateChanges() {
    audioProvider.audioPlayer.sequenceStateStream
        .listen((SequenceState? sequenceState) {
      final sequence = sequenceState?.effectiveSequence;
      if (sequence == null || sequence.isEmpty) return;
      final items = sequence.map((source) => source.tag as MediaItem);
      queue.add(items.toList());
    });
  }

  @override
  Future<void> addQueueItems(List<MediaItem> mediaItems) async {
    final audioSource = mediaItems.map(_createAudioSource);
    audioProvider.defaultPlaylist.addAll(audioSource.toList());
    final newQueue = queue.value..addAll(mediaItems);
    queue.add(newQueue);
  }

  @override
  Future<void> addQueueItem(MediaItem mediaItem) async {
    final audioSource = _createAudioSource(mediaItem);
    audioProvider.defaultPlaylist.add(audioSource);
    final newQueue = queue.value..add(mediaItem);
    queue.add(newQueue);
  }

  UriAudioSource _createAudioSource(MediaItem mediaItem) {
    return AudioSource.uri(
      Uri.parse(mediaItem.extras!['url'] as String),
      tag: mediaItem,
    );
  }

  @override
  Future<void> removeQueueItemAt(int index) async {
    audioProvider.defaultPlaylist.removeAt(index);
    final newQueue = queue.value..removeAt(index);
    queue.add(newQueue);
  }

  @override
  Future<void> play() => audioProvider.audioPlayer.play();

  @override
  Future<void> pause() => audioProvider.audioPlayer.pause();

  @override
  Future<void> seek(Duration position) =>
      audioProvider.audioPlayer.seek(position);

  @override
  Future<void> skipToQueueItem(int index) async {
    if (index < 0 || index >= queue.value.length) return;
    if (audioProvider.audioPlayer.shuffleModeEnabled) {
      index = audioProvider.audioPlayer.shuffleIndices![index];
    }
    audioProvider.audioPlayer.seek(Duration.zero, index: index);
  }

  @override
  Future<void> skipToNext() => audioProvider.audioPlayer.seekToNext();

  @override
  Future<void> skipToPrevious() => audioProvider.audioPlayer.seekToPrevious();

  @override
  Future<void> setRepeatMode(AudioServiceRepeatMode repeatMode) async {
    switch (repeatMode) {
      case AudioServiceRepeatMode.none:
        audioProvider.audioPlayer.setLoopMode(LoopMode.off);
        break;
      case AudioServiceRepeatMode.one:
        audioProvider.audioPlayer.setLoopMode(LoopMode.one);
        break;
      case AudioServiceRepeatMode.group:
      case AudioServiceRepeatMode.all:
        audioProvider.audioPlayer.setLoopMode(LoopMode.all);
        break;
    }
  }

  @override
  Future<void> setShuffleMode(AudioServiceShuffleMode shuffleMode) async {
    if (shuffleMode == AudioServiceShuffleMode.none) {
      audioProvider.audioPlayer.setShuffleModeEnabled(false);
    } else {
      await audioProvider.audioPlayer.shuffle();
      audioProvider.audioPlayer.setShuffleModeEnabled(true);
    }
  }

  @override
  Future<void> customAction(String name, [Map<String, dynamic>? extras]) async {
    if (name == 'dispose') {
      await audioProvider.audioPlayer.dispose();
      super.stop();
    }
  }

  @override
  Future<void> stop() async {
    await audioProvider.audioStop();
    return super.stop();
  }
}
