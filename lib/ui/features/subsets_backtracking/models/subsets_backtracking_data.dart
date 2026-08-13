class SubsetsProblem {
  final String title;
  final String difficulty; // Easy, Medium, Hard
  final List<String> companyTags;
  final String keyIdeaEn;
  final String keyIdeaBn;
  final bool isPopular;

  const SubsetsProblem({
    required this.title,
    required this.difficulty,
    required this.companyTags,
    required this.keyIdeaEn,
    required this.keyIdeaBn,
    this.isPopular = false,
  });
}

class SubsetsBacktrackingData {
  static Map<String, String> getConceptIntro(bool isEnglish) {
    if (isEnglish) {
      return {
        "title": "Subsets & Backtracking Pattern — Complete Deep Dive (C++ & FAANG Focus)",
        "summary": "Subsets & Backtracking systematically explores the entire state-space decision tree to generate combinations, permutations, and power sets (2^N or N!). Backtracking follows the classic 3-step formula: 1) Make Choice (curr.push_back(val)), 2) Explore Recursively (backtrack(...)), 3) Undo Choice (curr.pop_back()).",
        "whenToUseTitle": "When to Use Subsets & Backtracking?",
        "whenToUse1": "Generating all possible subsets (Power Set) of a given set (LeetCode 78, 90).",
        "whenToUse2": "Generating all permutations of a sequence (LeetCode 46, 47).",
        "whenToUse3": "Finding all combinations that sum to a target value (Combination Sum - LeetCode 39, 40, 216).",
        "whenToUse4": "Solving constraint satisfaction puzzles like N-Queens (LeetCode 51), Sudoku Solver (LeetCode 37), or Word Search (LeetCode 79).",
        "whenToUse5": "Generating valid parentheses or letter combinations of phone numbers.",
        "typesTitle": "3 Main Subsets & Backtracking Patterns",
        "type1Title": "1. Subsets / Power Set (Include / Exclude)",
        "type1Desc": "For each element at index start, push current subset curr to result. Loop i from start to N-1, choose nums[i], recurse backtrack(i + 1), and undo choice pop_back().",
        "type2Title": "2. Permutations (Order Matters)",
        "type2Desc": "Track visited elements using a visited boolean vector. Loop through all elements 0 to N-1. If not visited, choose, mark visited, recurse, unmark, and pop.",
        "type3Title": "3. Combinations / Combination Sum",
        "type3Desc": "Choose elements to meet target sum. If elements can be reused, recurse with same index i. If not reusable, recurse with i + 1. Sort input to skip duplicates (i > start && nums[i] == nums[i-1]).",
      };
    } else {
      return {
        "title": "Subsets & Backtracking Pattern — সম্পূর্ণ গাইড (C++ ও FAANG ফোকাস)",
        "summary": "Subsets & Backtracking হলো স্টেট-স্পেস ডিসিশন ট্রির প্রতিটি শাখা সিস্টেমেটিকভাবে ট্রাভার্স করে সব সম্ভব পরমুটেশন, কম্বিনেশন বা সাবসেট (২^N বা N!) তৈরি করা। ব্যাকট্র্যাকিং ৩টি মূল ধাপের ফর্মুলা মেনে চলে: ১) চয়েস গ্রহণ (curr.push_back), ২) রিকার্সিভ এক্সপ্লোর (backtrack), ৩) চয়েস বাতিল (curr.pop_back)।",
        "whenToUseTitle": "কখন বুঝবা Subsets & Backtracking লাগবে?",
        "whenToUse1": "একটি সেটের সবকটি সাবসেট বা পাওয়ার সেট (Power Set) তৈরি করতে বললে (LeetCode 78, 90)।",
        "whenToUse2": "সব ধরনের পারমুটেশন বা অনুক্রম (Permutations) বের করতে বললে (LeetCode 46, 47)।",
        "whenToUse3": "টার্গেট যোগফল মেলাতে সব ধরনের কম্বিনেশন (Combination Sum) বের করতে বললে (LeetCode 39, 40)।",
        "whenToUse4": "কনস্ট্রেইন্ট স্যাটিসফ্যাকশন গেম যেমন N-Queens (LeetCode 51), Sudoku (LeetCode 37) বা Word Search (LeetCode 79) সমাধান করতে।",
        "whenToUse5": "বৈধ বন্ধনী বা ফোন নম্বরের অক্ষরের কম্বিনেশন তৈরি করতে।",
        "typesTitle": "Main Types (৩ ধরনের pattern)",
        "type1Title": "১. Subsets / Power Set (ইনক্লুড/এক্সক্লুড)",
        "type1Desc": "ইনডেক্স start থেকে N-1 পর্যন্ত লুপ চালাও। `curr` ভেক্টর রেজাল্টে যোগ করো। `nums[i]` চয়েস করো, `backtrack(i + 1)` রিকার্স করো, তারপর `curr.pop_back()` দিয়ে চয়েস ক্যানসেল করো।",
        "type2Title": "২. Permutations (অনুক্ৰম বা সাজানো)",
        "type2Desc": "একটি `visited` বুলিয়ান ভেক্টর রাখো। ০ থেকে N-1 পর্যন্ত লুপে প্রতিটি অব্যবহৃত সংখ্যা সিলেক্ট করো, ভিজিটেড মার্ক করো, রিকার্স করো, এবং ব্যাকে এসে আনমার্ক করো।",
        "type3Title": "৩. Combinations / Combination Sum (টার্গেট কম্বিনেশন)",
        "type3Desc": "টার্গেট সাম না মেলা পর্যন্ত উপাদান সিলেক্ট করো। পুনরায় ব্যবহারযোগ্য হলে একই ইনডেক্স `i` পাস করো, না হলে `i + 1` পাস করো। ডুপ্লিকেট এড়াতে ইনপুট সর্ট করো।",
      };
    }
  }

  static List<SubsetsProblem> getEasyProblems() {
    return const [
      SubsetsProblem(
        title: "Binary Tree Paths",
        difficulty: "Easy",
        companyTags: ["Amazon", "Meta", "Google"],
        keyIdeaEn: "Backtracking DFS collecting all root-to-leaf paths string representations.",
        keyIdeaBn: "রুট থেকে লিফ পর্যন্ত সব পথের স্ট্রিং ব্যাকট্র্যাকিং দিয়ে সংগ্রহ করুন।",
        isPopular: true,
      ),
      SubsetsProblem(
        title: "Sum of All Subset XOR Totals",
        difficulty: "Easy",
        companyTags: ["Amazon", "Meta"],
        keyIdeaEn: "Backtracking inclusion/exclusion to compute XOR sum of all generated subsets.",
        keyIdeaBn: "সব সাবসেটের XOR যোগফল বের করতে ব্যাকট্র্যাকিং ব্যবহার করুন।",
        isPopular: true,
      ),
      SubsetsProblem(
        title: "Letter Case Permutation",
        difficulty: "Easy",
        companyTags: ["Meta", "Amazon"],
        keyIdeaEn: "Backtracking branching on upper and lowercase character decisions.",
        keyIdeaBn: "অক্ষরের বড় ও ছোট হাতের সিদ্ধান্তের ওপর ভিত্তি করে ব্যাকট্র্যাক করুন।",
      ),
      SubsetsProblem(
        title: "Count of Matches in Tournament",
        difficulty: "Easy",
        companyTags: ["Amazon", "Meta"],
        keyIdeaEn: "Recursive simulation of tournament bracket matches.",
        keyIdeaBn: "টুর্নামেন্টের ম্যাচ সংখ্যা গণনা করার রিকার্সিভ সমাধান।",
      ),
      SubsetsProblem(
        title: "Fair Distribution of Cookies (Easy Variant)",
        difficulty: "Easy",
        companyTags: ["Google", "Amazon"],
        keyIdeaEn: "Backtracking assignment of cookie bags to children.",
        keyIdeaBn: "শিশুদের মাঝে কুকিজ বন্টনের ব্যাকট্র্যাকিং।",
      ),
      SubsetsProblem(
        title: "Generate Parentheses (Easy Variant)",
        difficulty: "Easy",
        companyTags: ["Amazon", "Meta"],
        keyIdeaEn: "Backtracking tracking open and close parenthesis counts.",
        keyIdeaBn: "ওপেন ও ক্লোজ বন্ধনীর সংখ্যা মেপে ব্যাকট্র্যাক করুন।",
      ),
      SubsetsProblem(
        title: "Combinations (Easy Variant)",
        difficulty: "Easy",
        companyTags: ["Google", "Amazon"],
        keyIdeaEn: "Backtracking selecting K numbers out of 1 to N.",
        keyIdeaBn: "১ থেকে N থেকে K টি সংখ্যা বাছার কম্বিনেশন।",
      ),
      SubsetsProblem(
        title: "Subsets (Easy Variant)",
        difficulty: "Easy",
        companyTags: ["Amazon", "Meta"],
        keyIdeaEn: "Power set generation via simple recursive inclusion/exclusion.",
        keyIdeaBn: "সহজ রিকার্শনে পাওয়ার সেট সাবসেট তৈরি করুন।",
      ),
    ];
  }

  static List<SubsetsProblem> getMediumProblems() {
    return const [
      SubsetsProblem(
        title: "Subsets",
        difficulty: "Medium",
        companyTags: ["Meta", "Amazon", "Google", "Microsoft", "Bloomberg"],
        keyIdeaEn: "Classic Backtracking pattern generating all 2^N unique subsets.",
        keyIdeaBn: "ক্লাসিক্যাল ব্যাকট্র্যাকিং দিয়ে ২^N টি ইউনিক সাবসেট তৈরি করুন।",
        isPopular: true,
      ),
      SubsetsProblem(
        title: "Subsets II (With Duplicates)",
        difficulty: "Medium",
        companyTags: ["Meta", "Amazon", "Google"],
        keyIdeaEn: "Sort array first. Skip duplicate adjacent elements (if i > start && nums[i] == nums[i-1]) to avoid duplicate subsets.",
        keyIdeaBn: "ইনপুট সর্ট করে পাশাপাশি ডুপ্লিকেট বাদ দিয়ে ইউনিক সাবসেট পান।",
        isPopular: true,
      ),
      SubsetsProblem(
        title: "Permutations",
        difficulty: "Medium",
        companyTags: ["Meta", "Amazon", "Google", "Microsoft"],
        keyIdeaEn: "Backtracking with visited boolean array to generate all N! orderings.",
        keyIdeaBn: "ভিজিটেড এরে দিয়ে সব N! টি পারমুটেশন বের করুন।",
        isPopular: true,
      ),
      SubsetsProblem(
        title: "Permutations II (With Duplicates)",
        difficulty: "Medium",
        companyTags: ["Meta", "Amazon", "Google"],
        keyIdeaEn: "Sort array first. Skip duplicate visited choices (if i > 0 && nums[i] == nums[i-1] && !visited[i-1]).",
        keyIdeaBn: "সর্ট করে অব্যবহৃত ডুপ্লিকেট সংখ্যা স্কিপ করে ব্যাকট্র্যাক করুন।",
        isPopular: true,
      ),
      SubsetsProblem(
        title: "Combination Sum",
        difficulty: "Medium",
        companyTags: ["Meta", "Amazon", "Google", "Microsoft", "Bloomberg"],
        keyIdeaEn: "Backtracking allowing candidate element reuse (recurse with same index i).",
        keyIdeaBn: "একই উপাদান একাধিকবার ব্যবহারের সুযোগ রেখে ব্যাকট্র্যাক করুন।",
        isPopular: true,
      ),
      SubsetsProblem(
        title: "Combination Sum II",
        difficulty: "Medium",
        companyTags: ["Meta", "Amazon", "Google"],
        keyIdeaEn: "Sort array first, single use per element (recurse i + 1), skip duplicate elements.",
        keyIdeaBn: "সর্ট করে প্রতিটি উপাদান ১ বার ব্যবহার করে ডুপ্লিকেট স্কিপ করুন।",
      ),
      SubsetsProblem(
        title: "Letter Combinations of a Phone Number",
        difficulty: "Medium",
        companyTags: ["Meta", "Amazon", "Google", "Microsoft"],
        keyIdeaEn: "Backtracking mapping digits to phone keypad characters.",
        keyIdeaBn: "ডিজিট দিয়ে কিপ্যাডের অক্ষর ম্যাপিং ব্যাকট্র্যাক করুন।",
      ),
      SubsetsProblem(
        title: "Word Search",
        difficulty: "Medium",
        companyTags: ["Meta", "Amazon", "Google", "Microsoft", "Bloomberg"],
        keyIdeaEn: "2D Grid Backtracking DFS with temporary character masking.",
        keyIdeaBn: "২D গ্রিড ব্যাকট্র্যাকিং DFS দিয়ে শব্দ মেলান।",
      ),
    ];
  }

  static List<SubsetsProblem> getHardProblems() {
    return const [
      SubsetsProblem(
        title: "N-Queens",
        difficulty: "Hard",
        companyTags: ["Amazon", "Meta", "Google", "Microsoft"],
        keyIdeaEn: "Backtracking placing N non-attacking queens on N x N board. Track cols, main Diag (r-c), anti Diag (r+c).",
        keyIdeaBn: "কলাম ও ডায়াগোনাল ট্র্যাক করে N x N বোর্ডে রানী বসানোর ব্যাকট্র্যাকিং।",
        isPopular: true,
      ),
      SubsetsProblem(
        title: "Sudoku Solver",
        difficulty: "Hard",
        companyTags: ["Google", "Amazon", "Meta", "Microsoft"],
        keyIdeaEn: "Backtracking 9x9 grid placing digits 1-9 checking row, col, and 3x3 box validity.",
        keyIdeaBn: "সারি, কলাম ও ৩x৩ বক্স ভ্যালিডিটি দিয়ে সুডোকু সলভ করুন।",
        isPopular: true,
      ),
      SubsetsProblem(
        title: "Palindrome Partitioning",
        difficulty: "Hard",
        companyTags: ["Meta", "Amazon", "Google"],
        keyIdeaEn: "Backtracking string partitioning checking if substring is palindrome.",
        keyIdeaBn: "সাবস্ট্রিং প্যালিন্ড্রোম কিনা চেক করে স্ট্রিং পার্টিশন করুন।",
      ),
    ];
  }

  static List<Map<String, String>> getCommonMistakes(bool isEnglish) {
    if (isEnglish) {
      return [
        {
          "title": "1. Forgetting to Backtrack (`curr.pop_back()`)",
          "desc": "Modifying the current path array without popping the last choice distorts all subsequent recursive branches!"
        },
        {
          "title": "2. Not Handling Duplicates Correctly",
          "desc": "In Subsets II / Combination Sum II, failing to sort the input first and skip adjacent duplicates (`if (i > start && nums[i] == nums[i-1]) continue;`) causes duplicate output subsets."
        },
        {
          "title": "3. Wrong Index in Recursive Call (`i` vs `start`)",
          "desc": "In Subsets, passing `backtrack(start + 1)` instead of `backtrack(i + 1)` causes infinite loops or duplicate element selections."
        },
        {
          "title": "4. Passing State Vector by Value Overhead",
          "desc": "Passing `vector<int> curr` by value instead of constant reference `vector<int>& curr` creates heavy memory allocation overhead on every stack frame."
        },
        {
          "title": "5. Missing Base Case / Boundary Check",
          "desc": "Failing to check if targetSum < 0 or index >= N causes infinite recursion stack overflow crashes."
        },
      ];
    } else {
      return [
        {
          "title": "১. ব্যাকট্র্যাক করতে ভুলে যাওয়া (`curr.pop_back()`)",
          "desc": "রিকার্সিভ কল শেষ করে আসার পর `curr.pop_back()` দিয়ে চয়েস বাতিল না করলে পরবর্তী সব ব্রাঞ্চের ফলাফল ভুল আসবে!"
        },
        {
          "title": "২. ডুপ্লিকেট উপাদান না ছেঁটে ফেলা",
          "desc": "Subsets II এ ইনপুট সর্ট না করে পাশাপাশি ডুপ্লিকেট (`if (i > start && nums[i] == nums[i-1]) continue;`) স্কিপ না করলে রেজাল্টে একই সাবসেট বারবার আসবে।"
        },
        {
          "title": "৩. রিকার্সিভ কলে ভুল ইনডেক্স পাস করা (`start + 1` এর বদলে `i + 1`)",
          "desc": "লুপের ভেতর `i + 1` পাস করার জায়গায় `start + 1` পাস করলে অসীম লুপ তৈরি হবে।"
        },
        {
          "title": "৪. ভেক্টর বাই-রেফারেন্স (`&`) পাস না করা",
          "desc": "`vector<int>& curr` এর জায়গায় বাই-ভ্যালু পাস করলে প্রতি রিকার্শনে মেমোরি কপি হয়ে প্রোগ্রাম ধীরগতির হয়ে যাবে।"
        },
        {
          "title": "৫. বেস কেস ও বাউন্ডারি না থাকা",
          "desc": "targetSum < 0 বা ইনডেক্স লিমিট চেক না করলে স্ট্যাক ওভারফ্লো ক্র্যাশ ঘটবে।"
        },
      ];
    }
  }
}
