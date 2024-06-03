// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
import 'package:save_pass/save_pass_bloc/authorization_bloc/authorization_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initialize();
  SupabaseAppService.supabase = Supabase.instance.client;
  UserRepository userRepository = UserRepositoryImpl();
  LocalUserRepository localUserRepository = LocalUserRepositoryImpl();
  LocalRepository localRepository = LocalRepositoryImpl();
  RemoteRepository remoteRepository = RemoteRepositoryImpl();
  runApp(MyApp(
    userRepository: userRepository,
    localUserRepository: localUserRepository,
  ));
}

class MyApp extends StatelessWidget {
  final UserRepository userRepository;
  final LocalUserRepository localUserRepository;
  const MyApp(
      {super.key,
      required this.userRepository,
      required this.localUserRepository});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SavePass',
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xFF2C2C2C),
        brightness: Brightness.dark,
        primaryColor: Colors.teal,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: const TextTheme(
          headlineLarge: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
          bodyLarge: TextStyle(fontSize: 14.0, fontWeight: FontWeight.normal),
        ),
      ),
      home: BlocProvider(
        create: (context) =>
            AuthorizationBloc(userRepository, localUserRepository)
              ..add(AutoLogin()),
        child: BlocListener<AuthorizationBloc, AuthorizationState>(
          listener: (context, state) {
            if (state.registrationStatus == AuthorizationStatus.denied) {}
            if (state.registrationStatus == AuthorizationStatus.access) {}
          },
          child: const LoadingScreen(),
        ),
      ),
    );
  }
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
