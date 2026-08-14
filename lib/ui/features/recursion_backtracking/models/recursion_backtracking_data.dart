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
        title: "Expression Add Operators",
        difficulty: "Hard",
        companyTags: ["Meta", "Google", "Amazon"],
        keyIdeaEn: "Backtracking over operators ('+', '-', '*') evaluating prev operand for precedence.",
        keyIdeaBn: "অপারেটর যোগ করে রিকার্সিভ মুল্যায়ন করুন।",
        isPopular: true,
      ),
      RecursionBacktrackingProblem(
        title: "Remove Invalid Parentheses",
        difficulty: "Hard",
        companyTags: ["Meta", "Amazon"],
        keyIdeaEn: "BFS or Backtracking to find minimum removals for valid parentheses.",
        keyIdeaBn: "সর্বনিম্ন কতগুলো ব্র্যাকেট মুছলে বৈধ হবে তা বের করুন।",
      ),
    ];
  }

  static List<Map<String, String>> getCommonMistakes(bool isEnglish) {
    if (isEnglish) {
      return [
        {
          "title": "1. Forgetting Base Case (Infinite Stack Overflow)",
          "desc": "Calling recursion without a terminal condition like `if (idx == n) return;` causes infinite recursion and StackOverflowError!"
        },
        {
          "title": "2. Forgetting to Undo State (Backtrack / Un-choose)",
          "desc": "Modifying state (`path.push_back(val)`) without executing matching `path.pop_back()` pollutes other recursive branches with dirty state!"
        },
        {
          "title": "3. Pass by Value vs Pass by Reference Trap",
          "desc": "Passing `vector<int>& path` by reference without `pop_back()` corrupts results. If passing by value, runtime explodes due to continuous memory copies!"
        },
        {
          "title": "4. Failing to Skip Duplicates in Combinations/Subsets",
          "desc": "When input has duplicates `[1, 2, 2]`, forgetting `if (i > start && nums[i] == nums[i-1]) continue;` generates duplicate result subsets!"
        },
        {
          "title": "5. Modifying Global Grid/State Without Restoring",
          "desc": "In 2D Grid DFS (Word Search / Maze), setting `grid[r][c] = '#'` without restoring `grid[r][c] = originalChar` breaks parallel paths!"
        },
      ];
    } else {
      return [
        {
          "title": "১. বেস কেস (Base Case) দিতে ভুলে যাওয়া",
          "desc": "রিকার্সনে `if (idx == n) return;` এর মতো থামার জায়গা না দিলে ইনফিনিট লুপে কল পড়ে StackOverflowError হবে!"
        },
        {
          "title": "২. স্টেট আন-চয়েস (Un-choose / Backtrack) না করা",
          "desc": "`path.push_back(val)` করার পর কল শেষে `path.pop_back()` না করলে পরবর্তী ব্রাঞ্চের রেজাল্ট নোংরা হয়ে যাবে।"
        },
        {
          "title": "৩. Pass by Reference ফানে ব্যাকট্র্যাক না করা",
          "desc": "রেফারেন্সে পাঠালে অবশ্যই ব্যাকট্র্যাক করে রিমুভ করতে হবে, অন্যথায় অন্যান্য ব্রাঞ্চও ক্ষতিগ্রস্ত হবে।"
        },
        {
          "title": "৪. ডুপ্লিকেট ইনপুট সামলানো না হওয়া",
          "desc": "ইনপুটে `[1, 2, 2]` এর মতো মান থাকলে সর্ট করে `if (i > start && nums[i] == nums[i-1]) continue;` না দিলে একই সাবসেট বারবার আসবে।"
        },
        {
          "title": "৫. গ্রিড নোড আগের অবস্থায় রিস্টোর না করা",
          "desc": "Word Search এ `grid[r][c] = '#'` দিয়ে ভিজিট চিহ্নিত করার পর ব্যাকট্র্যাককালে আসল অক্ষর ফিরিয়ে না দিলে অন্যান্য পাথ বন্ধ হয়ে যাবে।"
        },
      ];
    }
  }
}
