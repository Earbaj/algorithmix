import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';
import '../../models/two_heaps_data.dart';

class TwoHeapsMistakesTabView extends StatelessWidget {
  final bool isEnglish;

  const TwoHeapsMistakesTabView({super.key, required this.isEnglish});

  @override
  Widget build(BuildContext context) {
    final hPadding = Responsive.horizontalPadding(context);
    final mistakes = TwoHeapsData.getCommonMistakes(isEnglish);

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
            _buildRoadmapStep(1, isEnglish ? "Understand Heap Invariants" : "হিপের আকার ও ভারসাম্য বোঝা", isEnglish ? "Ensure size diff between Max-Heap and Min-Heap is never > 1." : "Max-Heap ও Min-Heap এর সাইজ পার্থক্য সর্বোচ্চ ১ রাখুন।"),
            _buildRoadmapStep(2, isEnglish ? "Master C++ Priority Queue Declarations" : "C++ priority_queue ডিক্লারেশন মাস্টার করা", isEnglish ? "Use std::greater<int> for Min-Heap declaration." : "Min-Heap এর জন্য `greater<int>` ফানক্টর ব্যবহার করুন।"),
            _buildRoadmapStep(3, isEnglish ? "Master Double Precision Median Query" : "ডাবল প্রিসিশন মিডিয়ান হিসাব", isEnglish ? "Cast to double before adding tops to prevent integer overflow." : "যোগের আগে `(double)` কাস্টিং করে মিডিয়ান হিসাব করুন।"),
            _buildRoadmapStep(4, isEnglish ? "Master Lazy Erase for Sliding Windows" : "স্লাইডিং উইন্ডোর ল্যাজি রিমুভাল", isEnglish ? "Use hash map or std::multiset for random element deletion." : "হিসাব রাখতে ল্যাজি ডিলিট হ্যাশ ম্যাপ ব্যবহার করুন।"),
            _buildRoadmapStep(5, isEnglish ? "Master IPO Profit & Capital Dual Sorting" : "IPO ক্যাপিটাল ও প্রফিট দুই হিপ ট্র্যাকিং", isEnglish ? "Pop affordable projects to Max-Heap greedily." : "সামর্থ্যের প্রকল্প প্রফিট হিপে রূপান্তর করুন।"),
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
