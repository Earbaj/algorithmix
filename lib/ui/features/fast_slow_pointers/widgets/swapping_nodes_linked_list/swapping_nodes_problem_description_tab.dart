import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';

class SwappingNodesProblemDescriptionTab extends StatelessWidget {
  final bool isEnglish;

  const SwappingNodesProblemDescriptionTab({
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
                    color: AppTheme.accentAmber.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppTheme.accentAmber),
                  ),
                  child: Text('🟡 Medium', style: TextStyle(color: AppTheme.accentAmber, fontWeight: FontWeight.bold, fontSize: Responsive.sp(context, 12))),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.accentPurple.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppTheme.accentPurple),
                  ),
                  child: Text('LeetCode #1721', style: TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: Responsive.sp(context, 12))),
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
              isEnglish ? 'Swapping Nodes in a Linked List' : 'লিঙ্কড লিস্টের নোড সওয়াপ (Swapping Nodes in a Linked List)',
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
                        ? 'Given the head of a linked list and an integer k, swap the values of the k-th node from the beginning and the k-th node from the end (the list is 1-indexed).\n\nRequirement: Solve in O(N) time complexity and O(1) auxiliary space.'
                        : 'একটি লিঙ্কড লিস্টের "head" এবং সংখ্যা "k" দেওয়া আছে। শুরুর দিক থেকে k-তম নোড এবং শেষ দিক থেকে k-তম নোডের মান দুটি অদলবদল (swap) করুন।\n\nশর্ত: O(N) সময় এবং O(1) মেমোরি স্পেসে সমাধান করুন।',
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
              "head = [1, 2, 3, 4, 5], k = 2",
              "Output: [1, 4, 3, 2, 5]",
              isEnglish ? "Explanation: 2nd node from start is 2, 2nd node from end is 4. Swapping their values gives [1, 4, 3, 2, 5]." : "ব্যাখ্যা: শুরুর ২য় নোড ২ এবং শেষের ২য় নোড ৪। এদের মান সওয়াপ করলে [১, ৪, ৩, ২, ৫] পাওয়া যায়।",
            ),
            _buildExampleCard(
              context,
              "Example 2",
              "head = [7, 9, 6, 6, 7, 8, 3, 0, 9, 5], k = 5",
              "Output: [7, 9, 6, 6, 8, 7, 3, 0, 9, 5]",
              isEnglish ? "Explanation: 5th node from start is 7, 5th node from end is 8. Swapping their values gives result." : "ব্যাখ্যা: শুরুর ৫ম নোড ৭ এবং শেষের ৫ম নোড ৮। মান সওয়াপ করা হলো।",
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
                      Text(isEnglish ? '🧠 Two-Pointer One-Pass Strategy' : '🧠 টু-পয়েন্টার ওয়ান-পাস স্ট্র্যাটেজি', style: TextStyle(fontSize: Responsive.sp(context, 16), fontWeight: FontWeight.bold, color: Colors.white)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildIntuitionRow(context, "1️⃣ Find k-th Node from Start", isEnglish ? "Traverse k-1 steps from head to reach first node (k-th node from start)." : "head থেকে k-1 ধাপ সামনে গিয়ে ১ম নোড (first) চিহ্নিত করা।"),
                  _buildIntuitionRow(context, "2️⃣ Find k-th Node from End", isEnglish ? "Set curr = first, second = head. Advance both together until curr reaches end! Now second is at k-th node from end." : "curr = first ও second = head করে দুটোকেই একসাথে সামনে বাড়ানো যতক্ষণ না curr শেষ নোডে পৌঁছায়!"),
                  _buildIntuitionRow(context, "3️⃣ Swap Values In-Place", isEnglish ? "Swap values: swap(first.val, second.val). Done in O(N) time and O(1) space!" : "first ও second এর মান অদলবদল করুন! O(N) সময় ও O(1) স্পেসে ইমপ্লিমেন্ট করা হলো!", highlight: true),
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
