import 'package:flutter/material.dart';
import 'package:algorithmix/domain/models/sliding_window_data.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';
import 'package:algorithmix/ui/core/navigation/app_routes.dart';
import '../widgets/sliding_window_visualizer.dart';

class SlidingWindowDetailScreen extends StatefulWidget {
  const SlidingWindowDetailScreen({super.key});

  @override
  State<SlidingWindowDetailScreen> createState() => _SlidingWindowDetailScreenState();
}

class _SlidingWindowDetailScreenState extends State<SlidingWindowDetailScreen>
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
    final intro = SlidingWindowData.getConceptIntro(_isEnglish);

    return Scaffold(
      backgroundColor: AppTheme.primaryDark,
      appBar: AppBar(
        title: Text(_isEnglish ? 'Sliding Window Deep Dive' : 'স্লাইডিং উইন্ডো গাইড'),
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

            // 3 Main Sliding Window Types
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
            _buildCodeBox("Template 1: Fixed Size Window K (C++ Max Sum Subarray)", """
int maxSubarraySum(vector<int>& arr, int k) {
    int curr_sum = 0;
    for (int i = 0; i < k; i++) curr_sum += arr[i];
    int max_sum = curr_sum;
    for (int right = k; right < arr.size(); right++) {
        curr_sum += arr[right] - arr[right - k];
        max_sum = max(max_sum, curr_sum);
    }
    return max_sum;
}"""),
            const SizedBox(height: 16),
            _buildCodeBox("Template 2: Dynamic Window (C++ Longest Unique Substring)", """
int lengthOfLongestSubstring(string s) {
    unordered_map<char, int> mp;
    int left = 0, max_len = 0;
    for (int right = 0; right < s.length(); right++) {
        if (mp.count(s[right])) left = max(left, mp[s[right]] + 1);
        mp[s[right]] = right;
        max_len = max(max_len, right - left + 1);
    }
    return max_len;
}"""),
            const SizedBox(height: 16),
            _buildCodeBox("Template 3: Dynamic Min Window (C++ Min Subarray Sum >= Target)", """
int minSubArrayLen(int target, vector<int>& nums) {
    int left = 0, curr_sum = 0, min_len = INT_MAX;
    for (int right = 0; right < nums.size(); right++) {
        curr_sum += nums[right];
        while (curr_sum >= target) {
            min_len = min(min_len, right - left + 1);
            curr_sum -= nums[left++];
        }
    }
    return min_len == INT_MAX ? 0 : min_len;
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
        child: SlidingWindowVisualizer(isEnglish: _isEnglish),
      ),
    );
  }

  // TAB 3: FAANG Problems
  Widget _buildProblemsTab() {
    final hPadding = Responsive.horizontalPadding(context);
    final easy = SlidingWindowData.getEasyProblems();
    final medium = SlidingWindowData.getMediumProblems();
    final hard = SlidingWindowData.getHardProblems();

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

  Widget _buildProblemSection(String title, List<SlidingWindowProblem> problems, Color diffColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontSize: Responsive.sp(context, 16), fontWeight: FontWeight.bold, color: diffColor)),
        const SizedBox(height: 10),
        ...problems.map((p) => _buildProblemCard(p, diffColor)).toList(),
      ],
    );
  }

  Widget _buildProblemCard(SlidingWindowProblem p, Color diffColor) {
    final isClickable = p.title.contains("Maximum Average Subarray I") ||
        p.title.contains("Contains Duplicate II") ||
        p.title.contains("Defuse the Bomb") ||
        p.title.contains("Minimum Recolors") ||
        p.title.contains("Substrings of Size Three") ||
        p.title.contains("Find All Anagrams") ||
        p.title.contains("Permutation in String") ||
        p.title.contains("Grumpy Bookstore Owner") ||
        p.title.contains("Longest Substring Without Repeating") ||
        p.title.contains("Longest Repeating Character Replacement") ||
        p.title.contains("Minimum Size Subarray Sum") ||
        p.title.contains("Max Consecutive Ones III") ||
        p.title.contains("Fruit Into Baskets");

    return InkWell(
      onTap: () {
        if (p.title.contains("Maximum Average Subarray I")) {
          Navigator.of(context).pushNamed(AppRoutes.maxAverageSubarrayIDetail);
        } else if (p.title.contains("Contains Duplicate II")) {
          Navigator.of(context).pushNamed(AppRoutes.containsDuplicateIIDetail);
        } else if (p.title.contains("Defuse the Bomb")) {
          Navigator.of(context).pushNamed(AppRoutes.defuseTheBombDetail);
        } else if (p.title.contains("Minimum Recolors")) {
          Navigator.of(context).pushNamed(AppRoutes.minimumRecolorsDetail);
        } else if (p.title.contains("Substrings of Size Three")) {
          Navigator.of(context).pushNamed(AppRoutes.distinctSubstringsThreeDetail);
        } else if (p.title.contains("Find All Anagrams")) {
          Navigator.of(context).pushNamed(AppRoutes.findAnagramsDetail);
        } else if (p.title.contains("Permutation in String")) {
          Navigator.of(context).pushNamed(AppRoutes.permutationInStringDetail);
        } else if (p.title.contains("Grumpy Bookstore Owner")) {
          Navigator.of(context).pushNamed(AppRoutes.grumpyBookstoreOwnerDetail);
        } else if (p.title.contains("Longest Substring Without Repeating")) {
          Navigator.of(context).pushNamed(AppRoutes.longestSubstringWithoutRepeatingDetail);
        } else if (p.title.contains("Longest Repeating Character Replacement")) {
          Navigator.of(context).pushNamed(AppRoutes.longestRepeatingReplacementDetail);
        } else if (p.title.contains("Minimum Size Subarray Sum")) {
          Navigator.of(context).pushNamed(AppRoutes.minSizeSubarraySumDetail);
        } else if (p.title.contains("Max Consecutive Ones III")) {
          Navigator.of(context).pushNamed(AppRoutes.maxConsecutiveOnesIIIDetail);
        } else if (p.title.contains("Fruit Into Baskets")) {
          Navigator.of(context).pushNamed(AppRoutes.fruitIntoBasketsDetail);
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
            color: isClickable ? AppTheme.accentNeonCyan.withOpacity(0.5) : const Color(0xFF1E293B),
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
    final mistakes = SlidingWindowData.getCommonMistakes(_isEnglish);

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
            _buildRoadmapStep(1, _isEnglish ? "Master Fixed Size Window K Mechanics" : "ফিক্সড সাইজ K উইন্ডো স্লাইডিং আয়ত্তকরণ", _isEnglish ? "Understand O(1) incremental slide addition and subtraction." : "O(1) যোগ ও বিয়োগ দিয়ে ফিক্সড স্লাইড করুন।"),
            _buildRoadmapStep(2, _isEnglish ? "Master Dynamic Max Length Window" : "ডাইনামিক ম্যাক্স লেন্থ উইন্ডো", _isEnglish ? "Expand right, shrink left on invalid constraint, track maximum." : "ডান বাড়িয়ে শর্ত ভাঙলে বাম সরাও, সর্বোচ্চ নাও।"),
            _buildRoadmapStep(3, _isEnglish ? "Master Dynamic Min Length Window" : "ডাইনামিক মিন লেন্থ উইন্ডো", _isEnglish ? "Expand right until valid, shrink left greedily to minimize window size." : "শর্ত মিললে বাম কমিয়ে মিনিমাম উইন্ডো বের করুন।"),
            _buildRoadmapStep(4, _isEnglish ? "Master Frequency Map & Anagram Windows" : "ফ্রিকোয়েন্সি ম্যাপ ও অ্যানাগ্রাম স্লাইডিং", _isEnglish ? "Match string character frequencies in fixed/dynamic window." : "স্ট্রিং ক্যারেক্টার ফ্রিকোয়েন্সি স্লাইড করে মেলান।"),
            _buildRoadmapStep(5, _isEnglish ? "Master Monotonic Deque Sliding Window" : "মনোটোনিক ডিকিউ স্লাইডিং উইন্ডো", _isEnglish ? "Maintain Monotonic Decreasing Deque for O(N) Sliding Window Max." : "O(N) স্লাইডিং উইন্ডো ম্যাক্সিমাম এর জন্য ডিকিউ ব্যবহার করুন।"),
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
