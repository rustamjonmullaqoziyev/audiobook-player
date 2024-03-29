import 'package:audiobook/data/mapper/audiobook_mapper.dart';
import 'package:audiobook/data/responses/audiobook/audiobooks_response.dart';
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
    final audiobooks = AudiobooksResponse.fromJson(response.data)
        .audiobooks
        .map((audiobook) => audiobook.toAudiobook())
        .toList();
    return audiobooks;
  }
}
