import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';

class PalindromeSolutionCodeTab extends StatefulWidget {
  final bool isEnglish;

  const PalindromeSolutionCodeTab({
    super.key,
    required this.isEnglish,
  });

  @override
  State<PalindromeSolutionCodeTab> createState() => _PalindromeSolutionCodeTabState();
}

class _PalindromeSolutionCodeTabState extends State<PalindromeSolutionCodeTab> {
  final List<int> _currentNodes = [1, 2, 2, 1];
  int _p1Idx = 0;
  int _p2Idx = 3;
  bool _showAnswer = false;
  String _userFeedbackEn = "Compare p1 (head) and p2 (reversed 2nd half head)!";
  String _userFeedbackBn = "p1 (হেড) ও p2 (উল্টানো ২য় অর্ধাংশ হেড) এর মান তুলনা করুন!";
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
      if (_p1Idx < _p2Idx) {
        if (_currentNodes[_p1Idx] != _currentNodes[_p2Idx]) {
          _userSolved = true;
          _userFeedbackEn = "❌ Mismatch found! ${_currentNodes[_p1Idx]} != ${_currentNodes[_p2Idx]}. Not a palindrome!";
          _userFeedbackBn = "❌ অমিল পাওয়া গেছে! ${_currentNodes[_p1Idx]} != ${_currentNodes[_p2Idx]}। প্যালিনড্রোম নয়!";
        } else {
          _userFeedbackEn = "Matched: ${_currentNodes[_p1Idx]} == ${_currentNodes[_p2Idx]}. Moving p1 right, p2 left.";
          _userFeedbackBn = "মিলেছে: ${_currentNodes[_p1Idx]} == ${_currentNodes[_p2Idx]}। p1 ডানদিকে, p2 বামদিকে টানা হলো।";
          _p1Idx++;
          _p2Idx--;

          if (_p1Idx >= _p2Idx) {
            _userSolved = true;
            _userFeedbackEn = "🎉 PERFECT! All node pairs matched! Palindrome confirmed!";
            _userFeedbackBn = "🎉 দারুণ! সকল নোড জোড়া মিলে গেছে! প্যালিনড্রোম নিশ্চিত!";
          }
        }
      } else {
        _userSolved = true;
        _userFeedbackEn = "🎉 PERFECT! All node pairs matched! Palindrome confirmed!";
        _userFeedbackBn = "🎉 দারুণ! সকল নোড জোড়া মিলে গেছে! প্যালিনড্রোম নিশ্চিত!";
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
                      Text(widget.isEnglish ? '🎮 Practice Mode: Check Palindrome Yourself!' : '🎮 প্র্যাকটিস মোড: নিজে প্যালিনড্রোম চেক করুন!', style: TextStyle(fontSize: Responsive.sp(context, 16), fontWeight: FontWeight.bold, color: Colors.white)),
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
                        label: Text(widget.isEnglish ? 'Compare Next Node Pair' : 'পরের নোড জোড়া তুলনা করুন', style: TextStyle(fontSize: Responsive.sp(context, 13))),
                        style: ElevatedButton.styleFrom(backgroundColor: AppTheme.accentPurple),
                      ),
                      OutlinedButton.icon(
                        onPressed: () {
                          setState(() {
                            _p1Idx = 0;
                            _p2Idx = 3;
                            _userSolved = false;
                            _userFeedbackEn = "Reset done! Try checking palindrome.";
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
private:
    ListNode* reverseList(ListNode* head) {
        ListNode* prev = nullptr;
        ListNode* curr = head;
        while (curr != nullptr) {
            ListNode* nextTemp = curr->next;
            curr->next = prev;
            prev = curr;
            curr = nextTemp;
        }
        return prev;
    }

public:
    bool isPalindrome(ListNode* head) {
        if (!head || !head->next) return true;

        ListNode* slow = head;
        ListNode* fast = head;
        while (fast != nullptr && fast->next != nullptr) {
            slow = slow->next;
            fast = fast->next->next;
        }

        ListNode* p2 = reverseList(slow);
        ListNode* p1 = head;

        while (p2 != nullptr) {
            if (p1->val != p2->val) return false;
            p1 = p1->next;
            p2 = p2->next;
        }

        return true;
    }
};""";
    } else if (lang == "Java") {
      code = """
class Solution {
    private ListNode reverseList(ListNode head) {
        ListNode prev = null;
        ListNode curr = head;
        while (curr != null) {
            ListNode nextTemp = curr.next;
            curr.next = prev;
            prev = curr;
            curr = nextTemp;
        }
        return prev;
    }

    public boolean isPalindrome(ListNode head) {
        if (head == null || head.next == null) return true;

        ListNode slow = head;
        ListNode fast = head;
        while (fast != null && fast.next != null) {
            slow = slow.next;
            fast = fast.next.next;
        }

        ListNode p2 = reverseList(slow);
        ListNode p1 = head;

        while (p2 != null) {
            if (p1.val != p2.val) return false;
            p1 = p1.next;
            p2 = p2.next;
        }

        return true;
    }
}""";
    } else if (lang == "Python") {
      code = """
class Solution:
    def isPalindrome(self, head: Optional[ListNode]) -> bool:
        if not head or not head.next:
            return True

        slow = fast = head
        while fast and fast.next:
            slow = slow.next
            fast = fast.next.next

        prev = None
        curr = slow
        while curr:
            curr.next, prev, curr = prev, curr, curr.next

        p1, p2 = head, prev
        while p2:
            if p1.val != p2.val:
                return False
            p1, p2 = p1.next, p2.next

        return True""";
    } else {
      code = """
bool isPalindrome(ListNode? head) {
  if (head == null || head.next == null) return true;

  ListNode? slow = head;
  ListNode? fast = head;
  while (fast != null && fast.next != null) {
    slow = slow!.next;
    fast = fast.next!.next;
  }

  ListNode? prev = null;
  ListNode? curr = slow;
  while (curr != null) {
    ListNode? nextTemp = curr.next;
    curr.next = prev;
    prev = curr;
    curr = nextTemp;
  }

  ListNode? p1 = head;
  ListNode? p2 = prev;
  while (p2 != null) {
    if (p1!.val != p2.val) return false;
    p1 = p1.next;
    p2 = p2.next;
  }

  return true;
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
