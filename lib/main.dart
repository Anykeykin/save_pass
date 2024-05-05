import 'package:flutter/material.dart';
import 'package:save_pass/save_pass_api/remote_api/datasource/initialize.dart';
import 'package:save_pass/save_pass_ui/first_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initialize();
  runApp(const MyApp());
}
