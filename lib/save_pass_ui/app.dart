// ignore_for_file: use_build_context_synchronously

import 'package:domain/local_repository/local_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:save_pass/save_pass_bloc/authorization_bloc/authorization_bloc.dart';
import 'package:save_pass/save_pass_bloc/passwords_bloc/passwords_bloc.dart';
import 'package:save_pass/save_pass_bloc/security_level_bloc/security_level_bloc.dart';
import 'package:save_pass/save_pass_ui/loading/loading_screen.dart';
import 'package:save_pass/save_pass_ui/router/router.dart';
import 'package:save_pass/save_pass_ui/router/screen_paths.dart';

class MyApp extends StatelessWidget {
  final LocalRepository localRepository;

  const MyApp({
    super.key,
    required this.localRepository,
  });

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
                AuthorizationBloc(localRepository)..add(const Check()),
          ),
          BlocProvider(
            create: (context) => PasswordsBloc(
              localRepository: localRepository,
            ),
          ),
          BlocProvider(
            create: (context) => SecurityLevelBloc(
              localRepository: localRepository,
            ),
          ),
        ],
        child: BlocListener<AuthorizationBloc, AuthorizationState>(
          listener: (context, state) async {
            await Future.delayed(const Duration(seconds: 1), () {});

            if (state.openStatus == OpenStatus.denied) {
              Navigator.of(context).pushNamed(
                ScreenPaths.loginScreen,
                arguments: {
                  'auth_bloc': context.read<AuthorizationBloc>(),
                },
              );
            }
            if (state.openStatus == OpenStatus.create) {
              Navigator.of(context).pushNamed(
                ScreenPaths.registrationScreen,
                arguments: {
                  'auth_bloc': context.read<AuthorizationBloc>(),
                },
              );
            }
            if (state.openStatus == OpenStatus.access) {
              context.read<SecurityLevelBloc>().add(const GetSecurityLevel());
              await Future.delayed(const Duration(seconds: 1), () {});
              Navigator.of(context).pushNamed(
                ScreenPaths.passListScreen,
                arguments: {
                  'passwords_bloc': context.read<PasswordsBloc>(),
                  'security_level_bloc': context.read<SecurityLevelBloc>(),
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

mixin NavKey {
  static final navKey = GlobalKey<NavigatorState>();
}
