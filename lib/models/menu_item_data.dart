import 'package:flutter/material.dart';

class MenuItemData {
  final IconData icon;
  final String title;
  final String description;
  final Color color;
  final VoidCallback onTap;

  const MenuItemData({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
    required this.onTap,
  });
}