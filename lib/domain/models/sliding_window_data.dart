class SlidingWindowProblem {
  final String title;
  final String difficulty; // Easy, Medium, Hard
  final List<String> companyTags;
  final String keyIdeaEn;
  final String keyIdeaBn;
  final bool isPopular;

  const SlidingWindowProblem({
    required this.title,
    required this.difficulty,
    required this.companyTags,
    required this.keyIdeaEn,
    required this.keyIdeaBn,
    this.isPopular = false,
  });
}

class SlidingWindowData {
  static Map<String, String> getConceptIntro(bool isEnglish) {
    if (isEnglish) {
      return {
        "title": "Sliding Window — Complete Deep Dive (C++ & FAANG Focus)",
        "summary": "Sliding Window maintains a contiguous dynamic or fixed range over an array/string to calculate subarray statistics in linear O(N) time, avoiding O(N²) nested re-computation by reusing overlapping elements.",
        "whenToUseTitle": "When to Use Sliding Window?",
        "whenToUse1": "Problem requires finding contiguous subarrays or substrings.",
        "whenToUse2": "Fixed size window K (e.g. Max Sum Subarray of size K).",
        "whenToUse3": "Dynamic window targeting max/min length under a constraint.",
        "whenToUse4": "Substring character frequency matching or anagram checking.",
        "whenToUse5": "Eliminates O(N²) brute force nested loops over contiguous sub-ranges.",
        "typesTitle": "3 Main Sliding Window Patterns",
        "type1Title": "1. Fixed Size Window (K)",
        "type1Desc": "Window size is fixed at K. Expand to K elements, then slide both left and right pointers together (val = val + arr[right] - arr[left++]).",
        "type2Title": "2. Dynamic / Flexible Window (Max Length)",
        "type2Desc": "Expand right to include elements. If window breaks constraint, shrink left until valid again. Track max_len = max(max_len, right - left + 1).",
        "type3Title": "3. Dynamic / Flexible Window (Min Length)",
        "type3Desc": "Expand right until constraint is satisfied (e.g. sum >= target). Then shrink left greedily to find smallest valid window (min_len = min(min_len, right - left + 1)).",
      };
    } else {
      return {
        "title": "Sliding Window — সম্পূর্ণ গাইড (C++ ও FAANG ফোকাস)",
        "summary": "Sliding Window হলো একটি নির্দিষ্ট সাইজ (K) বা পরিবর্তনশীল (Dynamic) উইন্ডো বজায় রেখে অ্যারে বা স্ট্রিংয়ের পর পর এলিমেন্ট প্রসেস করা, যাতে O(N²) লুপ বাদ দিয়ে O(N) এ সমাধান পাওয়া যায়।",
        "whenToUseTitle": "কখন বুঝবা Sliding Window লাগবে?",
        "whenToUse1": "সমস্যাটিতে কন্টিনিউয়াস (Contiguous) সাব-অ্যারে বা সাব-স্ট্রিং চাওয়া হয়।",
        "whenToUse2": "ফিক্সড সাইজ K উইন্ডো (যেমন K দৈর্ঘ্যের সর্বোচ্চ যোগফল)।",
        "whenToUse3": "ডাইনামিক উইন্ডো যেখানে সর্বোচ্চ বা সর্বনিম্ন দৈর্ঘ্য চাওয়া হয়েছে।",
        "whenToUse4": "স্ট্রিংয়ের অক্ষর ফ্রিকোয়েন্সি বা অ্যানাগ্রাম কম্বিনেশন ম্যাচ করা।",
        "whenToUse5": "O(N²) নেস্টেড লুপের বদলে O(N) লিনিয়ার টাইম পাওয়া।",
        "typesTitle": "Main Types (৩ ধরনের pattern)",
        "type1Title": "১. Fixed Size Window (K)",
        "type1Desc": "উইন্ডোর দৈর্ঘ্য K ফিক্সড। K এলিমেন্ট হওয়ার পর বাম ও ডান পয়েন্টার একসাথে ১ ঘর করে আগাবে (curr_sum += arr[right] - arr[left++])।",
        "type2Title": "২. Dynamic Window (Max Length)",
        "type2Desc": "ডান পয়েন্টার বাড়িয়ে উইন্ডো বড় করো। শর্ত ভেঙে গেলে বাম পয়েন্টার দিয়ে উইন্ডো ছোট করো। সর্বোচ্চ দৈর্ঘ্য ট্র্যাক করো।",
        "type3Title": "৩. Dynamic Window (Min Length)",
        "type3Desc": "ডান পয়েন্টার বাড়িয়ে শর্ত পূরণ করো (sum >= target)। শর্ত পূরণ হলে বাম পয়েন্টার ছোট করে সর্বনিম্ন দৈর্ঘ্য বের করো।",
      };
    }
  }

  static List<SlidingWindowProblem> getEasyProblems() {
    return const [
      SlidingWindowProblem(
        title: "Maximum Average Subarray I",
        difficulty: "Easy",
        companyTags: ["Amazon", "Meta"],
        keyIdeaEn: "Fixed size K window. Compute sum of first K elements, then slide window adding right and subtracting left.",
        keyIdeaBn: "ফিক্সড সাইজ K উইন্ডো। প্রথম K এলিমেন্টের সাম বের করে ডান যোগ ও বাম বিয়োগ করে স্লাইড করুন।",
        isPopular: true,
      ),
      SlidingWindowProblem(
        title: "Contains Duplicate II",
        difficulty: "Easy",
        companyTags: ["Amazon", "Meta", "Microsoft"],
        keyIdeaEn: "Fixed size K sliding window hash set. Remove nums[i-k] when window exceeds size K.",
        keyIdeaBn: "ফিক্সড সাইজ K স্লাইডিং উইন্ডো হ্যাশ সেট। সাইজ K পার হলে বাম উপাদান বাদ দিন।",
        isPopular: true,
      ),
      SlidingWindowProblem(
        title: "Defuse the Bomb",
        difficulty: "Easy",
        companyTags: ["Amazon", "Google"],
        keyIdeaEn: "Circular array sliding window sum over next/previous K elements.",
        keyIdeaBn: "সার্কুলার অ্যারে স্লাইডিং উইন্ডো দিয়ে পরবর্তী বা পূর্ববর্তী K উপাদান যোগ করুন।",
      ),
      SlidingWindowProblem(
        title: "Minimum Recolors to Get K Consecutive Black Blocks",
        difficulty: "Easy",
        companyTags: ["Meta", "Amazon"],
        keyIdeaEn: "Fixed window of size K. Track minimum count of 'W' characters inside window.",
        keyIdeaBn: "ফিক্সড K উইন্ডোতে সর্বনিম্ন 'W' ক্যারেক্টার গণনা করুন।",
      ),
      SlidingWindowProblem(
        title: "Substrings of Size Three with Distinct Characters",
        difficulty: "Easy",
        companyTags: ["Google", "Amazon"],
        keyIdeaEn: "Fixed window K = 3. Check if all 3 characters are unique.",
        keyIdeaBn: "ফিক্সড K = 3 উইন্ডোতে ৩টি অক্ষরই আলাদা কিনা চেক করুন।",
      ),
      SlidingWindowProblem(
        title: "Find All Anagrams in a String",
        difficulty: "Easy",
        companyTags: ["Meta", "Amazon", "Microsoft"],
        keyIdeaEn: "Fixed size window = p.length(). Compare frequency array counts of length 26.",
        keyIdeaBn: "ফিক্সড উইন্ডো সাইজ p.length()। ২৬ আকারের ফ্রিকোয়েন্সি অ্যারে মিলিয়ে স্লাইড করুন।",
        isPopular: true,
      ),
      SlidingWindowProblem(
        title: "Permutation in String",
        difficulty: "Easy",
        companyTags: ["Meta", "Microsoft", "Yandex"],
        keyIdeaEn: "Fixed sliding window frequency matching for string s1 inside s2.",
        keyIdeaBn: "s1 এর ফ্রিকোয়েন্সি s2 এর ফিক্সড স্লাইডিং উইন্ডোতে মেলান।",
      ),
      SlidingWindowProblem(
        title: "Grumpy Bookstore Owner",
        difficulty: "Easy",
        companyTags: ["Amazon", "Meta"],
        keyIdeaEn: "Fixed window of minutes X to maximize satisfied customers.",
        keyIdeaBn: "X মিনিটের ফিক্সড উইন্ডো স্লাইড করে সর্বোচ্চ সন্তুষ্ট কাস্টমার বের করুন।",
      ),
    ];
  }

  static List<SlidingWindowProblem> getMediumProblems() {
    return const [
      SlidingWindowProblem(
        title: "Longest Substring Without Repeating Characters",
        difficulty: "Medium",
        companyTags: ["Meta", "Amazon", "Google", "Apple"],
        keyIdeaEn: "Dynamic window. Expand right, track last index of chars. If duplicate, jump left = max(left, map[char] + 1).",
        keyIdeaBn: "ডাইনামিক উইন্ডো। ডান বাড়াও, ডুপ্লিকেট পেলে বাম পয়েন্টার লাফ দিয়ে জ্যাম্প করাও।",
        isPopular: true,
      ),
      SlidingWindowProblem(
        title: "Longest Repeating Character Replacement",
        difficulty: "Medium",
        companyTags: ["Meta", "Amazon", "Google"],
        keyIdeaEn: "Dynamic window. Track max_freq. If (window_len - max_freq > k), shrink left.",
        keyIdeaBn: "ডাইনামিক উইন্ডো। সর্বোচ্চ ফ্রিকোয়েন্সি দিয়ে (window_len - max_freq > k) হলে বাম কমান।",
        isPopular: true,
      ),
      SlidingWindowProblem(
        title: "Minimum Size Subarray Sum",
        difficulty: "Medium",
        companyTags: ["Meta", "Amazon", "Microsoft"],
        keyIdeaEn: "Dynamic window (Min length). Expand right until sum >= target, then shrink left while valid.",
        keyIdeaBn: "ডাইনামিক সর্বনিম্ন দৈর্ঘ্য। sum >= target হওয়া পর্যন্ত ডান বাড়ান, তারপর বাম কমিয়ে মিনিমাম বের করুন।",
        isPopular: true,
      ),
      SlidingWindowProblem(
        title: "Max Consecutive Ones III",
        difficulty: "Medium",
        companyTags: ["Meta", "Google", "Amazon"],
        keyIdeaEn: "Dynamic window allowing at most K zeroes. Expand right, shrink left when zeros > k.",
        keyIdeaBn: "সর্বোচ্চ K টি ০ অনুমোদনকারী ডাইনামিক উইন্ডো। zeros > k হলে বাম কমান।",
        isPopular: true,
      ),
      SlidingWindowProblem(
        title: "Fruit Into Baskets",
        difficulty: "Medium",
        companyTags: ["Google", "Amazon"],
        keyIdeaEn: "Dynamic window allowing at most 2 distinct fruit types in hash map.",
        keyIdeaBn: "সর্বোচ্চ ২টি ফল টাইপের ডাইনামিক উইন্ডো।",
      ),
      SlidingWindowProblem(
        title: "Subarray Product Less Than K",
        difficulty: "Medium",
        companyTags: ["Meta", "Amazon"],
        keyIdeaEn: "Dynamic window multiplying right. Shrink left while product >= k. Count subarrays += right - left + 1.",
        keyIdeaBn: "গুণফল কমানোর স্লাইডিং উইন্ডো। গুণফল >= k হলে বাম কমান।",
      ),
      SlidingWindowProblem(
        title: "Get Equal Substrings Within Budget",
        difficulty: "Medium",
        companyTags: ["Meta", "Google"],
        keyIdeaEn: "Dynamic window sum of absolute ASCII differences <= maxCost.",
        keyIdeaBn: "ASCII পার্থক্যের সমষ্টি <= maxCost বজায় রেখে ডাইনামিক উইন্ডো স্লাইড করুন।",
      ),
      SlidingWindowProblem(
        title: "Count Number of Nice Subarrays",
        difficulty: "Medium",
        companyTags: ["Amazon", "Meta"],
        keyIdeaEn: "Transform odds to 1 and evens to 0. Exactly K odds = atMost(K) - atMost(K-1).",
        keyIdeaBn: "বিজোড় সংখ্যাকে ১ ধরে atMost(K) - atMost(K-1) স্লাইডিং উইন্ডো মেলান।",
      ),
    ];
  }

  static List<SlidingWindowProblem> getHardProblems() {
    return const [
      SlidingWindowProblem(
        title: "Minimum Window Substring",
        difficulty: "Hard",
        companyTags: ["Meta", "Amazon", "Google", "Uber"],
        keyIdeaEn: "Dynamic min window + frequency match. Expand right until all chars match, shrink left greedily.",
        keyIdeaBn: "ডাইনামিক মিনিমাম উইন্ডো + ফ্রিকোয়েন্সি ম্যাচ। সব অক্ষর মিললে বাম থেকে কমিয়ে শর্টেস্ট বের করুন।",
        isPopular: true,
      ),
      SlidingWindowProblem(
        title: "Sliding Window Maximum",
        difficulty: "Hard",
        companyTags: ["Amazon", "Meta", "Google", "Microsoft"],
        keyIdeaEn: "Monotonic Decreasing Deque storing indices. Deque front always holds maximum of current window of size K.",
        keyIdeaBn: "মনোটোনিক ডিকিউ (Monotonic Deque)। ডিকিউ ফ্রন্টে সবসময় K সাইজের সর্বোচ্চ মান থাকবে।",
        isPopular: true,
      ),
      SlidingWindowProblem(
        title: "Substring with Concatenation of All Words",
        difficulty: "Hard",
        companyTags: ["Amazon", "Meta"],
        keyIdeaEn: "Multi-offset sliding window matching word counts of equal length L.",
        keyIdeaBn: "সমান দৈর্ঘ্যের সব শব্দ কনক্যাটেনেট করে স্লাইডিং উইন্ডো ফ্রিকোয়েন্সি ম্যাচ।",
      ),
    ];
  }

  static List<Map<String, String>> getCommonMistakes(bool isEnglish) {
    if (isEnglish) {
      return [
        {
          "title": "1. Forgetting to Shrink Window (left++)",
          "desc": "Expanding right pointer continuously without advancing left when constraint breaks turns sliding window into brute force or invalid window sizes."
        },
        {
          "title": "2. Off-by-One Window Size Calculation",
          "desc": "Calculating window size as `right - left` instead of `right - left + 1` causes off-by-one errors."
        },
        {
          "title": "3. Re-calculating Window Metrics in O(K)",
          "desc": "Re-summing or re-counting elements inside window from scratch at each step instead of updating incrementally in O(1) time."
        },
        {
          "title": "4. Incorrect Shrink Condition (Max vs Min)",
          "desc": "Shrinking when valid in Max Window problems or shrinking when invalid in Min Window problems leads to incorrect logic."
        },
        {
          "title": "5. Not Updating Frequency Map on Left Shrink",
          "desc": "Forgetting `freq[s[left]]--` when advancing `left++` corrupts hash map frequency state."
        },
      ];
    } else {
      return [
        {
          "title": "১. বাম পয়েন্টার (left++) না বাড়িয়ে উইন্ডো বড় করা",
          "desc": "শর্ত ভাঙার পর বাম পয়েন্টার না বাড়ালে উইন্ডো ভুল ফল দেবে এবং O(N) লিনিয়ার টাইম থাকবে না।"
        },
        {
          "title": "২. উইন্ডোর দৈর্ঘ্য গণনায় Off-by-One ভুল",
          "desc": "উইন্ডোর সঠিক দৈর্ঘ্য `right - left + 1` এর বদলে `right - left` লিখলে ১ এলিমেন্ট কম গণনা হবে।"
        },
        {
          "title": "৩. প্রতি পদক্ষেপে নতুন করে O(K) যোগফল বের করা",
          "desc": "উইন্ডো স্লাইড করার পর আবার নতুন করে লুপ চালিয়ে যোগফল না বের করে O(1) এ `curr += new - old` করা উচিত।"
        },
        {
          "title": "৪. Max vs Min উইন্ডো কমানোর শর্তে ভুল",
          "desc": "Max Window এ শর্ত ভাঙলে বাম সরাতে হয়, আর Min Window এ শর্ত মিললে মিনিমাম নেওয়ার জন্য বাম সরাতে হয়।"
        },
        {
          "title": "৫. বাম পয়েন্টার সরানোর সময় ম্যাপ ফ্রিকোয়েন্সি বিয়োগ না করা",
          "desc": "বাম পয়েন্টার `left++` করার সময় `freq[s[left]]--` করতে ভুলে গেলে হ্যাশ ম্যাপের ডাটা নষ্ট হয়ে যায়।"
        },
      ];
    }
  }
}
