import 'package:flutter/material.dart';
import 'package:algorithmix/data/repositories/pattern_repository.dart';
import 'package:algorithmix/domain/models/algorithm_model.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';

class AlgorithmsScreen extends StatefulWidget {
  const AlgorithmsScreen({super.key});

  @override
  State<AlgorithmsScreen> createState() => _AlgorithmsScreenState();
}

class _AlgorithmsScreenState extends State<AlgorithmsScreen> {
  final List<AlgorithmModel> _algorithms = PatternRepository.getAlgorithms();

  void _showAlgorithmDetail(AlgorithmModel algo) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.surfaceDark,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(algo.icon, color: algo.color, size: 32),
                      const SizedBox(width: 12),
                      Text(
                        algo.title,
                        style: TextStyle(
                          fontSize: Responsive.sp(context, 20),
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryDark,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Category:', style: TextStyle(color: AppTheme.textSecondary)),
                        Text(algo.category, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        const Text('Complexity:', style: TextStyle(color: AppTheme.textSecondary)),
                        Text(algo.complexity, style: TextStyle(color: algo.color, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    algo.description,
                    style: TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: Responsive.sp(context, 14),
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Close'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final hPadding = Responsive.horizontalPadding(context);

    return Scaffold(
      backgroundColor: AppTheme.primaryDark,
      appBar: AppBar(
        title: const Text('Algorithms Catalog'),
        centerTitle: true,
      ),
      body: ResponsiveCenter(
        padding: EdgeInsets.symmetric(horizontal: hPadding, vertical: 16),
        child: isMobile
            ? ListView.builder(
                itemCount: _algorithms.length,
                itemBuilder: (context, index) => _buildAlgoTile(_algorithms[index]),
              )
            : GridView.builder(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 480,
                  mainAxisExtent: 110,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: _algorithms.length,
                itemBuilder: (context, index) => _buildAlgoTile(_algorithms[index]),
              ),
      ),
    );
  }

  Widget _buildAlgoTile(AlgorithmModel algo) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: algo.color.withOpacity(0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(algo.icon, color: algo.color, size: 28),
        ),
        title: Text(
          algo.title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: Responsive.sp(context, 16),
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Text(
            '${algo.category} • ${algo.complexity}',
            style: TextStyle(
              color: algo.color,
              fontSize: Responsive.sp(context, 12),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        trailing: const Icon(Icons.chevron_right, color: AppTheme.textMuted),
        onTap: () => _showAlgorithmDetail(algo),
      ),
    );
  }
}
