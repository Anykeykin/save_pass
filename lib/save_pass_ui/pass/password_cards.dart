import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:save_pass/save_pass_bloc/passwords_bloc/passwords_bloc.dart';
import 'package:save_pass/save_pass_ui/router/screen_paths.dart';

class PasswordCard extends StatefulWidget {
  final String site;
  final String password;
  final int passwordId;

  const PasswordCard({
    super.key,
    required this.site,
    required this.password,
    required this.passwordId,
  });

  @override
  State<PasswordCard> createState() => _PasswordCardState();
}

class _PasswordCardState extends State<PasswordCard> with SingleTickerProviderStateMixin {
  bool _obscureText = true;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  final Color _primaryColor = const Color(0xFF009688);

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.97).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleVisibility() {
    setState(() => _obscureText = !_obscureText);
  }

  void _onTapDown() => _animationController.forward();
  void _onTapUp() => _animationController.reverse();

  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Подтвердите удаление'),
        content: Text('Удалить пароль для ${widget.site}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () {
              context.read<PasswordsBloc>().add(DeletePass(passwordId: widget.passwordId));
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Пароль для ${widget.site} удалён'),
                  backgroundColor: _primaryColor,
                ),
              );
            },
            child: const Text('Удалить', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _navigateToEdit() {
    context.read<PasswordsBloc>().add(InitEditPass(passwordId: widget.passwordId));
    Navigator.pushNamed(
      context,
      ScreenPaths.editPassListScreen,
      arguments: {'passwords_bloc': context.read<PasswordsBloc>()},
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return ScaleTransition(
      scale: _scaleAnimation,
      child: Card(
        elevation: 2,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: _primaryColor.withOpacity(0.2), width: 1),
        ),
        color: isDark ?const Color(0xFF1E1E1E) : Colors.white,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: _toggleVisibility,
          onLongPress: _showDeleteDialog,
          onTapDown: (_) => _onTapDown(),
          onTapUp: (_) => _onTapUp(),
          onTapCancel: _onTapUp,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Аватар
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: _primaryColor.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      widget.site.isNotEmpty ? widget.site[0].toUpperCase() : '?',
                      style: TextStyle(
                        color: _primaryColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),

                // Контент
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.site,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _obscureText ? '••••••••' : widget.password,
                        style: TextStyle(
                          fontSize: 16,
                          color: isDark ? Colors.white70 : Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),

                // Кнопки действий
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(
                        _obscureText ? Icons.visibility_off : Icons.visibility,
                        color: _primaryColor,
                      ),
                      onPressed: _toggleVisibility,
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit),
                      color: _primaryColor,
                      onPressed: _navigateToEdit,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}