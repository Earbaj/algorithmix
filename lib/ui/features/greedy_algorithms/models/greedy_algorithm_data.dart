class GreedyProblem {
  final String title;
  final String difficulty; // Easy, Medium, Hard
  final List<String> companyTags;
  final String keyIdeaEn;
  final String keyIdeaBn;
  final bool isPopular;

  const GreedyProblem({
    required this.title,
    required this.difficulty,
    required this.companyTags,
    required this.keyIdeaEn,
    required this.keyIdeaBn,
    this.isPopular = false,
  });
}

class GreedyAlgorithmData {
  static Map<String, String> getConceptIntro(bool isEnglish) {
    if (isEnglish) {
      return {
        "title": "Greedy Algorithms Pattern — Complete Deep Dive (C++ & FAANG Focus)",
        "summary": "Greedy Algorithms build up a solution step by step, always making the choice that offers the most immediate (locally optimal) benefit without ever reconsidering past choices. For greedy to yield a globally optimal solution, the problem must possess two key properties: 1) Greedy Choice Property, and 2) Optimal Substructure.",
        "whenToUseTitle": "When to Use Greedy Algorithms?",
        "whenToUse1": "Jump Game reachability & minimum jumps (LeetCode 55, 45).",
        "whenToUse2": "Interval Scheduling / Non-overlapping Intervals (LeetCode 435, 452).",
        "whenToUse3": "Gas Station circular trip (LeetCode 134).",
        "whenToUse4": "Task Scheduling & Rearranging Strings (LeetCode 621, 767).",
        "whenToUse5": "Partition Labels / Candy Distribution (LeetCode 763, 135).",
        "typesTitle": "3 Main Greedy Algorithm Patterns",
        "type1Title": "1. Jump Game / Reachability (Farthest Reach Track)",
        "type1Desc": "Track maxReach = max(maxReach, i + nums[i]). If i > maxReach, unreachable. If maxReach >= N - 1, destination is reachable in O(N) time and O(1) space.",
        "type2Title": "2. Interval Scheduling (Sort by End Time)",
        "type2Desc": "Sort intervals by finish end time. Always greedily pick interval with earliest end time to leave maximum room for remaining intervals.",
        "type3Title": "3. Circular Resource Accumulation (Gas Station)",
        "type3Desc": "If totalGas >= totalCost, a valid starting station exists. Reset starting station to i + 1 whenever currentTank < 0.",
      };
    } else {
      return {
        "title": "Greedy Algorithms Pattern — সম্পূর্ণ গাইড (C++ ও FAANG ফোকাস)",
        "summary": "Greedy Algorithms প্রতি ধাপে স্থানীয়ভাবে সবচেয়ে লাভজনক (Locally Optimal) সিদ্ধান্ত গ্রহণ করে গ্লোবাল সমাধান তৈরি করে। গ্রিডি কাজ করার জন্য প্রবলেমে দুটি বৈশিষ্ট্য থাকতে হবে: ১) গ্রিডি চয়েস প্রপার্টি এবং ২) অপটিমাল সাবস্ট্রাকচার।",
        "whenToUseTitle": "কখন বুঝবা Greedy Algorithm লাগবে?",
        "whenToUse1": "লাফিয়ে শেষ গন্তব্যে পৌঁছানো বা সর্বনিম্ন জাম্প সংখ্যা বের করতে (LeetCode 55, 45)।",
        "whenToUse2": "পরস্পর ওভারল্যাপ না করা ইনটারভাল শিডিউলিং প্রবলেমে (LeetCode 435, 452)।",
        "whenToUse3": "গ্যাস স্টেশনে চক্রাকার ভ্রমণ সম্পন্ন করার প্রবলেমে (LeetCode 134)।",
        "whenToUse4": "টাস্ক শিডিউলিং বা অক্ষরের ফ্রিকোয়েন্সি রি-অর্গানাইজেশনে (LeetCode 621, 767)।",
        "whenToUse5": "চকলেট বন্টন (Candy) বা স্ট্রিং পার্টিশনে (LeetCode 135, 763)।",
        "typesTitle": "Main Types (৩ ধরনের pattern)",
        "type1Title": "১. Jump Game / Reachability (সর্বোচ্চ দূরত্বের জাম্প)",
        "type1Desc": "`maxReach = max(maxReach, i + nums[i])` ট্র্যাক করো। `i > maxReach` হলে পৌঁছানো অসম্ভব। `maxReach >= N - 1` হলে O(N) টাইমে গন্তব্যে পৌঁছানো সম্ভব।",
        "type2Title": "২. Interval Scheduling (শেষ সময় অনুযায়ী সর্ট)",
        "type2Desc": "ইনটারভালগুলো শেষ হওয়ার সময় (End Time) অনুযায়ী সর্ট করো। সবচেয়ে আগে শেষ হওয়া ইনটারভাল সিলেক্ট করো যাতে বাকিদের জন্য বেশি জায়গা থাকে।",
        "type3Title": "৩. Circular Resource Accumulation (গ্যাস স্টেশন)",
        "type3Desc": "`totalGas >= totalCost` হলে স্টার্ট ইনডেক্স অবশ্যই বিদ্যমান। `currentTank < 0` হলে স্টার্ট ইনডেক্স পরিবর্তন করো।",
      };
    }
  }

  static List<GreedyProblem> getEasyProblems() {
    return const [
      GreedyProblem(
        title: "Best Time to Buy and Sell Stock",
        difficulty: "Easy",
        companyTags: ["Amazon", "Meta", "Google", "Microsoft"],
        keyIdeaEn: "Track minimum buying price seen so far and greedily calculate maximum profit.",
        keyIdeaBn: "সর্বনিম্ন ক্রয়মূল্য ট্র্যাকিং করে সর্বোচ্চ লাভ হিসেব করুন।",
        isPopular: true,
      ),
      GreedyProblem(
        title: "Assign Cookies",
        difficulty: "Easy",
        companyTags: ["Amazon", "Meta"],
        keyIdeaEn: "Sort children greed and cookie sizes. Greedily satisfy least greedy child first.",
        keyIdeaBn: "সর্ট করে কম লোভী শিশুকে আগে কুকি প্রদান করুন।",
        isPopular: true,
      ),
      GreedyProblem(
        title: "Lemonade Change",
        difficulty: "Easy",
        companyTags: ["Amazon", "Meta", "Google"],
        keyIdeaEn: "Greedily prefer giving 10+5 dollar bills as change before 5+5+5.",
        keyIdeaBn: "ভাংতি দেওয়ার ক্ষেত্রে গ্রিডি নিয়মে ১০ ডলার বিল আগে ব্যবহার করুন।",
        isPopular: true,
      ),
      GreedyProblem(
        title: "Maximum Units on a Truck",
        difficulty: "Easy",
        companyTags: ["Amazon", "Meta"],
        keyIdeaEn: "Sort box types by units per box descending. Greedily pick highest unit boxes first.",
        keyIdeaBn: "ইউনিট সংখ্যা অনুযায়ী সর্ট করে সেরা বক্স আগে ট্রাকে দিন।",
      ),
      GreedyProblem(
        title: "Can Place Flowers",
        difficulty: "Easy",
        companyTags: ["Amazon", "Meta", "Google"],
        keyIdeaEn: "Greedily plant flower whenever left and right adjacent slots are empty.",
        keyIdeaBn: "দুই পাশ খালি থাকলে সাথে সাথে ফুল রোপণ করুন।",
      ),
      GreedyProblem(
        title: "Minimum Sum of Four Digit Number",
        difficulty: "Easy",
        companyTags: ["Google", "Amazon"],
        keyIdeaEn: "Sort 4 digits and pair smallest digits into 10s place of 2 numbers.",
        keyIdeaBn: "ডিজিট সর্ট করে ছোট ২টি ডিজিটকে দশকের ঘরে রেখে ২ সংখ্যা বানান।",
      ),
      GreedyProblem(
        title: "Split a String in Balanced Strings",
        difficulty: "Easy",
        companyTags: ["Amazon", "Meta"],
        keyIdeaEn: "Greedily split string whenever count of L equals count of R.",
        keyIdeaBn: "L ও R এর সংখ্যা সমান হলে সঙ্গে সঙ্গে স্ট্রিং স্প্লিট করুন।",
      ),
      GreedyProblem(
        title: "Minimum Cost to Move Chips to The Same Position",
        difficulty: "Easy",
        companyTags: ["Google", "Amazon"],
        keyIdeaEn: "Count odd and even position chips. Minimum cost is min(oddCount, evenCount).",
        keyIdeaBn: "জোড় ও বিজোড় পজিশনের চিপ সংখ্যা মেপে ন্যূনতম খরচ বের করুন।",
      ),
    ];
  }

  static List<GreedyProblem> getMediumProblems() {
    return const [
      GreedyProblem(
        title: "Jump Game",
        difficulty: "Medium",
        companyTags: ["Meta", "Amazon", "Google", "Microsoft", "Bloomberg"],
        keyIdeaEn: "Track maxReach = max(maxReach, i + nums[i]). If i > maxReach return false in O(N).",
        keyIdeaBn: "maxReach ট্র্যাক করে ও একপাশে এগিয়ে গন্তব্যে পৌঁছানো যায় কিনা চেক করুন।",
        isPopular: true,
      ),
      GreedyProblem(
        title: "Jump Game II",
        difficulty: "Medium",
        companyTags: ["Meta", "Amazon", "Google", "Microsoft"],
        keyIdeaEn: "Track currentEnd and maxReach. When i == currentEnd, increment jumps++ and update currentEnd = maxReach.",
        keyIdeaBn: "উইন্ডো শেষ সীমা পৌছালে জাম্প বাড়িয়ে পরবর্তী সর্বোচ্চ সীমানায় লাফ দিন।",
        isPopular: true,
      ),
      GreedyProblem(
        title: "Non-overlapping Intervals",
        difficulty: "Medium",
        companyTags: ["Meta", "Amazon", "Google", "Microsoft"],
        keyIdeaEn: "Sort intervals by END time. Greedily remove interval if start < prevEnd.",
        keyIdeaBn: "শেষ সময় দিয়ে সর্ট করে ওভারল্যাপ ইনটারভাল ছেঁটে ফেলুন।",
        isPopular: true,
      ),
      GreedyProblem(
        title: "Gas Station",
        difficulty: "Medium",
        companyTags: ["Meta", "Amazon", "Google", "Microsoft"],
        keyIdeaEn: "Check totalGas >= totalCost. Reset start index to i + 1 whenever currentTank < 0.",
        keyIdeaBn: "ফুয়েল ঘাটতি হলে স্টার্ট পজিশন পরের ঘরে স্থানান্তরিত করুন।",
        isPopular: true,
      ),
      GreedyProblem(
        title: "Partition Labels",
        difficulty: "Medium",
        companyTags: ["Amazon", "Meta", "Google"],
        keyIdeaEn: "Record last occurrences of all characters. Squeeze partition boundaries greedily.",
        keyIdeaBn: "অক্ষরের শেষ অবস্থান মেপে গ্রিডি নিয়মে পার্টিশন সাইজ বের করুন।",
      ),
      GreedyProblem(
        title: "Minimum Number of Arrows to Burst Balloons",
        difficulty: "Medium",
        companyTags: ["Amazon", "Meta", "Google"],
        keyIdeaEn: "Sort balloons by END coordinate. Shoot arrow at end of first balloon.",
        keyIdeaBn: "বেলুন শেষ পজিশন অনুযায়ী সর্ট করে কম তীর মেরে ফুটান।",
      ),
      GreedyProblem(
        title: "Hand of Straights",
        difficulty: "Medium",
        companyTags: ["Google", "Amazon"],
        keyIdeaEn: "Map frequency of numbers. Greedily construct straight hands starting from minimum number.",
        keyIdeaBn: "ক্ষুদ্রতম সংখ্যা থেকে শুরু করে সোজা হাতের কার্ডের গ্রুপ তৈরি করুন।",
      ),
      GreedyProblem(
        title: "Task Scheduler",
        difficulty: "Medium",
        companyTags: ["Meta", "Amazon", "Google", "Microsoft"],
        keyIdeaEn: "Greedily schedule most frequent task first with idle cooling slots.",
        keyIdeaBn: "সর্বোচ্চ ফ্রিকোয়েন্সির টাস্ক আগে শিডিউল করুন।",
      ),
    ];
  }

  static List<GreedyProblem> getHardProblems() {
    return const [
      GreedyProblem(
        title: "Candy",
        difficulty: "Hard",
        companyTags: ["Amazon", "Meta", "Google", "Microsoft", "Bloomberg"],
        keyIdeaEn: "Two-pass greedy: left-to-right pass satisfying right neighbor, then right-to-left pass satisfying left neighbor.",
        keyIdeaBn: "দুই ধাপে পাস করে প্রতিবেশীর চেয়ে বেশি ক্যান্ডি নিশ্চিত করুন।",
        isPopular: true,
      ),
      GreedyProblem(
        title: "Create Maximum Number",
        difficulty: "Hard",
        companyTags: ["Google", "Amazon"],
        keyIdeaEn: "Monotonic stack greedy selection + 2-vector greedy merge.",
        keyIdeaBn: "মনোটোনিক স্ট্যাক গ্রিডি বাছাই ও দুই ভেক্টরের সেরা মার্জ।",
      ),
      GreedyProblem(
        title: "IPO (Maximize Capital)",
        difficulty: "Hard",
        companyTags: ["Meta", "Amazon", "Google", "Microsoft"],
        keyIdeaEn: "Min-Heap for capital required, Max-Heap for profit greedy selection.",
        keyIdeaBn: "Min-Heap ক্যাপিটাল ও Max-Heap প্রফিট দিয়ে সর্বোচ্চ লাভ পান।",
      ),
    ];
  }

  static List<Map<String, String>> getCommonMistakes(bool isEnglish) {
    if (isEnglish) {
      return [
        {
          "title": "1. Assuming Greedy Always Works Without Proof",
          "desc": "Applying a greedy choice to a Dynamic Programming problem (like 0/1 Knapsack or Coin Change) leads to wrong answers. Verify Greedy Choice Property first!"
        },
        {
          "title": "2. Sorting by Start Time Instead of End Time in Interval Scheduling",
          "desc": "In Non-overlapping Intervals (LeetCode 435), sorting by start time fails. Sorting by END time leaves maximum room for future intervals."
        },
        {
          "title": "3. Forgetting to Check Global Feasibility",
          "desc": "In Gas Station (LeetCode 134), resetting local tank without checking if `totalGas >= totalCost` leads to false start index returns."
        },
        {
          "title": "4. Off-by-One in Jump Game Boundaries",
          "desc": "In Jump Game II (LeetCode 45), updating `jumps++` when `i == currentEnd` requires stopping at `N - 2` so final jump is counted correctly."
        },
        {
          "title": "5. Modifying Input Arrays Without Necessity",
          "desc": "Sorting input in place when original order is required by downstream callers."
        },
      ];
    } else {
      return [
        {
          "title": "১. প্রমাণ ছাড়াই সব প্রবলেমে গ্রিডি ব্যবহার করা",
          "desc": "ডাইনামিক প্রোগ্রামিং প্রবলেমে (যেমন 0/1 ক্যানপস্যাক বা কয়েন চেঞ্জ) গ্রিডি দিলে ভুল উত্তর আসবে। আগে গ্রিডি চয়েস প্রপার্টি নিশ্চিত করতে হবে!"
        },
        {
          "title": "২. ইনটারভাল শিডিউলিঙে End Time এর বদলে Start Time সর্ট করা",
          "desc": "Non-overlapping Intervals এ স্টার্ট টাইম দিয়ে সর্ট করলে ভুল আসবে। এন্ড টাইম (End Time) সর্ট করলে ভবিষ্যৎ ইনটারভালের জন্য বেশি জায়গা থাকে।"
        },
        {
          "title": "৩. গ্যাস স্টেশনে মোট ফুয়েল মেজার না করা",
          "desc": "`totalGas >= totalCost` চেক না করে সরাসরি স্টার্ট পজিশন রিটার্ন করলে উত্তর ভুল আসবে।"
        },
        {
          "title": "৪. জাম্প গেমের সীমানায় অফ-বাই-ওয়ান ভুল",
          "desc": "Jump Game II তে `jumps++` করার সময় `N - 2` পর্যন্ত লুপ না চালালে অতিরিক্ত ১টি জাম্প গননা হতে পারে।"
        },
        {
          "title": "৫. মূল ইনপুট অ্যারে না বুঝে মিউটেট করা",
          "desc": "ইনপুট অ্যারের ক্রমানুসার প্রয়োজন থাকা সত্ত্বেও ইন-প্লেস সর্ট করে ডাটা নষ্ট করে ফেলা।"
        },
      ];
    }
  }
}
