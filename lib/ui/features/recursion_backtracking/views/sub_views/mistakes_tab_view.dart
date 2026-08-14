import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';
import '../../models/recursion_backtracking_data.dart';

class RecursionMistakesTabView extends StatelessWidget {
  final bool isEnglish;

  const RecursionMistakesTabView({super.key, required this.isEnglish});

  @override
  Widget build(BuildContext context) {
    final hPadding = Responsive.horizontalPadding(context);
    final mistakes = RecursionBacktrackingData.getCommonMistakes(isEnglish);

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
            _buildRoadmapStep(1, isEnglish ? "Formulate Clear Base Case" : "সুস্পষ্ট বেস কেস (Base Case) নির্ধারণ", isEnglish ? "Define boundary terminal condition e.g. `if (idx == nums.size())`." : "সীমানা থামার শর্ত নির্ধারণ করুন `if (idx == nums.size())`।"),
            _buildRoadmapStep(2, isEnglish ? "Draw Decision Tree on Paper" : "খাতায় ডিসিশন ট্রি (Decision Tree) আঁকা", isEnglish ? "Visualize choices (Take/Skip or Swap) at each tree level before coding." : "কোডিং করার আগে প্রতিটি নোডের চয়েস খাতায় আঁকুন।"),
            _buildRoadmapStep(3, isEnglish ? "Enforce Symmetric Backtrack (Un-choose)" : "প্রতিটি চয়েসের বিপরীতে সমান ব্যাকট্র্যাক", isEnglish ? "Pair every `push_back()` or state mutation with a matching `pop_back()`." : "প্রতিটি `push_back()` এর বিপরীতে `pop_back()` রাখুন।"),
            _buildRoadmapStep(4, isEnglish ? "Implement Pruning Conditions Early" : "ইনভ্যালিড ব্রাঞ্চ ছাঁটাই (Pruning)", isEnglish ? "Return early when sum > target or grid bounds violated to cut tree depth." : "ইনভ্যালিড পাথে আগেই `return` করে সময় বাঁচান।"),
            _buildRoadmapStep(5, isEnglish ? "Handle Duplicates via Sorting" : "ডুপ্লিকেট ইনপুট হ্যান্ডলিং", isEnglish ? "Sort input and skip repeated elements at same recursive level." : "অ্যারে সর্ট করে একই ডেপথ লেভেলে একই এলিমেন্ট স্কিপ করুন।"),
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
