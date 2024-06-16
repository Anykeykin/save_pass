import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:save_pass/save_pass_bloc/authorization_bloc/authorization_bloc.dart';
import 'package:save_pass/save_pass_ui/router.dart';

class RegistrationSaveScreen extends StatelessWidget {
  RegistrationSaveScreen({super.key});

  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthorizationBloc, AuthorizationState>(
      builder: (registrationContext, state) {
        if (state.openStatus == OpenStatus.access) {
          Future.delayed(Duration.zero, () {
            Navigator.of(context).pushNamed(
              ScreenPaths.loginScreen,
              arguments: {
                'auth_bloc': context.read<AuthorizationBloc>(),
              },
            );
          });
        }
        return Scaffold(
          backgroundColor: const Color.fromARGB(255, 33, 33, 32),
          body: SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: SingleChildScrollView(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Text(
                                'Создать пароль входа',
                                style: TextStyle(
                                    color: Colors.green,
                                    fontSize: 30,
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(top: 10.0, bottom: 5),
                          child: Row(
                            children: [
                              Text(
                                'Пароль',
                                style: TextStyle(
                                    color: Colors.green,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
                            child: TextField(
                                controller: _passwordController,
                                style: const TextStyle(color: Colors.white),
                                decoration: const InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    borderSide: BorderSide(
                                      width: 1,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    borderSide: BorderSide(
                                      width: 1,
                                      color: Colors.green,
                                    ),
                                  ),
                                )),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ClipRRect(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                            child: SizedBox(
                              width: 329,
                              height: 56,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green),
                                onPressed: () {
                                  registrationContext
                                      .read<AuthorizationBloc>()
                                      .add(Create(
                                        password: _passwordController.text,
                                      ));
                                },
                                child: const Text(
                                  "Зарегистрироваться",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        Row(
                          children: [
                            const Text(
                              'Уже есть аккаунт?',
                              style: TextStyle(
                                color: Color(0xFF837E93),
                                fontSize: 13,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(
                              width: 2.5,
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.of(context).pushNamed(
                                  ScreenPaths.loginScreen,
                                  arguments: {
                                    'auth_bloc':
                                        context.read<AuthorizationBloc>(),
                                  },
                                );
                              },
                              child: const Text(
                                'Войти',
                                style: TextStyle(
                                  color: Colors.green,
                                  fontSize: 13,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ]),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
