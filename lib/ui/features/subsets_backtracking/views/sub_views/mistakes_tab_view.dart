import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';
import '../../models/subsets_backtracking_data.dart';

class SubsetsMistakesTabView extends StatelessWidget {
  final bool isEnglish;

  const SubsetsMistakesTabView({super.key, required this.isEnglish});

  @override
  Widget build(BuildContext context) {
    final hPadding = Responsive.horizontalPadding(context);
    final mistakes = SubsetsBacktrackingData.getCommonMistakes(isEnglish);

    return ResponsiveCenter(
      padding: EdgeInsets.all(hPadding),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isEnglish ? "⚠️ Top 5 Common Mistakes" : "⚠️ ৫টি সাধারণ ভুল (যা এড়িয়ে চলবেন)",
              style: TextStyle(fontSize: Responsive.sp(context, 18), fontWeight: FontWeight.bold, color: AppTheme.accentPink),
            ),
            const SizedBox(height: 12),
            ...mistakes.map((m) {
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceDark,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppTheme.accentPink.withOpacity(0.4)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(m["title"]!, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 14)),
                    const SizedBox(height: 4),
                    Text(m["desc"]!, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12, height: 1.4)),
                  ],
                ),
              );
            }).toList(),
            const SizedBox(height: 24),

            // 5-Step Roadmap
            Text(
              isEnglish ? "🚀 5-Step Master Roadmap" : "🚀 ৫-ধাপের মাস্টার রোডম্যাপ",
              style: TextStyle(fontSize: Responsive.sp(context, 18), fontWeight: FontWeight.bold, color: AppTheme.accentGreen),
            ),
            const SizedBox(height: 12),
            _buildRoadmapStep(1, isEnglish ? "Master the 3-Step Backtracking Template" : "৩-ধাপের ব্যাকট্র্যাকিং টেমপ্লেট মাস্টার করা", isEnglish ? "Make choice -> Recurse -> Undo choice (pop_back())." : "চয়েস গ্রহণ -> রিকার্স -> চয়েস বাতিল (pop_back())।"),
            _buildRoadmapStep(2, isEnglish ? "Master Subsets & Power Set Generation (O(2^N))" : "পাওয়ার সেট ও সাবসেট তৈরি", isEnglish ? "Generate all 2^N subsets recursively by index incrementing." : "রিকার্সিভলি ২^N সাবসেট জেনারেট করুন।"),
            _buildRoadmapStep(3, isEnglish ? "Master Permutations with Visited Array (O(N!))" : "পারমুটেশন ও ভিজিটেড ট্র্যাকিং", isEnglish ? "Track selected elements with boolean visited array." : "ভিজিটেড এরে দিয়ে পারমুটেশন তৈরি করুন।"),
            _buildRoadmapStep(4, isEnglish ? "Master Sorting & Skipping Duplicates" : "ইনপুট সর্টিং ও ডুপ্লিকেট স্কিপিং", isEnglish ? "Sort array and skip (if i > start && nums[i] == nums[i-1])." : "সর্ট করে পাশাপাশি ডুপ্লিকেট স্কিপ করুন।"),
            _buildRoadmapStep(5, isEnglish ? "Master Pruning & Constraint Satisfaction (N-Queens)" : "প্রুনিং ও কনস্ট্রেইন্ট স্যাটিসফ্যাকশন", isEnglish ? "Prune invalid recursive paths early when target < 0 or conflict occurs." : "শর্ত অমান্য হলে শুরুতেই রিকার্সিভ পথ বাতিল করুন।"),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildRoadmapStep(int stepNum, String title, String desc) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.accentGreen.withOpacity(0.4)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 14,
            backgroundColor: AppTheme.accentGreen,
            child: Text("$stepNum", style: const TextStyle(color: AppTheme.primaryDark, fontWeight: FontWeight.bold, fontSize: 12)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 14)),
                const SizedBox(height: 4),
                Text(desc, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
