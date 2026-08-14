import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';

class IntersectionProblemDescriptionTab extends StatelessWidget {
  final bool isEnglish;

  const IntersectionProblemDescriptionTab({
    super.key,
    required this.isEnglish,
  });

  @override
  Widget build(BuildContext context) {
    final hPadding = Responsive.horizontalPadding(context);

    return ResponsiveCenter(
      maxWidth: 1280.0,
      padding: EdgeInsets.all(hPadding),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.accentGreen.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppTheme.accentGreen),
                  ),
                  child: Text('🟢 Easy', style: TextStyle(color: AppTheme.accentGreen, fontWeight: FontWeight.bold, fontSize: Responsive.sp(context, 12))),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.accentPurple.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppTheme.accentPurple),
                  ),
                  child: Text('LeetCode #160', style: TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: Responsive.sp(context, 12))),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.accentPink.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppTheme.accentPink),
                  ),
                  child: Text('⭐ FAANG Top Pick', style: TextStyle(color: AppTheme.accentPink, fontWeight: FontWeight.bold, fontSize: Responsive.sp(context, 12))),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              isEnglish ? 'Intersection of Two Linked Lists' : 'দুইটি লিঙ্কড লিস্টের ইন্টারসেকশন নোড (Intersection of Two Linked Lists)',
              style: TextStyle(fontSize: Responsive.sp(context, 22), fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 12),
            Container(
              padding: EdgeInsets.all(Responsive.sp(context, 18)),
              decoration: BoxDecoration(
                color: AppTheme.surfaceDark,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF334155)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(isEnglish ? 'Problem Statement' : 'সমস্যার বিবরণ', style: TextStyle(fontSize: Responsive.sp(context, 16), fontWeight: FontWeight.bold, color: AppTheme.accentNeonCyan)),
                  const SizedBox(height: 10),
                  Text(
                    isEnglish
                        ? 'Given the heads of two singly linked lists headA and headB, return the node at which the two lists intersect. If the two linked lists have no intersection at all, return null.\n\nRequirement: Solve in O(M + N) time complexity and O(1) auxiliary space.'
                        : 'দুইটি একমুখী লিঙ্কড লিস্ট "headA" এবং "headB" দেওয়া আছে। যে নোডে দুটি লিস্ট মিলিত হয়েছে (intersection node) তা রিটার্ন করুন। কোনো ইন্টারসেকশন না থাকলে null রিটার্ন করুন।\n\nশর্ত: O(M + N) সময় এবং O(1) মেমোরি স্পেসে সমাধান করুন।',
                    style: TextStyle(fontSize: Responsive.sp(context, 14), color: AppTheme.textSecondary, height: 1.5),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text(isEnglish ? '📌 Example Cases' : '📌 উদাহরণসমূহ', style: TextStyle(fontSize: Responsive.sp(context, 18), fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 12),
            _buildExampleCard(
              context,
              "Example 1",
              "listA = [4, 1, 8, 4, 5], listB = [5, 6, 1, 8, 4, 5]",
              "Output: Intersected at node '8'",
              isEnglish ? "Explanation: The two lists intersect at node with value 8." : "ব্যাখ্যা: দুটি লিস্ট মান ৮ নোডে এসে মিলিত হয়েছে।",
            ),
            _buildExampleCard(
              context,
              "Example 2 (No Intersection)",
              "listA = [2, 6, 4], listB = [1, 5]",
              "Output: null (No Intersection)",
              isEnglish ? "Explanation: The two lists do not intersect at any node." : "ব্যাখ্যা: দুটি লিস্ট কোনো নোডেই মিলিত হয়নি।",
            ),
            const SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(Responsive.sp(context, 18)),
              decoration: BoxDecoration(
                color: AppTheme.surfaceDark,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.accentPurple.withOpacity(0.5)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.lightbulb_outline, color: AppTheme.accentAmber, size: Responsive.sp(context, 24)),
                      const SizedBox(width: 8),
                      Text(isEnglish ? '🧠 Pointer Switching Magic' : '🧠 পয়েন্টার সুইচিং ম্যাজিক', style: TextStyle(fontSize: Responsive.sp(context, 16), fontWeight: FontWeight.bold, color: Colors.white)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildIntuitionRow(context, "1️⃣ Two Pointers pA & pB", isEnglish ? "Set pA at headA and pB at headB. Move both 1 step forward at a time." : "pA কে headA এবং pB কে headB এ বসিয়ে এক ধাপ করে সামনে বাড়ানো।"),
                  _buildIntuitionRow(context, "2️⃣ Switch Heads at End", isEnglish ? "When pA reaches end, redirect pA = headB. When pB reaches end, redirect pB = headA." : "pA শেষে পৌঁছালে headB এ রিডাইরেক্ট এবং pB শেষে পৌঁছালে headA এ রিডাইরেক্ট করা।"),
                  _buildIntuitionRow(context, "3️⃣ Equal Path Length Collision", isEnglish ? "Both pointers now cover total length len(A) + len(B)! They are guaranteed to collide at intersection node (or null)!" : "উভয় পয়েন্টার এখন সমান দূরত্ব len(A) + len(B) পার করবে এবং ইন্টারসেকশনে মিলিত হবে!", highlight: true),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildExampleCard(BuildContext context, String title, String input, String output, String desc) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: AppTheme.surfaceDark, borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFF334155))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.accentNeonCyan, fontSize: Responsive.sp(context, 13))),
          const SizedBox(height: 4),
          Text(input, style: TextStyle(fontFamily: 'monospace', color: Colors.white, fontSize: Responsive.sp(context, 12))),
          Text(output, style: TextStyle(fontFamily: 'monospace', color: AppTheme.accentGreen, fontWeight: FontWeight.bold, fontSize: Responsive.sp(context, 12))),
          const SizedBox(height: 4),
          Text(desc, style: TextStyle(color: AppTheme.textSecondary, fontSize: Responsive.sp(context, 12))),
        ],
      ),
    );
  }

  Widget _buildIntuitionRow(BuildContext context, String title, String desc, {bool highlight = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(highlight ? Icons.star : Icons.chevron_right, color: highlight ? AppTheme.accentGreen : AppTheme.textMuted, size: Responsive.sp(context, 18)),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: highlight ? AppTheme.accentGreen : Colors.white, fontSize: Responsive.sp(context, 13))),
                const SizedBox(height: 2),
                Text(desc, style: TextStyle(color: AppTheme.textSecondary, fontSize: Responsive.sp(context, 12), height: 1.3)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
