class DPProblem {
  final String title;
  final String difficulty; // Easy, Medium, Hard
  final List<String> companyTags;
  final String keyIdeaEn;
  final String keyIdeaBn;
  final bool isPopular;

  const DPProblem({
    required this.title,
    required this.difficulty,
    required this.companyTags,
    required this.keyIdeaEn,
    required this.keyIdeaBn,
    this.isPopular = false,
  });
}

class DPData {
  static Map<String, String> getConceptIntro(bool isEnglish) {
    if (isEnglish) {
      return {
        "title": "Dynamic Programming (DP) — Complete Deep Dive (C++ & FAANG Focus)",
        "summary": "Dynamic Programming solves complex optimization problems by breaking them down into simpler overlapping subproblems, solving each subproblem once, and storing the results in a lookup table (Memoization in Top-Down or Tabulation in Bottom-Up). DP is built on two pillars: 1) Overlapping Subproblems, and 2) Optimal Substructure.",
        "whenToUseTitle": "When to Use Dynamic Programming?",
        "whenToUse1": "Finding min/max cost or optimal path (Climbing Stairs LeetCode 70, Min Cost Climbing Stairs LeetCode 746, Coin Change LeetCode 322).",
        "whenToUse2": "Counting total combinations or ways to achieve a state (Target Sum LeetCode 494, Combination Sum IV LeetCode 377).",
        "whenToUse3": "String alignment and edit distance problems (LCS LeetCode 1143, Edit Distance LeetCode 72).",
        "whenToUse4": "Choice inclusion/exclusion optimization (0/1 Knapsack Partition Equal Subset Sum LeetCode 416, House Robber LeetCode 198).",
        "whenToUse5": "Longest Increasing Subsequence variants (LIS LeetCode 300).",
        "typesTitle": "3 Main Dynamic Programming Patterns",
        "type1Title": "1. 1D DP / Linear DP (House Robber & Climbing Stairs)",
        "type1Desc": "State depends on previous 1 or 2 indices: dp[i] = max(dp[i-1], dp[i-2] + nums[i]). Space can be optimized from O(N) to O(1) using two variables.",
        "type2Title": "2. 0/1 Knapsack & Unbounded Knapsack",
        "type2Desc": "State dp[i][w] depends on index i and capacity w. Include choice: profit[i] + dp[i-1][w-weight[i]]. Exclude choice: dp[i-1][w]. Reverse 1D loop for 0/1 Knapsack.",
        "type3Title": "3. 2D Sequence / Matrix DP (LCS & Edit Distance)",
        "type3Desc": "State dp[i][j] tracks prefix match of text1[0..i] and text2[0..j]. If text1[i] == text2[j], dp[i][j] = 1 + dp[i-1][j-1]; else max(dp[i-1][j], dp[i][j-1]).",
      };
    } else {
      return {
        "title": "Dynamic Programming (DP) — সম্পূর্ণ গাইড (C++ ও FAANG ফোকাস)",
        "summary": "ডাইনামিক প্রোগ্রামিং (DP) একটি জটিল অপটিমাইজেশন প্রবলেমকে ছোট ছোট সমমানের ওভারল্যাপিং সাবপ্রবলেমে বিভক্ত করে সমাধান করে এবং প্রাপ্ত ফলাফল লুকআপ টেবিলে ক্যাশ (Memoization / Tabulation) করে রাখে। DP এর দুটি মূল ভিত্তি: ১) ওভারল্যাপিং সাবপ্রবলেমস, এবং ২) অপটিমাল সাবস্ট্রাকচার।",
        "whenToUseTitle": "কখন বুঝবা Dynamic Programming (DP) লাগবে?",
        "whenToUse1": "সর্বনিম্ন/সর্বোচ্চ খরচ বা সেরা পথ বের করতে বললে (Climbing Stairs LeetCode 70, Coin Change LeetCode 322)।",
        "whenToUse2": "মোট কত উপায়ে বা কত কম্বিনেশনে গন্তব্যে পৌঁছানো যায় তা গণনা করতে বললে (Target Sum LeetCode 494)।",
        "whenToUse3": "স্ট্রিংয়ের এডিট ডিসটেন্স বা মিল খোঁজার প্রবলেমে (LCS LeetCode 1143, Edit Distance LeetCode 72)।",
        "whenToUse4": "উপাদান রাখা বা বাদ দেওয়ার চয়েস অপটিমাইজেশনে (0/1 Knapsack Partition Subset Sum LeetCode 416, House Robber LeetCode 198)।",
        "whenToUse5": "দীর্ঘতম ক্রমবর্ধমান অনুক্রম বের করতে (LIS LeetCode 300)।",
        "typesTitle": "Main Types (৩ ধরনের pattern)",
        "type1Title": "১. 1D DP / Linear DP (হাউস রবার ও ক্লাইম্বিং স্টেয়ার্স)",
        "type1Desc": "স্টেট পূর্ববর্তী ১ বা ২ ইনডেক্সের ওপর নির্ভরশীল: `dp[i] = max(dp[i-1], dp[i-2] + nums[i])`। দুটি ভ্যারিয়েবল দিয়ে ও(১) মেমোরিতে অপটিমাইজ করা যায়।",
        "type2Title": "২. 0/1 Knapsack & Unbounded Knapsack (ক্যানপস্যাক)",
        "type2Desc": "স্টেট `dp[i][w]` ইনডেক্স ও ক্যাপাসিটির ওপর নির্ভর করে। ইনক্লুড চয়েস: `profit + dp[i-1][w-weight]`। রিভার্স লুপ দিয়ে ১D এরেতে অপটিমাইজ করা যায়।",
        "type3Title": "৩. 2D Sequence / Matrix DP (LCS ও এডিট ডিসটেন্স)",
        "type3Desc": "স্টেট `dp[i][j]` দুটি স্ট্রিং প্রিফিক্স ম্যাচ ট্র্যাক করে। ক্যারেক্টার মিললে `1 + dp[i-1][j-1]`, না মিললে `max(dp[i-1][j], dp[i][j-1])`।",
      };
    }
  }

  static List<DPProblem> getEasyProblems() {
    return const [
      DPProblem(
        title: "Climbing Stairs",
        difficulty: "Easy",
        companyTags: ["Amazon", "Meta", "Google", "Microsoft"],
        keyIdeaEn: "Fibonacci-like state transition dp[i] = dp[i-1] + dp[i-2] solvable in O(N) time and O(1) space.",
        keyIdeaBn: "ফিবোনাক্কি স্টাইল স্টেট dp[i] = dp[i-1] + dp[i-2] দিয়ে সমাধান করুন।",
        isPopular: true,
      ),
      DPProblem(
        title: "Min Cost Climbing Stairs",
        difficulty: "Easy",
        companyTags: ["Amazon", "Meta"],
        keyIdeaEn: "1D DP calculating min cost to reach top step: dp[i] = cost[i] + min(dp[i-1], dp[i-2]).",
        keyIdeaBn: "প্রতি ধাপে সর্বনিম্ন খরচ হিসেব করে ১D DP তে সমাধান করুন।",
        isPopular: true,
      ),
      DPProblem(
        title: "Fibonacci Number",
        difficulty: "Easy",
        companyTags: ["Amazon", "Meta", "Google"],
        keyIdeaEn: "Classic DP memoization or O(1) space bottom-up tabulation.",
        keyIdeaBn: "মেমোইজেশন বা ২ ভ্যারিয়েবল মেমোরিতে ফিবোনাক্কি বের করুন।",
      ),
      DPProblem(
        title: "Pascal's Triangle",
        difficulty: "Easy",
        companyTags: ["Amazon", "Meta", "Google"],
        keyIdeaEn: "2D dynamic programming grid construction dp[i][j] = dp[i-1][j-1] + dp[i-1][j].",
        keyIdeaBn: "প্যাসকেলের ত্রিভুজ গ্রিড ডাইনামিক প্রোগ্রামিং দিয়ে ফিল করুন।",
      ),
      DPProblem(
        title: "N-th Tribonacci Number",
        difficulty: "Easy",
        companyTags: ["Amazon", "Meta"],
        keyIdeaEn: "3-variable linear DP iteration T(n) = T(n-1) + T(n-2) + T(n-3).",
        keyIdeaBn: "৩টি ভ্যারিয়েবল মেইনটেইন করে ট্রাইবোনাক্কি বের করুন।",
      ),
      DPProblem(
        title: "Divisor Game",
        difficulty: "Easy",
        companyTags: ["Google", "Amazon"],
        keyIdeaEn: "Math parity or boolean DP table.",
        keyIdeaBn: "ম্যাথ প্যারিটি বা বুলিয়ান DP টেবিল দিয়ে বিজয়ী নির্ধারণ করুন।",
      ),
      DPProblem(
        title: "Counting Bits",
        difficulty: "Easy",
        companyTags: ["Amazon", "Meta", "Google"],
        keyIdeaEn: "Bit manipulation DP pattern dp[i] = dp[i >> 1] + (i & 1).",
        keyIdeaBn: "বিট শিফট DP প্যাটার্ন দিয়ে ১ বিটের সংখ্যা গণনা করুন।",
      ),
      DPProblem(
        title: "Is Subsequence",
        difficulty: "Easy",
        companyTags: ["Google", "Amazon"],
        keyIdeaEn: "Two pointers or 2D DP string prefix matching.",
        keyIdeaBn: "টু পয়েন্টার বা ২D DP দিয়ে সাবসিকোয়েন্স মিল নিশ্চিত করুন।",
      ),
    ];
  }

  static List<DPProblem> getMediumProblems() {
    return const [
      DPProblem(
        title: "House Robber",
        difficulty: "Medium",
        companyTags: ["Meta", "Amazon", "Google", "Microsoft", "Bloomberg"],
        keyIdeaEn: "1D DP state transition dp[i] = max(dp[i-1], dp[i-2] + nums[i]) in O(N) time and O(1) space.",
        keyIdeaBn: "পাশাপাশি বাড়ি চুরি না করে সর্বোচ্চ টাকা চুরির O(1) স্পেস DP।",
        isPopular: true,
      ),
      DPProblem(
        title: "House Robber II (Circular)",
        difficulty: "Medium",
        companyTags: ["Meta", "Amazon", "Google", "Microsoft"],
        keyIdeaEn: "Run House Robber twice: once for range [0..N-2] and once for range [1..N-1].",
        keyIdeaBn: "সার্কুলার বাড়ি হওয়ায় ২ বার হাউস রবার চালিয়ে সর্বোচ্চ মান নিন।",
        isPopular: true,
      ),
      DPProblem(
        title: "Coin Change",
        difficulty: "Medium",
        companyTags: ["Meta", "Amazon", "Google", "Microsoft", "Bloomberg"],
        keyIdeaEn: "Unbounded Knapsack 1D DP: dp[w] = min(dp[w], 1 + dp[w - coin]) initialized to infinity.",
        keyIdeaBn: "ইনফিনিটি দিয়ে শুরু করে সর্বনিম্ন কয়েন সংখ্যা বের করার আনবাউন্ডেড ক্যানপস্যাক।",
        isPopular: true,
      ),
      DPProblem(
        title: "Longest Increasing Subsequence (LIS)",
        difficulty: "Medium",
        companyTags: ["Meta", "Amazon", "Google", "Microsoft", "Bloomberg"],
        keyIdeaEn: "O(N^2) DP dp[i] = max(dp[i], 1 + dp[j]) or O(N log N) patience sorting with binary search.",
        keyIdeaBn: "O(N^2) DP বা O(N log N) বাইনারি সার্চ দিয়ে দীর্ঘতম সর্টেড সাবসিকোয়েন্স পান।",
        isPopular: true,
      ),
      DPProblem(
        title: "Partition Equal Subset Sum",
        difficulty: "Medium",
        companyTags: ["Meta", "Amazon", "Google", "Microsoft"],
        keyIdeaEn: "0/1 Knapsack subset sum target = sum/2 using reverse 1D boolean DP array.",
        keyIdeaBn: "রিভার্স ১D বুলিয়ান ক্যানপস্যাক দিয়ে অর্ধেক সাম মেলানোর চেক করুন।",
      ),
      DPProblem(
        title: "Longest Common Subsequence (LCS)",
        difficulty: "Medium",
        companyTags: ["Meta", "Amazon", "Google", "Microsoft"],
        keyIdeaEn: "2D Matrix DP tracking character matches text1[i] == text2[j].",
        keyIdeaBn: "২D ম্যাট্রিক্স DP দিয়ে ২ স্ট্রিংয়ের দীর্ঘতম মিল থাকা সাবসিকোয়েন্স পান।",
      ),
      DPProblem(
        title: "Word Break",
        difficulty: "Medium",
        companyTags: ["Meta", "Amazon", "Google", "Microsoft", "Bloomberg"],
        keyIdeaEn: "1D boolean DP tracking if prefix s[0..i] can be segmented into dictionary words.",
        keyIdeaBn: "১D বুলিয়ান DP দিয়ে ডিকশনারি শব্দের সাবস্ট্রিং স্প্লিট চেক করুন।",
      ),
      DPProblem(
        title: "Unique Paths",
        difficulty: "Medium",
        companyTags: ["Meta", "Amazon", "Google", "Microsoft"],
        keyIdeaEn: "2D Grid DP dp[r][c] = dp[r-1][c] + dp[r][c-1] with O(C) row space optimization.",
        keyIdeaBn: "গ্রিড DP দিয়ে রুট থেকে ডেস্টিনেশনে মোট পথের সংখ্যা গণনা করুন।",
      ),
    ];
  }

  static List<DPProblem> getHardProblems() {
    return const [
      DPProblem(
        title: "Edit Distance",
        difficulty: "Hard",
        companyTags: ["Amazon", "Meta", "Google", "Microsoft", "Bloomberg"],
        keyIdeaEn: "2D DP matching text1[i] and text2[j] choosing min(Insert, Delete, Replace) + 1.",
        keyIdeaBn: "ইনসার্ট, ডিলিট ও রিপ্লেসের মধ্যে সর্বনিম্ন অপারেশন মেপে ২D DP চালান।",
        isPopular: true,
      ),
      DPProblem(
        title: "Trapping Rain Water (DP Approach)",
        difficulty: "Hard",
        companyTags: ["Amazon", "Meta", "Google", "Microsoft", "Apple"],
        keyIdeaEn: "Precompute maxLeft[i] and maxRight[i] arrays to calculate trapped water min(L, R) - height[i].",
        keyIdeaBn: "বাম ও ডানের সর্বোচ্চ উচ্চতার এরে বানিয়ে জমানো পানির পরিমাণ মেপুন।",
        isPopular: true,
      ),
      DPProblem(
        title: "Burst Balloons",
        difficulty: "Hard",
        companyTags: ["Google", "Amazon", "Meta", "Microsoft"],
        keyIdeaEn: "Interval DP dp[i][j] tracking maximum coins obtained by bursting balloon k last in range [i..j].",
        keyIdeaBn: "ইনটারভাল DP দিয়ে রেঞ্জে শেষ বেলুন ফাটানোর সর্বোচ্চ পয়েন্ট পান।",
      ),
    ];
  }

  static List<Map<String, String>> getCommonMistakes(bool isEnglish) {
    if (isEnglish) {
      return [
        {
          "title": "1. Confusing Top-Down Memoization vs Bottom-Up Tabulation",
          "desc": "Forgetting to initialize memoization table (`dp` filled with `-1`) causes infinite recursion or exponential O(2^N) time!"
        },
        {
          "title": "2. Incorrect DP Base Case Initialization",
          "desc": "Setting `dp[0]` to 0 instead of 1 in combination/ways counting, or failing to initialize 0-capacity column in Knapsack."
        },
        {
          "title": "3. Out-of-Bounds Indexing in State Transition",
          "desc": "Accessing `dp[i-2]` or `dp[w - weight]` without bounds checking causes SegFaults or negative array index crashes."
        },
        {
          "title": "4. Wrong Inner Loop Direction in 1D 0/1 Knapsack",
          "desc": "In 1D array space optimization for 0/1 Knapsack, iterating weight loop forward instead of backwards (`for (w = capacity; w >= weight; w--)`) accidentally turns 0/1 Knapsack into Unbounded Knapsack!"
        },
        {
          "title": "5. Missing Subproblem Independence",
          "desc": "Applying DP when subproblems are not independent or lack optimal substructure leads to wrong answers."
        },
      ];
    } else {
      return [
        {
          "title": "১. মেমোইজেশন টেবিল ইনিশিয়ালাইজ না করা",
          "desc": "Top-Down মেমোইজেশন টেবিলে `-1` দিয়ে ইনিশিয়ালাইজ করতে ভুলে গেলে রিকার্শন প্রতিবার বারবার চলবে এবং O(2^N) টাইম লেগে যাবে।"
        },
        {
          "title": "২. DP টেবিলের বেস কেসে ভুল মান দেওয়া",
          "desc": "কম্বিনেশন বা উপায়ের সংখ্যা গণনায় `dp[0]` কে 0 ধরে নেওয়া (১ ধরা উচিত ছিল) পুরো টেবিলের মান ০ বানিয়ে ফেলে।"
        },
        {
          "title": "৩. আউট-অফ-বাউন্ডস ইনডেক্সিং (`dp[i-2]` বা `dp[w - weight]`)",
          "desc": "ইনডেক্স ০ এর নিচে চলে গেলে চেক ছাড়া অ্যাক্সেস করায় সেগমেন্টেশন ফল্ট বা মেমোরি ক্র্যাশ ঘটে।"
        },
        {
          "title": "৪. ১D 0/1 Knapsack এ ভিতরের লুপ সোজা চালানো",
          "desc": "১D 0/1 Knapsack এ ক্যাপাসিটি লুপ উল্টো (`w = capacity; w >= weight; w--`) না চালিয়ে সোজা চালালে একই আইটেম বারবার ব্যবহার হয়ে Unbounded Knapsack হয়ে যাবে!"
        },
        {
          "title": "৫. সাবপ্রবলেম ইন্ডিপেন্ডেন্ট না হলে জোর করে DP লাগানো",
          "desc": "প্রবলেমে অপটিমাল সাবস্ট্রাকচার না থাকা সত্ত্বেও জোর করে DP দিলে ভুল উত্তর আসবে।"
        },
      ];
    }
  }
}
