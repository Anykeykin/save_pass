import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:save_pass/save_pass_ui/login_screen.dart';
import 'package:save_pass/save_pass_ui/pass_list_screen.dart';
import 'package:save_pass/save_pass_ui/registration_screen.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';

class ScreenPaths {
  static const String start = '/';
  static const String passListScreen = 'passListScreen';
  static const String registrationScreen = 'registrationScreen';
  static const String loginScreen = 'loginScreen';
}

mixin SavePassRouter {
  static Route<dynamic> routes(RouteSettings routesettings) {
    if (routesettings.name == ScreenPaths.passListScreen) {
      return passListScreen(routesettings.arguments);
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
      return RegistrationSaveScreen();
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
      return LoginScreen();
    },
  );
}

SwipeablePageRoute<void> passListScreen(
  Object? arguments,
) {
  return SwipeablePageRoute<void>(
    settings: const RouteSettings(name: ScreenPaths.passListScreen),
    canOnlySwipeFromEdge: true,
    backGestureDetectionWidth: 1,
    builder: (BuildContext context) {
      final Map<String, dynamic>? routeArguments =
          arguments as Map<String, dynamic>?;
      // final WarningBloc warningBloc = routeArguments?['warning_bloc'];
      // final GeolocationBloc geolocationBloc =
      //     routeArguments?['geolocation_bloc'];
      // final ProfileBloc profileBloc = routeArguments?['profile_bloc'];

      return MultiBlocProvider(
        providers: [
          // BlocProvider.value(
          //   value: warningBloc,
          // ),
          // BlocProvider.value(
          //   value: profileBloc..add(const GetUserInfo()),
          // ),
          // BlocProvider.value(
          //   value: geolocationBloc
          //     ..add(const GetCurrentGeolocation())
          //     ..add(const GetDangerPlaces()),
          // ),
        ],
        child: PasswordListScreen(),
      );
    },
  );
}
