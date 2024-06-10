import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:save_pass/save_pass_bloc/passwords_bloc/passwords_bloc.dart';
import 'package:save_pass/save_pass_ui/password_cards.dart';
import 'package:save_pass/save_pass_ui/router.dart';
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
      // appBar: AppBar(
      //   title: const Text(
      //     'Password Manager',
      //     style: TextStyle(color: Colors.white),
      //   ),
      //   backgroundColor: const Color(0xFF2C2C2C),
      //   elevation: 0,
      //   actions: [
      //     IconButton(
      //       icon: const Icon(Icons.search, color: Colors.white),
      //       onPressed: () {
      //         // Логика поиска пароля
      //       },
      //     ),
      //   ],
      // ),
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
              children: [
                BlocBuilder<PasswordsBloc, PasswordsState>(
                  builder: (context, state) {
                    return ListView.builder(
                      padding: const EdgeInsets.all(10.0),
                      itemCount: state.passModel.length,
                      itemBuilder: (context, index) {
                        return PasswordCard(
                          site: state.passModel[index].passwordName,
                          password: state.passModel[index].password,
                          passwordId: state.passModel[index].passwordId,
                        );
                      },
                    );
                  },
                ),
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
              title: 'Events',
            ),
            BarItem(
              icon: Icons.tune_rounded,
              title: 'Settings',
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

class ProtectionSettingsScreen extends StatefulWidget {
  @override
  _ProtectionSettingsScreenState createState() =>
      _ProtectionSettingsScreenState();
}

enum ProtectionLevel { basic, medium, high }

class _ProtectionSettingsScreenState extends State<ProtectionSettingsScreen> {
  ProtectionLevel _selectedLevel = ProtectionLevel.basic;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
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
            leading: Radio<ProtectionLevel>(
              value: ProtectionLevel.basic,
              groupValue: _selectedLevel,
              onChanged: (ProtectionLevel? value) {
                setState(() {
                  _selectedLevel = value!;
                });
              },
            ),
          ),
          ListTile(
            title: const Text('Средний'),
            subtitle: const Text(
              'Рекомендуемый уровень защиты. Включает все функции базового уровня и шифрование.',
              style: TextStyle(fontSize: 12),
            ),
            leading: Radio<ProtectionLevel>(
              value: ProtectionLevel.medium,
              groupValue: _selectedLevel,
              onChanged: (ProtectionLevel? value) {
                setState(() {
                  _selectedLevel = value!;
                });
              },
            ),
          ),
          ListTile(
            title: const Text('Высокий'),
            subtitle: const Text(
              'Максимальная защита. Включает все функции среднего уровня, а также двойное шифрование данных .',
              style: TextStyle(fontSize: 12),
            ),
            leading: Radio<ProtectionLevel>(
              value: ProtectionLevel.high,
              groupValue: _selectedLevel,
              onChanged: (ProtectionLevel? value) {
                setState(() {
                  _selectedLevel = value!;
                });
              },
            ),
          ),
        
        ],
      ),
    );
  }
}
