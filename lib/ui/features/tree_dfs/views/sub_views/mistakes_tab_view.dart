import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';
import '../../models/tree_dfs_data.dart';

class TreeDfsMistakesTabView extends StatelessWidget {
  final bool isEnglish;

  const TreeDfsMistakesTabView({super.key, required this.isEnglish});

  @override
  Widget build(BuildContext context) {
    final hPadding = Responsive.horizontalPadding(context);
    final mistakes = TreeDfsData.getCommonMistakes(isEnglish);

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
            _buildRoadmapStep(1, isEnglish ? "Master Base Case Null Protection" : "বেস কেসে নাল পয়েন্টার প্রোটেকশন", isEnglish ? "Always start recursive calls with if (!root) return baseValue;." : "রিকার্সিভ কলের শুরুতে নাল চেক নিশ্চিত করুন।"),
            _buildRoadmapStep(2, isEnglish ? "Master Inorder Traversal for BSTs" : "BST এর জন্য Inorder ট্রাভার্সাল", isEnglish ? "Use Left -> Root -> Right to get sorted values in BSTs." : "BST এর সর্টেড মান পেতে Inorder ব্যবহার করুন।"),
            _buildRoadmapStep(3, isEnglish ? "Master Bottom-Up Subtree Calculation" : "নিচ থেকে উপরে (Bottom-Up) সাব-ট্রি গণনা", isEnglish ? "Return left & right subtree values to calculate parent properties." : "সাব-ট্রি থেকে প্রাপ্ত মান রুটে জোড়া লাগান।"),
            _buildRoadmapStep(4, isEnglish ? "Master Path Backtracking Mechanics" : "পাথ ভেক্টর ব্যাকট্র্যাকিং মেকানিক্স", isEnglish ? "Pop element after returning from child branch (path.pop_back())." : "চাইল্ড ব্রাঞ্চ শেষে `path.pop_back()` নিশ্চিত করুন।"),
            _buildRoadmapStep(5, isEnglish ? "Master Max Path Sum & LCA Dynamic DFS" : "Max Path Sum ও LCA ডাইনামিক DFS", isEnglish ? "Combine local max calculation with returned single-branch max." : "গ্লোবাল ম্যাক্স ও একক ব্রাঞ্চ রিটার্ন মেলানো শিখুন।"),
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
