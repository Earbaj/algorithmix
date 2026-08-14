import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';
import '../widgets/middle_of_linked_list/middle_problem_description_tab.dart';
import '../widgets/middle_of_linked_list/middle_code_free_guide_tab.dart';
import '../widgets/middle_of_linked_list/middle_dynamic_visualizer_tab.dart';
import '../widgets/middle_of_linked_list/middle_code_debugger_tab.dart';
import '../widgets/middle_of_linked_list/middle_solution_code_tab.dart';

class MiddleOfLinkedListDetailScreen extends StatefulWidget {
  const MiddleOfLinkedListDetailScreen({super.key});

  @override
  State<MiddleOfLinkedListDetailScreen> createState() => _MiddleOfLinkedListDetailScreenState();
}

class _MiddleOfLinkedListDetailScreenState extends State<MiddleOfLinkedListDetailScreen>
    with SingleTickerProviderStateMixin {
  bool _isEnglish = true;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
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
        title: Text(
          '876. Middle of the Linked List',
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
          labelStyle: TextStyle(fontSize: Responsive.sp(context, 14), fontWeight: FontWeight.bold),
          unselectedLabelStyle: TextStyle(fontSize: Responsive.sp(context, 13)),
          tabs: [
            Tab(text: _isEnglish ? '📘 Problem Description' : '📘 প্রবলেম বিবরণ'),
            Tab(text: _isEnglish ? '🎨 Animated Visual Guide' : '🎨 অ্যানিমেটেড ভিজ্যুয়াল গাইড'),
            Tab(text: _isEnglish ? '⚡ Dynamic Visualizer' : '⚡ কাস্টম ভিজ্যুয়ালাইজার'),
            Tab(text: _isEnglish ? '🐞 Code Execution Debugger' : '🐞 কোড ডিবাগার'),
            Tab(text: _isEnglish ? '💡 Solution Code' : '💡 সমাধান কোড'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          MiddleProblemDescriptionTab(isEnglish: _isEnglish),
          MiddleCodeFreeGuideTab(isEnglish: _isEnglish),
          MiddleDynamicVisualizerTab(isEnglish: _isEnglish),
          MiddleCodeDebuggerTab(isEnglish: _isEnglish),
          MiddleSolutionCodeTab(isEnglish: _isEnglish),
        ],
      ),
    );
  }
}
