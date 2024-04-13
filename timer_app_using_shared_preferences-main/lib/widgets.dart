import 'package:flutter/material.dart';

class RoundButton extends StatelessWidget {
  final double size;
  final Color color;
  final VoidCallback onPressed;
  final IconData icon;
  const RoundButton(
      {super.key,
      required this.size,
      required this.color,
      required this.onPressed,
      required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon),
        iconSize: size * 0.6,
        color: Colors.white,
      ),
    );
  }
}
