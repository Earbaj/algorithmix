import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';
import '../../models/bit_manipulation_data.dart';

class BitMistakesTabView extends StatelessWidget {
  final bool isEnglish;

  const BitMistakesTabView({super.key, required this.isEnglish});

  @override
  Widget build(BuildContext context) {
    final hPadding = Responsive.horizontalPadding(context);
    final mistakes = BitManipulationData.getCommonMistakes(isEnglish);

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
            _buildRoadmapStep(1, isEnglish ? "Master Bitwise Operator Precedence" : "বিটওয়াইজ অপারেটর প্রিসিডেন্স আয়ত্ত করা", isEnglish ? "Always put parentheses around bitwise expressions e.g. `(n & 1) == 0`." : "বিট এক্সপ্রেশনের চারপাশে সর্বদাই বন্ধনী বা ব্র্যাকেট ব্যবহার করুন।"),
            _buildRoadmapStep(2, isEnglish ? "Master XOR Cancellation Property" : "XOR বাতিল কৌশল আয়ত্তকরণ", isEnglish ? "Remember `A ^ A = 0` and `A ^ 0 = A` for duplicate detection." : "ডুপ্লিকেট বাতিলের জন্য `A ^ A = 0` ও `A ^ 0 = A` মনে রাখুন।"),
            _buildRoadmapStep(3, isEnglish ? "Use Brian Kernighan for Bit Counting" : "১-বিট গণনায় Brian Kernighan ট্রিক", isEnglish ? "Use `n &= (n - 1)` loop to clear 1-bits in O(set bits) time." : "১-বিট দ্রুত মোছার জন্য `n &= (n - 1)` লুপ ব্যবহার করুন।"),
            _buildRoadmapStep(4, isEnglish ? "Check Power of 2 in O(1)" : "১ ধাপে ২ এর পাওয়ার পরীক্ষা", isEnglish ? "Verify power of two using `n > 0 && (n & (n - 1)) == 0`." : "`n > 0 && (n & (n - 1)) == 0` দিয়ে ২ এর পাওয়ার সনাক্ত করুন।"),
            _buildRoadmapStep(5, isEnglish ? "Master Bitmasking for Subsets" : "সাবসেট জেনারেশনে বিটমাস্কিং", isEnglish ? "Iterate mask `0` to `(1 << N) - 1` and check `(mask & (1 << i))`." : "মাস্ক `0..2^N-1` চালিয়ে `(mask & (1 << i))` দিয়ে বিটম্যাপ নিন।"),
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
