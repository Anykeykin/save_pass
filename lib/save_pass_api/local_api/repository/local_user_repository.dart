import 'package:save_pass/save_pass_api/models/app_user.dart';

abstract class LocalUserRepository {
  Future<bool> saveAuthData(AppUser appUser);
  Future<bool> removeAuthData(AppUser appUser);
}
