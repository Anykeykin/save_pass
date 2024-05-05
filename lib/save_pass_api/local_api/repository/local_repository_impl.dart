import 'package:save_pass/save_pass_api/local_api/datasource/sql_local_service.dart';
import 'package:save_pass/save_pass_api/local_api/repository/local_repository.dart';
import 'package:save_pass/save_pass_api/models/pass_model.dart';
import 'package:sqflite/sqflite.dart';

class LocalRepositoryImpl implements LocalRepository {
  @override
  Future<bool> deletePass(Future<Database> database, int passwordId) async {
    return await SqlLocalService.deletePass(database,passwordId);
  }

  @override
  Future<bool> editPass(Future<Database> database, PassModel passModel) async {
    return await SqlLocalService.editPass(database, passModel);
  }

  @override
  List<PassModel> getAllPass() {
    return SqlLocalService.getAllPass();
  }

  @override
  PassModel readPass() {
    return SqlLocalService.readPass();
  }

  @override
  bool savePass(PassModel passModel) {
    return SqlLocalService.savePass(passModel);
  }

  @override
  openSqlDatabase() {
    return SqlLocalService.openSqlDatabase();
  }
}
