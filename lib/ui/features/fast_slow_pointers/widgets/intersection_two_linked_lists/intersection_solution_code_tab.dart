import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';

class IntersectionSolutionCodeTab extends StatefulWidget {
  final bool isEnglish;

  const IntersectionSolutionCodeTab({
    super.key,
    required this.isEnglish,
  });

  @override
  State<IntersectionSolutionCodeTab> createState() => _IntersectionSolutionCodeTabState();
}

class _IntersectionSolutionCodeTabState extends State<IntersectionSolutionCodeTab> {
  int _userStep = 0;
  bool _showAnswer = false;
  String _userFeedbackEn = "pA is at headA [4], pB is at headB [5]. Step 1: Advance pointers!";
  String _userFeedbackBn = "pA নোড [৪] এ এবং pB নোড [৫] এ। ধাপ ১: পয়েন্টার সামনে নিন!";
  bool _userSolved = false;
  String _selectedCodeLang = "C++";

  void _copyToClipboard(String text, String label) {
    Clipboard.setData(ClipboardData(text: text.trim()));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Text(
              widget.isEnglish ? '$label copied to clipboard!' : '$label কোড কপি হয়েছে!',
              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ],
        ),
        backgroundColor: AppTheme.accentGreen,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _handleUserMove() {
    if (_userSolved) return;

    setState(() {
      if (_userStep == 0) {
        _userStep = 1;
        _userFeedbackEn = "pA hit end -> switched to headB [5]. pB is at [6]. Step 2: Continue!";
        _userFeedbackBn = "pA শেষে পৌঁছায় headB [৫] এ সুইসড। pB নোড [৬] এ। ধাপ ২: চালিয় যান!";
      } else if (_userStep == 1) {
        _userStep = 2;
        _userFeedbackEn = "pB hit end -> switched to headA [4]. Step 3: Advance to collision!";
        _userFeedbackBn = "pB শেষে পৌঁছায় headA [৪] এ সুইসড। ধাপ ৩: মিলন বিন্দুতে অগ্রসর হন!";
      } else if (_userStep == 2) {
        _userStep = 3;
        _userSolved = true;
        _userFeedbackEn = "🎉 PERFECT! pA == pB at Intersection Node [8]!";
        _userFeedbackBn = "🎉 দারুণ! pA == pB একই নোড [৮] এ এসে মিলিত হয়েছে!";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final hPadding = Responsive.horizontalPadding(context);

    return ResponsiveCenter(
      maxWidth: 1280.0,
      padding: EdgeInsets.all(hPadding),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(Responsive.sp(context, 18)),
              decoration: BoxDecoration(
                color: AppTheme.surfaceDark,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: _userSolved ? AppTheme.accentGreen : AppTheme.accentAmber),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(_userSolved ? Icons.check_circle : Icons.extension_outlined, color: _userSolved ? AppTheme.accentGreen : AppTheme.accentAmber, size: Responsive.sp(context, 24)),
                      const SizedBox(width: 8),
                      Text(widget.isEnglish ? '🎮 Practice Mode: Find Intersection Yourself!' : '🎮 প্র্যাকটিস মোড: নিজে ইন্টারসেকশন খুঁজুন!', style: TextStyle(fontSize: Responsive.sp(context, 16), fontWeight: FontWeight.bold, color: Colors.white)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(widget.isEnglish ? 'List A: [4, 1, 8, 4, 5], List B: [5, 6, 1, 8, 4, 5]' : 'লিস্ট A: [4, 1, 8, 4, 5], লিস্ট B: [5, 6, 1, 8, 4, 5]', style: TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: Responsive.sp(context, 13))),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      ElevatedButton.icon(
                        onPressed: _userSolved ? null : _handleUserMove,
                        icon: Icon(Icons.arrow_forward, size: Responsive.sp(context, 16)),
                        label: Text(widget.isEnglish ? 'Advance / Switch Pointers' : 'পয়েন্টার অগ্রসর / সুইচ করুন', style: TextStyle(fontSize: Responsive.sp(context, 13))),
                        style: ElevatedButton.styleFrom(backgroundColor: AppTheme.accentPurple),
                      ),
                      OutlinedButton.icon(
                        onPressed: () {
                          setState(() {
                            _userStep = 0;
                            _userSolved = false;
                            _userFeedbackEn = "Reset done! Try finding intersection.";
                            _userFeedbackBn = "রিসেট করা হয়েছে!";
                          });
                        },
                        icon: Icon(Icons.refresh, size: Responsive.sp(context, 16), color: Colors.white),
                        label: Text(widget.isEnglish ? 'Reset' : 'রিসেট', style: TextStyle(fontSize: Responsive.sp(context, 13))),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: _userSolved ? AppTheme.accentGreen.withOpacity(0.15) : AppTheme.primaryDark,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: _userSolved ? AppTheme.accentGreen : const Color(0xFF334155)),
                    ),
                    child: Text(widget.isEnglish ? _userFeedbackEn : _userFeedbackBn, style: TextStyle(color: _userSolved ? AppTheme.accentGreen : AppTheme.textSecondary, fontWeight: FontWeight.w600, fontSize: Responsive.sp(context, 13))),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            Container(
              padding: EdgeInsets.all(Responsive.sp(context, 18)),
              decoration: BoxDecoration(
                color: AppTheme.surfaceDark,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.accentPink.withOpacity(0.5)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(widget.isEnglish ? "Multi-Language Solution Code" : "বহুভাষী সমাধান কোড", style: TextStyle(fontSize: Responsive.sp(context, 16), fontWeight: FontWeight.bold, color: Colors.white)),
                            const SizedBox(height: 4),
                            Text(widget.isEnglish ? "Official optimal solution in C++, Java, Python & JavaScript." : "C++, Java, Python এবং JavaScript ভাষায় সলিউশন।", style: TextStyle(color: AppTheme.textSecondary, fontSize: Responsive.sp(context, 12))),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () => setState(() => _showAnswer = !_showAnswer),
                        style: ElevatedButton.styleFrom(backgroundColor: _showAnswer ? AppTheme.accentGreen : AppTheme.accentPink),
                        child: Text(_showAnswer ? (widget.isEnglish ? "Hide Code" : "কোড লুকান") : (widget.isEnglish ? "Reveal Solution Code" : "কোড দেখুন"), style: TextStyle(fontSize: Responsive.sp(context, 13), fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                  if (_showAnswer) ...[
                    const Divider(height: 28, color: Color(0xFF334155)),
                    Row(
                      children: ["C++", "Java", "Python", "JavaScript"].map((lang) {
                        final isSel = _selectedCodeLang == lang;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ChoiceChip(
                            label: Text(lang, style: TextStyle(fontSize: Responsive.sp(context, 12))),
                            selected: isSel,
                            selectedColor: AppTheme.accentPurple,
                            backgroundColor: AppTheme.primaryDark,
                            labelStyle: TextStyle(color: isSel ? Colors.white : AppTheme.textSecondary, fontWeight: isSel ? FontWeight.bold : FontWeight.normal),
                            onSelected: (val) {
                              if (val) setState(() { _selectedCodeLang = lang; });
                            },
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 14),
                    _buildFullCodeSnippet(_selectedCodeLang),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildFullCodeSnippet(String lang) {
    String code = "";
    if (lang == "C++") {
      code = """
class Solution {
public:
    ListNode *getIntersectionNode(ListNode *headA, ListNode *headB) {
        if (!headA || !headB) return nullptr;
        
        ListNode *pA = headA;
        ListNode *pB = headB;
        
        while (pA != pB) {
            pA = (pA == nullptr) ? headB : pA->next;
            pB = (pB == nullptr) ? headA : pB->next;
        }
        
        return pA;
    }
};""";
    } else if (lang == "Java") {
      code = """
public class Solution {
    public ListNode getIntersectionNode(ListNode headA, ListNode headB) {
        if (headA == null || headB == null) return null;
        
        ListNode pA = headA;
        ListNode pB = headB;
        
        while (pA != pB) {
            pA = (pA == null) ? headB : pA.next;
            pB = (pB == null) ? headA : pB.next;
        }
        
        return pA;
    }
}""";
    } else if (lang == "Python") {
      code = """
class Solution:
    def getIntersectionNode(self, headA: ListNode, headB: ListNode) -> Optional[ListNode]:
        if not headA or not headB:
            return None
            
        pA, pB = headA, headB
        
        while pA != pB:
            pA = headB if pA is None else pA.next
            pB = headA if pB is None else pB.next
            
        return pA""";
    } else {
      code = """
ListNode? getIntersectionNode(ListNode? headA, ListNode? headB) {
  if (headA == null || headB == null) return null;

  ListNode? pA = headA;
  ListNode? pB = headB;

  while (pA != pB) {
    pA = (pA == null) ? headB : pA.next;
    pB = (pB == null) ? headA : pB.next;
  }

  return pA;
}""";
    }

    return Container(
      padding: EdgeInsets.all(Responsive.sp(context, 14)),
      decoration: BoxDecoration(color: const Color(0xFF090D16), borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFF1E293B))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("$lang Solution Code", style: TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: Responsive.sp(context, 13))),
              ElevatedButton.icon(
                onPressed: () => _copyToClipboard(code, "$lang Solution"),
                icon: Icon(Icons.copy_all, size: Responsive.sp(context, 14)),
                label: Text(widget.isEnglish ? "Copy Code" : "কোড কপি করুন", style: TextStyle(fontSize: Responsive.sp(context, 12), fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(backgroundColor: AppTheme.accentPurple),
              ),
            ],
          ),
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Text(code.trim(), style: TextStyle(fontFamily: 'monospace', fontSize: Responsive.sp(context, 12.5), color: const Color(0xFF38BDF8), height: 1.4)),
          ),
        ],
      ),
    );
  }
}
