import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';
import '../../models/monotonic_stack_data.dart';

class MonotonicMistakesTabView extends StatelessWidget {
  final bool isEnglish;

  const MonotonicMistakesTabView({super.key, required this.isEnglish});

  @override
  Widget build(BuildContext context) {
    final hPadding = Responsive.horizontalPadding(context);
    final mistakes = MonotonicStackData.getCommonMistakes(isEnglish);

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
            _buildRoadmapStep(1, isEnglish ? "Store Indices, Not Array Values" : "স্ট্যাকে ভ্যালুর বদলে ইনডেক্স রাখা", isEnglish ? "Always push array indices to stack so distance `i - st.top()` can be derived." : "দূরত্ব `i - st.top()` মাপতে সর্বদাই ইনডেক্স পুশ করুন।"),
            _buildRoadmapStep(2, isEnglish ? "Choose Decreasing vs Increasing Type" : "Decreasing বনাম Increasing সর্টিং বাছাই", isEnglish ? "Use Decreasing Stack for Next Greater, Increasing Stack for Next Smaller." : "Next Greater এর জন্য Decreasing এবং Next Smaller এর জন্য Increasing স্ট্যাক বাছাই করুন।"),
            _buildRoadmapStep(3, isEnglish ? "Process Array in Single O(N) Pass" : "একবার O(N) পাসে পপ অ্যালগরিদম", isEnglish ? "Pop stack elements while condition `nums[i] > nums[st.top()]` holds." : "`nums[i] > nums[st.top()]` শর্তে লুপ চালিয়ে পপ করুন।"),
            _buildRoadmapStep(4, isEnglish ? "Master Histogram Left & Right Boundaries" : "হিস্টোগ্রামের বাম ও ডানের সীমানা হিসেব", isEnglish ? "Calculate width `w = st.empty() ? i : i - st.top() - 1` carefully." : "প্রস্থের জন্য `w = st.empty() ? i : i - st.top() - 1` সূত্র ব্যবহার করুন।"),
            _buildRoadmapStep(5, isEnglish ? "Handle Circular Array (2 * N Loop)" : "সার্কুলার এরে হ্যান্ডলিং (2 * N লুপ)", isEnglish ? "Loop from `0` to `2*N - 1` using index `i % N` for circular next greater." : "সার্কুলার মান অনুসন্ধানে `0..2*N-1` লুপ চালিয়ে `i % N` ব্যবহার করুন।"),
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
