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

  static bool editPass() {
    return true;
  }

  static bool savePass(PassModel passModel) {
    return true;
  }

  static List<PassModel> getAllPass() {
    return [];
  }

  static PassModel readPass() {
    return PassModel(
        passwordName: 'passwordName', password: 'password', passwordId: 0);
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
