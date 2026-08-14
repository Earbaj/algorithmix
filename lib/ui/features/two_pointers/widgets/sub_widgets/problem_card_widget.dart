import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';
import 'package:algorithmix/ui/core/navigation/app_routes.dart';
import '../../models/two_pointers_data.dart';

class TwoPointersProblemCardWidget extends StatelessWidget {
  final TwoPointersProblem problem;
  final Color diffColor;
  final bool isEnglish;

  const TwoPointersProblemCardWidget({
    super.key,
    required this.problem,
    required this.diffColor,
    required this.isEnglish,
  });

  void _navigateToDetail(BuildContext context) {
    final title = problem.title;
    switch (title) {
      case "Two Sum II (Sorted Array)":
        Navigator.pushNamed(context, AppRoutes.twoSumII);
        break;
      case "Valid Palindrome":
        Navigator.pushNamed(context, AppRoutes.validPalindrome);
        break;
      case "Reverse String":
        Navigator.pushNamed(context, AppRoutes.reverseString);
        break;
      case "Move Zeroes":
        Navigator.pushNamed(context, AppRoutes.moveZeroes);
        break;
      case "Remove Duplicates from Sorted Array":
        Navigator.pushNamed(context, AppRoutes.removeDuplicates);
        break;
      case "Squares of a Sorted Array":
        Navigator.pushNamed(context, AppRoutes.squaresSortedArray);
        break;
      case "Merge Sorted Array":
        Navigator.pushNamed(context, AppRoutes.mergeSortedArray);
        break;
      case "Is Subsequence":
        Navigator.pushNamed(context, AppRoutes.isSubsequence);
        break;
      case "3Sum":
        Navigator.pushNamed(context, AppRoutes.threeSum);
        break;
      case "3Sum Closest":
        Navigator.pushNamed(context, AppRoutes.threeSumClosest);
        break;
      case "Container With Most Water":
        Navigator.pushNamed(context, AppRoutes.containerWithMostWater);
        break;
      case "Sort Colors (Dutch National Flag)":
        Navigator.pushNamed(context, AppRoutes.sortColors);
        break;
      case "Remove Duplicates from Sorted Array II":
        Navigator.pushNamed(context, AppRoutes.removeDuplicatesII);
        break;
      case "4Sum":
        Navigator.pushNamed(context, AppRoutes.fourSum);
        break;
      case "Boats to Save People":
        Navigator.pushNamed(context, AppRoutes.boatsToSavePeople);
        break;
      case "Partition Labels":
        Navigator.pushNamed(context, AppRoutes.partitionLabels);
        break;
      case "Trapping Rain Water":
        Navigator.pushNamed(context, AppRoutes.trappingRainWater);
        break;
      case "Minimum Window Substring":
        Navigator.pushNamed(context, AppRoutes.minWindowSubstring);
        break;
      default:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isEnglish
                  ? "Detail view for '$title' coming soon!"
                  : "'$title' এর বিস্তারিত শীঘ্রই আসছে!",
            ),
            duration: const Duration(seconds: 2),
          ),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _navigateToDetail(context),
      borderRadius: BorderRadius.circular(12),
      child: Container(
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
                      Expanded(
                        child: Text(
                          problem.title,
                          style: TextStyle(
                            fontSize: Responsive.sp(context, 15),
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
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
                const SizedBox(width: 8),
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
                const SizedBox(width: 4),
                const Icon(Icons.arrow_forward_ios, size: 14, color: AppTheme.textMuted),
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
      ),
    );
  }
}
