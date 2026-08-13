import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';
import '../../models/inplace_reversal_data.dart';

class InplaceReversalMistakesTabView extends StatelessWidget {
  final bool isEnglish;

  const InplaceReversalMistakesTabView({super.key, required this.isEnglish});

  @override
  Widget build(BuildContext context) {
    final hPadding = Responsive.horizontalPadding(context);
    final mistakes = InplaceReversalData.getCommonMistakes(isEnglish);

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
            _buildRoadmapStep(1, isEnglish ? "Master 3-Pointer Link Flipping" : "৩-পয়েন্টার লিঙ্ক উল্টানো কৌশল", isEnglish ? "Always backup nextTemp before breaking curr->next link." : "পয়েন্টার লিঙ্ক পরিবর্তন করার আগেnextTemp ব্যাকআপ নিন।"),
            _buildRoadmapStep(2, isEnglish ? "Master Dummy Head Node Technique" : "ডামি হেড নোড টেকনিক", isEnglish ? "Use Dummy Node to eliminate edge case checks when left = 1." : "প্রথম নোড বদলে যাওয়ার মতো সমস্যার সমাধান ডামি নোড দিয়ে করুন।"),
            _buildRoadmapStep(3, isEnglish ? "Master Sub-list Reconnect Mechanics" : "Sub-list বাউন্ডারি রিকানেক্ট মেকানিক্স", isEnglish ? "Connect leftPrev->next = prev and subTail->next = curr." : "রিভার্স করা লিস্টের ২ পাশের প্রান্ত জোড়া লাগানো আয়ত্ত করুন।"),
            _buildRoadmapStep(4, isEnglish ? "Master Fast-Slow + Half List Reversal" : "Fast-Slow + অর্ধেক লিস্ট রিভার্স", isEnglish ? "Combine middle node finding with in-place reversal for Palindromes." : "প্যালিন্ড্রোম এবং Reorder List এ অর্ধেক লিঙ্কড লিস্ট রিভার্স করুন।"),
            _buildRoadmapStep(5, isEnglish ? "Master K-Group Reversal Recursion" : "K-Group নোড রিকার্সিভ লিঙ্ক", isEnglish ? "Recursively solve Reverse Nodes in k-Group in O(1) space." : "K-Group প্রবলেম রিকার্সিভলি সমাধান করুন।"),
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
