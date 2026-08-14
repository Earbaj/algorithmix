import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';
import '../../models/trie_data.dart';

class TrieMistakesTabView extends StatelessWidget {
  final bool isEnglish;

  const TrieMistakesTabView({super.key, required this.isEnglish});

  @override
  Widget build(BuildContext context) {
    final hPadding = Responsive.horizontalPadding(context);
    final mistakes = TrieData.getCommonMistakes(isEnglish);

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
            _buildRoadmapStep(1, isEnglish ? "Define Standard TrieNode Structure" : "TrieNode স্ট্রাকচার নিখুঁতভাবে তৈরি", isEnglish ? "Maintain `children[26]` array initialized to nullptr and boolean `isEnd`." : "`children[26]` নাল সহ ও `isEnd` ফ্ল্যাগ ডিফাইন করুন।"),
            _buildRoadmapStep(2, isEnglish ? "Master O(L) Insert & StartsWith" : "O(L) ইনসার্ট ও প্রিফিক্স লুকআপ", isEnglish ? "Traverse character by character using `c - 'a'` index math." : "`c - 'a'` হিসেব করে প্রতিটি অক্ষরের চাইল্ড নোডে যান।"),
            _buildRoadmapStep(3, isEnglish ? "Implement DFS Wildcard Backtracking" : "ওয়াইল্ডকার্ড ('.') DFS ব্যাকট্র্যাকিং", isEnglish ? "When encountering '.', recursively check all 26 non-null child nodes." : "'.' অক্ষরের জন্য সব ২৬টি নোডে DFS পরীক্ষা করুন।"),
            _buildRoadmapStep(4, isEnglish ? "Build 31-Bit Binary Trie for XOR" : "৩১-বিট বাইনারি ট্রাই ও ম্যাক্স XOR", isEnglish ? "Store binary bit paths (0/1) and pick opposite bit `1 - bit` greedily." : "সংখ্যার বিট ট্রিতে রেখে গ্রিডি পদ্ধতিতে `1 - bit` নিন।"),
            _buildRoadmapStep(5, isEnglish ? "Prune Branches in Grid Word Search II" : "Word Search II এ ব্রাঞ্চ ছাঁটাই (Pruning)", isEnglish ? "Stop DFS grid search immediately when current prefix doesn't exist in Trie." : "ট্রিতে প্রিফিক্স না থাকলে তখনই DFS থামিয়ে দিন।"),
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
