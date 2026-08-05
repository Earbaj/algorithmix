import 'package:flutter/material.dart';
import 'package:algorithmix/domain/models/pattern_model.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'package:algorithmix/ui/core/navigation/app_routes.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';

class PatternDetailModal extends StatelessWidget {
  final PatternModel pattern;

  const PatternDetailModal({super.key, required this.pattern});

  static void show(BuildContext context, PatternModel pattern) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => PatternDetailModal(pattern: pattern),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenH = Responsive.screenHeight(context);

    return Align(
      alignment: Alignment.bottomCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 720),
        child: Container(
          height: screenH * 0.85,
          decoration: const BoxDecoration(
            color: AppTheme.surfaceDark,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            border: Border(
              top: BorderSide(color: AppTheme.accentPurple, width: 2),
            ),
          ),
          child: Column(
            children: [
              // Drag handle
              Container(
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                width: 48,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFF475569),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.all(Responsive.isMobile(context) ? 20 : 28),
                  children: [
                    // Header Row
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: pattern.themeColor.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: pattern.themeColor.withOpacity(0.4)),
                          ),
                          child: Icon(pattern.icon, color: pattern.themeColor, size: 32),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                pattern.title,
                                style: TextStyle(
                                  fontSize: Responsive.sp(context, 20),
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: pattern.difficultyColor.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(color: pattern.difficultyColor),
                                    ),
                                    child: Text(
                                      pattern.difficultyText,
                                      style: TextStyle(
                                        fontSize: Responsive.sp(context, 12),
                                        fontWeight: FontWeight.bold,
                                        color: pattern.difficultyColor,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    pattern.category,
                                    style: TextStyle(
                                      fontSize: Responsive.sp(context, 12),
                                      color: AppTheme.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Launch Deep Dive Button if Basic Data Structures (id 2) or Two Pointers (id 4)
                    if (pattern.id == 2) ...[
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.of(context).pop();
                            Navigator.of(context).pushNamed(AppRoutes.dsa);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.accentNeonCyan,
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          icon: const Icon(Icons.rocket_launch, size: 20),
                          label: const Text(
                            'Open Basic Data Structures Hub 🚀',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                    if (pattern.id == 4) ...[
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.of(context).pop();
                            Navigator.of(context).pushNamed(AppRoutes.twoPointersDetail);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.accentNeonCyan,
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          icon: const Icon(Icons.rocket_launch, size: 20),
                          label: const Text(
                            'Launch Full Interactive Deep Dive 🚀',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],

                    // Complexity Badges Box
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryDark,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFF334155)),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                Text(
                                  'Time Complexity',
                                  style: TextStyle(
                                    fontSize: Responsive.sp(context, 12),
                                    color: AppTheme.textSecondary,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  pattern.timeComplexity,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: Responsive.sp(context, 14),
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.accentNeonCyan,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(width: 1, height: 40, color: const Color(0xFF334155)),
                          Expanded(
                            child: Column(
                              children: [
                                Text(
                                  'Space Complexity',
                                  style: TextStyle(
                                    fontSize: Responsive.sp(context, 12),
                                    color: AppTheme.textSecondary,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  pattern.spaceComplexity,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: Responsive.sp(context, 14),
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.accentPink,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Description
                    Text(
                      'Overview',
                      style: TextStyle(
                        fontSize: Responsive.sp(context, 16),
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      pattern.description,
                      style: TextStyle(
                        fontSize: Responsive.sp(context, 14),
                        color: AppTheme.textSecondary,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Key Concepts
                    Text(
                      'Key Concepts & Intuition',
                      style: TextStyle(
                        fontSize: Responsive.sp(context, 16),
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...pattern.keyConcepts.map((concept) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(Icons.check_circle_outline, color: pattern.themeColor, size: 18),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  concept,
                                  style: TextStyle(
                                    color: AppTheme.textPrimary,
                                    fontSize: Responsive.sp(context, 14),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )),
                    const SizedBox(height: 24),

                    // Sample Code Template
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Starter Template / Implementation',
                          style: TextStyle(
                            fontSize: Responsive.sp(context, 16),
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.copy, size: 20, color: AppTheme.accentNeonCyan),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Code snippet copied to clipboard!'),
                                duration: Duration(seconds: 1),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF090D16),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFF1E293B)),
                      ),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text(
                          pattern.sampleCode,
                          style: TextStyle(
                            fontFamily: 'monospace',
                            fontSize: Responsive.sp(context, 13),
                            color: const Color(0xFF38BDF8),
                            height: 1.4,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
