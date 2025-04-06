import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:save_pass/save_pass_bloc/authorization_bloc/authorization_bloc.dart';
import 'package:save_pass/save_pass_bloc/passwords_bloc/passwords_bloc.dart';
import 'package:save_pass/save_pass_ui/pass/create_pass_screen.dart';
import 'package:save_pass/save_pass_ui/pass/edit_pass_screen.dart';
import 'package:save_pass/save_pass_ui/authorization/login_screen.dart';
import 'package:save_pass/save_pass_ui/pass/pass_list_screen.dart';
import 'package:save_pass/save_pass_ui/authorization/registration_screen.dart';
import 'package:save_pass/save_pass_ui/router/screen_paths.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';

mixin SavePassRouter {
  static Route<dynamic> routes(RouteSettings routesettings) {
    if (routesettings.name == ScreenPaths.passListScreen) {
      return passListScreen(routesettings.arguments);
    }
    if (routesettings.name == ScreenPaths.createPassListScreen) {
      return createPassListScreen(routesettings.arguments);
    }
    if (routesettings.name == ScreenPaths.editPassListScreen) {
      return editPassListScreen(routesettings.arguments);
    }
    if (routesettings.name == ScreenPaths.registrationScreen) {
      return registrationScreen(routesettings.arguments);
    }
    if (routesettings.name == ScreenPaths.loginScreen) {
      return loginScreen(routesettings.arguments);
    }
    return registrationScreen(routesettings.arguments);
  }
}

SwipeablePageRoute<void> registrationScreen(
  Object? arguments,
) {
  return SwipeablePageRoute<void>(
    settings: const RouteSettings(name: ScreenPaths.registrationScreen),
    canOnlySwipeFromEdge: true,
    backGestureDetectionWidth: 1,
    builder: (_) {
      final Map<String, dynamic>? routeArguments =
          arguments as Map<String, dynamic>?;
      final AuthorizationBloc authBloc = routeArguments?['auth_bloc'];
      return BlocProvider.value(
        value: authBloc,
        child: RegistrationSaveScreen(),
      );
    },
  );
}

SwipeablePageRoute<void> loginScreen(
  Object? arguments,
) {
  return SwipeablePageRoute<void>(
    settings: const RouteSettings(name: ScreenPaths.loginScreen),
    canOnlySwipeFromEdge: true,
    backGestureDetectionWidth: 1,
    builder: (_) {
      final Map<String, dynamic>? routeArguments =
          arguments as Map<String, dynamic>?;
      final AuthorizationBloc authBloc = routeArguments?['auth_bloc'];
      return BlocProvider.value(
        value: authBloc,
        child: LoginScreen(),
      );
    },
  );
}

SwipeablePageRoute<void> passListScreen(
  Object? arguments,
) {
  return SwipeablePageRoute<void>(
    canSwipe: false,
    settings: const RouteSettings(name: ScreenPaths.passListScreen),
    // canOnlySwipeFromEdge: true,
    backGestureDetectionWidth: 1,
    builder: (BuildContext context) {
      final Map<String, dynamic>? routeArguments =
          arguments as Map<String, dynamic>?;
      final PasswordsBloc passwordsBloc = routeArguments?['passwords_bloc'];

      return MultiBlocProvider(
        providers: [
          BlocProvider.value(
            value: passwordsBloc..add(const GetSecurityLevel()),
          ),
        ],
        child: const PasswordListScreen(),
      );
    },
  );
}

SwipeablePageRoute<void> createPassListScreen(
  Object? arguments,
) {
  return SwipeablePageRoute<void>(
    settings: const RouteSettings(name: ScreenPaths.createPassListScreen),
    canOnlySwipeFromEdge: true,
    backGestureDetectionWidth: 1,
    builder: (BuildContext context) {
      final Map<String, dynamic>? routeArguments =
          arguments as Map<String, dynamic>?;
      final PasswordsBloc passwordsBloc = routeArguments?['passwords_bloc'];

      return MultiBlocProvider(
        providers: [
          BlocProvider.value(
            value: passwordsBloc,
          ),
        ],
        child: CreatePassScreen(),
      );
    },
  );
}

SwipeablePageRoute<void> editPassListScreen(
  Object? arguments,
) {
  return SwipeablePageRoute<void>(
    settings: const RouteSettings(name: ScreenPaths.editPassListScreen),
    canOnlySwipeFromEdge: true,
    backGestureDetectionWidth: 1,
    builder: (BuildContext context) {
      final Map<String, dynamic>? routeArguments =
          arguments as Map<String, dynamic>?;
      final PasswordsBloc passwordsBloc = routeArguments?['passwords_bloc'];

      return MultiBlocProvider(
        providers: [
          BlocProvider.value(
            value: passwordsBloc,
          ),
        ],
        child: EditPassScreen(),
      );
    },
  );
}
