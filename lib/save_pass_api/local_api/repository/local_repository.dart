import 'package:save_pass/save_pass_api/models/pass_model.dart';
import 'package:save_pass/save_pass_api/models/security_level.dart';

abstract class LocalRepository {
  Future<bool> savePass(PassModel passModel);
  Future<List<PassModel>> getAllPass();
  Future<bool> editPass(PassModel passModel);
  Future<bool> deletePass(int passwordId);
  Future<bool> saveSecurityLevel(SecurityLevel securityLevel);
  Future<SecurityLevel> getSecurityLevel();
}
