import 'package:flutter/material.dart';
import 'package:algorithmix/domain/models/two_pointers_data.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';
import 'package:algorithmix/ui/core/navigation/app_routes.dart';
import '../widgets/two_pointers_visualizer.dart';

class TwoPointersDetailScreen extends StatefulWidget {
  const TwoPointersDetailScreen({super.key});

  @override
  State<TwoPointersDetailScreen> createState() => _TwoPointersDetailScreenState();
}

class _TwoPointersDetailScreenState extends State<TwoPointersDetailScreen>
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
    final intro = TwoPointersData.getConceptIntro(_isEnglish);

    return Scaffold(
      backgroundColor: AppTheme.primaryDark,
      appBar: AppBar(
        title: Text(_isEnglish ? 'Two Pointers Deep Dive (C++)' : 'টু পয়েন্টারস গাইড (C++)'),
        centerTitle: true,
        actions: [
          // Language Switcher Button
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
                setState(() {
                  _isEnglish = !_isEnglish;
                });
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

  // TAB 1: Concept & C++ Templates
  Widget _buildConceptTab(Map<String, String> intro) {
    final hPadding = Responsive.horizontalPadding(context);

    return ResponsiveCenter(
      padding: EdgeInsets.all(hPadding),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title & Summary
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

            // When to use card
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

            // 3 Main Types
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

            // C++ Code Templates
            Text(
              _isEnglish ? "🧠 C++ Boilerplate Templates" : "🧠 C++ টেমপ্লেট কোড (মুখস্থ রাখার মতো)",
              style: TextStyle(
                fontSize: Responsive.sp(context, 18),
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            _buildCodeBox("Template 1: Opposite Direction (C++ Two Sum II)", """
vector<int> two_pointer_opposite(vector<int>& arr, int target) {
    int left = 0, right = arr.size() - 1;
    while (left < right) {
        int curr_sum = arr[left] + arr[right];
        if (curr_sum == target) {
            return {left, right};
        } else if (curr_sum < target) {
            left++;   // sum বাড়াতে হবে
        } else {
            right--;  // sum কমাতে হবে
        }
    }
    return {-1, -1};
}"""),
            const SizedBox(height: 16),
            _buildCodeBox("Template 2: Same Direction (C++ In-place modify)", """
int two_pointer_same_direction(vector<int>& arr) {
    int slow = 0;
    for (int fast = 0; fast < arr.size(); fast++) {
        if (condition(arr[fast])) {
            swap(arr[slow], arr[fast]);
            slow++;
        }
    }
    return slow;  // new length
}"""),
            const SizedBox(height: 16),
            _buildCodeBox("Template 3: Fixed + Two Pointer (C++ 3Sum Triplets)", """
vector<vector<int>> three_sum(vector<int>& arr) {
    sort(arr.begin(), arr.end());
    vector<vector<int>> result;
    int n = arr.size();
    for (int i = 0; i < n - 2; i++) {
        if (i > 0 && arr[i] == arr[i - 1]) continue;  // duplicate skip
        int left = i + 1, right = n - 1;
        while (left < right) {
            int total = arr[i] + arr[left] + arr[right];
            if (total == 0) {
                result.push_back({arr[i], arr[left], arr[right]});
                left++; right--;
                while (left < right && arr[left] == arr[left - 1]) left++;
                while (left < right && arr[right] == arr[right + 1]) right--;
            } else if (total < 0) {
                left++;
            } else {
                right--;
            }
        }
    }
    return result;
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
        child: TwoPointersVisualizer(isEnglish: _isEnglish),
      ),
    );
  }

  // TAB 3: FAANG Problems
  Widget _buildProblemsTab() {
    final hPadding = Responsive.horizontalPadding(context);
    final easy = TwoPointersData.getEasyProblems();
    final medium = TwoPointersData.getMediumProblems();
    final hard = TwoPointersData.getHardProblems();

    return ResponsiveCenter(
      padding: EdgeInsets.all(hPadding),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Featured Card for Two Sum II Page
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppTheme.accentPurple.withOpacity(0.3),
                    AppTheme.accentNeonCyan.withOpacity(0.2),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.accentNeonCyan.withOpacity(0.5), width: 1.5),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppTheme.accentNeonCyan.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.bolt, color: AppTheme.accentNeonCyan, size: 28),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _isEnglish ? "⚡ Two Sum II (Sorted Array) Deep Dive" : "⚡ টু সাম ২ (Sorted Array) স্পেশাল পেজ",
                          style: TextStyle(
                            fontSize: Responsive.sp(context, 16),
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _isEnglish
                              ? "Interactive visualizer, dynamic custom test cases, practice mode & full code answers."
                              : "ইন্টারেক্টিভ ভিজ্যুয়ালাইজার, কাস্টম টেস্ট কেস, প্র্যাকটিস মোড ও উত্তর সহ সম্পূর্ণ পেজ।",
                          style: TextStyle(
                            fontSize: Responsive.sp(context, 12),
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed(AppRoutes.twoSumII);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.accentNeonCyan,
                      foregroundColor: AppTheme.primaryDark,
                    ),
                    child: Text(_isEnglish ? "Open" : "খুলুন"),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            Text(
              _isEnglish ? "📋 FAANG Interview Problems (C++ Focus)" : "📋 FAANG ইন্টারভিউ প্রবলেমস",
              style: TextStyle(
                fontSize: Responsive.sp(context, 18),
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),

            // EASY Section
            _buildDifficultySection("🟢 EASY", AppTheme.accentGreen, easy),
            const SizedBox(height: 24),

            // MEDIUM Section
            _buildDifficultySection("🟡 MEDIUM", AppTheme.accentAmber, medium),
            const SizedBox(height: 24),

            // HARD Section
            _buildDifficultySection("🔴 HARD", const Color(0xFFEF4444), hard),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // TAB 4: Mistakes & Practice Roadmap
  Widget _buildMistakesTab() {
    final hPadding = Responsive.horizontalPadding(context);
    final mistakes = TwoPointersData.getCommonMistakes(_isEnglish);

    return ResponsiveCenter(
      padding: EdgeInsets.all(hPadding),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                const Icon(Icons.warning_amber_rounded, color: Color(0xFFEF4444), size: 24),
                const SizedBox(width: 8),
                Text(
                  _isEnglish ? "⚠️ Common Interview Mistakes" : "⚠️ সাধারণ ইন্টারভিউ ভুলসমূহ",
                  style: TextStyle(
                    fontSize: Responsive.sp(context, 18),
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            ...mistakes.map((m) => Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceDark,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFEF4444).withOpacity(0.4)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        m["title"]!,
                        style: TextStyle(
                          fontSize: Responsive.sp(context, 15),
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFFEF4444),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        m["desc"]!,
                        style: TextStyle(
                          fontSize: Responsive.sp(context, 13),
                          color: AppTheme.textSecondary,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                )),
            const SizedBox(height: 28),

            // Practice Order Roadmap
            Row(
              children: [
                const Icon(Icons.alt_route, color: AppTheme.accentNeonCyan, size: 24),
                const SizedBox(width: 8),
                Text(
                  _isEnglish ? "🎯 Recommended Practice Order" : "🎯 প্র্যাকটিস করার সঠিক ধাপ",
                  style: TextStyle(
                    fontSize: Responsive.sp(context, 18),
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildRoadmapStep(1, "Two Sum II → Valid Palindrome → Move Zeroes → Remove Duplicates"),
            _buildRoadmapStep(2, "Container With Most Water → 3Sum → 3Sum Closest"),
            _buildRoadmapStep(3, "Sort Colors (Dutch National Flag) → 4Sum"),
            _buildRoadmapStep(4, "Trapping Rain Water (Must-Do FAANG Problem ⭐)"),
            _buildRoadmapStep(5, "Minimum Window Substring (Sliding Window Transition)"),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // Helpers
  Widget _buildCheckPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle_outline, color: AppTheme.accentGreen, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: Responsive.sp(context, 13), color: AppTheme.textPrimary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypeCard(String title, String desc, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(12)),
            child: Icon(Icons.swap_horiz_rounded, color: color, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: Responsive.sp(context, 15))),
                const SizedBox(height: 4),
                Text(desc, style: TextStyle(color: AppTheme.textSecondary, fontSize: Responsive.sp(context, 12), height: 1.3)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCodeBox(String title, String code) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF090D16),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF1E293B)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.accentNeonCyan, fontSize: 13)),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Text(code, style: const TextStyle(fontFamily: 'monospace', fontSize: 12, color: Color(0xFF38BDF8), height: 1.4)),
          ),
        ],
      ),
    );
  }

  Widget _buildDifficultySection(String label, Color badgeColor, List<TwoPointersProblem> problems) {
    final isMobile = Responsive.isMobile(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: badgeColor)),
        const SizedBox(height: 12),
        if (isMobile)
          Column(children: problems.map((p) => _buildProblemCard(p, badgeColor)).toList())
        else
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 480,
              mainAxisExtent: 165, // Increased height to prevent grid card overflow
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
            ),
            itemCount: problems.length,
            itemBuilder: (context, index) => _buildProblemCard(problems[index], badgeColor),
          ),
      ],
    );
  }

  Widget _buildProblemCard(TwoPointersProblem problem, Color color) {
    final isTwoSum = problem.title.contains("Two Sum II");
    final isValidPalindrome = problem.title.contains("Valid Palindrome");
    final isReverseString = problem.title.contains("Reverse String");
    final isMoveZeroes = problem.title.contains("Move Zeroes");
    final isRemoveDuplicatesII =
        problem.title.contains("Remove Duplicates from Sorted Array II");
    final isRemoveDuplicates =
        problem.title.contains("Remove Duplicates from Sorted Array") &&
            !isRemoveDuplicatesII;
    final isSquaresSortedArray =
        problem.title.contains("Squares of a Sorted Array");
    final isMergeSortedArray = problem.title.contains("Merge Sorted Array");
    final isIsSubsequence = problem.title.contains("Is Subsequence");
    final isThreeSumClosest = problem.title.contains("3Sum Closest");
    final isThreeSum =
        problem.title.contains("3Sum") && !isThreeSumClosest;
    final isContainerWithMostWater =
        problem.title.contains("Container With Most Water");
    final isSortColors = problem.title.contains("Sort Colors");
    final hasDedicatedPage = isTwoSum ||
        isValidPalindrome ||
        isReverseString ||
        isMoveZeroes ||
        isRemoveDuplicates ||
        isRemoveDuplicatesII ||
        isSquaresSortedArray ||
        isMergeSortedArray ||
        isIsSubsequence ||
        isThreeSum ||
        isThreeSumClosest ||
        isContainerWithMostWater ||
        isSortColors;

    return InkWell(
      onTap: () {
        if (isTwoSum) {
          Navigator.of(context).pushNamed(AppRoutes.twoSumII);
        } else if (isValidPalindrome) {
          Navigator.of(context).pushNamed(AppRoutes.validPalindrome);
        } else if (isReverseString) {
          Navigator.of(context).pushNamed(AppRoutes.reverseString);
        } else if (isMoveZeroes) {
          Navigator.of(context).pushNamed(AppRoutes.moveZeroes);
        } else if (isRemoveDuplicatesII) {
          Navigator.of(context).pushNamed(AppRoutes.removeDuplicatesII);
        } else if (isRemoveDuplicates) {
          Navigator.of(context).pushNamed(AppRoutes.removeDuplicates);
        } else if (isSquaresSortedArray) {
          Navigator.of(context).pushNamed(AppRoutes.squaresSortedArray);
        } else if (isMergeSortedArray) {
          Navigator.of(context).pushNamed(AppRoutes.mergeSortedArray);
        } else if (isIsSubsequence) {
          Navigator.of(context).pushNamed(AppRoutes.isSubsequence);
        } else if (isThreeSumClosest) {
          Navigator.of(context).pushNamed(AppRoutes.threeSumClosest);
        } else if (isThreeSum) {
          Navigator.of(context).pushNamed(AppRoutes.threeSum);
        } else if (isContainerWithMostWater) {
          Navigator.of(context).pushNamed(AppRoutes.containerWithMostWater);
        } else if (isSortColors) {
          Navigator.of(context).pushNamed(AppRoutes.sortColors);
        }
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppTheme.surfaceDark,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
              color: hasDedicatedPage
                  ? AppTheme.accentNeonCyan
                  : (problem.isPopular
                      ? AppTheme.accentPink
                      : const Color(0xFF334155))),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    problem.title,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: Responsive.sp(context, 15)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                if (hasDedicatedPage)
                  Container(
                    margin: const EdgeInsets.only(right: 4),
                    padding:
                    const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                        color: AppTheme.accentNeonCyan.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10)),
                    child: const Text('🚀 Try Page',
                        style: TextStyle(
                            fontSize: 10,
                            color: AppTheme.accentNeonCyan,
                            fontWeight: FontWeight.bold)),
                  ),
                if (problem.isPopular)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(color: AppTheme.accentPink.withOpacity(0.2), borderRadius: BorderRadius.circular(10)),
                    child: const Text('⭐ FAANG', style: TextStyle(fontSize: 10, color: AppTheme.accentPink, fontWeight: FontWeight.bold)),
                  ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              _isEnglish ? problem.keyIdeaEn : problem.keyIdeaBn,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: AppTheme.textSecondary, fontSize: Responsive.sp(context, 12), height: 1.3),
            ),
            const SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: problem.companyTags.map((tag) {
                  return Container(
                    margin: const EdgeInsets.only(right: 6),
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryDark,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFF334155)),
                    ),
                    child: Text(
                      tag,
                      style: const TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.w500),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoadmapStep(int stepNum, String text) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF334155)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 14,
            backgroundColor: AppTheme.accentPurple,
            child: Text('$stepNum', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(text, style: TextStyle(color: Colors.white, fontSize: Responsive.sp(context, 13), fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}
