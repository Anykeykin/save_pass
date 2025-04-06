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


class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color.fromARGB(255, 33, 33, 32),
      body: Center(
        child: Text(
          'Save Pass',
          style: TextStyle(
              color: Colors.green, fontSize: 40, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

