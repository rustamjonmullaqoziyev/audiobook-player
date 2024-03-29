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
    String path = '${getDirectory.path}/audiobook.db';
    return await openDatabase(path, onCreate: _onCreate, version: 1);
  }

  void _onCreate(Database db, int version) async {
    await db.execute(
        'CREATE TABLE Article(id TEXT PRIMARY KEY Not null, author TEXT, title TEXT, description TEXT, url TEXT, urlToImage TEXT, published  TEXT, content TEXT, sourceName TEXT, sourceId TEXT, isFavourite INTEGER)');
  }
}
