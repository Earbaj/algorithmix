import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import '../models/kway_merge_data.dart';
import 'sub_views/concept_tab_view.dart';
import 'sub_views/visualizer_tab_view.dart';
import 'sub_views/problems_tab_view.dart';
import 'sub_views/mistakes_tab_view.dart';

class KWayMergeDetailScreen extends StatefulWidget {
  const KWayMergeDetailScreen({super.key});

  @override
  State<KWayMergeDetailScreen> createState() => _KWayMergeDetailScreenState();
}

class _KWayMergeDetailScreenState extends State<KWayMergeDetailScreen>
    with SingleTickerProviderStateMixin {
  bool _isEnglish = true;
  late TabController _tabController;

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
    final intro = KWayMergeData.getConceptIntro(_isEnglish);

    return Scaffold(
      backgroundColor: AppTheme.primaryDark,
      appBar: AppBar(
        title: Text(_isEnglish ? 'K-Way Merge Deep Dive' : 'K-Way Merge গাইড'),
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
          tabAlignment: TabAlignment.start,
          padding: EdgeInsets.zero,
          tabs: [
            Tab(text: _isEnglish ? 'Concept & C++ Code' : 'ধারণা ও C++ কোড'),
            Tab(text: _isEnglish ? 'Visualizer' : 'ভিজ্যুয়ালাইজার'),
            Tab(text: _isEnglish ? 'FAANG Problems' : 'FAANG প্রবলেমস'),
            Tab(text: _isEnglish ? 'Mistakes & Roadmap' : 'ভুল ও রোডম্যাপ'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          KWayMergeConceptTabView(intro: intro, isEnglish: _isEnglish),
          KWayMergeVisualizerTabView(isEnglish: _isEnglish),
          KWayMergeProblemsTabView(isEnglish: _isEnglish),
          KWayMergeMistakesTabView(isEnglish: _isEnglish),
        ],
      ),
    );
  }
}
