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
import 'package:save_pass/save_pass_bloc/passwords_bloc/passwords_bloc.dart';
import 'package:save_pass/save_pass_ui/router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initialize();
  SupabaseAppService.supabase = Supabase.instance.client;
  UserRepository userRepository = UserRepositoryImpl();
  LocalUserRepository localUserRepository = LocalUserRepositoryImpl();
  LocalRepository localRepository = LocalRepositoryImpl();
  RemoteRepository remoteRepository = RemoteRepositoryImpl();
  runApp(
    MyApp(
      userRepository: userRepository,
      localUserRepository: localUserRepository,
      localRepository: localRepository,
      remoteRepository: remoteRepository,
    ),
  );
}

class MyApp extends StatelessWidget {
  final UserRepository userRepository;
  final LocalUserRepository localUserRepository;
  final LocalRepository localRepository;
  final RemoteRepository remoteRepository;

  const MyApp(
      {super.key,
      required this.userRepository,
      required this.localUserRepository,
      required this.localRepository,
      required this.remoteRepository});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.dark,
      initialRoute: ScreenPaths.start,
      onGenerateRoute: SavePassRouter.routes,
      navigatorKey: NavKey.navKey,
      title: 'SavePass',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFF2C2C2C),
        brightness: Brightness.dark,
        primaryColor: Colors.teal,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: const TextTheme(
          headlineLarge: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
          bodyLarge: TextStyle(fontSize: 14.0, fontWeight: FontWeight.normal),
        ),
      ),
      home: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
                AuthorizationBloc(userRepository, localUserRepository)
                  ..add(AutoLogin()),
          ),
          BlocProvider(
            create: (context) =>
                PasswordsBloc(remoteRepository, localRepository),
          ),
        ],
        child: BlocListener<AuthorizationBloc, AuthorizationState>(
          listener: (context, state) {
            if (state.registrationStatus == AuthorizationStatus.denied) {
              Navigator.of(context).pushNamed(
                ScreenPaths.passListScreen,
                arguments: {
                  'passwords_bloc': context.read<PasswordsBloc>(),
                },
              );
              // Navigator.of(context).pushNamed(
              //   ScreenPaths.loginScreen,
              //   arguments: {
              //     'auth_bloc': context.read<AuthorizationBloc>(),
              //   },
              // );
            }
            if (state.registrationStatus == AuthorizationStatus.access) {
              Navigator.of(context).pushNamed(
                ScreenPaths.passListScreen,
                arguments: {
                  'passwords_bloc': context.read<PasswordsBloc>(),
                },
              );
            }
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

mixin NavKey {
  static final navKey = GlobalKey<NavigatorState>();
}
