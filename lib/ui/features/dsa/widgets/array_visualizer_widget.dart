import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';

class ArrayVisualizerWidget extends StatefulWidget {
  final bool isEnglish;

  const ArrayVisualizerWidget({super.key, required this.isEnglish});

  @override
  State<ArrayVisualizerWidget> createState() => _ArrayVisualizerWidgetState();
}

class _ArrayVisualizerWidgetState extends State<ArrayVisualizerWidget> {
  int _selectedDimensionMode = 0; // 0 = 1D Array, 1 = 2D Matrix, 2 = 3D Cube

  // 1D State
  final TextEditingController _valController = TextEditingController(text: "55");
  final TextEditingController _idxController = TextEditingController(text: "1");
  List<int> _elements1D = [10, 20, 30, 40];
  int _capacity1D = 4;
  int _highlighted1D = -1;
  String _logMessage1D = "";
  bool _isResizing1D = false;

  // 2D Matrix State (3x3)
  List<List<int>> _matrix2D = [
    [10, 15, 20],
    [25, 30, 35],
    [40, 45, 50],
  ];
  int _selectedRow2D = 1;
  int _selectedCol2D = 1;
  String _logMessage2D = "";

  // 3D Cube State (2 Layers x 2 Rows x 2 Cols)
  List<List<List<int>>> _cube3D = [
    [
      [5, 10],
      [15, 20]
    ],
    [
      [25, 30],
      [35, 40]
    ],
  ];
  int _activeLayer3D = 0;
  int _selectedRow3D = 0;
  int _selectedCol3D = 1;
  String _logMessage3D = "";

  @override
  void initState() {
    super.initState();
    _logMessage1D = widget.isEnglish
        ? "1D Dynamic Array initialized! Size = 4, Capacity = 4"
        : "১D ডাইনামিক অ্যারে প্রস্তুত! সাইজ = ৪, ক্যাপাসিটি = ৪";
    _logMessage2D = widget.isEnglish
        ? "2D Matrix (3x3 Grid). Selected element matrix[1][1] = 30"
        : "২D ম্যাট্রিক্স (৩x৩ গ্রিড)। সিলেক্টেড সেল matrix[1][1] = 30";
    _logMessage3D = widget.isEnglish
        ? "3D Cube Tensor (2x2x2). Selected layer[0][0][1] = 10"
        : "৩D কিউব টেনসর (২x২x২)। সিলেক্টেড সেল layer[0][0][1] = 10";
  }

  @override
  void dispose() {
    _valController.dispose();
    _idxController.dispose();
    super.dispose();
  }

  // 1D Action Handlers
  void _push1D() {
    final val = int.tryParse(_valController.text.trim()) ?? 99;
    setState(() {
      if (_elements1D.length >= _capacity1D) {
        _isResizing1D = true;
        _capacity1D *= 2;
        _logMessage1D = widget.isEnglish
            ? "⚠️ Capacity Full! Resizing: Capacity doubled to $_capacity1D (Amortized O(1))."
            : "⚠️ ক্যাপাসিটি ফুল! মেমোরি রিসাইজ: মেমোরি সাইজ বেড়ে $_capacity1D হলো (Amortized O(1))।";
      } else {
        _isResizing1D = false;
        _logMessage1D = widget.isEnglish
            ? "Appended $val at index ${_elements1D.length} in O(1) time."
            : "অ্যারের শেষে index ${_elements1D.length} এ $val যোগ করা হলো (O(1))।";
      }
      _elements1D.add(val);
      _highlighted1D = _elements1D.length - 1;
    });
  }

  void _pop1D() {
    if (_elements1D.isEmpty) return;
    setState(() {
      final removed = _elements1D.removeLast();
      _highlighted1D = -1;
      _isResizing1D = false;
      _logMessage1D = widget.isEnglish
          ? "Popped $removed from back in O(1) time."
          : "অ্যারের শেষ থেকে $removed বাদ দেওয়া হলো (O(1))।";
    });
  }

  void _insert1D() {
    final val = int.tryParse(_valController.text.trim()) ?? 99;
    int idx = int.tryParse(_idxController.text.trim()) ?? 0;
    if (idx < 0) idx = 0;
    if (idx > _elements1D.length) idx = _elements1D.length;

    setState(() {
      if (_elements1D.length >= _capacity1D) {
        _capacity1D *= 2;
        _isResizing1D = true;
      } else {
        _isResizing1D = false;
      }
      _elements1D.insert(idx, val);
      _highlighted1D = idx;
      _logMessage1D = widget.isEnglish
          ? "Inserted $val at index $idx. Shifted elements right in O(N) time!"
          : "index $idx এ $val যোগ করা হলো। বাকি সব উপাদান ডানে Shift হলো O(N) সময়ে!";
    });
  }

  void _delete1D() {
    int idx = int.tryParse(_idxController.text.trim()) ?? 0;
    if (_elements1D.isEmpty || idx < 0 || idx >= _elements1D.length) return;

    setState(() {
      final removed = _elements1D.removeAt(idx);
      _highlighted1D = -1;
      _isResizing1D = false;
      _logMessage1D = widget.isEnglish
          ? "Deleted $removed at index $idx. Shifted elements left in O(N) time!"
          : "index $idx থেকে $removed মুছে ফেলা হলো। বাকি উপাদান বামে Shift হলো O(N) সময়ে!";
    });
  }

  void _access1D() {
    int idx = int.tryParse(_idxController.text.trim()) ?? 0;
    if (idx < 0 || idx >= _elements1D.length) return;

    setState(() {
      _highlighted1D = idx;
      _isResizing1D = false;
      final val = _elements1D[idx];
      final address = "0x7FF${(1000 + idx * 4).toRadixString(16).toUpperCase()}";
      _logMessage1D = widget.isEnglish
          ? "O(1) Direct Access! Address = Base + ($idx * 4) = $address -> Value = $val"
          : "O(1) সরাসরি এক্সেস! মেমোরি এড্রেস $address এ মান = $val";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Mode Selector: 1D Array | 2D Matrix | 3D Cube
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: AppTheme.surfaceDark,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFF334155)),
          ),
          child: Row(
            children: [
              _buildModeTab(0, "1D Array", Icons.view_column_outlined),
              _buildModeTab(1, "2D Matrix", Icons.grid_on_outlined),
              _buildModeTab(2, "3D Tensor", Icons.view_in_ar_outlined),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Selected Mode View
        if (_selectedDimensionMode == 0)
          _build1DVisualizerView()
        else if (_selectedDimensionMode == 1)
          _build2DMatrixView()
        else
          _build3DCubeView(),
      ],
    );
  }

  Widget _buildModeTab(int modeIndex, String title, IconData icon) {
    final isSelected = _selectedDimensionMode == modeIndex;
    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedDimensionMode = modeIndex;
          });
        },
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? AppTheme.accentPurple : Colors.transparent,
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
                    fontSize: 12,
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

  // --------------------------------------------------------
  // 1D DYNAMIC ARRAY VISUALIZER
  // --------------------------------------------------------
  Widget _build1DVisualizerView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Status Banner
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: _isResizing1D ? AppTheme.accentAmber.withOpacity(0.15) : AppTheme.accentNeonCyan.withOpacity(0.12),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: _isResizing1D ? AppTheme.accentAmber : AppTheme.accentNeonCyan.withOpacity(0.5)),
          ),
          child: Row(
            children: [
              Icon(_isResizing1D ? Icons.warning_amber_rounded : Icons.info_outline, color: _isResizing1D ? AppTheme.accentAmber : AppTheme.accentNeonCyan, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  _logMessage1D,
                  style: TextStyle(
                    color: _isResizing1D ? AppTheme.accentAmber : AppTheme.accentNeonCyan,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // 1D Memory Canvas
        Container(
          padding: const EdgeInsets.all(10),
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
                  Text("Allocated Size: ${_elements1D.length}", style: const TextStyle(color: AppTheme.accentNeonCyan, fontWeight: FontWeight.bold, fontSize: 13)),
                  Text("Capacity: $_capacity1D", style: const TextStyle(color: AppTheme.accentAmber, fontWeight: FontWeight.bold, fontSize: 13)),
                ],
              ),
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: _capacity1D > 0 ? _elements1D.length / _capacity1D : 0,
                  backgroundColor: AppTheme.surfaceDark,
                  color: _elements1D.length == _capacity1D ? AppTheme.accentAmber : AppTheme.accentNeonCyan,
                  minHeight: 8,
                ),
              ),
              const SizedBox(height: 20),

              LayoutBuilder(
                builder: (context, constraints) {
                  // Base design width = 375
                  final scale = (constraints.maxWidth / 375).clamp(0.8, 1.5);

                  final cardWidth = 68 * scale;
                  final cardHeight = 80 * scale;

                  final addressFontSize = (9 * scale).clamp(8.0, 13.0);
                  final valueFontSize = (18 * scale).clamp(16.0, 28.0);
                  final indexFontSize = (10 * scale).clamp(9.0, 14.0);

                  final cardMargin = 10 * scale;

                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(
                        _capacity1D,
                            (i) {
                          final isAllocated = i < _elements1D.length;
                          final isHl = i == _highlighted1D;

                          final hexAddr =
                              "0x7FF${(1000 + i * 4).toRadixString(16).toUpperCase()}";

                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 300),

                            margin: EdgeInsets.only(
                              right: cardMargin,
                            ),

                            width: cardWidth,
                            height: cardHeight,

                            decoration: BoxDecoration(
                              color: !isAllocated
                                  ? Colors.transparent
                                  : (isHl
                                  ? AppTheme.accentAmber
                                  : AppTheme.surfaceDark),

                              borderRadius: BorderRadius.circular(
                                14 * scale,
                              ),

                              border: Border.all(
                                color: !isAllocated
                                    ? AppTheme.textMuted.withOpacity(0.4)
                                    : (isHl
                                    ? Colors.white
                                    : AppTheme.accentNeonCyan),

                                width: isHl
                                    ? 2.5 * scale
                                    : 1.5 * scale,
                              ),
                            ),

                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: 2 * scale,
                                ),
                                // Memory address
                                Text(
                                  hexAddr,
                                  style: TextStyle(
                                    fontSize: addressFontSize,
                                    color: isHl
                                        ? AppTheme.primaryDark
                                        : AppTheme.textMuted,
                                    fontFamily: 'monospace',
                                  ),
                                ),

                                SizedBox(
                                  height: 4 * scale,
                                ),

                                // Value
                                Text(
                                  isAllocated
                                      ? "${_elements1D[i]}"
                                      : "-",
                                  style: TextStyle(
                                    fontSize: valueFontSize,
                                    fontWeight: FontWeight.bold,
                                    color: !isAllocated
                                        ? AppTheme.textMuted
                                        : (isHl
                                        ? AppTheme.primaryDark
                                        : Colors.white),
                                  ),
                                ),

                                SizedBox(
                                  height: 4 * scale,
                                ),

                                // Index
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 6 * scale,
                                    vertical: 2 * scale,
                                  ),

                                  child: Text(
                                    "[$i]",
                                    style: TextStyle(
                                      fontSize: indexFontSize,
                                      fontWeight: FontWeight.bold,
                                      color: isHl
                                          ? Colors.white
                                          : AppTheme.accentNeonCyan,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              )
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
                      controller: _valController,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: widget.isEnglish ? "Value" : "মান",
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
                      controller: _idxController,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: widget.isEnglish ? "Index [i]" : "ইন্ডেক্স [i]",
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
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  ElevatedButton(onPressed: _push1D, style: ElevatedButton.styleFrom(backgroundColor: AppTheme.accentNeonCyan, foregroundColor: AppTheme.primaryDark), child: Text(widget.isEnglish ? "Push Back (O(1))" : "শেষে যোগ")),
                  ElevatedButton(onPressed: _pop1D, style: ElevatedButton.styleFrom(backgroundColor: AppTheme.accentAmber, foregroundColor: AppTheme.primaryDark), child: Text(widget.isEnglish ? "Pop Back (O(1))" : "শেষ বাদ")),
                  OutlinedButton(onPressed: _insert1D, child: Text(widget.isEnglish ? "Insert [i]" : "ইনসার্ট [i]")),
                  OutlinedButton(onPressed: _delete1D, child: Text(widget.isEnglish ? "Delete [i]" : "ডিলেট [i]")),
                  OutlinedButton(onPressed: _access1D, child: Text(widget.isEnglish ? "Access [i]" : "এক্সেস [i]")),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  // --------------------------------------------------------
  // 2D MATRIX / GRID VISUALIZER
  // --------------------------------------------------------
  Widget _build2DMatrixView() {
    int rSum = 0;
    for (int val in _matrix2D[_selectedRow2D]) {
      rSum += val;
    }
    int cSum = 0;
    for (int r = 0; r < 3; r++) {
      cSum += _matrix2D[r][_selectedCol2D];
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppTheme.accentPurple.withOpacity(0.15),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppTheme.accentPurple.withOpacity(0.5)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(_logMessage2D, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
              const SizedBox(height: 6),
              Text(
                widget.isEnglish
                    ? "Selected Cell: matrix[$_selectedRow2D][$_selectedCol2D] = ${_matrix2D[_selectedRow2D][_selectedCol2D]} | Row $_selectedRow2D Sum = $rSum | Col $_selectedCol2D Sum = $cSum"
                    : "সিলেক্টেড সেল: matrix[$_selectedRow2D][$_selectedCol2D] = ${_matrix2D[_selectedRow2D][_selectedCol2D]} | সারি $_selectedRow2D যোগফল = $rSum | কলাম $_selectedCol2D যোগফল = $cSum",
                style: const TextStyle(color: AppTheme.accentNeonCyan, fontSize: 12),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // 2D Grid Representation
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF090D16),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFF1E293B)),
          ),
          child: Column(
            children: List.generate(3, (r) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3, (c) {
                  final isSelected = r == _selectedRow2D && c == _selectedCol2D;
                  return InkWell(
                    onTap: () {
                      setState(() {
                        _selectedRow2D = r;
                        _selectedCol2D = c;
                        _logMessage2D = widget.isEnglish
                            ? "Inspecting 2D Cell matrix[$r][$c] = ${_matrix2D[r][c]}. Row-Major Offset = Base + ($r * 3 + $c) * 4"
                            : "২D সেল matrix[$r][$c] = ${_matrix2D[r][c]} চেক করা হচ্ছে। অফসেট = Base + ($r * 3 + $c) * 4";
                      });
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      margin: const EdgeInsets.all(6),
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        color: isSelected ? AppTheme.accentPurple : AppTheme.surfaceDark,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isSelected ? Colors.white : AppTheme.accentPurple.withOpacity(0.5),
                          width: isSelected ? 2.5 : 1,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "${_matrix2D[r][c]}",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: isSelected ? Colors.white : AppTheme.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text("[$r][$c]", style: TextStyle(fontSize: 10, color: isSelected ? Colors.white70 : AppTheme.textMuted)),
                        ],
                      ),
                    ),
                  );
                }),
              );
            }),
          ),
        ),
      ],
    );
  }

  // --------------------------------------------------------
  // 3D TENSOR / CUBE VISUALIZER
  // --------------------------------------------------------
  Widget _build3DCubeView() {
    final activeMatrix = _cube3D[_activeLayer3D];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppTheme.accentPink.withOpacity(0.15),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppTheme.accentPink.withOpacity(0.5)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(_logMessage3D, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
              const SizedBox(height: 4),
              Text(
                widget.isEnglish
                    ? "3D Cell: layer[$_activeLayer3D][$_selectedRow3D][$_selectedCol3D] = ${activeMatrix[_selectedRow3D][_selectedCol3D]}"
                    : "৩D সেল: layer[$_activeLayer3D][$_selectedRow3D][$_selectedCol3D] = ${activeMatrix[_selectedRow3D][_selectedCol3D]}",
                style: const TextStyle(color: AppTheme.accentPink, fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Depth Layer Selector
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => setState(() => _activeLayer3D = 0),
              style: ElevatedButton.styleFrom(
                backgroundColor: _activeLayer3D == 0 ? AppTheme.accentPink : AppTheme.surfaceDark,
              ),
              child: const Text("Depth Layer 0"),
            ),
            const SizedBox(width: 12),
            ElevatedButton(
              onPressed: () => setState(() => _activeLayer3D = 1),
              style: ElevatedButton.styleFrom(
                backgroundColor: _activeLayer3D == 1 ? AppTheme.accentPink : AppTheme.surfaceDark,
              ),
              child: const Text("Depth Layer 1"),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // 3D Layer Slice Grid
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF090D16),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFF1E293B)),
          ),
          child: Column(
            children: List.generate(2, (r) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(2, (c) {
                  final isSelected = r == _selectedRow3D && c == _selectedCol3D;
                  return InkWell(
                    onTap: () {
                      setState(() {
                        _selectedRow3D = r;
                        _selectedCol3D = c;
                        _logMessage3D = widget.isEnglish
                            ? "Inspecting 3D Cube [Depth: $_activeLayer3D][Row: $r][Col: $c] = ${activeMatrix[r][c]}"
                            : "৩D কিউব [Depth: $_activeLayer3D][Row: $r][Col: $c] = ${activeMatrix[r][c]} নির্বাচন করা হয়েছে";
                      });
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      margin: const EdgeInsets.all(8),
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: isSelected ? AppTheme.accentPink : AppTheme.surfaceDark,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: isSelected ? Colors.white : AppTheme.accentPink.withOpacity(0.6), width: isSelected ? 2.5 : 1),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("${activeMatrix[r][c]}", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: isSelected ? Colors.white : AppTheme.textPrimary)),
                          const SizedBox(height: 4),
                          Text("[$_activeLayer3D][$r][$c]", style: const TextStyle(fontSize: 10, color: Colors.white70)),
                        ],
                      ),
                    ),
                  );
                }),
              );
            }),
          ),
        ),
      ],
    );
  }
}
