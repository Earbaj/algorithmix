import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';

class RemoveDuplicatesProblemDescriptionTab extends StatelessWidget {
  final bool isEnglish;

  const RemoveDuplicatesProblemDescriptionTab({
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
              spacing: 4,
              runSpacing: 4,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.accentGreen.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppTheme.accentGreen),
                  ),
                  child: Text('Easy', style: TextStyle(color: AppTheme.accentGreen, fontWeight: FontWeight.bold, fontSize: Responsive.sp(context, 12))),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.accentPurple.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppTheme.accentPurple),
                  ),
                  child: Text('LeetCode #83', style: TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: Responsive.sp(context, 12))),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.accentPink.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppTheme.accentPink),
                  ),
                  child: Text('FAANG Top Pick', style: TextStyle(color: AppTheme.accentPink, fontWeight: FontWeight.bold, fontSize: Responsive.sp(context, 12))),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              isEnglish ? 'Remove Duplicates from Sorted List' : 'সর্টেড লিস্ট থেকে ডুপ্লিকেট রিমুভ (Remove Duplicates from Sorted List)',
              style: TextStyle(fontSize: Responsive.sp(context, 22), fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(isEnglish ? 'Problem Statement' : 'সমস্যার বিবরণ', style: TextStyle(fontSize: Responsive.sp(context, 16), fontWeight: FontWeight.bold, color: AppTheme.accentNeonCyan)),
                const SizedBox(height: 10),
                Text(
                  isEnglish
                      ? 'Given the head of a sorted linked list, delete all duplicates such that each element appears only once. Return the linked list sorted as well.\n\nRequirement: Solve in O(N) time complexity and O(1) auxiliary space.'
                      : 'একটি সর্টেড লিঙ্কড লিস্টের "head" দেওয়া আছে। সকল ডুপ্লিকেট নোড মুছে ফেলুন যাতে প্রতিটি উপাদান কেবল একবার উপস্থিত থাকে। ফিল্টার করা লিঙ্কড লিস্টটি সর্টেড অবস্থায় রিটার্ন করুন।\n\nশর্ত: O(N) সময় এবং O(1) মেমোরি স্পেসে সমাধান করুন।',
                  style: TextStyle(fontSize: Responsive.sp(context, 14), color: AppTheme.textPrimary, height: 1.5),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(isEnglish ? 'Example Cases' : 'উদাহরণসমূহ', style: TextStyle(fontSize: Responsive.sp(context, 18), fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 12),
            _buildExampleCard(
              context,
              "Example 1",
              "head = [1, 1, 2]",
              "Output: [1, 2]",
              isEnglish ? "Explanation: Node 1 is duplicated. Second 1 is bypassed." : "ব্যাখ্যা: নোড ১ ডুপ্লিকেট। ২য় ১ নোডটি স্কিপ করা হয়েছে।",
            ),
            _buildExampleCard(
              context,
              "Example 2",
              "head = [1, 1, 2, 3, 3]",
              "Output: [1, 2, 3]",
              isEnglish ? "Explanation: Duplicates 1 and 3 are removed, leaving unique elements [1, 2, 3]." : "ব্যাখ্যা: ডুপ্লিকেট ১ এবং ৩ রিমুভ করা হয়েছে, ফলে ইউনিক এলিমেন্ট [১, ২, ৩] থাকবে।",
            ),
            const SizedBox(height: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(isEnglish ? 'Pointer Bypass Intuition' : 'পয়েন্টার বাইপাস লজিক', style: TextStyle(fontSize: Responsive.sp(context, 16), fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 12),
                _buildIntuitionRow(context, "Extra Array/HashSet O(N) Space", isEnglish ? "Copy unique values into a new list. Works, but uses O(N) auxiliary space." : "ইউনিক মানগুলো নতুন অ্যারেলিস্টে রাখা। O(N) অতিরিক্ত মেমোরি লাগে।"),
                _buildIntuitionRow(context, "In-Place Pointer Bypass O(1) Space", isEnglish ? "Compare curr.val == curr.next.val. If true, bypass next node via curr.next = curr.next.next. Otherwise advance curr = curr.next. Done in 1 pass with O(1) space!" : "curr.val == curr.next.val হলে পয়েন্টার বাইপাস করুন (curr.next = curr.next.next)। অন্যথায় curr ১ ধাপ সামনে বাড়ান। O(1) স্পেসে ১ পাসে শেষ!", highlight: true),
              ],
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
      child: Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: highlight ? AppTheme.accentGreen : Colors.white, fontSize: Responsive.sp(context, 13))),
            const SizedBox(height: 2),
            Text(desc, style: TextStyle(color: AppTheme.textSecondary, fontSize: Responsive.sp(context, 12), height: 1.3)),
          ],
        ),
      ),
    );
  }
}
