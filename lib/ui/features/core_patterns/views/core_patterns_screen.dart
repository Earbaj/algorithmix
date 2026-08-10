import 'package:flutter/material.dart';
import 'package:algorithmix/data/repositories/pattern_repository.dart';
import 'package:algorithmix/domain/models/pattern_model.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'package:algorithmix/ui/core/navigation/app_routes.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';
import 'package:algorithmix/ui/features/core_patterns/widgets/pattern_card.dart';
import 'package:algorithmix/ui/features/core_patterns/widgets/pattern_detail_modal.dart';

class CorePatternsScreen extends StatefulWidget {
  const CorePatternsScreen({super.key});

  @override
  State<CorePatternsScreen> createState() => _CorePatternsScreenState();
}

class _CorePatternsScreenState extends State<CorePatternsScreen> {
  final List<PatternModel> _allPatterns = PatternRepository.getCorePatterns();
  List<PatternModel> _filteredPatterns = [];
  String _searchQuery = "";
  String _selectedCategory = "All";

  @override
  void initState() {
    super.initState();
    _filteredPatterns = _allPatterns;
  }

  void _filterPatterns() {
    setState(() {
      _filteredPatterns = _allPatterns.where((pattern) {
        final matchesQuery = pattern.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            pattern.description.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            pattern.category.toLowerCase().contains(_searchQuery.toLowerCase());

        if (_selectedCategory == "All") return matchesQuery;
        if (_selectedCategory == "Easy") {
          return matchesQuery && pattern.difficulty == PatternDifficulty.beginner;
        }
        if (_selectedCategory == "Medium") {
          return matchesQuery && pattern.difficulty == PatternDifficulty.intermediate;
        }
        if (_selectedCategory == "Hard") {
          return matchesQuery && pattern.difficulty == PatternDifficulty.advanced;
        }
        if (_selectedCategory == "⭐ Hot") {
          return matchesQuery && pattern.isHot;
        }
        return matchesQuery;
      }).toList();
    });
  }

  void _handlePatternTap(PatternModel pattern) {
    if (pattern.id == 1) {
      // Time & Space Complexity dedicated screen
      Navigator.of(context).pushNamed(AppRoutes.timeSpaceComplexityDetail);
    } else if (pattern.id == 2) {
      // Basic Data Structures dedicated screen (NEW PAGE)
      Navigator.of(context).pushNamed(AppRoutes.dsa);
    } else if (pattern.id == 3) {
      // Recursion & Backtracking dedicated screen
      Navigator.of(context).pushNamed(AppRoutes.recursionBacktrackingDetail);
    } else if (pattern.id == 4) {
      // Two Pointers dedicated screen
      Navigator.of(context).pushNamed(AppRoutes.twoPointersDetail);
    } else if (pattern.id == 5) {
      // Sliding Window dedicated screen
      Navigator.of(context).pushNamed(AppRoutes.slidingWindowDetail);
    } else if (pattern.id == 6) {
      // Fast & Slow Pointers dedicated screen
      Navigator.of(context).pushNamed(AppRoutes.fastSlowPointersDetail);
    } else if (pattern.id == 7) {
      // Merge Intervals dedicated screen
      Navigator.of(context).pushNamed(AppRoutes.mergeIntervalsDetail);
    } else if (pattern.id == 8) {
      // Cyclic Sort dedicated screen
      Navigator.of(context).pushNamed(AppRoutes.cyclicSortDetail);
    } else if (pattern.id == 9) {
      // In-place Reversal of Linked List dedicated screen
      Navigator.of(context).pushNamed(AppRoutes.inplaceReversalDetail);
    } else {
      PatternDetailModal.show(context, pattern);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final hPadding = Responsive.horizontalPadding(context);

    return Scaffold(
      backgroundColor: AppTheme.primaryDark,
      appBar: AppBar(
        title: const Text('25 Core Patterns'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Search & Filter Box
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: AppTheme.surfaceDark,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
            ),
            child: ResponsiveCenter(
              padding: EdgeInsets.all(hPadding < 20 ? 16 : hPadding),
              child: Column(
                children: [
                  // Search Input
                  TextField(
                    onChanged: (val) {
                      _searchQuery = val;
                      _filterPatterns();
                    },
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      hintText: 'Search patterns (e.g. Dynamic Programming, Sliding Window)...',
                      prefixIcon: Icon(Icons.search, color: AppTheme.accentNeonCyan),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Category Chips
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: ["All", "Easy", "Medium", "Hard", "⭐ Hot"].map((category) {
                        final isSelected = _selectedCategory == category;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: FilterChip(
                            label: Text(category),
                            selected: isSelected,
                            selectedColor: AppTheme.accentPurple,
                            backgroundColor: AppTheme.primaryDark,
                            labelStyle: TextStyle(
                              color: isSelected ? Colors.white : AppTheme.textSecondary,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            ),
                            onSelected: (selected) {
                              setState(() {
                                _selectedCategory = category;
                                _filterPatterns();
                              });
                            },
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Count summary
          ResponsiveCenter(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Showing ${_filteredPatterns.length} of ${_allPatterns.length} Patterns',
                  style: TextStyle(
                    fontSize: Responsive.sp(context, 13),
                    color: AppTheme.textMuted,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Icon(Icons.tune_outlined, size: 18, color: AppTheme.textMuted),
              ],
            ),
          ),

          // Pattern List / Grid
          Expanded(
            child: ResponsiveCenter(
              padding: EdgeInsets.symmetric(horizontal: hPadding, vertical: 8),
              child: isMobile
                  ? ListView.builder(
                      itemCount: _filteredPatterns.length,
                      itemBuilder: (context, index) {
                        final pattern = _filteredPatterns[index];
                        return PatternCard(
                          pattern: pattern,
                          onTap: () => _handlePatternTap(pattern),
                        );
                      },
                    )
                  : GridView.builder(
                      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 480,
                        mainAxisExtent: 220,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                      ),
                      itemCount: _filteredPatterns.length,
                      itemBuilder: (context, index) {
                        final pattern = _filteredPatterns[index];
                        return PatternCard(
                          pattern: pattern,
                          onTap: () => _handlePatternTap(pattern),
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
