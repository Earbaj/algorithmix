import 'package:flutter/material.dart';
import 'package:algorithmix/data/repositories/pattern_repository.dart';
import 'package:algorithmix/domain/models/dsa_model.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';

class DsaScreen extends StatefulWidget {
  const DsaScreen({super.key});

  @override
  State<DsaScreen> createState() => _DsaScreenState();
}

class _DsaScreenState extends State<DsaScreen> {
  final List<DsaModel> _dsaList = PatternRepository.getDsaItems();

  void _showDsaDetail(DsaModel dsa) {
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
                      Icon(dsa.icon, color: dsa.color, size: 32),
                      const SizedBox(width: 12),
                      Text(
                        dsa.title,
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Category: ${dsa.category}', style: const TextStyle(color: AppTheme.textSecondary)),
                        const SizedBox(height: 4),
                        Text('Time Complexity: ${dsa.timeComplexity}', style: TextStyle(color: dsa.color, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    dsa.description,
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
        title: const Text('Data Structures (DSA)'),
        centerTitle: true,
      ),
      body: ResponsiveCenter(
        padding: EdgeInsets.symmetric(horizontal: hPadding, vertical: 16),
        child: isMobile
            ? ListView.builder(
                itemCount: _dsaList.length,
                itemBuilder: (context, index) => _buildDsaTile(_dsaList[index]),
              )
            : GridView.builder(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 480,
                  mainAxisExtent: 110,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: _dsaList.length,
                itemBuilder: (context, index) => _buildDsaTile(_dsaList[index]),
              ),
      ),
    );
  }

  Widget _buildDsaTile(DsaModel dsa) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: dsa.color.withOpacity(0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(dsa.icon, color: dsa.color, size: 28),
        ),
        title: Text(
          dsa.title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: Responsive.sp(context, 16),
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Text(
            dsa.timeComplexity,
            style: TextStyle(
              color: dsa.color,
              fontSize: Responsive.sp(context, 12),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        trailing: const Icon(Icons.chevron_right, color: AppTheme.textMuted),
        onTap: () => _showDsaDetail(dsa),
      ),
    );
  }
}
