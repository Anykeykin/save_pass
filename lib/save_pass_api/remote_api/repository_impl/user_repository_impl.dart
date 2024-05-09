import 'package:save_pass/save_pass_api/remote_api/repository/user_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserRepositoryImpl implements UserRepository {
  static late SupabaseClient supabase;

  @override
  Future<User?> login(
    String email,
    String password,
  ) async {
    final authorization = await supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
    return authorization.user;
  }

  @override
  Future<User?> register(
    String email,
    String password,
  ) async {
    final authorization = await supabase.auth.signUp(
      email: email,
      password: password,
    );
    return authorization.user;
  }

  @override
  Future<void> logout() async {
    await supabase.auth.signOut();
  }
}
