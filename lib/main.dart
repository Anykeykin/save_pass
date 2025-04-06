// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:domain/local_repository/local_repository.dart';
import 'package:local_data/repository_impl/local_repository_impl.dart';
import 'package:save_pass/save_pass_ui/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  LocalRepository localRepository = LocalRepositoryImpl();
  localRepository.initDatabase();
  runApp(MyApp(localRepository: localRepository));
}

