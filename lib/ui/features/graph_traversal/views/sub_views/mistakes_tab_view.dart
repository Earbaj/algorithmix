import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';
import '../../models/graph_traversal_data.dart';

class GraphMistakesTabView extends StatelessWidget {
  final bool isEnglish;

  const GraphMistakesTabView({super.key, required this.isEnglish});

  @override
  Widget build(BuildContext context) {
    final hPadding = Responsive.horizontalPadding(context);
    final mistakes = GraphTraversalData.getCommonMistakes(isEnglish);

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
            _buildRoadmapStep(1, isEnglish ? "Choose Right Traversal Algorithm" : "সঠিক ট্রাভার্সাল বাছাই (BFS vs DFS)", isEnglish ? "Use BFS for shortest path in unweighted graphs, DFS for connectivity & recursion." : "আনওয়েটেড শর্টেস্ট পাথে BFS এবং কম্পোনেন্ট খোঁজায় DFS ব্যবহার করুন।"),
            _buildRoadmapStep(2, isEnglish ? "Mark Visited Before Queue Push" : "ক্যু-তে পুশের সাথেই ভিজিটেড সেট করা", isEnglish ? "In BFS, set `visited[u] = true` immediately when pushing to queue." : "BFS ক্যু-তে নোড ঢোকানোর সময়েই ভিজিটেড মার্ক করুন।"),
            _buildRoadmapStep(3, isEnglish ? "Check 2D Grid Boundaries First" : "২D গ্রিড বাউন্ডারি চেক নিশ্চিতকরণ", isEnglish ? "Verify `0 <= r < R && 0 <= c < C` before reading grid cell." : "ম্যাট্রিক্স সেল পড়ার আগে সীমানা চেক ভেরিফাই করুন।"),
            _buildRoadmapStep(4, isEnglish ? "Master Multi-Source BFS Queue Init" : "মাল্টি-সোর্স BFS ইনিশিয়ালাইজেশন", isEnglish ? "Push all starting sources (e.g. all rotten oranges) to Queue before while loop." : "লুপ শুরুর আগেই সব প্রাথমিক সোর্স ক্যু-তে পুশ করুন।"),
            _buildRoadmapStep(5, isEnglish ? "Master 2-Coloring Conflict Detection" : "২-কালারিং বাইপারটাইট বৈপরীত্য নিরূপণ", isEnglish ? "Assign `-color` to neighbors; return false if adjacent node has identical color." : "প্রতিবেশীকে বিপরীত রঙ দিন; একই রঙ মিললে false ফেরান।"),
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
