import 'package:flutter/material.dart';
import 'package:algorithmix/data/repositories/pattern_repository.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';
import 'package:algorithmix/ui/features/core_patterns/views/core_patterns_screen.dart';
import 'package:algorithmix/ui/features/core_patterns/widgets/pattern_detail_modal.dart';
import 'package:algorithmix/ui/features/algorithms/views/algorithms_screen.dart';
import 'package:algorithmix/ui/features/dsa/views/dsa_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      _DashboardHomeView(
        onSelectTab: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      const CorePatternsScreen(),
      const AlgorithmsScreen(),
      const DsaScreen(),
    ];

    return Scaffold(
      backgroundColor: AppTheme.primaryDark,
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        backgroundColor: AppTheme.surfaceDark,
        selectedItemColor: AppTheme.accentNeonCyan,
        unselectedItemColor: AppTheme.textMuted,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            activeIcon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.grid_view_outlined),
            activeIcon: Icon(Icons.grid_view_rounded),
            label: 'Core Patterns',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.code_outlined),
            activeIcon: Icon(Icons.code),
            label: 'Algorithms',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.dataset_outlined),
            activeIcon: Icon(Icons.dataset),
            label: 'DSA',
          ),
        ],
      ),
    );
  }
}

class _DashboardHomeView extends StatelessWidget {
  final ValueChanged<int> onSelectTab;

  const _DashboardHomeView({required this.onSelectTab});

  @override
  Widget build(BuildContext context) {
    final patterns = PatternRepository.getCorePatterns();
    final dpPattern = patterns.firstWhere((p) => p.id == 18);
    final hPadding = Responsive.horizontalPadding(context);
    final vPadding = Responsive.verticalPadding(context);
    final isMobile = Responsive.isMobile(context);

    return SafeArea(
      child: ResponsiveCenter(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: hPadding, vertical: vPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome Back, Developer 👋',
                        style: TextStyle(
                          fontSize: Responsive.sp(context, 20),
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Master patterns to solve any DSA problem.',
                        style: TextStyle(
                          fontSize: Responsive.sp(context, 13),
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppTheme.accentPurple.withOpacity(0.2),
                      shape: BoxShape.circle,
                      border: Border.all(color: AppTheme.accentPurple),
                    ),
                    child: const Icon(Icons.person, color: Colors.white, size: 24),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Progress Banner
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(isMobile ? 20 : 28),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF6366F1).withOpacity(0.4),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            'FEATURED ROADMAP',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const Icon(Icons.stars, color: Colors.amber, size: 24),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '25 Core Patterns Mastery',
                      style: TextStyle(
                        fontSize: Responsive.sp(context, 22),
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Learn the top 25 coding patterns used by Big Tech interviewers.',
                      style: TextStyle(
                        fontSize: Responsive.sp(context, 13),
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Icon(Icons.check_circle_outline, color: Colors.white, size: 16),
                        const SizedBox(width: 6),
                        Text(
                          '25 Interactive Cards Available',
                          style: TextStyle(
                            fontSize: Responsive.sp(context, 12),
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // Daily Spotlight Card (DP)
              Text(
                '⭐ Most Important Pattern',
                style: TextStyle(
                  fontSize: Responsive.sp(context, 18),
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () {
                  PatternDetailModal.show(context, dpPattern);
                },
                child: Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceDark,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppTheme.accentPink, width: 1.5),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppTheme.accentPink.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(Icons.stars, color: AppTheme.accentPink, size: 32),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Dynamic Programming (DP)',
                              style: TextStyle(
                                fontSize: Responsive.sp(context, 16),
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              dpPattern.description,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: Responsive.sp(context, 12),
                                color: AppTheme.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.arrow_forward_ios_rounded, color: AppTheme.textMuted, size: 16),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 28),

              // Explore Categories Title
              Text(
                'Explore Topics',
                style: TextStyle(
                  fontSize: Responsive.sp(context, 18),
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 14),

              // Responsive Action Cards
              if (isMobile) ...[
                _buildCategoryCard(
                  context,
                  title: '25 Core Patterns',
                  subtitle: 'Two Pointers, Sliding Window, DP, Trees & Graphs',
                  countText: '25 Cards',
                  icon: Icons.grid_view_rounded,
                  color: AppTheme.accentPurple,
                  onTap: () => onSelectTab(1),
                ),
                const SizedBox(height: 14),
                _buildCategoryCard(
                  context,
                  title: 'Algorithms Catalog',
                  subtitle: 'Sorting, Searching, Shortest Path, KMP',
                  countText: '4 Categories',
                  icon: Icons.code_rounded,
                  color: AppTheme.accentNeonCyan,
                  onTap: () => onSelectTab(2),
                ),
                const SizedBox(height: 14),
                _buildCategoryCard(
                  context,
                  title: 'Data Structures (DSA)',
                  subtitle: 'Arrays, Linked Lists, Trees, Heaps, Graphs',
                  countText: '4 Types',
                  icon: Icons.dataset_rounded,
                  color: AppTheme.accentGreen,
                  onTap: () => onSelectTab(3),
                ),
              ] else ...[
                // Grid layout for Tablet / Desktop
                Row(
                  children: [
                    Expanded(
                      child: _buildCategoryCard(
                        context,
                        title: '25 Core Patterns',
                        subtitle: 'Two Pointers, Sliding Window, DP, Trees & Graphs',
                        countText: '25 Cards',
                        icon: Icons.grid_view_rounded,
                        color: AppTheme.accentPurple,
                        onTap: () => onSelectTab(1),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: _buildCategoryCard(
                        context,
                        title: 'Algorithms Catalog',
                        subtitle: 'Sorting, Searching, Shortest Path, KMP',
                        countText: '4 Categories',
                        icon: Icons.code_rounded,
                        color: AppTheme.accentNeonCyan,
                        onTap: () => onSelectTab(2),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: _buildCategoryCard(
                        context,
                        title: 'Data Structures (DSA)',
                        subtitle: 'Arrays, Linked Lists, Trees, Heaps, Graphs',
                        countText: '4 Types',
                        icon: Icons.dataset_rounded,
                        color: AppTheme.accentGreen,
                        onTap: () => onSelectTab(3),
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required String countText,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFF334155)),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(icon, color: color, size: 28),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              title,
                              style: TextStyle(
                                fontSize: Responsive.sp(context, 16),
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: color.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              countText,
                              style: TextStyle(
                                fontSize: Responsive.sp(context, 11),
                                fontWeight: FontWeight.bold,
                                color: color,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: Responsive.sp(context, 12),
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
