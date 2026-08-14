import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';

class HappySolutionCodeTab extends StatefulWidget {
  final bool isEnglish;

  const HappySolutionCodeTab({
    super.key,
    required this.isEnglish,
  });

  @override
  State<HappySolutionCodeTab> createState() => _HappySolutionCodeTabState();
}

class _HappySolutionCodeTabState extends State<HappySolutionCodeTab> {
  final int _n = 19;
  bool _showAnswer = false;
  int _userSlow = 19;
  int _userFast = 19;
  String _userFeedbackEn = "Advance pointers: Slow transforms 1x, Fast transforms 2x!";
  String _userFeedbackBn = "পয়েন্টার অগ্রসর করুন: Slow ১ ধাপ, Fast ২ ধাপ যাবে!";
  bool _userSolved = false;
  String _selectedCodeLang = "C++";

  int _getNext(int n) {
    int sum = 0;
    while (n > 0) {
      int d = n % 10;
      sum += d * d;
      n ~/= 10;
    }
    return sum;
  }

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
      _userSlow = _getNext(_userSlow);
      _userFast = _getNext(_getNext(_userFast));

      if (_userSlow == 1 || _userFast == 1) {
        _userSolved = true;
        _userFeedbackEn = "🎉 CONGRATULATIONS! Reached 1! Happy Number confirmed!";
        _userFeedbackBn = "🎉 অভিনন্দন! ১ পাওয়া গেছে! হ্যাপি নাম্বার নিশ্চিত!";
      } else if (_userSlow == _userFast) {
        _userSolved = true;
        _userFeedbackEn = "❌ Cycle detected at $_userSlow! Not a happy number.";
        _userFeedbackBn = "❌ $_userSlow এ সাইকেল পাওয়া গেছে! হ্যাপি নাম্বার নয়।";
      } else {
        _userFeedbackEn = "Step done: Slow is at $_userSlow, Fast is at $_userFast. Keep moving!";
        _userFeedbackBn = "ধাপ সম্পন্ন: Slow হলো $_userSlow, Fast হলো $_userFast। রূপান্তর চালান!";
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
                      Text(widget.isEnglish ? '🎮 Practice Mode: Transform Digits Yourself!' : '🎮 প্র্যাকটিস মোড: নিজে রূপান্তর করুন!', style: TextStyle(fontSize: Responsive.sp(context, 16), fontWeight: FontWeight.bold, color: Colors.white)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(widget.isEnglish ? 'Current Input n: $_n' : 'বর্তমান ইনপুট n: $_n', style: TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: Responsive.sp(context, 13))),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      ElevatedButton.icon(
                        onPressed: _userSolved ? null : _handleUserMove,
                        icon: Icon(Icons.arrow_forward, size: Responsive.sp(context, 16)),
                        label: Text(widget.isEnglish ? 'Advance Pointers (Slow 1x, Fast 2x)' : 'পয়েন্টার অগ্রসর করুন (Slow ১x, Fast ২x)', style: TextStyle(fontSize: Responsive.sp(context, 13))),
                        style: ElevatedButton.styleFrom(backgroundColor: AppTheme.accentPurple),
                      ),
                      OutlinedButton.icon(
                        onPressed: () {
                          setState(() {
                            _userSlow = _n;
                            _userFast = _n;
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
private:
    int getNext(int n) {
        int sum = 0;
        while (n > 0) {
            int digit = n % 10;
            sum += digit * digit;
            n /= 10;
        }
        return sum;
    }

public:
    bool isHappy(int n) {
        int slow = n;
        int fast = n;
        
        do {
            slow = getNext(slow);
            fast = getNext(getNext(fast));
        } while (slow != fast);
        
        return slow == 1;
    }
};""";
    } else if (lang == "Java") {
      code = """
class Solution {
    private int getNext(int n) {
        int sum = 0;
        while (n > 0) {
            int digit = n % 10;
            sum += digit * digit;
            n /= 10;
        }
        return sum;
    }

    public boolean isHappy(int n) {
        int slow = n;
        int fast = n;
        
        do {
            slow = getNext(slow);
            fast = getNext(getNext(fast));
        } while (slow != fast);
        
        return slow == 1;
    }
}""";
    } else if (lang == "Python") {
      code = """
class Solution:
    def isHappy(self, n: int) -> bool:
        def get_next(number):
            total_sum = 0
            while number > 0:
                number, digit = divmod(number, 10)
                total_sum += digit ** 2
            return total_sum

        slow = n
        fast = n
        
        while True:
            slow = get_next(slow)
            fast = get_next(get_next(fast))
            if slow == fast:
                break
                
        return slow == 1""";
    } else {
      code = """
bool isHappy(int n) {
  int getNext(int number) {
    int sum = 0;
    while (number > 0) {
      int digit = number % 10;
      sum += digit * digit;
      number ~/= 10;
    }
    return sum;
  }

  int slow = n;
  int fast = n;

  do {
    slow = getNext(slow);
    fast = getNext(getNext(fast));
  } while (slow != fast);

  return slow == 1;
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
