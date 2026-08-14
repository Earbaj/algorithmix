import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';

class RemoveDuplicatesSolutionCodeTab extends StatefulWidget {
  final bool isEnglish;

  const RemoveDuplicatesSolutionCodeTab({
    super.key,
    required this.isEnglish,
  });

  @override
  State<RemoveDuplicatesSolutionCodeTab> createState() => _RemoveDuplicatesSolutionCodeTabState();
}

class _RemoveDuplicatesSolutionCodeTabState extends State<RemoveDuplicatesSolutionCodeTab> {
  List<int> _currentNodes = [1, 1, 2, 3, 3];
  int _currIdx = 0;
  bool _showAnswer = false;
  String _userFeedbackEn = "Advance pointer or bypass duplicate node!";
  String _userFeedbackBn = "পয়েন্টার অগ্রসর করুন অথবা ডুপ্লিকেট নোড রিমুভ করুন!";
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
      if (_currIdx < _currentNodes.length - 1) {
        if (_currentNodes[_currIdx] == _currentNodes[_currIdx + 1]) {
          int dup = _currentNodes.removeAt(_currIdx + 1);
          _userFeedbackEn = "Bypassed duplicate node with value $dup!";
          _userFeedbackBn = "মান $dup এর ডুপ্লিকেট নোড বাইপাস করা হলো!";
        } else {
          _currIdx++;
          _userFeedbackEn = "Advanced curr pointer to idx $_currIdx (val: ${_currentNodes[_currIdx]})";
          _userFeedbackBn = "curr পয়েন্টার ইনডেক্স $_currIdx এ সামনে নেয়া হলো (মান: ${_currentNodes[_currIdx]})";
        }

        if (_currIdx >= _currentNodes.length - 1) {
          _userSolved = true;
          _userFeedbackEn = "🎉 PERFECT! All duplicates removed: $_currentNodes";
          _userFeedbackBn = "🎉 দারুণ! সকল ডুপ্লিকেট রিমুভ সম্পন্ন: $_currentNodes";
        }
      } else {
        _userSolved = true;
        _userFeedbackEn = "🎉 All duplicates removed: $_currentNodes";
        _userFeedbackBn = "🎉 সকল ডুপ্লিকেট রিমুভ সম্পন্ন: $_currentNodes";
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
                      Text(widget.isEnglish ? '🎮 Practice Mode: Remove Duplicates Yourself!' : '🎮 প্র্যাকটিস মোড: নিজে ডুপ্লিকেট রিমুভ করুন!', style: TextStyle(fontSize: Responsive.sp(context, 16), fontWeight: FontWeight.bold, color: Colors.white)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(widget.isEnglish ? 'Current List: $_currentNodes' : 'বর্তমান লিঙ্কড লিস্ট: $_currentNodes', style: TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: Responsive.sp(context, 13))),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      ElevatedButton.icon(
                        onPressed: _userSolved ? null : _handleUserMove,
                        icon: Icon(Icons.arrow_forward, size: Responsive.sp(context, 16)),
                        label: Text(widget.isEnglish ? 'Advance / Bypass Step' : 'পয়েন্টার অগ্রসর / বাইপাস ধাপ', style: TextStyle(fontSize: Responsive.sp(context, 13))),
                        style: ElevatedButton.styleFrom(backgroundColor: AppTheme.accentPurple),
                      ),
                      OutlinedButton.icon(
                        onPressed: () {
                          setState(() {
                            _currentNodes = [1, 1, 2, 3, 3];
                            _currIdx = 0;
                            _userSolved = false;
                            _userFeedbackEn = "Reset done! Try removing duplicates.";
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
    ListNode* deleteDuplicates(ListNode* head) {
        ListNode* curr = head;
        
        while (curr != nullptr && curr->next != nullptr) {
            if (curr->val == curr->next->val) {
                curr->next = curr->next->next; // Bypass duplicate node
            } else {
                curr = curr->next;             // Advance pointer
            }
        }
        return head;
    }
};""";
    } else if (lang == "Java") {
      code = """
class Solution {
    public ListNode deleteDuplicates(ListNode head) {
        ListNode curr = head;
        
        while (curr != null && curr.next != null) {
            if (curr.val == curr.next.val) {
                curr.next = curr.next.next;
            } else {
                curr = curr.next;
            }
        }
        return head;
    }
}""";
    } else if (lang == "Python") {
      code = """
class Solution:
    def deleteDuplicates(self, head: Optional[ListNode]) -> Optional[ListNode]:
        curr = head
        
        while curr and curr.next:
            if curr.val == curr.next.val:
                curr.next = curr.next.next
            else:
                curr = curr.next
                
        return head""";
    } else {
      code = """
ListNode? deleteDuplicates(ListNode? head) {
  ListNode? curr = head;
  
  while (curr != null && curr.next != null) {
    if (curr.val == curr.next!.val) {
      curr.next = curr.next!.next;
    } else {
      curr = curr.next;
    }
  }
  return head;
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
