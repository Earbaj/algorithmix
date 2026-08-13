import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';
import '../../models/merge_intervals_data.dart';

class MergeIntervalsMistakesTabView extends StatelessWidget {
  final bool isEnglish;

  const MergeIntervalsMistakesTabView({super.key, required this.isEnglish});

  @override
  Widget build(BuildContext context) {
    final hPadding = Responsive.horizontalPadding(context);
    final mistakes = MergeIntervalsData.getCommonMistakes(isEnglish);

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
            _buildRoadmapStep(1, isEnglish ? "Master Start-Time Sorting Rule" : "Start-Time সর্টিং রুল আয়ত্তকরণ", isEnglish ? "Understand why sorting by start time enables linear scanning." : "শুরু দিয়ে সর্ট করার সুবিধা বুঝুন।"),
            _buildRoadmapStep(2, isEnglish ? "Master Overlapping Merging Logic" : "ওভারল্যাপিং মার্জ লজিক", isEnglish ? "Use curr[0] <= last[1] and update last[1] = max(last[1], curr[1])." : "curr[0] <= last[1] ও max() ব্যবহার শিখুন।"),
            _buildRoadmapStep(3, isEnglish ? "Master 3-Phase Insert Interval" : "৩-ধাপের ইনসার্ট ইন্টারভাল প্যাটার্ন", isEnglish ? "Process left non-overlapping, merge middle, add right non-overlapping." : "বাম, মাঝের মার্জ ও ডানের ধাপগুলো আয়ত্ত করুন।"),
            _buildRoadmapStep(4, isEnglish ? "Master Two-Pointer Intersection Logic" : "টু-পয়েন্টার ইন্টারসেকশন লজিক", isEnglish ? "Calculate [max(starts), min(ends)] and advance smaller end pointer." : "[max(starts), min(ends)] ও ছোট এন্ড সরাতে শিখুন।"),
            _buildRoadmapStep(5, isEnglish ? "Master Min-Heap & Sweep-Line Techniques" : "মিন-হিপ ও সুইপ-লাইন টেকনিক", isEnglish ? "Solve Meeting Rooms II and K-booking concurrency problems." : "মিটিং রুম ও সর্বোচ্চ সময় সংঘাত নির্ণয় করুন।"),
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
