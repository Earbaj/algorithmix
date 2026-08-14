import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';

class CycleProblemDescriptionTab extends StatelessWidget {
  final String problemTitle;
  final bool isEnglish;

  const CycleProblemDescriptionTab({
    super.key,
    required this.problemTitle,
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
                  child: Text('LeetCode #141', style: TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: Responsive.sp(context, 12))),
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
              isEnglish ? 'Linked List Cycle (Floyd\'s Algorithm)' : 'লিঙ্কড লিস্ট সাইকেল (ফ্লয়েডের অ্যালগরিদম)',
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
                        ? 'Given head, the head of a linked list, determine if the linked list has a cycle in it.\n\nThere is a cycle in a linked list if there is some node in the list that can be reached again by continuously following the next pointer. Internally, pos is used to denote the index of the node that tail\'s next pointer is connected to. Note that pos is not passed as a parameter.\n\nReturn true if there is a cycle in the linked list. Otherwise, return false.\n\nConstraint: Can you solve it using O(1) memory space?'
                        : 'একটি লিঙ্কড লিস্টের হেডের পয়েন্টার "head" দেওয়া আছে। নির্ণয় করুন লিস্টে কোনো সাইকেল (চক্র) আছে কিনা।\n\nযদি লিঙ্কড লিস্টের পরবর্তী পয়েন্টার অনুসরণ করে এমন একটি নোডে পৌঁছানো যায় যা পূর্বে একবার ভিজিট করা হয়েছে, তবে সাইকেল বিদ্যমান।\n\nশর্ত: আপনাকে অবশ্যই O(1) মেমোরি স্পেস ব্যবহার করে সমাধান করতে হবে।',
                    style: TextStyle(fontSize: Responsive.sp(context, 14), color: AppTheme.textSecondary, height: 1.5),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text(isEnglish ? '📌 Example Cases' : '📌 উদাহরণসমূহ', style: TextStyle(fontSize: Responsive.sp(context, 18), fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 12),
            _buildExampleCard(context, "Example 1", "head = [3, 2, 0, -4], pos = 1", "Output: true", isEnglish ? "Explanation: Tail node (-4) connects to node index 1 (val 2)." : "ব্যাখ্যা: টেল নোড (-4) ১ নম্বর ইনডেক্সের নোডের (মান 2) সাথে যুক্ত।"),
            _buildExampleCard(context, "Example 2", "head = [1, 2], pos = 0", "Output: true", isEnglish ? "Explanation: Tail node (2) connects to node index 0 (val 1)." : "ব্যাখ্যা: টেল নোড (2) ০ নম্বর ইনডেক্সের নোডের (মান 1) সাথে যুক্ত।"),
            _buildExampleCard(context, "Example 3", "head = [1], pos = -1", "Output: false", isEnglish ? "Explanation: There is no cycle in the linked list." : "ব্যাখ্যা: লিঙ্কড লিস্টে কোনো সাইকেল নেই।"),
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
                      Text(isEnglish ? '🧠 Why Fast & Slow Pointers Works?' : '🧠 কেন Fast & Slow Pointers কার্যকরী?', style: TextStyle(fontSize: Responsive.sp(context, 16), fontWeight: FontWeight.bold, color: Colors.white)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildIntuitionRow(context, "❌ Hash Set Approach O(N) Space", isEnglish ? "Store visited node pointers in a set. Works, but uses O(N) extra space." : "ভিজিটেড নোড হ্যাশ সেটে রাখা। O(N) মেমোরি লাগে।"),
                  _buildIntuitionRow(context, "🚀 Floyd's Tortoise & Hare O(1) Space", isEnglish ? "Slow moves 1 step, Fast moves 2 steps. Inside a loop, Fast closes the gap by 1 node per turn until collision!" : "Slow ১ ধাপ, Fast ২ ধাপ যাবে। সাইকেল থাকলে প্রতি ধাপে দূরত্ব ১ করে কমবে এবং মিলন ঘটবে!", highlight: true),
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
