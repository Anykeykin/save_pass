import 'package:domain/models/pass_model.dart';
import 'package:domain/remote_repository/remote_repository.dart';
import 'package:save_pass/save_pass_api/remote_api/datasource/supabase_services.dart';

class RemoteRepositoryImpl implements RemoteRepository {
  @override
  Future<bool> deletePass(int passwordId) async {
    return await SupabaseAppService.deletePass(passwordId);
  }

  @override
  Future<bool> editPass(PassModel passModel) async {
    return await SupabaseAppService.editPass(passModel);
  }

  @override
  Future<List<PassModel>> getAllPass() async {
    return await SupabaseAppService.getAllPass();
  }

  @override
  Future<bool> savePass(PassModel passModel) async {
    return await SupabaseAppService.savePass(passModel);
  }
}
