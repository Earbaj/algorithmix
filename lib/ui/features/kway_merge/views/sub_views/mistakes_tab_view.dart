import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';
import '../../models/kway_merge_data.dart';

class KWayMergeMistakesTabView extends StatelessWidget {
  final bool isEnglish;

  const KWayMergeMistakesTabView({super.key, required this.isEnglish});

  @override
  Widget build(BuildContext context) {
    final hPadding = Responsive.horizontalPadding(context);
    final mistakes = KWayMergeData.getCommonMistakes(isEnglish);

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
            _buildRoadmapStep(1, isEnglish ? "Master 2-Way Merge Foundation" : "২-Way মার্জ ভিত্তি শক্ত করা", isEnglish ? "Understand 2-pointer merging on sorted arrays and linked lists." : "সর্টেড অ্যারে বা লিঙ্কড লিস্টে ২-পয়েন্টার মার্জ আয়ত্ত করুন।"),
            _buildRoadmapStep(2, isEnglish ? "Master Min-Heap Bounded Size K Strategy" : "Min-Heap এর সাইজ K তে সীমাবদ্ধ রাখা", isEnglish ? "Keep heap size <= K by pushing only the 1st elements of K streams." : "লিস্টের প্রথম নোড পুশ করে হিপের সাইজ K তে রাখুন।"),
            _buildRoadmapStep(3, isEnglish ? "Master C++ Priority Queue Custom Comparator" : "C++ Priority Queue কাস্টম কম্পারেটর", isEnglish ? "Write functor `bool operator()(ListNode* a, ListNode* b)` to sort min node on top." : "কাস্টম ফানক্টর দিয়ে Min-Heap প্রপার্টি নিশ্চিত করুন।"),
            _buildRoadmapStep(4, isEnglish ? "Master Next-Pointer Invariant" : "পরবর্তী পয়েন্টার নোড পুশ ইনভেরিয়েন্ট", isEnglish ? "Upon popping top node, immediately check `if (top->next) minHeap.push(top->next)`." : "টপ পপ হওয়ার পরপরই `top->next` হিপে যোগ করুন।"),
            _buildRoadmapStep(5, isEnglish ? "Master Matrix 2D to 1D Tuple Heap Search" : "ম্যাট্রিক্সের কলাম অনুযায়ী K-Way হিপ সার্চ", isEnglish ? "Store `<val, row, col>` tuples to traverse sorted matrix boundaries." : "`<val, row, col>` ট্রিপল দিয়ে সর্টেড ম্যাট্রিক্স ফিল্টার করুন।"),
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
