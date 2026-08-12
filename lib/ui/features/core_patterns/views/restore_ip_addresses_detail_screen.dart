import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';

class RestoreIPAddressesStep {
  final int startIndex;
  final int segmentCount;
  final String currentSegment;
  final String currentIP;
  final List<String> allValidIPs;
  final String decision; // 'init', 'test_segment', 'valid_segment', 'leading_zero_error', 'out_of_range_error', 'valid_ip_saved', 'backtrack'
  final int activeLine;
  final String actionEn;
  final String actionBn;
  final String reasonEn;
  final String reasonBn;
  final int callStackDepth;

  const RestoreIPAddressesStep({
    required this.startIndex,
    required this.segmentCount,
    required this.currentSegment,
    required this.currentIP,
    required this.allValidIPs,
    required this.decision,
    required this.activeLine,
    required this.actionEn,
    required this.actionBn,
    required this.reasonEn,
    required this.reasonBn,
    required this.callStackDepth,
  });
}

class RestoreIPAddressesDetailScreen extends StatefulWidget {
  const RestoreIPAddressesDetailScreen({super.key});

  @override
  State<RestoreIPAddressesDetailScreen> createState() => _RestoreIPAddressesDetailScreenState();
}

class _RestoreIPAddressesDetailScreenState extends State<RestoreIPAddressesDetailScreen>
    with SingleTickerProviderStateMixin {
  bool _isEnglish = true;
  late TabController _tabController;

  // Custom Input State
  final TextEditingController _sController = TextEditingController(text: "25525511135");
  String _s = "25525511135";
  List<RestoreIPAddressesStep> _steps = [];

  // Playback Control
  int _currentStepIndex = 0;
  bool _isPlaying = false;
  Timer? _timer;

  // Code Language Selector
  String _selectedCodeLang = "C++";

  // Tab 2 Animation Model Selector (0: Step Flowcard, 1: Octet Validation Shield, 2: Valid IP Format Guide)
  int _animationModelIndex = 0;
  int _flowStepIndex = 0;

  // Practice Mode State
  List<int> _practiceDotPositions = []; // dot indices after characters in _s
  List<String> _practiceResults = [];
  List<String> _practiceHistory = [];
  String _userFeedbackEn = "Tap spaces between digits to place exactly 3 dots to restore valid IPv4 address!";
  String _userFeedbackBn = "বৈধ IPv4 পেতে ডিজিটের মাঝে ৩টি ডট স্থান নির্ধারণ করতে স্পর্শ করুন!";
  bool _practiceSolved = false;

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
    _flowStepIndex = 0;

    String inputStr = _sController.text.trim();
    if (inputStr.isEmpty) inputStr = "25525511135";
    if (inputStr.length > 12) inputStr = inputStr.substring(0, 12);
    _s = inputStr;

    _steps = _generateSteps(_s);

    // Reset practice mode
    _resetPractice();
  }

  void _resetPractice() {
    _practiceDotPositions = [];
    _practiceResults = [];
    _practiceHistory = [];
    _practiceSolved = false;
    _userFeedbackEn = "Tap spaces between digits to place 3 dots to restore IPv4 address for \"$_s\"!";
    _userFeedbackBn = "\"$_s\" এর জন্য ডিজিটের মাঝে ৩টি ডট বসিয়ে IPv4 অ্যাড্রেস মিলাুন!";
  }

  List<RestoreIPAddressesStep> _generateSteps(String str) {
    List<RestoreIPAddressesStep> steps = [];
    List<String> validIPs = [];

    // Step 0: Init
    steps.add(RestoreIPAddressesStep(
      startIndex: 0,
      segmentCount: 0,
      currentSegment: "",
      currentIP: "",
      allValidIPs: [],
      decision: "init",
      activeLine: 1,
      actionEn: "Line 1: Initialize Restore IP Addresses for s = \"$str\".",
      actionBn: "লাইন ১: s = \"$str\" এর জন্য Restore IP Addresses অ্যালগরিদম শুরু।",
      reasonEn: "We must partition s into 4 valid octets (0-255, no leading zeros).",
      reasonBn: "stiring টি ৪টি বৈধ অকটেটে (০-২৫৫, লিডিং জিরো ছাড়া) বিভক্ত করতে হবে।",
      callStackDepth: 0,
    ));

    void backtrack(int startIdx, int count, String currentIP, int depth) {
      if (count == 4) {
        if (startIdx == str.length) {
          String finalIP = currentIP.substring(0, currentIP.length - 1); // remove trailing dot
          validIPs.add(finalIP);

          steps.add(RestoreIPAddressesStep(
            startIndex: startIdx,
            segmentCount: count,
            currentSegment: "",
            currentIP: finalIP,
            allValidIPs: List.from(validIPs),
            decision: "valid_ip_saved",
            activeLine: 3,
            actionEn: "🎉 Line 3: Successfully Restored Valid IPv4 Address \"$finalIP\"!",
            actionBn: "🎉 লাইন ৩: সফলভাবে বৈধ IPv4 ঠিকানা \"$finalIP\" উদ্ধার করা হলো!",
            reasonEn: "4 valid octets formed and consumed entire string s.",
            reasonBn: "৪টি বৈধ অকটেট দিয়ে সম্পূর্ণ স্ট্রিং s কভার করা হয়েছে।",
            callStackDepth: depth,
          ));
        }
        return;
      }

      for (int len = 1; len <= 3; len++) {
        if (startIdx + len > str.length) break;

        String sub = str.substring(startIdx, startIdx + len);

        // Check leading zero
        if (len > 1 && sub.startsWith("0")) {
          steps.add(RestoreIPAddressesStep(
            startIndex: startIdx,
            segmentCount: count,
            currentSegment: sub,
            currentIP: currentIP,
            allValidIPs: List.from(validIPs),
            decision: "leading_zero_error",
            activeLine: 7,
            actionEn: "🛑 Line 7: Substring \"$sub\" has leading zero! Invalid octet.",
            actionBn: "🛑 লাইন ৭: সাবস্ট্রিং \"$sub\" এ লিডিং জিরো আছে! অবৈধ অকটেট।",
            reasonEn: "Octets with length > 1 cannot start with '0'.",
            reasonBn: "দৈর্ঘ্য ১ এর বেশি হলে অকটেটের শুরুতে '0' থাকা চলবে না।",
            callStackDepth: depth,
          ));
          break; // leading zero prevents any longer segment starting at startIdx
        }

        int val = int.parse(sub);
        if (val > 255) {
          steps.add(RestoreIPAddressesStep(
            startIndex: startIdx,
            segmentCount: count,
            currentSegment: sub,
            currentIP: currentIP,
            allValidIPs: List.from(validIPs),
            decision: "out_of_range_error",
            activeLine: 8,
            actionEn: "🛑 Line 8: Octet value $val > 255! Out of valid IPv4 range.",
            actionBn: "🛑 লাইন ৮: অকটেট মান $val > ২৫৫! বৈধ IPv4 রেঞ্জের বাইরে।",
            reasonEn: "IPv4 octet must be between 0 and 255.",
            reasonBn: "IPv4 অকটেট মান অবশ্যই ০ এবং ২৫৫ এর মধ্যে হতে হবে।",
            callStackDepth: depth,
          ));
          break; // val increases with len, so longer len will also be > 255
        }

        String nextIP = "$currentIP$sub.";
        steps.add(RestoreIPAddressesStep(
          startIndex: startIdx + len,
          segmentCount: count + 1,
          currentSegment: sub,
          currentIP: nextIP,
          allValidIPs: List.from(validIPs),
          decision: "valid_segment",
          activeLine: 9,
          actionEn: "✅ Line 9: Valid Octet \"$sub\". Recurse for segment ${count + 2}.",
          actionBn: "✅ লাইন ৯: বৈধ অকটেট \"$sub\"। সেগমেন্ট ${count + 2} এর জন্য রিকার্সন শুরু।",
          reasonEn: "Octet is valid (0 <= $val <= 255). Recurse to build next segment.",
          reasonBn: "অকটেট বৈধ (0 <= $val <= 255)। পরের সেগমেন্ট বানাতে রিকার্সন চালান।",
          callStackDepth: depth + 1,
        ));

        backtrack(startIdx + len, count + 1, nextIP, depth + 1);
      }
    }

    backtrack(0, 0, "", 0);

    // Final Step
    steps.add(RestoreIPAddressesStep(
      startIndex: str.length,
      segmentCount: 4,
      currentSegment: "",
      currentIP: "",
      allValidIPs: List.from(validIPs),
      decision: "valid_ip_saved",
      activeLine: 11,
      actionEn: "🎉 Line 11: Traversal Complete! Found total ${validIPs.length} valid IPv4 addresses for \"$str\"!",
      actionBn: "🎉 লাইন ১১: অনুসন্ধান সম্পূর্ণ! \"$str\" এর জন্য মোট ${validIPs.length} টি বৈধ IPv4 ঠিকানা উদ্ধার করা হয়েছে!",
      reasonEn: "All 4-part segment combinations evaluated.",
      reasonBn: "সমস্ত ৪-ভাগ সেগমেন্ট সমন্বয় পরীক্ষা সম্পন্ন করা হয়েছে।",
      callStackDepth: 0,
    ));

    return steps;
  }

  void _togglePlay() {
    setState(() => _isPlaying = !_isPlaying);
    if (_isPlaying) {
      _timer = Timer.periodic(const Duration(milliseconds: 1400), (timer) {
        if (_currentStepIndex < _steps.length - 1) {
          setState(() => _currentStepIndex++);
        } else {
          _timer?.cancel();
          setState(() => _isPlaying = false);
        }
      });
    } else {
      _timer?.cancel();
    }
  }

  int _calculateTotalValidIPsCount(String str) {
    int count = 0;
    void bt(int start, int segs) {
      if (segs == 4) {
        if (start == str.length) count++;
        return;
      }
      for (int len = 1; len <= 3; len++) {
        if (start + len > str.length) break;
        String sub = str.substring(start, start + len);
        if (len > 1 && sub.startsWith("0")) break;
        if (int.parse(sub) > 255) break;
        bt(start + len, segs + 1);
      }
    }

    bt(0, 0);
    return count;
  }

  void _handlePracticeDotTap(int dotIdx) {
    if (_practiceSolved) return;
    final targetTotal = _calculateTotalValidIPsCount(_s);

    setState(() {
      if (_practiceDotPositions.contains(dotIdx)) {
        _practiceDotPositions.remove(dotIdx);
        _userFeedbackEn = "↩️ Removed dot after digit $dotIdx.";
        _userFeedbackBn = "↩️ ডিজিট $dotIdx এর পরের ডট সরানো হয়েছে।";
      } else {
        if (_practiceDotPositions.length >= 3) {
          _userFeedbackEn = "ℹ️ Exactly 3 dots needed for IPv4 address! Remove one first.";
          _userFeedbackBn = "ℹ️ IPv4 ঠিকানার জন্য ঠিক ৩টি ডট প্রয়োজন! আগে একটি সরান।";
          return;
        }

        _practiceDotPositions.add(dotIdx);
        _practiceDotPositions.sort();

        if (_practiceDotPositions.length == 3) {
          // Validate IP formed by 3 dots
          List<int> dots = List.from(_practiceDotPositions);
          String seg1 = _s.substring(0, dots[0] + 1);
          String seg2 = _s.substring(dots[0] + 1, dots[1] + 1);
          String seg3 = _s.substring(dots[1] + 1, dots[2] + 1);
          String seg4 = _s.substring(dots[2] + 1);

          bool validSeg(String sub) {
            if (sub.isEmpty) return false;
            if (sub.length > 1 && sub.startsWith("0")) return false;
            if (int.parse(sub) > 255) return false;
            return true;
          }

          if (validSeg(seg1) && validSeg(seg2) && validSeg(seg3) && validSeg(seg4)) {
            String candidateIP = "$seg1.$seg2.$seg3.$seg4";
            if (!_practiceResults.contains(candidateIP)) {
              _practiceResults.add(candidateIP);
              _userFeedbackEn = "🎉 Valid IPv4 Restored: \"$candidateIP\"! (${_practiceResults.length} / $targetTotal)";
              _userFeedbackBn = "🎉 বৈধ IPv4 উদ্ধার: \"$candidateIP\"! (${_practiceResults.length} / $targetTotal)";
            } else {
              _userFeedbackEn = "ℹ️ \"$candidateIP\" was already collected. Try another dot placement!";
              _userFeedbackBn = "ℹ️ \"$candidateIP\" ইতিমধ্যেই সংগৃহীত হয়েছে। অন্য ডট স্থান অবস্থান চেষ্টা করুন!";
            }

            if (_practiceResults.length >= targetTotal) {
              _practiceSolved = true;
              _userFeedbackEn = "🏆 MASTERED! You found all $targetTotal valid IPv4 addresses for \"$_s\"!";
              _userFeedbackBn = "🏆 দারুণ! আপনি \"$_s\" এর সমস্ত $targetTotal টি বৈধ IPv4 ঠিকানা উদ্ধার করে ফেলেছেন!";
            }
          } else {
            _userFeedbackEn = "🛑 Invalid IPv4: Check octets ($seg1, $seg2, $seg3, $seg4). Ensure range 0-255 & no leading zeros!";
            _userFeedbackBn = "🛑 অবৈধ IPv4: সেগমেন্ট ($seg1, $seg2, $seg3, $seg4) দেখুন। ০-২৫৫ রেঞ্জ এবং লিডিং জিরো এড়ান!";
          }
        } else {
          _userFeedbackEn = "Placed dot ${_practiceDotPositions.length} / 3.";
          _userFeedbackBn = "ডট বসানো হয়েছে: ${_practiceDotPositions.length} / 3।";
        }
      }
    });
  }

  void _undoPracticeMove() {
    setState(() {
      _resetPractice();
      _userFeedbackEn = "↩️ Reset practice board for new move.";
      _userFeedbackBn = "↩️ নতুন মুভের জন্য বোর্ড রিসেট করা হলো।";
    });
  }

  @override
  Widget build(BuildContext context) {
    final hPadding = Responsive.horizontalPadding(context);

    return Scaffold(
      backgroundColor: AppTheme.primaryDark,
      appBar: AppBar(
        title: Text(
          '93. Restore IP Addresses',
          style: TextStyle(fontSize: Responsive.sp(context, 18), fontWeight: FontWeight.bold),
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
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: Responsive.sp(context, 13)),
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
          _buildProblemDescriptionTab(),
          _buildCodeFreeAnimationTab(),
          _buildVisualizerTab(),
          _buildPracticeTab(),
        ],
      ),
    );
  }

  // TAB 1: Problem Description
  Widget _buildProblemDescriptionTab() {
    final hPadding = Responsive.horizontalPadding(context);

    return ResponsiveCenter(
      padding: EdgeInsets.all(hPadding),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title + Tags
            Row(
              children: [
                Expanded(
                  child: Text(
                    "93. Restore IP Addresses",
                    style: TextStyle(fontSize: Responsive.sp(context, 22), fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.accentAmber.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppTheme.accentAmber),
                  ),
                  child: const Text("Medium", style: TextStyle(color: AppTheme.accentAmber, fontWeight: FontWeight.bold, fontSize: 12)),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 6,
              children: ["Meta", "Amazon", "Microsoft", "Google", "Apple", "Uber"].map((company) {
                return Chip(
                  backgroundColor: AppTheme.surfaceDark,
                  label: Text(company, style: const TextStyle(color: AppTheme.accentNeonCyan, fontSize: 11)),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),

            // Description Box
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.surfaceDark,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFF1E293B)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _isEnglish
                        ? "A valid IP address consists of exactly four integers separated by single dots. Each integer is between 0 and 255 (inclusive) and cannot have leading zeros. Given a string s containing only digits, return all possible valid IPv4 addresses that can be formed by inserting dots into s."
                        : "একটি বৈধ IPv4 অ্যাড্রেসে ডট দিয়ে পৃথক করা ঠিক ৪টি পূর্ণসংখ্যা থাকে (প্রতিটি ০-২৫৫ এর মধ্যে এবং '০' ছাড়া লিডিং জিরো থাকা চলবে না)। ডিজিটের স্ট্রিং s থেকে ডট বসিয়ে গঠিত সমস্ত সম্ভাব্য বৈধ IPv4 ঠিকানা রিটার্ন করুন।",
                    style: const TextStyle(color: Colors.white, fontSize: 14, height: 1.5),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Examples
            Text(_isEnglish ? "Examples" : "উদাহরণসমূহ", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 8),
            _buildExampleCard("Example 1", 's = "25525511135"', 'Output: ["255.255.11.135","255.255.111.35"]'),
            _buildExampleCard("Example 2", 's = "0000"', 'Output: ["0.0.0.0"]'),
            _buildExampleCard("Example 3", 's = "101023"', 'Output: ["1.0.10.23","1.0.102.3","10.1.0.23","10.10.2.3","101.0.2.3"]'),
            const SizedBox(height: 20),

            // Intuition Box
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.accentPurple.withOpacity(0.15),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppTheme.accentPurple),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.lightbulb_outline, color: AppTheme.accentAmber, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        _isEnglish ? "Key Intuition (4-Segment Backtracking + Octet Rule)" : "মূল আইডিয়া (৪-সেগমেন্ট ব্যাকট্র্যাকিং + অকটেট রুল)",
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 15),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _isEnglish
                        ? "1. At each step, test segment lengths of 1, 2, or 3 digits.\n2. Enforce 2 rules: 0 <= value <= 255 AND no leading zero for len > 1.\n3. Base case: Exactly 4 segments must consume all characters of s."
                        : "১. প্রতিটি পদক্ষেপে ১, ২ বা ৩ ডিজিটের সেগমেন্ট পরীক্ষা করুন।\n২. ২টি নিয়ম প্রযোজ্য: 0 <= value <= 255 এবং len > 1 হলে লিডিং জিরো নেই।\n৩. বেস কেস: ঠিক ৪টি সেগমেন্ট দিয়ে পুরো স্ট্রিং s কভার হতে হবে।",
                    style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13, height: 1.4),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Code Solutions (C++, Java, Python)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _isEnglish ? "Code Solutions" : "কোড সমাধানসমূহ",
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                DropdownButton<String>(
                  value: _selectedCodeLang,
                  dropdownColor: AppTheme.surfaceDark,
                  style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold),
                  items: ["C++", "Java", "Python"].map((lang) {
                    return DropdownMenuItem(value: lang, child: Text(lang));
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) setState(() => _selectedCodeLang = val);
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            _buildCodeSnippetBox(_selectedCodeLang),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // TAB 2: Code-Free Animation (3 Interactive Concept Models)
  Widget _buildCodeFreeAnimationTab() {
    final hPadding = Responsive.horizontalPadding(context);

    return ResponsiveCenter(
      padding: EdgeInsets.all(hPadding),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _isEnglish ? "Restore IP Visual Models (Concept Explanations)" : "রিস্টোর IP ভিজ্যুয়াল মডেলসমূহ (কোডহীন গাইড)",
              style: TextStyle(fontSize: Responsive.sp(context, 18), fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 6),
            Text(
              _isEnglish
                  ? "Explore 3 interactive models for string s = \"25525511135\"."
                  : "স্ট্রিং s = \"25525511135\" এর জন্য ৩টি ইন্টারঅ্যাক্টিভ ভিজ্যুয়াল মডেল পর্যবেক্ষণ করুন।",
              style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13),
            ),
            const SizedBox(height: 16),

            // Model Switcher Segmented Control
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildAnimationModelChip(0, _isEnglish ? "1. 🪜 Step Flowcard" : "১. 🪜 স্টেপ-বাই-স্টেপ ফ্লো-কার্ড"),
                  _buildAnimationModelChip(1, _isEnglish ? "2. 🛡️ Octet Rule Shield" : "২. 🛡️ অকটেট রুল শিল্ড"),
                  _buildAnimationModelChip(2, _isEnglish ? "3. 📊 IPv4 Format Guide" : "৩. 📊 IPv4 ফরম্যাট গাইড"),
                ],
              ),
            ),
            const SizedBox(height: 20),

            if (_animationModelIndex == 0) _buildStepFlowcardModel(),
            if (_animationModelIndex == 1) _buildOctetRuleShieldModel(),
            if (_animationModelIndex == 2) _buildIPv4FormatGuideModel(),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimationModelChip(int index, String label) {
    final isSelected = _animationModelIndex == index;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        selectedColor: AppTheme.accentPurple,
        backgroundColor: AppTheme.surfaceDark,
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : AppTheme.textSecondary,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          fontSize: 12,
        ),
        onSelected: (selected) {
          if (selected) setState(() => _animationModelIndex = index);
        },
      ),
    );
  }

  // MODEL 1: Step-by-Step Backtracking Flowcard Engine
  Widget _buildStepFlowcardModel() {
    final stepFlowData = [
      {
        "step": 1,
        "ip": "255 . 255 . 11 . 135",
        "badge": "🎉 VALID IP #1",
        "badgeColor": AppTheme.accentGreen,
        "titleEn": "Step 1: Partition 255 . 255 . 11 . 135 ➔ Saved Valid IP #1!",
        "titleBn": "ধাপ ১: বিভাগ 255 . 255 . 11 . 135 ➔ বৈধ IP #১ সংরক্ষিত!",
        "descEn": "Segments [\"255\", \"255\", \"11\", \"135\"] are all valid octets (0-255).",
        "descBn": "সেগমেন্ট [\"255\", \"255\", \"11\", \"135\"] সবকটি বৈধ অকটেট (০-২৫৫)।",
      },
      {
        "step": 2,
        "ip": "255 . 255 . 111 . 35",
        "badge": "🎉 VALID IP #2",
        "badgeColor": AppTheme.accentGreen,
        "titleEn": "Step 2: Partition 255 . 255 . 111 . 35 ➔ Saved Valid IP #2!",
        "titleBn": "ধাপ ২: বিভাগ 255 . 255 . 111 . 35 ➔ বৈধ IP #২ সংরক্ষিত!",
        "descEn": "Segments [\"255\", \"255\", \"111\", \"35\"] are all valid octets (0-255).",
        "descBn": "সেগমেন্ট [\"255\", \"255\", \"111\", \"35\"] সবকটি বৈধ অকটেট (০-২৫৫)।",
      },
      {
        "step": 3,
        "ip": "25525511135",
        "badge": "🏆 FINISHED",
        "badgeColor": AppTheme.accentGreen,
        "titleEn": "Step 3: Traversal Complete! Found 2 Valid IPv4 Addresses",
        "titleBn": "ধাপ ৩: ব্যাকট্র্যাকিং সম্পূর্ণ! মোট ২টি বৈধ IPv4 ঠিকানা উদ্ধার",
        "descEn": "Found all valid IPv4 combinations for string \"25525511135\"!",
        "descBn": "\"25525511135\" স্ট্রিং এর জন্য সমস্ত বৈধ IPv4 বিন্যাস পাওয়া গেছে!",
      },
    ];

    final currentStep = stepFlowData[_flowStepIndex.clamp(0, stepFlowData.length - 1)];
    final String ip = currentStep["ip"] as String;
    final String badgeText = currentStep["badge"] as String;
    final Color badgeColor = currentStep["badgeColor"] as Color;
    final String stepTitle = _isEnglish ? (currentStep["titleEn"] as String) : (currentStep["titleBn"] as String);
    final String stepDesc = _isEnglish ? (currentStep["descEn"] as String) : (currentStep["descBn"] as String);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF090D16),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF1E293B)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _isEnglish ? "1. Step-by-Step Restore IP Flowcard" : "১. স্টেপ-বাই-স্টেপ রিস্টোর IP ফ্লো-কার্ড",
                style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 14),
              ),
              Text(
                "Step ${_flowStepIndex + 1} / ${stepFlowData.length}",
                style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            _isEnglish
                ? "Watch octet segment splitting and IP validation."
                : "অকটেট সেগমেন্ট বিভাজন এবং IP যাচাইকরণ দেখুন।",
            style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12),
          ),
          const SizedBox(height: 16),

          // Active Step Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.surfaceDark,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: badgeColor, width: 2),
              boxShadow: [BoxShadow(color: badgeColor.withOpacity(0.2), blurRadius: 10)],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(stepTitle, style: TextStyle(color: badgeColor, fontWeight: FontWeight.bold, fontSize: 14)),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: badgeColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: badgeColor),
                      ),
                      child: Text(badgeText, style: TextStyle(color: badgeColor, fontWeight: FontWeight.bold, fontSize: 11)),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // IP Display Box
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF090D16),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: badgeColor.withOpacity(0.5)),
                  ),
                  child: Text(
                    "\"$ip\"",
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: badgeColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 12),

                Text(stepDesc, style: const TextStyle(color: Colors.white, fontSize: 13, height: 1.4)),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Stepper Control Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: AppTheme.surfaceDark,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF1E293B)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.skip_previous, color: Colors.white, size: 20),
                      onPressed: _flowStepIndex > 0 ? () => setState(() => _flowStepIndex--) : null,
                    ),
                    IconButton(
                      icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow, color: AppTheme.accentNeonCyan, size: 22),
                      onPressed: () {
                        setState(() => _isPlaying = !_isPlaying);
                        if (_isPlaying) {
                          _timer = Timer.periodic(const Duration(milliseconds: 1400), (t) {
                            if (_flowStepIndex < stepFlowData.length - 1) {
                              setState(() => _flowStepIndex++);
                            } else {
                              t.cancel();
                              setState(() => _isPlaying = false);
                            }
                          });
                        } else {
                          _timer?.cancel();
                        }
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.skip_next, color: Colors.white, size: 20),
                      onPressed: _flowStepIndex < stepFlowData.length - 1 ? () => setState(() => _flowStepIndex++) : null,
                    ),
                    IconButton(
                      icon: const Icon(Icons.refresh, color: AppTheme.accentNeonCyan, size: 20),
                      onPressed: () {
                        _timer?.cancel();
                        setState(() {
                          _isPlaying = false;
                          _flowStepIndex = 0;
                        });
                      },
                    ),
                  ],
                ),
                Text(
                  "Step ${_flowStepIndex + 1} / ${stepFlowData.length}",
                  style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // MODEL 2: Octet Rule Shield
  Widget _buildOctetRuleShieldModel() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF090D16),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF1E293B)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _isEnglish ? "2. IPv4 Octet Validation Shield (3 Rules)" : "২. IPv4 অকটেট ভ্যালিডেশন শিল্ড (৩টি নিয়ম)",
            style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 6),
          Text(
            _isEnglish
                ? "Every segment must pass 3 checks:\n1. Length: 1 to 3 digits\n2. Range: 0 <= value <= 255\n3. No Leading Zero: e.g. \"01\" is INVALID, but \"0\" is VALID."
                : "প্রতিটি সেগমেন্টের জন্য ৩টি পরীক্ষা:\n১. দৈর্ঘ্য: ১ থেকে ৩ ডিজিট\n২. রেঞ্জ: 0 <= value <= 255\n৩. লিডিং জিরো নাই: যেমন \"01\" অবৈধ, তবে \"0\" বৈধ।",
            style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12, height: 1.4),
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppTheme.surfaceDark,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.accentPink),
            ),
            child: const Text(
              "if (len > 1 && sub[0] == '0') break; 🛑\nif (stoi(sub) > 255) break; 🛑",
              style: TextStyle(fontFamily: 'monospace', fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.accentPink, height: 1.4),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  // MODEL 3: IPv4 Format Guide
  Widget _buildIPv4FormatGuideModel() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF090D16),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF1E293B)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _isEnglish ? "3. IPv4 Format Structure: A.B.C.D" : "৩. IPv4 ফরম্যাট কাঠামো: A.B.C.D",
            style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 6),
          Text(
            _isEnglish
                ? "A valid IPv4 consists of exactly 4 octets separated by 3 dots, using all digits of string s."
                : "একটি বৈধ IPv4 এ ঠিক ৪টি অকটেট ৩টি ডট দিয়ে আলাদা হয়ে স্ট্রিং s এর সব ডিজিট কভার করে।",
            style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12),
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppTheme.surfaceDark,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.accentGreen),
            ),
            child: const Text(
              "Segment 1 . Segment 2 . Segment 3 . Segment 4 🎉\nTotal 4 Octets & Exactly 3 Dots",
              style: TextStyle(fontFamily: 'monospace', fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white, height: 1.5),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  // TAB 3: Dynamic Visualizer
  Widget _buildVisualizerTab() {
    final step = _steps.isNotEmpty ? _steps[_currentStepIndex.clamp(0, _steps.length - 1)] : null;
    final isMobile = Responsive.isMobile(context);

    return SingleChildScrollView(
      padding: EdgeInsets.all(Responsive.horizontalPadding(context)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Input Box & Presets
          Container(
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
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _sController,
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        decoration: InputDecoration(
                          labelText: _isEnglish ? "String s (digits only)" : "স্ট্রিং s (শুধু সংখ্যা)",
                          labelStyle: const TextStyle(color: AppTheme.accentNeonCyan, fontSize: 12),
                          filled: true,
                          fillColor: const Color(0xFF090D16),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.accentNeonCyan,
                        foregroundColor: AppTheme.primaryDark,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      ),
                      onPressed: () => setState(() => _rebuildSteps()),
                      child: Text(_isEnglish ? "Run" : "রান"),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      const Text("Presets: ", style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
                      _buildPresetChip("25525511135"),
                      _buildPresetChip("0000"),
                      _buildPresetChip("101023"),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          if (step != null) ...[
            // Status Log Banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppTheme.accentPurple.withOpacity(0.15),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppTheme.accentPurple),
              ),
              child: Text(
                _isEnglish ? step.actionEn : step.actionBn,
                style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 13),
              ),
            ),
            const SizedBox(height: 16),

            // Code Snippet + Canvas Layout
            if (isMobile)
              Column(
                children: [
                  _buildCodeHighlightBox(step.activeLine),
                  const SizedBox(height: 16),
                  _buildRestoreIPCanvas(step),
                ],
              )
            else
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _buildCodeHighlightBox(step.activeLine)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildRestoreIPCanvas(step)),
                ],
              ),

            const SizedBox(height: 20),

            // Control Bar
            _buildControlBar(),
          ],
        ],
      ),
    );
  }

  // TAB 4: Practice & Answer
  Widget _buildPracticeTab() {
    final hPadding = Responsive.horizontalPadding(context);
    final targetTotal = _calculateTotalValidIPsCount(_s);

    return ResponsiveCenter(
      padding: EdgeInsets.all(hPadding),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _isEnglish ? "Interactive Practice Mode" : "ইন্টারেক্টিভ প্র্যাকটিস মোড",
              style: TextStyle(fontSize: Responsive.sp(context, 18), fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 6),
            Text(
              _isEnglish
                  ? "Tap spaces between digits to place 3 dots to form all $targetTotal valid IPv4 addresses!"
                  : "ডিজিটের মাঝে ৩টি ডট স্থান নির্বাচন করে সর্বমোট $targetTotal টি বৈধ IPv4 ঠিকানা উদ্ধার করুন!",
              style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13),
            ),
            const SizedBox(height: 16),

            // Progress Score Bar
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppTheme.surfaceDark,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppTheme.accentNeonCyan.withOpacity(0.4)),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _isEnglish ? "Discovered: ${_practiceResults.length} / $targetTotal Valid IPs" : "সংগৃহীত: ${_practiceResults.length} / $targetTotal টি বৈধ IP",
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                      Text(
                        "${((_practiceResults.length / targetTotal) * 100).clamp(0, 100).toInt()}%",
                        style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: targetTotal == 0 ? 0.0 : (_practiceResults.length / targetTotal).clamp(0.0, 1.0),
                      backgroundColor: AppTheme.primaryDark,
                      valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.accentGreen),
                      minHeight: 8,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Feedback Banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: _practiceSolved ? AppTheme.accentGreen.withOpacity(0.2) : AppTheme.surfaceDark,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: _practiceSolved ? AppTheme.accentGreen : AppTheme.accentNeonCyan),
              ),
              child: Text(
                _isEnglish ? _userFeedbackEn : _userFeedbackBn,
                style: TextStyle(
                  color: _practiceSolved ? AppTheme.accentGreen : Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Interactive Digit String with Dot Selectors
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 18),
                decoration: BoxDecoration(
                  color: const Color(0xFF090D16),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppTheme.accentPurple),
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(_s.length, (idx) {
                      bool hasDot = _practiceDotPositions.contains(idx);

                      return Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppTheme.surfaceDark,
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: const Color(0xFF334155)),
                            ),
                            child: Text(
                              _s[idx],
                              style: const TextStyle(
                                fontFamily: 'monospace',
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          if (idx < _s.length - 1)
                            GestureDetector(
                              onTap: () => _handlePracticeDotTap(idx),
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                margin: const EdgeInsets.symmetric(horizontal: 2),
                                decoration: BoxDecoration(
                                  color: hasDot ? AppTheme.accentNeonCyan : Colors.transparent,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: AppTheme.accentNeonCyan),
                                ),
                                child: Text(
                                  ".",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: hasDot ? AppTheme.primaryDark : AppTheme.accentNeonCyan,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      );
                    }),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            if (_practiceDotPositions.isNotEmpty)
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  icon: const Icon(Icons.undo, size: 16, color: AppTheme.accentAmber),
                  label: Text(_isEnglish ? "Reset Dots" : "ডট রিসেট", style: const TextStyle(color: AppTheme.accentAmber, fontSize: 12)),
                  onPressed: _undoPracticeMove,
                ),
              ),

            const SizedBox(height: 20),

            // Discovered IPs List
            Text(
              _isEnglish
                  ? "Collected Valid IPs (${_practiceResults.length} / $targetTotal):"
                  : "সংগৃহীত বৈধ IP সমূহ (${_practiceResults.length} / $targetTotal):",
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFF090D16),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFF1E293B)),
              ),
              child: _practiceResults.isEmpty
                ? const Text("[ No Valid IPs Restored Yet ]", style: TextStyle(color: AppTheme.textMuted, fontSize: 12))
                : Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _practiceResults.map((ip) {
                      return Chip(
                        backgroundColor: AppTheme.surfaceDark,
                        avatar: const Icon(Icons.check_circle, color: AppTheme.accentGreen, size: 16),
                        label: Text(
                          "\"$ip\"",
                          style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                      );
                    }).toList(),
                  ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // Helper Widgets
  Widget _buildPresetChip(String val) {
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: ActionChip(
        backgroundColor: const Color(0xFF090D16),
        label: Text("\"$val\"", style: const TextStyle(color: AppTheme.accentNeonCyan, fontSize: 11)),
        onPressed: () {
          _sController.text = val;
          _rebuildSteps();
        },
      ),
    );
  }

  Widget _buildCodeHighlightBox(int activeLine) {
    final codeLines = [
      "void backtrack(int start, int count, string ip, vector<string>& res) {",
      "    if (count == 4) {",
      "        if (start == s.size()) res.push_back(ip.substr(0, ip.size()-1));",
      "        return;",
      "    }",
      "    for (int len = 1; len <= 3 && start + len <= s.size(); len++) {",
      "        string sub = s.substr(start, len);",
      "        if (len > 1 && sub[0] == '0') break;",
      "        if (stoi(sub) > 255) break;",
      "        backtrack(start + len, count + 1, ip + sub + \".\", res);",
      "    }",
      "}",
    ];

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF090D16),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF1E293B)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(codeLines.length, (idx) {
          final lineNum = idx + 1;
          final isHighlighted = lineNum == activeLine;

          return AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            margin: const EdgeInsets.symmetric(vertical: 1),
            decoration: BoxDecoration(
              color: isHighlighted ? AppTheme.accentPurple.withOpacity(0.25) : Colors.transparent,
              borderRadius: BorderRadius.circular(6),
              border: isHighlighted ? Border.all(color: AppTheme.accentPurple) : null,
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 24,
                  child: Text(
                    "$lineNum",
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 11,
                      color: isHighlighted ? AppTheme.accentNeonCyan : const Color(0xFF64748B),
                      fontWeight: isHighlighted ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
                if (isHighlighted)
                  const Padding(
                    padding: EdgeInsets.only(right: 6),
                    child: Icon(Icons.arrow_right_alt, color: AppTheme.accentNeonCyan, size: 14),
                  )
                else
                  const SizedBox(width: 20),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Text(
                      codeLines[idx],
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 12,
                        color: isHighlighted ? Colors.white : const Color(0xFF38BDF8),
                        fontWeight: isHighlighted ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildRestoreIPCanvas(RestoreIPAddressesStep step) {
    Color decisionColor = AppTheme.accentPurple;
    String decisionLabel = "INIT";

    if (step.decision == "valid_segment") {
      decisionColor = AppTheme.accentNeonCyan;
      decisionLabel = "✅ VALID OCTET";
    } else if (step.decision == "leading_zero_error") {
      decisionColor = AppTheme.accentPink;
      decisionLabel = "🛑 LEADING ZERO";
    } else if (step.decision == "out_of_range_error") {
      decisionColor = AppTheme.accentPink;
      decisionLabel = "🛑 > 255 OVERFLOW";
    } else if (step.decision == "valid_ip_saved") {
      decisionColor = AppTheme.accentGreen;
      decisionLabel = "🎉 IP SAVED";
    } else if (step.decision == "backtrack") {
      decisionColor = AppTheme.accentAmber;
      decisionLabel = "↩️ BACKTRACK";
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF090D16),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF1E293B)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Segment: [${step.segmentCount} / 4]", style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 13)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                  color: decisionColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: decisionColor),
                ),
                child: Text(decisionLabel, style: TextStyle(color: decisionColor, fontWeight: FontWeight.bold, fontSize: 11)),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Active Segment & Current IP State
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Tested Octet: \"${step.currentSegment}\"", style: TextStyle(color: decisionColor, fontWeight: FontWeight.bold, fontSize: 12)),
              Text("Index: ${step.startIndex}", style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 6),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppTheme.surfaceDark,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: decisionColor.withOpacity(0.5)),
            ),
            child: Text(
              step.currentIP.isEmpty ? "\"\"" : "\"${step.currentIP}\"",
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: decisionColor,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 16),

          // Saved Valid IPs List
          const Text("Saved Restored IPv4 Addresses:", style: TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
          const SizedBox(height: 6),
          Container(
            width: double.infinity,
            constraints: const BoxConstraints(minHeight: 80, maxHeight: 180),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppTheme.surfaceDark,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF1E293B)),
            ),
            child: step.allValidIPs.isEmpty
                ? const Center(child: Text("[ No Valid IPv4 Saved Yet ]", style: TextStyle(color: AppTheme.textMuted, fontSize: 12)))
                : SingleChildScrollView(
                    child: Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: step.allValidIPs.map((ip) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: AppTheme.accentGreen.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppTheme.accentGreen),
                          ),
                          child: Text(
                            "\"$ip\"",
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildControlBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: AppTheme.primaryDark,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.textMuted.withOpacity(0.4)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.skip_previous, color: Colors.white),
                onPressed: _currentStepIndex > 0 ? () => setState(() => _currentStepIndex--) : null,
              ),
              IconButton(
                icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow, color: AppTheme.accentNeonCyan),
                onPressed: _togglePlay,
              ),
              IconButton(
                icon: const Icon(Icons.skip_next, color: Colors.white),
                onPressed: _currentStepIndex < _steps.length - 1 ? () => setState(() => _currentStepIndex++) : null,
              ),
              IconButton(
                icon: const Icon(Icons.refresh, color: AppTheme.accentNeonCyan),
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
            _isEnglish
                ? "Step ${_currentStepIndex + 1} of ${_steps.length}"
                : "ধাপ ${_currentStepIndex + 1} / ${_steps.length}",
            style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildExampleCard(String label, String input, String output) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 12)),
          const SizedBox(height: 2),
          Text("Input: $input", style: const TextStyle(color: Colors.white, fontSize: 13)),
          Text(output, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildCodeSnippetBox(String lang) {
    String code = "";
    if (lang == "C++") {
      code = """
class Solution {
public:
    void backtrack(int start, int count, string ip, string& s, vector<string>& res) {
        if (count == 4) {
            if (start == s.size()) res.push_back(ip.substr(0, ip.size() - 1));
            return;
        }
        for (int len = 1; len <= 3 && start + len <= s.size(); len++) {
            string sub = s.substr(start, len);
            if (len > 1 && sub[0] == '0') break;
            if (stoi(sub) > 255) break;
            backtrack(start + len, count + 1, ip + sub + ".", s, res);
        }
    }

    vector<string> restoreIpAddresses(string s) {
        vector<string> res;
        if (s.size() < 4 || s.size() > 12) return res;
        backtrack(0, 0, "", s, res);
        return res;
    }
};""";
    } else if (lang == "Java") {
      code = """
class Solution {
    public List<String> restoreIpAddresses(String s) {
        List<String> res = new ArrayList<>();
        if (s.length() < 4 || s.length() > 12) return res;
        backtrack(0, 0, "", s, res);
        return res;
    }

    private void backtrack(int start, int count, String ip, String s, List<String> res) {
        if (count == 4) {
            if (start == s.length()) res.add(ip.substring(0, ip.length() - 1));
            return;
        }
        for (int len = 1; len <= 3 && start + len <= s.length(); len++) {
            String sub = s.substring(start, start + len);
            if (len > 1 && sub.startsWith("0")) break;
            if (Integer.parseInt(sub) > 255) break;
            backtrack(start + len, count + 1, ip + sub + ".", s, res);
        }
    }
}""";
    } else {
      code = """
class Solution:
    def restoreIpAddresses(self, s: str) -> List[str]:
        res = []
        if len(s) < 4 or len(s) > 12:
            return res

        def backtrack(start, count, ip):
            if count == 4:
                if start == len(s):
                    res.append(ip[:-1])
                return
            for length in range(1, 4):
                if start + length <= len(s):
                    sub = s[start:start + length]
                    if length > 1 and sub.startswith("0"):
                        break
                    if int(sub) > 255:
                        break
                    backtrack(start + length, count + 1, ip + sub + ".")

        backtrack(0, 0, "")
        return res""";
    }

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF090D16),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF1E293B)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("$lang Solution", style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 13)),
              IconButton(
                icon: const Icon(Icons.copy, color: AppTheme.accentNeonCyan, size: 18),
                onPressed: () => _copyToClipboard(code, lang),
              ),
            ],
          ),
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
