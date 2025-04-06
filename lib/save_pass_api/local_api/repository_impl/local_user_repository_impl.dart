import 'package:domain/models/app_user.dart';
import 'package:save_pass/save_pass_api/local_api/datasource/sql_local_service.dart';
import 'package:domain/local_repository/local_user_repository.dart';

class LocalUserRepositoryImpl implements LocalUserRepository {
  @override
  Future<bool> saveAuthData(AppUser appUser) async {
    return await SqlLocalService.saveAuthData(appUser);
  }

  @override
  Future<bool> removeAuthData(AppUser appUser) async {
    return await SqlLocalService.removeAuthData(appUser);
  }
}
