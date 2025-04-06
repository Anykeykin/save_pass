import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:save_pass/save_pass_bloc/passwords_bloc/passwords_bloc.dart';

class EditPassScreen extends StatelessWidget {
  EditPassScreen({super.key});

  final TextEditingController _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PasswordsBloc, PasswordsState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: const Color.fromARGB(255, 33, 33, 32),
          body: SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Изменение пароля',
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
                                    labelStyle:
                                        TextStyle(color: Colors.green))),
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
                                  context.read<PasswordsBloc>().add(EditPass(
                                      password: _passwordController.text));
                                  Future.delayed(const Duration(seconds: 1),
                                      () {
                                    Navigator.of(context).pop();
                                  });
                                },
                                child: const Text(
                                  "Изменить пароль",
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
                        ]),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
