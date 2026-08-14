import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';
import '../../models/prefix_sum_data.dart';

class PrefixMistakesTabView extends StatelessWidget {
  final bool isEnglish;

  const PrefixMistakesTabView({super.key, required this.isEnglish});

  @override
  Widget build(BuildContext context) {
    final hPadding = Responsive.horizontalPadding(context);
    final mistakes = PrefixSumData.getCommonMistakes(isEnglish);

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
            _buildRoadmapStep(1, isEnglish ? "Initialize Map Base Case `map[0] = 1`" : "ম্যাপে বেস কেস `map[0] = 1` সেট করা", isEnglish ? "Always initialize `prefixMap[0] = 1` before single-pass subarray sum search." : "লুপ শুরুর আগে অবশ্যই `prefixMap[0] = 1` ইনিশিয়ালাইজ করুন।"),
            _buildRoadmapStep(2, isEnglish ? "Use 1-Indexed Prefix Array for 1D Range Sum" : "১-বেসড ১D প্রিফিক্স এরে গঠন", isEnglish ? "Build `prefix[i+1] = prefix[i] + nums[i]` so query is `prefix[R+1] - prefix[L]`." : "`prefix[R+1] - prefix[L]` ফর্মুলায় বাউন্ডারি সেফ রেঞ্জ সাম নিন।"),
            _buildRoadmapStep(3, isEnglish ? "Handle Canonical Modulo in C++" : "C++ এ ক্যানোনিকাল মডুলাস মেথড", isEnglish ? "Calculate `rem = ((currSum % k) + k) % k` to avoid negative remainders." : "ঋণাত্মক ভাগশেষ এড়াতে `((currSum % k) + k) % k` ব্যবহার করুন।"),
            _buildRoadmapStep(4, isEnglish ? "Master 2D Prefix Sum Formula" : "২D ম্যাট্রিক্স প্রিফিক্স সাম ফর্মুলা", isEnglish ? "Use inclusion-exclusion `P[r2][c2] - P[r1-1][c2] - P[r2][c1-1] + P[r1-1][c1-1]`." : "ইনক্লুশন-এক্সক্লুশন ২D প্রিফিক্স সাম ফর্মুলা ব্যবহার করুন।"),
            _buildRoadmapStep(5, isEnglish ? "Master Difference Array Technique" : "ডিফারেন্স এরে দিয়ে রেঞ্জ আপডেট", isEnglish ? "For range `[l, r]` add `v`, do `diff[l] += v` and `diff[r+1] -= v` then prefix sum." : "রেঞ্জ আপডেটে `diff[l] += v` ও `diff[r+1] -= v` দিয়ে প্রিফিক্স সাম নিন।"),
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
