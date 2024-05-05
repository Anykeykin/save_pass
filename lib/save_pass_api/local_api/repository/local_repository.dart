import 'package:save_pass/save_pass_api/models/pass_model.dart';
import 'package:sqflite/sqflite.dart';

abstract class LocalRepository {
  Future<bool> savePass(Future<Database> database, PassModel passModel);
  Future<List<PassModel>> getAllPass(Future<Database> database);
  Future<bool> editPass(Future<Database> database, PassModel passModel);
  Future<bool> deletePass(Future<Database> database, int passwordId);
  openSqlDatabase();
}
