import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';
import '../../models/dp_data.dart';

class DPMistakesTabView extends StatelessWidget {
  final bool isEnglish;

  const DPMistakesTabView({super.key, required this.isEnglish});

  @override
  Widget build(BuildContext context) {
    final hPadding = Responsive.horizontalPadding(context);
    final mistakes = DPData.getCommonMistakes(isEnglish);

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
            _buildRoadmapStep(1, isEnglish ? "Define State Representation" : "স্টেট সংজ্ঞায়িত করা (`dp[i]` বা `dp[i][j]`)", isEnglish ? "Explicitly define what `dp[i]` represents in plain words before writing code." : "কোড লেখার আগে `dp[i]` বা `dp[i][j]` এর অর্থ পরিষ্কার করুন।"),
            _buildRoadmapStep(2, isEnglish ? "Derive State Transition Relation" : "স্টেট ট্রানজিশন সমীকরণ গঠন", isEnglish ? "Determine subproblem dependency equation (e.g. `dp[i] = max(dp[i-1], dp[i-2] + nums[i])`)." : "পূর্ববর্তী সাবপ্রবলেমের সাপেক্ষে সমীকরণ তৈরি করুন।"),
            _buildRoadmapStep(3, isEnglish ? "Identify Base Cases & Boundaries" : "বেস কেস ও সীমানা নির্ধারণ", isEnglish ? "Carefully set base cases like `dp[0] = 0` or `dp[0] = 1` and guard against negative indices." : "বেস কেস ঠিক করুন এবং ইনডেক্স বাউন্ডারি ভ্যালিডেট করুন।"),
            _buildRoadmapStep(4, isEnglish ? "Choose Direction & Space Optimization" : "লুপের দিক ও মেমোরি অপটিমাইজেশন", isEnglish ? "Determine Top-Down recursion or Bottom-Up tabulation. Optimize 2D to 1D when applicable." : "১D 0/1 Knapsack এ রিভার্স লুপ দিয়ে স্পেস বাঁচান।"),
            _buildRoadmapStep(5, isEnglish ? "Dry Run Corner Cases" : "কর্নার কেস টেস্ট ও ব্যাকট্র্যাকিং", isEnglish ? "Test empty array, 1-element input, target sum 0, and large values for integer overflow." : "ফাঁকা ইনপুট ও সীমা সংক্রান্ত টেস্ট কেসে ড্রাই রান করুন।"),
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
