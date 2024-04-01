import '../../../domain/modules/audio/audio.dart';
import '../../../domain/modules/audiobooks/audiobooks.dart';

abstract class AppDatabaseProvider {
  Future<void> savedAudiobooks({required List<Audiobook> audiobooks});

  Future<List<Audiobook>> getSavedAudiobooks();

  Future<void> savedAudios(
      {required List<Audio> audios, required int audiobookId});

  Future<List<Audio>> getSavedAudios({required int audiobookId});

  Future<void> savedAudioPath(
      {required int audioId, required String path, required String filename});

  Future<String> getAudioPath({required int audioId});
}
