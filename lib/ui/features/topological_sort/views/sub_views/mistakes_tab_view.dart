import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';
import '../../models/topological_sort_data.dart';

class TopologicalMistakesTabView extends StatelessWidget {
  final bool isEnglish;

  const TopologicalMistakesTabView({super.key, required this.isEnglish});

  @override
  Widget build(BuildContext context) {
    final hPadding = Responsive.horizontalPadding(context);
    final mistakes = TopologicalSortData.getCommonMistakes(isEnglish);

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
            _buildRoadmapStep(1, isEnglish ? "Verify Directed Acyclic Graph (DAG)" : "গ্রাফে সাইকেল নেই (DAG) তা নিশ্চিত করা", isEnglish ? "Ensure topological sort is only applied on directed graphs without cycles." : "নিশ্চিত করুন গ্রাফটি ডিরেক্টেড ও সাইকেলমুক্ত।"),
            _buildRoadmapStep(2, isEnglish ? "Compute In-Degrees Accurately" : "ইন-ডিগ্রি (In-Degree) সঠিক মেপে ইনিশিয়ালাইজেশন", isEnglish ? "Edge `u -> v` means `inDegree[v]++`. Push all `inDegree == 0` nodes to Queue." : "এজ `u -> v` হলে `inDegree[v]++` করুন। ০ ইন-ডিগ্রির সব নোড ক্যু-তে দিন।"),
            _buildRoadmapStep(3, isEnglish ? "Master Kahn's BFS Algorithm Queue Loop" : "Kahn's BFS অ্যালগরিদম ক্যু লুপ", isEnglish ? "Pop node u, append to result order, decrement neighbor inDegrees, push when 0." : "নোড পপ করে প্রতিবেশীর ইন-ডিগ্রি ১ কমান এবং ০ হলে ক্যু-তে যোগ করুন।"),
            _buildRoadmapStep(4, isEnglish ? "Check Cycle Condition via Result Size" : "রেজাল্ট সাইজ দিয়ে সাইকেল ডিটেকশন", isEnglish ? "If `result.size() < V`, a cycle exists (return empty array or false)." : "`result.size() < V` হলে গ্রাফে সাইকেল রয়েছে (ফাঁকা এরে ফেরান)।"),
            _buildRoadmapStep(5, isEnglish ? "Master Alien Alphabet Graph Construction" : "অ্যালিয়েন ডিকশনারি ও লেক্সিকোগ্রাফিকাল সর্ট", isEnglish ? "Compare adjacent words character by character to construct directed DAG." : "পরপর শব্দের ক্যারেক্টার মেপে ডিরেক্টেড গ্রাফ তৈরি করুন।"),
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
