import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';

class HappyProblemDescriptionTab extends StatelessWidget {
  final bool isEnglish;

  const HappyProblemDescriptionTab({
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
                  child: Text('LeetCode #202', style: TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: Responsive.sp(context, 12))),
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
              isEnglish ? 'Happy Number' : 'হ্যাপি নাম্বার (Happy Number)',
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
                        ? 'Write an algorithm to determine if a number n is happy.\n\nA happy number is a number defined by the following process:\n1. Starting with any positive integer, replace the number by the sum of the squares of its digits.\n2. Repeat the process until the number equals 1 (where it will stay), or it loops endlessly in a cycle which does not include 1.\n3. Those numbers for which this process ends in 1 are happy numbers.\n\nReturn true if n is a happy number, and false if not.'
                        : 'একটি পজিটিভ সংখ্যা n হ্যাপি নাম্বার কিনা তা নির্ধারণ করুন।\n\nহ্যাপি নাম্বার নির্ধারণের নিয়ম:\n১. যেকোনো পজিটিভ সংখ্যা থেকে শুরু করে তার অংকগুলোর (digits) বর্গের যোগফল দিয়ে সংখ্যাটিকে প্রতিস্থাপন করুন।\n২. এই প্রক্রিয়াটি বার বার পুনরাবৃত্তি করুন যতক্ষণ না যোগফল ১ হয়, অথবা কোনো চক্রে (cycle) আটকে যায় যেখানে ১ নেই।\n৩. যে সকল সংখ্যার ক্ষেত্রে এই প্রক্রিয়া ১ এ শেষ হয় সেগুলোকে হ্যাপি নাম্বার বলা হয়।\n\nসংখ্যাটি হ্যাপি নাম্বার হলে true এবং অন্যথায় false রিটার্ন করুন।',
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
              "Example 1 (Happy Number)",
              "n = 19",
              "Output: true",
              isEnglish
                  ? "Explanation:\n1² + 9² = 82\n8² + 2² = 68\n6² + 8² = 100\n1² + 0² + 0² = 1 (Happy! 🎉)"
                  : "ব্যাখ্যা:\n1² + 9² = 82\n8² + 2² = 68\n6² + 8² = 100\n1² + 0² + 0² = 1 (হ্যাপি নাম্বার! 🎉)",
            ),
            _buildExampleCard(
              context,
              "Example 2 (Unhappy Number / Cycle)",
              "n = 2",
              "Output: false",
              isEnglish
                  ? "Explanation: 2 -> 4 -> 16 -> 37 -> 58 -> 89 -> 145 -> 42 -> 20 -> 4 (Gets stuck in an infinite cycle starting at 4, never reaches 1!)."
                  : "ব্যাখ্যা: 2 -> 4 -> 16 -> 37 -> 58 -> 89 -> 145 -> 42 -> 20 -> 4 (৪ নম্বর থেকে শুরু হওয়া অনন্ত লুপে আটকে যায়, কখনো ১ হয় না)।",
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
                      Text(isEnglish ? '🧠 Why Fast & Slow Pointers Works?' : '🧠 কেন Fast & Slow Pointers দিয়ে সমাধান সম্ভব?', style: TextStyle(fontSize: Responsive.sp(context, 16), fontWeight: FontWeight.bold, color: Colors.white)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildIntuitionRow(context, "❌ HashSet Approach O(N) Space", isEnglish ? "Store seen numbers in a HashSet to detect cycles. Works, but uses O(N) extra space." : "দেখা সংখ্যাগুলো হ্যাশ সেটে সংরক্ষণ করে সাইকেল ধরা। মেমোরি O(N) লাগে।"),
                  _buildIntuitionRow(context, "🚀 Floyd's Cycle Detection O(1) Space", isEnglish ? "Treat digit-square sums as an implicit linked list! Move Slow 1 transformation per step and Fast 2 transformations per step. If a cycle exists, Fast will collide with Slow! If 1 is reached, return true!" : "চিত্রায়ন: ডিজিট বর্গের যোগফলকে একটি ইমপ্লিসিট লিঙ্কড লিস্ট হিসেবে ভাবুন! Slow প্রতি ধাপে ১ বার এবং Fast ২ বার ডিজিট স্কয়ার যোগ করবে। সাইকেল থাকলে Fast ও Slow এর মিলন ঘটবে!", highlight: true),
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
          Text(desc, style: TextStyle(color: AppTheme.textSecondary, fontSize: Responsive.sp(context, 12), height: 1.4)),
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
