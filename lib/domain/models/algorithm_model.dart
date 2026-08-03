import 'package:flutter/material.dart';

class AlgorithmModel {
  final int id;
  final String title;
  final String category;
  final String complexity;
  final String description;
  final IconData icon;
  final Color color;

  const AlgorithmModel({
    required this.id,
    required this.title,
    required this.category,
    required this.complexity,
    required this.description,
    required this.icon,
    required this.color,
  });
}
