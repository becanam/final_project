import 'package:flutter/material.dart';

class BottomNavWidget extends StatelessWidget {
  const BottomNavWidget({
    super.key, this.onTap, this.color, required this.tabName
  });

  final void Function()? onTap;
  final String tabName;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        height: 20,
        width: 80,
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Text(tabName,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: color,
                      ),
        ),
      ),
    ));
  }
}