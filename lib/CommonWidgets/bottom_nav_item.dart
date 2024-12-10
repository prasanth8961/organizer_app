import 'package:flutter/material.dart';

class BottomNavItem extends StatelessWidget {
  const BottomNavItem(
      {super.key,
      required this.onTap,
      required this.icon,
      this.color = Colors.white});

  final void Function()? onTap;
  final IconData? icon;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        height: 60,
        width: 60,
        child: Icon(
          icon,
          color: color,
        ),
      ),
    );
  }
}
