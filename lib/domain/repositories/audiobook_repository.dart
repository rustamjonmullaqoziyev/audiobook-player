import 'dart:async';

import '../modules/audio/audio.dart';
import '../modules/audiobooks/audiobooks.dart';

abstract class AudiobookRepository {
  Future<List<Audiobook>> getAudiobooks();

  Future<List<Audio>> getAudios({required int id});

  Future<void> downloadAudio(
      {required int audioId, required String url, required String name});

  Future<String> getSavedAudioPath({required int audioId});

  Future<List<Audiobook>> getAudiobooksFormLocalDatabase();

  Future<List<Audio>> getAudiosFromLocalDatabase({required int id});
}
