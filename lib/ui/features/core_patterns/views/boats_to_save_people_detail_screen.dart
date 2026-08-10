import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';
import 'package:algorithmix/ui/features/core_patterns/widgets/boats_to_save_people_code_free_visualizer.dart';

class BoatsStep {
  final int left;
  final int right;
  final int limit;
  final int activeLine;
  final List<int> sortedPeople;
  final int boatsCount;
  final String actionEn;
  final String actionBn;
  final String reasonEn;
  final String reasonBn;
  final bool isFinish;

  const BoatsStep({
    required this.left,
    required this.right,
    required this.limit,
    required this.activeLine,
    required this.sortedPeople,
    required this.boatsCount,
    required this.actionEn,
    required this.actionBn,
    required this.reasonEn,
    required this.reasonBn,
    this.isFinish = false,
  });
}

class BoatsToSavePeopleDetailScreen extends StatefulWidget {
  const BoatsToSavePeopleDetailScreen({super.key});

  @override
  State<BoatsToSavePeopleDetailScreen> createState() =>
      _BoatsToSavePeopleDetailScreenState();
}

class _BoatsToSavePeopleDetailScreenState
    extends State<BoatsToSavePeopleDetailScreen>
    with SingleTickerProviderStateMixin {
  bool _isEnglish = true;
  late TabController _tabController;

  // Custom Input State
  final TextEditingController _inputController =
      TextEditingController(text: "3, 2, 2, 1");
  final TextEditingController _limitController =
      TextEditingController(text: "3");

  List<int> _currentPeople = [3, 2, 2, 1];
  int _currentLimit = 3;

  List<BoatsStep> _steps = [];

  // Playback Control
  int _currentStepIndex = 0;
  bool _isPlaying = false;
  Timer? _timer;

  // Practice Mode State
  bool _showAnswer = false;
  int _userLeft = 0;
  int _userRight = 3;
  List<int> _userSortedPeople = [1, 2, 2, 3];
  int _userBoatsCount = 0;
  String _userFeedbackEn = "Compare people[left] + people[right] with limit. Choose 'Pair Light & Heavy' or 'Send Heavy Alone'!";
  String _userFeedbackBn = "ওজনের যোগফল ও নৌকার লিমিট তুলনা করে বাটন সিলেক্ট করুন!";
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
    _inputController.dispose();
    _limitController.dispose();
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

    try {
      _currentLimit = int.parse(_limitController.text.trim());
      List<int> parsed = _inputController.text
          .split(',')
          .map((e) => int.parse(e.trim()))
          .toList();
      if (parsed.isEmpty) {
        parsed = [3, 2, 2, 1];
      }
      _currentPeople = parsed;
    } catch (_) {
      _currentPeople = [3, 2, 2, 1];
      _currentLimit = 3;
    }

    List<int> sorted = List.from(_currentPeople);
    sorted.sort();
    _userSortedPeople = List.from(sorted);
    _userLeft = 0;
    _userRight = sorted.length - 1;
    _userBoatsCount = 0;
    _userSolved = false;
    _userFeedbackEn = "Start rescuing people with boats!";
    _userFeedbackBn = "নৌকায় যাত্রী তোলা শুরু করুন!";

    _steps = _generateSteps(_currentPeople, _currentLimit);
    setState(() {});
  }

  List<BoatsStep> _generateSteps(List<int> orig, int limit) {
    List<BoatsStep> steps = [];
    List<int> people = List.from(orig);
    people.sort();

    int n = people.length;
    if (n == 0) return steps;

    int left = 0;
    int right = n - 1;
    int boats = 0;

    // Line 2: Sort
    steps.add(BoatsStep(
      left: left,
      right: right,
      limit: limit,
      activeLine: 2,
      sortedPeople: List.from(people),
      boatsCount: 0,
      actionEn: "Line 2: sort(people) → [${people.join(', ')}]",
      actionBn: "লাইন ২: sort(people) → [${people.join(', ')}]",
      reasonEn: "Array sorted ascending. Left (0) = lightest, Right (${n - 1}) = heaviest.",
      reasonBn: "ওজন অনুযায়ী সর্টেড। হালকা (left) ও ভারী (right) পয়েন্টার প্রস্তুত।",
    ));

    while (left <= right) {
      if (left == right) {
        boats++;
        steps.add(BoatsStep(
          left: left,
          right: right,
          limit: limit,
          activeLine: 5,
          sortedPeople: List.from(people),
          boatsCount: boats,
          actionEn: "Line 5: Single person remaining (${people[left]}) → Boat #$boats ⛵",
          actionBn: "লাইন ৫: সর্বশেষ ১ জন বাকি (${people[left]}) → নৌকা #$boats ⛵",
          reasonEn: "Last person gets dedicated boat #$boats.",
          reasonBn: "অবশিষ্ট ব্যক্তি একক নৌকায় পার হলেন।",
        ));
        break;
      }

      int sum = people[left] + people[right];

      if (sum <= limit) {
        boats++;
        steps.add(BoatsStep(
          left: left,
          right: right,
          limit: limit,
          activeLine: 6,
          sortedPeople: List.from(people),
          boatsCount: boats,
          actionEn: "Line 6: people[$left] (${people[left]}) + people[$right] (${people[right]}) = $sum <= $limit → Pair! Boat #$boats, left++, right--",
          actionBn: "লাইন ৬: people[$left] (${people[left]}) + people[$right] (${people[right]}) = $sum <= $limit → জোড় তৈরি! নৌকা #$boats, left++, right--",
          reasonEn: "Lightest and heaviest fit in 1 boat together!",
          reasonBn: "সবচেয়ে হালকা ও ভারী ব্যক্তি একই নৌকায় পার হলেন!",
        ));
        left++;
        right--;
      } else {
        boats++;
        steps.add(BoatsStep(
          left: left,
          right: right,
          limit: limit,
          activeLine: 9,
          sortedPeople: List.from(people),
          boatsCount: boats,
          actionEn: "Line 9: sum ($sum) > limit ($limit) → Heavy alone (${people[right]}) in Boat #$boats, right--",
          actionBn: "লাইন ৯: sum ($sum) > limit ($limit) → ভারী ব্যক্তি (${people[right]}) একা নৌকা #$boats, right--",
          reasonEn: "Heaviest person cannot pair with lightest. Takes boat alone.",
          reasonBn: "ভারী ব্যক্তি হালকা জনের সাথেও ধরে না। তিনি একা পার হবেন।",
        ));
        right--;
      }
    }

    // Line 12: Finish
    steps.add(BoatsStep(
      left: 0,
      right: n - 1,
      limit: limit,
      activeLine: 12,
      sortedPeople: List.from(people),
      boatsCount: boats,
      actionEn: "Line 12: return boats 🎉 Minimum Boats = $boats",
      actionBn: "লাইন ১২: return boats 🎉 সর্বনিম্ন নৌকা = $boats",
      reasonEn: "All people rescued! Greedy strategy guaranteed minimum boats.",
      reasonBn: "সকল যাত্রী পার হয়েছেন! গ্রিডি অ্যালগরিদম সফলভাবে সম্পন্ন।",
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

  void _loadPreset(List<int> people, int limit) {
    _inputController.text = people.join(', ');
    _limitController.text = limit.toString();
    _rebuildSteps();
  }

  void _handleUserAction(String action) {
    if (_userSolved || _userLeft > _userRight) return;

    final p = _userSortedPeople;

    setState(() {
      if (_userLeft == _userRight) {
        _userBoatsCount++;
        _userSolved = true;
        _userFeedbackEn = "🎉 Fantastic! Last person saved. Total Boats = $_userBoatsCount!";
        _userFeedbackBn = "🎉 দারুণ! শেষ ব্যক্তি পার হলেন। মোট নৌকা = $_userBoatsCount!";
        return;
      }

      int sum = p[_userLeft] + p[_userRight];

      if (action == "pair") {
        if (sum <= _currentLimit) {
          _userBoatsCount++;
          _userLeft++;
          _userRight--;
          _userFeedbackEn = "✅ Correct! Paired ${p[_userLeft - 1]} & ${p[_userRight + 1]} in Boat #$_userBoatsCount.";
          _userFeedbackBn = "✅ সঠিক! ২ জনকে ১টি নৌকায় পার করা হলো।";
        } else {
          _userFeedbackEn = "⚠️ Sum ($sum) exceeds limit ($_currentLimit)! Heavy person must go alone.";
          _userFeedbackBn = "⚠️ যোগফল লিমিট ছাড়িয়ে গেছে! ভারী ব্যক্তি একা যাবেন।";
        }
      } else if (action == "alone") {
        if (sum > _currentLimit) {
          _userBoatsCount++;
          _userRight--;
          _userFeedbackEn = "✅ Correct! Heavy person (${p[_userRight + 1]}) took Boat #$_userBoatsCount alone.";
          _userFeedbackBn = "✅ সঠিক! ভারী ব্যক্তি একা পার হলেন।";
        } else {
          _userFeedbackEn = "⚠️ Sum ($sum) <= limit ($_currentLimit)! You can pair them together.";
          _userFeedbackBn = "⚠️ যোগফল লিমিটের ভেতরে! ২ জন একসাথে যেতে পারবেন।";
        }
      }

      if (_userLeft > _userRight) {
        _userSolved = true;
        _userFeedbackEn = "🎉 Perfect! Minimum Boats Required = $_userBoatsCount ⛵!";
        _userFeedbackBn = "🎉 দারুণ! সর্বনিম্ন প্রয়োজনীয় নৌকা = $_userBoatsCount ⛵!";
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
          '881. Boats to Save People',
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
                    color: AppTheme.accentAmber.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppTheme.accentAmber),
                  ),
                  child: Text(
                    '🟡 Medium',
                    style: TextStyle(
                        color: AppTheme.accentAmber,
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
                    'LeetCode #881',
                    style: TextStyle(
                        color: AppTheme.accentNeonCyan,
                        fontWeight: FontWeight.bold,
                        fontSize: Responsive.sp(context, 12)),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.accentPink.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppTheme.accentPink),
                  ),
                  child: Text(
                    '⭐ Greedy Two Pointers Classic',
                    style: TextStyle(
                        color: AppTheme.accentPink,
                        fontWeight: FontWeight.bold,
                        fontSize: Responsive.sp(context, 12)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              _isEnglish
                  ? 'Boats to Save People'
                  : 'বোটস টু সেভ পিপল (Boats to Save People)',
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
                        ? 'You are given an array people where people[i] is the weight of the ith person, and an infinite number of boats where each boat can carry a maximum weight of limit.\n\nEach boat carries at most two people at the same time, provided the sum of the weight of those people is at most limit.\n\nReturn the minimum number of boats to carry every given person.'
                        : 'মানুষের ওজনের অ্যারে people এবং প্রতিটি নৌকার সর্বোচ্চ বহন ক্ষমতা limit দেওয়া আছে। প্রতিটি নৌকায় সর্বোচ্চ ২ জন বসতে পারেন যাদের ওজনের যোগফল limit এর চেয়ে বেশি নয়।\n\nসকলকে পার করার জন্য সর্বনিম্ন কতটি নৌকা প্রয়োজন তা বের করুন।',
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
              "people = [1, 2], limit = 3",
              "Output: 1",
              _isEnglish
                  ? "Explanation: 1 boat carries (1, 2)."
                  : "ব্যাখ্যা: ১টি নৌকায় (১, ২) উভয় ব্যক্তি পার হন।",
            ),
            _buildExampleCard(
              "Example 2",
              "people = [3, 2, 2, 1], limit = 3",
              "Output: 3",
              _isEnglish
                  ? "Explanation: Boats: (1, 2), (2), (3). Total 3 boats."
                  : "ব্যাখ্যা: নৌকা ৩টি: (১, ২), (২), (৩)।",
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
      child: BoatsToSavePeopleCodeFreeVisualizer(isEnglish: _isEnglish),
    );
  }

  // TAB 3: Dynamic Visualizer
  Widget _buildVisualizerTab(double hPadding) {
    final isMobile = Responsive.isMobile(context);
    final step = _steps.isEmpty
        ? BoatsStep(
            left: 0,
            right: 0,
            limit: _currentLimit,
            activeLine: 0,
            sortedPeople: _currentPeople,
            boatsCount: 0,
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
                          controller: _inputController,
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'monospace',
                              fontSize: Responsive.sp(context, 13)),
                          decoration: InputDecoration(
                            labelText: _isEnglish
                                ? 'People Weights Array (comma separated)'
                                : 'মানুষের ওজনের অ্যারে (কমা দিয়ে separated)',
                            hintText: 'e.g. 3, 2, 2, 1',
                            labelStyle: TextStyle(fontSize: Responsive.sp(context, 12)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      SizedBox(
                        width: 90,
                        child: TextField(
                          controller: _limitController,
                          keyboardType: TextInputType.number,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: Responsive.sp(context, 13)),
                          decoration: InputDecoration(
                            labelText: 'limit',
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
                        _buildPresetChip('[3,2,2,1], limit 3', [3, 2, 2, 1], 3),
                        _buildPresetChip('[3,5,3,4], limit 5', [3, 5, 3, 4], 5),
                        _buildPresetChip('[5,1,4,2], limit 6', [5, 1, 4, 2], 6),
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
    final p = _userSortedPeople;
    final valL = _userLeft <= _userRight ? p[_userLeft] : 0;
    final valR = _userLeft <= _userRight ? p[_userRight] : 0;
    final currentSum = valL + valR;

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
                            ? '🎮 Practice Mode: Save People With Minimum Boats!'
                            : '🎮 প্র্যাকটিস মোড: নিজে সর্বনিম্ন নৌকায় যাত্রী পার করুন!',
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
                    _isEnglish
                        ? 'Sorted Weights: [${_userSortedPeople.join(', ')}], Limit: $_currentLimit'
                        : 'সর্টেড ওজন: [${_userSortedPeople.join(', ')}], লিমিট: $_currentLimit',
                    style: TextStyle(
                        color: AppTheme.accentNeonCyan,
                        fontWeight: FontWeight.bold,
                        fontSize: Responsive.sp(context, 13)),
                  ),
                  const SizedBox(height: 16),

                  // Current Boat Gauge
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
                          "Light + Heavy: $currentSum (limit: $_currentLimit)",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: Responsive.sp(context, 12.5)),
                        ),
                        Text(
                          "Boats Used: $_userBoatsCount ⛵",
                          style: TextStyle(
                              color: AppTheme.accentGreen,
                              fontWeight: FontWeight.bold,
                              fontSize: Responsive.sp(context, 12.5)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // People Array View
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(p.length, (idx) {
                        final val = p[idx];
                        final isLeft = idx == _userLeft;
                        final isRight = idx == _userRight;

                        Color boxBg = AppTheme.primaryDark;
                        Color borderColor = const Color(0xFF334155);

                        if (isLeft && isRight) {
                          boxBg = AppTheme.accentGreen.withOpacity(0.3);
                          borderColor = AppTheme.accentGreen;
                        } else if (isLeft) {
                          boxBg = AppTheme.accentNeonCyan.withOpacity(0.25);
                          borderColor = AppTheme.accentNeonCyan;
                        } else if (isRight) {
                          boxBg = AppTheme.accentAmber.withOpacity(0.25);
                          borderColor = AppTheme.accentAmber;
                        }

                        return Container(
                          margin: const EdgeInsets.only(right: 8),
                          padding: EdgeInsets.symmetric(
                            horizontal: Responsive.sp(context, 14),
                            vertical: Responsive.sp(context, 10),
                          ),
                          decoration: BoxDecoration(
                            color: boxBg,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: borderColor, width: 2),
                          ),
                          child: Column(
                            children: [
                              if (isLeft && isRight)
                                Text('L&R',
                                    style: TextStyle(
                                        fontSize: Responsive.sp(context, 10),
                                        color: AppTheme.accentGreen,
                                        fontWeight: FontWeight.bold))
                              else if (isLeft)
                                Text('Light',
                                    style: TextStyle(
                                        fontSize: Responsive.sp(context, 10),
                                        color: AppTheme.accentNeonCyan,
                                        fontWeight: FontWeight.bold))
                              else if (isRight)
                                Text('Heavy',
                                    style: TextStyle(
                                        fontSize: Responsive.sp(context, 10),
                                        color: AppTheme.accentAmber,
                                        fontWeight: FontWeight.bold))
                              else
                                Text(' ',
                                    style: TextStyle(fontSize: Responsive.sp(context, 10))),
                              const SizedBox(height: 4),
                              Text(
                                '$val',
                                style: TextStyle(
                                    fontSize: Responsive.sp(context, 18),
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '[$idx]',
                                style: TextStyle(
                                    fontSize: Responsive.sp(context, 9),
                                    color: AppTheme.textMuted),
                              ),
                            ],
                          ),
                        );
                      }),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // User Action Buttons
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      ElevatedButton.icon(
                        onPressed: _userSolved || _userLeft > _userRight
                            ? null
                            : () => _handleUserAction("pair"),
                        icon: Icon(Icons.sailing, size: Responsive.sp(context, 16)),
                        label: Text(
                            _isEnglish
                                ? 'Pair Light & Heavy (Sum <= Limit)'
                                : '২ জন একসাথে পার করুন (Sum <= Limit)',
                            style: TextStyle(fontSize: Responsive.sp(context, 13))),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.accentGreen),
                      ),
                      ElevatedButton.icon(
                        onPressed: _userSolved || _userLeft > _userRight
                            ? null
                            : () => _handleUserAction("alone"),
                        icon: Icon(Icons.directions_boat, size: Responsive.sp(context, 16)),
                        label: Text(
                            _isEnglish
                                ? 'Send Heavy Alone (Sum > Limit)'
                                : 'ভারী ব্যক্তি একা পার করুন (Sum > Limit)',
                            style: TextStyle(fontSize: Responsive.sp(context, 13))),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.accentAmber),
                      ),
                      OutlinedButton.icon(
                        onPressed: () {
                          setState(() {
                            List<int> sorted = List.from(_currentPeople);
                            sorted.sort();
                            _userSortedPeople = List.from(sorted);
                            _userLeft = 0;
                            _userRight = sorted.length - 1;
                            _userBoatsCount = 0;
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
                                ? "• Time Complexity: O(N log N) — Sorting takes O(N log N), Two Pointers loop runs N times.\n• Space Complexity: O(1) auxiliary space (or O(N) depending on sort implementation)."
                                : "• টাইম কমপ্লেক্সিটি: O(N log N) — সর্টিং এ O(N log N) এবং টু-পয়েন্টারে O(N)।\n• স্পেস কমপ্লেক্সিটি: O(1) অতিরিক্ত মেমোরি।",
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

  Widget _buildPresetChip(String label, List<int> people, int limit) {
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: ActionChip(
        label: Text(label,
            style: TextStyle(
                fontSize: Responsive.sp(context, 11), color: Colors.white)),
        backgroundColor: AppTheme.primaryDark,
        onPressed: () => _loadPreset(people, limit),
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
      "int numRescueBoats(vector<int>& people, int limit) {",
      "    sort(people.begin(), people.end());",
      "    int left = 0, right = people.size() - 1;",
      "    int boats = 0;",
      "    while (left <= right) {",
      "        if (people[left] + people[right] <= limit) {",
      "            left++;",
      "        }",
      "        right--;",
      "        boats++;",
      "    }",
      "    return boats;",
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

  Widget _buildArrayVisualizationBox(BoatsStep step) {
    final arr = step.sortedPeople;

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
                "Sorted People Pointers State",
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
                  "Limit: ${step.limit}",
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
              children: List.generate(arr.length, (idx) {
                final val = arr[idx];
                final isLeft = idx == step.left;
                final isRight = idx == step.right;

                Color boxBg = AppTheme.primaryDark;
                Color borderColor = const Color(0xFF334155);

                if (isLeft && isRight) {
                  boxBg = AppTheme.accentGreen.withOpacity(0.25);
                  borderColor = AppTheme.accentGreen;
                } else if (isLeft) {
                  boxBg = AppTheme.accentNeonCyan.withOpacity(0.25);
                  borderColor = AppTheme.accentNeonCyan;
                } else if (isRight) {
                  boxBg = AppTheme.accentAmber.withOpacity(0.25);
                  borderColor = AppTheme.accentAmber;
                }

                return Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: EdgeInsets.symmetric(
                    horizontal: Responsive.sp(context, 12),
                    vertical: Responsive.sp(context, 10),
                  ),
                  decoration: BoxDecoration(
                    color: boxBg,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: borderColor, width: 2),
                  ),
                  child: Column(
                    children: [
                      if (isLeft && isRight)
                        Text('L&R',
                            style: TextStyle(
                                fontSize: Responsive.sp(context, 9.5),
                                color: AppTheme.accentGreen,
                                fontWeight: FontWeight.bold))
                      else if (isLeft)
                        Text('Light',
                            style: TextStyle(
                                fontSize: Responsive.sp(context, 9.5),
                                color: AppTheme.accentNeonCyan,
                                fontWeight: FontWeight.bold))
                      else if (isRight)
                        Text('Heavy',
                            style: TextStyle(
                                fontSize: Responsive.sp(context, 9.5),
                                color: AppTheme.accentAmber,
                                fontWeight: FontWeight.bold))
                      else
                        Text(' ',
                            style: TextStyle(fontSize: Responsive.sp(context, 9.5))),
                      const SizedBox(height: 4),
                      Text(
                        '$val',
                        style: TextStyle(
                          fontSize: Responsive.sp(context, 16),
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '[$idx]',
                        style: TextStyle(
                            fontSize: Responsive.sp(context, 9),
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
    int numRescueBoats(vector<int>& people, int limit) {
        sort(people.begin(), people.end());
        int left = 0, right = people.size() - 1;
        int boats = 0;
        
        while (left <= right) {
            if (people[left] + people[right] <= limit) {
                left++;
            }
            right--;
            boats++;
        }
        return boats;
    }
};""";
    } else if (lang == "Java") {
      code = """
class Solution {
    public int numRescueBoats(int[] people, int limit) {
        Arrays.sort(people);
        int left = 0, right = people.length - 1;
        int boats = 0;
        
        while (left <= right) {
            if (people[left] + people[right] <= limit) {
                left++;
            }
            right--;
            boats++;
        }
        return boats;
    }
}""";
    } else if (lang == "Python") {
      code = """
class Solution:
    def numRescueBoats(self, people: List[int], limit: int) -> int:
        people.sort()
        left, right = 0, len(people) - 1
        boats = 0
        
        while left <= right:
            if people[left] + people[right] <= limit:
                left += 1
            right -= 1
            boats += 1
        return boats""";
    } else {
      code = """
int numRescueBoats(List<int> people, int limit) {
  people.sort();
  int left = 0, right = people.length - 1;
  int boats = 0;

  while (left <= right) {
    if (people[left] + people[right] <= limit) {
      left++;
    }
    right--;
    boats++;
  }
  return boats;
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
