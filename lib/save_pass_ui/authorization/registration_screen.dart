import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:save_pass/save_pass_bloc/authorization_bloc/authorization_bloc.dart';

class RegistrationSaveScreen extends StatelessWidget {
  RegistrationSaveScreen({super.key});

  final TextEditingController _passwordController = TextEditingController();
  final Color _primaryColor = const Color(0xFF009688);
  final Color _darkBgColor = const Color(0xFF121212);

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? _darkBgColor : Colors.grey[50],
      body: BlocConsumer<AuthorizationBloc, AuthorizationState>(
        listener: (context, state) {
          
        },
        builder: (context, state) {
          return SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Header
                    Icon(
                      Icons.security_rounded,
                      size: 80,
                      color: _primaryColor,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Создание мастер-пароля',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: isDark ? Colors.white : _primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Придумайте надежный пароль для защиты ваших данных',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: isDark ? Colors.white70 : Colors.black54,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),

                    // Password Field
                    TextField(
                      maxLength: 16,
                      controller: _passwordController,
                      obscureText: true,
                      style: TextStyle(
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                        labelText: 'Мастер-пароль',
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
                    const SizedBox(height: 16),
                    Text(
                      'Используйте комбинацию букв, цифр и специальных символов',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: isDark ? Colors.white54 : Colors.grey,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),

                    // Create Button
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
                                  context.read<AuthorizationBloc>().add(
                                        Create(password: _passwordController.text),
                                      );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Введите пароль'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              },
                        child: const Text(
                                'Создать мастер-пароль',
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
              ),
            ),
          );
        },
      ),
    );
  }
}