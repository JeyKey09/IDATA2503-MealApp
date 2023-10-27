import 'package:flutter/material.dart';

/// A meal category
class Category {
  const Category({
    required this.id,
    required this.title,
    // default color
    this.color = Colors.orange,
  });

  final String id;
  final String title;
  final Color color;
}
