import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';
import '../../models/cyclic_sort_data.dart';

class CyclicSortMistakesTabView extends StatelessWidget {
  final bool isEnglish;

  const CyclicSortMistakesTabView({super.key, required this.isEnglish});

  @override
  Widget build(BuildContext context) {
    final hPadding = Responsive.horizontalPadding(context);
    final mistakes = CyclicSortData.getCommonMistakes(isEnglish);

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
            _buildRoadmapStep(1, isEnglish ? "Master While Loop Mechanics (No Forced i++)" : "While লুপ মেকানিক্স (জোরপূর্বক i++ না দেওয়া)", isEnglish ? "Understand why elements stay at i until correct swap." : "সোয়াপ সম্পন্ন হওয়া পর্যন্ত i ধরে রাখার কারণ বুঝুন।"),
            _buildRoadmapStep(2, isEnglish ? "Master 1 to N vs 0 to N Index Mapping" : "১ থেকে N বনাম ০ থেকে N ইনডেক্স ম্যাপিং", isEnglish ? "Use val - 1 for 1..N and val for 0..N mapping." : "সঠিক ইনডেক্স স্থান নির্বাচন আয়ত্ত করুন।"),
            _buildRoadmapStep(3, isEnglish ? "Master Duplicate & Missing Number Scans" : "ডুপ্লিকেট ও মিসিং নম্বর স্ক্যানিং", isEnglish ? "Find nums[i] != i + 1 mismatches in single pass." : "এক পাসে অমিল খুঁজে মিসিং ও ডুপ্লিকেট বের করুন।"),
            _buildRoadmapStep(4, isEnglish ? "Master First Missing Positive Boundary Filtering" : "First Missing Positive বাউন্ডারি ফিল্টারিং", isEnglish ? "Filter elements <= 0 and > N to avoid out-of-bounds crashes." : "ইনভ্যালিড মান এড়িয়ে চলার নিয়ম শিখুন।"),
            _buildRoadmapStep(5, isEnglish ? "Master Cyclic Graph Component Swapping" : "সাইক্লিক গ্রাফ কম্পোনেন্ট সোয়াপিং", isEnglish ? "Solve Couples Holding Hands and minimum swap problems." : "সর্বনিম্ন সোয়াপ প্রবলেম আয়ত্ত করুন।"),
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
