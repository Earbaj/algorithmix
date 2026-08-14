import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';
import '../../models/two_pointers_data.dart';

class TwoPointersMistakesTabView extends StatelessWidget {
  final bool isEnglish;

  const TwoPointersMistakesTabView({super.key, required this.isEnglish});

  @override
  Widget build(BuildContext context) {
    final hPadding = Responsive.horizontalPadding(context);
    final mistakes = TwoPointersData.getCommonMistakes(isEnglish);

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
            _buildRoadmapStep(1, isEnglish ? "Ensure Array Sorting Condition" : "অ্যারে সর্ট বা অর্ডার নিশ্চিতকরণ", isEnglish ? "Sort array `sort(nums.begin(), nums.end())` for sum/target search patterns." : "টার্গেট সামের ক্ষেত্রে `sort()` নিশ্চিত করুন।"),
            _buildRoadmapStep(2, isEnglish ? "Set Left & Right Pointer Bounds" : "লেফট ও রাইট পয়েন্টার বাউন্ড সেট করা", isEnglish ? "Initialize `left = 0` and `right = n - 1` with while condition `left < right`." : "`left = 0` ও `right = n - 1` এবং লুপের জন্য `left < right` ব্যবহার করুন।"),
            _buildRoadmapStep(3, isEnglish ? "Handle Duplicates Aggressively" : "ডুপ্লিকেট এলিমেন্ট স্কিপিং", isEnglish ? "In 3Sum or 4Sum, skip duplicate adjacent values for fixed & two pointers." : "3Sum/4Sum এর ক্ষেত্রে ডুপ্লিকেট মান স্কিপ করুন।"),
            _buildRoadmapStep(4, isEnglish ? "Master Slow & Fast Pointer Strategy" : "স্লো ও ফাস্ট পয়েন্টার টেকনিক", isEnglish ? "Use slow pointer for valid placement and fast pointer for array scanning." : "ইন-প্লেস অ্যারে মডিফিকেশনে স্লো ও ফাস্ট পয়েন্টার ব্যবহার করুন।"),
            _buildRoadmapStep(5, isEnglish ? "Master Container & Trapping Water Boundaries" : "কন্টেইনার ও ট্র্যাপিং ওয়াটার পয়েন্টার", isEnglish ? "Always shrink pointer pointing to lower height element to maximize area/water." : "কম উচ্চতার দেওয়াল পয়েন্টার সরান যাতে এলাকা বা পানি বাড়ানো যায়।"),
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
