import 'package:save_pass/save_pass_api/remote_api/datasource/supabase_services.dart';
import 'package:domain/remote_repository/user_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserRepositoryImpl implements UserRepository {
  @override
  Future<User?> login(
    String email,
    String password,
  ) async {
    return await SupabaseAppService.login(email, password);
  }

  @override
  Future<User?> register(
    String email,
    String password,
  ) async {
    return await SupabaseAppService.register(email, password);
  }

  @override
  Future<void> logout() async {
    await SupabaseAppService.logout();
  }
}
