import 'package:domain/models/pass_model.dart';
import 'package:domain/models/security_level.dart';
import 'package:local_data/datasource/sql_local_service.dart';
import 'package:domain/local_repository/local_repository.dart';

class LocalRepositoryImpl implements LocalRepository {
  final SqlLocalService _sqlLocalService;

  LocalRepositoryImpl(this._sqlLocalService);

  @override
  Future<bool> deletePass(int passwordId) async {
    return await _sqlLocalService.deletePass(passwordId);
  }

  @override
  Future<bool> editPass(PassModel passModel) async {
    return await _sqlLocalService.editPass(passModel);
  }

  @override
  Future<List<PassModel>> getAllPass() async {
    return await _sqlLocalService.getAllPass();
  }

  @override
  Future<bool> savePass(PassModel passModel) async {
    return await _sqlLocalService.savePass(passModel);
  }

  @override
  Future<bool> saveSecurityKey(SecurityKey securityKey) async {
    return await _sqlLocalService.saveKey(securityKey);
  }

  @override
  Future<List<SecurityKey>> getKeys() async {
    return await _sqlLocalService.getKeys();
  }

  @override
  Future<bool> saveLevel(String level) async {
    return await _sqlLocalService.saveLevel(level);
  }

  @override
  Future<String> getLevel() async {
    return await _sqlLocalService.getLevel();
  }

  @override
  Future<void> initDatabase() async {
    await Future.wait([
      _sqlLocalService.openKeySqlDatabase(),
      _sqlLocalService.openSqlDatabase(),
      _sqlLocalService.openLevelSqlDatabase(),
    ]);
  }
}
