import 'package:flutter/foundation.dart' show immutable;
import 'package:new_begining/exceptions/custom_exceptions.dart'
    as exceptions
    show DatabaseAlreadyOpenException;
import 'package:new_begining/exceptions/custom_exceptions.dart';

import 'package:sqflite/sqflite.dart'
    as sqflite
    show getDatabasesPath, openDatabase, Database;

import 'package:path_provider/path_provider.dart'
    as path_provider
    show getApplicationDocumentsDirectory, MissingPlatformDirectoryException;

import 'package:path/path.dart' as p show join;

/// NotesServices is a singleton class that provides methods to interact with the SQLite database.
class NotesServices {
  sqflite.Database? _db;

  sqflite.Database _getDbInstanceOrThrow() {
    // final db = _db;
    if (_db == null) {
      throw DatabaseNotOpenException('Database is not opened');
    } else {
      return _db!;
    }
  }

  /// CRUDE OPERATIONS
  Future<void> deleteUser({required String email}) async {
    final db = _getDbInstanceOrThrow();
    final deletedUser = await db.delete(
      notesTable,
      where: 'email =?',
      whereArgs: [email.toLowerCase()],
    );
    if (deletedUser == 0) {
      throw Exception('Could not delete user with email $email');
    }
  }

  Future<DatabseUser> createUser({required String email}) async {
    _db = _getDbInstanceOrThrow();
    final results = await _db!.query(
      userTable,
      limit: 1,
      where: 'email = ?',
      whereArgs: [email.toLowerCase()],
    );
    if (results.isNotEmpty) {
      throw Exception('User with email $email already exists');
    }
    final userId = await _db!.insert(userTable, {
      emailColumn: email.toLowerCase(),
    });
    return DatabseUser(id: userId, email: email);
  }

  Future<DatabseUser> getUser({required String email}) async {
    _db = _getDbInstanceOrThrow();
    final results = await _db!.query(
      userTable,
      limit: 1,
      where: 'email = ?',
      whereArgs: [email.toLowerCase()],
    );
    if (results.isEmpty) {
      throw Exception('Could not find user with email $email');
    } else {
      return DatabseUser.fromUserRow(results.first);
    }
  }

  /// CREATE NOTE FUNCTION
  Future<DatabaseNotes> createNote({required DatabseUser owner}) async {
    _db = _getDbInstanceOrThrow();
    // make sure owner exists in the database with the correct id
    final dbUser = await getUser(email: owner.email);
    if (dbUser != owner) {
      throw Exception('You are not the owner of this note');
    }
    // create the note
    const text = '';
    final noteId = await _db!.insert(notesTable, {
      userIdColumn: owner.id,
      textColumn: text,
      isSyncedWithCloudColumn: 1,
    });
    return DatabaseNotes(
      id: noteId,
      userId: owner.id,
      text: text,
      isSyncedWithCloud: true,
    );
  }

  Future<DatabaseNotes> getNote({required int id}) async {
    _db = _getDbInstanceOrThrow();
    final notes = await _db!.query(
      notesTable,
      limit: 1,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (notes.isEmpty) {
      throw Exception('Could not find note with id $id');
    } else {
      return DatabaseNotes.fromRow(notes.first);
    }
  }

  Future<Iterable<DatabaseNotes>> getAllNotes({
    required DatabseUser owner,
  }) async {
    _db = _getDbInstanceOrThrow();
    // make sure owner exists in the database with the correct id
    final dbUser = await getUser(email: owner.email);
    if (dbUser != owner) {
      throw Exception('You are not the owner of this note');
    }
    final notes = await _db!.query(
      notesTable,
      where: 'user_id = ?',
      whereArgs: [owner.id],
    );
    return notes.map((noteRow) => DatabaseNotes.fromRow(noteRow));
  }

  // update note
  Future<DatabaseNotes> updateNote({
    required DatabaseNotes note,
    required String text,
  }) async {
    _db = _getDbInstanceOrThrow();
    // make sure note exists
    final dbNote = await getNote(id: note.id);
    if (dbNote != note) {
      throw Exception('Note with id ${note.id} does not exist');
    }
    // update the note
    final updatedCount = await _db!.update(
      notesTable,
      {
        textColumn: text,
        isSyncedWithCloudColumn: 0,
      },
      where: 'id = ?',
      whereArgs: [note.id],
    );
    if (updatedCount == 0) {
      throw Exception('Could not update note with id ${note.id}');
    } else {
      return await getNote(id: note.id);
    }
  }

  /// This method initializes a database upon first call.
  /// If the database is already initialized, it throws a [DatabaseAlreadyOpenException].
  Future<void> initialize() async {
    if (_db != null) {
      // database already opened
      throw exceptions.DatabaseAlreadyOpenException('Database already opened');
    }
    try {
      // step 1:
      // get the documents directory path from path_provider package
      final docsPath = await path_provider.getApplicationDocumentsDirectory();
      // step 2:
      // join the documents path with the database name to get the full database path
      final dbPath = p.join(docsPath.path, dbName);
      // step 3:
      // open the database at the given path and store the reference to _db
      _db = await sqflite.openDatabase(dbPath);

      // create user table
      await _db?.execute(createUserTable);
      // create notes table
      await _db?.execute(createNotesTable);

      // step 4:
    } on path_provider.MissingPlatformDirectoryException catch (_) {
      throw Exception('Unable to get documents directory');
    }
  }

  Future<void> close() async {
    final db = _db;
    if (db == null) {
      throw DatabaseNotOpenException('Database is not opened');
    } else {
      await db.close();
      _db = null;
    }
  }
}

/// A service class to handle SQLite database operations for notes.
/// This class provides methods to initialize the database, create tables,
/// and perform CRUD operations on notes.
@immutable
class DatabseUser {
  final int id;
  final String email;

  /// Constructor for creating a DatabseUser instance.
  const DatabseUser({required this.id, required this.email});

  /// get user row from user table
  DatabseUser.fromUserRow(Map<String, Object?> map)
    : id = map[idColumn] as int,
      email = map[emailColumn] as String;

  /// insert user object into user table
  Map<String, Object> toUserTable() {
    return {idColumn: id, emailColumn: email};
  }

  // override toString method
  @override
  String toString() => 'Person, ID = $id, email = $email';

  // get instance equality
  @override
  bool operator ==(covariant DatabseUser other) => id == other.id;

  // get instace hashcode
  @override
  int get hashCode => id.hashCode;
}

@immutable
class DatabaseNotes {
  final int id;
  final int userId;
  final String text;
  final bool isSyncedWithCloud;

  /// Constructor for creating a DatabaseNote instance.
  const DatabaseNotes({
    required this.id,
    required this.userId,
    required this.text,
    required this.isSyncedWithCloud,
  });

  /// get note row from notes table
  DatabaseNotes.fromRow(Map<String, Object?> map)
    : id = map[idColumn] as int,
      userId = map[idColumn] as int,
      text = map[textColumn] as String,
      isSyncedWithCloud = (map[isSyncedWithCloudColumn] as int) == 1
          ? true
          : false;

  /// insert note object into notes table
  Map<String, Object> toNotesTable() {
    return {
      idColumn: id,
      userIdColumn: userId,
      textColumn: text,
      isSyncedWithCloudColumn: isSyncedWithCloud ? 1 : 0,
    };
  }

  // override toString method
  @override
  String toString() =>
      'Note, ID = $id, userId = $userId, isSyncedWithCloud = $isSyncedWithCloud';

  // get instance equality
  @override
  bool operator ==(covariant DatabaseNotes other) => id == other.id;

  // get instace hashcode
  @override
  int get hashCode => id.hashCode;
}

// database name and table name
const dbName = 'notes.db';
const notesTable = 'notes';
const userTable = 'user';

// column names
const idColumn = 'id';
const emailColumn = 'email';
const userIdColumn = 'user_id';
const textColumn = 'text';
const isSyncedWithCloudColumn = 'is_synced_with_cloud';

/// custom sql queries and database operations
// create user table query
const createUserTable =
    '''
  CREATE TABLE IF NOT EXISTS $userTable (
    $idColumn INTEGER PRIMARY KEY AUTOINCREMENT,
    $emailColumn TEXT NOT NULL
  );
''';
// create notes table query
const createNotesTable =
    '''
  CREATE TABLE IF NOT EXISTS $notesTable (
    $idColumn INTEGER PRIMARY KEY AUTOINCREMENT,
    $userIdColumn INTEGER NOT NULL,
    $textColumn TEXT,
    $isSyncedWithCloudColumn INTEGER DEFAULT 0,
    FOREIGN KEY ($userIdColumn) REFERENCES $userTable($idColumn),
    PRIMARY KEY ("id" AUTOINCREMENT)
  );
''';
