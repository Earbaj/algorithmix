import 'package:flutter/material.dart';
import 'package:algorithmix/domain/models/dsa_data.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';
import '../widgets/array_visualizer_widget.dart';
import '../widgets/dsa_visualizers.dart';
import '../widgets/dsa_problem_modal.dart';

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
          tabs: [
            Tab(text: _isEnglish ? 'Concept & Code (1D/2D/3D)' : 'ধারণা ও কোড (১D/২D/৩D)'),
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
            const SizedBox(height: 24),

            // Core Characteristics
            Text(
              _isEnglish ? "🔑 Core Characteristics & Multi-Dimensional Layouts" : "🔑 মূল বৈশিষ্ট্য ও মেমোরি লেআউট",
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
              _isEnglish ? "💻 Code Examples (1D, 2D Grid & 3D Cube)" : "💻 কোড উদাহরণ (১D, ২D ম্যাট্রিক্স ও ৩D কিউব)",
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
                Text("Dimension: $_selectedDimension", style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold)),
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
            ArrayVisualizerWidget(isEnglish: _isEnglish),
          ],
        ),
      ),
    );
  }

  // TAB 3: Basic Problems (1D, 2D, 3D)
  Widget _buildProblemsTab() {
    final hPadding = Responsive.horizontalPadding(context);
    final problems = widget.topic.basicProblems;

    return ResponsiveCenter(
      padding: EdgeInsets.all(hPadding),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _isEnglish ? "📋 Fundamental Array Practice Problems" : "📋 বেসিক অ্যারে প্র্যাকটিস প্রবলেমস",
              style: TextStyle(fontSize: Responsive.sp(context, 18), fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 16),

            if (problems.isEmpty)
              const Padding(
                padding: EdgeInsets.all(20),
                child: Text("No basic problems listed.", style: TextStyle(color: AppTheme.textMuted)),
              )
            else
              Column(
                children: problems.map((p) => _buildProblemCard(p)).toList(),
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
          DsaProblemModal.show(context, problem, _isEnglish);
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
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
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
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
            Row(
              children: [
                const Icon(Icons.warning_amber_rounded, color: Color(0xFFEF4444), size: 24),
                const SizedBox(width: 8),
                Text(
                  _isEnglish ? "⚠️ Common Array Mistakes & Pitfalls" : "⚠️ অ্যারের সাধারণ ভুলসমূহ",
                  style: TextStyle(fontSize: Responsive.sp(context, 18), fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 16),

            ...mistakes.map((m) {
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceDark,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFEF4444).withOpacity(0.4)),
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
            const SizedBox(height: 28),

            // Step-by-Step Learning Roadmap
            Row(
              children: [
                const Icon(Icons.alt_route_rounded, color: AppTheme.accentNeonCyan, size: 24),
                const SizedBox(width: 8),
                Text(
                  _isEnglish ? "🎯 Step-by-Step Mastery Roadmap" : "🎯 রোডম্যাপ (ধাপে ধাপে শেখার উপায়)",
                  style: TextStyle(fontSize: Responsive.sp(context, 18), fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ],
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
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: widget.topic.themeColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        step["step"]!,
                        style: TextStyle(color: widget.topic.themeColor, fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                    ),
                    const SizedBox(width: 14),
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
