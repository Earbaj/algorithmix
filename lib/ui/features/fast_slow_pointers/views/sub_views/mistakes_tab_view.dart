import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';
import '../../models/fast_slow_pointers_data.dart';

class FastSlowMistakesTabView extends StatelessWidget {
  final bool isEnglish;

  const FastSlowMistakesTabView({super.key, required this.isEnglish});

  @override
  Widget build(BuildContext context) {
    final hPadding = Responsive.horizontalPadding(context);
    final mistakes = FastSlowPointersData.getCommonMistakes(isEnglish);

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
            _buildRoadmapStep(1, isEnglish ? "Master 1-Step vs 2-Step Pointer Mechanics" : "১-ধাপ বনাম ২-ধাপ পয়েন্টার মেকানিক্স আয়ত্তকরণ", isEnglish ? "Understand O(1) space traversal speeds." : "O(1) স্পেসের স্পিড রেসিও বুঝুন।"),
            _buildRoadmapStep(2, isEnglish ? "Master Cycle Detection & Collision Proof" : "সাইকেল ডিটেকশন ও কোলাইশন প্রুফ", isEnglish ? "Detect loop intersection using slow == fast." : "slow == fast দিয়ে ইন্টারসেকশন শনাক্ত করুন।"),
            _buildRoadmapStep(3, isEnglish ? "Master Cycle Entry Node Discovery" : "সাইকেল শুরুর নোড (Cycle Entry Node) নির্ণয়", isEnglish ? "Reset slow = head and advance both pointers 1 step to meet at entry." : "slow=head করে ১ ধাপ করে এগিয়ে শুরুর নোড পান।"),
            _buildRoadmapStep(4, isEnglish ? "Master Single-Pass Middle Node Finding" : "এক পাসে মিডল নোড ও লিস্ট পার্টনিং", isEnglish ? "Find exact middle node to reverse list and check palindromes." : "মিডল নোড দিয়ে লিস্ট রিভার্স ও প্যালিন্ড্রোম চেক করুন।"),
            _buildRoadmapStep(5, isEnglish ? "Master Floyd's Algorithm on Arrays" : "অ্যারেতে ফ্লয়েডের অ্যালগরিদম প্রয়োগ (LeetCode 287)", isEnglish ? "Treat array elements as pointers to solve duplicate number problems." : "অ্যারে উপাদানকে লিঙ্কড পয়েন্টার হিসেবে ব্যবহার করুন।"),
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
