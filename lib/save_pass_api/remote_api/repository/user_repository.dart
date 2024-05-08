import 'package:supabase_flutter/supabase_flutter.dart';

abstract class UserRepository {
  Future<User?> login(
    SupabaseClient supabase,
    String email,
    String password,
  );
  Future<User?> register(
    SupabaseClient supabase,
    String email,
    String password,
  );
  Future<void> logout(
    SupabaseClient supabase,
  );
}
