import 'package:flutter/material.dart';
import 'package:algorithmix/domain/models/recursion_backtracking_data.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';
import 'package:algorithmix/ui/core/navigation/app_routes.dart';
import '../widgets/recursion_backtracking_visualizer.dart';

class RecursionBacktrackingDetailScreen extends StatefulWidget {
  const RecursionBacktrackingDetailScreen({super.key});

  @override
  State<RecursionBacktrackingDetailScreen> createState() => _RecursionBacktrackingDetailScreenState();
}

class _RecursionBacktrackingDetailScreenState extends State<RecursionBacktrackingDetailScreen>
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
    final intro = RecursionBacktrackingData.getConceptIntro(_isEnglish);

    return Scaffold(
      backgroundColor: AppTheme.primaryDark,
      appBar: AppBar(
        title: Text(_isEnglish ? 'Recursion & Backtracking Deep Dive' : 'রিকার্সন ও ব্যাকট্র্যাকিং গাইড'),
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

            // 3 Main Backtracking Types
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
            _buildCodeBox("Template 1: Subsets & Combinations (Take / Skip Pattern)", """
void generateSubsets(vector<int>& nums, int idx, vector<int>& path, vector<vector<int>>& result) {
    if (idx == nums.size()) {
        result.push_back(path);  // Base Case
        return;
    }
    // Choice 1: Include nums[idx] (Take)
    path.push_back(nums[idx]);
    generateSubsets(nums, idx + 1, path, result);
    
    // Backtrack (Un-choose)
    path.pop_back();
    
    // Choice 2: Exclude nums[idx] (Skip)
    generateSubsets(nums, idx + 1, path, result);
}"""),
            const SizedBox(height: 16),
            _buildCodeBox("Template 2: Permutations (In-place Swap Pattern)", """
void permute(vector<int>& nums, int start, vector<vector<int>>& result) {
    if (start == nums.size()) {
        result.push_back(nums);
        return;
    }
    for (int i = start; i < nums.size(); i++) {
        swap(nums[start], nums[i]);       // Choose
        permute(nums, start + 1, result);  // Recurse
        swap(nums[start], nums[i]);       // Un-choose (Backtrack)
    }
}"""),
            const SizedBox(height: 16),
            _buildCodeBox("Template 3: Grid Search / N-Queens (Choose -> Recurse -> Un-choose)", """
bool solveGridDFS(int r, int c, vector<vector<char>>& board) {
    if (r == R && c == C) return true;  // Goal Reached
    
    board[r][c] = '#';  // Choose (Mark Visited)
    for (auto& dir : directions) {
        int nr = r + dir[0], nc = c + dir[1];
        if (isValid(nr, nc) && solveGridDFS(nr, nc, board)) return true;
    }
    
    board[r][c] = '.';  // Un-choose (Backtrack)
    return false;
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
        child: RecursionBacktrackingVisualizer(isEnglish: _isEnglish),
      ),
    );
  }

  // TAB 3: FAANG Problems
  Widget _buildProblemsTab() {
    final hPadding = Responsive.horizontalPadding(context);
    final easy = RecursionBacktrackingData.getEasyProblems();
    final medium = RecursionBacktrackingData.getMediumProblems();
    final hard = RecursionBacktrackingData.getHardProblems();

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

  Widget _buildProblemSection(String title, List<RecursionBacktrackingProblem> problems, Color diffColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontSize: Responsive.sp(context, 16), fontWeight: FontWeight.bold, color: diffColor)),
        const SizedBox(height: 10),
        ...problems.map((p) => _buildProblemCard(p, diffColor)).toList(),
      ],
    );
  }

  Widget _buildProblemCard(RecursionBacktrackingProblem p, Color diffColor) {
    final isClickable = p.title.contains("Subsets") ||
        p.title.contains("Combination Sum") ||
        p.title.contains("Generate Parentheses") ||
        p.title.contains("Letter Combinations") ||
        p.title.contains("Permutations") ||
        p.title.contains("Binary Tree Paths") ||
        p.title.contains("Word Search") ||
        p.title.contains("Subsets II") ||
        p.title.contains("Permutations II") ||
        p.title.contains("Combination Sum II") ||
        p.title.contains("Palindrome Partitioning") ||
        p.title.contains("Letter Case Permutation") ||
        p.title.contains("N-Queens") ||
        p.title.contains("Sudoku Solver");

    return InkWell(
      onTap: () {
        if (p.title.contains("Subsets II")) {
          Navigator.of(context).pushNamed(AppRoutes.subsetsIIDetail);
        } else if (p.title.contains("Subsets")) {
          Navigator.of(context).pushNamed(AppRoutes.subsetsDetail);
        } else if (p.title.contains("Combination Sum II")) {
          Navigator.of(context).pushNamed(AppRoutes.combinationSumIIDetail);
        } else if (p.title.contains("Combination Sum")) {
          Navigator.of(context).pushNamed(AppRoutes.combinationSumDetail);
        } else if (p.title.contains("Generate Parentheses")) {
          Navigator.of(context).pushNamed(AppRoutes.generateParenthesesDetail);
        } else if (p.title.contains("Letter Combinations")) {
          Navigator.of(context).pushNamed(AppRoutes.letterCombinationsDetail);
        } else if (p.title.contains("Permutations II")) {
          Navigator.of(context).pushNamed(AppRoutes.permutationsIIDetail);
        } else if (p.title.contains("Permutations")) {
          Navigator.of(context).pushNamed(AppRoutes.permutationsDetail);
        } else if (p.title.contains("Binary Tree Paths")) {
          Navigator.of(context).pushNamed(AppRoutes.binaryTreePathsDetail);
        } else if (p.title.contains("Word Search")) {
          Navigator.of(context).pushNamed(AppRoutes.wordSearchDetail);
        } else if (p.title.contains("Palindrome Partitioning")) {
          Navigator.of(context).pushNamed(AppRoutes.palindromePartitioningDetail);
        } else if (p.title.contains("Letter Case Permutation")) {
          Navigator.of(context).pushNamed(AppRoutes.letterCasePermutationDetail);
        } else if (p.title.contains("N-Queens")) {
          Navigator.of(context).pushNamed(AppRoutes.nQueensDetail);
        } else if (p.title.contains("Sudoku Solver")) {
          Navigator.of(context).pushNamed(AppRoutes.sudokuSolverDetail);
        }
      },
      borderRadius: BorderRadius.circular(14),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppTheme.surfaceDark,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isClickable ? AppTheme.accentNeonCyan : const Color(0xFF1E293B),
            width: isClickable ? 1.5 : 1.0,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Text(
                        p.title,
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 14),
                      ),
                      if (isClickable) ...[
                        const SizedBox(width: 6),
                        const Icon(Icons.open_in_new, color: AppTheme.accentNeonCyan, size: 14),
                      ],
                    ],
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
      ),
    );
  }

  // TAB 4: Mistakes & 5-Step Roadmap
  Widget _buildMistakesTab() {
    final hPadding = Responsive.horizontalPadding(context);
    final mistakes = RecursionBacktrackingData.getCommonMistakes(_isEnglish);

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
            _buildRoadmapStep(1, _isEnglish ? "Master Call Stack & Base Case Mechanics" : "কল স্ট্যাক ও বেস কেস মেকানিক্স আয়ত্তকরণ", _isEnglish ? "Understand O(N) recursion call stack depth and termination criteria." : "O(N) রিকার্সন কল স্ট্যাক এবং সমাপ্তির শর্ত বুজুন।"),
            _buildRoadmapStep(2, _isEnglish ? "Master Subsets & Power Set (Take / Skip)" : "সাবসেট ও পাওয়ার সেট (Take / Skip চয়েস)", _isEnglish ? "Implement 2ⁿ binary choice tree recursion." : "২ⁿ বাইনারি চয়েস ট্রি ইমপ্লিমেন্ট করুন।"),
            _buildRoadmapStep(3, _isEnglish ? "Master Permutations (Used Array & Swap)" : "পারমিউটেশন (Swap ও Used অ্যারে প্যাটার্ন)", _isEnglish ? "Generate N! orderings with in-place swaps and backtracking." : "ইন-প্লেস সোয়াপ দিয়ে সব N! অর্ডার জেনারেট করুন।"),
            _buildRoadmapStep(4, _isEnglish ? "Master Constraint Backtracking & Grid Search" : "কনস্ট্রেইন্ট ব্যাকট্র্যাকিং ও গ্রিড সার্চ", _isEnglish ? "Solve N-Queens, Sudoku Solver, and 2D Grid DFS Word Search." : "N-Queens, Sudoku এবং ২D গ্রিড সার্চ সমাধান করুন।"),
            _buildRoadmapStep(5, _isEnglish ? "Master Tree Pruning & Memoized Backtracking" : "ট্রি প্রুনিং ও মেমোইজড ব্যাকট্র্যাকিং", _isEnglish ? "Prune invalid branches early to transition into Dynamic Programming." : "ইনভ্যালিড ব্রাঞ্চ আগে ছাঁটাই করে ডাইনামিক প্রোগ্রামিং এ রূপান্তর করুন।"),
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
