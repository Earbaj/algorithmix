class ModifiedBinarySearchProblem {
  final String title;
  final String difficulty; // Easy, Medium, Hard
  final List<String> companyTags;
  final String keyIdeaEn;
  final String keyIdeaBn;
  final bool isPopular;

  const ModifiedBinarySearchProblem({
    required this.title,
    required this.difficulty,
    required this.companyTags,
    required this.keyIdeaEn,
    required this.keyIdeaBn,
    this.isPopular = false,
  });
}

class ModifiedBinarySearchData {
  static Map<String, String> getConceptIntro(bool isEnglish) {
    if (isEnglish) {
      return {
        "title": "Modified Binary Search Pattern — Complete Deep Dive (C++ & FAANG Focus)",
        "summary": "Modified Binary Search extends standard O(log N) binary search to non-standard or altered search spaces, such as Rotated Sorted Arrays, Bitonic Peak Arrays, Matrix Grids, or Monotonic Predicate functions. The key insight is that in any rotated sorted array, at least one half (left or right) is always strictly sorted.",
        "whenToUseTitle": "When to Use Modified Binary Search?",
        "whenToUse1": "Searching elements in a Rotated Sorted Array (LeetCode 33, 81).",
        "whenToUse2": "Finding the Minimum / Pivot element in a Rotated Sorted Array (LeetCode 153, 154).",
        "whenToUse3": "Finding the First and Last Position of an element in a sorted array (LeetCode 34).",
        "whenToUse4": "Finding Peak Element / Bitonic Array Peak (LeetCode 162, 852).",
        "whenToUse5": "Monotonic Search on Answers (e.g. Koko Eating Bananas LeetCode 875, Capacity To Ship Packages LeetCode 1011).",
        "typesTitle": "3 Main Modified Binary Search Patterns",
        "type1Title": "1. Search in Rotated Sorted Array",
        "type1Desc": "Calculate mid. Check if left half (nums[low] <= nums[mid]) is sorted. If target lies within left half range, search left (high = mid - 1); else search right (low = mid + 1).",
        "type2Title": "2. First and Last Boundary Position",
        "type2Desc": "Instead of returning immediately when nums[mid] == target, save ans = mid and continue searching left (high = mid - 1) for first position, or right (low = mid + 1) for last position.",
        "type3Title": "3. Monotonic Answer Space Search (Koko Bananas)",
        "type3Desc": "Define answer range low = 1 to high = max_val. Test feasibility function isValid(mid). Squeeze search space to find minimum valid answer in O(N log MAX).",
      };
    } else {
      return {
        "title": "Modified Binary Search Pattern — সম্পূর্ণ গাইড (C++ ও FAANG ফোকাস)",
        "summary": "Modified Binary Search হলো সাধারণ O(log N) বাইনারি সার্চকে রোটেটেড অ্যারে, বিটোনিক ট্রি, ম্যাট্রিক্স গ্রিড বা উত্তর সীমানায় প্রয়োগ করা। এর মূল সূত্র হলো: একটি রোটেটেড সর্টেড অ্যারেতে যেকোনো পয়েন্টে mid নিলে অন্তত একটি অর্ধেক (বাম অথবা ডান) অবশ্যই সর্টেড থাকবে।",
        "whenToUseTitle": "কখন বুঝবা Modified Binary Search লাগবে?",
        "whenToUse1": "ঘূর্ণায়মান বা রোটেটেড সর্টেড অ্যারেতে (Rotated Sorted Array) উপাদান খুঁজতে বললে (LeetCode 33, 81)।",
        "whenToUse2": "রোটেটেড অ্যারের সর্বনিম্ন মান (Minimum / Pivot) বের করতে বললে (LeetCode 153, 154)।",
        "whenToUse3": "সর্টেড অ্যারেতে কোনো সংখ্যার ১ম ও শেষ ইনডেক্স (First and Last Position) বের করতে বললে (LeetCode 34)।",
        "whenToUse4": "পাহাড় বা বিটোনিক অ্যারের সর্বোচ্চ পিক উপাদান (Peak Element) বের করতে (LeetCode 162, 852)।",
        "whenToUse5": "উত্তর সীমানায় সার্চ চালিয়ে সম্ভাব্য সর্বনিম্ন/সর্বোচ্চ মান বের করতে (Koko Eating Bananas LeetCode 875)।",
        "typesTitle": "Main Types (৩ ধরনের pattern)",
        "type1Title": "১. Search in Rotated Sorted Array (রোটেটেড অ্যারে সার্চ)",
        "type1Desc": "mid বের করো। `nums[low] <= nums[mid]` হলে বাম অর্ধেক সর্টেড। টার্গেট বামে থাকলে `high = mid - 1`, অন্যথায় `low = mid + 1` কর।",
        "type2Title": "২. First and Last Boundary Position (সীমানা ইনডেক্স)",
        "type2Desc": "`nums[mid] == target` পাওয়া মাত্রই না থেমে `ans = mid` সেভ করে ১ম ইনডেক্সের জন্য বামে এবং শেষ ইনডেক্সের জন্য ডানে সার্চ চালু রাখো।",
        "type3Title": "৩. Monotonic Answer Space Search (উত্তরের ওপর বাইনারি সার্চ)",
        "type3Desc": "উত্তর সীমানা `low = 1` থেকে `high = max_val` ধরো। শর্ত চেককারী ফাংশন `isValid(mid)` দিয়ে উইন্ডো ছোট করো।",
      };
    }
  }

  static List<ModifiedBinarySearchProblem> getEasyProblems() {
    return const [
      ModifiedBinarySearchProblem(
        title: "Binary Search",
        difficulty: "Easy",
        companyTags: ["Amazon", "Meta", "Google", "Microsoft"],
        keyIdeaEn: "Classic O(log N) binary search on sorted array using low, mid, high pointers.",
        keyIdeaBn: "সর্টেড অ্যারেতে ক্লাসিক্যাল O(log N) বাইনারি সার্চ।",
        isPopular: true,
      ),
      ModifiedBinarySearchProblem(
        title: "Search Insert Position",
        difficulty: "Easy",
        companyTags: ["Amazon", "Meta", "Google"],
        keyIdeaEn: "Binary search returning low index when target is not found.",
        keyIdeaBn: "টার্গেট না পেলে ইনসার্ট ইনডেক্স হিসেবে low রিটার্ন করুন।",
        isPopular: true,
      ),
      ModifiedBinarySearchProblem(
        title: "First Bad Version",
        difficulty: "Easy",
        companyTags: ["Meta", "Amazon", "Google"],
        keyIdeaEn: "Binary search on boolean predicate function isBadVersion(mid).",
        keyIdeaBn: "বুলিয়ান ফাংশন দিয়ে ১ম খারাপ ভার্সন খুঁজে বের করুন।",
        isPopular: true,
      ),
      ModifiedBinarySearchProblem(
        title: "Guess Number Higher or Lower",
        difficulty: "Easy",
        companyTags: ["Google", "Amazon"],
        keyIdeaEn: "Binary search squeezing search space based on guess(mid) feedback.",
        keyIdeaBn: "গেসিং ফিডব্যাকের ওপর বাইনারি সার্চ চালান।",
      ),
      ModifiedBinarySearchProblem(
        title: "Sqrt(x)",
        difficulty: "Easy",
        companyTags: ["Amazon", "Meta", "Google"],
        keyIdeaEn: "Binary search on integer range 1 to x testing mid * mid <= x.",
        keyIdeaBn: "১ থেকে x সীমানায় mid * mid <= x মেপে বর্গমূল বের করুন।",
      ),
      ModifiedBinarySearchProblem(
        title: "Peak Index in a Mountain Array",
        difficulty: "Easy",
        companyTags: ["Amazon", "Google"],
        keyIdeaEn: "Binary search comparing arr[mid] < arr[mid + 1] to find mountain peak.",
        keyIdeaBn: "arr[mid] < arr[mid + 1] মেপে পাহাড়ের চূড়া বের করুন।",
      ),
      ModifiedBinarySearchProblem(
        title: "Arranging Coins",
        difficulty: "Easy",
        companyTags: ["Amazon", "Meta"],
        keyIdeaEn: "Binary search on completed stair rows formula (mid * (mid + 1)) / 2.",
        keyIdeaBn: "কয়েন দিয়ে ধাপ তৈরির বাইনারি সার্চ।",
      ),
      ModifiedBinarySearchProblem(
        title: "Find Smallest Letter Greater Than Target",
        difficulty: "Easy",
        companyTags: ["Google", "Amazon"],
        keyIdeaEn: "Binary search on sorted character array returning letters[low % N].",
        keyIdeaBn: "সর্টেড ক্যারেক্টার অ্যারেতে টার্গেটের চেয়ে বড় ছোট অক্ষর খুঁজুন।",
      ),
    ];
  }

  static List<ModifiedBinarySearchProblem> getMediumProblems() {
    return const [
      ModifiedBinarySearchProblem(
        title: "Search in Rotated Sorted Array",
        difficulty: "Medium",
        companyTags: ["Meta", "Amazon", "Google", "Microsoft", "Bloomberg"],
        keyIdeaEn: "Check which half is sorted at mid. Squeeze low/high based on target boundary.",
        keyIdeaBn: "mid এ কোন অর্ধেক সর্টেড চেক করুন। টার্গেট বাউন্ডারি মেপে low/high সরান।",
        isPopular: true,
      ),
      ModifiedBinarySearchProblem(
        title: "Find First and Last Position of Element",
        difficulty: "Medium",
        companyTags: ["Meta", "Amazon", "Google", "Microsoft"],
        keyIdeaEn: "Two modified binary searches: one for first index (high = mid - 1) and one for last index (low = mid + 1).",
        keyIdeaBn: "২টি বাইনারি সার্চ: ১ম ইনডেক্স ও শেষ ইনডেক্সের জন্য।",
        isPopular: true,
      ),
      ModifiedBinarySearchProblem(
        title: "Find Minimum in Rotated Sorted Array",
        difficulty: "Medium",
        companyTags: ["Meta", "Amazon", "Google", "Microsoft"],
        keyIdeaEn: "Binary search comparing nums[mid] with nums[high]. If nums[mid] > nums[high], min is in right half.",
        keyIdeaBn: "nums[mid] > nums[high] হলে সর্বনিম্ন মান ডান অর্ধে থাকবে।",
        isPopular: true,
      ),
      ModifiedBinarySearchProblem(
        title: "Find Peak Element",
        difficulty: "Medium",
        companyTags: ["Meta", "Amazon", "Google", "Microsoft"],
        keyIdeaEn: "Binary search comparing nums[mid] with nums[mid + 1]. Move towards higher neighbor.",
        keyIdeaBn: "nums[mid] < nums[mid + 1] হলে উচু প্রতিবেশীর দিকে সরুন।",
        isPopular: true,
      ),
      ModifiedBinarySearchProblem(
        title: "Koko Eating Bananas",
        difficulty: "Medium",
        companyTags: ["Meta", "Amazon", "Google", "Microsoft"],
        keyIdeaEn: "Binary search on answer speed range 1 to max(piles). Test total hours <= h.",
        keyIdeaBn: "স্পিড ১ থেকে max(piles) সীমানায় বাইনারি সার্চ করে ঘণ্টা হিসেব করুন।",
        isPopular: true,
      ),
      ModifiedBinarySearchProblem(
        title: "Capacity To Ship Packages Within D Days",
        difficulty: "Medium",
        companyTags: ["Amazon", "Meta", "Google"],
        keyIdeaEn: "Binary search on capacity range max(weights) to sum(weights). Test day count.",
        keyIdeaBn: "জাহাজের ক্যাপাসিটিতে বাইনারি সার্চ চালিয়ে দিন সংখ্যা মেলান।",
      ),
      ModifiedBinarySearchProblem(
        title: "Search a 2D Matrix",
        difficulty: "Medium",
        companyTags: ["Meta", "Amazon", "Google", "Microsoft"],
        keyIdeaEn: "Virtual 1D binary search on M x N matrix mapping mid index to matrix[mid / N][mid % N].",
        keyIdeaBn: "ভার্চুয়াল ১D বাইনারি সার্চ করে ম্যাট্রিক্স ইনডেক্সে রূপান্তর করুন।",
      ),
      ModifiedBinarySearchProblem(
        title: "Search in Rotated Sorted Array II (Duplicates)",
        difficulty: "Medium",
        companyTags: ["Meta", "Amazon", "Google"],
        keyIdeaEn: "When nums[low] == nums[mid] == nums[high], shrink window with low++ and high--.",
        keyIdeaBn: "ডুপ্লিকেট মান সমান হলে low++ ও high-- করে উইন্ডো ছোট করুন।",
      ),
    ];
  }

  static List<ModifiedBinarySearchProblem> getHardProblems() {
    return const [
      ModifiedBinarySearchProblem(
        title: "Median of Two Sorted Arrays",
        difficulty: "Hard",
        companyTags: ["Amazon", "Meta", "Google", "Microsoft", "Apple"],
        keyIdeaEn: "Binary search on smaller array partition index i, computing corresponding j in larger array.",
        keyIdeaBn: "ছোট অ্যারের পার্টিশন ইনডেক্সে বাইনারি সার্চ করে মিডিয়ান নির্ধারণ করুন।",
        isPopular: true,
      ),
      ModifiedBinarySearchProblem(
        title: "Find Minimum in Rotated Sorted Array II (Duplicates)",
        difficulty: "Hard",
        companyTags: ["Google", "Amazon"],
        keyIdeaEn: "Binary search handling duplicate boundaries by shrinking high-- when nums[mid] == nums[high].",
        keyIdeaBn: "ডুপ্লিকেট নোডে high-- করে সর্বনিম্ন মান বের করুন।",
        isPopular: true,
      ),
      ModifiedBinarySearchProblem(
        title: "Split Array Largest Sum",
        difficulty: "Hard",
        companyTags: ["Google", "Amazon", "Meta"],
        keyIdeaEn: "Binary search on answer maximum sum range max(nums) to sum(nums). Test subarray partition count.",
        keyIdeaBn: "ম্যাক্সিমাম সাম সীমানায় বাইনারি সার্চ করে সাব-অ্যারে ভাগ মেলান।",
      ),
    ];
  }

  static List<Map<String, String>> getCommonMistakes(bool isEnglish) {
    if (isEnglish) {
      return [
        {
          "title": "1. Integer Overflow in Mid Calculation",
          "desc": "Doing `int mid = (low + high) / 2` with large `low` and `high` values causes 32-bit signed integer overflow. Always use `int mid = low + (high - low) / 2;`."
        },
        {
          "title": "2. Infinite Loop in Boundary Conditions",
          "desc": "Mixing up `while (low <= high)` and `while (low < high)` with improper `low = mid` or `high = mid` causes infinite loop when `low == high`."
        },
        {
          "title": "3. Assuming Entire Array is Sorted in Rotated Array",
          "desc": "Forgetting that only ONE half is guaranteed to be sorted at any `mid` step. Always check `nums[low] <= nums[mid]` first!"
        },
        {
          "title": "4. Failing to Handle Duplicates (LeetCode 81)",
          "desc": "When `nums[low] == nums[mid] == nums[high]`, it is impossible to determine which half is sorted. You must shrink window with `low++` and `high--`!"
        },
        {
          "title": "5. Off-by-One Error in Predicate Feasibility Search",
          "desc": "In Binary Search on Answer, failing to store `ans = mid` when feasible leads to incorrect boundary values."
        },
      ];
    } else {
      return [
        {
          "title": "১. Mid গণনায় ইনটিজার ওভারফ্লো (Integer Overflow)",
          "desc": "`int mid = (low + high) / 2` বড় ইনপুট হলে ওভারফ্লো ঘটে। সবসময় `int mid = low + (high - low) / 2;` ব্যবহার করা উচিত।"
        },
        {
          "title": "২. বাউন্ডারি শর্তে অসীম লুপ (Infinite Loop)",
          "desc": "`while (low <= high)` ও `low = mid` একসাথে ব্যবহার করলে `low == high` অবস্থায় প্রোগ্রাম অসীম লুপে আটকে যাবে।"
        },
        {
          "title": "৩. রোটেটেড অ্যারের পুরো অংশ সর্টেড ভেবে নেওয়া",
          "desc": "রোটেটেড অ্যারেতে প্রতিটি ধাপে কেবল যেকোনো একটি অর্ধেক সর্টেড থাকে। আগে `nums[low] <= nums[mid]` দিয়ে সর্টেড অর্ধেক নিশ্চিত করতে হবে।"
        },
        {
          "title": "৪. ডুপ্লিকেট মান হ্যান্ডেল না করা (LeetCode 81)",
          "desc": "যখন `nums[low] == nums[mid] == nums[high]`, তখন কোন অর্ধেক সর্টেড তা বোঝা অসম্ভব। এসময় `low++` ও `high--` করতে হবে।"
        },
        {
          "title": "৫. উত্তরের বাইনারি সার্চে অ্যানসার সেভ না করা",
          "desc": "Monotonic Answer Search এ শর্ত সত্য হলে `ans = mid` সেভ না করলে সঠিক উত্তর পাওয়া যাবে না।"
        },
      ];
    }
  }
}
