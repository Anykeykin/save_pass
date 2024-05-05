import 'package:flutter/material.dart';
import 'package:save_pass/save_pass_api/local_api/repository/local_repository_impl.dart';
import 'package:save_pass/save_pass_api/remote_api/datasource/initialize.dart';
import 'package:save_pass/save_pass_ui/first_screen.dart';
import 'package:sqflite/sqflite.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Database db = await LocalRepositoryImpl().openSqlDatabase();
  initialize();
  final supabase = Supabase.instance.client;
  runApp(const MyApp());
}
