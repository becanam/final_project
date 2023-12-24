import 'package:flutter/material.dart';

class ExplodingThumbsUp extends StatefulWidget {
  const ExplodingThumbsUp({super.key});

  @override
  _ExplodingThumbsUpState createState() => _ExplodingThumbsUpState();
}

class _ExplodingThumbsUpState extends State<ExplodingThumbsUp>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 2.0).animate(_controller);
    _fadeAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(_controller);
    _colorAnimation = ColorTween(begin: Colors.blue[300], end: Colors.green)
        .animate(_controller);

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reverse();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleOnPressed() {
    if (_controller.status == AnimationStatus.dismissed) {
      _controller.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      iconSize: 30,
      icon: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Opacity(
            opacity: _fadeAnimation.value,
            child: Transform.scale(
              scale: _scaleAnimation.value,
              child: Icon(Icons.thumb_up, color: _colorAnimation.value),
            ),
          );
        },
      ),
      onPressed: _handleOnPressed,
    );
  }
}