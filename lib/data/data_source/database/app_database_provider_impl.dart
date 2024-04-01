import 'package:audiobook/domain/modules/audio/audio.dart';
import 'package:audiobook/domain/modules/audiobooks/audiobooks.dart';
import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'app_database_provider.dart';

@LazySingleton(as: AppDatabaseProvider)
class AppDatabaseProviderImpl extends AppDatabaseProvider {
  static final AppDatabaseProviderImpl _databaseService =
      AppDatabaseProviderImpl._internal();

  factory AppDatabaseProviderImpl() => _databaseService;

  AppDatabaseProviderImpl._internal();

  static Database? _database;

  AppDatabaseProviderImpl._();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    final getDirectory = await getApplicationDocumentsDirectory();
    String path = '${getDirectory.path}/audiobooks.db';
    return await openDatabase(path, onCreate: _onCreate, version: 1);
  }

  void _onCreate(Database db, int version) async {
    await db.execute(
        'CREATE TABLE Audiobook(audiobookId INTEGER PRIMARY KEY Not null, name TEXT, author TEXT, description TEXT, url TEXT, imageUrl TEXT, position INTEGER Not null )');
    await db.execute(
        'CREATE TABLE Audio(audioId INTEGER PRIMARY KEY Not null, audiobookId INTEGER Not null, name TEXT, author TEXT, description TEXT, url TEXT, imageUrl TEXT, position INTEGER Not null )');
    await db.execute(
        'CREATE TABLE AudioFile(audioId INTEGER PRIMARY KEY Not null, path TEXT, filename TEXT)');
  }

  @override
  Future<List<Audiobook>> getSavedAudiobooks() async {
    try {
      final db = await _databaseService.database;
      var data = await db.rawQuery('SELECT * FROM Audiobook');
      List<Audiobook> audiobooks = List.generate(
          data.length, (index) => Audiobook.fromJson(data[index]));
      return audiobooks;
    } catch (e) {
      return List.empty();
    }
  }

  @override
  Future<List<Audio>> getSavedAudios({required int audiobookId}) async {
    try {
      final db = await _databaseService.database;
      var data = await db.query(
        'Audio',
        where: 'audiobookId = ?',
        whereArgs: [audiobookId],
      );
      List<Audio> audios =
          List.generate(data.length, (index) => Audio.fromJson(data[index]));
      if(audios.isEmpty) {
        return List.empty();
      } else {
        return audios;
      }
    } catch (e) {
      return List.empty();
    }
  }

  @override
  Future<void> savedAudiobooks({required List<Audiobook> audiobooks}) async {
    final db = await _databaseService.database;
    for (var element in audiobooks) {
      await db.rawInsert(
          'INSERT OR REPLACE INTO Audiobook(audiobookId,name,author ,description,url ,imageUrl, position) VALUES(?, ?,?,?,?,?,?)',
          [
            element.id,
            element.name,
            element.author,
            element.description,
            element.url,
            element.imageUrl,
            element.position,
          ]);
    }
  }

  @override
  Future<void> savedAudios(
      {required List<Audio> audios, required int audiobookId}) async {
    final db = await _databaseService.database;
    for (var element in audios) {
      await db.rawInsert(
          'INSERT OR REPLACE INTO Audio(audioId,audiobookId,name,url ,description, position) VALUES(?, ?,?,?,?,?)',
          [
            element.id,
            audiobookId,
            element.name,
            element.url,
            element.description,
            element.position,
          ]);
    }
  }

  @override
  Future<void> savedAudioPath(
      {required int audioId,
      required String path,
      required String filename}) async {
    final db = await _databaseService.database;
    await db.rawInsert(
        'INSERT OR REPLACE INTO AudioFile(audioId, path, filename), VALUES(?, ?,?)',
        [audioId, path, filename]);
  }

  @override
  Future<String> getAudioPath({required int audioId}) async {
    final Database db = await database;

    final List<Map<String, dynamic>> maps = await db.query(
      'audios',
      where: 'audioId = ?',
      whereArgs: [audioId],
    );

    if (maps.isNotEmpty) {
      return maps.first['path'];
    }

    throw Exception('ID $audioId not found');
  }
}
