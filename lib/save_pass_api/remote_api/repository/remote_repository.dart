import 'package:domain/models/pass_model.dart';


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
