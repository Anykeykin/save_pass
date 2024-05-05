import 'package:save_pass/save_pass_api/models/pass_model.dart';
import 'package:sqflite/sqflite.dart';

abstract class LocalRepository {
  bool savePass(PassModel passModel);
  PassModel readPass();
  List<PassModel> getAllPass();
  bool editPass();
  Future<bool> deletePass(Future<Database> database, int passwordId);
  openSqlDatabase();
}
