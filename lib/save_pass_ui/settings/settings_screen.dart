import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:save_pass/save_pass_bloc/passwords_bloc/passwords_bloc.dart';

class ProtectionSettingsScreen extends StatelessWidget {
  const ProtectionSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: BlocBuilder<PasswordsBloc, PasswordsState>(
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
                        gradientColors: [
                          Colors.blue.shade100,
                          Colors.blue.shade200,
                        ],
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
                        gradientColors: [
                          Colors.purple.shade100,
                          Colors.purple.shade200,
                        ],
                        description: 'Рекомендуемый уровень с шифрованием',
                        benefits: const [
                          'Все базовые функции',
                          'Шифрование',
                        ],
                        onChanged: _handleLevelChange(context),
                      ),
                      const SizedBox(height: 16),
                      _SecurityOptionCard(
                        level: 'hard',
                        currentLevel: state.securityLevel,
                        title: 'Максимальный',
                        icon: Icons.security,
                        gradientColors: [
                          Colors.red.shade100,
                          Colors.red.shade200,
                        ],
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
    return (level) {
      if (level != null) {
        context.read<PasswordsBloc>().add(
              UpdateSecurityLevel(securityLevel: level),
            );

        // Анимация выбора
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Безопасность паролей',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8),
        Text(
          'Выберите подходящий уровень защиты для ваших данных',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
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
  final List<Color> gradientColors;
  final String description;
  final List<String> benefits;
  final ValueChanged<String?> onChanged;

  const _SecurityOptionCard({
    required this.level,
    required this.currentLevel,
    required this.title,
    required this.icon,
    required this.gradientColors,
    required this.description,
    required this.benefits,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = level == currentLevel;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          if (isSelected)
            BoxShadow(
              color: gradientColors.last.withOpacity(0.4),
              blurRadius: 10,
              spreadRadius: 2,
              offset: const Offset(0, 4),
            ),
        ],
        border: isSelected
            ? Border.all(
                color: Theme.of(context).colorScheme.primary,
                width: 2,
              )
            : null,
      ),
      child: Material(
        color: Colors.transparent,
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
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(icon, color: Colors.white),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const Spacer(),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      child: isSelected
                          ? const Icon(Icons.check_circle, color: Colors.white)
                          : const Icon(Icons.circle_outlined,
                              color: Colors.white70),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withOpacity(0.9),
                      ),
                ),
                const SizedBox(height: 16),
                ...benefits.map((benefit) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          Icon(Icons.check_circle_outline,
                              size: 16, color: Colors.white),
                          const SizedBox(width: 8),
                          Text(
                            benefit,
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: Colors.white.withOpacity(0.9),
                                    ),
                          ),
                        ],
                      ),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
