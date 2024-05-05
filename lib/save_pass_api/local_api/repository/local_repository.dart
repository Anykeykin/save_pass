import 'package:save_pass/save_pass_api/models/pass_model.dart';

abstract class LocalRepository {
  bool savePass(PassModel passModel);
  PassModel readPass();
  List<PassModel> getAllPass();
  bool editPass();
  bool deletePass();
}
