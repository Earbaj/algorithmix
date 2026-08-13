import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';
import '../../models/top_k_elements_data.dart';

class TopKElementsMistakesTabView extends StatelessWidget {
  final bool isEnglish;

  const TopKElementsMistakesTabView({super.key, required this.isEnglish});

  @override
  Widget build(BuildContext context) {
    final hPadding = Responsive.horizontalPadding(context);
    final mistakes = TopKElementsData.getCommonMistakes(isEnglish);

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
            _buildRoadmapStep(1, isEnglish ? "Master Heap Selection Strategy" : "হিপ টাইপ বেছে নেওয়া", isEnglish ? "Use Min-Heap of size K for K largest; Max-Heap of size K for K smallest." : "K-তম বড় সংখ্যার জন্য K সাইজের Min-Heap এবং ছোট সংখ্যার জন্য Max-Heap।"),
            _buildRoadmapStep(2, isEnglish ? "Master C++ Priority Queue Syntax" : "C++ Priority Queue এর সঠিক সিনট্যাক্স", isEnglish ? "Use priority_queue<int, vector<int>, greater<int>> for Min-Heap." : "Min-Heap এর জন্য `greater<int>` ব্যবহার করুন।"),
            _buildRoadmapStep(3, isEnglish ? "Master Pair Ordering (Frequency, Val)" : "ফ্রিকোয়েন্সি পেয়ারের সঠিক অর্ডার", isEnglish ? "Always push pair<int, int> as {frequency, val} so heap sorts by count automatically." : "হিপে পেয়ার রাখার সময় `{frequency, val}` ফরম্যাটে রাখুন।"),
            _buildRoadmapStep(4, isEnglish ? "Master Push-then-Pop Bounded Heap Size" : "পুশ করে সাইজ চেক ও পপ কৌশল", isEnglish ? "Push element first, then if heap.size() > K, pop root to keep size bounded at K." : "আগে `push()` করে তারপর `size() > K` হলে `pop()` করুন।"),
            _buildRoadmapStep(5, isEnglish ? "Master Two-Heap Pattern (Median Streaming)" : "টু-হিপস (Two-Heaps) স্লাইডিং মিডিয়ান ট্র্যাকিং", isEnglish ? "Combine Max-Heap (left half) & Min-Heap (right half) for streaming medians." : "স্ট্রিমিং ডেটার মিডিয়ান পেতে Max-Heap ও Min-Heap একসাথে ব্যালেন্স করুন।"),
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
