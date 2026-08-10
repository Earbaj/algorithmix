class RecursionBacktrackingProblem {
  final String title;
  final String difficulty; // Easy, Medium, Hard
  final List<String> companyTags;
  final String keyIdeaEn;
  final String keyIdeaBn;
  final bool isPopular;

  const RecursionBacktrackingProblem({
    required this.title,
    required this.difficulty,
    required this.companyTags,
    required this.keyIdeaEn,
    required this.keyIdeaBn,
    this.isPopular = false,
  });
}

class RecursionBacktrackingData {
  static Map<String, String> getConceptIntro(bool isEnglish) {
    if (isEnglish) {
      return {
        "title": "Recursion & Backtracking — Complete Deep Dive (C++ & FAANG Focus)",
        "summary": "Recursion breaks problems into smaller subproblems with explicit Base Cases. Backtracking builds candidates incrementally and abandons (prunes) a candidate path as soon as it determines the candidate cannot lead to a valid solution.",
        "whenToUseTitle": "When to Use Recursion & Backtracking?",
        "whenToUse1": "Generating all Permutations, Subsets, or Combinations (O(2ⁿ) or O(N!)).",
        "whenToUse2": "Exploring all paths in 2D grids or graphs (e.g. N-Queens, Sudoku Solver, Word Search).",
        "whenToUse3": "Decision trees where at each step you make a choice -> recurse -> un-choose (backtrack).",
        "whenToUse4": "Problems requiring State Space Tree search with branch pruning.",
        "whenToUse5": "Dividing problems into self-similar subproblems with base cases.",
        "typesTitle": "3 Main Backtracking Patterns",
        "type1Title": "1. Subsets & Combinations (Take / Skip)",
        "type1Desc": "At each index, make 2 choices: include or exclude current element. Recurse to index + 1.",
        "type2Title": "2. Permutations & Ordering (Used Array / Swap)",
        "type2Desc": "Pick any unused element at each step or swap elements in-place to explore all orderings.",
        "type3Title": "3. Constraint Satisfaction (Choose / Recurse / Un-choose)",
        "type3Desc": "Place a candidate choice, recurse to next position, then undo choice (un-choose) if invalid path reached.",
      };
    } else {
      return {
        "title": "Recursion & Backtracking — সম্পূর্ণ গাইড (C++ ও FAANG ফোকাস)",
        "summary": "Recursion হলো নিজেকে নিজে কল দিয়ে ছোট সাব-প্রবলেমে সমাধান করা। Backtracking হলো প্রতিটি স্টেপে অপশন চয়েস করা, গভীরে যাওয়া এবং ভুল পাথে পৌঁছালে আগের অবস্থায় ব্যাক (Un-choose) করে সঠিক পথ খোঁজা।",
        "whenToUseTitle": "কখন বুঝবা Backtracking লাগবে?",
        "whenToUse1": "সব Permutations, Subsets বা Combinations জেনারেট করতে হলে (O(2ⁿ) বা O(N!))।",
        "whenToUse2": "২D গ্রিড বা গ্রাফের সব পথ এক্সপ্লোর করতে (যেমন N-Queens, Sudoku, Word Search)।",
        "whenToUse3": "সিদ্ধান্তের ট্রি যেখানে চয়েস করো -> গভীরে যাও -> চয়েস ক্যানসেল করো (backtrack)।",
        "whenToUse4": "স্টেট স্পেস ট্রিতে ইনভ্যালিড ব্রাঞ্চ ছাঁটাই (Pruning) করে সমাধান খোঁজা।",
        "whenToUse5": "বেস কেস দিয়ে প্রবলেমকে নিজের মতো ছোট সাব-প্রবলেমে ভাগ করা।",
        "typesTitle": "Main Types (৩ ধরনের pattern)",
        "type1Title": "১. Subsets & Combinations (Take / Skip)",
        "type1Desc": "প্রতিটি নোডে ২টি চয়েস: এলিমেন্ট নেবো (Take) নাকি নেবো না (Skip)। তারপর index + 1 এ যান।",
        "type2Title": "২. Permutations & Ordering (Used / Swap)",
        "type2Desc": "ব্যবহৃত না হওয়া যেকোনো এলিমেন্ট বাছাই করো অথবা মেমোরিতে Swap করে নতুন অর্ডার বানাও।",
        "type3Title": "৩. Constraint Satisfaction (Choose / Recurse / Un-choose)",
        "type3Desc": "চয়েস সেট করো -> রিকার্সন কল দাও -> ভুল হলে ব্যাকট্র্যাক করে চয়েস বাতিল করো (Un-choose)।",
      };
    }
  }

  static List<RecursionBacktrackingProblem> getEasyProblems() {
    return const [
      RecursionBacktrackingProblem(
        title: "Subsets (Power Set)",
        difficulty: "Easy",
        companyTags: ["Amazon", "Meta", "Google"],
        keyIdeaEn: "Include / Exclude current element at each index. Return all 2ⁿ subsets.",
        keyIdeaBn: "প্রতি ইনডেক্সে নেবো/নেবো না সিদ্ধান্ত। সব ২ⁿ টি সাবসেট রিটার্ন করুন।",
        isPopular: true,
      ),
      RecursionBacktrackingProblem(
        title: "Combination Sum",
        difficulty: "Easy",
        companyTags: ["Meta", "Amazon", "Microsoft"],
        keyIdeaEn: "Unlimited reuse of elements. Backtrack when sum exceeds target.",
        keyIdeaBn: "একই উপাদান বারবার ব্যবহারযোগ্য। টার্গেট ছাড়ালে ব্যাকট্র্যাক করুন।",
        isPopular: true,
      ),
      RecursionBacktrackingProblem(
        title: "Generate Parentheses",
        difficulty: "Easy",
        companyTags: ["Amazon", "Google", "Meta"],
        keyIdeaEn: "Track open & close count. Add '(' if open < n, add ')' if close < open.",
        keyIdeaBn: "ওপেন ও ক্লোজ সংখ্যা ট্র্যাক রাখুন। নিদির্ষ্ট শর্তে ব্র্যাকেট যোগ করুন।",
        isPopular: true,
      ),
      RecursionBacktrackingProblem(
        title: "Letter Combinations of a Phone Number",
        difficulty: "Easy",
        companyTags: ["Amazon", "Meta", "Google"],
        keyIdeaEn: "Map digits to letters. Recurse over letter choices for each digit index.",
        keyIdeaBn: "ডিজিটকে লেটারে ম্যাপ করে রিকার্সিভ কম্বিনেশন জেনারেট করুন।",
      ),
      RecursionBacktrackingProblem(
        title: "Permutations",
        difficulty: "Easy",
        companyTags: ["Meta", "Amazon", "Google", "Microsoft"],
        keyIdeaEn: "Swap elements in-place or use boolean used[] array. N! total permutations.",
        keyIdeaBn: "ইন-প্লেস Swap অথবা used[] অ্যারে দিয়ে সব N! পারমিউটেশন বের করুন।",
        isPopular: true,
      ),
      RecursionBacktrackingProblem(
        title: "Binary Tree Paths",
        difficulty: "Easy",
        companyTags: ["Meta", "Google"],
        keyIdeaEn: "Root-to-leaf DFS string concatenation backtracking.",
        keyIdeaBn: "রুট থেকে লিফ পর্যন্ত সব পাথ রিকার্সিভলি যুক্ত করুন।",
      ),
      RecursionBacktrackingProblem(
        title: "Word Search",
        difficulty: "Easy",
        companyTags: ["Amazon", "Meta", "Bloomberg"],
        keyIdeaEn: "2D Grid 4-directional DFS. Mark visited cell '#', backtrack to original char.",
        keyIdeaBn: "২D গ্রিডে ৪-দিকমুখী DFS। নোড '#' মার্ক করে পরে ব্যাকট্র্যাক করুন।",
        isPopular: true,
      ),
      RecursionBacktrackingProblem(
        title: "Subsets II (Duplicates)",
        difficulty: "Easy",
        companyTags: ["Meta", "Amazon"],
        keyIdeaEn: "Sort input array first. Skip duplicate choices: if (i > start && nums[i] == nums[i-1]) continue.",
        keyIdeaBn: "অ্যারে সর্ট করে ডুপ্লিকেট চয়েস স্কিপ করুন।",
      ),
    ];
  }

  static List<RecursionBacktrackingProblem> getMediumProblems() {
    return const [
      RecursionBacktrackingProblem(
        title: "Permutations II (Duplicates)",
        difficulty: "Medium",
        companyTags: ["Meta", "Amazon"],
        keyIdeaEn: "Sort and track used[i]. Skip duplicate elements at same depth level.",
        keyIdeaBn: "সর্ট করে একই লেভেলে ডুপ্লিকেট স্কিপ করুন।",
        isPopular: true,
      ),
      RecursionBacktrackingProblem(
        title: "Combination Sum II",
        difficulty: "Medium",
        companyTags: ["Amazon", "Meta"],
        keyIdeaEn: "Each number can only be used once. Sort and skip duplicate candidates.",
        keyIdeaBn: "প্রতিটি উপাদান একবার ব্যবহারযোগ্য। ডুপ্লিকেট স্কিপ করুন।",
      ),
      RecursionBacktrackingProblem(
        title: "Palindrome Partitioning",
        difficulty: "Medium",
        companyTags: ["Meta", "Amazon", "Google"],
        keyIdeaEn: "Partition string into substrings. If substring is palindrome, recurse on remainder.",
        keyIdeaBn: "প্যালিন্ড্রোম সাবস্ট্রিং কেটে কেটে রিকার্সন চালান।",
        isPopular: true,
      ),
      RecursionBacktrackingProblem(
        title: "Letter Case Permutation",
        difficulty: "Medium",
        companyTags: ["Meta", "Amazon"],
        keyIdeaEn: "At letters, branch into lower-case and upper-case choices.",
        keyIdeaBn: "লেটার পেলে ছোট ও বড় হাতের দুটো অপশনে ব্রাঞ্চ করুন।",
      ),
      RecursionBacktrackingProblem(
        title: "N-Queens",
        difficulty: "Medium",
        companyTags: ["Amazon", "Meta", "Google", "Microsoft"],
        keyIdeaEn: "Place queens row by row. Check column, main diagonal, and anti-diagonal safety.",
        keyIdeaBn: "রো অনুযায়ী কুইন বসান। কলাম ও ডায়াগোনাল সেফটি চেক করে ব্যাকট্র্যাক করুন।",
        isPopular: true,
      ),
      RecursionBacktrackingProblem(
        title: "Sudoku Solver",
        difficulty: "Medium",
        companyTags: ["Google", "Microsoft", "Amazon"],
        keyIdeaEn: "Find empty cell '.', try digits '1'-'9', verify row/col/box safety, recurse.",
        keyIdeaBn: "খালি ঘরে ১-৯ বসিয়ে রিকার্সন চালান, ইনভ্যালিড হলে ব্যাকট্র্যাক করুন।",
        isPopular: true,
      ),
      RecursionBacktrackingProblem(
        title: "Target Sum",
        difficulty: "Medium",
        companyTags: ["Amazon", "Meta"],
        keyIdeaEn: "Assign '+' or '-' to each number to reach target sum.",
        keyIdeaBn: "প্রতিটি চিহ্নে '+' বা '-' বসিয়ে টার্গেট মেলান।",
      ),
      RecursionBacktrackingProblem(
        title: "Restore IP Addresses",
        difficulty: "Medium",
        companyTags: ["Amazon", "Meta"],
        keyIdeaEn: "Split string into 4 valid octets (0 to 255 with no leading zeroes).",
        keyIdeaBn: "স্ট্রিংকে ৪টি সঠিক IP ব্লকে ভাগ করুন।",
      ),
    ];
  }

  static List<RecursionBacktrackingProblem> getHardProblems() {
    return const [
      RecursionBacktrackingProblem(
        title: "N-Queens II (Total Solutions Count)",
        difficulty: "Hard",
        companyTags: ["Amazon", "Meta", "Google"],
        keyIdeaEn: "Bitmasking / Column Tracking to count valid N-Queens placements fast.",
        keyIdeaBn: "বিটমাস্কিং দিয়ে দ্রুত N-Queens সমাধানের সংখ্যা গণনা করুন।",
        isPopular: true,
      ),
      RecursionBacktrackingProblem(
        title: "Word Search II (Grid + Trie Optimization)",
        difficulty: "Hard",
        companyTags: ["Amazon", "Meta", "Google"],
        keyIdeaEn: "Combine 2D Grid DFS backtracking with Trie prefix pruning for fast multi-word lookup.",
        keyIdeaBn: "২D গ্রিড ব্যাকট্র্যাকিং এর সাথে ট্রাই প্রিফিক্স প্রুনিং যুক্ত করে সার্চ করুন।",
        isPopular: true,
      ),
      RecursionBacktrackingProblem(
        title: "Remove Invalid Parentheses",
        difficulty: "Hard",
        companyTags: ["Meta", "Google"],
        keyIdeaEn: "BFS or Backtracking to remove minimum invalid parentheses making string valid.",
        keyIdeaBn: "সর্বনিম্ন ব্র্যাকেট রিমুভ করে স্ট্রিংকে ভ্যালিড করুন।",
        isPopular: true,
      ),
    ];
  }

  static List<Map<String, String>> getCommonMistakes(bool isEnglish) {
    if (isEnglish) {
      return [
        {
          "title": "1. Missing or Late Base Case Check",
          "desc": "Forgetting base cases or placing condition checks after out-of-bounds array access causes StackOverflowError or Segmentation Fault!"
        },
        {
          "title": "2. Forgetting the Backtrack Step (Un-choose)",
          "desc": "Mutating shared state (e.g., path.push_back(x) or grid[r][c] = '#') without undoing it (path.pop_back() or grid[r][c] = original) corrupts state for sibling branches!"
        },
        {
          "title": "3. Missing Duplicate Skips in Combinations",
          "desc": "Failing to sort input and skip duplicate candidates using `if (i > start && nums[i] == nums[i-1]) continue;` generates duplicate subset combinations."
        },
        {
          "title": "4. Modifying Collection While Iterating",
          "desc": "Mutating loop parameters or passing reference collections without proper recursion stack scoping leads to unexpected reference errors."
        },
        {
          "title": "5. Not Pruning Invalid Paths Early",
          "desc": "Continuing recursive calls on paths that already violate target constraints wastes computation. Prune invalid paths as early as possible!"
        },
      ];
    } else {
      return [
        {
          "title": "১. বেস কেস (Base Case) দিতে ভুলে যাওয়া বা দেরিতে দেখা",
          "desc": "বেস কেস না দিলে রিকার্সন অসীম লুপে পড়ে StackOverflowError ঘটায়। আবার আউট-অফ-বাউন্ড ইনডেক্স অ্যাক্সেসের পর বেস কেস চেক করলে crash করে।"
        },
        {
          "title": "২. ব্যাকট্র্যাক বা আন-চয়েস (Un-choose) করতে ভুলে যাওয়া",
          "desc": "শেয়ার্ড অবজেক্টে `path.push_back(val)` করে রিকার্সন শেষে `path.pop_back()` না করলে পরবর্তী সকল সাব-ব্রাঞ্চের ডেটা নষ্ট হয়ে যায়।"
        },
        {
          "title": "৩. সর্টিং ছাড়া ডুপ্লিকেট স্কিপ করার চেষ্টা",
          "desc": "Subsets II বা Combination Sum II এ অ্যারে সর্ট না করে `if (i > start && nums[i] == nums[i-1])` দিলে ডুপ্লিকেট স্কিপ কাজ করবে না।"
        },
        {
          "title": "৪. ইনভ্যালিড পাথ আর্লি প্রুন (Prune) না করা",
          "desc": "সাম টার্গেট ছাড়িয়ে গেলে বা ডায়াগোনালে কুইন অ্যাটাক লাইনে থাকলে রিকার্সন থামিয়ে প্রুন না করলে O(2ⁿ) অ্যালগরিদম অলস সময় নষ্ট করে।"
        },
        {
          "title": "৫. মেমোরি কল স্ট্যাক ওভারফ্লো",
          "desc": "খুব বড় ইনপুটে (যেমন N=100000) নরমাল রিকার্সন চালালে ওয়ান-পাস স্ট্যাক স্পেস ফুরিয়ে প্রোগ্রাম ক্র্যাশ করে।"
        },
      ];
    }
  }
}
