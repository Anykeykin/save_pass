import 'package:save_pass/save_pass_api/local_api/datasource/sql_local_service.dart';
import 'package:save_pass/save_pass_api/local_api/repository/local_user_repository.dart';
import 'package:save_pass/save_pass_api/models/app_user.dart';

class LocalUserRepositoryImpl implements LocalUserRepository {
  @override
  Future<AppUser?> loadAuthData() async {
    return await SqlLocalService.loadAuthData();
  }

  @override
  Future<bool> saveAuthData(AppUser appUser) async {
    return await SqlLocalService.saveAuthData(appUser);
  }

  @override
  Future<bool> removeAuthData(AppUser appUser) async {
    return await SqlLocalService.removeAuthData(appUser);
  }
}
