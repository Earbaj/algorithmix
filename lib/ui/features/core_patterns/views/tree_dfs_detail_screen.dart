import 'package:flutter/material.dart';
import 'package:algorithmix/domain/models/tree_dfs_data.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';
import '../widgets/tree_dfs_visualizer.dart';

class TreeDfsDetailScreen extends StatefulWidget {
  const TreeDfsDetailScreen({super.key});

  @override
  State<TreeDfsDetailScreen> createState() => _TreeDfsDetailScreenState();
}

class _TreeDfsDetailScreenState extends State<TreeDfsDetailScreen>
    with SingleTickerProviderStateMixin {
  bool _isEnglish = true;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final intro = TreeDfsData.getConceptIntro(_isEnglish);

    return Scaffold(
      backgroundColor: AppTheme.primaryDark,
      appBar: AppBar(
        title: Text(_isEnglish ? 'Tree DFS Deep Dive' : 'ট্রি DFS (Pre/In/Postorder) গাইড'),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: TextButton.icon(
              style: TextButton.styleFrom(
                backgroundColor: AppTheme.accentPurple.withOpacity(0.2),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              icon: Icon(
                Icons.language,
                color: _isEnglish ? AppTheme.accentNeonCyan : AppTheme.accentPink,
                size: 18,
              ),
              label: Text(
                _isEnglish ? 'EN' : 'BN',
                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
              onPressed: () {
                setState(() => _isEnglish = !_isEnglish);
              },
            ),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppTheme.accentNeonCyan,
          labelColor: AppTheme.accentNeonCyan,
          unselectedLabelColor: AppTheme.textSecondary,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          padding: EdgeInsets.zero,
          tabs: [
            Tab(text: _isEnglish ? 'Concept & C++ Code' : 'ধারণা ও C++ কোড'),
            Tab(text: _isEnglish ? 'Visualizer' : 'ভিজ্যুয়ালাইজার'),
            Tab(text: _isEnglish ? 'FAANG Problems' : 'FAANG প্রবলেমস'),
            Tab(text: _isEnglish ? 'Mistakes & Roadmap' : 'ভুল ও রোডম্যাপ'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildConceptTab(intro),
          _buildVisualizerTab(),
          _buildProblemsTab(),
          _buildMistakesTab(),
        ],
      ),
    );
  }

  // TAB 1: Concept & C++ Boilerplate Templates
  Widget _buildConceptTab(Map<String, String> intro) {
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

            // 3 Main Tree DFS Types
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
              _isEnglish ? "🧠 C++ Boilerplate Templates" : "🧠 C++ টেমপ্লেট কোড (মুখস্থ রাখার মতো)",
              style: TextStyle(
                fontSize: Responsive.sp(context, 18),
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            _buildCodeBox("Template 1: Preorder Traversal (Root -> Left -> Right)", """
void preorder(TreeNode* root, vector<int>& res) {
    if (!root) return;
    res.push_back(root->val); // Process Root First!
    preorder(root->left, res);
    preorder(root->right, res);
}"""),
            const SizedBox(height: 16),
            _buildCodeBox("Template 2: Inorder Traversal (Left -> Root -> Right - BST Sorted)", """
void inorder(TreeNode* root, vector<int>& res) {
    if (!root) return;
    inorder(root->left, res);
    res.push_back(root->val); // Process Root (Sorted in BST!)
    inorder(root->right, res);
}"""),
            const SizedBox(height: 16),
            _buildCodeBox("Template 3: Postorder Traversal / Path Sum (Left -> Right -> Root)", """
bool hasPathSum(TreeNode* root, int targetSum) {
    if (!root) return false;
    if (!root->left && !root->right) return targetSum == root->val;
    return hasPathSum(root->left, targetSum - root->val) ||
           hasPathSum(root->right, targetSum - root->val);
}"""),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // TAB 2: Visualizer
  Widget _buildVisualizerTab() {
    final hPadding = Responsive.horizontalPadding(context);

    return ResponsiveCenter(
      padding: EdgeInsets.all(hPadding),
      child: SingleChildScrollView(
        child: TreeDfsVisualizer(isEnglish: _isEnglish),
      ),
    );
  }

  // TAB 3: FAANG Problems
  Widget _buildProblemsTab() {
    final hPadding = Responsive.horizontalPadding(context);
    final easy = TreeDfsData.getEasyProblems();
    final medium = TreeDfsData.getMediumProblems();
    final hard = TreeDfsData.getHardProblems();

    return ResponsiveCenter(
      padding: EdgeInsets.all(hPadding),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _isEnglish ? "FAANG & MAANG Interview Practice Problems" : "FAANG ও MAANG ইন্টারভিউ প্রশ্নসমূহ",
              style: TextStyle(fontSize: Responsive.sp(context, 20), fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 6),
            Text(
              _isEnglish ? "Master these curated problems to ace your technical interviews." : "ইন্টারভিউ ক্র্যাক করতে গুরুত্বপূর্ণ প্রবলেমসমূহ সমাধান করুন।",
              style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13),
            ),
            const SizedBox(height: 20),

            _buildProblemSection(_isEnglish ? "🟢 Easy Practice Problems" : "🟢 সহজ সমস্যাসমূহ", easy, AppTheme.accentGreen),
            const SizedBox(height: 20),
            _buildProblemSection(_isEnglish ? "🟡 Medium Practice Problems" : "🟡 মাঝারি সমস্যাসমূহ", medium, AppTheme.accentAmber),
            const SizedBox(height: 20),
            _buildProblemSection(_isEnglish ? "🔴 Hard Practice Problems" : "🔴 কঠিন সমস্যাসমূহ", hard, AppTheme.accentPink),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildProblemSection(String title, List<TreeDfsProblem> problems, Color diffColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontSize: Responsive.sp(context, 16), fontWeight: FontWeight.bold, color: diffColor)),
        const SizedBox(height: 10),
        ...problems.map((p) => _buildProblemCard(p, diffColor)).toList(),
      ],
    );
  }

  Widget _buildProblemCard(TreeDfsProblem p, Color diffColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF1E293B)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  p.title,
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 14),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: diffColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: diffColor),
                ),
                child: Text(p.difficulty, style: TextStyle(color: diffColor, fontSize: 10, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            _isEnglish ? p.keyIdeaEn : p.keyIdeaBn,
            style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12, height: 1.4),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 6,
            children: p.companyTags.map((tag) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppTheme.accentPurple.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(tag, style: const TextStyle(color: AppTheme.accentNeonCyan, fontSize: 10, fontWeight: FontWeight.bold)),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // TAB 4: Mistakes & 5-Step Roadmap
  Widget _buildMistakesTab() {
    final hPadding = Responsive.horizontalPadding(context);
    final mistakes = TreeDfsData.getCommonMistakes(_isEnglish);

    return ResponsiveCenter(
      padding: EdgeInsets.all(hPadding),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _isEnglish ? "⚠️ Top 5 Common Mistakes" : "⚠️ ৫টি সাধারণ ভুল (যা এড়িয়ে চলবেন)",
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
              _isEnglish ? "🚀 5-Step Master Roadmap" : "🚀 ৫-ধাপের মাস্টার রোডম্যাপ",
              style: TextStyle(fontSize: Responsive.sp(context, 18), fontWeight: FontWeight.bold, color: AppTheme.accentGreen),
            ),
            const SizedBox(height: 12),
            _buildRoadmapStep(1, _isEnglish ? "Master Recursive Base Case & Call Stack" : "রিকার্সিভ বেস কেস ও কল স্ট্যাক মেকানিক্স", _isEnglish ? "Always start with if (root == nullptr) return." : "সর্বপ্রথম `if (root == nullptr)` বেস কেস চেক করুন।"),
            _buildRoadmapStep(2, _isEnglish ? "Master 3 Classical Traversals" : "৩টি ক্লাসিক্যাল ট্রাভার্সাল আয়ত্তকরণ", _isEnglish ? "Understand Preorder (Root-L-R), Inorder (L-Root-R), and Postorder (L-R-Root)." : "প্রি, ইন এবং পোস্ট-অর্ডারের পার্থক্য আয়ত্ত করুন।"),
            _buildRoadmapStep(3, _isEnglish ? "Master BST Inorder Sorted Property" : "BST এর ইন-অর্ডার সর্টেড প্রপার্টি", _isEnglish ? "Solve K-th smallest element or BST validation using Inorder." : "Inorder দিয়ে BST সর্টেড উপাদান ও K-তম মান বের করুন।"),
            _buildRoadmapStep(4, _isEnglish ? "Master Postorder Bottom-Up Calculation" : "পোস্ট-অর্ডার বটম-আপ হিসাব", _isEnglish ? "Calculate Tree Height, Diameter, and LCA from subtrees." : "সাব-ট্রি থেকে হাইট, ডায়ামিটার ও LCA বের করুন।"),
            _buildRoadmapStep(5, _isEnglish ? "Master Backtracking Path Collection" : "ব্যাকট্র্যাকিং দিয়ে রুট-টু-লিফ পাথ সংগ্রহ", _isEnglish ? "Collect root-to-leaf paths and backtrack with path.pop_back()." : "পাথ ভেক্টর পাস করে `path.pop_back()` দিয়ে ব্যাকট্র্যাক করুন।"),
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
