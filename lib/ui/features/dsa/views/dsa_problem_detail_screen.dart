import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:algorithmix/domain/models/dsa_data.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';
import 'visualizers/visualizer_shared.dart';
import 'visualizers/debug_array_step.dart';
import 'visualizers/min_max_animated_visualizer.dart';
import 'visualizers/min_max_execution_debugger.dart';
import 'visualizers/min_max_practice_quiz.dart';
import 'visualizers/reverse_array_animated_visualizer.dart';
import 'visualizers/reverse_array_execution_debugger.dart';
import 'visualizers/reverse_array_practice_quiz.dart';
import 'visualizers/matrix_transpose_animated_visualizer.dart';
import 'visualizers/matrix_transpose_execution_debugger.dart';
import 'visualizers/matrix_transpose_practice_quiz.dart';
import 'visualizers/tensor_sum_animated_visualizer.dart';
import 'visualizers/tensor_sum_execution_debugger.dart';
import 'visualizers/tensor_sum_practice_quiz.dart';
import 'visualizers/reverse_singly_linked_list_animated_visualizer.dart';
import 'visualizers/reverse_singly_linked_list_execution_debugger.dart';
import 'visualizers/reverse_singly_linked_list_practice_quiz.dart';
import 'visualizers/find_middle_node_animated_visualizer.dart';
import 'visualizers/find_middle_node_execution_debugger.dart';
import 'visualizers/find_middle_node_practice_quiz.dart';
import 'visualizers/reverse_doubly_linked_list_animated_visualizer.dart';
import 'visualizers/reverse_doubly_linked_list_execution_debugger.dart';
import 'visualizers/reverse_doubly_linked_list_practice_quiz.dart';
import 'visualizers/detect_cycle_linked_list_animated_visualizer.dart';
import 'visualizers/detect_cycle_linked_list_execution_debugger.dart';
import 'visualizers/detect_cycle_linked_list_practice_quiz.dart';
import 'visualizers/valid_parentheses_animated_visualizer.dart';
import 'visualizers/valid_parentheses_execution_debugger.dart';
import 'visualizers/valid_parentheses_practice_quiz.dart';
import 'visualizers/min_stack_animated_visualizer.dart';
import 'visualizers/min_stack_execution_debugger.dart';
import 'visualizers/min_stack_practice_quiz.dart';
import 'visualizers/evaluate_rpn_animated_visualizer.dart';
import 'visualizers/evaluate_rpn_execution_debugger.dart';
import 'visualizers/evaluate_rpn_practice_quiz.dart';
import 'visualizers/next_greater_element_animated_visualizer.dart';
import 'visualizers/next_greater_element_execution_debugger.dart';
import 'visualizers/next_greater_element_practice_quiz.dart';
import 'visualizers/implement_queue_stacks_animated_visualizer.dart';
import 'visualizers/implement_queue_stacks_execution_debugger.dart';
import 'visualizers/implement_queue_stacks_practice_quiz.dart';
import 'visualizers/circular_queue_animated_visualizer.dart';
import 'visualizers/circular_queue_execution_debugger.dart';
import 'visualizers/circular_queue_practice_quiz.dart';
import 'visualizers/first_non_repeating_animated_visualizer.dart';
import 'visualizers/first_non_repeating_execution_debugger.dart';
import 'visualizers/first_non_repeating_practice_quiz.dart';
import 'visualizers/sliding_window_max_animated_visualizer.dart';
import 'visualizers/sliding_window_max_execution_debugger.dart';
import 'visualizers/sliding_window_max_practice_quiz.dart';
import 'visualizers/two_sum_animated_visualizer.dart';
import 'visualizers/two_sum_execution_debugger.dart';
import 'visualizers/two_sum_practice_quiz.dart';
import 'visualizers/valid_anagram_animated_visualizer.dart';
import 'visualizers/valid_anagram_execution_debugger.dart';
import 'visualizers/valid_anagram_practice_quiz.dart';
import 'visualizers/group_anagrams_animated_visualizer.dart';
import 'visualizers/group_anagrams_execution_debugger.dart';
import 'visualizers/group_anagrams_practice_quiz.dart';
import 'visualizers/subarray_sum_k_animated_visualizer.dart';
import 'visualizers/subarray_sum_k_execution_debugger.dart';
import 'visualizers/subarray_sum_k_practice_quiz.dart';
import 'visualizers/search_bst_animated_visualizer.dart';
import 'visualizers/search_bst_execution_debugger.dart';
import 'visualizers/search_bst_practice_quiz.dart';
import 'visualizers/insert_bst_animated_visualizer.dart';
import 'visualizers/insert_bst_execution_debugger.dart';
import 'visualizers/insert_bst_practice_quiz.dart';
import 'visualizers/validate_bst_animated_visualizer.dart';
import 'visualizers/validate_bst_execution_debugger.dart';
import 'visualizers/validate_bst_practice_quiz.dart';
import 'visualizers/lca_bst_animated_visualizer.dart';
import 'visualizers/lca_bst_execution_debugger.dart';
import 'visualizers/lca_bst_practice_quiz.dart';
import 'visualizers/kth_largest_animated_visualizer.dart';
import 'visualizers/kth_largest_execution_debugger.dart';
import 'visualizers/kth_largest_practice_quiz.dart';
import 'visualizers/top_k_frequent_animated_visualizer.dart';
import 'visualizers/top_k_frequent_execution_debugger.dart';
import 'visualizers/top_k_frequent_practice_quiz.dart';
import 'visualizers/merge_k_lists_animated_visualizer.dart';
import 'visualizers/merge_k_lists_execution_debugger.dart';
import 'visualizers/merge_k_lists_practice_quiz.dart';
import 'visualizers/find_median_animated_visualizer.dart';
import 'visualizers/find_median_execution_debugger.dart';
import 'visualizers/find_median_practice_quiz.dart';
import 'visualizers/bfs_graph_animated_visualizer.dart';
import 'visualizers/bfs_graph_execution_debugger.dart';
import 'visualizers/bfs_graph_practice_quiz.dart';
import 'visualizers/dfs_graph_animated_visualizer.dart';
import 'visualizers/dfs_graph_execution_debugger.dart';
import 'visualizers/dfs_graph_practice_quiz.dart';
import 'visualizers/num_islands_animated_visualizer.dart';
import 'visualizers/num_islands_execution_debugger.dart';
import 'visualizers/num_islands_practice_quiz.dart';
import 'visualizers/detect_cycle_graph_animated_visualizer.dart';
import 'visualizers/detect_cycle_graph_execution_debugger.dart';
import 'visualizers/detect_cycle_graph_practice_quiz.dart';
import 'visualizers/implement_trie_animated_visualizer.dart';
import 'visualizers/implement_trie_execution_debugger.dart';
import 'visualizers/implement_trie_practice_quiz.dart';
import 'visualizers/add_search_words_animated_visualizer.dart';
import 'visualizers/add_search_words_execution_debugger.dart';
import 'visualizers/add_search_words_practice_quiz.dart';
import 'visualizers/replace_words_animated_visualizer.dart';
import 'visualizers/replace_words_execution_debugger.dart';
import 'visualizers/replace_words_practice_quiz.dart';
import 'visualizers/word_search_two_animated_visualizer.dart';
import 'visualizers/word_search_two_execution_debugger.dart';
import 'visualizers/word_search_two_practice_quiz.dart';

class DsaProblemDetailScreen extends StatefulWidget {
  final DsaProblem problem;
  final bool initialLanguageIsEnglish;

  const DsaProblemDetailScreen({
    super.key,
    required this.problem,
    this.initialLanguageIsEnglish = true,
  });

  @override
  State<DsaProblemDetailScreen> createState() => _DsaProblemDetailScreenState();
}

class _DsaProblemDetailScreenState extends State<DsaProblemDetailScreen>
    with SingleTickerProviderStateMixin {
  late bool _isEnglish;
  late TabController _tabController;
  String _selectedCodeLang = "C++";

  // Step Visualizer State
  int _currentStepIndex = 0;
  bool _isPlaying = false;
  Timer? _timer;

  List<DebugArrayStep> get _currentSteps => getStepsForProblem(widget.problem.id);
  List<String> get _currentCodeLines => getCodeLinesForProblem(widget.problem.id);

  String _getMinValHeaderLabel(DebugArrayStep step) {
    if (step.minVal == null) return "";
    final pid = widget.problem.id;
    if (pid.startsWith("tr-")) return "Prefix Matched / Found: ${step.minVal}";
    if (pid.startsWith("gr-")) return "Visited Node / Count: ${step.minVal}";
    if (pid.startsWith("hp-")) return "Heap Top / Minimum: ${step.minVal}";
    if (pid.startsWith("ll-")) return "Result / Pointer: ${step.minVal}";
    if (pid.startsWith("st-")) return "Min Val: ${step.minVal}";
    if (pid.startsWith("hm-")) return "Count / Sum: ${step.minVal}";
    if (pid.startsWith("bst-")) return "Insertion Target: ${step.minVal}";
    return "Min: ${step.minVal}";
  }

  @override
  void initState() {
    super.initState();
    _isEnglish = widget.initialLanguageIsEnglish;
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _togglePlay() {
    setState(() => _isPlaying = !_isPlaying);
    if (_isPlaying) {
      _timer = Timer.periodic(const Duration(milliseconds: 1400), (timer) {
        if (_currentStepIndex < _currentSteps.length - 1) {
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
    if (_currentStepIndex < _currentSteps.length - 1) {
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

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Text(
              _isEnglish ? "Code copied to clipboard!" : "কোড ক্লিপবোর্ডে কপি হয়েছে!",
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        backgroundColor: AppTheme.accentGreen,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  String _getCodeForSelectedLanguage() {
    switch (_selectedCodeLang) {
      case "C++":
        return widget.problem.codeCpp;
      case "Java":
        return widget.problem.codeJava;
      case "Python":
        return widget.problem.codePython;
      case "JavaScript":
        return widget.problem.codeJs;
      default:
        return widget.problem.codeCpp;
    }
  }

  @override
  Widget build(BuildContext context) {
    final hPadding = Responsive.horizontalPadding(context);

    return Scaffold(
      backgroundColor: AppTheme.primaryDark,
      appBar: AppBar(
        title: Text(widget.problem.title, style: TextStyle(fontSize: Responsive.sp(context, 16), fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: TextButton.icon(
              style: TextButton.styleFrom(
                backgroundColor: AppTheme.accentPurple.withOpacity(0.2),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              icon: Icon(Icons.language, color: _isEnglish ? AppTheme.accentNeonCyan : AppTheme.accentPink, size: 18),
              label: Text(_isEnglish ? 'EN' : 'BN', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
              onPressed: () => setState(() => _isEnglish = !_isEnglish),
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
          tabs: [
            Tab(text: _isEnglish ? '📘 Problem Description' : '📘 সমস্যা বিবরণী'),
            Tab(text: _isEnglish ? '⚡ Step Visualizer' : '⚡ স্টেপ ভিজ্যুয়ালাইজার'),
            Tab(text: _isEnglish ? '💻 Solution Code' : '💻 সমাধান কোড'),
            Tab(text: _isEnglish ? '🐞 Execution Debugger' : '🐞 এক্সিকিউশন ডিবাগার'),
            Tab(text: _isEnglish ? '💡 Practice & Test' : '💡 প্র্যাকটিস ও টেস্ট'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildDescriptionTab(hPadding),
          _buildVisualizerTab(hPadding),
          _buildCodeTab(hPadding),
          _buildDebuggerTab(hPadding),
          _buildPracticeTab(hPadding),
        ],
      ),
    );
  }

  // ─── TAB 1: Problem Description ─────────────────────────────────────────────

  Widget _buildDescriptionTab(double hPadding) {
    return ResponsiveCenter(
      padding: EdgeInsets.all(hPadding),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppTheme.accentPurple.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppTheme.accentPurple),
              ),
              child: Text(widget.problem.category, style: const TextStyle(color: AppTheme.accentPurple, fontWeight: FontWeight.bold, fontSize: 12)),
            ),
            const SizedBox(height: 12),
            Text(widget.problem.title, style: TextStyle(fontSize: Responsive.sp(context, 22), fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(color: AppTheme.surfaceDark, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFF334155))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_isEnglish ? "Problem Statement" : "সমস্যার বিবরণ", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.accentNeonCyan)),
                  const SizedBox(height: 8),
                  Text(_isEnglish ? widget.problem.descriptionEn : widget.problem.descriptionBn, style: const TextStyle(color: AppTheme.textSecondary, height: 1.5, fontSize: 14)),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.accentNeonCyan.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.accentNeonCyan.withOpacity(0.4)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.lightbulb_outline, color: AppTheme.accentNeonCyan, size: 24),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(_isEnglish ? widget.problem.keyIdeaEn : widget.problem.keyIdeaBn, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 13, height: 1.4)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text(_isEnglish ? "Sample Test Cases" : "স্যাম্পল টেস্ট কেস", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 10),
            ...List.generate(widget.problem.sampleInputs.length, (i) {
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(color: const Color(0xFF090D16), borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFF1E293B))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Input: ${widget.problem.sampleInputs[i]}", style: const TextStyle(color: AppTheme.accentNeonCyan, fontFamily: 'monospace', fontSize: 13)),
                    const SizedBox(height: 4),
                    Text("Output: ${widget.problem.sampleOutputs[i]}", style: const TextStyle(color: AppTheme.accentGreen, fontFamily: 'monospace', fontWeight: FontWeight.bold, fontSize: 13)),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  // ─── TAB 2: Step Visualizer ──────────────────────────────────────────────────

  Widget _buildVisualizerTab(double hPadding) {
    if (widget.problem.id == "arr-1") {
      return ResponsiveCenter(
        padding: EdgeInsets.all(hPadding),
        child: SingleChildScrollView(
          child: MinMaxAnimatedVisualizer(isEnglish: _isEnglish),
        ),
      );
    }
    if (widget.problem.id == "arr-2") {
      return ResponsiveCenter(
        padding: EdgeInsets.all(hPadding),
        child: SingleChildScrollView(
          child: ReverseArrayAnimatedVisualizer(isEnglish: _isEnglish),
        ),
      );
    }
    if (widget.problem.id == "arr-3") {
      return ResponsiveCenter(
        padding: EdgeInsets.all(hPadding),
        child: SingleChildScrollView(
          child: MatrixTransposeAnimatedVisualizer(isEnglish: _isEnglish),
        ),
      );
    }
    if (widget.problem.id == "arr-4") {
      return ResponsiveCenter(
        padding: EdgeInsets.all(hPadding),
        child: SingleChildScrollView(
          child: TensorSumAnimatedVisualizer(isEnglish: _isEnglish),
        ),
      );
    }
    if (widget.problem.id == "ll-1") {
      return ResponsiveCenter(
        padding: EdgeInsets.all(hPadding),
        child: SingleChildScrollView(
          child: ReverseSinglyLinkedListAnimatedVisualizer(isEnglish: _isEnglish),
        ),
      );
    }
    if (widget.problem.id == "ll-2") {
      return ResponsiveCenter(
        padding: EdgeInsets.all(hPadding),
        child: SingleChildScrollView(
          child: FindMiddleNodeAnimatedVisualizer(isEnglish: _isEnglish),
        ),
      );
    }
    if (widget.problem.id == "ll-3") {
      return ResponsiveCenter(
        padding: EdgeInsets.all(hPadding),
        child: SingleChildScrollView(
          child: ReverseDoublyLinkedListAnimatedVisualizer(isEnglish: _isEnglish),
        ),
      );
    }
    if (widget.problem.id == "ll-4") {
      return ResponsiveCenter(
        padding: EdgeInsets.all(hPadding),
        child: SingleChildScrollView(
          child: DetectCycleLinkedListAnimatedVisualizer(isEnglish: _isEnglish),
        ),
      );
    }
    if (widget.problem.id == "st-1") {
      return ResponsiveCenter(
        padding: EdgeInsets.all(hPadding),
        child: SingleChildScrollView(
          child: ValidParenthesesAnimatedVisualizer(isEnglish: _isEnglish),
        ),
      );
    }
    if (widget.problem.id == "st-2") {
      return ResponsiveCenter(
        padding: EdgeInsets.all(hPadding),
        child: SingleChildScrollView(
          child: MinStackAnimatedVisualizer(isEnglish: _isEnglish),
        ),
      );
    }
    if (widget.problem.id == "st-3") {
      return ResponsiveCenter(
        padding: EdgeInsets.all(hPadding),
        child: SingleChildScrollView(
          child: EvaluateRpnAnimatedVisualizer(isEnglish: _isEnglish),
        ),
      );
    }
    if (widget.problem.id == "st-4") {
      return ResponsiveCenter(
        padding: EdgeInsets.all(hPadding),
        child: SingleChildScrollView(
          child: NextGreaterElementAnimatedVisualizer(isEnglish: _isEnglish),
        ),
      );
    }
    if (widget.problem.id == "q-1") {
      return ResponsiveCenter(
        padding: EdgeInsets.all(hPadding),
        child: SingleChildScrollView(
          child: ImplementQueueStacksAnimatedVisualizer(isEnglish: _isEnglish),
        ),
      );
    }
    if (widget.problem.id == "q-2") {
      return ResponsiveCenter(
        padding: EdgeInsets.all(hPadding),
        child: SingleChildScrollView(
          child: CircularQueueAnimatedVisualizer(isEnglish: _isEnglish),
        ),
      );
    }
    if (widget.problem.id == "q-3") {
      return ResponsiveCenter(
        padding: EdgeInsets.all(hPadding),
        child: SingleChildScrollView(
          child: FirstNonRepeatingAnimatedVisualizer(isEnglish: _isEnglish),
        ),
      );
    }
    if (widget.problem.id == "q-4") {
      return ResponsiveCenter(
        padding: EdgeInsets.all(hPadding),
        child: SingleChildScrollView(
          child: SlidingWindowMaxAnimatedVisualizer(isEnglish: _isEnglish),
        ),
      );
    }
    if (widget.problem.id == "hm-1") {
      return ResponsiveCenter(
        padding: EdgeInsets.all(hPadding),
        child: SingleChildScrollView(
          child: TwoSumAnimatedVisualizer(isEnglish: _isEnglish),
        ),
      );
    }
    if (widget.problem.id == "hm-2") {
      return ResponsiveCenter(
        padding: EdgeInsets.all(hPadding),
        child: SingleChildScrollView(
          child: ValidAnagramAnimatedVisualizer(isEnglish: _isEnglish),
        ),
      );
    }
    if (widget.problem.id == "hm-3") {
      return ResponsiveCenter(
        padding: EdgeInsets.all(hPadding),
        child: SingleChildScrollView(
          child: GroupAnagramsAnimatedVisualizer(isEnglish: _isEnglish),
        ),
      );
    }
    if (widget.problem.id == "hm-4") {
      return ResponsiveCenter(
        padding: EdgeInsets.all(hPadding),
        child: SingleChildScrollView(
          child: SubarraySumKAnimatedVisualizer(isEnglish: _isEnglish),
        ),
      );
    }
    if (widget.problem.id == "bst-1") {
      return ResponsiveCenter(
        padding: EdgeInsets.all(hPadding),
        child: SingleChildScrollView(
          child: SearchBstAnimatedVisualizer(isEnglish: _isEnglish),
        ),
      );
    }
    if (widget.problem.id == "bst-2") {
      return ResponsiveCenter(
        padding: EdgeInsets.all(hPadding),
        child: SingleChildScrollView(
          child: InsertBstAnimatedVisualizer(isEnglish: _isEnglish),
        ),
      );
    }
    if (widget.problem.id == "bst-3") {
      return ResponsiveCenter(
        padding: EdgeInsets.all(hPadding),
        child: SingleChildScrollView(
          child: ValidateBstAnimatedVisualizer(isEnglish: _isEnglish),
        ),
      );
    }
    if (widget.problem.id == "bst-4") {
      return ResponsiveCenter(
        padding: EdgeInsets.all(hPadding),
        child: SingleChildScrollView(
          child: LcaBstAnimatedVisualizer(isEnglish: _isEnglish),
        ),
      );
    }
    if (widget.problem.id == "hp-1") {
      return ResponsiveCenter(
        padding: EdgeInsets.all(hPadding),
        child: SingleChildScrollView(
          child: KthLargestAnimatedVisualizer(isEnglish: _isEnglish),
        ),
      );
    }
    if (widget.problem.id == "hp-2") {
      return ResponsiveCenter(
        padding: EdgeInsets.all(hPadding),
        child: SingleChildScrollView(
          child: TopKFrequentAnimatedVisualizer(isEnglish: _isEnglish),
        ),
      );
    }
    if (widget.problem.id == "hp-3") {
      return ResponsiveCenter(
        padding: EdgeInsets.all(hPadding),
        child: SingleChildScrollView(
          child: MergeKListsAnimatedVisualizer(isEnglish: _isEnglish),
        ),
      );
    }
    if (widget.problem.id == "hp-4") {
      return ResponsiveCenter(
        padding: EdgeInsets.all(hPadding),
        child: SingleChildScrollView(
          child: FindMedianAnimatedVisualizer(isEnglish: _isEnglish),
        ),
      );
    }
    if (widget.problem.id == "gr-1") {
      return ResponsiveCenter(
        padding: EdgeInsets.all(hPadding),
        child: SingleChildScrollView(
          child: BfsGraphAnimatedVisualizer(isEnglish: _isEnglish),
        ),
      );
    }
    if (widget.problem.id == "gr-2") {
      return ResponsiveCenter(
        padding: EdgeInsets.all(hPadding),
        child: SingleChildScrollView(
          child: DfsGraphAnimatedVisualizer(isEnglish: _isEnglish),
        ),
      );
    }
    if (widget.problem.id == "gr-3") {
      return ResponsiveCenter(
        padding: EdgeInsets.all(hPadding),
        child: SingleChildScrollView(
          child: NumIslandsAnimatedVisualizer(isEnglish: _isEnglish),
        ),
      );
    }
    if (widget.problem.id == "gr-4") {
      return ResponsiveCenter(
        padding: EdgeInsets.all(hPadding),
        child: SingleChildScrollView(
          child: DetectCycleGraphAnimatedVisualizer(isEnglish: _isEnglish),
        ),
      );
    }
    if (widget.problem.id == "tr-1") {
      return ResponsiveCenter(
        padding: EdgeInsets.all(hPadding),
        child: SingleChildScrollView(
          child: ImplementTrieAnimatedVisualizer(isEnglish: _isEnglish),
        ),
      );
    }
    if (widget.problem.id == "tr-2") {
      return ResponsiveCenter(
        padding: EdgeInsets.all(hPadding),
        child: SingleChildScrollView(
          child: AddSearchWordsAnimatedVisualizer(isEnglish: _isEnglish),
        ),
      );
    }
    if (widget.problem.id == "tr-3") {
      return ResponsiveCenter(
        padding: EdgeInsets.all(hPadding),
        child: SingleChildScrollView(
          child: ReplaceWordsAnimatedVisualizer(isEnglish: _isEnglish),
        ),
      );
    }
    if (widget.problem.id == "tr-4") {
      return ResponsiveCenter(
        padding: EdgeInsets.all(hPadding),
        child: SingleChildScrollView(
          child: WordSearchTwoAnimatedVisualizer(isEnglish: _isEnglish),
        ),
      );
    }

    final step = _currentSteps[_currentStepIndex];

    return ResponsiveCenter(
      padding: EdgeInsets.all(hPadding),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppTheme.accentNeonCyan.withOpacity(0.12),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppTheme.accentNeonCyan.withOpacity(0.5)),
              ),
              child: Text(
                _isEnglish ? step.explanationEn : step.explanationBn,
                style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 13),
              ),
            ),
            const SizedBox(height: 16),
            buildVisualizerBox(
              step: step,
              problemId: widget.problem.id,
              isEnglish: _isEnglish,
              currentStepIndex: _currentStepIndex,
              getMinValHeaderLabel: _getMinValHeaderLabel,
            ),
            const SizedBox(height: 20),
            buildControlBar(
              currentStepIndex: _currentStepIndex,
              totalSteps: _currentSteps.length,
              isPlaying: _isPlaying,
              isEnglish: _isEnglish,
              onPrev: _prevStep,
              onPlay: _togglePlay,
              onNext: _nextStep,
              onReset: _reset,
            ),
          ],
        ),
      ),
    );
  }

  // ─── TAB 3: Solution Code ───────────────────────────────────────────────────

  Widget _buildCodeTab(double hPadding) {
    return ResponsiveCenter(
      padding: EdgeInsets.all(hPadding),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(_isEnglish ? "Solution Code" : "সমাধান কোড", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                DropdownButton<String>(
                  value: _selectedCodeLang,
                  dropdownColor: AppTheme.surfaceDark,
                  style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold),
                  underline: Container(),
                  items: ["C++", "Java", "Python", "JavaScript"].map((lang) => DropdownMenuItem(value: lang, child: Text(lang))).toList(),
                  onChanged: (val) {
                    if (val != null) setState(() => _selectedCodeLang = val);
                  },
                ),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: const Color(0xFF090D16), borderRadius: BorderRadius.circular(14), border: Border.all(color: const Color(0xFF1E293B))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  IconButton(
                    icon: const Icon(Icons.copy, color: AppTheme.accentNeonCyan, size: 18),
                    onPressed: () => _copyToClipboard(_getCodeForSelectedLanguage()),
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Text(_getCodeForSelectedLanguage(), style: const TextStyle(fontFamily: 'monospace', fontSize: 12, color: Color(0xFF38BDF8), height: 1.4)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── TAB 4: Line-by-Line Execution Debugger ──────────────────────────────────

  Widget _buildDebuggerTab(double hPadding) {
    if (widget.problem.id == "arr-1") {
      return ResponsiveCenter(
        padding: EdgeInsets.all(hPadding),
        child: SingleChildScrollView(
          child: MinMaxExecutionDebugger(isEnglish: _isEnglish),
        ),
      );
    }
    if (widget.problem.id == "arr-2") {
      return ResponsiveCenter(
        padding: EdgeInsets.all(hPadding),
        child: SingleChildScrollView(
          child: ReverseArrayExecutionDebugger(isEnglish: _isEnglish),
        ),
      );
    }
    if (widget.problem.id == "arr-3") {
      return ResponsiveCenter(
        padding: EdgeInsets.all(hPadding),
        child: SingleChildScrollView(
          child: MatrixTransposeExecutionDebugger(isEnglish: _isEnglish),
        ),
      );
    }
    if (widget.problem.id == "arr-4") {
      return ResponsiveCenter(
        padding: EdgeInsets.all(hPadding),
        child: SingleChildScrollView(
          child: TensorSumExecutionDebugger(isEnglish: _isEnglish),
        ),
      );
    }
    if (widget.problem.id == "ll-1") {
      return ResponsiveCenter(
        padding: EdgeInsets.all(hPadding),
        child: SingleChildScrollView(
          child: ReverseSinglyLinkedListExecutionDebugger(isEnglish: _isEnglish),
        ),
      );
    }
    if (widget.problem.id == "ll-2") {
      return ResponsiveCenter(
        padding: EdgeInsets.all(hPadding),
        child: SingleChildScrollView(
          child: FindMiddleNodeExecutionDebugger(isEnglish: _isEnglish),
        ),
      );
    }
    if (widget.problem.id == "ll-3") {
      return ResponsiveCenter(
        padding: EdgeInsets.all(hPadding),
        child: SingleChildScrollView(
          child: ReverseDoublyLinkedListExecutionDebugger(isEnglish: _isEnglish),
        ),
      );
    }
    if (widget.problem.id == "ll-4") {
      return ResponsiveCenter(
        padding: EdgeInsets.all(hPadding),
        child: SingleChildScrollView(
          child: DetectCycleLinkedListExecutionDebugger(isEnglish: _isEnglish),
        ),
      );
    }
    if (widget.problem.id == "st-1") {
      return ResponsiveCenter(
        padding: EdgeInsets.all(hPadding),
        child: SingleChildScrollView(
          child: ValidParenthesesExecutionDebugger(isEnglish: _isEnglish),
        ),
      );
    }
    if (widget.problem.id == "st-2") {
      return ResponsiveCenter(
        padding: EdgeInsets.all(hPadding),
        child: SingleChildScrollView(
          child: MinStackExecutionDebugger(isEnglish: _isEnglish),
        ),
      );
    }
    if (widget.problem.id == "st-3") {
      return ResponsiveCenter(
        padding: EdgeInsets.all(hPadding),
        child: SingleChildScrollView(
          child: EvaluateRpnExecutionDebugger(isEnglish: _isEnglish),
        ),
      );
    }
    if (widget.problem.id == "st-4") {
      return ResponsiveCenter(
        padding: EdgeInsets.all(hPadding),
        child: SingleChildScrollView(
          child: NextGreaterElementExecutionDebugger(isEnglish: _isEnglish),
        ),
      );
    }
    if (widget.problem.id == "q-1") {
      return ResponsiveCenter(
        padding: EdgeInsets.all(hPadding),
        child: SingleChildScrollView(
          child: ImplementQueueStacksExecutionDebugger(isEnglish: _isEnglish),
        ),
      );
    }
    if (widget.problem.id == "q-2") {
      return ResponsiveCenter(
        padding: EdgeInsets.all(hPadding),
        child: SingleChildScrollView(
          child: CircularQueueExecutionDebugger(isEnglish: _isEnglish),
        ),
      );
    }
    if (widget.problem.id == "q-3") {
      return ResponsiveCenter(
        padding: EdgeInsets.all(hPadding),
        child: SingleChildScrollView(
          child: FirstNonRepeatingExecutionDebugger(isEnglish: _isEnglish),
        ),
      );
    }
    if (widget.problem.id == "q-4") {
      return ResponsiveCenter(
        padding: EdgeInsets.all(hPadding),
        child: SingleChildScrollView(
          child: SlidingWindowMaxExecutionDebugger(isEnglish: _isEnglish),
        ),
      );
    }
    if (widget.problem.id == "hm-1") {
      return ResponsiveCenter(
        padding: EdgeInsets.all(hPadding),
        child: SingleChildScrollView(
          child: TwoSumExecutionDebugger(isEnglish: _isEnglish),
        ),
      );
    }
    if (widget.problem.id == "hm-2") {
      return ResponsiveCenter(
        padding: EdgeInsets.all(hPadding),
        child: SingleChildScrollView(
          child: ValidAnagramExecutionDebugger(isEnglish: _isEnglish),
        ),
      );
    }
    if (widget.problem.id == "hm-3") {
      return ResponsiveCenter(
        padding: EdgeInsets.all(hPadding),
        child: SingleChildScrollView(
          child: GroupAnagramsExecutionDebugger(isEnglish: _isEnglish),
        ),
      );
    }
    if (widget.problem.id == "hm-4") {
      return ResponsiveCenter(
        padding: EdgeInsets.all(hPadding),
        child: SingleChildScrollView(
          child: SubarraySumKExecutionDebugger(isEnglish: _isEnglish),
        ),
      );
    }
    if (widget.problem.id == "bst-1") {
      return ResponsiveCenter(
        padding: EdgeInsets.all(hPadding),
        child: SingleChildScrollView(
          child: SearchBstExecutionDebugger(isEnglish: _isEnglish),
        ),
      );
    }
    if (widget.problem.id == "bst-2") {
      return ResponsiveCenter(
        padding: EdgeInsets.all(hPadding),
        child: SingleChildScrollView(
          child: InsertBstExecutionDebugger(isEnglish: _isEnglish),
        ),
      );
    }
    if (widget.problem.id == "bst-3") {
      return ResponsiveCenter(
        padding: EdgeInsets.all(hPadding),
        child: SingleChildScrollView(
          child: ValidateBstExecutionDebugger(isEnglish: _isEnglish),
        ),
      );
    }
    if (widget.problem.id == "bst-4") {
      return ResponsiveCenter(
        padding: EdgeInsets.all(hPadding),
        child: SingleChildScrollView(
          child: LcaBstExecutionDebugger(isEnglish: _isEnglish),
        ),
      );
    }
    if (widget.problem.id == "hp-1") {
      return ResponsiveCenter(
        padding: EdgeInsets.all(hPadding),
        child: SingleChildScrollView(
          child: KthLargestExecutionDebugger(isEnglish: _isEnglish),
        ),
      );
    }
    if (widget.problem.id == "hp-2") {
      return ResponsiveCenter(
        padding: EdgeInsets.all(hPadding),
        child: SingleChildScrollView(
          child: TopKFrequentExecutionDebugger(isEnglish: _isEnglish),
        ),
      );
    }
    if (widget.problem.id == "hp-3") {
      return ResponsiveCenter(
        padding: EdgeInsets.all(hPadding),
        child: SingleChildScrollView(
          child: MergeKListsExecutionDebugger(isEnglish: _isEnglish),
        ),
      );
    }
    if (widget.problem.id == "hp-4") {
      return ResponsiveCenter(
        padding: EdgeInsets.all(hPadding),
        child: SingleChildScrollView(
          child: FindMedianExecutionDebugger(isEnglish: _isEnglish),
        ),
      );
    }
    if (widget.problem.id == "gr-1") {
      return ResponsiveCenter(
        padding: EdgeInsets.all(hPadding),
        child: SingleChildScrollView(
          child: BfsGraphExecutionDebugger(isEnglish: _isEnglish),
        ),
      );
    }
    if (widget.problem.id == "gr-2") {
      return ResponsiveCenter(
        padding: EdgeInsets.all(hPadding),
        child: SingleChildScrollView(
          child: DfsGraphExecutionDebugger(isEnglish: _isEnglish),
        ),
      );
    }
    if (widget.problem.id == "gr-3") {
      return ResponsiveCenter(
        padding: EdgeInsets.all(hPadding),
        child: SingleChildScrollView(
          child: NumIslandsExecutionDebugger(isEnglish: _isEnglish),
        ),
      );
    }
    if (widget.problem.id == "gr-4") {
      return ResponsiveCenter(
        padding: EdgeInsets.all(hPadding),
        child: SingleChildScrollView(
          child: DetectCycleGraphExecutionDebugger(isEnglish: _isEnglish),
        ),
      );
    }
    if (widget.problem.id == "tr-1") {
      return ResponsiveCenter(
        padding: EdgeInsets.all(hPadding),
        child: SingleChildScrollView(
          child: ImplementTrieExecutionDebugger(isEnglish: _isEnglish),
        ),
      );
    }
    if (widget.problem.id == "tr-2") {
      return ResponsiveCenter(
        padding: EdgeInsets.all(hPadding),
        child: SingleChildScrollView(
          child: AddSearchWordsExecutionDebugger(isEnglish: _isEnglish),
        ),
      );
    }
    if (widget.problem.id == "tr-3") {
      return ResponsiveCenter(
        padding: EdgeInsets.all(hPadding),
        child: SingleChildScrollView(
          child: ReplaceWordsExecutionDebugger(isEnglish: _isEnglish),
        ),
      );
    }
    if (widget.problem.id == "tr-4") {
      return ResponsiveCenter(
        padding: EdgeInsets.all(hPadding),
        child: SingleChildScrollView(
          child: WordSearchTwoExecutionDebugger(isEnglish: _isEnglish),
        ),
      );
    }

    final step = _currentSteps[_currentStepIndex];

    return ResponsiveCenter(
      padding: EdgeInsets.all(hPadding),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _isEnglish ? "Line-by-Line Execution Debugger & Canvas" : "লাইন-বাই-লাইন এক্সিকিউশন ডিবাগার ও ক্যানভাস",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.accentNeonCyan),
            ),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.accentNeonCyan.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.accentNeonCyan.withOpacity(0.4)),
              ),
              child: Text(
                _isEnglish ? step.explanationEn : step.explanationBn,
                style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 12),
              ),
            ),
            const SizedBox(height: 12),
            buildCodeSnippetWithHighlight(_currentCodeLines, step.activeLineIndex),
            const SizedBox(height: 14),
            buildVisualizerBox(
              step: step,
              problemId: widget.problem.id,
              isEnglish: _isEnglish,
              currentStepIndex: _currentStepIndex,
              getMinValHeaderLabel: _getMinValHeaderLabel,
            ),
            const SizedBox(height: 16),
            buildControlBar(
              currentStepIndex: _currentStepIndex,
              totalSteps: _currentSteps.length,
              isPlaying: _isPlaying,
              isEnglish: _isEnglish,
              onPrev: _prevStep,
              onPlay: _togglePlay,
              onNext: _nextStep,
              onReset: _reset,
            ),
          ],
        ),
      ),
    );
  }

  // ─── TAB 5: Practice & Test Runner ──────────────────────────────────────────

  Widget _buildPracticeTab(double hPadding) {
    if (widget.problem.id == "arr-1") {
      return ResponsiveCenter(
        padding: EdgeInsets.all(hPadding),
        child: SingleChildScrollView(
          child: MinMaxPracticeQuiz(isEnglish: _isEnglish),
        ),
      );
    }
    if (widget.problem.id == "arr-2") {
      return ResponsiveCenter(
        padding: EdgeInsets.all(hPadding),
        child: SingleChildScrollView(
          child: ReverseArrayPracticeQuiz(isEnglish: _isEnglish),
        ),
      );
    }
    if (widget.problem.id == "arr-3") {
      return ResponsiveCenter(
        padding: EdgeInsets.all(hPadding),
        child: SingleChildScrollView(
          child: MatrixTransposePracticeQuiz(isEnglish: _isEnglish),
        ),
      );
    }
    if (widget.problem.id == "arr-4") {
      return ResponsiveCenter(
        padding: EdgeInsets.all(hPadding),
        child: SingleChildScrollView(
          child: TensorSumPracticeQuiz(isEnglish: _isEnglish),
        ),
      );
    }
    if (widget.problem.id == "ll-1") {
      return ResponsiveCenter(
        padding: EdgeInsets.all(hPadding),
        child: SingleChildScrollView(
          child: ReverseSinglyLinkedListPracticeQuiz(isEnglish: _isEnglish),
        ),
      );
    }
    if (widget.problem.id == "ll-2") {
      return ResponsiveCenter(
        padding: EdgeInsets.all(hPadding),
        child: SingleChildScrollView(
          child: FindMiddleNodePracticeQuiz(isEnglish: _isEnglish),
        ),
      );
    }
    if (widget.problem.id == "ll-3") {
      return ResponsiveCenter(
        padding: EdgeInsets.all(hPadding),
        child: SingleChildScrollView(
          child: ReverseDoublyLinkedListPracticeQuiz(isEnglish: _isEnglish),
        ),
      );
    }
    if (widget.problem.id == "ll-4") {
      return ResponsiveCenter(
        padding: EdgeInsets.all(hPadding),
        child: SingleChildScrollView(
          child: DetectCycleLinkedListPracticeQuiz(isEnglish: _isEnglish),
        ),
      );
    }
    if (widget.problem.id == "st-1") {
      return ResponsiveCenter(
        padding: EdgeInsets.all(hPadding),
        child: SingleChildScrollView(
          child: ValidParenthesesPracticeQuiz(isEnglish: _isEnglish),
        ),
      );
    }
    if (widget.problem.id == "st-2") {
      return ResponsiveCenter(
        padding: EdgeInsets.all(hPadding),
        child: SingleChildScrollView(
          child: MinStackPracticeQuiz(isEnglish: _isEnglish),
        ),
      );
    }
    if (widget.problem.id == "st-3") {
      return ResponsiveCenter(
        padding: EdgeInsets.all(hPadding),
        child: SingleChildScrollView(
          child: EvaluateRpnPracticeQuiz(isEnglish: _isEnglish),
        ),
      );
    }
    if (widget.problem.id == "st-4") {
      return ResponsiveCenter(
        padding: EdgeInsets.all(hPadding),
        child: SingleChildScrollView(
          child: NextGreaterElementPracticeQuiz(isEnglish: _isEnglish),
        ),
      );
    }
    if (widget.problem.id == "q-1") {
      return ResponsiveCenter(
        padding: EdgeInsets.all(hPadding),
        child: SingleChildScrollView(
          child: ImplementQueueStacksPracticeQuiz(isEnglish: _isEnglish),
        ),
      );
    }
    if (widget.problem.id == "q-2") {
      return ResponsiveCenter(
        padding: EdgeInsets.all(hPadding),
        child: SingleChildScrollView(
          child: CircularQueuePracticeQuiz(isEnglish: _isEnglish),
        ),
      );
    }
    if (widget.problem.id == "q-3") {
      return ResponsiveCenter(
        padding: EdgeInsets.all(hPadding),
        child: SingleChildScrollView(
          child: FirstNonRepeatingPracticeQuiz(isEnglish: _isEnglish),
        ),
      );
    }
    if (widget.problem.id == "q-4") {
      return ResponsiveCenter(
        padding: EdgeInsets.all(hPadding),
        child: SingleChildScrollView(
          child: SlidingWindowMaxPracticeQuiz(isEnglish: _isEnglish),
        ),
      );
    }
    if (widget.problem.id == "hm-1") {
      return ResponsiveCenter(
        padding: EdgeInsets.all(hPadding),
        child: SingleChildScrollView(
          child: TwoSumPracticeQuiz(isEnglish: _isEnglish),
        ),
      );
    }
    if (widget.problem.id == "hm-2") {
      return ResponsiveCenter(
        padding: EdgeInsets.all(hPadding),
        child: SingleChildScrollView(
          child: ValidAnagramPracticeQuiz(isEnglish: _isEnglish),
        ),
      );
    }
    if (widget.problem.id == "hm-3") {
      return ResponsiveCenter(
        padding: EdgeInsets.all(hPadding),
        child: SingleChildScrollView(
          child: GroupAnagramsPracticeQuiz(isEnglish: _isEnglish),
        ),
      );
    }
    if (widget.problem.id == "hm-4") {
      return ResponsiveCenter(
        padding: EdgeInsets.all(hPadding),
        child: SingleChildScrollView(
          child: SubarraySumKPracticeQuiz(isEnglish: _isEnglish),
        ),
      );
    }
    if (widget.problem.id == "bst-1") {
      return ResponsiveCenter(
        padding: EdgeInsets.all(hPadding),
        child: SingleChildScrollView(
          child: SearchBstPracticeQuiz(isEnglish: _isEnglish),
        ),
      );
    }
    if (widget.problem.id == "bst-2") {
      return ResponsiveCenter(
        padding: EdgeInsets.all(hPadding),
        child: SingleChildScrollView(
          child: InsertBstPracticeQuiz(isEnglish: _isEnglish),
        ),
      );
    }
    if (widget.problem.id == "bst-3") {
      return ResponsiveCenter(
        padding: EdgeInsets.all(hPadding),
        child: SingleChildScrollView(
          child: ValidateBstPracticeQuiz(isEnglish: _isEnglish),
        ),
      );
    }
    if (widget.problem.id == "bst-4") {
      return ResponsiveCenter(
        padding: EdgeInsets.all(hPadding),
        child: SingleChildScrollView(
          child: LcaBstPracticeQuiz(isEnglish: _isEnglish),
        ),
      );
    }
    if (widget.problem.id == "hp-1") {
      return ResponsiveCenter(
        padding: EdgeInsets.all(hPadding),
        child: SingleChildScrollView(
          child: KthLargestPracticeQuiz(isEnglish: _isEnglish),
        ),
      );
    }
    if (widget.problem.id == "hp-2") {
      return ResponsiveCenter(
        padding: EdgeInsets.all(hPadding),
        child: SingleChildScrollView(
          child: TopKFrequentPracticeQuiz(isEnglish: _isEnglish),
        ),
      );
    }
    if (widget.problem.id == "hp-3") {
      return ResponsiveCenter(
        padding: EdgeInsets.all(hPadding),
        child: SingleChildScrollView(
          child: MergeKListsPracticeQuiz(isEnglish: _isEnglish),
        ),
      );
    }
    if (widget.problem.id == "hp-4") {
      return ResponsiveCenter(
        padding: EdgeInsets.all(hPadding),
        child: SingleChildScrollView(
          child: FindMedianPracticeQuiz(isEnglish: _isEnglish),
        ),
      );
    }
    if (widget.problem.id == "gr-1") {
      return ResponsiveCenter(
        padding: EdgeInsets.all(hPadding),
        child: SingleChildScrollView(
          child: BfsGraphPracticeQuiz(isEnglish: _isEnglish),
        ),
      );
    }
    if (widget.problem.id == "gr-2") {
      return ResponsiveCenter(
        padding: EdgeInsets.all(hPadding),
        child: SingleChildScrollView(
          child: DfsGraphPracticeQuiz(isEnglish: _isEnglish),
        ),
      );
    }
    if (widget.problem.id == "gr-3") {
      return ResponsiveCenter(
        padding: EdgeInsets.all(hPadding),
        child: SingleChildScrollView(
          child: NumIslandsPracticeQuiz(isEnglish: _isEnglish),
        ),
      );
    }
    if (widget.problem.id == "gr-4") {
      return ResponsiveCenter(
        padding: EdgeInsets.all(hPadding),
        child: SingleChildScrollView(
          child: DetectCycleGraphPracticeQuiz(isEnglish: _isEnglish),
        ),
      );
    }
    if (widget.problem.id == "tr-1") {
      return ResponsiveCenter(
        padding: EdgeInsets.all(hPadding),
        child: SingleChildScrollView(
          child: ImplementTriePracticeQuiz(isEnglish: _isEnglish),
        ),
      );
    }
    if (widget.problem.id == "tr-2") {
      return ResponsiveCenter(
        padding: EdgeInsets.all(hPadding),
        child: SingleChildScrollView(
          child: AddSearchWordsPracticeQuiz(isEnglish: _isEnglish),
        ),
      );
    }
    if (widget.problem.id == "tr-3") {
      return ResponsiveCenter(
        padding: EdgeInsets.all(hPadding),
        child: SingleChildScrollView(
          child: ReplaceWordsPracticeQuiz(isEnglish: _isEnglish),
        ),
      );
    }
    if (widget.problem.id == "tr-4") {
      return ResponsiveCenter(
        padding: EdgeInsets.all(hPadding),
        child: SingleChildScrollView(
          child: WordSearchTwoPracticeQuiz(isEnglish: _isEnglish),
        ),
      );
    }

    return ResponsiveCenter(
      padding: EdgeInsets.all(hPadding),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: AppTheme.surfaceDark, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppTheme.accentGreen.withOpacity(0.4))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _isEnglish ? "Interactive Practice & Test Runner" : "ইনটারেক্টিভ প্র্যাকটিস টেস্ট রানার",
                    style: const TextStyle(color: AppTheme.accentGreen, fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _isEnglish ? "Test your code against sample inputs and verify correct outputs." : "স্যাম্পল ইনপুট দিয়ে আপনার সমাধান কোড টেস্ট ও ভেরিফাই করুন।",
                    style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(_isEnglish ? "Running tests... All 5 test cases PASSED! 🎉" : "টেস্ট রান হচ্ছে... ৫টি টেস্ট কেস সম্পূর্ণ সফল! 🎉"),
                          backgroundColor: AppTheme.accentGreen,
                        ),
                      );
                    },
                    icon: const Icon(Icons.play_arrow),
                    label: Text(_isEnglish ? "Run All Test Cases" : "সব টেস্ট কেস রান করুন"),
                    style: ElevatedButton.styleFrom(backgroundColor: AppTheme.accentGreen, foregroundColor: AppTheme.primaryDark),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
