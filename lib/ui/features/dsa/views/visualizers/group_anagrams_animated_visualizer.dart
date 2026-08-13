import 'dart:async';
import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';

class GroupAnagramsAnimatedVisualizer extends StatefulWidget {
  final bool isEnglish;

  const GroupAnagramsAnimatedVisualizer({
    super.key,
    required this.isEnglish,
  });

  @override
  State<GroupAnagramsAnimatedVisualizer> createState() =>
      _GroupAnagramsAnimatedVisualizerState();
}

class GroupStepData {
  final String activeStr;
  final String sortedKey;
  final Map<String, List<String>> groupMap;
  final String titleEn;
  final String titleBn;
  final String explanationEn;
  final String explanationBn;

  const GroupStepData({
    required this.activeStr,
    required this.sortedKey,
    required this.groupMap,
    required this.titleEn,
    required this.titleBn,
    required this.explanationEn,
    required this.explanationBn,
  });
}

class _GroupAnagramsAnimatedVisualizerState
    extends State<GroupAnagramsAnimatedVisualizer> {
  final List<String> _strs = const ["eat", "tea", "tan", "ate", "nat", "bat"];

  int _currentStepIndex = 0;
  bool _isPlaying = false;
  Timer? _timer;

  late final List<GroupStepData> _steps;

  @override
  void initState() {
    super.initState();
    _steps = const [
      GroupStepData(
        activeStr: "-",
        sortedKey: "-",
        groupMap: {},
        titleEn: "1. Initialization",
        titleBn: "১. সূচনা (Initialization)",
        explanationEn: "strs = [\"eat\", \"tea\", \"tan\", \"ate\", \"nat\", \"bat\"]. Initialize empty Hash Map `mp` (sorted_key -> List<string>).",
        explanationBn: "strs = [\"eat\", \"tea\", \"tan\", \"ate\", \"nat\", \"bat\"]। ফাঁকা সর্টেড কী হ্যাশ ম্যাপ সূচনা করি।",
      ),
      GroupStepData(
        activeStr: "eat",
        sortedKey: "aet",
        groupMap: {
          "aet": ["eat"]
        },
        titleEn: "2. Process \"eat\" -> sortedKey = \"aet\"",
        titleBn: "২. \"eat\" প্রসেস -> সর্টেড কী = \"aet\"",
        explanationEn: "Sort \"eat\" to get key \"aet\". Push \"eat\" to `mp[\"aet\"]` bucket.",
        explanationBn: "\"eat\" সর্ট করে কী \"aet\" তৈরি। `mp[\"aet\"]` বাকেটে \"eat\" যোগ করি।",
      ),
      GroupStepData(
        activeStr: "tea",
        sortedKey: "aet",
        groupMap: {
          "aet": ["eat", "tea"]
        },
        titleEn: "3. Process \"tea\" -> sortedKey = \"aet\"",
        titleBn: "৩. \"tea\" প্রসেস -> সর্টেড কী = \"aet\"",
        explanationEn: "Sort \"tea\" to get key \"aet\". Add \"tea\" to existing bucket `mp[\"aet\"]` = [\"eat\", \"tea\"].",
        explanationBn: "\"tea\" সর্ট করে একই কী \"aet\" পাওয়া গেল! `mp[\"aet\"]` বাকেটে \"tea\" যুক্ত হলো।",
      ),
      GroupStepData(
        activeStr: "tan",
        sortedKey: "ant",
        groupMap: {
          "aet": ["eat", "tea"],
          "ant": ["tan"]
        },
        titleEn: "4. Process \"tan\" -> sortedKey = \"ant\"",
        titleBn: "৪. \"tan\" প্রসেস -> সর্টেড কী = \"ant\"",
        explanationEn: "Sort \"tan\" to get new key \"ant\". Create bucket `mp[\"ant\"]` = [\"tan\"].",
        explanationBn: "\"tan\" সর্ট করে নতুন কী \"ant\" পাওয়া গেল। নতুন বাকেট `mp[\"ant\"]` তৈরি হলো।",
      ),
      GroupStepData(
        activeStr: "all processed",
        sortedKey: "-",
        groupMap: {
          "aet": ["eat", "tea", "ate"],
          "ant": ["tan", "nat"],
          "abt": ["bat"]
        },
        titleEn: "5. All Processed -> Result Grouped! 🎉",
        titleBn: "৫. সব প্রসেস সম্পন্ন -> গ্রুপড অ্যানাগ্রামস তৈরি! 🎉",
        explanationEn: "Final Hash Map buckets: [[\"eat\",\"tea\",\"ate\"], [\"tan\",\"nat\"], [\"bat\"]]! 🎉",
        explanationBn: "চূড়ান্ত হ্যাশ বাকেটস: [[\"eat\",\"tea\",\"ate\"], [\"tan\",\"nat\"], [\"bat\"]]! 🎉",
      ),
    ];
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _togglePlay() {
    setState(() => _isPlaying = !_isPlaying);
    if (_isPlaying) {
      _timer = Timer.periodic(const Duration(milliseconds: 1500), (timer) {
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

  void _nextStep() {
    if (_currentStepIndex < _steps.length - 1) {
      setState(() => _currentStepIndex++);
    }
  }

  void _prevStep() {
    if (_currentStepIndex > 0) {
      setState(() => _currentStepIndex--);
    }
  }

  void _reset() {
    _timer?.cancel();
    setState(() {
      _isPlaying = false;
      _currentStepIndex = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final step = _steps[_currentStepIndex];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppTheme.accentPink.withOpacity(0.12),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppTheme.accentPink.withOpacity(0.5)),
          ),
          child: Row(
            children: [
              const Icon(Icons.grid_view, color: AppTheme.accentPink, size: 24),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.isEnglish ? step.titleEn : step.titleBn,
                      style: const TextStyle(color: AppTheme.accentPink, fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      widget.isEnglish ? step.explanationEn : step.explanationBn,
                      style: const TextStyle(color: Colors.white, fontSize: 12, height: 1.3),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Input strings & Hash Map Buckets Canvas
        Container(
          width: double.infinity,
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
                widget.isEnglish ? "Input Strings (strs):" : "ইনপুট স্ট্রিংস (strs):",
                style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _strs.map((s) {
                    final isCurrent = step.activeStr == s;

                    return Container(
                      margin: const EdgeInsets.only(right: 6),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: isCurrent ? AppTheme.accentPink.withOpacity(0.3) : AppTheme.surfaceDark,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: isCurrent ? AppTheme.accentPink : const Color(0xFF334155)),
                      ),
                      child: Text(
                        "\"$s\"",
                        style: TextStyle(fontFamily: 'monospace', fontSize: 13, fontWeight: FontWeight.bold, color: isCurrent ? AppTheme.accentPink : Colors.white70),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 18),

              Text(
                widget.isEnglish ? "Sorted Key Anagram Buckets:" : "সর্টেড কী অ্যানাগ্রাম বাকেটস:",
                style: const TextStyle(color: AppTheme.accentPink, fontSize: 12, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

              Column(
                children: step.groupMap.entries.map((entry) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F172A),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppTheme.accentPink.withOpacity(0.5)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(color: AppTheme.accentPink, borderRadius: BorderRadius.circular(6)),
                          child: Text("key: \"${entry.key}\"", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11, fontFamily: 'monospace')),
                        ),
                        const SizedBox(width: 10),
                        const Icon(Icons.arrow_forward, color: AppTheme.accentGreen, size: 16),
                        const SizedBox(width: 10),
                        Expanded(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: entry.value.map((valStr) {
                                return Container(
                                  margin: const EdgeInsets.only(right: 6),
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: AppTheme.accentGreen.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(color: AppTheme.accentGreen),
                                  ),
                                  child: Text("\"$valStr\"", style: const TextStyle(color: AppTheme.accentGreen, fontWeight: FontWeight.bold, fontSize: 12, fontFamily: 'monospace')),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        _buildControls(),
      ],
    );
  }

  Widget _buildControls() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF334155)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            icon: const Icon(Icons.replay, color: Colors.white70),
            onPressed: _reset,
            tooltip: widget.isEnglish ? "Reset" : "রিসেট",
          ),
          IconButton(
            icon: const Icon(Icons.skip_previous, color: Colors.white),
            onPressed: _currentStepIndex > 0 ? _prevStep : null,
            tooltip: widget.isEnglish ? "Previous Step" : "আগের স্টেপ",
          ),
          IconButton(
            icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
            onPressed: _togglePlay,
            tooltip: _isPlaying
                ? (widget.isEnglish ? "Pause" : "পজ করুন")
                : (widget.isEnglish ? "Auto Play" : "অটো প্লে"),
          ),
          IconButton(
            icon: const Icon(Icons.skip_next, color: Colors.white),
            onPressed: _currentStepIndex < _steps.length - 1 ? _nextStep : null,
            tooltip: widget.isEnglish ? "Next Step" : "পরের স্টেপ",
          ),
          Text(
            "${_currentStepIndex + 1}/${_steps.length}",
            style: const TextStyle(color: AppTheme.accentPink, fontWeight: FontWeight.bold, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
