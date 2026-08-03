import 'package:flutter/material.dart';

class DsaModel {
  final int id;
  final String title;
  final String category;
  final String timeComplexity;
  final String description;
  final IconData icon;
  final Color color;

  const DsaModel({
    required this.id,
    required this.title,
    required this.category,
    required this.timeComplexity,
    required this.description,
    required this.icon,
    required this.color,
  });
}
