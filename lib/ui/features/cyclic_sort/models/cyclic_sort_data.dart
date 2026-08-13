class CyclicSortProblem {
  final String title;
  final String difficulty; // Easy, Medium, Hard
  final List<String> companyTags;
  final String keyIdeaEn;
  final String keyIdeaBn;
  final bool isPopular;

  const CyclicSortProblem({
    required this.title,
    required this.difficulty,
    required this.companyTags,
    required this.keyIdeaEn,
    required this.keyIdeaBn,
    this.isPopular = false,
  });
}

class CyclicSortData {
  static Map<String, String> getConceptIntro(bool isEnglish) {
    if (isEnglish) {
      return {
        "title": "Cyclic Sort — Complete Deep Dive (C++ & FAANG Focus)",
        "summary": "Cyclic Sort is an in-place O(N) time and O(1) space sorting algorithm used when an array contains numbers in a given bounded range (e.g. 1 to N or 0 to N). By placing each number at its correct index (nums[i] - 1) via swaps, missing or duplicate numbers can be identified in a single scan.",
        "whenToUseTitle": "When to Use Cyclic Sort?",
        "whenToUse1": "Input array contains integers in range 1 to N or 0 to N.",
        "whenToUse2": "Problem asks to find missing numbers, duplicate numbers, or set mismatches in O(N) time and O(1) space.",
        "whenToUse3": "Finding the smallest positive missing integer (First Missing Positive).",
        "whenToUse4": "In-place element swapping where array elements act as direct index pointers.",
        "whenToUse5": "Eliminates O(N log N) sorting or O(N) Hash Set space overhead.",
        "typesTitle": "3 Main Cyclic Sort Patterns",
        "type1Title": "1. Standard 1 to N Cyclic Sort",
        "type1Desc": "Iterate with index i. While nums[i] != nums[nums[i] - 1], swap nums[i] with nums[nums[i] - 1]. Otherwise, advance i++.",
        "type2Title": "2. Finding Missing & Duplicate Numbers",
        "type2Desc": "Run Cyclic Sort. Scan array: if nums[i] != i + 1, then i + 1 is the missing number and nums[i] is the duplicate number!",
        "type3Title": "3. First Missing Positive (Unbounded Range)",
        "type3Desc": "Ignore numbers <= 0 or > N. Only swap numbers within valid range 1 to N. Then scan for first index where nums[i] != i + 1.",
      };
    } else {
      return {
        "title": "Cyclic Sort — সম্পূর্ণ গাইড (C++ ও FAANG ফোকাস)",
        "summary": "Cyclic Sort হলো ইন-প্লেস O(N) টাইম এবং O(1) স্পেসের অ্যালগরিদম যা ১ থেকে N বা ০ থেকে N সীমানার সংখ্যার অ্যারেতে ব্যবহৃত হয়। প্রতিটি সংখ্যাকে তার সঠিক ইনডেক্সে (nums[i] - 1) সোয়াপ করে রেখে এক পাসে নিখোঁজ (Missing) বা ডুপ্লিকেট সংখ্যা বের করা যায়।",
        "whenToUseTitle": "কখন বুঝবা Cyclic Sort লাগবে?",
        "whenToUse1": "ইনপুট অ্যারেতে ১ থেকে N বা ০ থেকে N সীমানার সংখ্যা থাকবে।",
        "whenToUse2": "O(N) টাইম ও O(1) মেমোরিতে হারানো সংখ্যা (Missing Number) বা ডুপ্লিকেট সংখ্যা বের করতে বলা হলে।",
        "whenToUse3": "সর্বনিম্ন পজিটিভ নিখোঁজ সংখ্যা (First Missing Positive) বের করতে।",
        "whenToUse4": "অ্যারের প্রতিটি সংখ্যা নিজেই নিজের ইনডেক্স পয়েন্টার হিসেবে কাজ করলে।",
        "whenToUse5": "O(N log N) সর্টিং বা O(N) হ্যাশ সেটের বাড়তি মেমোরি খরচ বাদ দিতে।",
        "typesTitle": "Main Types (৩ ধরনের pattern)",
        "type1Title": "১. Standard 1 to N Cyclic Sort (সাধারণ সর্ট)",
        "type1Desc": "ইনডেক্স i নিয়ে লুপ চালাও। যতক্ষণ `nums[i] != nums[nums[i] - 1]`, সোয়াপ করো। অন্যথায় `i++` বাড়িয়ে আগাও।",
        "type2Title": "২. Missing & Duplicate Numbers (নিখোঁজ ও ডুপ্লিকেট)",
        "type2Desc": "Cyclic Sort শেষ করার পর অ্যারে ট্রাভার্স করো: যদি `nums[i] != i + 1`, তবে `i + 1` হলো মিসিং এবং `nums[i]` হলো ডুপ্লিকেট!",
        "type3Title": "৩. First Missing Positive (অনিয়ন্ত্রিত রেঞ্জ)",
        "type3Desc": "ঋণাত্মক বা N এর চেয়ে বড় সংখ্যা ইগনোর করো। শুধুমাত্র ১ থেকে N এর ভেতরের সংখ্যাগুলো সঠিক স্থানে সোয়াপ করো।",
      };
    }
  }

  static List<CyclicSortProblem> getEasyProblems() {
    return const [
      CyclicSortProblem(
        title: "Missing Number",
        difficulty: "Easy",
        companyTags: ["Amazon", "Meta", "Google", "Microsoft"],
        keyIdeaEn: "Cyclic Sort in 0 to N range. The index i where nums[i] != i is the missing number.",
        keyIdeaBn: "০ থেকে N সীমানার সাইক্লিক সর্ট। যেখানে `nums[i] != i` সেটাই মিসিং নম্বর।",
        isPopular: true,
      ),
      CyclicSortProblem(
        title: "Find All Numbers Disappeared in an Array",
        difficulty: "Easy",
        companyTags: ["Amazon", "Meta", "Google"],
        keyIdeaEn: "Cyclic Sort 1 to N. Scan array: all indices where nums[i] != i + 1 represent missing numbers i + 1.",
        keyIdeaBn: "সাইক্লিক সর্ট শেষে যে সব ইনডেক্সে `nums[i] != i + 1`, সেগুলোই হারানো সংখ্যা।",
        isPopular: true,
      ),
      CyclicSortProblem(
        title: "Set Mismatch",
        difficulty: "Easy",
        companyTags: ["Amazon", "Meta"],
        keyIdeaEn: "Cyclic Sort 1 to N. Misplaced index holds duplicate nums[i] and missing number i + 1.",
        keyIdeaBn: "ভুল ইনডেক্সে থাকা সংখ্যাটি ডুপ্লিকেট এবং সঠিক ইনডেক্স মানটি মিসিং।",
      ),
      CyclicSortProblem(
        title: "Sort Array By Parity",
        difficulty: "Easy",
        companyTags: ["Meta", "Amazon"],
        keyIdeaEn: "In-place two pointer cyclic swap putting evens at front and odds at back.",
        keyIdeaBn: "ইন-প্লেস সোয়াপ করে জোড় সংখ্যা সামনে ও বিজোড় পেছনে আনুন।",
      ),
      CyclicSortProblem(
        title: "Sort Array By Parity II",
        difficulty: "Easy",
        companyTags: ["Amazon", "Meta"],
        keyIdeaEn: "Two pointers at odd and even indices. Swap misplaced elements.",
        keyIdeaBn: "জোড় ও বিজোড় ইনডেক্স পয়েন্টার দিয়ে সোয়াপ করুন।",
      ),
      CyclicSortProblem(
        title: "Relative Sort Array",
        difficulty: "Easy",
        companyTags: ["Amazon", "Meta"],
        keyIdeaEn: "Custom frequency array or cyclic place ordering by relative array arr2.",
        keyIdeaBn: "arr2 এর আপেক্ষিক ক্রম অনুযায়ী অ্যারে সাজান।",
      ),
      CyclicSortProblem(
        title: "Check If Array Pairs Are Divisible by k",
        difficulty: "Easy",
        companyTags: ["Google", "Amazon"],
        keyIdeaEn: "Modulo remainder frequency array cyclic matching.",
        keyIdeaBn: "ভাগশেষ ফ্রিকোয়েন্সি মিলিয়ে জোড় সংখ্যা চেক করুন।",
      ),
      CyclicSortProblem(
        title: "Find Target Indices After Sorting Array",
        difficulty: "Easy",
        companyTags: ["Google", "Amazon"],
        keyIdeaEn: "Count smaller elements and target frequency to determine target indices in O(N).",
        keyIdeaBn: "O(N) এ ছোট উপাদান ও টার্গেট গণনা করে ইনডেক্স বের করুন।",
      ),
    ];
  }

  static List<CyclicSortProblem> getMediumProblems() {
    return const [
      CyclicSortProblem(
        title: "Find All Duplicates in an Array",
        difficulty: "Medium",
        companyTags: ["Meta", "Amazon", "Google", "Microsoft"],
        keyIdeaEn: "Cyclic Sort or negate values as visited flags. All elements where nums[i] != i + 1 are duplicates.",
        keyIdeaBn: "সাইক্লিক সর্ট শেষে যে সব স্থানে `nums[i] != i + 1` সেগুলিই ডুপ্লিকেট।",
        isPopular: true,
      ),
      CyclicSortProblem(
        title: "Find the Duplicate Number",
        difficulty: "Medium",
        companyTags: ["Amazon", "Meta", "Google", "Microsoft"],
        keyIdeaEn: "Cyclic Sort or Floyd's Fast & Slow pointers on array indices. Duplicate sits at collision.",
        keyIdeaBn: "সাইক্লিক সর্ট অথবা পয়েন্টার কোলাইশনে ডুপ্লিকেট মেলান।",
        isPopular: true,
      ),
      CyclicSortProblem(
        title: "First Missing Positive",
        difficulty: "Medium",
        companyTags: ["Amazon", "Meta", "Google", "Microsoft", "Bloomberg"],
        keyIdeaEn: "Cyclic Sort ignoring <=0 and >N. The first index i where nums[i] != i + 1 gives answer i + 1.",
        keyIdeaBn: "ইনভ্যালিড সংখ্যা বাদ দিয়ে সাইক্লিক সর্ট করুন। ১ম অমিল ইনডেক্স `i + 1` ই উত্তর।",
        isPopular: true,
      ),
      CyclicSortProblem(
        title: "H-Index",
        difficulty: "Medium",
        companyTags: ["Amazon", "Google"],
        keyIdeaEn: "Bucket sort / Cyclic counting array for citation counts up to N.",
        keyIdeaBn: "সাইটেশন গণনায় বাকেট সর্ট সপ্রয়োগ করুন।",
      ),
      CyclicSortProblem(
        title: "Find All Lonely Numbers in the Array",
        difficulty: "Medium",
        companyTags: ["Amazon", "Meta"],
        keyIdeaEn: "Frequency hash map or bucket count checking nums[i]-1 and nums[i]+1.",
        keyIdeaBn: "ফ্রিকোয়েন্সি ম্যাপে নিঃসঙ্গ সংখ্যা শনাক্ত করুন।",
      ),
      CyclicSortProblem(
        title: "Kth Missing Positive Number",
        difficulty: "Medium",
        companyTags: ["Meta", "Amazon"],
        keyIdeaEn: "Binary search or cyclic count tracking missing positive integers.",
        keyIdeaBn: "বাইনারি সার্চ বা মিসিং গণনায় K-তম সংখ্যাটি বের করুন।",
      ),
      CyclicSortProblem(
        title: "Smallest Missing Non-negative Integer After Operations",
        difficulty: "Medium",
        companyTags: ["Google", "Amazon"],
        keyIdeaEn: "Modulo arithmetic remainder counting array to find smallest missing non-negative.",
        keyIdeaBn: "মডিউলো ভাগশেষ বাকেট দিয়ে মিসিং নন-নেগেটিভ বের করুন।",
      ),
      CyclicSortProblem(
        title: "Maximum Consecutive Floors Without Special Floors",
        difficulty: "Medium",
        companyTags: ["Amazon", "Google"],
        keyIdeaEn: "Sort special floors and compute gaps between consecutive special floors.",
        keyIdeaBn: "স্পেশাল ফ্লোর সর্ট করে মাঝখানের সর্বোচ্চ গ্যাপ বের করুন।",
      ),
    ];
  }

  static List<CyclicSortProblem> getHardProblems() {
    return const [
      CyclicSortProblem(
        title: "First Missing Positive (O(1) Space Hard Variant)",
        difficulty: "Hard",
        companyTags: ["Amazon", "Meta", "Google", "Microsoft"],
        keyIdeaEn: "Cyclic Sort in O(N) time & O(1) space. Swap nums[i] to nums[nums[i] - 1] while 1 <= nums[i] <= N.",
        keyIdeaBn: "O(1) স্পেসের কঠোর শর্তে ১ থেকে N সীমানায় সাইক্লিক সোয়াপ করে সমাধান।",
        isPopular: true,
      ),
      CyclicSortProblem(
        title: "Couples Holding Hands",
        difficulty: "Hard",
        companyTags: ["Google", "Amazon"],
        keyIdeaEn: "Min Swaps cyclic graph components / Cyclic Sort to pair couples (2*i, 2*i+1).",
        keyIdeaBn: "সাইক্লিক সোয়াপ ও গ্রাফ কম্পোনেন্ট দিয়ে সর্বনিম্ন সোয়াপ সংখ্যা বের করুন।",
        isPopular: true,
      ),
      CyclicSortProblem(
        title: "Create Sorted Array through Instructions",
        difficulty: "Hard",
        companyTags: ["Google", "Amazon"],
        keyIdeaEn: "BIT / Fenwick Tree or Segment Tree for dynamic insertion cost calculation.",
        keyIdeaBn: "ফেনউইক ট্রি বা সেগমেন্ট ট্রি দিয়ে ইনসার্ট কস্ট গণনা করুন।",
      ),
    ];
  }

  static List<Map<String, String>> getCommonMistakes(bool isEnglish) {
    if (isEnglish) {
      return [
        {
          "title": "1. Using `for` loop instead of `while (i < N)`",
          "desc": "Advancing `i++` unconditionally on every step skips elements that were just swapped into `nums[i]` and haven't been placed at their correct index yet!"
        },
        {
          "title": "2. Infinite Swap Loops on Duplicate Numbers",
          "desc": "Swapping `nums[i]` with `nums[correctIdx]` when `nums[i] == nums[correctIdx]` causes an infinite swap loop! Check `nums[i] != nums[correctIdx]` before swapping."
        },
        {
          "title": "3. Off-by-One Index Mapping Error",
          "desc": "Mapping range 1 to N to index `val` instead of `val - 1` causes array index out of bounds exceptions."
        },
        {
          "title": "4. Not Filtering Out-of-Range Elements in First Missing Positive",
          "desc": "Trying to swap negative numbers (<= 0) or numbers greater than N into array indices causes out of bounds errors. Only swap when `1 <= nums[i] <= N`."
        },
        {
          "title": "5. Modifying Input Array When Read-Only Constraint Required",
          "desc": "Cyclic Sort modifies the input array in-place. If the problem specifies read-only input, you cannot use Cyclic Sort directly without copying."
        },
      ];
    } else {
      return [
        {
          "title": "১. `while (i < N)` এর বদলে `for` লুপ ব্যবহার করা",
          "desc": "প্রতি পদক্ষেপে না ভেবে `i++` বাড়ালে সদ্য সোয়াপ হয়ে আসা নতুন মানটি চেক না করেই স্কিপ হয়ে যাবে এবং ভুল রেজাল্ট আসবে!"
        },
        {
          "title": "২. ডুপ্লিকেট মান থাকলে সোয়াপের অসীম লুপ (Infinite Loop)",
          "desc": "যখন `nums[i] == nums[correctIdx]`, তখনও সোয়াপ করলে প্রোগ্রাম অসীম সোয়াপ লুপে ঝুলবে। সোয়াপের আগে `nums[i] != nums[correctIdx]` চেক করা বাধ্যতামূলক।"
        },
        {
          "title": "৩. ইনডেক্স ম্যাপিং এ Off-by-One ভুল",
          "desc": "১ থেকে N সীমানায় সঠিক ইনডেক্স `val - 1` না লিখে `val` লিখলে Index Out of Bounds এক্সসেপশন ঘটবে।"
        },
        {
          "title": "৪. First Missing Positive এ অনিয়ন্ত্রিত ইনপুট ফিল্টার না করা",
          "desc": "ঋণাত্মক সংখ্যা (<= 0) বা N এর চেয়ে বড় মান সোয়াপ করতে গেলে ক্র্যাশ করবে। শুধুমাত্র `1 <= nums[i] <= N` হলে সোয়াপ করতে হবে।"
        },
        {
          "title": "৫. Read-Only ইনপুটে অ্যারে মডিফাই করে ফেলা",
          "desc": "Cyclic Sort ইন-প্লেস অ্যারে পরিবর্তন করে। যদি প্রবলেমে রিড-অনলি বলা থাকে তবে মূল অ্যারে সর্ট করা যাবে না।"
        },
      ];
    }
  }
}
