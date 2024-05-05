import 'package:save_pass/save_pass_api/models/pass_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class RemoteRepository {
  Future<bool> savePass(
    SupabaseClient supabase,
    PassModel passModel,
  );

  Future<List<PassModel>> getAllPass(
    SupabaseClient supabase,
  );

  Future<bool> editPass(
    SupabaseClient supabase,
    PassModel passModel,
  );

  Future<bool> deletePass(
    SupabaseClient supabase,
    int passwordId,
  );
}
