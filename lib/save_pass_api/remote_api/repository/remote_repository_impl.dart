import 'package:save_pass/save_pass_api/models/pass_model.dart';
import 'package:save_pass/save_pass_api/remote_api/datasource/supabase_services.dart';
import 'package:save_pass/save_pass_api/remote_api/repository/remote_repository.dart';
import 'package:supabase/src/supabase_client.dart';

class RemoteRepositoryImpl implements RemoteRepository {
  @override
  Future<bool> deletePass(SupabaseClient supabase, int passwordId) async {
    return await SupabaseAppService.deletePass(supabase, passwordId);
  }

  @override
  Future<bool> editPass(SupabaseClient supabase, PassModel passModel) async {
    return await SupabaseAppService.editPass(supabase, passModel);
  }

  @override
  Future<List<PassModel>> getAllPass(SupabaseClient supabase) async {
    return await SupabaseAppService.getAllPass(supabase);
  }

  @override
  Future<bool> savePass(SupabaseClient supabase, PassModel passModel) async {
    return await SupabaseAppService.savePass(supabase,passModel);
  }
}
