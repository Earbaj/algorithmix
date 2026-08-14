import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';

class CycleSolutionCodeTab extends StatefulWidget {
  final bool isEnglish;

  const CycleSolutionCodeTab({
    super.key,
    required this.isEnglish,
  });

  @override
  State<CycleSolutionCodeTab> createState() => _CycleSolutionCodeTabState();
}

class _CycleSolutionCodeTabState extends State<CycleSolutionCodeTab> {
  final List<int> _currentNodes = [3, 2, 0, -4];
  final int _cyclePos = 1;

  bool _showAnswer = false;
  int _userSlow = 0;
  int _userFast = 0;
  String _userFeedbackEn = "Advance pointers: Slow moves 1 step, Fast moves 2 steps!";
  String _userFeedbackBn = "পয়েন্টার অগ্রসর করুন: Slow ১ ধাপ, Fast ২ ধাপ যাবে!";
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
    int n = _currentNodes.length;

    setState(() {
      if (_cyclePos >= 0 && _userSlow >= _cyclePos) {
        _userSlow = (_userSlow + 1 >= n) ? _cyclePos : _userSlow + 1;
      } else {
        _userSlow++;
      }

      if (_cyclePos >= 0) {
        int step1 = (_userFast + 1 >= n) ? _cyclePos : _userFast + 1;
        _userFast = (step1 + 1 >= n) ? _cyclePos : step1 + 1;
      } else {
        _userFast += 2;
      }

      if (_cyclePos >= 0 && _userSlow == _userFast) {
        _userSolved = true;
        _userFeedbackEn = "🎉 CONGRATULATIONS! Pointers collided at index $_userSlow (val: ${_currentNodes[_userSlow % n]})! Cycle detected!";
        _userFeedbackBn = "🎉 অভিনন্দন! পয়েন্টারদ্বয় ইনডেক্স $_userSlow এ মিলিত হয়েছে! সাইকেল ডিটেকশন নিশ্চিত!";
      } else if (_cyclePos < 0 && _userFast >= n) {
        _userSolved = true;
        _userFeedbackEn = "✅ Fast reached end of list without cycle! Return false.";
        _userFeedbackBn = "✅ Fast লিঙ্কড লিস্টের শেষ মাথায় নাল পেয়েছে! কোনো সাইকেল নেই।";
      } else {
        _userFeedbackEn = "Step done: Slow is at index $_userSlow, Fast is at index $_userFast. Keep moving!";
        _userFeedbackBn = "ধাপ সম্পন্ন: Slow ইনডেক্স $_userSlow এ, Fast ইনডেক্স $_userFast এ। পয়েন্টার চালান!";
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
                      Text(widget.isEnglish ? '🎮 Practice Mode: Move Pointers Yourself!' : '🎮 প্র্যাকটিস মোড: নিজে পয়েন্টার চালান!', style: TextStyle(fontSize: Responsive.sp(context, 16), fontWeight: FontWeight.bold, color: Colors.white)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(widget.isEnglish ? 'Current List: $_currentNodes | Cycle Pos: $_cyclePos' : 'বর্তমান লিস্ট: $_currentNodes | সাইকেল ইনডেক্স: $_cyclePos', style: TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: Responsive.sp(context, 13))),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      ElevatedButton.icon(
                        onPressed: _userSolved ? null : _handleUserMove,
                        icon: Icon(Icons.arrow_forward, size: Responsive.sp(context, 16)),
                        label: Text(widget.isEnglish ? 'Advance Pointers (Slow +1, Fast +2)' : 'পয়েন্টার অগ্রসর করুন (Slow +১, Fast +২)', style: TextStyle(fontSize: Responsive.sp(context, 13))),
                        style: ElevatedButton.styleFrom(backgroundColor: AppTheme.accentPurple),
                      ),
                      OutlinedButton.icon(
                        onPressed: () {
                          setState(() {
                            _userSlow = 0;
                            _userFast = 0;
                            _userSolved = false;
                            _userFeedbackEn = "Reset done! Try moving pointers.";
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
    bool hasCycle(ListNode *head) {
        if (!head || !head->next) return false;
        
        ListNode *slow = head;
        ListNode *fast = head;
        
        while (fast != nullptr && fast->next != nullptr) {
            slow = slow->next;          // Move 1 step
            fast = fast->next->next;    // Move 2 steps
            
            if (slow == fast) {
                return true; // Collision detected -> Cycle exists
            }
        }
        return false; // Fast reached NULL -> No cycle
    }
};""";
    } else if (lang == "Java") {
      code = """
public class Solution {
    public boolean hasCycle(ListNode head) {
        if (head == null || head.next == null) return false;
        
        ListNode slow = head;
        ListNode fast = head;
        
        while (fast != null && fast.next != null) {
            slow = slow.next;
            fast = fast.next.next;
            
            if (slow == fast) {
                return true;
            }
        }
        return false;
    }
}""";
    } else if (lang == "Python") {
      code = """
class Solution:
    def hasCycle(self, head: Optional[ListNode]) -> bool:
        slow = head
        fast = head
        
        while fast and fast.next:
            slow = slow.next
            fast = fast.next.next
            
            if slow == fast:
                return True
        return False""";
    } else {
      code = """
bool hasCycle(ListNode? head) {
  if (head == null || head.next == null) return false;
  
  ListNode? slow = head;
  ListNode? fast = head;
  
  while (fast != null && fast.next != null) {
    slow = slow.next;
    fast = fast.next!.next;
    
    if (slow == fast) {
      return true;
    }
  }
  return false;
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
