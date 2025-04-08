import 'package:domain/models/pass_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:save_pass/save_pass_bloc/passwords_bloc/passwords_bloc.dart';
import 'package:save_pass/save_pass_ui/pass/password_cards.dart';

class PasswordsScreen extends StatelessWidget {
  const PasswordsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PasswordsBloc, PasswordsState>(
      builder: (context, state) {
        if (state.loadStatus == LoadStatus.loading) {
          return const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Расшифровываются пароли',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              CircularProgressIndicator(),
            ],
          );
        }

        final List<PassModel> passModel = state.passModel;
        return ListView.builder(
          padding: const EdgeInsets.all(10.0),
          itemCount: passModel.length,
          itemBuilder: (context, index) {
            return PasswordCard(
              site: passModel[index].passwordName,
              password: passModel[index].password,
              passwordId: passModel[index].passwordId,
            );
          },
        );
      },
    );
  }
}
