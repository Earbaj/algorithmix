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
            Tab(text: _isEnglish ? (widget.topic.id == 202 || widget.topic.id == 203 || widget.topic.id == 204 || widget.topic.id == 205 || widget.topic.id == 206 || widget.topic.id == 207 || widget.topic.id == 208 || widget.topic.id == 209 ? 'Concept & Code' : 'Concept & Code (1D/2D/3D)') : (widget.topic.id == 202 || widget.topic.id == 203 || widget.topic.id == 204 || widget.topic.id == 205 || widget.topic.id == 206 || widget.topic.id == 207 || widget.topic.id == 208 || widget.topic.id == 209 ? 'ধারণা ও কোড' : 'ধারণা ও কোড (১D/২D/৩D)')),
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
            ] else if (widget.topic.id == 203) ...[
              _buildStackComplexitySection(),
            ] else if (widget.topic.id == 204) ...[
              _buildQueueComplexitySection(),
            ] else if (widget.topic.id == 205) ...[
              _buildHashMapComplexitySection(),
            ] else if (widget.topic.id == 206) ...[
              _buildBstComplexitySection(),
            ] else if (widget.topic.id == 207) ...[
              _buildHeapComplexitySection(),
            ] else if (widget.topic.id == 208) ...[
              _buildGraphComplexitySection(),
            ] else if (widget.topic.id == 209) ...[
              _buildTrieComplexitySection(),
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
                  ? (widget.topic.id == 202 ? "🔑 Core Characteristics & Pointer Mechanics" : (widget.topic.id == 203 ? "🔑 Core Characteristics & LIFO Mechanism" : (widget.topic.id == 204 ? "🔑 Core Characteristics & FIFO Pipeline" : (widget.topic.id == 205 ? "🔑 Core Characteristics & Hashing Mechanism" : "🔑 Core Characteristics & Multi-Dimensional Layouts"))))
                  : (widget.topic.id == 202 ? "🔑 মূল বৈশিষ্ট্য ও পয়েন্টার মেকানিক্স" : (widget.topic.id == 203 ? "🔑 মূল বৈশিষ্ট্য ও LIFO মেকানিজম" : (widget.topic.id == 204 ? "🔑 মূল বৈশিষ্ট্য ও FIFO পাইপলাইন" : (widget.topic.id == 205 ? "🔑 মূল বৈশিষ্ট্য ও হ্যাশিং মেকানিজম" : "🔑 মূল বৈশিষ্ট্য ও মেমোরি লেআউট")))),
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
                  ? (widget.topic.id == 202 ? "💻 Node Data Structures (Singly & Doubly Nodes)" : (widget.topic.id == 203 ? "💻 Stack Implementations (Array & Monotonic)" : (widget.topic.id == 204 ? "💻 Queue & Deque Implementations" : (widget.topic.id == 205 ? "💻 Hash Map & Hash Set Implementations" : "💻 Code Examples (1D, 2D Grid & 3D Cube)"))))
                  : (widget.topic.id == 202 ? "💻 নোড ডেটা স্ট্রাকচার (Singly ও Doubly নোড)" : (widget.topic.id == 203 ? "💻 স্ট্যাক ইমপ্লিমেন্টেশন (অ্যারে ও মনোটোনিক)" : (widget.topic.id == 204 ? "💻 কিউ ও Deque ইমপ্লিমেন্টেশন" : (widget.topic.id == 205 ? "💻 হ্যাশ ম্যাপ ও হ্যাশ সেট ইমপ্লিমেন্টেশন" : "💻 কোড উদাহরণ (১D, ২D ম্যাট্রিক্স ও ৩D কিউব)")))),
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
                      _isEnglish ? "Linked List & Floyd's Fast/Slow Pointers Metrics" : "লিঙ্কড লিস্ট ও ফ্লয়েডস ফাস্ট/স্লো পয়েন্টার মেট্রিক্স",
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
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildComplexityBadge(_isEnglish ? "Head Insert/Delete" : "হেড ইনসার্ট/ডিলেট", "O(1)", AppTheme.accentGreen),
                    const SizedBox(width: 10),
                    _buildComplexityBadge(_isEnglish ? "Floyd's Cycle Detect" : "ফ্লয়েড সাইকেল ডিটেক্ট", "O(N) Time | O(1) Space", AppTheme.accentNeonCyan),
                    const SizedBox(width: 10),
                    _buildComplexityBadge(_isEnglish ? "Fast/Slow Middle Node" : "মিডল নোড নির্ণয়", "O(N) Time | O(1) Space", AppTheme.accentPurple),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Comparison Table Card (Array vs Singly vs Doubly vs Fast & Slow Pointers)
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
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    const Icon(Icons.table_chart_outlined, color: AppTheme.accentPurple, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      _isEnglish ? "Array vs Singly LL vs Fast & Slow Pointers (Floyd's)" : "অ্যারে বনাম Singly LL বনাম ফাস্ট ও স্লো পয়েন্টার তুলনা",
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                  ],
                ),
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
                        _buildTableHeaderCell("Fast & Slow Pointers (Floyd's)"),
                      ],
                    ),
                    TableRow(
                      children: [
                        _buildTableCell(_isEnglish ? "Cycle Detection Strategy" : "সাইকেল নির্ণয়ের কৌশল", isBold: true),
                        _buildTableCell(_isEnglish ? "N/A (Fixed size)" : "এন/এ", color: AppTheme.textMuted),
                        _buildTableCell(_isEnglish ? "O(N) Hash Set Space" : "হ্যাশ সেটে O(N) স্পেস", color: AppTheme.accentAmber),
                        _buildTableCell(_isEnglish ? "O(1) Memory Space (meet at cycle)" : "O(1) স্পেস (লুপে মিলিত হয়)", color: AppTheme.accentGreen),
                      ],
                    ),
                    TableRow(
                      children: [
                        _buildTableCell(_isEnglish ? "Middle Node Finding" : "মিডল নোড খোঁজার উপায়", isBold: true),
                        _buildTableCell("O(1) Index [len/2]", color: AppTheme.accentGreen),
                        _buildTableCell(_isEnglish ? "2 Passes (Length count + Walk)" : "২বার ট্রাভার্সাল (দৈর্ঘ্য+ওয়াক)", color: AppTheme.accentAmber),
                        _buildTableCell(_isEnglish ? "1 Pass (slow=1 step, fast=2 steps)" : "১ পাস (slow ১ ধাপ, fast ২ ধাপ)", color: AppTheme.accentGreen),
                      ],
                    ),
                    TableRow(
                      children: [
                        _buildTableCell(_isEnglish ? "Memory Space Overhead" : "অতিরিক্ত মেমোরি খরচ", isBold: true),
                        _buildTableCell("0 Extra Pointers", color: AppTheme.accentGreen),
                        _buildTableCell("O(N) Hash Set / Nodes", color: Colors.redAccent),
                        _buildTableCell("O(1) Auxiliary (2 pointers)", color: AppTheme.accentGreen),
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

  Widget _buildStackComplexitySection() {
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
                  const Icon(Icons.layers_outlined, color: AppTheme.accentGreen, size: 22),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _isEnglish ? "Stack (LIFO) Operations Complexity" : "স্ট্যাক (LIFO) অপারেশনস জটিলতা",
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
                  _buildComplexityBadge(_isEnglish ? "Push / Pop" : "পুশ (Push) / পপ (Pop)", "O(1)", AppTheme.accentGreen),
                  _buildComplexityBadge(_isEnglish ? "Top / Peek" : "টপ (Top) দেখা", "O(1)", AppTheme.accentNeonCyan),
                  _buildComplexityBadge(_isEnglish ? "Search Element" : "এলিমেন্ট খোজা", "O(N)", AppTheme.accentAmber),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Comparison Table Card (Stack vs Queue vs Array)
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
                  const Icon(Icons.table_chart_outlined, color: AppTheme.accentGreen, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _isEnglish ? "Stack (LIFO) vs Queue (FIFO) vs Array" : "স্ট্যাক (LIFO) বনাম কিউ (FIFO) বনাম অ্যারে তুলনা",
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                    ),
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
                        _buildTableHeaderCell("Stack (LIFO)"),
                        _buildTableHeaderCell("Queue (FIFO)"),
                        _buildTableHeaderCell("Array"),
                      ],
                    ),
                    TableRow(
                      children: [
                        _buildTableCell(_isEnglish ? "Access Principle" : "এক্সেস নীতি", isBold: true),
                        _buildTableCell(_isEnglish ? "LIFO (Last In First Out)" : "LIFO (লাস্ট-ইন ফার্স্ট-আউট)", color: AppTheme.accentGreen),
                        _buildTableCell(_isEnglish ? "FIFO (First In First Out)" : "FIFO (ফার্স্ট-ইন ফার্স্ট-আউট)", color: AppTheme.accentNeonCyan),
                        _buildTableCell(_isEnglish ? "Random Access [index]" : "র্যান্ডম ইনডেক্স এক্সেস", color: AppTheme.accentAmber),
                      ],
                    ),
                    TableRow(
                      children: [
                        _buildTableCell(_isEnglish ? "Insertion Point" : "এলিমেন্ট যোগ করার স্থান", isBold: true),
                        _buildTableCell(_isEnglish ? "TOP only O(1)" : "কেবল TOP প্রান্তে O(1)", color: AppTheme.accentGreen),
                        _buildTableCell(_isEnglish ? "REAR end O(1)" : "REAR ব্যাক প্রান্তে O(1)", color: AppTheme.accentNeonCyan),
                        _buildTableCell(_isEnglish ? "Any Index O(N)" : "যে কোনো ইনডেক্সে O(N)", color: Colors.redAccent),
                      ],
                    ),
                    TableRow(
                      children: [
                        _buildTableCell(_isEnglish ? "Deletion Point" : "এলিমেন্ট মোছার স্থান", isBold: true),
                        _buildTableCell(_isEnglish ? "TOP only O(1)" : "কেবল TOP প্রান্তে O(1)", color: AppTheme.accentGreen),
                        _buildTableCell(_isEnglish ? "FRONT head O(1)" : "FRONT ফ্রন্ট প্রান্তে O(1)", color: AppTheme.accentNeonCyan),
                        _buildTableCell(_isEnglish ? "Any Index O(N)" : "যে কোনো ইনডেক্সে O(N)", color: Colors.redAccent),
                      ],
                    ),
                    TableRow(
                      children: [
                        _buildTableCell(_isEnglish ? "Primary Use Cases" : "প্রধান ব্যবহার ক্ষেত্র", isBold: true),
                        _buildTableCell(_isEnglish ? "Recursion, Call Stack, Undo" : "কল স্ট্যাক, রিকার্শন, ব্র্যাকেট", color: AppTheme.accentGreen),
                        _buildTableCell(_isEnglish ? "BFS, Task Scheduling, Print Buffer" : "BFS গ্রাফ, প্রসেস শিডিউলিং", color: AppTheme.accentNeonCyan),
                        _buildTableCell(_isEnglish ? "Direct Lookup Tables" : "ডাইরেক্ট লুকআপ টেবিল", color: AppTheme.accentAmber),
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

  Widget _buildQueueComplexitySection() {
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
                  const Icon(Icons.swap_horizontal_circle_outlined, color: AppTheme.accentAmber, size: 22),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _isEnglish ? "Queue (FIFO) & Deque Operations Complexity" : "কিউ (FIFO) ও Deque অপারেশনস জটিলতা",
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
                  _buildComplexityBadge(_isEnglish ? "Enqueue / Dequeue" : "এনকিউ / ডিকিউ", "O(1)", AppTheme.accentGreen),
                  _buildComplexityBadge(_isEnglish ? "Front / Peek" : "ফ্রন্ট (Front) দেখা", "O(1)", AppTheme.accentNeonCyan),
                  _buildComplexityBadge(_isEnglish ? "Search Element" : "এলিমেন্ট খোজা", "O(N)", AppTheme.accentAmber),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Comparison Table Card (Queue vs Deque vs Stack vs Array)
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
                  const Icon(Icons.table_chart_outlined, color: AppTheme.accentAmber, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _isEnglish ? "Queue (FIFO) vs Deque vs Stack (LIFO) Comparison" : "কিউ (FIFO) বনাম Deque বনাম স্ট্যাক (LIFO) তুলনা",
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                    ),
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
                        _buildTableHeaderCell("Queue (FIFO)"),
                        _buildTableHeaderCell("Deque (Double-Ended)"),
                        _buildTableHeaderCell("Stack (LIFO)"),
                      ],
                    ),
                    TableRow(
                      children: [
                        _buildTableCell(_isEnglish ? "Access Principle" : "এক্সেস নীতি", isBold: true),
                        _buildTableCell(_isEnglish ? "FIFO (First In First Out)" : "FIFO (ফার্স্ট-ইন ফার্স্ট-আউট)", color: AppTheme.accentAmber),
                        _buildTableCell(_isEnglish ? "Double-Ended (Front & Rear)" : "উভয় প্রান্ত (Front ও Rear)", color: AppTheme.accentNeonCyan),
                        _buildTableCell(_isEnglish ? "LIFO (Last In First Out)" : "LIFO (লাস্ট-ইন ফার্স্ট-আউট)", color: AppTheme.accentGreen),
                      ],
                    ),
                    TableRow(
                      children: [
                        _buildTableCell(_isEnglish ? "Insertion Point" : "এলিমেন্ট যোগ করার স্থান", isBold: true),
                        _buildTableCell(_isEnglish ? "REAR end only O(1)" : "কেবল REAR প্রান্তে O(1)", color: AppTheme.accentAmber),
                        _buildTableCell(_isEnglish ? "Both Front & Rear O(1)" : "Front ও Rear উভয়ে O(1)", color: AppTheme.accentNeonCyan),
                        _buildTableCell(_isEnglish ? "TOP end only O(1)" : "কেবল TOP প্রান্তে O(1)", color: AppTheme.accentGreen),
                      ],
                    ),
                    TableRow(
                      children: [
                        _buildTableCell(_isEnglish ? "Deletion Point" : "এলিমেন্ট মোছার স্থান", isBold: true),
                        _buildTableCell(_isEnglish ? "FRONT head only O(1)" : "কেবল FRONT প্রান্তে O(1)", color: AppTheme.accentAmber),
                        _buildTableCell(_isEnglish ? "Both Front & Rear O(1)" : "Front ও Rear উভয়ে O(1)", color: AppTheme.accentNeonCyan),
                        _buildTableCell(_isEnglish ? "TOP end only O(1)" : "কেবল TOP প্রান্তে O(1)", color: AppTheme.accentGreen),
                      ],
                    ),
                    TableRow(
                      children: [
                        _buildTableCell(_isEnglish ? "Primary Use Cases" : "প্রধান ব্যবহার ক্ষেত্র", isBold: true),
                        _buildTableCell(_isEnglish ? "BFS, CPU Task Scheduling" : "BFS গ্রাফ, প্রসেস শিডিউলিং", color: AppTheme.accentAmber),
                        _buildTableCell(_isEnglish ? "Sliding Window Max, Palindromes" : "স্লাইডিং উইন্ডো, প্যালেইনড্রোম", color: AppTheme.accentNeonCyan),
                        _buildTableCell(_isEnglish ? "Recursion, Call Stack, Undo" : "কল স্ট্যাক, রিকার্শন, ব্র্যাকেট", color: AppTheme.accentGreen),
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

  Widget _buildGraphComplexitySection() {
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
                  const Icon(Icons.hub_outlined, color: Color(0xFF0284C7), size: 22),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _isEnglish ? "Graph Operations & Memory Complexity Metrics" : "গ্রাফ ট্রাভার্সাল ও মেমোরি জটিলতা মেট্রিক্স",
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
                  _buildComplexityBadge(_isEnglish ? "BFS / DFS Search" : "BFS / DFS সময়", "O(V + E)", AppTheme.accentGreen),
                  _buildComplexityBadge(_isEnglish ? "Adj List Space" : "অ্যাডজাসেন্সি লিস্ট", "O(V + E)", AppTheme.accentNeonCyan),
                  _buildComplexityBadge(_isEnglish ? "Adj Matrix Space" : "অ্যাডজাসেন্সি ম্যাট্রিক্স", "O(V²)", AppTheme.accentAmber),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Comparison Table Card (Adjacency List vs Adjacency Matrix vs Edge List)
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
                  const Icon(Icons.table_chart_outlined, color: Color(0xFF0284C7), size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _isEnglish ? "Adjacency List vs Adjacency Matrix vs Edge List Comparison" : "অ্যাডজাসেন্সি লিস্ট বনাম ম্যাট্রিক্স বনাম এজ লিস্ট তুলনা",
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                    ),
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
                        _buildTableHeaderCell(_isEnglish ? "Property / Feature" : "বৈশিষ্ট্য / মেকানিজম"),
                        _buildTableHeaderCell("Adjacency List"),
                        _buildTableHeaderCell("Adjacency Matrix"),
                        _buildTableHeaderCell("Edge List"),
                      ],
                    ),
                    TableRow(
                      children: [
                        _buildTableCell(_isEnglish ? "Space Complexity" : "মেমোরি স্পেস জটিলতা", isBold: true),
                        _buildTableCell(_isEnglish ? "O(V + E) Optimal for Sparse" : "স্পার্স গ্রাফে O(V + E)", color: AppTheme.accentGreen),
                        _buildTableCell(_isEnglish ? "O(V²) Dense graph fit" : "ডেন্স গ্রাফে O(V²)", color: AppTheme.accentAmber),
                        _buildTableCell(_isEnglish ? "O(E) Minimal edges only" : "কেবল এজের ওয়ান O(E)", color: AppTheme.accentNeonCyan),
                      ],
                    ),
                    TableRow(
                      children: [
                        _buildTableCell(_isEnglish ? "Check Edge (u, v)" : "(u, v) এজ সংযোগ চেক", isBold: true),
                        _buildTableCell(_isEnglish ? "O(degree(u)) Scan list" : "লিস্ট স্ক্যানে O(deg)", color: AppTheme.accentNeonCyan),
                        _buildTableCell(_isEnglish ? "O(1) Instant matrix lookup" : "ম্যাট্রিক্সে ইনস্ট্যান্ট O(1)", color: AppTheme.accentGreen),
                        _buildTableCell(_isEnglish ? "O(E) Full edge loop" : "ফুল এজ লুপে O(E)", color: Colors.redAccent),
                      ],
                    ),
                    TableRow(
                      children: [
                        _buildTableCell(_isEnglish ? "Find All Neighbors of u" : "u এর সব প্রতিবেশী খোজা", isBold: true),
                        _buildTableCell(_isEnglish ? "O(degree(u)) Direct access" : "সরাসরি লিস্টে O(deg)", color: AppTheme.accentGreen),
                        _buildTableCell(_isEnglish ? "O(V) Iterate entire row" : "রো স্ক্যান করে O(V)", color: AppTheme.accentAmber),
                        _buildTableCell(_isEnglish ? "O(E) Iterate all edges" : "সব এজ স্ক্যান ওয়ান O(E)", color: Colors.redAccent),
                      ],
                    ),
                    TableRow(
                      children: [
                        _buildTableCell(_isEnglish ? "Underlying Data Structure" : "অভ্যন্তরীণ অবকাঠামো", isBold: true),
                        _buildTableCell(_isEnglish ? "Array of Dynamic Vectors (`adj[u]`)" : "ডাইনামিক ভেক্টর অ্যারে", color: AppTheme.accentGreen),
                        _buildTableCell(_isEnglish ? "2D Flat Matrix (`matrix[V][V]`)" : "২D ফ্ল্যাট গ্রিড ম্যাট্রিক্স", color: AppTheme.accentAmber),
                        _buildTableCell(_isEnglish ? "Array of Tuples (`(u, v, w)`)" : "এজ টুপলের তালিকা", color: AppTheme.accentNeonCyan),
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

  Widget _buildTrieComplexitySection() {
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
                  const Icon(Icons.sort_by_alpha_outlined, color: Color(0xFFA855F7), size: 22),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _isEnglish ? "Trie Search & Prefix Lookup Complexity Metrics" : "ট্রাই সার্চ ও প্রিফিক্স জটিলতা মেট্রিক্স",
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
                  _buildComplexityBadge(_isEnglish ? "Insert / Search" : "ইনসার্ট / সার্চ", "O(L)", AppTheme.accentGreen),
                  _buildComplexityBadge(_isEnglish ? "StartsWith Prefix" : "প্রিফিক্স চেক", "O(L)", AppTheme.accentNeonCyan),
                  _buildComplexityBadge(_isEnglish ? "Space Complexity" : "মেমোরি স্পেস", "O(N×L×26)", AppTheme.accentAmber),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Comparison Table Card (Trie vs Hash Set vs BST vs Array)
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
                  const Icon(Icons.table_chart_outlined, color: Color(0xFFA855F7), size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _isEnglish ? "Trie (Prefix Tree) vs Hash Set vs BST Comparison" : "ট্রাই (Prefix Tree) বনাম হ্যাশ সেট বনাম BST তুলনা",
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                    ),
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
                        _buildTableHeaderCell(_isEnglish ? "Property / Feature" : "বৈশিষ্ট্য / মেকানিজম"),
                        _buildTableHeaderCell("Trie (Prefix Tree)"),
                        _buildTableHeaderCell("Hash Set (`std::unordered_set`)"),
                        _buildTableHeaderCell("Binary Search Tree (BST)"),
                      ],
                    ),
                    TableRow(
                      children: [
                        _buildTableCell(_isEnglish ? "Search Exact Word" : "হুবহু শব্দ অনুসন্ধান", isBold: true),
                        _buildTableCell(_isEnglish ? "O(L) Word length bound" : "অক্ষরের সংখ্যায় O(L)", color: AppTheme.accentGreen),
                        _buildTableCell(_isEnglish ? "O(L) Hash calculation" : "হ্যাশ ডাইজেস্টে O(L)", color: AppTheme.accentGreen),
                        _buildTableCell(_isEnglish ? "O(L × log N) String cmp" : "স্ট্রিং তুলনায় O(L log N)", color: AppTheme.accentAmber),
                      ],
                    ),
                    TableRow(
                      children: [
                        _buildTableCell(_isEnglish ? "Find All Words with Prefix 'app'" : "প্রিফিক্স 'app' দিয়ে শব্দ খোজ", isBold: true),
                        _buildTableCell(_isEnglish ? "O(L + K) Instant tree sub-walk" : "ইনস্ট্যান্ট ওয়ান O(L + K)", color: AppTheme.accentGreen),
                        _buildTableCell(_isEnglish ? "O(N × L) Full set iteration" : "ফুল সেট স্ক্যানে O(N × L)", color: Colors.redAccent),
                        _buildTableCell(_isEnglish ? "O(N × L) Scan subtrees" : "সাব-ট্রি স্ক্যানে O(N × L)", color: Colors.redAccent),
                      ],
                    ),
                    TableRow(
                      children: [
                        _buildTableCell(_isEnglish ? "Wildcard / Auto-Complete" : "অটো-কমপ্লিট / ডট ('.') সার্চ", isBold: true),
                        _buildTableCell(_isEnglish ? "O(L) DFS N-ary Branching" : "N-আকার ব্রাঞ্চিংয়ে O(L)", color: AppTheme.accentGreen),
                        _buildTableCell(_isEnglish ? "Not Supported (Requires Regex)" : "সরাসরি সম্ভব নয়", color: Colors.redAccent),
                        _buildTableCell(_isEnglish ? "Complex Inorder Traversal" : "ইন-অর্ডার ট্রাভার্সাল", color: AppTheme.accentAmber),
                      ],
                    ),
                    TableRow(
                      children: [
                        _buildTableCell(_isEnglish ? "Underlying Node Structure" : "অভ্যন্তরীণ নোড অবকাঠামো", isBold: true),
                        _buildTableCell(_isEnglish ? "`TrieNode* children[26]`" : "২৬ চাইল্ড পয়েন্টার অ্যারে", color: AppTheme.accentGreen),
                        _buildTableCell(_isEnglish ? "Bucketed Hash Table" : "হ্যাশ টেবিল কন্টেইনার", color: AppTheme.accentAmber),
                        _buildTableCell(_isEnglish ? "Binary Node (`left, right`)" : "বাইনারি নোড (বাম, ডান)", color: AppTheme.accentNeonCyan),
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

  Widget _buildHeapComplexitySection() {
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
                  const Icon(Icons.unfold_more_double_outlined, color: Color(0xFF84CC16), size: 22),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _isEnglish ? "Min & Max Heap Operations Complexity Metrics" : "হিপ ও প্রায়োরিটি কিউ জটিলতা মেট্রিক্স",
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
                  _buildComplexityBadge(_isEnglish ? "Peek Top (Min/Max)" : "টপ মান (Peek)", "O(1)", AppTheme.accentGreen),
                  _buildComplexityBadge(_isEnglish ? "Push / Pop (Heapify)" : "ইনসার্ট / পপ (Heapify)", "O(log N)", AppTheme.accentNeonCyan),
                  _buildComplexityBadge(_isEnglish ? "Build Heap (Floyd)" : "হিপ তৈরি (Build)", "O(N)", AppTheme.accentAmber),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Comparison Table Card (Heap vs BST vs Unsorted Array)
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
                  const Icon(Icons.table_chart_outlined, color: Color(0xFF84CC16), size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _isEnglish ? "Binary Heap vs BST vs Unsorted Array Comparison" : "বাইনারি হিপ বনাম BST বনাম আনসর্টেড অ্যারে তুলনা",
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                    ),
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
                        _buildTableHeaderCell(_isEnglish ? "Property / Feature" : "বৈশিষ্ট্য / মেকানিজম"),
                        _buildTableHeaderCell("Binary Heap (Min/Max)"),
                        _buildTableHeaderCell("Binary Search Tree (BST)"),
                        _buildTableHeaderCell("Unsorted Array"),
                      ],
                    ),
                    TableRow(
                      children: [
                        _buildTableCell(_isEnglish ? "Find Extreme (Min or Max)" : "সর্বনিম্ন / সর্বোচ্চ খোজা", isBold: true),
                        _buildTableCell(_isEnglish ? "O(1) Instant Root Peek" : "রুটে ওয়ান O(1)", color: AppTheme.accentGreen),
                        _buildTableCell(_isEnglish ? "O(log N) Go to leftmost/rightmost" : "একপাশে হেঁটে O(log N)", color: AppTheme.accentNeonCyan),
                        _buildTableCell(_isEnglish ? "O(N) Full Array Scan" : "ফুল স্ক্যান O(N)", color: Colors.redAccent),
                      ],
                    ),
                    TableRow(
                      children: [
                        _buildTableCell(_isEnglish ? "Insert New Element" : "নতুন উপাদান যোগ", isBold: true),
                        _buildTableCell(_isEnglish ? "O(log N) Bubble-Up" : "বাবল-আপ ওয়ান O(log N)", color: AppTheme.accentGreen),
                        _buildTableCell(_isEnglish ? "O(log N) Traverse down" : "নিচে নেমে O(log N)", color: AppTheme.accentNeonCyan),
                        _buildTableCell(_isEnglish ? "O(1) Append at end" : "শেষে যুক্ত O(1)", color: AppTheme.accentAmber),
                      ],
                    ),
                    TableRow(
                      children: [
                        _buildTableCell(_isEnglish ? "Build Structure from Array" : "সম্পূর্ণ অ্যারে থেকে তৈরি", isBold: true),
                        _buildTableCell(_isEnglish ? "O(N) Floyd's Algorithm" : "ফ্লয়েড অ্যালগরিদমে O(N)", color: AppTheme.accentGreen),
                        _buildTableCell(_isEnglish ? "O(N log N) N insertions" : "N বার ইনসার্ট O(N log N)", color: AppTheme.accentNeonCyan),
                        _buildTableCell(_isEnglish ? "O(1) No build required" : "তৈরি করতে হয় না O(1)", color: AppTheme.accentAmber),
                      ],
                    ),
                    TableRow(
                      children: [
                        _buildTableCell(_isEnglish ? "Underlying Storage Structure" : "অভ্যন্তরীণ অবকাঠামো", isBold: true),
                        _buildTableCell(_isEnglish ? "Contiguous 1D Array (`2i+1, 2i+2`)" : "১D অ্যারে মেমোরি", color: AppTheme.accentGreen),
                        _buildTableCell(_isEnglish ? "Left/Right Pointer Triplets" : "পয়েন্টার নোড ট্রিপ্লেট", color: AppTheme.accentNeonCyan),
                        _buildTableCell(_isEnglish ? "Contiguous Memory Block" : "ধারাবাহিক মেমোরি ব্লক", color: AppTheme.accentAmber),
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

  Widget _buildBstComplexitySection() {
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
                  const Icon(Icons.account_tree_outlined, color: AppTheme.accentNeonCyan, size: 22),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _isEnglish ? "Binary Search Tree Operations Complexity Metrics" : "বাইনারি সার্চ ট্রি জটিলতা মেট্রিক্স",
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
                  _buildComplexityBadge(_isEnglish ? "Search / Insert (Avg)" : "গড় সময় (Search/Insert)", "O(log N)", AppTheme.accentGreen),
                  _buildComplexityBadge(_isEnglish ? "Worst Case (Skewed)" : "সবচেয়ে খারাপ সময় (Skewed)", "O(N)", AppTheme.accentAmber),
                  _buildComplexityBadge(_isEnglish ? "Call Stack Space" : "কল স্ট্যাক স্পেস", "O(H)", AppTheme.accentNeonCyan),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Comparison Table Card (BST vs Sorted Array vs Binary Heap vs Hash Map)
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
                  const Icon(Icons.table_chart_outlined, color: AppTheme.accentNeonCyan, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _isEnglish ? "BST vs Sorted Array vs Binary Heap vs Hash Map Comparison" : "BST বনাম সর্টেড অ্যারে বনাম হিপ বনাম হ্যাশ ম্যাপ তুলনা",
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                    ),
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
                        _buildTableHeaderCell(_isEnglish ? "Property / Feature" : "বৈশিষ্ট্য / মেকানিজম"),
                        _buildTableHeaderCell("Binary Search Tree (BST)"),
                        _buildTableHeaderCell("Sorted Array (Binary Search)"),
                        _buildTableHeaderCell("Hash Map (Hash Table)"),
                      ],
                    ),
                    TableRow(
                      children: [
                        _buildTableCell(_isEnglish ? "Lookup / Search Time" : "খোজা বা Lookup সময়", isBold: true),
                        _buildTableCell(_isEnglish ? "O(log N) Average" : "গড়ে O(log N)", color: AppTheme.accentGreen),
                        _buildTableCell(_isEnglish ? "O(log N) Guaranteed" : "সর্বদা O(log N)", color: AppTheme.accentNeonCyan),
                        _buildTableCell(_isEnglish ? "O(1) Average" : "গড়ে O(1)", color: AppTheme.accentAmber),
                      ],
                    ),
                    TableRow(
                      children: [
                        _buildTableCell(_isEnglish ? "Dynamic Insertion Time" : "ডাইনামিক ইনসার্ট সময়", isBold: true),
                        _buildTableCell(_isEnglish ? "O(log N) without shifting" : "শিফটিং ছাড়া O(log N)", color: AppTheme.accentGreen),
                        _buildTableCell(_isEnglish ? "O(N) due to element shift" : "শিফটিং এর কারণে O(N)", color: Colors.redAccent),
                        _buildTableCell(_isEnglish ? "O(1) Average" : "গড়ে O(1)", color: AppTheme.accentAmber),
                      ],
                    ),
                    TableRow(
                      children: [
                        _buildTableCell(_isEnglish ? "Sorted Traversal Cost" : "সর্টেড ক্রমানুসার প্রিন্ট", isBold: true),
                        _buildTableCell(_isEnglish ? "O(N) Inorder Walk" : "Inorder লুপে O(N)", color: AppTheme.accentGreen),
                        _buildTableCell(_isEnglish ? "O(N) Linear Scan" : "লিনিয়ার স্ক্যান O(N)", color: AppTheme.accentNeonCyan),
                        _buildTableCell(_isEnglish ? "O(N log N) requires sort" : "সর্ট ছাড়া সম্ভব নয়", color: Colors.redAccent),
                      ],
                    ),
                    TableRow(
                      children: [
                        _buildTableCell(_isEnglish ? "Underlying Data Structure" : "অভ্যন্তরীণ অবকাঠামো", isBold: true),
                        _buildTableCell(_isEnglish ? "Left/Right Pointer Nodes" : "পয়েন্টার নোড ট্রিপ্লেট", color: AppTheme.accentNeonCyan),
                        _buildTableCell(_isEnglish ? "Contiguous Memory Block" : "ধারাবাহিক মেমোরি ব্লক", color: AppTheme.accentAmber),
                        _buildTableCell(_isEnglish ? "Bucket Array + Chaining" : "বাকেট অ্যারে + চেইনিং", color: AppTheme.accentPink),
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

  Widget _buildHashMapComplexitySection() {
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
                  const Icon(Icons.grid_view_outlined, color: AppTheme.accentPink, size: 22),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _isEnglish ? "Hash Table Operations Complexity Metrics" : "হ্যাশ টেবিল ও হ্যাশ ম্যাপের জটিলতা মেট্রিক্স",
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
                  _buildComplexityBadge(_isEnglish ? "Average Lookup/Put" : "গড় সময় (Lookup/Put)", "O(1)", AppTheme.accentGreen),
                  _buildComplexityBadge(_isEnglish ? "Worst Case (Collision)" : "সবচেয়ে খারাপ সময়", "O(N)", AppTheme.accentAmber),
                  _buildComplexityBadge(_isEnglish ? "Space Complexity" : "স্পেস জটিলতা", "O(N)", AppTheme.accentNeonCyan),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Comparison Table Card (Hash Map vs Tree Map vs Direct Array Index)
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
                  const Icon(Icons.table_chart_outlined, color: AppTheme.accentPink, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _isEnglish ? "Hash Map vs Tree Map (BST) vs Array Comparison" : "হ্যাশ ম্যাপ বনাম ট্রি ম্যাপ বনাম অ্যারে তুলনা",
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                    ),
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
                        _buildTableHeaderCell(_isEnglish ? "Property / Feature" : "বৈশিষ্ট্য / মেকানিজম"),
                        _buildTableHeaderCell("Hash Map (Hash Table)"),
                        _buildTableHeaderCell("Tree Map (Red-Black BST)"),
                        _buildTableHeaderCell("Array Indexing"),
                      ],
                    ),
                    TableRow(
                      children: [
                        _buildTableCell(_isEnglish ? "Lookup / Search Time" : "খোজা বা Lookup সময়", isBold: true),
                        _buildTableCell(_isEnglish ? "O(1) Average" : "গড়ে O(1)", color: AppTheme.accentGreen),
                        _buildTableCell(_isEnglish ? "O(log N) Guaranteed" : "সর্বদা O(log N)", color: AppTheme.accentNeonCyan),
                        _buildTableCell(_isEnglish ? "O(1) by integer index" : "ইনডেক্স দিয়ে O(1)", color: AppTheme.accentAmber),
                      ],
                    ),
                    TableRow(
                      children: [
                        _buildTableCell(_isEnglish ? "Key Ordering" : "কী বা চাবির ক্রমানুসার", isBold: true),
                        _buildTableCell(_isEnglish ? "Unordered / Random" : "অবিন্যস্ত (Unordered)", color: Colors.redAccent),
                        _buildTableCell(_isEnglish ? "Strictly Sorted Keys" : "সর্টেড বা সাজানো", color: AppTheme.accentGreen),
                        _buildTableCell(_isEnglish ? "Sequential Indices 0..N-1" : "ধারাবাহিক ০..N-1", color: AppTheme.accentAmber),
                      ],
                    ),
                    TableRow(
                      children: [
                        _buildTableCell(_isEnglish ? "Underlying Data Structure" : "অভ্যন্তরীণ অবকাঠামো", isBold: true),
                        _buildTableCell(_isEnglish ? "Bucket Array + Chaining/Probing" : "বাকেট অ্যারে + চেইনিং", color: AppTheme.accentPink),
                        _buildTableCell(_isEnglish ? "Self-Balancing Red-Black Tree" : "ব্যালেন্সড বাইনারি ট্রি", color: AppTheme.accentNeonCyan),
                        _buildTableCell(_isEnglish ? "Contiguous Memory Block" : "ধারাবাহিক মেমোরি ব্লক", color: AppTheme.accentAmber),
                      ],
                    ),
                    TableRow(
                      children: [
                        _buildTableCell(_isEnglish ? "Best Use Cases" : "সেরা ব্যবহার ক্ষেত্র", isBold: true),
                        _buildTableCell(_isEnglish ? "Frequency Count, Two Sum O(1)" : "ফ্রিকোয়েন্সি, টু-সাম, ক্যাশ", color: AppTheme.accentGreen),
                        _buildTableCell(_isEnglish ? "Range Queries, Sorted Map" : "রেঞ্জ কোয়েরি, সর্টেড কী", color: AppTheme.accentNeonCyan),
                        _buildTableCell(_isEnglish ? "Direct Dense Index Access" : "ঘন ইনডেক্স এক্সেস", color: AppTheme.accentAmber),
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
