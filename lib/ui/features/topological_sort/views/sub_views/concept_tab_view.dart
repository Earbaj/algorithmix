import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';

class TopologicalConceptTabView extends StatelessWidget {
  final Map<String, String> intro;
  final bool isEnglish;

  const TopologicalConceptTabView({
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

            // 3 Main Topological Patterns
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
            _buildCodeBox("Template 1: Course Schedule II Topological Order (LeetCode 210)", """
vector<int> findOrder(int numCourses, vector<vector<int>>& prerequisites) {
    vector<vector<int>> adj(numCourses); vector<int> inDegree(numCourses, 0);
    for (auto& p : prerequisites) { adj[p[1]].push_back(p[0]); inDegree[p[0]]++; }
    queue<int> q; for (int i = 0; i < numCourses; i++) if (inDegree[i] == 0) q.push(i);
    vector<int> order;
    while (!q.empty()) {
        int u = q.front(); q.pop(); order.push_back(u); // Pop in-degree 0 node
        for (int v : adj[u]) { if (--inDegree[v] == 0) q.push(v); }
    }
    return order.size() == numCourses ? order : vector<int>();
}"""),
            const SizedBox(height: 16),
            _buildCodeBox("Template 2: Course Schedule Cycle Detection (LeetCode 207)", """
bool canFinish(int numCourses, vector<vector<int>>& prerequisites) {
    vector<vector<int>> adj(numCourses); vector<int> inDegree(numCourses, 0);
    for (auto& p : prerequisites) { adj[p[1]].push_back(p[0]); inDegree[p[0]]++; }
    queue<int> q; for (int i = 0; i < numCourses; i++) if (inDegree[i] == 0) q.push(i);
    int count = 0;
    while (!q.empty()) {
        int u = q.front(); q.pop(); count++;
        for (int v : adj[u]) if (--inDegree[v] == 0) q.push(v);
    }
    return count == numCourses; // If count < N, cycle exists!
}"""),
            const SizedBox(height: 16),
            _buildCodeBox("Template 3: Alien Dictionary (LeetCode 269)", """
string alienOrder(vector<string>& words) {
    unordered_map<char, unordered_set<char>> adj; unordered_map<char, int> inDegree;
    // Build character graph from adjacent words comparison
    queue<char> q; for (auto& p : inDegree) if (p.second == 0) q.push(p.first);
    string order = "";
    while (!q.empty()) {
        char u = q.front(); q.pop(); order += u;
        for (char v : adj[u]) if (--inDegree[v] == 0) q.push(v);
    }
    return order.size() == inDegree.size() ? order : "";
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
