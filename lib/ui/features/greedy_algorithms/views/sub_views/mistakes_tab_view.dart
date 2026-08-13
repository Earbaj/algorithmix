import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';
import '../../models/greedy_algorithm_data.dart';

class GreedyMistakesTabView extends StatelessWidget {
  final bool isEnglish;

  const GreedyMistakesTabView({super.key, required this.isEnglish});

  @override
  Widget build(BuildContext context) {
    final hPadding = Responsive.horizontalPadding(context);
    final mistakes = GreedyAlgorithmData.getCommonMistakes(isEnglish);

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
            _buildRoadmapStep(1, isEnglish ? "Verify Greedy Choice Property" : "গ্রিডি চয়েস প্রপার্টি সত্য কিনা প্রমাণ করা", isEnglish ? "Ensure locally optimal choice guarantees globally optimal solution (avoid DP pitfalls)." : "নিশ্চিত করুন স্থানীয় লাভজনক চয়েস বৈশ্বিক সেরা ফল আনে।"),
            _buildRoadmapStep(2, isEnglish ? "Master Farthest Reach Tracking" : "সর্বোচ্চ দূরত্বের রিচ ট্র্যাকিং", isEnglish ? "Track maxReach = max(maxReach, i + nums[i]) for Jump Game." : "জাম্প গেম প্রবলেমে `maxReach` আপডেট করুন।"),
            _buildRoadmapStep(3, isEnglish ? "Master Interval End Time Sorting" : "ইনটারভাল শেষ সময় (End Time) সর্টিং", isEnglish ? "Always sort intervals by finish end time for Non-overlapping scheduling." : "ইনটারভাল শেষ সময় দিয়ে সর্ট করে ওভারল্যাপ ট্র্যাকিং।"),
            _buildRoadmapStep(4, isEnglish ? "Master Circular Resource Gas Accumulation" : "সার্কুলার ট্রিপ ও গ্যাস স্টেশন ট্র্যাকিং", isEnglish ? "Track totalGas vs totalCost and reset startStation when tank becomes negative." : "`currentTank < 0` হলে পরবর্তী স্টেশনকে নতুন সূচনা ধরুন।"),
            _buildRoadmapStep(5, isEnglish ? "Master Two-Pass Left/Right Neighbor Pass" : "দুই-পাস (Left-Right Pass) ক্যান্ডি প্রবলেম", isEnglish ? "Pass left-to-right, then right-to-left to solve neighbor constraints (Candy LeetCode 135)." : "দুই ধাপে বাম-ডান এবং ডান-বাম পাস দিয়ে প্রতিবেশী শর্ত মেটান।"),
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
