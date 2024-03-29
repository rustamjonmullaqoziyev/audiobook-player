import '../modules/audiobooks/audiobooks.dart';

abstract class AudiobookRepository {
  
  Future<List<Audiobook>> getAudiobooks();
}
