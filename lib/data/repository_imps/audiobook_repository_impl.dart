import 'package:audiobook/data/mapper/audio_mapper.dart';
import 'package:audiobook/data/mapper/audiobook_mapper.dart';
import 'package:audiobook/data/responses/audio/audios_response.dart';
import 'package:audiobook/data/responses/audiobook/audiobooks_response.dart';
import 'package:audiobook/domain/modules/audio/audio.dart';
import 'package:audiobook/domain/modules/audiobooks/audiobooks.dart';
import 'package:audiobook/domain/repositories/audiobook_repository.dart';
import 'package:injectable/injectable.dart';

import '../data_source/database/app_database_provider.dart';
import '../data_source/service/audiobook_service.dart';

@Injectable(as: AudiobookRepository)
class AudiobookRepositoryImpl implements AudiobookRepository {
  final AudiobooksService service;
  final AppDatabaseProvider databaseProvider;

  AudiobookRepositoryImpl(this.service, this.databaseProvider);

  @override
  Future<List<Audiobook>> getAudiobooks() async {
    final response = await service.getAudiobooks();
    final responses = AudiobooksResponse.fromJson(response.data).audiobooks;
    final audiobooks = <Audiobook>[];
    for (var i = 0; i < responses.length; i++) {
      audiobooks.add(responses[i].toAudiobook(position: i));
    }
    await databaseProvider.savedAudiobooks(audiobooks: audiobooks);
    return audiobooks;
  }

  @override
  Future<List<Audio>> getAudios({required int id}) async {
    final response = await service.getAudios(id: id);
    final responses = AudiosResponse.fromJson(response.data).audios;
    final audios = <Audio>[];
    for (var i = 0; i < responses.length; i++) {
      audios.add(responses[i].toAudio(position: i));
    }
    await databaseProvider.savedAudios(audios: audios, audiobookId: id);
    return audios;
  }

  @override
  Future<void> downloadAudio(
      {required int audioId, required String url, required String name}) async {
    final path = await service.downloadFile(url: url, filename: name);
    databaseProvider.savedAudioPath(
        audioId: audioId, path: path, filename: name);
  }

  @override
  Future<String> getSavedAudioPath({required int audioId}) async {
    return databaseProvider.getAudioPath(audioId: audioId);
  }

  @override
  Future<List<Audiobook>> getAudiobooksFormLocalDatabase() async {
    return await databaseProvider.getSavedAudiobooks();
  }

  @override
  Future<List<Audio>> getAudiosFromLocalDatabase({required int id}) async {
    return await databaseProvider.getSavedAudios(audiobookId: id);
  }
}
