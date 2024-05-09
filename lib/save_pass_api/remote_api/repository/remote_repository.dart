import 'package:save_pass/save_pass_api/models/pass_model.dart';

abstract class RemoteRepository {
  Future<bool> savePass(
    PassModel passModel,
  );

  Future<List<PassModel>> getAllPass();

  Future<bool> editPass(
    PassModel passModel,
  );

  Future<bool> deletePass(
    int passwordId,
  );
}
