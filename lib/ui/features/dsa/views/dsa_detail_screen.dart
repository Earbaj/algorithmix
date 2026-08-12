import 'package:flutter/material.dart';
import 'package:algorithmix/domain/models/dsa_data.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';
import '../widgets/array_visualizer_widget.dart';
import '../widgets/dsa_visualizers.dart';
import '../widgets/dsa_problem_modal.dart';
import 'dsa_problem_detail_screen.dart';

class DsaDetailScreen extends StatefulWidget {
  final DsaTopic topic;

  const DsaDetailScreen({super.key, required this.topic});

  @override
  State<DsaDetailScreen> createState() => _DsaDetailScreenState();
}

class _DsaDetailScreenState extends State<DsaDetailScreen>
    with SingleTickerProviderStateMixin {
  bool _isEnglish = true;
  late TabController _tabController;

  // Code Tab state
  String _selectedDimension = "1D Array";
  String _selectedLang = "C++";

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryDark,
      appBar: AppBar(
        title: Text(widget.topic.title),
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
                size: 18,
              ),
              label: Text(
                _isEnglish ? 'EN' : 'BN',
                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
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
          indicatorColor: widget.topic.themeColor,
          labelColor: widget.topic.themeColor,
          unselectedLabelColor: AppTheme.textSecondary,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          padding: EdgeInsets.zero,
          tabs: [
            Tab(text: _isEnglish ? (widget.topic.id == 202 ? 'Concept & Code' : 'Concept & Code (1D/2D/3D)') : (widget.topic.id == 202 ? 'ধারণা ও কোড' : 'ধারণা ও কোড (১D/২D/৩D)')),
            Tab(text: _isEnglish ? 'Visualizer' : 'ভিজ্যুয়ালাইজার'),
            Tab(text: _isEnglish ? 'Basic Problems' : 'বেসিক প্রবলেমস'),
            Tab(text: _isEnglish ? 'Mistakes & Roadmap' : 'ভুল ও রোডম্যাপ'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildConceptTab(),
          _buildVisualizerTab(),
          _buildProblemsTab(),
          _buildMistakesTab(),
        ],
      ),
    );
  }

  // TAB 1: Concept & Multi-Dimension Code
  Widget _buildConceptTab() {
    final hPadding = Responsive.horizontalPadding(context);
    final dimMap = widget.topic.multiDimCodeTemplates;
    final availableDims = dimMap.keys.toList();
    if (!availableDims.contains(_selectedDimension) && availableDims.isNotEmpty) {
      _selectedDimension = availableDims.first;
    }
    final langMap = dimMap[_selectedDimension] ?? {};
    final availableLangs = langMap.keys.toList();
    if (!availableLangs.contains(_selectedLang) && availableLangs.isNotEmpty) {
      _selectedLang = availableLangs.first;
    }

    return ResponsiveCenter(
      padding: EdgeInsets.all(hPadding),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(widget.topic.icon, color: widget.topic.themeColor, size: 32),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    widget.topic.title,
                    style: TextStyle(
                      fontSize: Responsive.sp(context, 22),
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              _isEnglish ? widget.topic.descriptionEn : widget.topic.descriptionBn,
              style: TextStyle(
                fontSize: Responsive.sp(context, 14),
                color: AppTheme.textSecondary,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 20),

            // Complexity Matrix Box
            if (widget.topic.id == 202) ...[
              _buildLinkedListComplexitySection(),
            ] else ...[
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceDark,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: widget.topic.themeColor.withOpacity(0.4)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.timer_outlined, color: AppTheme.accentAmber, size: 22),
                        const SizedBox(width: 8),
                        Text(
                          _isEnglish ? "Complexity Metrics (1D, 2D, 3D)" : "টাইম ও স্পেস জটিলতা (১D, ২D, ৩D)",
                          style: TextStyle(
                            fontSize: Responsive.sp(context, 16),
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildComplexityBadge(_isEnglish ? "1D Access" : "১D এক্সেস", "O(1)", AppTheme.accentGreen),
                        _buildComplexityBadge(_isEnglish ? "2D Space" : "২D স্পেস", "O(R×C)", AppTheme.accentNeonCyan),
                        _buildComplexityBadge(_isEnglish ? "3D Space" : "৩D স্পেস", "O(D×R×C)", AppTheme.accentPink),
                      ],
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 24),

            // Core Characteristics
            Text(
              _isEnglish
                  ? (widget.topic.id == 202 ? "🔑 Core Characteristics & Pointer Mechanics" : "🔑 Core Characteristics & Multi-Dimensional Layouts")
                  : (widget.topic.id == 202 ? "🔑 মূল বৈশিষ্ট্য ও পয়েন্টার মেকানিক্স" : "🔑 মূল বৈশিষ্ট্য ও মেমোরি লেআউট"),
              style: TextStyle(fontSize: Responsive.sp(context, 18), fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 12),
            ...(_isEnglish ? widget.topic.keyConceptsEn : widget.topic.keyConceptsBn).map((concept) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.check_circle_outline, color: AppTheme.accentGreen, size: 18),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        concept,
                        style: TextStyle(fontSize: Responsive.sp(context, 13), color: AppTheme.textPrimary, height: 1.4),
                      ),
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: 24),

            // Multi-Dimension & Language Code Switcher
            Text(
              _isEnglish
                  ? (widget.topic.id == 202 ? "💻 Node Data Structures (Singly & Doubly Nodes)" : "💻 Code Examples (1D, 2D Grid & 3D Cube)")
                  : (widget.topic.id == 202 ? "💻 নোড ডেটা স্ট্রাকচার (Singly ও Doubly নোড)" : "💻 কোড উদাহরণ (১D, ২D ম্যাট্রিক্স ও ৩D কিউব)"),
              style: TextStyle(fontSize: Responsive.sp(context, 18), fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 12),

            // Dimension Switcher Chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: availableDims.map((dim) {
                  final isSelected = dim == _selectedDimension;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(dim),
                      selected: isSelected,
                      selectedColor: widget.topic.themeColor,
                      backgroundColor: AppTheme.surfaceDark,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : AppTheme.textSecondary,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                      onSelected: (selected) {
                        if (selected) setState(() => _selectedDimension = dim);
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 12),

            // Language Switcher Dropdown
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("$_selectedDimension", style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold)),
                DropdownButton<String>(
                  value: _selectedLang,
                  dropdownColor: AppTheme.surfaceDark,
                  style: TextStyle(color: widget.topic.themeColor, fontWeight: FontWeight.bold),
                  underline: Container(),
                  items: availableLangs.map((lang) {
                    return DropdownMenuItem(value: lang, child: Text(lang));
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) setState(() => _selectedLang = val);
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF090D16),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFF1E293B)),
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Text(
                  langMap[_selectedLang] ?? "",
                  style: const TextStyle(fontFamily: 'monospace', fontSize: 12, color: Color(0xFF38BDF8), height: 1.4),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildLinkedListComplexitySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: AppTheme.surfaceDark,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: widget.topic.themeColor.withOpacity(0.4)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.speed_outlined, color: AppTheme.accentAmber, size: 22),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _isEnglish ? "Linked List Time & Space Metrics" : "লিঙ্কড লিস্ট টাইম ও স্পেস মেট্রিক্স",
                      style: TextStyle(
                        fontSize: Responsive.sp(context, 16),
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildComplexityBadge(_isEnglish ? "Head Insert/Delete" : "হেড ইনসার্ট/ডিলেট", "O(1)", AppTheme.accentGreen),
                  _buildComplexityBadge(_isEnglish ? "Search / Access" : "সার্চ / এক্সেস", "O(N)", AppTheme.accentAmber),
                  _buildComplexityBadge(_isEnglish ? "Node Space Overhead" : "পয়েন্টার ওভারহেড", "O(1) per node", AppTheme.accentNeonCyan),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Comparison Table Card (Array vs Singly vs Doubly)
        Container(
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
                children: [
                  const Icon(Icons.table_chart_outlined, color: AppTheme.accentPurple, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    _isEnglish ? "Array vs Singly vs Doubly Linked List" : "অ্যারে বনাম Singly বনাম Doubly লিঙ্কড লিস্ট তুলনা",
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Table(
                  defaultColumnWidth: const IntrinsicColumnWidth(),
                  border: TableBorder.all(color: const Color(0xFF1E293B), width: 1, borderRadius: BorderRadius.circular(8)),
                  children: [
                    TableRow(
                      decoration: const BoxDecoration(color: Color(0xFF1E293B)),
                      children: [
                        _buildTableHeaderCell(_isEnglish ? "Property / Operation" : "বৈশিষ্ট্য / অপারেশন"),
                        _buildTableHeaderCell("Array"),
                        _buildTableHeaderCell("Singly Linked List"),
                        _buildTableHeaderCell("Doubly Linked List"),
                      ],
                    ),
                    TableRow(
                      children: [
                        _buildTableCell(_isEnglish ? "Memory Allocation" : "মেমোরি সংস্থান", isBold: true),
                        _buildTableCell(_isEnglish ? "Contiguous Block" : "পরপর মেমোরি ব্লক", color: AppTheme.accentGreen),
                        _buildTableCell(_isEnglish ? "Non-contiguous Heap" : "আলাদা হিপ মেমোরি", color: AppTheme.accentAmber),
                        _buildTableCell(_isEnglish ? "Non-contiguous Heap" : "আলাদা হিপ মেমোরি", color: AppTheme.accentAmber),
                      ],
                    ),
                    TableRow(
                      children: [
                        _buildTableCell(_isEnglish ? "Access by Index i" : "ইনডেক্স দিয়ে সরাসরি এক্সেস", isBold: true),
                        _buildTableCell("O(1) Instant", color: AppTheme.accentGreen),
                        _buildTableCell("O(N) Sequential", color: Colors.redAccent),
                        _buildTableCell("O(N) Sequential", color: Colors.redAccent),
                      ],
                    ),
                    TableRow(
                      children: [
                        _buildTableCell(_isEnglish ? "Head Insert / Delete" : "শুরুতে ইনসার্ট / ডিলেট", isBold: true),
                        _buildTableCell("O(N) (Shift all)", color: Colors.redAccent),
                        _buildTableCell("O(1) Instant", color: AppTheme.accentGreen),
                        _buildTableCell("O(1) Instant", color: AppTheme.accentGreen),
                      ],
                    ),
                    TableRow(
                      children: [
                        _buildTableCell(_isEnglish ? "Tail Deletion" : "শেষে ডিলেট করা", isBold: true),
                        _buildTableCell("O(1)", color: AppTheme.accentGreen),
                        _buildTableCell("O(N) (Need prev)", color: Colors.redAccent),
                        _buildTableCell("O(1) with tail ptr", color: AppTheme.accentGreen),
                      ],
                    ),
                    TableRow(
                      children: [
                        _buildTableCell(_isEnglish ? "Traversal Direction" : "ট্রাভার্সাল দিক", isBold: true),
                        _buildTableCell("Bi-directional", color: AppTheme.accentNeonCyan),
                        _buildTableCell("Unidirectional (next)", color: AppTheme.accentAmber),
                        _buildTableCell("Bi-directional (prev/next)", color: AppTheme.accentNeonCyan),
                      ],
                    ),
                    TableRow(
                      children: [
                        _buildTableCell(_isEnglish ? "Pointer Space Overhead" : "অতিরিক্ত পয়েন্টার মেমোরি", isBold: true),
                        _buildTableCell("0 Extra Pointers", color: AppTheme.accentGreen),
                        _buildTableCell("1 Pointer (next)", color: AppTheme.accentAmber),
                        _buildTableCell("2 Pointers (prev, next)", color: Colors.purpleAccent),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTableHeaderCell(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Text(
        text,
        style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 12),
      ),
    );
  }

  Widget _buildTableCell(String text, {bool isBold = false, Color color = Colors.white70}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Text(
        text,
        style: TextStyle(
          color: isBold ? Colors.white : color,
          fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildComplexityBadge(String label, String value, Color color) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 11)),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: color.withOpacity(0.15),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: color.withOpacity(0.5)),
          ),
          child: Text(value, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12)),
        ),
      ],
    );
  }

  // TAB 2: Visualizer
  Widget _buildVisualizerTab() {
    final hPadding = Responsive.horizontalPadding(context);

    return ResponsiveCenter(
      padding: EdgeInsets.all(hPadding),
      child: SingleChildScrollView(
        child: Column(
          children: [
            DsaInteractiveVisualizer(
              topicId: widget.topic.id,
              isEnglish: _isEnglish,
            ),
          ],
        ),
      ),
    );
  }

  // TAB 3: Basic Problems (1D, 2D, 3D)
  Widget _buildProblemsTab() {
    final hPadding = Responsive.horizontalPadding(context);
    final isMobile = Responsive.isMobile(context);
    final problems = widget.topic.basicProblems;

    return ResponsiveCenter(
      maxWidth: 1200,
      padding: EdgeInsets.all(hPadding),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _isEnglish ? "Fundamental Array Practice Problems" : "বেসিক অ্যারে প্র্যাকটিস প্রবলেমস",
              style: TextStyle(fontSize: Responsive.sp(context, 18), fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 16),

            if (problems.isEmpty)
              const Padding(
                padding: EdgeInsets.all(20),
                child: Text("No basic problems listed.", style: TextStyle(color: AppTheme.textMuted)),
              )
            else if (isMobile)
              Column(
                children: problems.map((p) => _buildProblemCard(p)).toList(),
              )
            else
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 540,
                  mainAxisExtent: 165,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: problems.length,
                itemBuilder: (context, index) => _buildProblemCard(problems[index]),
              ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildProblemCard(DsaProblem problem) {
    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => DsaProblemDetailScreen(
                problem: problem,
                initialLanguageIsEnglish: _isEnglish,
              ),
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      problem.title,
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: Responsive.sp(context, 15)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                _isEnglish ? problem.keyIdeaEn : problem.keyIdeaBn,
                style: TextStyle(color: AppTheme.textSecondary, fontSize: Responsive.sp(context, 13), height: 1.3),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: widget.topic.themeColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: widget.topic.themeColor.withOpacity(0.4)),
                    ),
                    child: Text(problem.category, style: TextStyle(fontSize: 10, color: widget.topic.themeColor, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(width: 10),
                  Text(_isEnglish ? "View Solution & Code 🚀" : "সমাধান ও কোড দেখুন 🚀", style: TextStyle(color: widget.topic.themeColor, fontSize: 12, fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // TAB 4: Mistakes & 5-Step Roadmap
  Widget _buildMistakesTab() {
    final hPadding = Responsive.horizontalPadding(context);
    final mistakes = _isEnglish ? widget.topic.commonMistakesEn : widget.topic.commonMistakesBn;
    final roadmap = _isEnglish ? widget.topic.roadmapStepsEn : widget.topic.roadmapStepsBn;

    return ResponsiveCenter(
      padding: EdgeInsets.all(hPadding),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _isEnglish ? "Common Array Mistakes & Pitfalls" : "অ্যারের সাধারণ ভুলসমূহ",
              style: TextStyle(fontSize: Responsive.sp(context, 18), fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 16),

            ...mistakes.map((m) {
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceDark,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFF334155)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      m["title"]!,
                      style: TextStyle(fontSize: Responsive.sp(context, 15), fontWeight: FontWeight.bold, color: const Color(0xFFEF4444)),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      m["desc"]!,
                      style: TextStyle(fontSize: Responsive.sp(context, 13), color: AppTheme.textSecondary, height: 1.4),
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: 14),
            // Step-by-Step Learning Roadmap
            Text(
              _isEnglish ? "Step-by-Step Mastery Roadmap" : "রোডম্যাপ (ধাপে ধাপে শেখার উপায়)",
              style: TextStyle(fontSize: Responsive.sp(context, 18), fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 16),

            ...roadmap.map((step) {
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceDark,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFF334155)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            step["title"]!,
                            style: TextStyle(fontSize: Responsive.sp(context, 15), fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            step["desc"]!,
                            style: TextStyle(fontSize: Responsive.sp(context, 13), color: AppTheme.textSecondary, height: 1.4),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
