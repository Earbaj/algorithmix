import 'dart:math';
import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';

class VisualTrieNode {
  String char;
  bool isEndOfWord;
  Map<String, VisualTrieNode> children = {};
  double x = 0;
  double y = 0;

  VisualTrieNode(this.char, {this.isEndOfWord = false});
}

class TrieVisualizerWidget extends StatefulWidget {
  final bool isEnglish;

  const TrieVisualizerWidget({super.key, required this.isEnglish});

  @override
  State<TrieVisualizerWidget> createState() => _TrieVisualizerWidgetState();
}

class _TrieVisualizerWidgetState extends State<TrieVisualizerWidget> {
  int _selectedTypeMode = 0; // 0 = Tree Canvas, 1 = Word Dictionary, 2 = Autocomplete

  final TextEditingController _wordController = TextEditingController(text: "apple");
  late VisualTrieNode _root;

  String _highlightedPath = "";
  List<String> _autocompleteSuggestions = [];
  String _statusMessage = "";

  @override
  void initState() {
    super.initState();
    _resetTrie();
  }

  void _resetTrie() {
    _root = VisualTrieNode("*");
    _insertWord("app");
    _insertWord("apple");
    _insertWord("bat");
    _insertWord("ball");

    _highlightedPath = "";
    _autocompleteSuggestions.clear();
    _statusMessage = widget.isEnglish
        ? "Trie (Prefix Tree) Ready! Words: ['app', 'apple', 'bat', 'ball']"
        : "Trie (Prefix Tree) প্রস্তুত! ডিকশনারি: ['app', 'apple', 'bat', 'ball']";
  }

  @override
  void dispose() {
    _wordController.dispose();
    super.dispose();
  }

  void _insertWord(String word) {
    word = word.toLowerCase().trim();
    if (word.isEmpty) return;

    VisualTrieNode curr = _root;
    for (int i = 0; i < word.length; i++) {
      String c = word[i];
      if (!curr.children.containsKey(c)) {
        curr.children[c] = VisualTrieNode(c);
      }
      curr = curr.children[c]!;
    }
    curr.isEndOfWord = true;
  }

  void _handleInsert() {
    final word = _wordController.text.toLowerCase().trim();
    if (word.isEmpty) return;

    setState(() {
      _insertWord(word);
      _highlightedPath = word;
      _statusMessage = widget.isEnglish
          ? "Inserted word '$word' in O(L) time! Updated Prefix Tree branches."
          : "শব্দ '$word' ট্রাইতে ইনসার্ট করা হলো (O(L))!";
    });
  }

  void _handleSearch() {
    final word = _wordController.text.toLowerCase().trim();
    if (word.isEmpty) return;

    VisualTrieNode curr = _root;
    bool found = true;
    for (int i = 0; i < word.length; i++) {
      String c = word[i];
      if (!curr.children.containsKey(c)) {
        found = false;
        break;
      }
      curr = curr.children[c]!;
    }

    bool isExactWord = found && curr.isEndOfWord;

    setState(() {
      _highlightedPath = found ? word : "";
      _statusMessage = isExactWord
          ? (widget.isEnglish ? "EXACT MATCH: Found word '$word' in Trie! (isEndOfWord = true)" : "হুবহু শব্দ পাওয়া গেছে: '$word'!")
          : (found
              ? (widget.isEnglish ? "PREFIX MATCH ONLY: Prefix '$word' exists, but is NOT a standalone word." : "শুধুমাত্র প্রিফিক্স ম্যাচ: '$word' পাওয়া গেছে, তবে এটি সম্পূর্ণ শব্দ নয়।")
              : (widget.isEnglish ? "❌ Word '$word' NOT found in Trie!" : "❌ শব্দ '$word' ট্রাইতে পাওয়া যায়নি!"));
    });
  }

  void _collectWords(VisualTrieNode node, String prefix, List<String> res) {
    if (node.isEndOfWord) res.add(prefix);
    node.children.forEach((c, child) {
      _collectWords(child, prefix + c, res);
    });
  }

  void _handleAutocomplete() {
    final prefix = _wordController.text.toLowerCase().trim();
    VisualTrieNode curr = _root;
    bool foundPrefix = true;

    for (int i = 0; i < prefix.length; i++) {
      String c = prefix[i];
      if (!curr.children.containsKey(c)) {
        foundPrefix = false;
        break;
      }
      curr = curr.children[c]!;
    }

    final List<String> suggestions = [];
    if (foundPrefix) {
      _collectWords(curr, prefix, suggestions);
    }

    setState(() {
      _highlightedPath = foundPrefix ? prefix : "";
      _autocompleteSuggestions = suggestions;
      _statusMessage = foundPrefix
          ? (widget.isEnglish ? "Autocomplete Suggestions for '$prefix': [${suggestions.join(', ')}]" : "অটো-কমপ্লিট সাজেশনস ('$prefix'): [${suggestions.join(', ')}]")
          : (widget.isEnglish ? "No autocomplete matches found for '$prefix'" : "কোনো অটো-কমপ্লিট সাজেশন পাওয়া যায়নি");
    });
  }

  List<String> _getAllWords() {
    final List<String> words = [];
    _collectWords(_root, "", words);
    return words;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Mode Switcher
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: AppTheme.surfaceDark,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFF334155)),
          ),
          child: Row(
            children: [
              _buildTypeTab(0, "Prefix Tree Canvas", Icons.sort_by_alpha_outlined),
              _buildTypeTab(1, "Dictionary Words", Icons.menu_book),
              _buildTypeTab(2, "Autocomplete Engine", Icons.search),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Status Banner
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFFA855F7).withOpacity(0.15),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFA855F7).withOpacity(0.5)),
          ),
          child: Row(
            children: [
              const Icon(Icons.sort_by_alpha, color: Color(0xFFA855F7), size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  _statusMessage,
                  style: const TextStyle(
                    color: Color(0xFFA855F7),
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Display Canvas
        Container(
          height: 350,
          padding: const EdgeInsets.all(16),
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xFF090D16),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFF1E293B)),
          ),
          child: _buildCanvasContent(),
        ),
        const SizedBox(height: 16),

        // Controls
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.surfaceDark,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFF334155)),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _wordController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: widget.isEnglish ? "Word or Prefix" : "শব্দ বা প্রিফিক্স",
                        labelStyle: const TextStyle(color: AppTheme.textSecondary, fontSize: 12),
                        filled: true,
                        fillColor: AppTheme.primaryDark,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  ElevatedButton.icon(
                    icon: const Icon(Icons.add, size: 16),
                    label: Text(widget.isEnglish ? "Insert Word O(L)" : "শব্দ যোগ (O(L))"),
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFA855F7), foregroundColor: Colors.white),
                    onPressed: _handleInsert,
                  ),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.search, size: 16),
                    label: Text(widget.isEnglish ? "Search Word O(L)" : "শব্দ খুঁজুন (O(L))"),
                    style: ElevatedButton.styleFrom(backgroundColor: AppTheme.accentGreen, foregroundColor: AppTheme.primaryDark),
                    onPressed: _handleSearch,
                  ),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.spellcheck, size: 16),
                    label: Text(widget.isEnglish ? "Autocomplete Prefix" : "অটো-কমপ্লিট"),
                    style: ElevatedButton.styleFrom(backgroundColor: AppTheme.accentNeonCyan, foregroundColor: AppTheme.primaryDark),
                    onPressed: _handleAutocomplete,
                  ),
                  OutlinedButton.icon(
                    icon: const Icon(Icons.refresh, size: 16),
                    label: Text(widget.isEnglish ? "Reset Trie" : "রিসেট"),
                    onPressed: () {
                      setState(() {
                        _resetTrie();
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCanvasContent() {
    if (_selectedTypeMode == 1) {
      // Dictionary Word List View
      final allWords = _getAllWords();
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Stored Dictionary Words (isEndOfWord == true)", style: TextStyle(color: Color(0xFFA855F7), fontWeight: FontWeight.bold, fontSize: 13)),
          const SizedBox(height: 14),
          if (allWords.isEmpty)
            const Text("Dictionary is Empty", style: TextStyle(color: AppTheme.textMuted, fontSize: 12))
          else
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: allWords.map((word) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFA855F7),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [BoxShadow(color: const Color(0xFFA855F7).withOpacity(0.4), blurRadius: 8)],
                  ),
                  child: Text(word, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                );
              }).toList(),
            ),
        ],
      );
    } else if (_selectedTypeMode == 2) {
      // Autocomplete Suggestions View
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Autocomplete Suggestions for '${_wordController.text}'", style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 13)),
          const SizedBox(height: 14),
          if (_autocompleteSuggestions.isEmpty)
            Text(widget.isEnglish ? "Click 'Autocomplete Prefix' to see suggestions." : "সাজেশন দেখতে 'অটো-কমপ্লিট' বাটনে চাপ দিন।", style: const TextStyle(color: AppTheme.textMuted, fontSize: 12))
          else
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: _autocompleteSuggestions.map((word) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: AppTheme.accentNeonCyan,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(word, style: const TextStyle(color: AppTheme.primaryDark, fontWeight: FontWeight.bold, fontSize: 16)),
                );
              }).toList(),
            ),
        ],
      );
    } else {
      // Hierarchical Character Tree Canvas
      return LayoutBuilder(
        builder: (context, constraints) {
          final width = max(constraints.maxWidth, 600.0);
          final height = constraints.maxHeight;

          // Calculate tree node layout coordinates
          _calculateTrieNodePositions(_root, width / 2, 35, width / 4, 65);

          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: width,
              height: height,
              child: Stack(
                children: [
                  CustomPaint(
                    size: Size(width, height),
                    painter: TrieBranchPainter(
                      root: _root,
                      highlightedPath: _highlightedPath,
                    ),
                  ),
                  ..._buildTrieNodeWidgets(_root, ""),
                ],
              ),
            ),
          );
        },
      );
    }
  }

  void _calculateTrieNodePositions(VisualTrieNode node, double x, double y, double dx, double dy) {
    node.x = x;
    node.y = y;

    final children = node.children.values.toList();
    if (children.isEmpty) return;

    double startX = x - (dx * (children.length - 1) / 2);
    for (int i = 0; i < children.length; i++) {
      _calculateTrieNodePositions(children[i], startX + (i * dx), y + dy, dx * 0.5, dy);
    }
  }

  List<Widget> _buildTrieNodeWidgets(VisualTrieNode node, String currentPrefix) {
    final List<Widget> widgets = [];
    final fullPrefix = node.char == "*" ? "" : currentPrefix + node.char;

    final isPathMatch = _highlightedPath.isNotEmpty && _highlightedPath.startsWith(fullPrefix) && fullPrefix.isNotEmpty;
    final isRoot = node.char == "*";

    widgets.add(
      Positioned(
        left: node.x - 22,
        top: node.y - 22,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: node.isEndOfWord
                ? AppTheme.accentPink
                : (isPathMatch
                    ? AppTheme.accentNeonCyan
                    : (isRoot ? const Color(0xFFA855F7) : AppTheme.surfaceDark)),
            shape: BoxShape.circle,
            border: Border.all(
              color: (node.isEndOfWord || isPathMatch) ? Colors.white : const Color(0xFFA855F7).withOpacity(0.6),
              width: (node.isEndOfWord || isPathMatch) ? 2.5 : 1.5,
            ),
            boxShadow: node.isEndOfWord
                ? [BoxShadow(color: AppTheme.accentPink.withOpacity(0.6), blurRadius: 10)]
                : (isPathMatch ? [BoxShadow(color: AppTheme.accentNeonCyan.withOpacity(0.5), blurRadius: 8)] : []),
          ),
          child: Center(
            child: Text(
              node.char,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: (node.isEndOfWord || isPathMatch) ? AppTheme.primaryDark : Colors.white,
              ),
            ),
          ),
        ),
      ),
    );

    node.children.forEach((c, child) {
      widgets.addAll(_buildTrieNodeWidgets(child, fullPrefix));
    });

    return widgets;
  }

  Widget _buildTypeTab(int modeIndex, String title, IconData icon) {
    final isSelected = _selectedTypeMode == modeIndex;
    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedTypeMode = modeIndex;
            if (modeIndex == 2) _handleAutocomplete();
          });
        },
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFA855F7) : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 16, color: isSelected ? Colors.white : AppTheme.textSecondary),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  title,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    color: isSelected ? Colors.white : AppTheme.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// CustomPainter to draw branch lines connecting parent and child Trie nodes
class TrieBranchPainter extends CustomPainter {
  final VisualTrieNode root;
  final String highlightedPath;

  TrieBranchPainter({required this.root, required this.highlightedPath});

  @override
  void paint(Canvas canvas, Size size) {
    _drawTrieBranches(canvas, root, "");
  }

  void _drawTrieBranches(Canvas canvas, VisualTrieNode node, String prefix) {
    final fullPrefix = node.char == "*" ? "" : prefix + node.char;

    final defaultPaint = Paint()
      ..color = const Color(0xFF334155)
      ..strokeWidth = 1.8
      ..style = PaintingStyle.stroke;

    final pathPaint = Paint()
      ..color = AppTheme.accentNeonCyan
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke;

    node.children.forEach((c, child) {
      final childPrefix = fullPrefix + c;
      final isPath = highlightedPath.isNotEmpty && highlightedPath.startsWith(childPrefix);

      canvas.drawLine(
        Offset(node.x, node.y),
        Offset(child.x, child.y),
        isPath ? pathPaint : defaultPaint,
      );

      _drawTrieBranches(canvas, child, fullPrefix);
    });
  }

  @override
  bool shouldRepaint(covariant TrieBranchPainter oldDelegate) => true;
}
