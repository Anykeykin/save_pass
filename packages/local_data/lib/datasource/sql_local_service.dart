import 'dart:io';

import 'package:domain/models/app_user.dart';
import 'package:domain/models/pass_model.dart';
import 'package:domain/models/security_level.dart';
// ignore: depend_on_referenced_packages
import "package:path/path.dart";
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class SqlLocalService {
  late Database _sqlDatabase;
  late Database _keyDatabase;
  late Database _levelDatabase;

  SqlLocalService();

  Future<bool> saveLevel(String securityLevel) async {
    return await _levelDatabase.insert(
            'level', {'level_id': 0, 'level': securityLevel},
            conflictAlgorithm: ConflictAlgorithm.replace) !=
        0;
  }

  getLevel() async {
    final List<Map<String, Object?>> securityMaps =
        await _levelDatabase.query('level');
    String level = '';
    try {
      level = securityMaps[0]['level'] as String;
    } catch (e) {
      print(e);
    }
    return level;
  }

  getKeys() async {
    final List<Map<String, Object?>> keys = await _keyDatabase.query('keys');

    return [
      for (final key in keys) SecurityKey.fromMap(key),
    ];
  }

  Future<void> openKeySqlDatabase() async {
    final Directory libDir = Platform.isAndroid
        ? await getApplicationDocumentsDirectory()
        : await getLibraryDirectory();
    if (!File("${libDir.path}/keys.db").existsSync()) {
      File("${libDir.path}/keys.db").createSync(recursive: true);
    }

    _keyDatabase = await openDatabase(
      join(libDir.path, 'keys.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE keys(key_name TEXT PRIMARY KEY, key TEXT)',
        );
      },
      version: 2,
    );
  }

  Future<void> openLevelSqlDatabase() async {
    final Directory libDir = Platform.isAndroid
        ? await getApplicationDocumentsDirectory()
        : await getLibraryDirectory();
    if (!File("${libDir.path}/level.db").existsSync()) {
      File("${libDir.path}/level.db").createSync(recursive: true);
    }
    _levelDatabase = await openDatabase(
      join(libDir.path, 'level.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE level(level_id INTEGER PRIMARY KEY, level TEXT)',
        );
      },
      version: 2,
    );
  }

  Future<bool> saveKey(SecurityKey securitykey) async {
    return await _keyDatabase.insert('keys', securitykey.toMap(),
            conflictAlgorithm: ConflictAlgorithm.replace) !=
        0;
  }

  Future<bool> deletePass(int passwordId) async {
    return await _sqlDatabase.delete(
          'pass',
          where: 'password_id = ?',
          whereArgs: [passwordId],
        ) !=
        0;
  }

  Future<bool> editPass(PassModel passModel) async {
    return await _sqlDatabase.update(
          'pass',
          passModel.toMap(),
          where: 'password_id = ?',
          whereArgs: [passModel.passwordId],
        ) !=
        0;
  }

  Future<bool> savePass(PassModel passModel) async {
    return await _sqlDatabase.insert(
          'pass',
          passModel.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        ) !=
        0;
  }

  Future<List<PassModel>> getAllPass() async {
    final List<Map<String, Object?>> passMaps =
        await _sqlDatabase.query('pass');

    return [
      for (final passMap in passMaps) PassModel.fromMap(passMap),
    ];
  }

  Future<void> openSqlDatabase() async {
    final Directory libDir = Platform.isAndroid
        ? await getApplicationDocumentsDirectory()
        : await getLibraryDirectory();
    if (!File("${libDir.path}/pass.db").existsSync()) {
      File("${libDir.path}/pass.db").createSync(recursive: true);
    }
    _sqlDatabase = await openDatabase(
      join(libDir.path, 'pass.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE pass(password_id INTEGER PRIMARY KEY, password_name TEXT, password TEXT)',
        );
      },
      version: 1,
    );
  }

  static openAuthSqlDatabase() async {
    final Directory libDir = Platform.isAndroid
        ? await getApplicationDocumentsDirectory()
        : await getLibraryDirectory();
    final database = openDatabase(
      join(libDir.path, 'auth.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE auth(uid INTEGER PRIMARY KEY, email TEXT, password TEXT)',
        );
      },
      version: 1,
    );
    return database;
  }

  static Future<bool> saveAuthData(AppUser appUser) async {
    final db = await openAuthSqlDatabase();

    return await db.insert(
          'auth',
          appUser.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        ) !=
        0;
  }

  static Future<bool> removeAuthData(AppUser appUser) async {
    final db = await openAuthSqlDatabase();

    return await db.delete(
          'auth',
          where: 'id = ?',
          whereArgs: [appUser.uid],
        ) !=
        0;
  }
}
