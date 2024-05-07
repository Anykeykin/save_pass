import 'package:save_pass/save_pass_api/models/app_user.dart';
import 'package:sqflite/sqflite.dart';

abstract class LocalUserRepository {
  saveAuthData(AppUser appUser, Database database);
  loadAuthData(Database database);
  removeAuthData(AppUser appUser, Database database);
}
