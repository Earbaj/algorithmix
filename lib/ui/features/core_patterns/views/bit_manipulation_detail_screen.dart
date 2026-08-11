import 'package:flutter/material.dart';
import 'package:algorithmix/domain/models/bit_manipulation_data.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';
import '../widgets/bit_manipulation_visualizer.dart';

class BitManipulationDetailScreen extends StatefulWidget {
  const BitManipulationDetailScreen({super.key});

  @override
  State<BitManipulationDetailScreen> createState() => _BitManipulationDetailScreenState();
}

class _BitManipulationDetailScreenState extends State<BitManipulationDetailScreen>
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
    final intro = BitManipulationData.getConceptIntro(_isEnglish);

    return Scaffold(
      backgroundColor: AppTheme.primaryDark,
      appBar: AppBar(
        title: Text(_isEnglish ? 'Bit Manipulation Deep Dive' : 'বিট ম্যানিপুলেশন গাইড'),
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

            // 3 Main Bit Manipulation Types
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
            _buildCodeBox("Template 1: Single Number XOR Cancellation (C++ LeetCode 136)", """
int singleNumber(vector<int>& nums) {
    int result = 0;
    for (int num : nums) {
        result ^= num; // XOR cancels duplicate pairs (A ^ A = 0)
    }
    return result; // Unique single element remaining!
}"""),
            const SizedBox(height: 16),
            _buildCodeBox("Template 2: Number of 1 Bits Kernighan's Algorithm (C++ LeetCode 191)", """
int hammingWeight(uint32_t n) {
    int count = 0;
    while (n != 0) {
        n &= (n - 1); // Clears rightmost set 1-bit in O(1)!
        count++;
    }
    return count;
}"""),
            const SizedBox(height: 16),
            _buildCodeBox("Template 3: Reverse Bits 32-Bit Shift (C++ LeetCode 190)", """
uint32_t reverseBits(uint32_t n) {
    uint32_t res = 0;
    for (int i = 0; i < 32; i++) {
        res = (res << 1) | (n & 1); // Append rightmost bit to res
        n >>= 1;
    }
    return res;
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
        child: BitManipulationVisualizer(isEnglish: _isEnglish),
      ),
    );
  }

  // TAB 3: FAANG Problems
  Widget _buildProblemsTab() {
    final hPadding = Responsive.horizontalPadding(context);
    final easy = BitManipulationData.getEasyProblems();
    final medium = BitManipulationData.getMediumProblems();
    final hard = BitManipulationData.getHardProblems();

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

  Widget _buildProblemSection(String title, List<BitManipulationProblem> problems, Color diffColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontSize: Responsive.sp(context, 16), fontWeight: FontWeight.bold, color: diffColor)),
        const SizedBox(height: 10),
        ...problems.map((p) => _buildProblemCard(p, diffColor)).toList(),
      ],
    );
  }

  Widget _buildProblemCard(BitManipulationProblem p, Color diffColor) {
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
    final mistakes = BitManipulationData.getCommonMistakes(_isEnglish);

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
            _buildRoadmapStep(1, _isEnglish ? "Master Basic Bit Operators & Parentheses" : "বেসিক বিট অপারেটর ও ব্র্যাকেট অগ্রাধিকার", _isEnglish ? "Use parentheses for bitwise comparison e.g., if ((n & 1) == 0)." : "তুলনা চেকে ব্র্যাকেট ব্যবহার বাধ্যতামূলক করুন।"),
            _buildRoadmapStep(2, _isEnglish ? "Master XOR Properties & Unique Element Tricks" : "XOR ধর্ম ও ইউনিক মান (LeetCode 136 & 268)", _isEnglish ? "Use A ^ A = 0 to cancel duplicate numbers in O(1) space." : "জোড়া মান বাতিল করে ইউনিক সংখ্যা বের করুন।"),
            _buildRoadmapStep(3, _isEnglish ? "Master Kernighan's Algorithm & Power of 2 Check" : "কার্নিগান অ্যালগরিদম ও ২ এর পাওয়ার (LeetCode 191 & 231)", _isEnglish ? "Use n & (n - 1) to clear rightmost set bit in O(1) time." : "ডানপাশের ১-বিট মুছে দ্রুত গণনা সম্পন্ন করুন।"),
            _buildRoadmapStep(4, _isEnglish ? "Master Bitmasking Subsets & DP States" : "বিটমাস্কিং সাবসেট ও DP স্টেট (LeetCode 78 & 318)", _isEnglish ? "Generate 2^N subsets using mask loop from 0 to (1 << N) - 1." : "মাস্ক লুপ দিয়ে সাবসেট ও DP স্টেট ট্র্যাকিং শিখুন।"),
            _buildRoadmapStep(5, _isEnglish ? "Master Bitwise Addition & Shortest Path Bitmask BFS" : "বিটওয়াইজ যোগফল ও বিটমাস্ক BFS (LeetCode 371 & 847)", _isEnglish ? "Solve Sum of Two Integers and Shortest Path Visiting All Nodes." : "Sum of Two Integers ও Shortest Path Bitmask BFS সমাধান করুন।"),
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
