import 'package:save_pass/save_pass_api/local_api/datasource/sql_local_service.dart';
import 'package:save_pass/save_pass_api/local_api/repository/local_user_repository.dart';
import 'package:save_pass/save_pass_api/models/app_user.dart';
import 'package:sqflite/sqflite.dart';

class LocalUserRepositoryImpl implements LocalUserRepository {
  @override
  Future<AppUser> loadAuthData(Database database) async {
    return await SqlLocalService.loadAuthData(database);
  }

  @override
  Future<bool> saveAuthData(AppUser appUser, Database database) async {
    return await SqlLocalService.saveAuthData(appUser, database);
  }

  @override
  removeAuthData(AppUser appUser, Database database) async {
    return await SqlLocalService.removeAuthData(appUser, database);
  }
}
