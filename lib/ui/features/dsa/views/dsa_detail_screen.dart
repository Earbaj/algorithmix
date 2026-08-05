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
          // Language Switcher Button (EN / BN)
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
            Tab(text: _isEnglish ? 'Concept & Code' : 'ধারণা ও কোড'),
            Tab(text: _isEnglish ? 'Visualizer' : 'ভিজ্যুয়ালাইজার'),
            Tab(text: _isEnglish ? 'FAANG Problems' : 'FAANG প্রবলেমস'),
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

  // TAB 1: Concept & Multi-Language Code
  Widget _buildConceptTab() {
    final hPadding = Responsive.horizontalPadding(context);

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

            // Time & Space Complexity Matrix Box
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
                        _isEnglish ? "Operations Time & Space Complexity" : "অপারেশন জটিলতা (Time & Space)",
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
                      _buildComplexityBadge(_isEnglish ? "Access Index" : "ইন্ডেক্স রিড", "O(1)", AppTheme.accentGreen),
                      _buildComplexityBadge(_isEnglish ? "Push Back" : "শেষে যোগ", "Amortized O(1)", AppTheme.accentGreen),
                      _buildComplexityBadge(_isEnglish ? "Search" : "খোঁজা", "O(N)", AppTheme.accentAmber),
                      _buildComplexityBadge(_isEnglish ? "Insert/Delete" : "ইনসার্ট/ডিলেট", "O(N)", const Color(0xFFEF4444)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Core Characteristics
            Text(
              _isEnglish ? "🔑 Core Characteristics & Intuition" : "🔑 মূল বৈশিষ্ট্য ও মেমোরি ধারণা",
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

            // Multi-Language Code Snippets
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _isEnglish ? "💻 Code Implementation" : "💻 ইমপ্লিমেন্টেশন কোড",
                  style: TextStyle(fontSize: Responsive.sp(context, 18), fontWeight: FontWeight.bold, color: Colors.white),
                ),
                DropdownButton<String>(
                  value: _selectedLang,
                  dropdownColor: AppTheme.surfaceDark,
                  style: TextStyle(color: widget.topic.themeColor, fontWeight: FontWeight.bold),
                  underline: Container(),
                  items: widget.topic.codeTemplates.keys.map((lang) {
                    return DropdownMenuItem(value: lang, child: Text(lang));
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) setState(() => _selectedLang = val);
                  },
                ),
              ],
            ),
            const SizedBox(height: 10),

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
                  widget.topic.codeTemplates[_selectedLang] ?? "",
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
            DsaInteractiveVisualizer(topicId: widget.topic.id, isEnglish: _isEnglish),
          ],
        ),
      ),
    );
  }

  // TAB 3: FAANG Problems (Easy, Medium, Hard)
  Widget _buildProblemsTab() {
    final hPadding = Responsive.horizontalPadding(context);

    return ResponsiveCenter(
      padding: EdgeInsets.all(hPadding),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _isEnglish ? "📋 FAANG Interview Problems" : "📋 FAANG প্রবলেম কালেকশন",
              style: TextStyle(fontSize: Responsive.sp(context, 18), fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 16),

            if (widget.topic.easyProblems.isNotEmpty) ...[
              _buildDifficultySection("🟢 EASY", AppTheme.accentGreen, widget.topic.easyProblems),
              const SizedBox(height: 20),
            ],
            if (widget.topic.mediumProblems.isNotEmpty) ...[
              _buildDifficultySection("🟡 MEDIUM", AppTheme.accentAmber, widget.topic.mediumProblems),
              const SizedBox(height: 20),
            ],
            if (widget.topic.hardProblems.isNotEmpty) ...[
              _buildDifficultySection("🔴 HARD", const Color(0xFFEF4444), widget.topic.hardProblems),
              const SizedBox(height: 20),
            ],
          ],
        ),
      ),
    );
  }

  // TAB 4: Mistakes & Roadmap
  Widget _buildMistakesTab() {
    final hPadding = Responsive.horizontalPadding(context);
    final mistakes = _isEnglish ? widget.topic.commonMistakesEn : widget.topic.commonMistakesBn;

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
                  _isEnglish ? "⚠️ Common Interview Pitfalls" : "⚠️ সাধারণ ইন্টারভিউ ভুলসমূহ",
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
                      style: TextStyle(
                        fontSize: Responsive.sp(context, 15),
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFFEF4444),
                      ),
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
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildDifficultySection(String label, Color color, List<DsaProblem> problems) {
    final isMobile = Responsive.isMobile(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color)),
        const SizedBox(height: 12),
        if (isMobile)
          Column(children: problems.map((p) => _buildProblemCard(p, color)).toList())
        else
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 480,
              mainAxisExtent: 165,
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
            ),
            itemCount: problems.length,
            itemBuilder: (context, index) => _buildProblemCard(problems[index], color),
          ),
      ],
    );
  }

  Widget _buildProblemCard(DsaProblem problem, Color color) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          DsaProblemModal.show(context, problem, _isEnglish);
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      problem.title,
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: Responsive.sp(context, 15)),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(color: widget.topic.themeColor.withOpacity(0.2), borderRadius: BorderRadius.circular(8)),
                    child: Text("🚀 Solution Code", style: TextStyle(fontSize: 10, color: widget.topic.themeColor, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                _isEnglish ? problem.keyIdeaEn : problem.keyIdeaBn,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: AppTheme.textSecondary, fontSize: Responsive.sp(context, 12), height: 1.3),
              ),
              const SizedBox(height: 10),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: problem.companyTags.map((tag) {
                    return Container(
                      margin: const EdgeInsets.only(right: 6),
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryDark,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFF334155)),
                      ),
                      child: Text(tag, style: const TextStyle(fontSize: 10, color: Colors.white)),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
