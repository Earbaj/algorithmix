import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';

class HashTableVisualizerWidget extends StatefulWidget {
  final bool isEnglish;

  const HashTableVisualizerWidget({super.key, required this.isEnglish});

  @override
  State<HashTableVisualizerWidget> createState() => _HashTableVisualizerWidgetState();
}

class _HashTableVisualizerWidgetState extends State<HashTableVisualizerWidget> {
  int _selectedTypeMode = 0; // 0 = Separate Chaining, 1 = Linear Probing, 2 = Hash Set

  final TextEditingController _keyController = TextEditingController(text: "apple");
  final TextEditingController _valController = TextEditingController(text: "25");

  final int _capacity = 5;
  late List<List<MapEntry<String, String>>> _chainBuckets;
  List<MapEntry<String, String>?> _probingBuckets = List.filled(5, null);

  int _highlightedBucketIndex = -1;
  String _statusMessage = "";

  @override
  void initState() {
    super.initState();
    _resetData();
  }

  void _resetData() {
    _chainBuckets = List.generate(5, (_) => []);
    _probingBuckets = List.filled(5, null);

    // Default items
    _putChain("apple", "25");
    _putChain("banana", "40");
    _putChain("cat", "15");

    _highlightedBucketIndex = -1;
    _statusMessage = widget.isEnglish
        ? "Hash Table initialized with 5 buckets (hash(k) = ascii_sum % 5)"
        : "৫টি বাকেট বিশিষ্ট হ্যাশ টেবিল প্রস্তুত (hash(k) = ascii_sum % 5)";
  }

  @override
  void dispose() {
    _keyController.dispose();
    _valController.dispose();
    super.dispose();
  }

  int _computeHash(String key) {
    int sum = 0;
    for (int i = 0; i < key.length; i++) {
      sum += key.codeUnitAt(i);
    }
    return sum % _capacity;
  }

  void _putChain(String key, String val) {
    final idx = _computeHash(key);
    final chain = _chainBuckets[idx];
    for (int i = 0; i < chain.length; i++) {
      if (chain[i].key == key) {
        chain[i] = MapEntry(key, val);
        return;
      }
    }
    chain.add(MapEntry(key, val));
  }

  void _handlePut() {
    final key = _keyController.text.trim();
    final val = _valController.text.trim();
    if (key.isEmpty) return;

    final idx = _computeHash(key);

    setState(() {
      _highlightedBucketIndex = idx;
      if (_selectedTypeMode == 1) {
        // Linear Probing
        int probe = idx;
        int count = 0;
        while (_probingBuckets[probe] != null && _probingBuckets[probe]!.key != key && count < _capacity) {
          probe = (probe + 1) % _capacity;
          count++;
        }
        if (count >= _capacity) {
          _statusMessage = widget.isEnglish ? "⚠️ Table Full! Cannot insert." : "⚠️ টেবিল ফুল! ইনসার্ট সম্ভব নয়।";
          return;
        }
        _probingBuckets[probe] = MapEntry(key, val);
        _statusMessage = widget.isEnglish
            ? "Linear Probing Put: key '$key' -> hash = $idx, placed at slot $probe"
            : "Linear Probing Put: key '$key' -> hash = $idx, স্থান পেয়েছে স্লট $probe এ";
      } else {
        // Chaining & Set
        _putChain(key, val);
        _statusMessage = widget.isEnglish
            ? "Chaining Put: hash('$key') = ascii_sum % 5 = Bucket [$idx] -> Added ($key : $val)"
            : "Chaining Put: hash('$key') = ascii_sum % 5 = বাকেট [$idx] -> যুক্ত হলো ($key : $val)";
      }
    });
  }

  void _handleGet() {
    final key = _keyController.text.trim();
    if (key.isEmpty) return;

    final idx = _computeHash(key);

    setState(() {
      _highlightedBucketIndex = idx;
      if (_selectedTypeMode == 1) {
        // Probing lookup
        int probe = idx;
        int count = 0;
        bool found = false;
        while (_probingBuckets[probe] != null && count < _capacity) {
          if (_probingBuckets[probe]!.key == key) {
            found = true;
            _statusMessage = widget.isEnglish
                ? "FOUND key '$key' = '${_probingBuckets[probe]!.value}' at Slot [$probe] in O(1) time!"
                : "খুঁজে পাওয়া গেছে! key '$key' = '${_probingBuckets[probe]!.value}' স্লট [$probe] এ (O(1))!";
            break;
          }
          probe = (probe + 1) % _capacity;
          count++;
        }
        if (!found) {
          _statusMessage = widget.isEnglish ? "❌ Key '$key' Not Found!" : "❌ Key '$key' পাওয়া যায়নি!";
        }
      } else {
        // Chain lookup
        final chain = _chainBuckets[idx];
        final match = chain.where((e) => e.key == key).firstOrNull;
        if (match != null) {
          _statusMessage = widget.isEnglish
              ? "FOUND key '$key' = '${match.value}' in Bucket [$idx] Chain!"
              : "খুঁজে পাওয়া গেছে! key '$key' = '${match.value}' বাকেট [$idx] চেইনে!";
        } else {
          _statusMessage = widget.isEnglish ? "❌ Key '$key' Not Found in Bucket [$idx]!" : "❌ Key '$key' বাকেট [$idx] এ পাওয়া যায়নি!";
        }
      }
    });
  }

  void _handleRemove() {
    final key = _keyController.text.trim();
    if (key.isEmpty) return;

    final idx = _computeHash(key);

    setState(() {
      _highlightedBucketIndex = idx;
      _chainBuckets[idx].removeWhere((e) => e.key == key);
      _statusMessage = widget.isEnglish
          ? "Removed key '$key' from Bucket [$idx] Chain."
          : "কী '$key' বাকেট [$idx] থেকে মুছে ফেলা হয়েছে।";
    });
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
              _buildTypeTab(0, "Separate Chaining", Icons.account_tree_outlined),
              _buildTypeTab(1, "Linear Probing", Icons.east),
              _buildTypeTab(2, "Hash Set", Icons.grid_view_outlined),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Status Banner
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppTheme.accentPink.withOpacity(0.15),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppTheme.accentPink.withOpacity(0.5)),
          ),
          child: Row(
            children: [
              const Icon(Icons.grid_view, color: AppTheme.accentPink, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  _statusMessage,
                  style: const TextStyle(
                    color: AppTheme.accentPink,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Hash Table Canvas
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF090D16),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFF1E293B)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Hash Buckets (Capacity: 5)", style: TextStyle(color: AppTheme.accentPink, fontWeight: FontWeight.bold, fontSize: 13)),
                  Text("Hash: sum(ascii) % 5", style: TextStyle(color: AppTheme.textMuted, fontSize: 11, fontFamily: 'monospace')),
                ],
              ),
              const SizedBox(height: 16),

              if (_selectedTypeMode == 1)
                // Linear Probing Canvas
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(_capacity, (i) {
                      final entry = _probingBuckets[i];
                      final isHl = i == _highlightedBucketIndex;

                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: 65,
                        height: 80,
                        decoration: BoxDecoration(
                          color: isHl ? AppTheme.accentPink : AppTheme.surfaceDark,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: isHl ? Colors.white : AppTheme.accentPink.withOpacity(0.5), width: isHl ? 2.5 : 1),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Slot [$i]", style: TextStyle(fontSize: 9, color: isHl ? Colors.white : AppTheme.textMuted)),
                            const SizedBox(height: 4),
                            Text(entry != null ? entry.key : "-", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: isHl ? Colors.white : Colors.white70)),
                            Text(entry != null ? ":${entry.value}" : "", style: TextStyle(fontSize: 10, color: isHl ? Colors.white70 : AppTheme.accentPink)),
                          ],
                        ),
                      );
                    }),
                  ),
                )
              else
                // Chaining / Set Bucket Rows
                Column(
                  children: List.generate(_capacity, (i) {
                    final chain = _chainBuckets[i];
                    final isHl = i == _highlightedBucketIndex;

                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: isHl ? AppTheme.accentPink.withOpacity(0.2) : AppTheme.surfaceDark,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: isHl ? AppTheme.accentPink : const Color(0xFF334155), width: isHl ? 2 : 1),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(color: isHl ? AppTheme.accentPink : AppTheme.primaryDark, borderRadius: BorderRadius.circular(6)),
                            child: Text("Bucket [$i]", style: TextStyle(color: isHl ? Colors.white : AppTheme.accentPink, fontWeight: FontWeight.bold, fontSize: 11)),
                          ),
                          const SizedBox(width: 10),
                          const Icon(Icons.arrow_forward_rounded, color: AppTheme.textMuted, size: 16),
                          const SizedBox(width: 10),

                          if (chain.isEmpty)
                            const Text("NULL (Empty Chain)", style: TextStyle(color: AppTheme.textMuted, fontSize: 12))
                          else
                            Expanded(
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: chain.map((entry) {
                                    return Container(
                                      margin: const EdgeInsets.only(right: 8),
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: AppTheme.accentPink,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        _selectedTypeMode == 2 ? entry.key : "${entry.key} : ${entry.value}",
                                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                        ],
                      ),
                    );
                  }),
                ),
            ],
          ),
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
                      controller: _keyController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: widget.isEnglish ? "Key" : "কী (Key)",
                        labelStyle: const TextStyle(color: AppTheme.textSecondary, fontSize: 12),
                        filled: true,
                        fillColor: AppTheme.primaryDark,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _valController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: widget.isEnglish ? "Value" : "মান (Value)",
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
                    icon: const Icon(Icons.add_task, size: 16),
                    label: Text(widget.isEnglish ? "Put(key, val) O(1)" : "যোগ/আপডেট O(1)"),
                    style: ElevatedButton.styleFrom(backgroundColor: AppTheme.accentPink, foregroundColor: Colors.white),
                    onPressed: _handlePut,
                  ),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.search, size: 16),
                    label: Text(widget.isEnglish ? "Get(key) O(1)" : "খোঁজা (Get) O(1)"),
                    style: ElevatedButton.styleFrom(backgroundColor: AppTheme.accentNeonCyan, foregroundColor: AppTheme.primaryDark),
                    onPressed: _handleGet,
                  ),
                  OutlinedButton.icon(
                    icon: const Icon(Icons.delete_outline, size: 16),
                    label: Text(widget.isEnglish ? "Remove(key)" : "রিমুভ (Remove)"),
                    onPressed: _handleRemove,
                  ),
                  OutlinedButton.icon(
                    icon: const Icon(Icons.refresh, size: 16),
                    label: Text(widget.isEnglish ? "Reset" : "রিসেট"),
                    onPressed: () {
                      setState(() {
                        _resetData();
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

  Widget _buildTypeTab(int modeIndex, String title, IconData icon) {
    final isSelected = _selectedTypeMode == modeIndex;
    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedTypeMode = modeIndex;
          });
        },
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? AppTheme.accentPink : Colors.transparent,
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
