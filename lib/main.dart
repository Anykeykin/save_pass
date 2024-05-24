// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:save_pass/save_pass_api/local_api/repository/local_repository.dart';
import 'package:save_pass/save_pass_api/local_api/repository/local_user_repository.dart';
import 'package:save_pass/save_pass_api/local_api/repository_impl/local_repository_impl.dart';
import 'package:save_pass/save_pass_api/local_api/repository_impl/local_user_repository_impl.dart';
import 'package:save_pass/save_pass_api/remote_api/datasource/initialize.dart';
import 'package:save_pass/save_pass_api/remote_api/datasource/supabase_services.dart';
import 'package:save_pass/save_pass_api/remote_api/repository/remote_repository.dart';
import 'package:save_pass/save_pass_api/remote_api/repository/user_repository.dart';
import 'package:save_pass/save_pass_api/remote_api/repository_impl/remote_repository_impl.dart';
import 'package:save_pass/save_pass_api/remote_api/repository_impl/user_repository_impl.dart';
import 'package:save_pass/save_pass_ui/first_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initialize();
  SupabaseAppService.supabase = Supabase.instance.client;
  UserRepository userRepository = UserRepositoryImpl();
  LocalUserRepository localUserRepository = LocalUserRepositoryImpl();
  LocalRepository localRepository = LocalRepositoryImpl();
  RemoteRepository remoteRepository = RemoteRepositoryImpl();
  runApp(const MyApp());
}
