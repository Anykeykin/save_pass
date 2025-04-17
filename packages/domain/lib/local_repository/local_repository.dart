

import 'package:domain/models/pass_model.dart';
import 'package:domain/models/security_level.dart';

abstract class LocalRepository {
  static late String levelKey;
  static late String firstKey;
  static late String secondKey;

  static late String securityLevel;


  Future<bool> savePass(PassModel passModel);
  Future<List<PassModel>> getAllPass();
  Future<bool> editPass(PassModel passModel);
  Future<bool> deletePass(int passwordId);
  Future<bool> saveSecurityKey(SecurityKey securityKey);
  Future<List<SecurityKey>> getKeys();
  Future<bool> saveLevel(String level);
  Future<String?> getLevel();
  Future<void> initDatabase();
}
