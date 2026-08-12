import 'dart:async';
import 'package:flutter/material.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';

class CircularQueueAnimatedVisualizer extends StatefulWidget {
  final bool isEnglish;

  const CircularQueueAnimatedVisualizer({
    super.key,
    required this.isEnglish,
  });

  @override
  State<CircularQueueAnimatedVisualizer> createState() =>
      _CircularQueueAnimatedVisualizerState();
}

class CircularStepData {
  final String opName;
  final List<int?> slots; // fixed size 4
  final int front;
  final int rear;
  final String titleEn;
  final String titleBn;
  final String explanationEn;
  final String explanationBn;

  const CircularStepData({
    required this.opName,
    required this.slots,
    required this.front,
    required this.rear,
    required this.titleEn,
    required this.titleBn,
    required this.explanationEn,
    required this.explanationBn,
  });
}

class _CircularQueueAnimatedVisualizerState
    extends State<CircularQueueAnimatedVisualizer> {
  int _currentStepIndex = 0;
  bool _isPlaying = false;
  Timer? _timer;

  late final List<CircularStepData> _steps;

  @override
  void initState() {
    super.initState();
    _steps = const [
      CircularStepData(
        opName: "INIT (K=4)",
        slots: [null, null, null, null],
        front: 0,
        rear: -1,
        titleEn: "1. Initialization",
        titleBn: "১. সূচনা (Initialization)",
        explanationEn: "Circular Ring Queue of capacity K = 4. front = 0, rear = -1.",
        explanationBn: "K = 4 সাইজের সার্কুলার রিং কিউ সূচনা। front = 0, rear = -1।",
      ),
      CircularStepData(
        opName: "enQueue(10)",
        slots: [10, null, null, null],
        front: 0,
        rear: 0,
        titleEn: "2. enQueue(10)",
        titleBn: "২. enQueue(10)",
        explanationEn: "rear = (rear + 1) % 4 = 0. Insert 10 at slot 0.",
        explanationBn: "rear = (0 + 1) % 4 = 0। স্লট ০ এ ১০ বসানো হলো।",
      ),
      CircularStepData(
        opName: "enQueue(20)",
        slots: [10, 20, null, null],
        front: 0,
        rear: 1,
        titleEn: "3. enQueue(20)",
        titleBn: "৩. enQueue(20)",
        explanationEn: "rear = (1 + 1) % 4 = 1. Insert 20 at slot 1.",
        explanationBn: "rear = (1 + 1) % 4 = 1। স্লট ১ এ ২০ বসানো হলো।",
      ),
      CircularStepData(
        opName: "deQueue()",
        slots: [null, 20, null, null],
        front: 1,
        rear: 1,
        titleEn: "4. deQueue() -> Frees Slot 0",
        titleBn: "৪. deQueue() -> স্লট ০ খালি হলো",
        explanationEn: "deQueue() removes 10 from Front. Advance front = (front + 1) % 4 = 1. Slot 0 freed!",
        explanationBn: "deQueue() ফ্রন্ট থেকে ১০ রিমুভ করে। front = (0 + 1) % 4 = 1। স্লট ০ খালি হলো!",
      ),
      CircularStepData(
        opName: "enQueue(30), enQueue(40), enQueue(50)",
        slots: [50, 20, 30, 40],
        front: 1,
        rear: 0,
        titleEn: "5. Ring Wrap-around! enQueue(50) reuses Slot 0 🎉",
        titleBn: "৫. রিং র‍্যাপ-অ্যারাউন্ড! 50 খালি স্লট 0 পুনরায় ব্যবহার করল 🎉",
        explanationEn: "After filling slots 2 and 3, rear wraps around via (3 + 1) % 4 = 0! 50 is inserted into freed slot 0! Space reused efficiently!",
        explanationBn: "স্লট ২ ও ৩ পূরণের পর, (3 + 1) % 4 = 0 সূত্রের মাধ্যমে rear ঘুরে ফাঁকা স্লট ০ তে ৫০ কে বসায়! স্থান অপচয় রোধ হলো!",
      ),
    ];
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _togglePlay() {
    setState(() => _isPlaying = !_isPlaying);
    if (_isPlaying) {
      _timer = Timer.periodic(const Duration(milliseconds: 1500), (timer) {
        if (_currentStepIndex < _steps.length - 1) {
          setState(() => _currentStepIndex++);
        } else {
          _timer?.cancel();
          setState(() => _isPlaying = false);
        }
      });
    } else {
      _timer?.cancel();
    }
  }

  void _nextStep() {
    if (_currentStepIndex < _steps.length - 1) {
      setState(() => _currentStepIndex++);
    }
  }

  void _prevStep() {
    if (_currentStepIndex > 0) {
      setState(() => _currentStepIndex--);
    }
  }

  void _reset() {
    _timer?.cancel();
    setState(() {
      _isPlaying = false;
      _currentStepIndex = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final step = _steps[_currentStepIndex];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppTheme.accentAmber.withOpacity(0.12),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppTheme.accentAmber.withOpacity(0.5)),
          ),
          child: Row(
            children: [
              const Icon(Icons.loop, color: AppTheme.accentAmber, size: 24),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.isEnglish ? step.titleEn : step.titleBn,
                      style: const TextStyle(color: AppTheme.accentAmber, fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      widget.isEnglish ? step.explanationEn : step.explanationBn,
                      style: const TextStyle(color: Colors.white, fontSize: 12, height: 1.3),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Circular Ring Memory Canvas
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF090D16),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFF1E293B)),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildLegendItem("front ptr", AppTheme.accentNeonCyan),
                  const SizedBox(width: 20),
                  _buildLegendItem("rear ptr", AppTheme.accentAmber),
                ],
              ),
              const SizedBox(height: 16),

              // Ring Slots Row
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(step.slots.length, (idx) {
                    final val = step.slots[idx];
                    final isFront = step.front == idx;
                    final isRear = step.rear == idx;

                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 6),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              if (isFront) _buildBadge("FRONT", AppTheme.accentNeonCyan),
                              if (isRear) _buildBadge("REAR", AppTheme.accentAmber),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Container(
                            width: 52,
                            height: 52,
                            decoration: BoxDecoration(
                              color: isFront
                                  ? AppTheme.accentNeonCyan.withOpacity(0.2)
                                  : (isRear ? AppTheme.accentAmber.withOpacity(0.2) : const Color(0xFF1E293B)),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isFront
                                    ? AppTheme.accentNeonCyan
                                    : (isRear ? AppTheme.accentAmber : const Color(0xFF334155)),
                                width: isFront || isRear ? 2 : 1,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                val == null ? "EMPTY" : "$val",
                                style: TextStyle(
                                  fontFamily: 'monospace',
                                  color: val == null ? AppTheme.textMuted : Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: val == null ? 10 : 15,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text("Slot $idx", style: const TextStyle(color: AppTheme.textMuted, fontSize: 10)),
                        ],
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(height: 14),
              Text(
                widget.isEnglish
                    ? "Modulo Math (index + 1) % Capacity wraps around seamlessly!"
                    : "মডিউলো পাটিগণিত (index + 1) % Capacity এর সাহায্যে বৃত্তাকারে স্থান পুনর্ব্যবহার!",
                style: const TextStyle(color: AppTheme.textMuted, fontSize: 11, fontStyle: FontStyle.italic),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        _buildControls(),
      ],
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(width: 10, height: 10, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 4),
        Text(label, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildBadge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      margin: const EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(color: color.withOpacity(0.2), borderRadius: BorderRadius.circular(4), border: Border.all(color: color)),
      child: Text(label, style: TextStyle(color: color, fontSize: 9, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildControls() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.surfaceDark,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF334155)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            icon: const Icon(Icons.replay, color: Colors.white70),
            onPressed: _reset,
            tooltip: widget.isEnglish ? "Reset" : "রিসেট",
          ),
          IconButton(
            icon: const Icon(Icons.skip_previous, color: Colors.white),
            onPressed: _currentStepIndex > 0 ? _prevStep : null,
            tooltip: widget.isEnglish ? "Previous Step" : "আগের স্টেপ",
          ),
          ElevatedButton.icon(
            onPressed: _togglePlay,
            icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
            label: Text(_isPlaying
                ? (widget.isEnglish ? "Pause" : "পজ করুন")
                : (widget.isEnglish ? "Auto Play" : "অটো প্লে")),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.accentAmber,
              foregroundColor: AppTheme.primaryDark,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.skip_next, color: Colors.white),
            onPressed: _currentStepIndex < _steps.length - 1 ? _nextStep : null,
            tooltip: widget.isEnglish ? "Next Step" : "পরের স্টেপ",
          ),
          Text(
            "${_currentStepIndex + 1}/${_steps.length}",
            style: const TextStyle(color: AppTheme.accentAmber, fontWeight: FontWeight.bold, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
