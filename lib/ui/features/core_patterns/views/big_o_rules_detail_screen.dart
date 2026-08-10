import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';
import 'package:algorithmix/ui/features/core_patterns/widgets/big_o_rules_code_free_visualizer.dart';

class BigORulesDetailScreen extends StatefulWidget {
  const BigORulesDetailScreen({super.key});

  @override
  State<BigORulesDetailScreen> createState() => _BigORulesDetailScreenState();
}

class _BigORulesDetailScreenState extends State<BigORulesDetailScreen>
    with SingleTickerProviderStateMixin {
  bool _isEnglish = true;
  late TabController _tabController;
  String _selectedCodeLang = "C++";

  // Quiz State
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
        title: Text(
          '1.4 Four Core Rules for Big O',
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
            Tab(text: _isEnglish ? '📘 Rules Breakdown' : '📘 নিয়মাবলী বিশ্লেষণ'),
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
                        ? 'Four Core Rules for Big O Calculation'
                        : 'বিগ ও (Big O) হিসাবের ৪টি মৌলিক নিয়ম',
                    style: TextStyle(
                      fontSize: Responsive.sp(context, 18),
                      fontWeight: FontWeight.bold,
                      color: AppTheme.accentNeonCyan,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _isEnglish
                        ? '1. Drop Constants: O(2N) -> O(N)\n2. Drop Non-Dominant Terms: O(N² + N) -> O(N²)\n3. Additive Sequential Code Blocks: O(A) + O(B) -> O(A + B)\n4. Multiplicative Nested Loops: for A { for B } -> O(A * B)'
                        : '১. কনস্ট্যান্ট বাদ দিন: O(2N) -> O(N)\n২. অপ্রধান পদ বাদ দিন: O(N² + N) -> O(N²)\n৩. আলাদা লুপ যোগ হবে: O(A) + O(B) -> O(A + B)\n৪. নেসটেড লুপ গুণ হবে: for A { for B } -> O(A * B)',
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
      child: BigORulesCodeFreeVisualizer(isEnglish: _isEnglish),
    );
  }

  Widget _buildCodeTraceTab(double hPadding) {
    String code = """
// 4 Rules Big O Code Trace
void calculateRules(vector<int>& a, vector<int>& b) {
    // Rule 3 Additive: O(A) + O(B)
    for (int x : a) cout << x;
    for (int y : b) cout << y;
    
    // Rule 4 Multiplicative: O(A * B)
    for (int x : a) {
        for (int y : b) {
            cout << x << y;
        }
    }
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
                Text("4 Rules Code Trace",
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
                        ? "🧠 Interactive Quiz: Big O Rules"
                        : "🧠 ইন্টারেক্টিভ কুইজ: বিগ ও হিসাবের নিয়ম",
                    style: TextStyle(
                        fontSize: Responsive.sp(context, 16),
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _isEnglish
                        ? "What is the simplified Big O for an expression O(N^2 + 50N + 1000)?"
                        : "সমীকরণ O(N^2 + 50N + 1000) এর সরলীকৃত বিগ ও কত হবে?",
                    style: TextStyle(
                        fontSize: Responsive.sp(context, 13.5),
                        color: AppTheme.textSecondary),
                  ),
                  const SizedBox(height: 14),

                  ...List.generate(4, (idx) {
                    final options = ["O(N)", "O(50N)", "O(N^2)", "O(N^3)"];
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
                            ? "💡 Drop non-dominant terms and constants to get O(N^2)."
                            : "💡 কনস্ট্যান্ট ও ছোট পদ বাদ দিলে O(N^2) পাওয়া যায়।",
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
