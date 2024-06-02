import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:save_pass/save_pass_bloc/authorization_bloc/authorization_bloc.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthorizationBloc, AuthorizationState>(
      builder: (registrationContext, state) {
        if (state.registrationStatus == AuthorizationStatus.error) {
          Future.delayed(Duration.zero, () {
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Введены неверные данные')));
          });
        }
        if (state.registrationStatus == AuthorizationStatus.access) {
          // Future.delayed(Duration.zero, () {
          //   Navigator.of(context).pushNamed(
          //     ScreenPaths.navBarScreen,
          //     arguments: {},
          //   );
          // });
        }
        return Scaffold(
          backgroundColor: const Color.fromARGB(255, 33, 33, 32),
          body: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Text(
                              'Вход',
                              style: TextStyle(
                                  color: Colors.green,
                                  fontSize: 30,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                            controller: _emailController,
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
                                labelText: 'Email',
                                labelStyle: TextStyle(color: Colors.green))),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                            style: const TextStyle(color: Colors.white),
                            controller: _passwordController,
                            decoration: const InputDecoration(
                                fillColor: Colors.white,
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
                                labelText: 'Пароль',
                                labelStyle: TextStyle(color: Colors.green))),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        child: SizedBox(
                          width: 329,
                          height: 56,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green),
                            onPressed: () {
                              registrationContext.read<AuthorizationBloc>().add(
                                  Login(
                                      email: _emailController.text,
                                      password: _passwordController.text));
                            },
                            child: const Text(
                              "Войти",
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
                      const SizedBox(
                        height: 25,
                      ),
                      Row(
                        children: [
                          const Text(
                            'Нет аккаунта?',
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
                              // Navigator.of(context).pushNamed(
                              //   ScreenPaths.registrationScreen,
                              //   arguments: {},
                              // );
                            },
                            child: const Text(
                              'Зарегистрироваться',
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
            ],
          ),
        );
      },
    );
  }
}
