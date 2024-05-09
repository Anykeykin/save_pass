// ignore_for_file: avoid_print

import 'package:save_pass/save_pass_api/models/pass_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseAppService {
  static late SupabaseClient supabase;

  static deletePass(int passwordId) async {
    dynamic test =
        await supabase.from('pass').delete().match({'password_id': passwordId});
    print(test);
    return true;
  }

  static editPass(PassModel passModel) async {
    dynamic test = await supabase
        .from('pass')
        .update(passModel.toMap())
        .match({'password_id': passModel.passwordId});
    print(test);
    return true;
  }

  static getAllPass() async {
    final data = await supabase.from('users').select();
    return [
      for (final passMap in data) PassModel.fromMap(passMap),
    ];
  }

  static savePass(PassModel passModel) async {
    dynamic test = await supabase.from('cities').insert(passModel.toMap());
    print(test);
    return true;
  }

  static logout() async {
    await supabase.auth.signOut();
  }

  static Future<User?> register(
    String email,
    String password,
  ) async {
    final authorization = await supabase.auth.signUp(
      email: email,
      password: password,
    );
    return authorization.user;
  }

  static Future<User?> login(
    String email,
    String password,
  ) async {
    final authorization = await supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
    return authorization.user;
  }
}
