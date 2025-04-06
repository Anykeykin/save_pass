import 'package:domain/models/pass_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:save_pass/save_pass_bloc/passwords_bloc/passwords_bloc.dart';
import 'package:save_pass/save_pass_ui/pass/password_cards.dart';
import 'package:save_pass/save_pass_ui/pass/passwords_screen.dart';
import 'package:save_pass/save_pass_ui/router/screen_paths.dart';
import 'package:save_pass/save_pass_ui/settings/settings_screen.dart';
import 'package:sliding_clipped_nav_bar/sliding_clipped_nav_bar.dart';

class PasswordListScreen extends StatefulWidget {
  const PasswordListScreen({super.key});

  @override
  State<PasswordListScreen> createState() => _PasswordListScreenState();
}

class _PasswordListScreenState extends State<PasswordListScreen> {
  late PageController _pageController;
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: selectedIndex);
  }

  void onButtonPressed(int index) {
    setState(() {
      selectedIndex = index;
    });
    _pageController.animateToPage(selectedIndex,
        duration: const Duration(milliseconds: 400), curve: Curves.easeOutQuad);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          const SafeArea(
              child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Password Manager',
              style: TextStyle(color: Colors.white),
            ),
          )),
          Expanded(
            child: PageView(
              physics: const NeverScrollableScrollPhysics(),
              controller: _pageController,
              children: const [
                PasswordsScreen(),
                ProtectionSettingsScreen(),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: SlidingClippedNavBar(
          backgroundColor: const Color(0xFF2C2C2C),
          onButtonPressed: onButtonPressed,
          iconSize: 30,
          activeColor: Colors.white,
          selectedIndex: selectedIndex,
          barItems: <BarItem>[
            BarItem(
              icon: Icons.event,
              title: 'Пароли',
            ),
            BarItem(
              icon: Icons.tune_rounded,
              title: 'Настройки',
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Логика добавления нового пароля
          Navigator.of(context).pushNamed(
            ScreenPaths.createPassListScreen,
            arguments: {
              'passwords_bloc': context.read<PasswordsBloc>(),
            },
          );
        },
        backgroundColor: const Color(0xFF2C2C2C),
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
