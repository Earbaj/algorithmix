import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';

class SubsetsConceptTabView extends StatelessWidget {
  final Map<String, String> intro;
  final bool isEnglish;

  const SubsetsConceptTabView({
    super.key,
    required this.intro,
    required this.isEnglish,
  });

  @override
  Widget build(BuildContext context) {
    final hPadding = Responsive.horizontalPadding(context);

    return ResponsiveCenter(
      padding: EdgeInsets.all(hPadding),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              intro["title"]!,
              style: TextStyle(
                fontSize: Responsive.sp(context, 22),
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              intro["summary"]!,
              style: TextStyle(
                fontSize: Responsive.sp(context, 14),
                color: AppTheme.textSecondary,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),

            // When to use Card
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppTheme.surfaceDark,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF334155)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.vpn_key_outlined, color: AppTheme.accentAmber, size: 22),
                      const SizedBox(width: 8),
                      Text(
                        intro["whenToUseTitle"]!,
                        style: TextStyle(
                          fontSize: Responsive.sp(context, 16),
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildCheckPoint(intro["whenToUse1"]!),
                  _buildCheckPoint(intro["whenToUse2"]!),
                  _buildCheckPoint(intro["whenToUse3"]!),
                  _buildCheckPoint(intro["whenToUse4"]!),
                  _buildCheckPoint(intro["whenToUse5"]!),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // 3 Main Subsets & Backtracking Patterns
            Text(
              intro["typesTitle"]!,
              style: TextStyle(
                fontSize: Responsive.sp(context, 18),
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            _buildTypeCard(intro["type1Title"]!, intro["type1Desc"]!, AppTheme.accentNeonCyan),
            _buildTypeCard(intro["type2Title"]!, intro["type2Desc"]!, AppTheme.accentPurple),
            _buildTypeCard(intro["type3Title"]!, intro["type3Desc"]!, AppTheme.accentPink),
            const SizedBox(height: 24),

            // C++ Boilerplate Code Templates
            Text(
              isEnglish ? "🧠 C++ Boilerplate Templates" : "🧠 C++ টেমপ্লেট কোড (মুখস্থ রাখার মতো)",
              style: TextStyle(
                fontSize: Responsive.sp(context, 18),
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            _buildCodeBox("Template 1: Subsets / Power Set (LeetCode 78)", """
void backtrack(int start, vector<int>& nums, vector<int>& curr, vector<vector<int>>& res) {
    res.push_back(curr); // Add subset candidate to result
    for (int i = start; i < nums.size(); i++) {
        curr.push_back(nums[i]);            // 1. Make Choice
        backtrack(i + 1, nums, curr, res);   // 2. Recurse next index
        curr.pop_back();                    // 3. Undo Choice (Backtrack!)
    }
}"""),
            const SizedBox(height: 16),
            _buildCodeBox("Template 2: Permutations (LeetCode 46)", """
void backtrack(vector<int>& nums, vector<int>& curr, vector<bool>& visited, vector<vector<int>>& res) {
    if (curr.size() == nums.size()) { res.push_back(curr); return; }
    for (int i = 0; i < nums.size(); i++) {
        if (visited[i]) continue;
        visited[i] = true; curr.push_back(nums[i]); // Choose
        backtrack(nums, curr, visited, res);         // Recurse
        curr.pop_back(); visited[i] = false;        // Backtrack!
    }
}"""),
            const SizedBox(height: 16),
            _buildCodeBox("Template 3: Combination Sum (LeetCode 39)", """
void backtrack(int start, int target, vector<int>& nums, vector<int>& curr, vector<vector<int>>& res) {
    if (target == 0) { res.push_back(curr); return; }
    if (target < 0) return;
    for (int i = start; i < nums.size(); i++) {
        curr.push_back(nums[i]);
        backtrack(i, target - nums[i], nums, curr, res); // Reuse index i!
        curr.pop_back();
    }
}"""),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle_outline, color: AppTheme.accentGreen, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(text, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13, height: 1.4)),
          ),
        ],
      ),
    );
  }

  Widget _buildTypeCard(String title, String desc, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 4),
          Text(desc, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12, height: 1.4)),
        ],
      ),
    );
  }

  Widget _buildCodeBox(String title, String code) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF090D16),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF1E293B)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 13)),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Text(code, style: const TextStyle(fontFamily: 'monospace', fontSize: 12, color: Color(0xFF38BDF8), height: 1.4)),
          ),
        ],
      ),
    );
  }
}
