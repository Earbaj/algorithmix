import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';
import 'package:algorithmix/ui/features/core_patterns/widgets/complexity_classes_code_free_visualizer.dart';

class ComplexityClassesDetailScreen extends StatefulWidget {
  const ComplexityClassesDetailScreen({super.key});

  @override
  State<ComplexityClassesDetailScreen> createState() =>
      _ComplexityClassesDetailScreenState();
}

class _ComplexityClassesDetailScreenState
    extends State<ComplexityClassesDetailScreen>
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
          '1.2 Common Complexity Classes',
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
          labelStyle: TextStyle(
              fontSize: Responsive.sp(context, 14), fontWeight: FontWeight.bold),
          unselectedLabelStyle:
              TextStyle(fontSize: Responsive.sp(context, 13)),
          tabs: [
            Tab(text: _isEnglish ? '📘 Concept Hierarchy' : '📘 ধারণা ও র‍্যাঙ্কিং'),
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
                        ? 'Common Complexity Classes Ranking'
                        : 'সাধারণ কমপ্লেক্সিটি ক্লাস র‍্যাঙ্কিং',
                    style: TextStyle(
                      fontSize: Responsive.sp(context, 18),
                      fontWeight: FontWeight.bold,
                      color: AppTheme.accentNeonCyan,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _isEnglish
                        ? 'Algorithms are grouped into Big O complexity classes based on how their execution steps scale relative to N.\n\nRanking (Fastest -> Slowest):\nO(1) < O(log N) < O(N) < O(N log N) < O(N²) < O(2ᴺ) < O(N!)'
                        : 'অ্যালগরিদমের কার্যক্ষমতা N এর সাথে কীভাবে বাড়ে তার উপর ভিত্তি করে বিগ ও ক্লাসে ভাগ করা হয়।\n\nগতি অনুসারে ক্রমানুসার:\nO(1) < O(log N) < O(N) < O(N log N) < O(N²) < O(2ᴺ) < O(N!)',
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
      child: ComplexityClassesCodeFreeVisualizer(isEnglish: _isEnglish),
    );
  }

  Widget _buildCodeTraceTab(double hPadding) {
    String code = """
// Complexity Classes Code Trace
void demoClasses(int n) {
    int val = n * 2;                 // O(1)
    int low = 0, high = n;           // O(log N) Binary Search
    for (int i = 0; i < n; i++) {}   // O(N) Linear
    // Merge Sort                    // O(N log N)
    for (int i=0; i<n; i++)          // O(N^2) Quadratic
        for (int j=0; j<n; j++) {}
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
                Text("Complexity Code Trace",
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
                        ? "🧠 Interactive Quiz: Complexity Hierarchy"
                        : "🧠 ইন্টারেক্টিভ কুইজ: কমপ্লেক্সিটি র‍্যাঙ্কিং",
                    style: TextStyle(
                        fontSize: Responsive.sp(context, 16),
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _isEnglish
                        ? "Which complexity scales fastest and is preferred for sorting up to 10^6 items?"
                        : "১০^৬ টি উপাদান সর্ট করার জন্য সবচেয়ে কার্যকর টাইম কমপ্লেক্সিটি কোনটি?",
                    style: TextStyle(
                        fontSize: Responsive.sp(context, 13.5),
                        color: AppTheme.textSecondary),
                  ),
                  const SizedBox(height: 14),

                  ...List.generate(4, (idx) {
                    final options = ["O(N^2)", "O(N log N)", "O(2^N)", "O(N!)"];
                    final isSel = _selectedQuizOption == idx;
                    final isCorrectOpt = idx == 1;

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
                            ? "💡 O(N log N) is optimal for comparison sorting."
                            : "💡 O(N log N) কম্পারিজন সর্টিংয়ের জন্য সেরা।",
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
