import 'package:save_pass/save_pass_api/local_api/datasource/sql_local_service.dart';
import 'package:save_pass/save_pass_api/local_api/repository/local_repository.dart';
import 'package:save_pass/save_pass_api/models/pass_model.dart';
import 'package:sqflite/sqflite.dart';

class LocalRepositoryImpl implements LocalRepository {
  @override
  Future<bool> deletePass(Future<Database> database, int passwordId) async {
    return await SqlLocalService.deletePass(database, passwordId);
  }

  @override
  Future<bool> editPass(Future<Database> database, PassModel passModel) async {
    return await SqlLocalService.editPass(database, passModel);
  }

  @override
  Future<List<PassModel>> getAllPass(Future<Database> database) async {
    return await SqlLocalService.getAllPass(database);
  }

  @override
  Future<bool> savePass(Future<Database> database, PassModel passModel)async {
    return await SqlLocalService.savePass(database,passModel);
  }

  @override
  openSqlDatabase() {
    return SqlLocalService.openSqlDatabase();
  }
}