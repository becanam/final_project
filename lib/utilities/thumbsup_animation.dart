import 'package:flutter/material.dart';

class ThumbsUpAnimation extends StatefulWidget {
  final VoidCallback onAnimationComplete;

  ThumbsUpAnimation({required this.onAnimationComplete});

  @override
  _ThumbsUpAnimationState createState() => _ThumbsUpAnimationState();
}

class _ThumbsUpAnimationState extends State<ThumbsUpAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          widget.onAnimationComplete();
        }
      });

    _scaleAnimation = Tween<double>(begin: 1.0, end: 2.0).animate(_animationController);
    _colorAnimation = ColorTween(begin: Colors.grey, end: Colors.green).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void triggerAnimation() {
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      iconSize: _scaleAnimation.value * 30,
      color: _colorAnimation.value,
      icon: Icon(Icons.thumb_up),
      onPressed: triggerAnimation,
    );
  }
}
