import 'package:save_pass/save_pass_api/local_api/datasource/sql_local_service.dart';
import 'package:save_pass/save_pass_api/local_api/repository/local_repository.dart';
import 'package:save_pass/save_pass_api/models/pass_model.dart';
import 'package:save_pass/save_pass_api/models/security_level.dart';

class LocalRepositoryImpl implements LocalRepository {
  @override
  Future<bool> deletePass(int passwordId) async {
    return await SqlLocalService.deletePass(passwordId);
  }

  @override
  Future<bool> editPass(PassModel passModel) async {
    return await SqlLocalService.editPass(passModel);
  }

  @override
  Future<List<PassModel>> getAllPass() async {
    return await SqlLocalService.getAllPass();
  }

  @override
  Future<bool> savePass(PassModel passModel) async {
    return await SqlLocalService.savePass(passModel);
  }

  @override
  Future<bool> saveSecurityKey(SecurityKey securityKey) async {
    return await SqlLocalService.saveKey(securityKey);
  }

  @override
  Future<List<SecurityKey>> getKeys() async {
    return await SqlLocalService.getKeys();
  }

  @override
  Future<bool> saveLevel(String level) async {
    return await SqlLocalService.saveLevel(level);
  }

  @override
  Future<String> getLevel() async {
    return await SqlLocalService.getLevel();
  }

  @override
  Future<void> initDatabase() async {
    try {
      SqlLocalService.openKeySqlDatabase();
    } catch (e) {}
    try {
      SqlLocalService.openSqlDatabase();
    } catch (e) {}
    try {
      SqlLocalService.openLevelSqlDatabase();
    } catch (e) {}
  }
}
