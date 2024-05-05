import 'package:save_pass/save_pass_api/models/pass_model.dart';

class SqlLocalService {
  static bool deletePass() {
    return true;
  }

  static bool editPass() {
    return true;
  }

  static bool savePass(PassModel passModel) {
    return true;
  }

  static List<PassModel> getAllPass() {
    return [];
  }

  static PassModel readPass() {
    return PassModel(passwordName: 'passwordName', password: 'password');
  }
}
