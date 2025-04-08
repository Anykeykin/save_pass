import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:save_pass/save_pass_bloc/security_level_bloc/security_level_bloc.dart';

class ProtectionSettingsScreen extends StatelessWidget {
  const ProtectionSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF009688);
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: BlocBuilder<SecurityLevelBloc, SecurityLevelState>(
          builder: (context, state) {
            return Column(
              children: [
                const _HeaderSection(),
                const SizedBox(height: 24),
                Expanded(
                  child: ListView(
                    physics: const BouncingScrollPhysics(),
                    children: [
                      _SecurityOptionCard(
                        level: 'base',
                        currentLevel: state.securityLevel,
                        title: 'Базовый',
                        icon: Icons.lock_outline,
                        primaryColor: primaryColor,
                        isDark: isDark,
                        description: 'Минимальная защита с паролем при входе',
                        benefits: const [
                          'Защита паролем',
                        ],
                        onChanged: _handleLevelChange(context),
                      ),
                      const SizedBox(height: 16),
                      _SecurityOptionCard(
                        level: 'medium',
                        currentLevel: state.securityLevel,
                        title: 'Средний',
                        icon: Icons.lock,
                        primaryColor: primaryColor,
                        isDark: isDark,
                        description: 'Рекомендуемый уровень с шифрованием',
                        benefits: const [
                          'Все базовые функции',
                          'Шифрование паролей',
                        ],
                        onChanged: _handleLevelChange(context),
                      ),
                      const SizedBox(height: 16),
                      _SecurityOptionCard(
                        level: 'hard',
                        currentLevel: state.securityLevel,
                        title: 'Максимальный',
                        icon: Icons.security,
                        primaryColor: primaryColor,
                        isDark: isDark,
                        description: 'Полная защита всех данных',
                        benefits: const [
                          'Все средние функции',
                          'Двойное шифрование',
                        ],
                        onChanged: _handleLevelChange(context),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  ValueChanged<String?> _handleLevelChange(BuildContext context) {
    final primaryColor = const Color(0xFF009688);

    return (level) {
      if (level != null) {
        context.read<SecurityLevelBloc>().add(
              SaveSecurityLevel(securityLevel: level),
            );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            backgroundColor: primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            content: Text('Уровень защиты изменён на ${_levelName(level)}'),
            duration: const Duration(seconds: 1),
          ),
        );
      }
    };
  }

  String _levelName(String level) {
    return {
          'base': 'Базовый',
          'medium': 'Средний',
          'hard': 'Максимальный',
        }[level] ??
        '';
  }
}

class _HeaderSection extends StatelessWidget {
  const _HeaderSection();

  @override
  Widget build(BuildContext context) {
    final primaryColor = const Color(0xFF009688);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Безопасность паролей',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : primaryColor,
              ),
        ),
        const SizedBox(height: 8),
        Text(
          'Выберите подходящий уровень защиты для ваших данных',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: isDark ? Colors.white70 : Colors.black.withOpacity(0.7),
              ),
        ),
      ],
    );
  }
}

class _SecurityOptionCard extends StatelessWidget {
  final String level;
  final String currentLevel;
  final String title;
  final IconData icon;
  final Color primaryColor;
  final bool isDark;
  final String description;
  final List<String> benefits;
  final ValueChanged<String?> onChanged;

  const _SecurityOptionCard({
    required this.level,
    required this.currentLevel,
    required this.title,
    required this.icon,
    required this.primaryColor,
    required this.isDark,
    required this.description,
    required this.benefits,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = level == currentLevel;
    final bgColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;

    return Card(
      elevation: isSelected ? 4 : 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isSelected ? primaryColor : Colors.transparent,
          width: 2,
        ),
      ),
      color: bgColor,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => onChanged(level),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: primaryColor.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, color: primaryColor),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: isDark ? Colors.white : Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const Spacer(),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: isSelected
                        ? Icon(Icons.check_circle, color: primaryColor)
                        : Icon(Icons.circle_outlined,
                            color: isDark ? Colors.white54 : Colors.grey),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                description,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: isDark ? Colors.white70 : Colors.black87,
                    ),
              ),
              const SizedBox(height: 16),
              ...benefits.map((benefit) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Icon(Icons.check_circle_outline,
                            size: 16, color: primaryColor),
                        const SizedBox(width: 8),
                        Text(
                          benefit,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(
                                color: isDark ? Colors.white70 : Colors.black87,
                              ),
                        ),
                      ],
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
