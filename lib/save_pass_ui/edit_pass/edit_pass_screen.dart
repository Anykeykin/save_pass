import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:save_pass/save_pass_bloc/passwords_bloc/passwords_bloc.dart';

class EditPassScreen extends StatelessWidget {
  EditPassScreen({super.key});

  final TextEditingController _passwordController = TextEditingController();
  final Color _primaryColor = const Color(0xFF009688);
  final Color _darkBgColor = const Color(0xFF121212);

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Изменение пароля'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: isDark ? Colors.white : _primaryColor,
      ),
      backgroundColor: isDark ? _darkBgColor : Colors.grey[50],
      body: BlocBuilder<PasswordsBloc, PasswordsState>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Заголовок
                Text(
                  'Введите новый пароль',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: isDark ? Colors.white : _primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 32),
                
                // Поле ввода пароля
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  style: TextStyle(
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                    labelText: 'Пароль',
                    labelStyle: TextStyle(color: _primaryColor),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: _primaryColor,
                        width: 2,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                
                // Кнопка сохранения
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 4,
                    ),
                    onPressed: () {
                      if (_passwordController.text.isNotEmpty) {
                        context.read<PasswordsBloc>().add(
                              EditPass(password: _passwordController.text),
                            );
                        Navigator.of(context).pop();
                        
                        // Показать уведомление
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text('Пароль успешно изменён'),
                            backgroundColor: _primaryColor,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        );
                      }
                    },
                    child: const Text(
                      'Сохранить изменения',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}