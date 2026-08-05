import 'package:flutter/material.dart';
import 'package:algorithmix/domain/models/dsa_data.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';

class DsaProblemModal extends StatefulWidget {
  final DsaProblem problem;
  final bool isEnglish;

  const DsaProblemModal({
    super.key,
    required this.problem,
    required this.isEnglish,
  });

  static void show(BuildContext context, DsaProblem problem, bool isEnglish) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DsaProblemModal(problem: problem, isEnglish: isEnglish),
    );
  }

  @override
  State<DsaProblemModal> createState() => _DsaProblemModalState();
}

class _DsaProblemModalState extends State<DsaProblemModal> {
  String _selectedLanguage = "C++";

  String _getCodeForLanguage() {
    switch (_selectedLanguage) {
      case "C++":
        return widget.problem.codeCpp;
      case "Java":
        return widget.problem.codeJava;
      case "Python":
        return widget.problem.codePython;
      case "JavaScript":
        return widget.problem.codeJs;
      default:
        return widget.problem.codeCpp;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      maxChildSize: 0.95,
      minChildSize: 0.5,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: AppTheme.primaryDark,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              // Top Drag Handle
              Container(
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                width: 44,
                height: 5,
                decoration: BoxDecoration(
                  color: AppTheme.textMuted.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),

              // Modal Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppTheme.accentPurple.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppTheme.accentPurple),
                      ),
                      child: Text(
                        widget.problem.category,
                        style: const TextStyle(color: AppTheme.accentPurple, fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        widget.problem.title,
                        style: TextStyle(
                          fontSize: Responsive.sp(context, 17),
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: AppTheme.textSecondary),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),

              const Divider(color: Color(0xFF1E293B)),

              // Content Body
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Problem Description
                      Text(
                        widget.isEnglish ? "Problem Statement" : "সমস্যা বিবরণী",
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.isEnglish ? widget.problem.descriptionEn : widget.problem.descriptionBn,
                        style: const TextStyle(color: AppTheme.textSecondary, height: 1.4, fontSize: 14),
                      ),
                      const SizedBox(height: 16),

                      // Key Idea Box
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppTheme.accentNeonCyan.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppTheme.accentNeonCyan.withOpacity(0.4)),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.lightbulb_outline, color: AppTheme.accentNeonCyan, size: 20),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                widget.isEnglish ? widget.problem.keyIdeaEn : widget.problem.keyIdeaBn,
                                style: const TextStyle(color: Colors.white, fontSize: 13, height: 1.4, fontWeight: FontWeight.w500),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Sample Test Cases
                      Text(
                        widget.isEnglish ? "Sample Cases" : "স্যাম্পল টেস্ট কেস",
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      const SizedBox(height: 8),
                      ...List.generate(widget.problem.sampleInputs.length, (i) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFF090D16),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: const Color(0xFF1E293B)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Input: ${widget.problem.sampleInputs[i]}", style: const TextStyle(color: AppTheme.accentNeonCyan, fontSize: 12, fontFamily: 'monospace')),
                              const SizedBox(height: 4),
                              Text("Output: ${widget.problem.sampleOutputs[i]}", style: const TextStyle(color: AppTheme.accentGreen, fontSize: 12, fontFamily: 'monospace', fontWeight: FontWeight.bold)),
                            ],
                          ),
                        );
                      }),
                      const SizedBox(height: 20),

                      // Multi-language Solution Selector
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            widget.isEnglish ? "Solution Code" : "সমাধান কোড",
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                          DropdownButton<String>(
                            value: _selectedLanguage,
                            dropdownColor: AppTheme.surfaceDark,
                            style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold),
                            underline: Container(),
                            items: ["C++", "Java", "Python", "JavaScript"].map((lang) {
                              return DropdownMenuItem(value: lang, child: Text(lang));
                            }).toList(),
                            onChanged: (val) {
                              if (val != null) {
                                setState(() {
                                  _selectedLanguage = val;
                                });
                              }
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Code Display Box
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
                            _getCodeForLanguage(),
                            style: const TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 12,
                              color: Color(0xFF38BDF8),
                              height: 1.4,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
