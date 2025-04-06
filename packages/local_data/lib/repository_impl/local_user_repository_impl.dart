import 'package:domain/models/app_user.dart';
import 'package:domain/local_repository/local_user_repository.dart';
import 'package:local_data/datasource/sql_local_service.dart';

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
