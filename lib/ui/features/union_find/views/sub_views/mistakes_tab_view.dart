import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';
import '../../models/union_find_data.dart';

class UnionFindMistakesTabView extends StatelessWidget {
  final bool isEnglish;

  const UnionFindMistakesTabView({super.key, required this.isEnglish});

  @override
  Widget build(BuildContext context) {
    final hPadding = Responsive.horizontalPadding(context);
    final mistakes = UnionFindData.getCommonMistakes(isEnglish);

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
            _buildRoadmapStep(1, isEnglish ? "Write Path Compression in `find(i)`" : "`find(i)` এ পাথ কম্প্রেশন যুক্ত করা", isEnglish ? "Write `parent[i] = find(parent[i])` to guarantee O(α(N)) amortized time." : "`parent[i] = find(parent[i])` লিখে পাথ কম্প্রেশন নিশ্চিত করুন।"),
            _buildRoadmapStep(2, isEnglish ? "Union Roots, Not Raw Nodes" : "সরাসরি নোড নয়, রুটের মধ্যে `unite` ঘটানো", isEnglish ? "Find roots `rootU = find(u)` and `rootV = find(v)` before setting `parent[rootV] = rootU`." : "প্যারেন্ট সেটের আগে অবশ্যই ২ প্রান্তের রুট বের করুন।"),
            _buildRoadmapStep(3, isEnglish ? "Track Dynamic Component Count" : "ডাইনামিক কম্পোনেন্ট কাউন্ট ট্র্যাকিং", isEnglish ? "Initialize `count = N`, and decrement `count--` only when `rootU != rootV`." : "নতুন ২ রুট মার্জ হলে কেবল `count--` করুন।"),
            _buildRoadmapStep(4, isEnglish ? "Master 2D Grid Index Mapping" : "২D গ্রিড ইনডেক্স ১D তে ম্যাপিং", isEnglish ? "Convert 2D cell `(r, c)` to 1D `r * cols + c` for matrix DSU problems." : "ম্যাট্রিক্সের প্রবলেমে `r * C + c` দিয়ে ১D DSU ব্যবহার করুন।"),
            _buildRoadmapStep(5, isEnglish ? "Detect Cycles in Undirected Graphs" : "আনডিরেক্টেড গ্রাফে সাইকেল ডিটেকশন", isEnglish ? "If `unite(u, v)` returns false (`find(u) == find(v)`), a cycle edge is detected!" : "`find(u) == find(v)` হলে সাইকেল ধরা পড়ে।"),
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
