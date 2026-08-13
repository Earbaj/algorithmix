import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';
import '../../models/tree_bfs_data.dart';

class TreeBfsProblemCardWidget extends StatelessWidget {
  final TreeBfsProblem problem;
  final Color diffColor;
  final bool isEnglish;

  const TreeBfsProblemCardWidget({
    super.key,
    required this.problem,
    required this.diffColor,
    required this.isEnglish,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF1E293B)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Text(
                      problem.title,
                      style: TextStyle(
                        fontSize: Responsive.sp(context, 15),
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    if (problem.isPopular) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppTheme.accentPink.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          "🔥 HOT",
                          style: TextStyle(
                            fontSize: Responsive.sp(context, 10),
                            fontWeight: FontWeight.bold,
                            color: AppTheme.accentPink,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: diffColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  problem.difficulty,
                  style: TextStyle(
                    fontSize: Responsive.sp(context, 11),
                    fontWeight: FontWeight.bold,
                    color: diffColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            isEnglish ? problem.keyIdeaEn : problem.keyIdeaBn,
            style: TextStyle(
              fontSize: Responsive.sp(context, 13),
              color: AppTheme.textSecondary,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 6,
            runSpacing: 4,
            children: problem.companyTags.map((company) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppTheme.accentPurple.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  "🏢 $company",
                  style: TextStyle(
                    fontSize: Responsive.sp(context, 11),
                    color: AppTheme.accentPurple,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
