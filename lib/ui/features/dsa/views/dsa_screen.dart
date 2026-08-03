import 'package:flutter/material.dart';
import 'package:algorithmix/data/repositories/pattern_repository.dart';
import 'package:algorithmix/domain/models/dsa_model.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';

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
        return Padding(
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
                    style: const TextStyle(
                      fontSize: 20,
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
                style: const TextStyle(color: AppTheme.textPrimary, fontSize: 14, height: 1.4),
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
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryDark,
      appBar: AppBar(
        title: const Text('Data Structures (DSA)'),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _dsaList.length,
        itemBuilder: (context, index) {
          final dsa = _dsaList[index];
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
                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(
                  dsa.timeComplexity,
                  style: TextStyle(color: dsa.color, fontSize: 12, fontWeight: FontWeight.w600),
                ),
              ),
              trailing: const Icon(Icons.chevron_right, color: AppTheme.textMuted),
              onTap: () => _showDsaDetail(dsa),
            ),
          );
        },
      ),
    );
  }
}
