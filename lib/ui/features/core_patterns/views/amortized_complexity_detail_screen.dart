import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';
import 'package:algorithmix/ui/features/core_patterns/widgets/amortized_complexity_code_free_visualizer.dart';
import 'package:text_scroll/text_scroll.dart';

class AmortizedComplexityDetailScreen extends StatefulWidget {
  const AmortizedComplexityDetailScreen({super.key});

  @override
  State<AmortizedComplexityDetailScreen> createState() =>
      _AmortizedComplexityDetailScreenState();
}

class _AmortizedComplexityDetailScreenState
    extends State<AmortizedComplexityDetailScreen>
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
          '1.5 Amortized Complexity Analysis',
          mode: TextScrollMode.bouncing, // This makes it go right-to-left, then left-to-right
          velocity: const Velocity(pixelsPerSecond: Offset(50, 0)), // Adjust speed here
          delayBefore: const Duration(seconds: 1), // Waits 1 second before starting
          pauseBetween: const Duration(seconds: 1), // Pauses before bouncing back
          style: TextStyle(
            fontSize: Responsive.sp(context, 16),
            fontWeight: FontWeight.bold,
          ),
        ) : Text(
          '1.5 Amortized Complexity Analysis',
          style: TextStyle(
            fontSize: Responsive.sp(context, 16),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: AppTheme.accentPurple.withOpacity(0.2),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: Text(
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
                        ? 'Amortized Complexity Analysis'
                        : 'অ্যামোরটাইজড কমপ্লেক্সিটি অ্যানালাইসিস',
                    style: TextStyle(
                      fontSize: Responsive.sp(context, 18),
                      fontWeight: FontWeight.bold,
                      color: AppTheme.accentNeonCyan,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _isEnglish
                        ? 'Amortized analysis calculates the average time per operation over a worst-case sequence of operations, even if one single operation is expensive (e.g. array doubling).'
                        : 'অ্যামোরটাইজড অ্যানালাইসিস একক অপারেশনে বেশি সময় লাগলেও টানা অনেকগুলো অপারেশনের গড়ে অর্জিত সময় পরিমাপ করে (যেমন ডায়নামিক অ্যারে মেমোরি ডাবলিং)।',
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
      child: AmortizedComplexityCodeFreeVisualizer(isEnglish: _isEnglish),
    );
  }

  Widget _buildCodeTraceTab(double hPadding) {
    String code = """
// Dynamic Vector Push Back Trace
vector<int> dynamicArray;
for (int i = 0; i < n; i++) {
    dynamicArray.push_back(i); // Amortized O(1) constant time
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
                Text("Amortized Push Code Trace",
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
                        ? "🧠 Interactive Quiz: Amortized Complexity"
                        : "🧠 ইন্টারেক্টিভ কুইজ: অ্যামোরটাইজড কমপ্লেক্সিটি",
                    style: TextStyle(
                        fontSize: Responsive.sp(context, 16),
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _isEnglish
                        ? "What is the average amortized time complexity per insertion in a dynamic vector?"
                        : "ডায়নামিক ভেক্টরে প্রতি ইনসার্শনের গড়ে অ্যামোরটাইজড টাইম কমপ্লেক্সিটি কত?",
                    style: TextStyle(
                        fontSize: Responsive.sp(context, 13.5),
                        color: AppTheme.textSecondary),
                  ),
                  const SizedBox(height: 14),

                  ...List.generate(4, (idx) {
                    final options = ["O(1) amortized", "O(N)", "O(N^2)", "O(log N)"];
                    final isSel = _selectedQuizOption == idx;
                    final isCorrectOpt = idx == 0;

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
                            ? "💡 Total copy cost over N insertions is O(N), so average is O(1)."
                            : "💡 N ইনসার্শনে মোট কপি খরচ O(N), তাই গড় O(1)।",
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
