import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';

class MiddleProblemDescriptionTab extends StatelessWidget {
  final bool isEnglish;

  const MiddleProblemDescriptionTab({
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
                  child: Text('LeetCode #876', style: TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: Responsive.sp(context, 12))),
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
              isEnglish ? 'Middle of the Linked List' : 'লিঙ্কড লিস্টের মাঝামাঝি নোড (Middle of Linked List)',
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
                        ? 'Given the head of a singly linked list, return the middle node of the linked list.\n\nIf there are two middle nodes (even length list), return the second middle node.\n\nRequirement: Solve in a single pass O(N) time and O(1) space.'
                        : 'একটি লিঙ্কড লিস্টের "head" দেওয়া আছে। লিঙ্কড লিস্টের ঠিক মাঝামাঝি (middle) নোডটি রিটার্ন করুন।\n\nযদি লিঙ্কড লিস্টের দৈর্ঘ্য জোড় হয় (দুইটি মিডল নোড থাকে), তবে দ্বিতীয় মিডল নোডটি রিটার্ন করতে হবে।\n\nশর্ত: এক পাসে O(N) সময় এবং O(1) স্পেসে সমাধান করুন।',
                    style: TextStyle(fontSize: Responsive.sp(context, 14), color: AppTheme.textSecondary, height: 1.5),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text(isEnglish ? '📌 Example Cases' : '📌 উদাহরণসমূহ', style: TextStyle(fontSize: Responsive.sp(context, 18), fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 12),
            _buildExampleCard(context, "Example 1 (Odd Length: 5 nodes)", "head = [1, 2, 3, 4, 5]", "Output: [3, 4, 5] (Middle Node: 3)", isEnglish ? "Explanation: Middle node of list is 3." : "ব্যাখ্যা: ৫ টি নোডের ক্ষেত্রে ঠিক মাঝের নোড হলো ৩।"),
            _buildExampleCard(context, "Example 2 (Even Length: 6 nodes)", "head = [1, 2, 3, 4, 5, 6]", "Output: [4, 5, 6] (Second Middle Node: 4)", isEnglish ? "Explanation: Middle nodes are 3 and 4. As per rule, return 2nd middle node (4)." : "ব্যাখ্যা: ৬ টি নোডের ক্ষেত্রে ৩ এবং ৪ দুটিই মিডিয়াম নোড। নিয়ম অনুযায়ী ২য় মিডল নোড ৪ রিটার্ন করা হয়েছে।"),
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
                      Text(isEnglish ? '🧠 Two-Pass vs One-Pass Fast & Slow' : '🧠 দুই পাস বনাম এক পাস Fast & Slow', style: TextStyle(fontSize: Responsive.sp(context, 16), fontWeight: FontWeight.bold, color: Colors.white)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildIntuitionRow(context, "❌ Two-Pass Approach O(N) + O(N)", isEnglish ? "Pass 1: Count total elements N. Pass 2: Iterate N/2 steps to find middle node. Requires traversing the list twice!" : "পাস ১: মোট দৈর্ঘ্য N গোনা। পাস ২: N/2 ধাপ হেঁটে মিডলে পৌঁছানো। ২ বার লিস্ট ট্রাভার্স করতে হয়।"),
                  _buildIntuitionRow(context, "🚀 One-Pass Fast & Slow Pointers O(N)", isEnglish ? "Move slow 1 step and fast 2 steps. When fast hits NULL or last node, slow is ALREADY at the middle node! Done in a single pass!" : "slow ১ ধাপ, fast ২ ধাপ যাবে। fast যখন শেষে পৌঁছাবে, slow কিন্তু ইতিমধ্যেই মিডল নোডে থাকবে! মাত্র ১ পাসে ফিনিশ!", highlight: true),
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
