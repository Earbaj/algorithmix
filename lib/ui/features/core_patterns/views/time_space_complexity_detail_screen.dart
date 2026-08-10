import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:algorithmix/ui/core/theme/app_theme.dart';
import 'package:algorithmix/ui/core/utils/responsive.dart';
import 'package:algorithmix/ui/core/navigation/app_routes.dart';
import 'package:algorithmix/ui/features/core_patterns/widgets/time_space_complexity_code_free_visualizer.dart';

class SubTopicItem {
  final int id;
  final String titleEn;
  final String titleBn;
  final IconData icon;
  final Color color;
  final String summaryEn;
  final String summaryBn;
  final String detailsEn;
  final String detailsBn;
  final List<String> keyTakeawaysEn;
  final List<String> keyTakeawaysBn;
  final String codeExample;
  final String quizQuestionEn;
  final String quizQuestionBn;
  final List<String> quizOptionsEn;
  final List<String> quizOptionsBn;
  final int correctOptionIndex;
  final String quizExplanationEn;
  final String quizExplanationBn;

  const SubTopicItem({
    required this.id,
    required this.titleEn,
    required this.titleBn,
    required this.icon,
    required this.color,
    required this.summaryEn,
    required this.summaryBn,
    required this.detailsEn,
    required this.detailsBn,
    required this.keyTakeawaysEn,
    required this.keyTakeawaysBn,
    required this.codeExample,
    required this.quizQuestionEn,
    required this.quizQuestionBn,
    required this.quizOptionsEn,
    required this.quizOptionsBn,
    required this.correctOptionIndex,
    required this.quizExplanationEn,
    required this.quizExplanationBn,
  });
}

class TimeSpaceComplexityDetailScreen extends StatefulWidget {
  const TimeSpaceComplexityDetailScreen({super.key});

  @override
  State<TimeSpaceComplexityDetailScreen> createState() =>
      _TimeSpaceComplexityDetailScreenState();
}

class _TimeSpaceComplexityDetailScreenState
    extends State<TimeSpaceComplexityDetailScreen>
    with SingleTickerProviderStateMixin {
  bool _isEnglish = true;
  late TabController _tabController;
  int? _expandedSubTopicId = 1;
  String _selectedCodeLang = "C++";

  // Master Quiz State
  final Map<int, int?> _userAnswers = {};
  final Map<int, bool> _quizSubmitted = {};
  int _quizScore = 0;

  // List of all sub-topics under Time & Space Complexity (Big O)
  final List<SubTopicItem> _subTopics = [
    SubTopicItem(
      id: 1,
      titleEn: "1. Asymptotic Notations (Big O, Big Ω, Big Θ)",
      titleBn: "১. অ্যাসিম্পটোটিক নোটেশন (Big O, Big Ω, Big Θ)",
      icon: Icons.functions_rounded,
      color: const Color(0xFF06B6D4),
      summaryEn: "Mathematical bounds used to describe algorithm performance as input size grows to infinity.",
      summaryBn: "ইনপুট সাইজ অসীমের দিকে বৃদ্ধি পেলে অ্যালগরিদমের পারফরম্যান্সের গাণিতিক সীমানা।",
      detailsEn:
          "• Big O (O): Upper bound (Worst Case) — Guarantees algorithm will run no worse than this rate.\n"
          "• Big Omega (Ω): Lower bound (Best Case) — Minimum operations algorithm must perform.\n"
          "• Big Theta (Θ): Tight bound (Average/Exact Case) — Algorithm is bounded above and below by the same rate.",
      detailsBn:
          "• Big O (O): আপার বাউন্ড (Worst Case) — গ্যারান্টি দেয় যে অ্যালগরিদম এর চেয়ে খারাপ পারফর্ম করবে না।\n"
          "• Big Omega (Ω): লোয়ার বাউন্ড (Best Case) — অ্যালগরিদমের সর্বনিম্ন অপারেশনের সংখ্যা।\n"
          "• Big Theta (Θ): টাইট বাউন্ড (Exact Case) — উপরের ও নিচের উভয় সীমানা একই গ্রোথ রেটে থাকে।",
      keyTakeawaysEn: [
        "Software Engineers primary focus is Big O (Worst Case).",
        "Big O describes growth rate, NOT exact execution time in milliseconds.",
        "O(g(n)) means execution time <= c * g(n) for large n."
      ],
      keyTakeawaysBn: [
        "সফটওয়্যার ইঞ্জিনিয়ারদের মূল ফোকাস থাকে Big O (Worst Case) এর উপর।",
        "Big O মিলিসেকেন্ডের সময় মাপেনা, গ্রোথ রেট বা অপারেশনের অনুপাত নির্দেশ করে।",
        "O(g(n)) নির্দেশ করে টিপিক্যাল এক্সিকিউশন c * g(n) এর চেয়ে ছোট বা সমান।"
      ],
      codeExample: """
// Asymptotic Notation Comparison
void demonstrateNotations(int n) {
  // Best Case: Ω(1) if target is first element
  // Worst Case: O(N) if target is last element or missing
  // Average Case: Θ(N/2) -> Θ(N) linear scan
}""",
      quizQuestionEn: "Which notation guarantees the upper bound (worst-case scenario) of an algorithm?",
      quizQuestionBn: "কোন নোটেশনটি অ্যালগরিদমের আপার বাউন্ড (ওয়ার্স্ট-কেস পরিস্থিতি) গ্যারান্টি দেয়?",
      quizOptionsEn: ["Big O (O)", "Big Omega (Ω)", "Big Theta (Θ)", "Alpha (α)"],
      quizOptionsBn: ["Big O (O)", "Big Omega (Ω)", "Big Theta (Θ)", "Alpha (α)"],
      correctOptionIndex: 0,
      quizExplanationEn: "Big O represents the upper bound, guaranteeing the maximum operations an algorithm will perform in the worst case.",
      quizExplanationBn: "Big O হলো আপার বাউন্ড যা ওয়ার্স্ট কেসে সর্বোচ্চ অপারেশনের সংখ্যা গ্যারান্টি দেয়।",
    ),
    SubTopicItem(
      id: 2,
      titleEn: "2. Common Complexity Classes & Growth Ranking",
      titleBn: "২. সাধারণ কমপ্লেক্সিটি ক্লাস ও গ্রোথ রেট র‍্যাঙ্কিং",
      icon: Icons.format_list_numbered_rounded,
      color: const Color(0xFF3B82F6),
      summaryEn: "Hierarchy of speed from fastest O(1) to slowest O(N!).",
      summaryBn: "সবচেয়ে দ্রুত O(1) থেকে সবচেয়ে ধীর O(N!) পর্যন্ত গ্রোথ রেটের হায়ারার্কি।",
      detailsEn:
          "Order of Growth (Fastest to Slowest):\n"
          "1. O(1) — Constant Time (Instant lookup)\n"
          "2. O(log N) — Logarithmic (Halving problem size)\n"
          "3. O(N) — Linear (Single scan)\n"
          "4. O(N log N) — Linearithmic (Optimal comparison sorting)\n"
          "5. O(N²) — Quadratic (Double nested loops)\n"
          "6. O(2ᴺ) — Exponential (Subsets & recursive brute force)\n"
          "7. O(N!) — Factorial (Permutations generation)",
      detailsBn:
          "দ্রুততম থেকে ধীরতমের ক্রম:\n"
          "১. O(1) — কনস্ট্যান্ট টাইম (ইনস্ট্যান্ট অ্যাক্সেস)\n"
          "২. O(log N) — লগেরিথমিক (অর্ধেক হয়ে যাওয়া সমস্যা)\n"
          "৩. O(N) — লিনিয়ার (একক লুপ)\n"
          "৪. O(N log N) — লিনিয়ারিজমিক (সেরা কম্পারিজন সর্টিং)\n"
          "৫. O(N²) — কোয়াড্রাটিক (নেসটেড লুপ)\n"
          "৬. O(2ᴺ) — এক্সপোনেনশিয়াল (সাবসেট ও ব্রুটফোর্স)\n"
          "৭. O(N!) — ফ্যাক্টোরিয়াল (পারমিউটেশন জেনারেশন)",
      keyTakeawaysEn: [
        "Aim for O(1), O(log N), or O(N) in production code.",
        "O(N log N) is acceptable for sorting up to 10^6 elements.",
        "O(N²) fails for N > 10,000 in 1 second time limits."
      ],
      keyTakeawaysBn: [
        "প্রোডাকশন কোডে O(1), O(log N), অথবা O(N) অর্জনের চেষ্টা করুন।",
        "১০^৬ এলিমেন্ট সর্ট করতে O(N log N) পারফেক্ট কাজ করে।",
        "১ সেকেন্ড টাইম লিমিটে N > ১০,০০০ হলে O(N²) অ্যালগরিদম টাইমআউট খায়।"
      ],
      codeExample: """
// Growth Classes Summary
// O(1) < O(log N) < O(N) < O(N log N) < O(N^2) < O(2^N) < O(N!)""",
      quizQuestionEn: "Which time complexity scales the fastest and is most efficient for large input size N?",
      quizQuestionBn: "কোন টাইম কমপ্লেক্সিটিটি সবচেয়ে দ্রুত কাজ করে এবং বড় ইনপুট N এর জন্য সবচেয়ে দক্ষ?",
      quizOptionsEn: ["O(N^2)", "O(N log N)", "O(log N)", "O(2^N)"],
      quizOptionsBn: ["O(N^2)", "O(N log N)", "O(log N)", "O(2^N)"],
      correctOptionIndex: 2,
      quizExplanationEn: "O(log N) grows extremely slowly because the problem size is halved at each step.",
      quizExplanationBn: "O(log N) অত্যন্ত ধীরে বাড়ে কারণ প্রতি পদক্ষেপে সমস্যা অর্ধেক হয়ে যায়।",
    ),
    SubTopicItem(
      id: 3,
      titleEn: "3. Space Complexity & Call Stack Overhead",
      titleBn: "৩. স্পেস কমপ্লেক্সিটি ও কল স্ট্যাক মেমোরি বিশ্লেষণ",
      icon: Icons.memory_rounded,
      color: const Color(0xFF8B5CF6),
      summaryEn: "Total memory used by algorithm including Auxiliary space and Recursion Call Stack.",
      summaryBn: "অ্যালগরিদম দ্বারা ব্যবহৃত মোট মেমোরি (অক্সিলিয়ারি স্পেস ও রিকার্শন কল স্ট্যাকসহ)।",
      detailsEn:
          "• Auxiliary Space: Extra space used by data structures (arrays, hash tables, matrices).\n"
          "• Total Space: Input size + Auxiliary Space.\n"
          "• Call Stack Overhead: Every recursive function call occupies stack memory frames proportional to recursion depth.",
      detailsBn:
          "• অক্সিলিয়ারি স্পেস: অতিরিক্ত ডাটা স্ট্রাকচার (অ্যারে, হ্যাশ ম্যাপ, ম্যাট্রিক্স) দ্বারা মেমোরি।\n"
          "• মোট স্পেস: ইনপুট সাইজ + অক্সিলিয়ারি স্পেস।\n"
          "• কল স্ট্যাক ওভারহেড: প্রতিটি রিকার্সিভ ফাংশন কল মেমোরিতে স্ট্যাক ফ্রেম তৈরি করে।",
      keyTakeawaysEn: [
        "Recursive Depth of N requires O(N) call stack space.",
        "In-Place algorithms use O(1) auxiliary space.",
        "Tree recursion space equals maximum depth (height H) of the tree."
      ],
      keyTakeawaysBn: [
        "N গভীরতার রিকার্শনে O(N) কল স্ট্যাক মেমোরি লাগে।",
        "In-Place অ্যালগরিদম কোনো অতিরিক্ত O(1) স্পেস ছাড়া ইনপুট রূপান্তর করে।",
        "ট্রি রিকার্শনের মেমোরি স্পেস ট্রির সর্বোচ্চ উচ্চতা H এর সমান।"
      ],
      codeExample: """
// Recursive Call Stack O(N) Space Complexity
int factorial(int n) {
  if (n <= 1) return 1;
  return n * factorial(n - 1); // Depth n stack frame
}""",
      quizQuestionEn: "What is the memory space complexity of a recursive algorithm with recursion depth N?",
      quizQuestionBn: "N গভীরতার একটি রিকার্সিভ অ্যালগরিদমের মেমোরি স্পেস কমপ্লেক্সিটি কত?",
      quizOptionsEn: ["O(1)", "O(log N)", "O(N)", "O(N^2)"],
      quizOptionsBn: ["O(1)", "O(log N)", "O(N)", "O(N^2)"],
      correctOptionIndex: 2,
      quizExplanationEn: "Each recursive call adds a stack frame, resulting in O(N) call stack space memory allocation.",
      quizExplanationBn: "প্রতিটি রিকার্সিভ কলের জন্য স্ট্যাক ফ্রেম যুক্ত হয়ে O(N) কল স্ট্যাক মেমোরি তৈরি হয়।",
    ),
    SubTopicItem(
      id: 4,
      titleEn: "4. Four Core Rules for Calculating Big O",
      titleBn: "৪. বিগ ও (Big O) হিসাব করার ৪টি মৌলিক নিয়ম",
      icon: Icons.checklist_rtl_rounded,
      color: const Color(0xFF10B981),
      summaryEn: "Simplification rules to reduce complex code blocks into a single Big O term.",
      summaryBn: "জটিল কোড ব্লককে একক বিগ ও টার্মে রূপান্তর করার সহজ সরলীকরণ নিয়ম।",
      detailsEn:
          "• Rule 1: Drop Constants — O(2N) becomes O(N). Constant multipliers don't change asymptotic growth rate.\n"
          "• Rule 2: Drop Non-Dominant Terms — O(N² + N + 500) becomes O(N²).\n"
          "• Rule 3: Additive Sequential Statements — O(A) + O(B) = O(A + B).\n"
          "• Rule 4: Multiplicative Nested Loops — Nested loop over A and B = O(A * B).",
      detailsBn:
          "• নিয়ম ১: কনস্ট্যান্ট বাদ দিন — O(2N) পরিবর্তিত হয়ে O(N) হয়।\n"
          "• নিয়ম ২: ছোট পদ বাদ দিন — O(N² + N + ৫০০) হবে O(N²)।\n"
          "• নিয়ম ৩: পর পর কোড ব্লক যোগ হয় — O(A) + O(B) = O(A + B)।\n"
          "• নিয়ম ৪: নেসটেড লুপ গুণ হয় — A ও B এর উপর নেসটেড লুপ = O(A * B)।",
      keyTakeawaysEn: [
        "Focus on the worst-performing term when N approaches infinity.",
        "Sequential loops add together: O(N) + O(N) = O(2N) -> O(N).",
        "Nested loops multiply: for i in N { for j in M } -> O(N * M)."
      ],
      keyTakeawaysBn: [
        "N অসীমের কাছাকাছি গেলে সবচেয়ে বড় টার্মের উপর ফোকাস করুন।",
        "পর পর দুটি আলাদা লুপ থাকলে যোগ হবে: O(N) + O(N) = O(N)।",
        "লুপের ভেতর লুপ থাকলে গুণ হবে: for i in N { for j in M } -> O(N * M)।"
      ],
      codeExample: """
void calculateBigO(List<int> a, List<int> b) {
  // Step 1: O(A)
  for (int x in a) print(x);
  
  // Step 2: O(B)
  for (int y in b) print(y);
  
  // Total: O(A + B)
}""",
      quizQuestionEn: "What is the simplified Big O complexity for an algorithm taking O(N^2 + 50N + 1000) operations?",
      quizQuestionBn: "একটি অ্যালগরিদম O(N^2 + 50N + 1000) অপারেশন নিলে এর সরলীকৃত বিগ ও কত হবে?",
      quizOptionsEn: ["O(N)", "O(50N)", "O(N^2)", "O(N^3)"],
      quizOptionsBn: ["O(N)", "O(50N)", "O(N^2)", "O(N^3)"],
      correctOptionIndex: 2,
      quizExplanationEn: "By dropping constants and non-dominant terms, O(N^2 + 50N + 1000) simplifies to O(N^2).",
      quizExplanationBn: "কনস্ট্যান্ট ও ছোট পদগুলো বাদ দিলে O(N^2 + 50N + 1000) সরল হয়ে O(N^2) হয়।",
    ),
    SubTopicItem(
      id: 5,
      titleEn: "5. Amortized Complexity (Dynamic Capacity Doubling)",
      titleBn: "৫. অ্যামোরটাইজড কমপ্লেক্সিটি (ডায়নামিক ক্যাপাসিটি ডাবলিং)",
      icon: Icons.trending_down_rounded,
      color: const Color(0xFFF59E0B),
      summaryEn: "Average time per operation over a series of operations, even if one single operation is expensive.",
      summaryBn: "একক অপারেশনে বেশি সময় লাগলেও টানা অনেকগুলো অপারেশনের গড়ে অর্জিত সময়।",
      detailsEn:
          "• Dynamic Array Resizing (Vector / ArrayList push_back):\n"
          "  - Inserting N elements requires array doubling at sizes 1, 2, 4, 8, 16...\n"
          "  - Total copies over N insertions = 1 + 2 + 4 + ... + N = 2N - 1 = O(N).\n"
          "  - Amortized time per insertion = O(N) / N = O(1) constant time!",
      detailsBn:
          "• ডায়নামিক অ্যারে মেমোরি ডাবলিং (Vector / ArrayList push_back):\n"
          "  - N টি এলিমেন্ট যুক্ত করতে ১, ২, ৪, ৮, ১৬ সাইজে কপি করতে হয়।\n"
          "  - মোট কপি সংখ্যা = ১ + ২ + ৪ + ... + N = ২N - ১ = O(N)।\n"
          "  - প্রতি ইনসার্শনে গড় বা অ্যামোরটাইজড সময় = O(N) / N = O(1)!",
      keyTakeawaysEn: [
        "Amortized O(1) means individual pushes may take O(N), but overall cost is O(1) per push.",
        "Used extensively in Dynamic Arrays, Hash Table rehashing, and Union-Find."
      ],
      keyTakeawaysBn: [
        "অ্যামোরটাইজড O(1) অর্থ হলো দু-একটি ধাপে O(N) লাগলেও গড়ে প্রতিটি ইনসার্শন O(1) সময় নেয়।",
        "ডায়নামিক অ্যারে রি-সাইজিং, হ্যাশ টেবিল রি-হ্যাশিং এ এটি ব্যবহৃত হয়।"
      ],
      codeExample: """
// Dynamic Vector Amortized O(1) Push Back
List<int> dynamicArray = [];
for (int i = 0; i < n; i++) {
  dynamicArray.add(i); // Amortized O(1) time
}""",
      quizQuestionEn: "What is the amortized time complexity of inserting an element into a dynamic vector (ArrayList)?",
      quizQuestionBn: "একটি ডায়নামিক ভেক্টরে (ArrayList) উপাদান যুক্ত করার অ্যামোরটাইজড টাইম কমপ্লেক্সিটি কত?",
      quizOptionsEn: ["O(1) amortized", "O(N)", "O(log N)", "O(N^2)"],
      quizOptionsBn: ["O(1) amortized", "O(N)", "O(log N)", "O(N^2)"],
      correctOptionIndex: 0,
      quizExplanationEn: "Although array doubling takes O(N) occasionally, over N insertions the average time per insertion is O(1) amortized.",
      quizExplanationBn: "মাঝে মাঝে O(N) রি-সাইজিং লাগলেও N টি ইনসার্শনের গড়ে প্রতিটিতে O(1) সময় লাগে।",
    ),
    SubTopicItem(
      id: 6,
      titleEn: "6. Best vs Average vs Worst Case Analysis",
      titleBn: "৬. বেস্ট বনাম এভারেজ বনাম ওয়ার্স্ট কেস অ্যানালাইসিস",
      icon: Icons.pie_chart_outline_rounded,
      color: const Color(0xFFEF4444),
      summaryEn: "Evaluating how algorithm performance varies based on input data arrangement.",
      summaryBn: "ইনপুট ডাটা সাজানোর ওপর ভিত্তি করে অ্যালগরিদমের পারফরম্যান্স তারতম্য বিশ্লেষণ।",
      detailsEn:
          "• Quick Sort: Best/Average = O(N log N) with balanced pivot, Worst = O(N²) with already sorted array & bad pivot.\n"
          "• Hash Table: Average = O(1) lookup, Worst = O(N) when all keys hash to the same bucket (collision).\n"
          "• Linear Search: Best = O(1) at first index, Worst = O(N) at end or not present.",
      detailsBn:
          "• কুইক সর্ট: ব্যালেন্সড পিবট হলে Best/Average = O(N log N), কিন্তু খারাপ পিবটে Worst = O(N²)।\n"
          "• হ্যাশ টেবিল: সাধারণ Average = O(1), কিন্তু অতিরিক্ত কলিশন হলে Worst = O(N)।\n"
          "• লিনিয়ার সার্চ: শুরুতে থাকলে Best = O(1), শেষে বা না থাকলে Worst = O(N)।",
      keyTakeawaysEn: [
        "Always design algorithms assuming the Worst Case scenario.",
        "Use randomized pivots or dual-pivot logic to guarantee average case in Quick Sort."
      ],
      keyTakeawaysBn: [
        "কোড ডিজাইন করার সময় সবসময় Worst Case বিবেচনা করুন।",
        "কুইক সর্টে র‍্যান্ডম পিবট ব্যবহার করে O(N log N) নিশ্চিত রাখা হয়।"
      ],
      codeExample: """
// Linear Search Cases
int search(List<int> arr, int target) {
  for (int i = 0; i < arr.length; i++) {
    if (arr[i] == target) return i; // Best: O(1), Worst: O(N)
  }
  return -1;
}""",
      quizQuestionEn: "What is the worst-case time complexity of Quick Sort when selecting a bad pivot on an already sorted array?",
      quizQuestionBn: "সর্ট করা অ্যারেতে খারাপ পিবট সিলেক্ট করলে কুইক সর্টের ওয়ার্স্ট-কেস টাইম কমপ্লেক্সিটি কত হয়?",
      quizOptionsEn: ["O(N log N)", "O(N^2)", "O(N)", "O(1)"],
      quizOptionsBn: ["O(N log N)", "O(N^2)", "O(N)", "O(1)"],
      correctOptionIndex: 1,
      quizExplanationEn: "Without randomized pivot selection, Quick Sort degenerates to quadratic O(N^2) worst case on sorted arrays.",
      quizExplanationBn: "খারাপ পিবটের কারণে কুইক সর্ট ডিমোট হয়ে O(N^2) ওয়ার্স্ট কেসে রূপ নেয়।",
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
              _isEnglish
                  ? '$label copied to clipboard!'
                  : '$label কোড ক্লিপবোর্ডে কপি হয়েছে!',
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

  void _openSubTopicDetailModal(SubTopicItem subTopic) {
    if (subTopic.id == 1) {
      Navigator.of(context).pushNamed(AppRoutes.asymptoticNotations);
    } else if (subTopic.id == 2) {
      Navigator.of(context).pushNamed(AppRoutes.complexityClasses);
    } else if (subTopic.id == 3) {
      Navigator.of(context).pushNamed(AppRoutes.spaceComplexity);
    } else if (subTopic.id == 4) {
      Navigator.of(context).pushNamed(AppRoutes.bigORules);
    } else if (subTopic.id == 5) {
      Navigator.of(context).pushNamed(AppRoutes.amortizedComplexity);
    } else if (subTopic.id == 6) {
      Navigator.of(context).pushNamed(AppRoutes.bestWorstCase);
    } else {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => _buildSubTopicModalContent(subTopic),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final hPadding = Responsive.horizontalPadding(context);

    return Scaffold(
      backgroundColor: AppTheme.primaryDark,
      appBar: AppBar(
        title: Text(
          '1. Time & Space Complexity (Big O)',
          style: TextStyle(
            fontSize: Responsive.sp(context, 16),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: TextButton.icon(
              style: TextButton.styleFrom(
                backgroundColor: AppTheme.accentPurple.withOpacity(0.2),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              icon: Icon(
                Icons.language,
                color: _isEnglish ? AppTheme.accentNeonCyan : AppTheme.accentPink,
                size: Responsive.sp(context, 18),
              ),
              label: Text(
                _isEnglish ? 'EN' : 'BN',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: Responsive.sp(context, 13)),
              ),
              onPressed: () {
                setState(() {
                  _isEnglish = !_isEnglish;
                });
              },
            ),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppTheme.accentNeonCyan,
          labelColor: AppTheme.accentNeonCyan,
          unselectedLabelColor: AppTheme.textSecondary,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          padding: EdgeInsets.zero,
          labelStyle: TextStyle(
              fontSize: Responsive.sp(context, 14), fontWeight: FontWeight.bold),
          unselectedLabelStyle:
              TextStyle(fontSize: Responsive.sp(context, 13)),
          tabs: [
            Tab(text: _isEnglish ? '📌 Sub-Topics List' : '📌 সকল সাব-টপিক লিস্ট'),
            Tab(text: _isEnglish ? '📊 Growth Rate Visualizer' : '📊 গ্রোথ রেট ভিজ্যুয়ালাইজার'),
            Tab(text: _isEnglish ? '⚡ Code Examples' : '⚡ কোড উদাহরণ'),
            Tab(text: _isEnglish ? '💡 Practice & Master Quiz' : '💡 প্র্যাকটিস ও মাস্টার কুইজ'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildAllSubTopicsTab(hPadding),
          _buildGrowthRateVisualizerTab(hPadding),
          _buildCodeExamplesTab(hPadding),
          _buildQuizAndBestPracticesTab(hPadding),
        ],
      ),
    );
  }

  // TAB 1: List of All Sub-topics in Clean Card Grid/List Format
  Widget _buildAllSubTopicsTab(double hPadding) {
    final isMobile = Responsive.isMobile(context);

    return ResponsiveCenter(
      maxWidth: 1280.0,
      padding: EdgeInsets.all(hPadding),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header summary
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(Responsive.sp(context, 16)),
              decoration: BoxDecoration(
                color: AppTheme.surfaceDark,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.accentNeonCyan.withOpacity(0.4)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _isEnglish
                        ? 'Topic 1: Time & Space Complexity (Big O) Sub-Topics'
                        : 'টপিক ১: টাইম ও স্পেস কমপ্লেক্সিটি (Big O) এর সকল সাব-টপিক',
                    style: TextStyle(
                      fontSize: Responsive.sp(context, 18),
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _isEnglish
                        ? 'Explore the 6 fundamental sub-topics below to master algorithm performance analysis, memory overhead, and Big O calculation rules!'
                        : 'অ্যালগরিদম পারফরম্যান্স বিশ্লেষণ, মেমোরি ওভারহেড এবং বিগ ও হিসাবের ৬টি মৌলিক সাব-টপিক বিস্তারিত জানতে নিচে ক্লিক করুন!',
                    style: TextStyle(
                      fontSize: Responsive.sp(context, 13),
                      color: AppTheme.textSecondary,
                      height: 1.45,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: AppTheme.accentPurple.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _isEnglish
                          ? 'Total Sub-Topics: ${_subTopics.length} Core Modules'
                          : 'মোট সাব-টপিক: ${_subTopics.length} টি কোর মডিউল',
                      style: TextStyle(
                        color: AppTheme.accentNeonCyan,
                        fontWeight: FontWeight.bold,
                        fontSize: Responsive.sp(context, 12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Sub-Topics List Cards
            Text(
              _isEnglish ? '📚 Sub-Topics Modules List:' : '📚 সাব-টপিকস মডিউলসমূহ:',
              style: TextStyle(
                fontSize: Responsive.sp(context, 16),
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),

            ..._subTopics.map((subTopic) {
              return InkWell(
                onTap: () => _openSubTopicDetailModal(subTopic),
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 14),
                  padding: EdgeInsets.all(Responsive.sp(context, 14)),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceDark,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFF334155)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: subTopic.color.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(subTopic.icon,
                              color: subTopic.color, size: 22),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _isEnglish
                                    ? subTopic.titleEn
                                    : subTopic.titleBn,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: Responsive.sp(context, 15),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _isEnglish
                                    ? subTopic.summaryEn
                                    : subTopic.summaryBn,
                                style: TextStyle(
                                  color: AppTheme.textSecondary,
                                  fontSize: Responsive.sp(context, 12.5),
                                  height: 1.35,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Divider(height: 1, color: Color(0xFF334155)),
                    const SizedBox(height: 12),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: subTopic.color.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            _isEnglish ? "Module #${subTopic.id}" : "মডিউল #${subTopic.id}",
                            style: TextStyle(
                                color: subTopic.color,
                                fontWeight: FontWeight.bold,
                                fontSize: Responsive.sp(context, 11)),
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () => _openSubTopicDetailModal(subTopic),
                          icon: Icon(Icons.star_rounded,
                              size: 16, color: AppTheme.accentGreen),
                          label: Text(
                            _isEnglish ? "⭐ Try Topic & Quiz" : "⭐ সাব-টপিক ও কুইজ",
                            style: TextStyle(
                                fontSize: Responsive.sp(context, 12),
                                fontWeight: FontWeight.bold),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.accentPurple,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // TAB 2: Growth Rate Visualizer
  Widget _buildGrowthRateVisualizerTab(double hPadding) {
    return ResponsiveCenter(
      maxWidth: 1280.0,
      padding: EdgeInsets.all(hPadding),
      child: TimeSpaceComplexityCodeFreeVisualizer(isEnglish: _isEnglish),
    );
  }

  // TAB 3: Code Examples in C++, Java, Python, Dart
  Widget _buildCodeExamplesTab(double hPadding) {
    return ResponsiveCenter(
      maxWidth: 1280.0,
      padding: EdgeInsets.all(hPadding),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _isEnglish
                  ? "⚡ Big O Code Implementations"
                  : "⚡ বিভিন্ন বিগ ও (Big O) টাইম কমপ্লেক্সিটির কোড উদাহরণ",
              style: TextStyle(
                fontSize: Responsive.sp(context, 18),
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),

            Row(
              children: ["C++", "Java", "Python", "Dart"].map((lang) {
                final isSel = _selectedCodeLang == lang;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(lang,
                        style: TextStyle(fontSize: Responsive.sp(context, 12))),
                    selected: isSel,
                    selectedColor: AppTheme.accentPurple,
                    backgroundColor: AppTheme.surfaceDark,
                    labelStyle: TextStyle(
                      color: isSel ? Colors.white : AppTheme.textSecondary,
                      fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
                    ),
                    onSelected: (val) {
                      if (val) {
                        setState(() {
                          _selectedCodeLang = lang;
                        });
                      }
                    },
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            _buildFullCodeSnippet(_selectedCodeLang),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // TAB 4: Practice & Master Quiz
  Widget _buildQuizAndBestPracticesTab(double hPadding) {
    return ResponsiveCenter(
      maxWidth: 1280.0,
      padding: EdgeInsets.all(hPadding),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Quiz Score Card Header
            Container(
              padding: EdgeInsets.all(Responsive.sp(context, 16)),
              decoration: BoxDecoration(
                color: AppTheme.surfaceDark,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.accentPurple),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _isEnglish
                            ? "🧠 Master Quiz Score:"
                            : "🧠 মাস্টার কুইজ স্কোর:",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: Responsive.sp(context, 15),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _isEnglish
                            ? "$_quizScore / ${_subTopics.length} Correct Answers"
                            : "$_quizScore / ${_subTopics.length} সঠিক উত্তর",
                        style: TextStyle(
                          color: AppTheme.accentGreen,
                          fontWeight: FontWeight.bold,
                          fontSize: Responsive.sp(context, 13),
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        _userAnswers.clear();
                        _quizSubmitted.clear();
                        _quizScore = 0;
                      });
                    },
                    icon: const Icon(Icons.refresh, size: 16),
                    label: Text(_isEnglish ? "Reset Quiz" : "রিসেট কুইজ"),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryDark),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Quiz Questions List
            ..._subTopics.map((subTopic) {
              final userAns = _userAnswers[subTopic.id];
              final isSubmitted = _quizSubmitted[subTopic.id] ?? false;

              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: EdgeInsets.all(Responsive.sp(context, 16)),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceDark,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFF334155)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Q${subTopic.id}. ${_isEnglish ? subTopic.quizQuestionEn : subTopic.quizQuestionBn}",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: Responsive.sp(context, 14),
                      ),
                    ),
                    const SizedBox(height: 12),

                    ...List.generate(
                        _isEnglish
                            ? subTopic.quizOptionsEn.length
                            : subTopic.quizOptionsBn.length, (optIdx) {
                      final optText = _isEnglish
                          ? subTopic.quizOptionsEn[optIdx]
                          : subTopic.quizOptionsBn[optIdx];
                      final isSelected = userAns == optIdx;
                      final isCorrect = optIdx == subTopic.correctOptionIndex;

                      Color btnColor = AppTheme.primaryDark;
                      Color borderColor = const Color(0xFF334155);

                      if (isSubmitted) {
                        if (isCorrect) {
                          btnColor = AppTheme.accentGreen.withOpacity(0.2);
                          borderColor = AppTheme.accentGreen;
                        } else if (isSelected) {
                          btnColor = AppTheme.accentPink.withOpacity(0.2);
                          borderColor = AppTheme.accentPink;
                        }
                      } else if (isSelected) {
                        btnColor = AppTheme.accentPurple.withOpacity(0.3);
                        borderColor = AppTheme.accentPurple;
                      }

                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: InkWell(
                          onTap: isSubmitted
                              ? null
                              : () {
                                  setState(() {
                                    _userAnswers[subTopic.id] = optIdx;
                                  });
                                },
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 10),
                            decoration: BoxDecoration(
                              color: btnColor,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: borderColor),
                            ),
                            child: Row(
                              children: [
                                Text(
                                  String.fromCharCode(65 + optIdx) + ") ",
                                  style: TextStyle(
                                    color: AppTheme.accentNeonCyan,
                                    fontWeight: FontWeight.bold,
                                    fontSize: Responsive.sp(context, 13),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    optText,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: Responsive.sp(context, 13),
                                    ),
                                  ),
                                ),
                                if (isSubmitted && isCorrect)
                                  const Icon(Icons.check_circle,
                                      color: AppTheme.accentGreen, size: 18)
                                else if (isSubmitted && isSelected)
                                  const Icon(Icons.cancel,
                                      color: AppTheme.accentPink, size: 18),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                    const SizedBox(height: 10),

                    if (!isSubmitted)
                      ElevatedButton(
                        onPressed: userAns == null
                            ? null
                            : () {
                                setState(() {
                                  _quizSubmitted[subTopic.id] = true;
                                  if (userAns == subTopic.correctOptionIndex) {
                                    _quizScore++;
                                  }
                                });
                              },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.accentPurple),
                        child: Text(_isEnglish ? "Submit Answer" : "উত্তর সাবমিট করুন"),
                      )
                    else
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryDark,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          "💡 ${_isEnglish ? subTopic.quizExplanationEn : subTopic.quizExplanationBn}",
                          style: TextStyle(
                            color: AppTheme.accentNeonCyan,
                            fontSize: Responsive.sp(context, 12),
                          ),
                        ),
                      ),
                  ],
                ),
              );
            }).toList(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // Interactive Sub-Topic Modal Bottom Sheet
  Widget _buildSubTopicModalContent(SubTopicItem subTopic) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      padding: EdgeInsets.all(Responsive.sp(context, 18)),
      decoration: const BoxDecoration(
        color: AppTheme.surfaceDark,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppTheme.textMuted,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 14),

          Row(
            children: [
              Icon(subTopic.icon, color: subTopic.color, size: 24),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  _isEnglish ? subTopic.titleEn : subTopic.titleBn,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: Responsive.sp(context, 16),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          const Divider(color: Color(0xFF334155)),
          const SizedBox(height: 10),

          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _isEnglish ? subTopic.detailsEn : subTopic.detailsBn,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: Responsive.sp(context, 13.5),
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 16),

                  Text(
                    _isEnglish ? "🔑 Key Rules:" : "🔑 মূল নিয়মাবলী:",
                    style: TextStyle(
                      color: subTopic.color,
                      fontWeight: FontWeight.bold,
                      fontSize: Responsive.sp(context, 14),
                    ),
                  ),
                  const SizedBox(height: 6),
                  ...(_isEnglish
                          ? subTopic.keyTakeawaysEn
                          : subTopic.keyTakeawaysBn)
                      .map((item) => Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Row(
                              children: [
                                const Icon(Icons.arrow_right,
                                    color: AppTheme.accentNeonCyan),
                                Expanded(
                                  child: Text(item,
                                      style: TextStyle(
                                          color: AppTheme.textSecondary,
                                          fontSize: Responsive.sp(context, 12.5))),
                                ),
                              ],
                            ),
                          )),
                  const SizedBox(height: 16),

                  _buildSubTopicCodeSnippet(subTopic),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubTopicCodeSnippet(SubTopicItem subTopic) {
    return Container(
      padding: EdgeInsets.all(Responsive.sp(context, 12)),
      decoration: BoxDecoration(
        color: const Color(0xFF090D16),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF1E293B)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Code Example",
                style: TextStyle(
                  color: subTopic.color,
                  fontWeight: FontWeight.bold,
                  fontSize: Responsive.sp(context, 12),
                ),
              ),
              InkWell(
                onTap: () =>
                    _copyToClipboard(subTopic.codeExample, subTopic.titleEn),
                child: Row(
                  children: [
                    Icon(Icons.copy,
                        size: Responsive.sp(context, 13),
                        color: AppTheme.accentNeonCyan),
                    const SizedBox(width: 4),
                    Text(
                      _isEnglish ? "Copy" : "কপি",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: Responsive.sp(context, 11),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Text(
              subTopic.codeExample.trim(),
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: Responsive.sp(context, 12),
                color: const Color(0xFF38BDF8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFullCodeSnippet(String lang) {
    String code = "";
    if (lang == "C++") {
      code = """
#include <iostream>
#include <vector>
#include <unordered_map>
using namespace std;

// 1. O(1) Constant Time
int getFirstElement(const vector<int>& nums) {
    return nums.empty() ? -1 : nums[0];
}

// 2. O(log N) Logarithmic Time (Binary Search)
int binarySearch(const vector<int>& nums, int target) {
    int low = 0, high = nums.size() - 1;
    while (low <= high) {
        int mid = low + (high - low) / 2;
        if (nums[mid] == target) return mid;
        if (nums[mid] < target) low = mid + 1;
        else high = mid - 1;
    }
    return -1;
}

// 3. O(N) Linear Time
int findMax(const vector<int>& nums) {
    int maxVal = nums[0];
    for (int num : nums) {
        if (num > maxVal) maxVal = num;
    }
    return maxVal;
}

// 4. O(N^2) Quadratic Time
void printPairs(const vector<int>& nums) {
    for (int i = 0; i < nums.size(); i++) {
        for (int j = 0; j < nums.size(); j++) {
            cout << nums[i] << ", " << nums[j] << endl;
        }
    }
}""";
    } else if (lang == "Java") {
      code = """
import java.util.*;

public class BigOExamples {
    // 1. O(1) Constant Time
    public static int getFirst(int[] nums) {
        return nums.length > 0 ? nums[0] : -1;
    }

    // 2. O(log N) Binary Search
    public static int binarySearch(int[] nums, int target) {
        int low = 0, high = nums.length - 1;
        while (low <= high) {
            int mid = low + (high - low) / 2;
            if (nums[mid] == target) return mid;
            if (nums[mid] < target) low = mid + 1;
            else high = mid - 1;
        }
        return -1;
    }

    // 3. O(N) Linear Scan
    public static int findMax(int[] nums) {
        int max = nums[0];
        for (int num : nums) {
            if (num > max) max = num;
        }
        return max;
    }
}""";
    } else if (lang == "Python") {
      code = """
# Big O Examples in Python

# 1. O(1) Constant Time
def get_first(nums):
    return nums[0] if nums else None

# 2. O(log N) Binary Search
def binary_search(nums, target):
    low, high = 0, len(nums) - 1
    while low <= high:
        mid = low + (high - low) // 2
        if nums[mid] == target:
            return mid
        elif nums[mid] < target:
            low = mid + 1
        else:
            high = mid - 1
    return -1

# 3. O(N) Linear Scan
def find_max(nums):
    max_val = nums[0]
    for num in nums:
        if num > max_val:
            max_val = num
    return max_val""";
    } else {
      code = """
// Big O Examples in Dart

// 1. O(1) Constant Time
int getFirst(List<int> nums) => nums.isNotEmpty ? nums[0] : -1;

// 2. O(log N) Binary Search
int binarySearch(List<int> nums, int target) {
  int low = 0, high = nums.length - 1;
  while (low <= high) {
    int mid = low + (high - low) ~/ 2;
    if (nums[mid] == target) return mid;
    if (nums[mid] < target) low = mid + 1;
    else high = mid - 1;
  }
  return -1;
}

// 3. O(N) Linear Scan
int findMax(List<int> nums) {
  int maxVal = nums[0];
  for (int num in nums) {
    if (num > maxVal) maxVal = num;
  }
  return maxVal;
}""";
    }

    return Container(
      padding: EdgeInsets.all(Responsive.sp(context, 14)),
      decoration: BoxDecoration(
        color: const Color(0xFF090D16),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF1E293B)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "$lang Solution Code",
                style: TextStyle(
                  color: AppTheme.accentNeonCyan,
                  fontWeight: FontWeight.bold,
                  fontSize: Responsive.sp(context, 13),
                ),
              ),
              ElevatedButton.icon(
                onPressed: () => _copyToClipboard(code, "$lang Solution"),
                icon: Icon(Icons.copy_all, size: Responsive.sp(context, 14)),
                label: Text(
                  _isEnglish ? "Copy Code" : "কোড কপি করুন",
                  style: TextStyle(
                      fontSize: Responsive.sp(context, 12),
                      fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.accentPurple,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Text(
              code.trim(),
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: Responsive.sp(context, 12.5),
                color: const Color(0xFF38BDF8),
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
