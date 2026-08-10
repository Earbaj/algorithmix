import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';
import 'package:algorithmix/ui/features/core_patterns/widgets/asymptotic_notations_code_free_visualizer.dart';
import 'package:text_scroll/text_scroll.dart';

class AsymptoticNotationsDetailScreen extends StatefulWidget {
  const AsymptoticNotationsDetailScreen({super.key});

  @override
  State<AsymptoticNotationsDetailScreen> createState() =>
      _AsymptoticNotationsDetailScreenState();
}

class _AsymptoticNotationsDetailScreenState
    extends State<AsymptoticNotationsDetailScreen>
    with SingleTickerProviderStateMixin {
  bool _isEnglish = true;
  late TabController _tabController;
  String _selectedCodeLang = "C++";

  // Quiz state
  int? _selectedQuizOption;
  bool _quizSubmitted = false;
  bool _isCorrect = false;

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
          '1.1 Asymptotic Notations (Big O, Ω, Θ)',
          mode: TextScrollMode.bouncing, // This makes it go right-to-left, then left-to-right
          velocity: const Velocity(pixelsPerSecond: Offset(50, 0)), // Adjust speed here
          delayBefore: const Duration(seconds: 1), // Waits 1 second before starting
          pauseBetween: const Duration(seconds: 1), // Pauses before bouncing back
          style: TextStyle(
            fontSize: Responsive.sp(context, 16),
            fontWeight: FontWeight.bold,
          ),
        ):Text(
          '1.1 Asymptotic Notations (Big O, Ω, Θ)',
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
            Tab(text: _isEnglish ? '⚡ Dynamic Code Trace' : '⚡ ডায়নামিক কোড ট্রেস'),
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

  // TAB 1: Concept
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
                        ? 'Asymptotic Notations (O, Ω, Θ)'
                        : 'অ্যাসিম্পটোটিক নোটেশন (O, Ω, Θ)',
                    style: TextStyle(
                      fontSize: Responsive.sp(context, 18),
                      fontWeight: FontWeight.bold,
                      color: AppTheme.accentNeonCyan,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _isEnglish
                        ? 'Asymptotic notations are mathematical frameworks used to analyze the growth rate of an algorithm\'s runtime or space usage as the input size N grows arbitrarily large (towards infinity).'
                        : 'অ্যাসিম্পটোটিক নোটেশন হলো গাণিতিক ফ্রেমওয়ার্ক যা ইনপুট সাইজ N অসীমের দিকে বৃদ্ধি পাওয়ার সাথে অ্যালগরিদমের রানটাইম বা স্পেসের গ্রোথ রেট বিশ্লেষণ করতে ব্যবহৃত হয়।',
                    style: TextStyle(
                      fontSize: Responsive.sp(context, 14),
                      color: AppTheme.textSecondary,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            _buildNotationDetailCard(
              "1. Big O Notation (O)",
              _isEnglish ? "Upper Bound / Worst Case" : "আপার বাউন্ড / ওয়ার্স্ট কেস",
              AppTheme.accentPink,
              _isEnglish
                  ? "• Guarantees that the algorithm will NEVER exceed this operation growth rate.\n• Definition: f(n) <= c * g(n) for all n >= n0.\n• Example: Linear Search worst case is O(N)."
                  : "• গ্যারান্টি দেয় যে অ্যালগরিদম কখনোই এই গ্রোথ রেট অতিক্রম করবে না।\n• সংজ্ঞা: f(n) <= c * g(n) যখন n >= n0।\n• উদাহরণ: লিনিয়ার সার্চের ওয়ার্স্ট কেস O(N)।",
            ),
            const SizedBox(height: 12),

            _buildNotationDetailCard(
              "2. Big Omega Notation (Ω)",
              _isEnglish ? "Lower Bound / Best Case" : "লোয়ার বাউন্ড / বেস্ট কেস",
              AppTheme.accentGreen,
              _isEnglish
                  ? "• Represents the minimum number of operations an algorithm must perform.\n• Definition: f(n) >= c * g(n) for all n >= n0.\n• Example: Linear Search best case is Ω(1) if target is at index 0."
                  : "• অ্যালগরিদমের প্রয়োজনীয় সর্বনিম্ন অপারেশনের সংখ্যা নির্দেশ করে।\n• সংজ্ঞা: f(n) >= c * g(n) যখন n >= n0।\n• উদাহরণ: লিনিয়ার সার্চের বেস্ট কেস Ω(1) যদি টার্গেট শুরুতে থাকে।",
            ),
            const SizedBox(height: 12),

            _buildNotationDetailCard(
              "3. Big Theta Notation (Θ)",
              _isEnglish ? "Tight Bound / Exact Case" : "টাইট বাউন্ড / অ্যাকচুয়াল কেস",
              AppTheme.accentNeonCyan,
              _isEnglish
                  ? "• Bounds the function both from above and below within constant factors.\n• Definition: c1 * g(n) <= f(n) <= c2 * g(n).\n• Example: Merge Sort is ALWAYS Θ(N log N) in all cases."
                  : "• অ্যালগরিদমকে উপরে ও নিচে একই গ্রোথ রেটে সীমাবদ্ধ রাখে।\n• সংজ্ঞা: c1 * g(n) <= f(n) <= c2 * g(n)।\n• উদাহরণ: মার্জ সর্ট সব কেসেই Θ(N log N)।",
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildNotationDetailCard(
      String title, String badge, Color color, String desc) {
    return Container(
      padding: EdgeInsets.all(Responsive.sp(context, 16)),
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyle(
                  fontSize: Responsive.sp(context, 15),
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
          const SizedBox(height: 10,),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: color),
            ),
            child: Text(badge,
                style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.bold,
                    fontSize: Responsive.sp(context, 11))),
          ),
          const SizedBox(height: 10),
          Text(desc,
              style: TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: Responsive.sp(context, 13),
                  height: 1.45)),
        ],
      ),
    );
  }

  // TAB 2: Visualizer
  Widget _buildVisualizerTab(double hPadding) {
    return ResponsiveCenter(
      maxWidth: 1280.0,
      padding: EdgeInsets.all(hPadding),
      child: AsymptoticNotationsCodeFreeVisualizer(isEnglish: _isEnglish),
    );
  }

  // TAB 3: Code Trace
  Widget _buildCodeTraceTab(double hPadding) {
    return ResponsiveCenter(
      maxWidth: 1280.0,
      padding: EdgeInsets.all(hPadding),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "C++ Trace: Asymptotic Notation Boundaries",
              style: TextStyle(
                  color: AppTheme.accentNeonCyan,
                  fontWeight: FontWeight.bold,
                  fontSize: Responsive.sp(context, 16)),
            ),
            const SizedBox(height: 12),
            _buildFullCodeSnippet(_selectedCodeLang),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // TAB 4: Quiz & Solution Code
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
                        ? (_isCorrect ? AppTheme.accentGreen : AppTheme.accentPink)
                        : AppTheme.accentPurple),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _isEnglish
                        ? "🧠 Interactive Quiz: Asymptotic Notations"
                        : "🧠 ইন্টারেক্টিভ কুইজ: অ্যাসিম্পটোটিক নোটেশন",
                    style: TextStyle(
                        fontSize: Responsive.sp(context, 16),
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _isEnglish
                        ? "Which notation represents the tight bound where an algorithm is bounded both above and below by the same rate?"
                        : "কোন নোটেশনটি টাইট বাউন্ড প্রকাশ করে যেখানে অ্যালগরিদম উপর ও নিচে একই গ্রোথ রেটে সীমাবদ্ধ থাকে?",
                    style: TextStyle(
                        fontSize: Responsive.sp(context, 13.5),
                        color: AppTheme.textSecondary),
                  ),
                  const SizedBox(height: 14),

                  ...List.generate(4, (idx) {
                    final options = ["Big O (O)", "Big Omega (Ω)", "Big Theta (Θ)", "Alpha (α)"];
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
                                _isCorrect = _selectedQuizOption == 2;
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
                            ? "💡 Big Theta (Θ) represents the exact tight bound."
                            : "💡 বিগ থিটা (Θ) নিখুঁত টাইট বাউন্ড নির্দেশ করে।",
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

  Widget _buildFullCodeSnippet(String lang) {
    String code = """
// Asymptotic Notation Code Trace
void analyzeAsymptoticBounds(int n) {
    // Upper Bound O(N^2)
    for (int i = 0; i < n; i++) {
        for (int j = 0; j < n; j++) {
            // Execution count: n * n
        }
    }
}""";

    return Container(
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
              Text("$lang Code Trace",
                  style: const TextStyle(
                      color: AppTheme.accentNeonCyan,
                      fontWeight: FontWeight.bold)),
              ElevatedButton.icon(
                onPressed: () => _copyToClipboard(code, "$lang Trace"),
                icon: const Icon(Icons.copy, size: 14),
                label: Text(_isEnglish ? "Copy" : "কপি"),
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.accentPurple),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Text(
              code.trim(),
              style: const TextStyle(
                  fontFamily: 'monospace', color: Color(0xFF38BDF8)),
            ),
          ),
        ],
      ),
    );
  }
}
