import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:save_pass/save_pass_bloc/passwords_bloc/passwords_bloc.dart';
import 'package:save_pass/save_pass_ui/router.dart';

class PasswordListScreen extends StatelessWidget {
  const PasswordListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Password Manager',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF2C2C2C),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {
              // Логика поиска пароля
            },
          ),
        ],
      ),
      body: BlocBuilder<PasswordsBloc, PasswordsState>(
        builder: (context, state) {
          return ListView.builder(
            padding: const EdgeInsets.all(10.0),
            itemCount: state.passModel.length,
            itemBuilder: (context, index) {
              return PasswordCard(
                site: state.passModel[index].passwordName,
                password: state.passModel[index].password,
              );
            },
          );
        },
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

class PasswordCard extends StatefulWidget {
  final String site;
  final String password;

  const PasswordCard({super.key, required this.site, required this.password});

  @override
  // ignore: library_private_types_in_public_api
  _PasswordCardState createState() => _PasswordCardState();
}

class _PasswordCardState extends State<PasswordCard> {
  bool _obscureText = true;
  bool _isPressed = false;

  void _toggleVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  void _onTapDown() {
    setState(() {
      _isPressed = true;
    });
  }

  void _onTapUp() {
    setState(() {
      _isPressed = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _onTapDown(),
      onTapUp: (_) => _onTapUp(),
      onTapCancel: () => _onTapUp(),
      onTap: _toggleVisibility,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        decoration: BoxDecoration(
          color: _isPressed ? const Color(0xFF222222) : const Color(0xFF2C2C2C),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.6),
              offset: const Offset(5, 5),
              blurRadius: 15,
              spreadRadius: 1,
            ),
            BoxShadow(
              color: Colors.grey.shade800,
              offset: const Offset(-5, -5),
              blurRadius: 15,
              spreadRadius: 1,
            ),
          ],
        ),
        child: ListTile(
          contentPadding:
              const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
          leading: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF2C2C2C),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.6),
                  offset: const Offset(2, 2),
                  blurRadius: 10,
                  spreadRadius: 1,
                ),
                BoxShadow(
                  color: Colors.grey.shade800,
                  offset: const Offset(-2, -2),
                  blurRadius: 10,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: CircleAvatar(
              backgroundColor: const Color(0xFF2C2C2C),
              child: Text(
                widget.site[0].toUpperCase(),
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          title: Text(
            widget.site,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
              color: Colors.white,
            ),
          ),
          subtitle: Text(
            _obscureText ? '••••••••' : widget.password,
            style: const TextStyle(fontSize: 16.0, color: Colors.white70),
          ),
          trailing: GestureDetector(
            onTap: _toggleVisibility,
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF2C2C2C),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.6),
                    offset: const Offset(2, 2),
                    blurRadius: 10,
                    spreadRadius: 1,
                  ),
                  BoxShadow(
                    color: Colors.grey.shade800,
                    offset: const Offset(-2, -2),
                    blurRadius: 10,
                    spreadRadius: 1,
                  ),
                ],
              ),
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                _obscureText ? Icons.visibility_off : Icons.visibility,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
