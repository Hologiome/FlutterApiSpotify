import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '/models/Album.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart'; // Mettez à jour avec le chemin correct vers votre modèle Playlist
import 'package:path/path.dart';

class DatabaseService {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDb();
    return _database!;
  }

  initDb() async {
    print("totoss");
    // final dbPath = await getDatabasesPath();
    final dbPath = "/";
    print(dbPath);
    return await openDatabase(
      join(dbPath, 'playlist.db'),
      onCreate: (db, version) {
        print("toto");
        return db.execute(
          "CREATE TABLE playlists(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, trackIds TEXT)",
        );
      },
      version: 1,
    );
  }

  Future<void> insertPlaylist(Playlist playlist) async {
    final db = await database;
    await db.insert(
      'playlists',
      playlist.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Ajouter d'autres méthodes pour récupérer des playlists, ajouter des chansons à une playlist, etc.
}
