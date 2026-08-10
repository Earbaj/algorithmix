import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';
import 'package:algorithmix/ui/features/core_patterns/widgets/space_complexity_code_free_visualizer.dart';
import 'package:text_scroll/text_scroll.dart';

class SpaceComplexityDetailScreen extends StatefulWidget {
  const SpaceComplexityDetailScreen({super.key});

  @override
  State<SpaceComplexityDetailScreen> createState() =>
      _SpaceComplexityDetailScreenState();
}

class _SpaceComplexityDetailScreenState
    extends State<SpaceComplexityDetailScreen>
    with SingleTickerProviderStateMixin {
  bool _isEnglish = true;
  late TabController _tabController;
  String _selectedCodeLang = "C++";

  // Quiz state
  int? _selectedQuizOption;
  bool _quizSubmitted = false;

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

  void _copyToClipboard(String text, String label) {
    Clipboard.setData(ClipboardData(text: text.trim()));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Text(
              _isEnglish
                  ? '$label copied to clipboard!'
                  : '$label কোড ক্লিপবোর্ডে কপি হয়েছে!',
              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ],
        ),
        backgroundColor: AppTheme.accentGreen,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hPadding = Responsive.horizontalPadding(context);

    return Scaffold(
      backgroundColor: AppTheme.primaryDark,
      appBar: AppBar(
        title: Responsive.isMobile(context) ? TextScroll(
          '1.3 Space Complexity & Call Stack',
          mode: TextScrollMode.bouncing, // This makes it go right-to-left, then left-to-right
          velocity: const Velocity(pixelsPerSecond: Offset(50, 0)), // Adjust speed here
          delayBefore: const Duration(seconds: 1), // Waits 1 second before starting
          pauseBetween: const Duration(seconds: 1), // Pauses before bouncing back
          style: TextStyle(
            fontSize: Responsive.sp(context, 16),
            fontWeight: FontWeight.bold,
          ),
        ):Text(
          '1.3 Space Complexity & Call Stack',
          style: TextStyle(
            fontSize: Responsive.sp(context, 16),
            fontWeight: FontWeight.bold,
          ),
        ),
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
                size: Responsive.sp(context, 18),
              ),
              label: Text(
                _isEnglish ? 'EN' : 'BN',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: Responsive.sp(context, 13)),
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
          tabAlignment: TabAlignment.start,
          padding: EdgeInsets.zero,
          labelStyle: TextStyle(
              fontSize: Responsive.sp(context, 14), fontWeight: FontWeight.bold),
          unselectedLabelStyle:
              TextStyle(fontSize: Responsive.sp(context, 13)),
          tabs: [
            Tab(text: _isEnglish ? '📘 Concept Breakdown' : '📘 কনসেপ্ট বিশ্লেষণ'),
            Tab(text: _isEnglish ? '🎨 Code-Free Visualizer' : '🎨 কোডহীন ভিজ্যুয়াল গাইড'),
            Tab(text: _isEnglish ? '⚡ Code Trace' : '⚡ কোড ট্রেস'),
            Tab(text: _isEnglish ? '💡 Quiz & Solutions' : '💡 কুইজ ও সমাধান'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildConceptTab(hPadding),
          _buildVisualizerTab(hPadding),
          _buildCodeTraceTab(hPadding),
          _buildQuizTab(hPadding),
        ],
      ),
    );
  }

  Widget _buildConceptTab(double hPadding) {
    return ResponsiveCenter(
      maxWidth: 1280.0,
      padding: EdgeInsets.all(hPadding),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(Responsive.sp(context, 18)),
              decoration: BoxDecoration(
                color: AppTheme.surfaceDark,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.accentNeonCyan.withOpacity(0.4)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _isEnglish
                        ? 'Space Complexity & Recursion Call Stack'
                        : 'স্পেস কমপ্লেক্সিটি ও রিকার্শন কল স্ট্যাক',
                    style: TextStyle(
                      fontSize: Responsive.sp(context, 18),
                      fontWeight: FontWeight.bold,
                      color: AppTheme.accentNeonCyan,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _isEnglish
                        ? 'Space Complexity measures the total memory occupied by an algorithm, consisting of Auxiliary Space (extra data structures) and Call Stack Overhead (recursion frames).'
                        : 'স্পেস কমপ্লেক্সিটি অ্যালগরিদম দ্বারা ব্যবহৃত মোট মেমোরি পরিমাপ করে, যা অক্সিলিয়ারি স্পেস ও রিকার্শন স্ট্যাক ওভারহেডের সমষ্টি।',
                    style: TextStyle(
                      fontSize: Responsive.sp(context, 13.5),
                      color: AppTheme.textSecondary,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildVisualizerTab(double hPadding) {
    return ResponsiveCenter(
      maxWidth: 1280.0,
      padding: EdgeInsets.all(hPadding),
      child: SpaceComplexityCodeFreeVisualizer(isEnglish: _isEnglish),
    );
  }

  Widget _buildCodeTraceTab(double hPadding) {
    String code = """
// Recursive Call Stack Trace: O(N) Space Complexity
int factorial(int n) {
    if (n <= 1) return 1; // Base case
    return n * factorial(n - 1); // Depth n call stack memory
}""";

    return ResponsiveCenter(
      maxWidth: 1280.0,
      padding: EdgeInsets.all(hPadding),
      child: Container(
        padding: EdgeInsets.all(Responsive.sp(context, 14)),
        decoration: BoxDecoration(
          color: const Color(0xFF090D16),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF1E293B)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Recursive Stack Code Trace",
                    style: const TextStyle(
                        color: AppTheme.accentNeonCyan,
                        fontWeight: FontWeight.bold)),
                ElevatedButton.icon(
                  onPressed: () => _copyToClipboard(code, "Code Trace"),
                  icon: const Icon(Icons.copy, size: 14),
                  label: Text(_isEnglish ? "Copy" : "কপি"),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.accentPurple),
                ),
              ],
            ),
            const SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Text(code.trim(),
                  style: const TextStyle(
                      fontFamily: 'monospace', color: Color(0xFF38BDF8))),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuizTab(double hPadding) {
    return ResponsiveCenter(
      maxWidth: 1280.0,
      padding: EdgeInsets.all(hPadding),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(Responsive.sp(context, 18)),
              decoration: BoxDecoration(
                color: AppTheme.surfaceDark,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                    color: _quizSubmitted
                        ? AppTheme.accentGreen
                        : AppTheme.accentPurple),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _isEnglish
                        ? "🧠 Interactive Quiz: Space Complexity"
                        : "🧠 ইন্টারেক্টিভ কুইজ: স্পেস কমপ্লেক্সিটি",
                    style: TextStyle(
                        fontSize: Responsive.sp(context, 16),
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _isEnglish
                        ? "What is the memory space complexity of a recursive algorithm with depth N?"
                        : "N গভীরতার একটি রিকার্সিভ অ্যালগরিদমের মেমোরি স্পেস কমপ্লেক্সিটি কত?",
                    style: TextStyle(
                        fontSize: Responsive.sp(context, 13.5),
                        color: AppTheme.textSecondary),
                  ),
                  const SizedBox(height: 14),

                  ...List.generate(4, (idx) {
                    final options = ["O(1)", "O(log N)", "O(N)", "O(N^2)"];
                    final isSel = _selectedQuizOption == idx;
                    final isCorrectOpt = idx == 2;

                    Color bg = AppTheme.primaryDark;
                    Color border = const Color(0xFF334155);

                    if (_quizSubmitted) {
                      if (isCorrectOpt) {
                        bg = AppTheme.accentGreen.withOpacity(0.2);
                        border = AppTheme.accentGreen;
                      } else if (isSel) {
                        bg = AppTheme.accentPink.withOpacity(0.2);
                        border = AppTheme.accentPink;
                      }
                    } else if (isSel) {
                      bg = AppTheme.accentPurple.withOpacity(0.3);
                      border = AppTheme.accentPurple;
                    }

                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: InkWell(
                        onTap: _quizSubmitted
                            ? null
                            : () => setState(() => _selectedQuizOption = idx),
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: bg,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: border),
                          ),
                          child: Row(
                            children: [
                              Text("${String.fromCharCode(65 + idx)}) ",
                                  style: const TextStyle(
                                      color: AppTheme.accentNeonCyan,
                                      fontWeight: FontWeight.bold)),
                              Expanded(
                                child: Text(options[idx],
                                    style: const TextStyle(color: Colors.white)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                  const SizedBox(height: 12),

                  if (!_quizSubmitted)
                    ElevatedButton(
                      onPressed: _selectedQuizOption == null
                          ? null
                          : () {
                              setState(() {
                                _quizSubmitted = true;
                              });
                            },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.accentPurple),
                      child: Text(_isEnglish ? "Submit Answer" : "উত্তর সাবমিট করুন"),
                    )
                  else
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryDark,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        _isEnglish
                            ? "💡 Each recursive step allocates a stack frame resulting in O(N) space."
                            : "💡 প্রতিটি রিকার্সিভ কলের জন্য স্ট্যাক ফ্রেম বরাদ্দ হয়ে O(N) স্পেস লাগে।",
                        style: const TextStyle(color: AppTheme.accentNeonCyan),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
