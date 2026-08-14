import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';
import 'package:simple_icons/simple_icons.dart';
import '../../models/fast_slow_pointers_data.dart';
import '../../views/linked_list_cycle_detail_screen.dart';
import '../../views/middle_of_linked_list_detail_screen.dart';
import '../../views/happy_number_detail_screen.dart';
import '../../views/remove_duplicates_from_sorted_list_detail_screen.dart';
import '../../views/palindrome_linked_list_detail_screen.dart';
import '../../views/delete_node_in_linked_list_detail_screen.dart';
import '../../views/swapping_nodes_in_linked_list_detail_screen.dart';
import '../../views/intersection_of_two_linked_lists_detail_screen.dart';

class FastSlowProblemCardWidget extends StatelessWidget {
  final FastSlowPointersProblem problem;
  final Color diffColor;
  final bool isEnglish;

  const FastSlowProblemCardWidget({
    super.key,
    required this.problem,
    required this.diffColor,
    required this.isEnglish,
  });

  void _navigateToDetail(BuildContext context) {
    if (problem.title == "Middle of the Linked List") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const MiddleOfLinkedListDetailScreen(),
        ),
      );
    } else if (problem.title == "Happy Number") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const HappyNumberDetailScreen(),
        ),
      );
    } else if (problem.title == "Remove Duplicates from Sorted List") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const RemoveDuplicatesFromSortedListDetailScreen(),
        ),
      );
    } else if (problem.title == "Palindrome Linked List") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const PalindromeLinkedListDetailScreen(),
        ),
      );
    } else if (problem.title == "Delete Node in a Linked List") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const DeleteNodeInLinkedListDetailScreen(),
        ),
      );
    } else if (problem.title == "Swapping Nodes in a Linked List") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const SwappingNodesInLinkedListDetailScreen(),
        ),
      );
    } else if (problem.title == "Intersection of Two Linked Lists") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const IntersectionOfTwoLinkedListsDetailScreen(),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LinkedListCycleDetailScreen(
            problemTitle: problem.title,
          ),
        ),
      );
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
                            "Popular",
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
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        getCompanyIcon(company),
                        size: 14,
                        color: AppTheme.accentPurple,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        company,
                        style: TextStyle(
                          fontSize: Responsive.sp(context, 11),
                          color: AppTheme.accentPurple,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  IconData getCompanyIcon(String company) {
    switch (company.toLowerCase()) {
      case 'google':
        return SimpleIcons.google;

      case 'microsoft':
        return SimpleIcons.mega;

      case 'amazon':
        return SimpleIcons.alamy;

      case 'uber':
        return SimpleIcons.unpkg;

      case 'meta':
        return SimpleIcons.meta;

      case 'apple':
        return SimpleIcons.apple;

      default:
        return Icons.business_outlined;
    }
  }
}
