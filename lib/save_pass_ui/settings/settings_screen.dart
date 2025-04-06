import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:save_pass/save_pass_bloc/passwords_bloc/passwords_bloc.dart';

class ProtectionSettingsScreen extends StatelessWidget {
  const ProtectionSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: BlocBuilder<PasswordsBloc, PasswordsState>(
        builder: (context, state) {
          return ListView(
            children: <Widget>[
              const Text(
                'Выберите уровень защиты:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              ListTile(
                title: const Text('Базовый'),
                subtitle: const Text(
                  'Минимальная защита. Включает основные меры предосторожности в виде пароля при входе.',
                  style: TextStyle(fontSize: 12),
                ),
                leading: Radio<String>(
                  value: 'base',
                  groupValue: state.securityLevel,
                  onChanged: (String? level) {
                    if (level != null) {
                      context
                          .read<PasswordsBloc>()
                          .add(UpdateSecurityLevel(securityLevel: level));
                    }
                  },
                ),
              ),
              ListTile(
                title: const Text('Средний'),
                subtitle: const Text(
                  'Рекомендуемый уровень защиты. Включает все функции базового уровня и шифрование.',
                  style: TextStyle(fontSize: 12),
                ),
                leading: Radio<String>(
                  value: 'medium',
                  groupValue: state.securityLevel,
                  onChanged: (String? level) {
                    if (level != null) {
                      context
                          .read<PasswordsBloc>()
                          .add(UpdateSecurityLevel(securityLevel: level));
                    }
                  },
                ),
              ),
              ListTile(
                title: const Text('Высокий'),
                subtitle: const Text(
                  'Максимальная защита. Включает все функции среднего уровня, а также двойное шифрование данных .',
                  style: TextStyle(fontSize: 12),
                ),
                leading: Radio<String>(
                  value: 'hard',
                  groupValue: state.securityLevel,
                  onChanged: (String? level) {
                    if (level != null) {
                      context
                          .read<PasswordsBloc>()
                          .add(UpdateSecurityLevel(securityLevel: level));
                    }
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}