import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:save_pass/save_pass_bloc/passwords_bloc/passwords_bloc.dart';
import 'package:save_pass/save_pass_ui/pass/passwords_screen.dart';
import 'package:save_pass/save_pass_ui/router/screen_paths.dart';
import 'package:save_pass/save_pass_ui/settings/settings_screen.dart';
import 'package:sliding_clipped_nav_bar/sliding_clipped_nav_bar.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late PageController _pageController;
  int selectedIndex = 0;
  final Color _primaryColor = const Color(0xFF009688);

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: selectedIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void onButtonPressed(int index) {
    setState(() => selectedIndex = index);
    _pageController.animateToPage(
      selectedIndex,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOutQuad,
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Password Manager',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: _primaryColor,
        foregroundColor: isDark ? Colors.white : _primaryColor,
      ),
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _pageController,
        children: const [
          PasswordsScreen(),
          ProtectionSettingsScreen(),
        ],
      ),
      bottomNavigationBar: SlidingClippedNavBar(
        backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        onButtonPressed: onButtonPressed,
        iconSize: 26,
        activeColor: _primaryColor,
        inactiveColor: isDark ? Colors.white54 : Colors.grey,
        selectedIndex: selectedIndex,
        barItems: [
          BarItem(
            icon: Icons.lock_outline,
            title: 'Пароли',
          ),
          BarItem(
            icon: Icons.settings_outlined,
            title: 'Настройки',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).pushNamed(
          ScreenPaths.createPassListScreen,
          arguments: {'passwords_bloc': context.read<PasswordsBloc>()},
        ),
        backgroundColor: _primaryColor,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}