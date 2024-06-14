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
  Future<SecurityLevel> getSecurityLevel() async {
    return await SqlLocalService.getSecurityLevel();
  }

  @override
  Future<bool> saveSecurityLevel(SecurityLevel securityLevel) async {
    return await SqlLocalService.saveLevel(securityLevel);
  }

  @override
  Future<String> getFirstKey() async {
    return await SqlLocalService.getFirstKey();
  }

  @override
  Future<String> getSecondKey() async {
    return await SqlLocalService.getSecondKey();
  }
  
  @override
  Future<String> getLevelKey() async{
    return await SqlLocalService.getLevelKey();
  }
}
