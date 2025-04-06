import 'package:flutter/material.dart';
import 'dart:math';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> 
    with SingleTickerProviderStateMixin {
  
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;
  final Color _primaryColor = const Color(0xFF009688);
  final Color _darkBgColor = const Color(0xFF121212);

  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();
    
    _scaleAnimation = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.2), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.2, end: 1.0), weight: 50),
    ]).animate(_controller);
    
    _rotationAnimation = Tween(begin: 0.0, end: 2 * pi).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? _darkBgColor : Colors.grey[50],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Анимированный защитный щит
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Transform(
                  transform: Matrix4.identity()
                    ..scale(_scaleAnimation.value)
                    ..rotateZ(_rotationAnimation.value),
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.security_rounded,
                    size: 80,
                    color: _primaryColor.withOpacity(0.8),
                  ),
                );
              },
            ),
            
            const SizedBox(height: 30),
            
            // Текст с волновым эффектом
            ShaderMask(
              shaderCallback: (rect) {
                return LinearGradient(
                  colors: [
                    _primaryColor,
                    _primaryColor.withGreen(_primaryColor.green + 50),
                    _primaryColor,
                  ],
                  stops: const [0.0, 0.5, 1.0],
                  transform: _GradientTransform(_controller.value),
                ).createShader(rect);
              },
              child: const Text(
                'Save Pass',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
            
            const SizedBox(height: 40),
            
            // Кастомный индикатор
            _buildWaveLoader(),
          ],
        ),
      ),
    );
  }

  Widget _buildWaveLoader() {
    return SizedBox(
      width: 150,
      height: 30,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(5, (index) {
          return AnimatedBar(
            controller: _controller,
            index: index,
            color: _primaryColor,
          );
        }),
      ),
    );
  }
}

class _GradientTransform extends GradientTransform {
  final double progress;
  
  _GradientTransform(this.progress);
  
  @override
  Matrix4 transform(Rect bounds, {TextDirection? textDirection}) {
    return Matrix4.identity()
      ..translate(-bounds.width * (1 - progress), 0.0, 0.0);
  }
}

class AnimatedBar extends StatelessWidget {
  final AnimationController controller;
  final int index;
  final Color color;
  
  const AnimatedBar({
    super.key,
    required this.controller,
    required this.index,
    required this.color,
  });
  
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final value = (controller.value * 5 - index).clamp(0.0, 1.0);
        return Container(
          width: 8,
          height: 30 * (0.5 + value * 0.5),
          decoration: BoxDecoration(
            color: color.withOpacity(0.3 + value * 0.7),
            borderRadius: BorderRadius.circular(4),
          ),
        );
      },
    );
  }
}