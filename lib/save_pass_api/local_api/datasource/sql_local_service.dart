import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:save_pass/save_pass_api/models/pass_model.dart';
import 'package:sqflite/sqflite.dart';
// ignore: depend_on_referenced_packages
import "package:path/path.dart";

class SqlLocalService {
  static Future<bool> deletePass(
      Future<Database> database, int passwordId) async {
    final db = await database;

    return await db.delete(
          'pass',
          where: 'id = ?',
          whereArgs: [passwordId],
        ) !=
        0;
  }

  static Future<bool> editPass(
      Future<Database> database, PassModel passModel) async {
    final db = await database;

    return await db.update(
          'pass',
          passModel.toMap(),
          where: 'id = ?',
          whereArgs: [passModel.passwordId],
        ) !=
        0;
  }

  static Future<bool> savePass(
      Future<Database> database, PassModel passModel) async {
    final db = await database;

    return await db.insert(
          'pass',
          passModel.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        ) !=
        0;
  }

  static Future<List<PassModel>> getAllPass(Future<Database> database) async {
    final db = await database;

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
}
