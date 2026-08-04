import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';
import 'package:algorithmix/ui/features/core_patterns/widgets/min_window_substring_code_free_visualizer.dart';

class MinWindowStep {
  final int left;
  final int right;
  final int formed;
  final int required;
  final int activeLine;
  final String currentWindowStr;
  final String bestWindowStr;
  final int bestLen;
  final String s;
  final String t;
  final String actionEn;
  final String actionBn;
  final String reasonEn;
  final String reasonBn;
  final bool isFinish;

  const MinWindowStep({
    required this.left,
    required this.right,
    required this.formed,
    required this.required,
    required this.activeLine,
    required this.currentWindowStr,
    required this.bestWindowStr,
    required this.bestLen,
    required this.s,
    required this.t,
    required this.actionEn,
    required this.actionBn,
    required this.reasonEn,
    required this.reasonBn,
    this.isFinish = false,
  });
}

class MinWindowSubstringDetailScreen extends StatefulWidget {
  const MinWindowSubstringDetailScreen({super.key});

  @override
  State<MinWindowSubstringDetailScreen> createState() =>
      _MinWindowSubstringDetailScreenState();
}

class _MinWindowSubstringDetailScreenState
    extends State<MinWindowSubstringDetailScreen>
    with SingleTickerProviderStateMixin {
  bool _isEnglish = true;
  late TabController _tabController;

  // Custom Input State
  final TextEditingController _sController =
      TextEditingController(text: "ADOBECODEBANC");
  final TextEditingController _tController =
      TextEditingController(text: "ABC");

  String _currentS = "ADOBECODEBANC";
  String _currentT = "ABC";
  List<MinWindowStep> _steps = [];

  // Playback Control
  int _currentStepIndex = 0;
  bool _isPlaying = false;
  Timer? _timer;

  // Practice Mode State
  bool _showAnswer = false;
  int _userLeft = 0;
  int _userRight = 0;
  int _userFormed = 0;
  int _userRequired = 0;
  String _userBestWindow = "";
  String _userFeedbackEn = "Expand right until all chars in t are included, then shrink left!";
  String _userFeedbackBn = "t এর সকল অক্ষর না আসা পর্যন্ত right সরান, তারপর left কমান!";
  bool _userSolved = false;
  String _selectedCodeLang = "C++";

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _rebuildSteps();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _timer?.cancel();
    _sController.dispose();
    _tController.dispose();
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

  void _rebuildSteps() {
    _timer?.cancel();
    _isPlaying = false;
    _currentStepIndex = 0;

    String s = _sController.text.trim();
    String t = _tController.text.trim();
    if (s.isEmpty) s = "ADOBECODEBANC";
    if (t.isEmpty) t = "ABC";

    _currentS = s;
    _currentT = t;

    _userLeft = 0;
    _userRight = 0;
    _userFormed = 0;
    _userBestWindow = "";
    _userSolved = false;
    _userFeedbackEn = "Start sliding window search!";
    _userFeedbackBn = "স্লাইডিং উইন্ডো সার্চ শুরু করুন!";

    _steps = _generateSteps(_currentS, _currentT);
    setState(() {});
  }

  List<MinWindowStep> _generateSteps(String s, String t) {
    List<MinWindowStep> steps = [];
    if (s.isEmpty || t.isEmpty) return steps;

    Map<String, int> tMap = {};
    for (int i = 0; i < t.length; i++) {
      String ch = t[i];
      tMap[ch] = (tMap[ch] ?? 0) + 1;
    }
    int required = tMap.length;

    Map<String, int> windowMap = {};
    int formed = 0;
    int left = 0;
    int minLen = 999999;
    String bestWindow = "";

    // Line 2: Init
    steps.add(MinWindowStep(
      left: 0,
      right: 0,
      formed: 0,
      required: required,
      activeLine: 2,
      currentWindowStr: s[0],
      bestWindowStr: "",
      bestLen: 0,
      s: s,
      t: t,
      actionEn: "Line 2: Build target tMap for '$t' (Required = $required)",
      actionBn: "লাইন ২: টার্গেট '$t' এর জন্য ফ্রিকোয়েন্সি ম্যাপ প্রস্তুত (Required = $required)",
      reasonEn: "Frequency map created for target string '$t'.",
      reasonBn: "টার্গেট স্ট্রিং '$t' এর অক্ষরের ফ্রিকোয়েন্সি ম্যাপ তৈরি হলো।",
    ));

    for (int right = 0; right < s.length; right++) {
      String charR = s[right];
      windowMap[charR] = (windowMap[charR] ?? 0) + 1;

      if (tMap.containsKey(charR) && windowMap[charR] == tMap[charR]) {
        formed++;
      }

      String curWin = s.substring(left, right + 1);

      steps.add(MinWindowStep(
        left: left,
        right: right,
        formed: formed,
        required: required,
        activeLine: 6,
        currentWindowStr: curWin,
        bestWindowStr: bestWindow,
        bestLen: minLen == 999999 ? 0 : minLen,
        s: s,
        t: t,
        actionEn: "Line 6: Expand right to $right ('$charR') → Window '$curWin'",
        actionBn: "লাইন ৬: right বাড়িয়ে $right ('$charR') করা হলো → উইন্ডো '$curWin'",
        reasonEn: "Added '$charR' at right. Formed = $formed / $required.",
        reasonBn: "'$charR' যুক্ত করা হলো। সন্তুষ্ট অক্ষর = $formed / $required।",
      ));

      while (left <= right && formed == required) {
        curWin = s.substring(left, right + 1);
        int curLen = curWin.length;

        if (curLen < minLen) {
          minLen = curLen;
          bestWindow = curWin;
        }

        steps.add(MinWindowStep(
          left: left,
          right: right,
          formed: formed,
          required: required,
          activeLine: 9,
          currentWindowStr: curWin,
          bestWindowStr: bestWindow,
          bestLen: minLen,
          s: s,
          t: t,
          actionEn: "Line 9: formed == required 🎉 Valid Window '$curWin' (Len $curLen) → Best = '$bestWindow'",
          actionBn: "লাইন ৯: formed == required 🎉 ভ্যালিড উইন্ডো '$curWin' (দৈর্ঘ্য $curLen) → সেরা = '$bestWindow'",
          reasonEn: "Current window covers all chars of '$t'. Shrink left pointer to minimize length.",
          reasonBn: "উইন্ডোটি '$t' কে পুরোপুরি ধারণ করেছে। ছোট করতে left++ কমান।",
        ));

        String charL = s[left];
        windowMap[charL] = windowMap[charL]! - 1;
        if (tMap.containsKey(charL) && windowMap[charL]! < tMap[charL]!) {
          formed--;
        }
        left++;
      }
    }

    // Line 15: Finish
    steps.add(MinWindowStep(
      left: left,
      right: s.length - 1,
      formed: formed,
      required: required,
      activeLine: 15,
      currentWindowStr: bestWindow,
      bestWindowStr: bestWindow,
      bestLen: bestWindow.isEmpty ? 0 : bestWindow.length,
      s: s,
      t: t,
      actionEn: "Line 15: return bestWindow 🎉 Minimum Window = '$bestWindow'",
      actionBn: "লাইন ১৫: return bestWindow 🎉 ক্ষুদ্রতম উইন্ডো = '$bestWindow'",
      reasonEn: "Algorithm completed in O(|S| + |T|) linear time!",
      reasonBn: "O(|S| + |T|) সময়াধিক্যে অ্যালগরিদম সম্পন্ন!",
      isFinish: true,
    ));

    return steps;
  }

  void _togglePlay() {
    setState(() {
      _isPlaying = !_isPlaying;
    });

    if (_isPlaying) {
      _timer = Timer.periodic(const Duration(milliseconds: 1500), (timer) {
        if (_currentStepIndex < _steps.length - 1) {
          setState(() {
            _currentStepIndex++;
          });
        } else {
          _timer?.cancel();
          setState(() {
            _isPlaying = false;
          });
        }
      });
    } else {
      _timer?.cancel();
    }
  }

  void _loadPreset(String s, String t) {
    _sController.text = s;
    _tController.text = t;
    _rebuildSteps();
  }

  void _handleUserAction(String action) {
    if (_userSolved) return;

    final s = _currentS;
    final t = _currentT;

    Map<String, int> tMap = {};
    for (int i = 0; i < t.length; i++) {
      tMap[t[i]] = (tMap[t[i]] ?? 0) + 1;
    }
    int required = tMap.length;

    Map<String, int> windowMap = {};
    for (int i = _userLeft; i <= _userRight && i < s.length; i++) {
      windowMap[s[i]] = (windowMap[s[i]] ?? 0) + 1;
    }

    int formed = 0;
    tMap.forEach((k, v) {
      if ((windowMap[k] ?? 0) >= v) formed++;
    });

    setState(() {
      if (action == "expand") {
        if (_userRight < s.length - 1) {
          _userRight++;
          String win = s.substring(_userLeft, _userRight + 1);
          _userFeedbackEn = "Expanded right to $_userRight. Current Window: '$win'.";
          _userFeedbackBn = "right বাড়িয়ে $_userRight করা হলো। বর্তমান উইন্ডো: '$win'।";
        } else {
          _userSolved = true;
          _userFeedbackEn = "Reached end of string s!";
          _userFeedbackBn = "স্ট্রিং s এর শেষ মাথায় পৌঁছে গেছেন!";
        }
      } else if (action == "shrink") {
        if (_userLeft < _userRight) {
          _userLeft++;
          String win = s.substring(_userLeft, _userRight + 1);
          _userFeedbackEn = "Shrunk left to $_userLeft. Current Window: '$win'.";
          _userFeedbackBn = "left কমিয়ে $_userLeft করা হলো। বর্তমান উইন্ডো: '$win'।";
        }
      }

      if (formed == required) {
        String win = s.substring(_userLeft, _userRight + 1);
        if (_userBestWindow.isEmpty || win.length < _userBestWindow.length) {
          _userBestWindow = win;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final hPadding = Responsive.horizontalPadding(context);

    return Scaffold(
      backgroundColor: AppTheme.primaryDark,
      appBar: AppBar(
        title: Text(
          '76. Minimum Window Substring',
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
            Tab(text: _isEnglish ? '📘 Problem Description' : '📘 প্রবলেম বিবরণ'),
            Tab(text: _isEnglish ? '🎨 Code-Free Animation' : '🎨 কোডহীন ভিজ্যুয়াল গাইড'),
            Tab(text: _isEnglish ? '⚡ Dynamic Visualizer' : '⚡ কাস্টম ইনপুট ও ভিজ্যুয়ালাইজার'),
            Tab(text: _isEnglish ? '💡 Practice & Answer' : '💡 প্র্যাকটিস ও উত্তর'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildProblemDescriptionTab(hPadding),
          _buildCodeFreeVisualizerTab(hPadding),
          _buildVisualizerTab(hPadding),
          _buildPracticeAndAnswerTab(hPadding),
        ],
      ),
    );
  }

  // TAB 1: Problem Description
  Widget _buildProblemDescriptionTab(double hPadding) {
    return ResponsiveCenter(
      maxWidth: 1280.0,
      padding: EdgeInsets.all(hPadding),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.accentPink.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppTheme.accentPink),
                  ),
                  child: Text(
                    '🔴 Hard',
                    style: TextStyle(
                        color: AppTheme.accentPink,
                        fontWeight: FontWeight.bold,
                        fontSize: Responsive.sp(context, 12)),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.accentPurple.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppTheme.accentPurple),
                  ),
                  child: Text(
                    'LeetCode #76',
                    style: TextStyle(
                        color: AppTheme.accentNeonCyan,
                        fontWeight: FontWeight.bold,
                        fontSize: Responsive.sp(context, 12)),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.accentGreen.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppTheme.accentGreen),
                  ),
                  child: Text(
                    '⭐ Sliding Window + Frequency Map',
                    style: TextStyle(
                        color: AppTheme.accentGreen,
                        fontWeight: FontWeight.bold,
                        fontSize: Responsive.sp(context, 12)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              _isEnglish
                  ? 'Minimum Window Substring'
                  : 'মিনিমাম উইন্ডো সাবস্ট্রিং (Minimum Window Substring)',
              style: TextStyle(
                fontSize: Responsive.sp(context, 20),
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),

            // Statement Box
            Container(
              padding: EdgeInsets.all(Responsive.sp(context, 18)),
              decoration: BoxDecoration(
                color: AppTheme.surfaceDark,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF334155)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _isEnglish ? 'Problem Statement' : 'সমস্যার বিবরণ',
                    style: TextStyle(
                      fontSize: Responsive.sp(context, 16),
                      fontWeight: FontWeight.bold,
                      color: AppTheme.accentNeonCyan,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _isEnglish
                        ? 'Given two strings s and t of lengths m and n respectively, return the minimum window substring of s such that every character in t (including duplicates) is included in the window. If there is no such substring, return the empty string "".'
                        : 'm ও n দৈর্ঘ্যের দুটি স্ট্রিং s ও t দেওয়া আছে। s এর এমন ক্ষুদ্রতম উইন্ডো সাবস্ট্রিং বের করুন যার ভেতরে t এর প্রতিটি অক্ষর (ডুপ্লিকেটসহ) বিদ্যমান থাকবে। যদি এমন কোনো সাবস্ট্রিং না থাকে, খালি স্ট্রিং "" রিটার্ন করুন।',
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

            // Examples
            Text(
              _isEnglish ? '📌 Example Cases' : '📌 উদাহরণসমূহ',
              style: TextStyle(
                fontSize: Responsive.sp(context, 18),
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            _buildExampleCard(
              "Example 1",
              "s = \"ADOBECODEBANC\", t = \"ABC\"",
              "Output: \"BANC\"",
              _isEnglish
                  ? "Explanation: The minimum window substring \"BANC\" includes 'A', 'B', and 'C' from string t."
                  : "ব্যাখ্যা: \"BANC\" সাবস্ট্রিংটি t এর 'A', 'B', 'C' অক্ষরের প্রতিটিই ধারণ করে।",
            ),
            _buildExampleCard(
              "Example 2",
              "s = \"a\", t = \"aa\"",
              "Output: \"\"",
              _isEnglish
                  ? "Explanation: String s does not contain two 'a's, so no valid window exists."
                  : "ব্যাখ্যা: s এ দুটি 'a' নেই, তাই কোনো ভ্যালিড উইন্ডো পাওয়া সম্ভব নয়।",
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // TAB 2: Code-Free Animation
  Widget _buildCodeFreeVisualizerTab(double hPadding) {
    return ResponsiveCenter(
      maxWidth: 1280.0,
      padding: EdgeInsets.all(hPadding),
      child: MinWindowSubstringCodeFreeVisualizer(isEnglish: _isEnglish),
    );
  }

  // TAB 3: Dynamic Visualizer
  Widget _buildVisualizerTab(double hPadding) {
    final isMobile = Responsive.isMobile(context);
    final step = _steps.isEmpty
        ? MinWindowStep(
            left: 0,
            right: 0,
            formed: 0,
            required: 0,
            activeLine: 0,
            currentWindowStr: "",
            bestWindowStr: "",
            bestLen: 0,
            s: _currentS,
            t: _currentT,
            actionEn: "",
            actionBn: "",
            reasonEn: "",
            reasonBn: "")
        : _steps[_currentStepIndex];

    return ResponsiveCenter(
      maxWidth: 1280.0,
      padding: EdgeInsets.all(hPadding),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Dynamic Input Box
            Container(
              padding: EdgeInsets.all(Responsive.sp(context, 16)),
              decoration: BoxDecoration(
                color: AppTheme.surfaceDark,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.accentNeonCyan.withOpacity(0.4)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _isEnglish ? '⚙️ Dynamic Test Case Generator' : '⚙️ ডায়নামিক ইনপুট ও টেস্ট কেস',
                    style: TextStyle(
                      fontSize: Responsive.sp(context, 16),
                      fontWeight: FontWeight.bold,
                      color: AppTheme.accentNeonCyan,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _sController,
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'monospace',
                              fontSize: Responsive.sp(context, 13)),
                          decoration: InputDecoration(
                            labelText: _isEnglish ? 'String s' : 'স্ট্রিং s',
                            hintText: 'e.g. ADOBECODEBANC',
                            labelStyle: TextStyle(fontSize: Responsive.sp(context, 12)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      SizedBox(
                        width: 110,
                        child: TextField(
                          controller: _tController,
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'monospace',
                              fontSize: Responsive.sp(context, 13)),
                          decoration: InputDecoration(
                            labelText: _isEnglish ? 'Target t' : 'টার্গেট t',
                            hintText: 'e.g. ABC',
                            labelStyle: TextStyle(fontSize: Responsive.sp(context, 12)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        Text('Presets: ',
                            style: TextStyle(
                                color: AppTheme.textMuted,
                                fontSize: Responsive.sp(context, 12))),
                        _buildPresetChip('s="ADOBECODEBANC", t="ABC"', "ADOBECODEBANC", "ABC"),
                        _buildPresetChip('s="a", t="a"', "a", "a"),
                        _buildPresetChip('s="OUZODYXAZV", t="XYZ"', "OUZODYXAZV", "XYZ"),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: _rebuildSteps,
                    icon: Icon(Icons.bolt, color: Colors.white, size: Responsive.sp(context, 18)),
                    label: Text(
                      _isEnglish ? 'Run Dynamic Visualizer' : 'ভিজ্যুয়ালাইজার রান করুন',
                      style: TextStyle(
                          fontSize: Responsive.sp(context, 14), fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(backgroundColor: AppTheme.accentPurple),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Visualization Layout: Stack on Mobile, Side-by-Side Horizontal Scroll on Desktop
            if (isMobile)
              Column(
                children: [
                  _buildCodeTraceWidget(step.activeLine),
                  const SizedBox(height: 16),
                  _buildArrayVisualizationBox(step),
                ],
              )
            else
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 580,
                      child: _buildCodeTraceWidget(step.activeLine),
                    ),
                    const SizedBox(width: 16),
                    SizedBox(
                      width: 550,
                      child: _buildArrayVisualizationBox(step),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 16),

            // Playback Controls
            Container(
              padding: EdgeInsets.symmetric(
                  horizontal: Responsive.sp(context, 16), vertical: 12),
              decoration: BoxDecoration(
                color: AppTheme.surfaceDark,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFF334155)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.skip_previous,
                            color: Colors.white, size: Responsive.sp(context, 20)),
                        onPressed: _currentStepIndex > 0
                            ? () => setState(() => _currentStepIndex--)
                            : null,
                      ),
                      IconButton(
                        icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow,
                            color: AppTheme.accentNeonCyan,
                            size: Responsive.sp(context, 24)),
                        onPressed: _togglePlay,
                      ),
                      IconButton(
                        icon: Icon(Icons.skip_next,
                            color: Colors.white, size: Responsive.sp(context, 20)),
                        onPressed: _currentStepIndex < _steps.length - 1
                            ? () => setState(() => _currentStepIndex++)
                            : null,
                      ),
                      IconButton(
                        icon: Icon(Icons.refresh,
                            color: AppTheme.textMuted, size: Responsive.sp(context, 20)),
                        onPressed: () {
                          _timer?.cancel();
                          setState(() {
                            _isPlaying = false;
                            _currentStepIndex = 0;
                          });
                        },
                      ),
                    ],
                  ),
                  Text(
                    "Step ${_currentStepIndex + 1} / ${_steps.length}",
                    style: TextStyle(
                        color: AppTheme.textSecondary,
                        fontWeight: FontWeight.bold,
                        fontSize: Responsive.sp(context, 13)),
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

  // TAB 4: Practice & Answer
  Widget _buildPracticeAndAnswerTab(double hPadding) {
    final s = _currentS;
    final t = _currentT;
    final curWin = (_userLeft <= _userRight && _userRight < s.length)
        ? s.substring(_userLeft, _userRight + 1)
        : "";

    return ResponsiveCenter(
      maxWidth: 1280.0,
      padding: EdgeInsets.all(hPadding),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Try It Yourself Interactive Box
            Container(
              padding: EdgeInsets.all(Responsive.sp(context, 18)),
              decoration: BoxDecoration(
                color: AppTheme.surfaceDark,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                    color: _userSolved ? AppTheme.accentGreen : AppTheme.accentAmber),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        _userSolved ? Icons.check_circle : Icons.extension_outlined,
                        color: _userSolved ? AppTheme.accentGreen : AppTheme.accentAmber,
                        size: Responsive.sp(context, 24),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _isEnglish
                            ? '🎮 Practice Mode: Find Minimum Window Substring!'
                            : '🎮 প্র্যাকটিস মোড: নিজে মিনিমাম উইন্ডো সাবস্ট্রিং বের করুন!',
                        style: TextStyle(
                          fontSize: Responsive.sp(context, 16),
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _isEnglish ? "s = '$s', t = '$t'" : "s = '$s', t = '$t'",
                    style: TextStyle(
                        color: AppTheme.accentNeonCyan,
                        fontWeight: FontWeight.bold,
                        fontSize: Responsive.sp(context, 13)),
                  ),
                  const SizedBox(height: 16),

                  // Current Window Gauge
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryDark,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppTheme.accentNeonCyan.withOpacity(0.3)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Current Window: '$curWin' [$_userLeft..$_userRight]",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: Responsive.sp(context, 12.5)),
                        ),
                        Text(
                          "Best Min Window: '${_userBestWindow}'",
                          style: TextStyle(
                              color: AppTheme.accentGreen,
                              fontWeight: FontWeight.bold,
                              fontSize: Responsive.sp(context, 12.5)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // User Action Buttons
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      ElevatedButton.icon(
                        onPressed: _userSolved ? null : () => _handleUserAction("expand"),
                        icon: Icon(Icons.arrow_forward, size: Responsive.sp(context, 16)),
                        label: Text(
                            _isEnglish ? 'Expand Right++' : 'Right++ ডানে বাড়ান',
                            style: TextStyle(fontSize: Responsive.sp(context, 13))),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.accentNeonCyan),
                      ),
                      ElevatedButton.icon(
                        onPressed: _userSolved ? null : () => _handleUserAction("shrink"),
                        icon: Icon(Icons.arrow_back, size: Responsive.sp(context, 16)),
                        label: Text(
                            _isEnglish ? 'Shrink Left++' : 'Left++ বামে কমান',
                            style: TextStyle(fontSize: Responsive.sp(context, 13))),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.accentPink),
                      ),
                      OutlinedButton.icon(
                        onPressed: () {
                          setState(() {
                            _userLeft = 0;
                            _userRight = 0;
                            _userFormed = 0;
                            _userBestWindow = "";
                            _userSolved = false;
                            _userFeedbackEn = "Reset done!";
                            _userFeedbackBn = "রিসেট করা হয়েছে!";
                          });
                        },
                        icon: Icon(Icons.refresh,
                            size: Responsive.sp(context, 16), color: Colors.white),
                        label: Text(_isEnglish ? 'Reset' : 'রিসেট',
                            style: TextStyle(fontSize: Responsive.sp(context, 13))),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Feedback Box
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: _userSolved
                          ? AppTheme.accentGreen.withOpacity(0.15)
                          : AppTheme.primaryDark,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: _userSolved
                              ? AppTheme.accentGreen
                              : const Color(0xFF334155)),
                    ),
                    child: Text(
                      _isEnglish ? _userFeedbackEn : _userFeedbackBn,
                      style: TextStyle(
                        color: _userSolved ? AppTheme.accentGreen : AppTheme.textSecondary,
                        fontWeight: FontWeight.w600,
                        fontSize: Responsive.sp(context, 13),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Reveal Solution Section
            Container(
              padding: EdgeInsets.all(Responsive.sp(context, 18)),
              decoration: BoxDecoration(
                color: AppTheme.surfaceDark,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.accentPink.withOpacity(0.5)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _isEnglish ? "Need Help or Stuck?" : "সমস্যা সমাধান করতে পারছ না?",
                              style: TextStyle(
                                fontSize: Responsive.sp(context, 16),
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _isEnglish
                                  ? "Reveal complete solution code in C++, Java, Python, and Dart."
                                  : "সম্পূর্ণ সমাধান ও কোড গাইডলাইন দেখুন।",
                              style: TextStyle(
                                  color: AppTheme.textSecondary,
                                  fontSize: Responsive.sp(context, 12)),
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _showAnswer = !_showAnswer;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              _showAnswer ? AppTheme.accentGreen : AppTheme.accentPink,
                        ),
                        child: Text(
                          _showAnswer
                              ? (_isEnglish ? "Hide Answer" : "উত্তর লুকান")
                              : (_isEnglish ? "Reveal Solution Code" : "উত্তর ও কোড দেখুন"),
                          style: TextStyle(
                              fontSize: Responsive.sp(context, 13),
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  if (_showAnswer) ...[
                    const Divider(height: 28, color: Color(0xFF334155)),
                    Row(
                      children: ["C++", "Java", "Python", "Dart"].map((lang) {
                        final isSel = _selectedCodeLang == lang;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ChoiceChip(
                            label: Text(lang,
                                style: TextStyle(fontSize: Responsive.sp(context, 12))),
                            selected: isSel,
                            selectedColor: AppTheme.accentPurple,
                            backgroundColor: AppTheme.primaryDark,
                            labelStyle: TextStyle(
                              color: isSel ? Colors.white : AppTheme.textSecondary,
                              fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
                            ),
                            onSelected: (val) {
                              if (val) {
                                setState(() {
                                  _selectedCodeLang = lang;
                                });
                              }
                            },
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 12),
                    _buildFullCodeSnippet(_selectedCodeLang),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryDark,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "⏱️ Complexity Analysis:",
                            style: TextStyle(
                                color: AppTheme.accentNeonCyan,
                                fontWeight: FontWeight.bold,
                                fontSize: Responsive.sp(context, 14)),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            _isEnglish
                                ? "• Time Complexity: O(|S| + |T|) — Each character in s is visited at most twice (by left and right pointers).\n• Space Complexity: O(|S| + |T|) — Frequency maps storing character counts."
                                : "• টাইম কমপ্লেক্সিটি: O(|S| + |T|) — s এর প্রতিটি অক্ষর সর্বোচ্চ দুবার (left ও right দ্বারা) স্ক্যান হয়।\n• স্পেস কমপ্লেক্সিটি: O(|S| + |T|) ফ্রিকোয়েন্সি ম্যাপের জন্য।",
                            style: TextStyle(
                                color: AppTheme.textSecondary,
                                fontSize: Responsive.sp(context, 13),
                                height: 1.4),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildPresetChip(String label, String s, String t) {
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: ActionChip(
        label: Text(label,
            style: TextStyle(
                fontSize: Responsive.sp(context, 11), color: Colors.white)),
        backgroundColor: AppTheme.primaryDark,
        onPressed: () => _loadPreset(s, t),
      ),
    );
  }

  Widget _buildExampleCard(
      String title, String input, String output, String desc) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF334155)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.accentNeonCyan,
                  fontSize: Responsive.sp(context, 13))),
          const SizedBox(height: 4),
          Text(input,
              style: TextStyle(
                  fontFamily: 'monospace',
                  color: Colors.white,
                  fontSize: Responsive.sp(context, 12))),
          Text(output,
              style: TextStyle(
                  fontFamily: 'monospace',
                  color: AppTheme.accentGreen,
                  fontWeight: FontWeight.bold,
                  fontSize: Responsive.sp(context, 12))),
          const SizedBox(height: 4),
          Text(desc,
              style: TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: Responsive.sp(context, 12))),
        ],
      ),
    );
  }

  Widget _buildCodeTraceWidget(int activeLine) {
    final codeLines = const [
      "string minWindow(string s, string t) {",
      "    unordered_map<char, int> tMap, windowMap;",
      "    for (char c : t) tMap[c]++;",
      "    int required = tMap.size(), formed = 0;",
      "    int left = 0, minLen = INT_MAX, minLeft = 0;",
      "    for (int right = 0; right < s.size(); right++) {",
      "        char c = s[right];",
      "        windowMap[c]++;",
      "        if (tMap.count(c) && windowMap[c] == tMap[c]) formed++;",
      "        while (left <= right && formed == required) {",
      "            if (right - left + 1 < minLen) {",
      "                minLen = right - left + 1; minLeft = left;",
      "            }",
      "            windowMap[s[left]]--;",
      "            if (tMap.count(s[left]) && windowMap[s[left]] < tMap[s[left]]) formed--;",
      "            left++;",
      "        }",
      "    }",
      "    return minLen == INT_MAX ? \"\" : s.substr(minLeft, minLen);",
      "}",
    ];

    final fullCodeText = codeLines.join('\n');

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(Responsive.sp(context, 14)),
      decoration: BoxDecoration(
        color: const Color(0xFF090D16),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF1E293B), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.code_rounded,
                      color: AppTheme.accentNeonCyan, size: 18),
                  const SizedBox(width: 6),
                  Text(
                    "C++ Execution Trace",
                    style: TextStyle(
                      color: AppTheme.accentNeonCyan,
                      fontWeight: FontWeight.bold,
                      fontSize: Responsive.sp(context, 13.5),
                    ),
                  ),
                ],
              ),
              InkWell(
                onTap: () => _copyToClipboard(fullCodeText, "C++ Trace Code"),
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppTheme.accentPurple.withOpacity(0.25),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppTheme.accentPurple.withOpacity(0.5)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.copy,
                          size: Responsive.sp(context, 13),
                          color: AppTheme.accentNeonCyan),
                      const SizedBox(width: 4),
                      Text(
                        _isEnglish ? "Copy" : "কপি",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: Responsive.sp(context, 11.5),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(codeLines.length, (idx) {
                final lineNum = idx + 1;
                final isActive = lineNum == activeLine;

                return AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(vertical: 2.5),
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                  decoration: BoxDecoration(
                    color: isActive
                        ? AppTheme.accentPurple.withOpacity(0.35)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(6),
                    border: isActive
                        ? const Border(
                            left: BorderSide(
                                color: AppTheme.accentNeonCyan, width: 4))
                        : null,
                  ),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 28,
                        child: Text(
                          '$lineNum',
                          style: TextStyle(
                            fontFamily: 'monospace',
                            fontSize: Responsive.sp(context, 12),
                            color: isActive
                                ? AppTheme.accentNeonCyan
                                : AppTheme.textMuted,
                            fontWeight:
                                isActive ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ),
                      Text(
                        codeLines[idx],
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: Responsive.sp(context, 13),
                          color:
                              isActive ? Colors.white : const Color(0xFF94A3B8),
                          fontWeight:
                              isActive ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildArrayVisualizationBox(MinWindowStep step) {
    final s = step.s;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(Responsive.sp(context, 16)),
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: step.isFinish ? AppTheme.accentGreen : const Color(0xFF334155),
          width: step.isFinish ? 2.0 : 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "String s & Window Bounds",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: Responsive.sp(context, 14)),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.accentNeonCyan.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  "Best Window: '${step.bestWindowStr}'",
                  style: TextStyle(
                      color: AppTheme.accentNeonCyan,
                      fontWeight: FontWeight.bold,
                      fontSize: Responsive.sp(context, 12)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(s.length, (idx) {
                final ch = s[idx];
                final isLeft = idx == step.left;
                final isRight = idx == step.right;
                final inWindow = idx >= step.left && idx <= step.right;

                Color boxBg = AppTheme.primaryDark;
                Color borderColor = const Color(0xFF334155);

                if (isLeft && isRight) {
                  boxBg = AppTheme.accentGreen.withOpacity(0.25);
                  borderColor = AppTheme.accentGreen;
                } else if (isLeft) {
                  boxBg = AppTheme.accentNeonCyan.withOpacity(0.25);
                  borderColor = AppTheme.accentNeonCyan;
                } else if (isRight) {
                  boxBg = AppTheme.accentPink.withOpacity(0.25);
                  borderColor = AppTheme.accentPink;
                } else if (inWindow) {
                  boxBg = AppTheme.accentPurple.withOpacity(0.15);
                  borderColor = AppTheme.accentPurple;
                }

                List<String> ptrs = [];
                if (isLeft) ptrs.add("L");
                if (isRight) ptrs.add("R");

                return Container(
                  margin: const EdgeInsets.only(right: 6),
                  padding: EdgeInsets.symmetric(
                    horizontal: Responsive.sp(context, 10),
                    vertical: Responsive.sp(context, 8),
                  ),
                  decoration: BoxDecoration(
                    color: boxBg,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: borderColor, width: 1.5),
                  ),
                  child: Column(
                    children: [
                      Text(
                        ptrs.join('&'),
                        style: TextStyle(
                          fontSize: Responsive.sp(context, 9),
                          color: isLeft
                              ? AppTheme.accentNeonCyan
                              : AppTheme.accentPink,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        ch,
                        style: TextStyle(
                          fontSize: Responsive.sp(context, 15),
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '[$idx]',
                        style: TextStyle(
                            fontSize: Responsive.sp(context, 8.5),
                            color: AppTheme.textMuted),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 16),

          Container(
            width: double.infinity,
            padding: EdgeInsets.all(Responsive.sp(context, 12)),
            decoration: BoxDecoration(
              color: step.isFinish
                  ? AppTheme.accentGreen.withOpacity(0.15)
                  : AppTheme.primaryDark,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: step.isFinish
                    ? AppTheme.accentGreen
                    : const Color(0xFF334155),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _isEnglish ? step.actionEn : step.actionBn,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: step.isFinish ? AppTheme.accentGreen : Colors.white,
                    fontSize: Responsive.sp(context, 13),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _isEnglish ? step.reasonEn : step.reasonBn,
                  style: TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: Responsive.sp(context, 12),
                      height: 1.3),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFullCodeSnippet(String lang) {
    String code = "";
    if (lang == "C++") {
      code = """
class Solution {
public:
    string minWindow(string s, string t) {
        unordered_map<char, int> tMap, windowMap;
        for (char c : t) tMap[c]++;
        
        int required = tMap.size(), formed = 0;
        int left = 0, minLen = INT_MAX, minLeft = 0;
        
        for (int right = 0; right < s.size(); right++) {
            char c = s[right];
            windowMap[c]++;
            
            if (tMap.count(c) && windowMap[c] == tMap[c]) {
                formed++;
            }
            
            while (left <= right && formed == required) {
                if (right - left + 1 < minLen) {
                    minLen = right - left + 1;
                    minLeft = left;
                }
                
                char charL = s[left];
                windowMap[charL]--;
                if (tMap.count(charL) && windowMap[charL] < tMap[charL]) {
                    formed--;
                }
                left++;
            }
        }
        return minLen == INT_MAX ? "" : s.substr(minLeft, minLen);
    }
};""";
    } else if (lang == "Java") {
      code = """
class Solution {
    public String minWindow(String s, String t) {
        if (s.length() == 0 || t.length() == 0) return "";
        
        Map<Character, Integer> tMap = new HashMap<>();
        for (int i = 0; i < t.length(); i++) {
            tMap.put(t.charAt(i), tMap.getOrDefault(t.charAt(i), 0) + 1);
        }
        
        int required = tMap.size(), formed = 0;
        Map<Character, Integer> windowMap = new HashMap<>();
        int left = 0, minLen = Integer.MAX_VALUE, minLeft = 0;
        
        for (int right = 0; right < s.length(); right++) {
            char c = s.charAt(right);
            windowMap.put(c, windowMap.getOrDefault(c, 0) + 1);
            
            if (tMap.containsKey(c) && windowMap.get(c).intValue() == tMap.get(c).intValue()) {
                formed++;
            }
            
            while (left <= right && formed == required) {
                if (right - left + 1 < minLen) {
                    minLen = right - left + 1;
                    minLeft = left;
                }
                
                char charL = s.charAt(left);
                windowMap.put(charL, windowMap.get(charL) - 1);
                if (tMap.containsKey(charL) && windowMap.get(charL) < tMap.get(charL)) {
                    formed--;
                }
                left++;
            }
        }
        return minLen == Integer.MAX_VALUE ? "" : s.substring(minLeft, minLeft + minLen);
    }
}""";
    } else if (lang == "Python") {
      code = """
class Solution:
    def minWindow(self, s: str, t: str) -> str:
        if not s or not t:
            return ""
        
        t_map = Counter(t)
        required = len(t_map)
        formed = 0
        window_map = {}
        
        left = 0
        ans = (float("inf"), 0, 0)
        
        for right, char in enumerate(s):
            window_map[char] = window_map.get(char, 0) + 1
            if char in t_map and window_map[char] == t_map[char]:
                formed += 1
            
            while left <= right and formed == required:
                if right - left + 1 < ans[0]:
                    ans = (right - left + 1, left, right)
                
                char_l = s[left]
                window_map[char_l] -= 1
                if char_l in t_map and window_map[char_l] < t_map[char_l]:
                    formed -= 1
                left += 1
                
        return "" if ans[0] == float("inf") else s[ans[1]:ans[2]+1]""";
    } else {
      code = """
String minWindow(String s, String t) {
  if (s.isEmpty || t.isEmpty) return "";

  Map<String, int> tMap = {};
  for (int i = 0; i < t.length; i++) {
    tMap[t[i]] = (tMap[t[i]] ?? 0) + 1;
  }
  int required = tMap.length, formed = 0;
  Map<String, int> windowMap = {};
  int left = 0, minLen = 999999, minLeft = 0;

  for (int right = 0; right < s.length; right++) {
    String c = s[right];
    windowMap[c] = (windowMap[c] ?? 0) + 1;

    if (tMap.containsKey(c) && windowMap[c] == tMap[c]) {
      formed++;
    }

    while (left <= right && formed == required) {
      if (right - left + 1 < minLen) {
        minLen = right - left + 1;
        minLeft = left;
      }

      String charL = s[left];
      windowMap[charL] = windowMap[charL]! - 1;
      if (tMap.containsKey(charL) && windowMap[charL]! < tMap[charL]!) {
        formed--;
      }
      left++;
    }
  }
  return minLen == 999999 ? "" : s.substring(minLeft, minLeft + minLen);
}""";
    }

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
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 10,
            runSpacing: 8,
            children: [
              Text(
                "$lang Solution Code",
                style: TextStyle(
                  color: AppTheme.accentNeonCyan,
                  fontWeight: FontWeight.bold,
                  fontSize: Responsive.sp(context, 13),
                ),
              ),
              ElevatedButton.icon(
                onPressed: () => _copyToClipboard(code, "$lang Solution"),
                icon: Icon(Icons.copy_all, size: Responsive.sp(context, 14)),
                label: Text(
                  _isEnglish ? "Copy Code" : "কোড কপি করুন",
                  style: TextStyle(
                      fontSize: Responsive.sp(context, 12),
                      fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.accentPurple,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Text(
              code.trim(),
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: Responsive.sp(context, 12.5),
                color: const Color(0xFF38BDF8),
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
