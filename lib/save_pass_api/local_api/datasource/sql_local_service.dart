import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:save_pass/save_pass_api/models/app_user.dart';
import 'package:save_pass/save_pass_api/models/pass_model.dart';
import 'package:sqflite/sqflite.dart';
// ignore: depend_on_referenced_packages
import "package:path/path.dart";

class SqlLocalService {
  static Future<bool> deletePass(int passwordId) async {
    final db = await openSqlDatabase();

    return await db.delete(
          'pass',
          where: 'password_id = ?',
          whereArgs: [passwordId],
        ) !=
        0;
  }

  static Future<bool> editPass(PassModel passModel) async {
    final db = await openSqlDatabase();

    return await db.update(
          'pass',
          passModel.toMap(),
          where: 'password_id = ?',
          whereArgs: [passModel.passwordId],
        ) !=
        0;
  }

  static Future<bool> savePass(PassModel passModel) async {
    final db = await openSqlDatabase();

    return await db.insert(
          'pass',
          passModel.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        ) !=
        0;
  }

  static Future<List<PassModel>> getAllPass() async {
    final db = await openSqlDatabase();

    final List<Map<String, Object?>> passMaps = await db.query('pass');

    return [
      for (final passMap in passMaps) PassModel.fromMap(passMap),
    ];
  }

  static openSqlDatabase() async {
    final Directory libDir = await getLibraryDirectory();
    final database = openDatabase(
      join(libDir.path, 'pass.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE pass(password_id INTEGER PRIMARY KEY, password_name TEXT, password TEXT)',
        );
      },
      version: 1,
    );
    return database;
  }

  static openAuthSqlDatabase() async {
    final Directory libDir = await getLibraryDirectory();
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

  static Future<AppUser?> loadAuthData() async {
    final db = await openAuthSqlDatabase();
    try {
      final List<Map<String, Object?>> authMaps = await db.query('auth');
      // TODO: Прочекать и исправить это недоразумение
      return AppUser.fromMap(authMaps.first);
    } catch (e) {
      return null;
    }
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
