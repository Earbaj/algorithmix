import 'package:flutter/material.dart';

enum PatternDifficulty {
  beginner,
  intermediate,
  advanced,
}

class PatternModel {
  final int id;
  final String title;
  final String category;
  final PatternDifficulty difficulty;
  final IconData icon;
  final Color themeColor;
  final String description;
  final String timeComplexity;
  final String spaceComplexity;
  final List<String> keyConcepts;
  final String sampleCode;
  final bool isHot;

  const PatternModel({
    required this.id,
    required this.title,
    required this.category,
    required this.difficulty,
    required this.icon,
    required this.themeColor,
    required this.description,
    required this.timeComplexity,
    required this.spaceComplexity,
    required this.keyConcepts,
    required this.sampleCode,
    this.isHot = false,
  });

  String get difficultyText {
    switch (difficulty) {
      case PatternDifficulty.beginner:
        return 'Easy';
      case PatternDifficulty.intermediate:
        return 'Medium';
      case PatternDifficulty.advanced:
        return 'Hard';
    }
  }

  Color get difficultyColor {
    switch (difficulty) {
      case PatternDifficulty.beginner:
        return const Color(0xFF10B981);
      case PatternDifficulty.intermediate:
        return const Color(0xFFF59E0B);
      case PatternDifficulty.advanced:
        return const Color(0xFFEF4444);
    }
  }
}
