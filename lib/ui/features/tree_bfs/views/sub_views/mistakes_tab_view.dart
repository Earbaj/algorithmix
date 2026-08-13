import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';
import '../../models/tree_bfs_data.dart';

class TreeBfsMistakesTabView extends StatelessWidget {
  final bool isEnglish;

  const TreeBfsMistakesTabView({super.key, required this.isEnglish});

  @override
  Widget build(BuildContext context) {
    final hPadding = Responsive.horizontalPadding(context);
    final mistakes = TreeBfsData.getCommonMistakes(isEnglish);

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
            _buildRoadmapStep(1, isEnglish ? "Master Queue Level Size Snapshotting" : "ক্যু লেভেল সাইজ স্ন্যাপশট নেওয়া", isEnglish ? "Always store levelSize = q.size() before processing inner level loop." : "ইনোভাল লুপের আগে levelSize স্ন্যাপশট নিশ্চিত করুন।"),
            _buildRoadmapStep(2, isEnglish ? "Master Null Child Filtering" : "নাল চাইল্ড ফিল্টারিং", isEnglish ? "Only push valid left and right children to avoid queue crashes." : "কেবল বৈধ চিলড্রেন ক্যু তে পুশ করুন।"),
            _buildRoadmapStep(3, isEnglish ? "Master Level Aggregations (Average, Min Depth)" : "লেভেল এগ্রিগেশন (গড়, সর্বনিম্ন গভীরতা)", isEnglish ? "Perform level calculations or early leaf node returns effortlessly." : "প্রতি লেভেলে গড় বের করা ও ১ম লিফ নোডে রিটার্ন শেখা।"),
            _buildRoadmapStep(4, isEnglish ? "Master Zigzag Direction Switching" : "জিগজ্যাগ ডিরেকশন সুইচিং", isEnglish ? "Invert boolean direction flag only after finishing level loop." : "লেভেল শেষে ফ্ল্যাগ উল্টে জিগজ্যাগ ভেক্টর তৈরি করুন।"),
            _buildRoadmapStep(5, isEnglish ? "Master Graph BFS Adaptation (All Nodes K Distance)" : "গ্রাফ BFS এ রূপান্তর (K দূরত্বের নোড)", isEnglish ? "Convert Binary Tree to undirected graph to perform BFS from any node." : "প্যারেন্ট পয়েন্টার যোগ করে যেকোনো নোড থেকে BFS চালান।"),
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
