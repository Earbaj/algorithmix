class TwoPointersProblem {
  final String title;
  final String difficulty; // Easy, Medium, Hard
  final List<String> companyTags;
  final String keyIdeaEn;
  final String keyIdeaBn;
  final bool isPopular;

  const TwoPointersProblem({
    required this.title,
    required this.difficulty,
    required this.companyTags,
    required this.keyIdeaEn,
    required this.keyIdeaBn,
    this.isPopular = false,
  });
}

class TwoPointersData {
  static Map<String, String> getConceptIntro(bool isEnglish) {
    if (isEnglish) {
      return {
        "title": "Two Pointers — Complete Deep Dive (FAANG Focus)",
        "summary": "Two Pointers is a technique using two indices to traverse an array or string simultaneously, reducing O(n²) brute force solutions down to linear O(n) time.",
        "whenToUseTitle": "When to Use Two Pointers?",
        "whenToUse1": "The array or string is sorted (or can be sorted).",
        "whenToUse2": "Working with pairs, triplets, or subarrays targeting a sum/difference/condition.",
        "whenToUse3": "Checking for palindromes or symmetric patterns.",
        "whenToUse4": "In-place array modifications (e.g. removing duplicates, moving zeros).",
        "whenToUse5": "Container and trapping water problems using opposite direction pointers.",
        "typesTitle": "3 Main Pointer Patterns",
        "type1Title": "1. Opposite Direction",
        "type1Desc": "One pointer starts at the left (0), another at the right (n-1), moving towards each other until they meet.",
        "type2Title": "2. Same Direction (Slow & Fast)",
        "type2Desc": "Both pointers move in the same direction. Slow pointer tracks valid placement, fast pointer scans elements.",
        "type3Title": "3. Fixed + Two Pointer (Triplets)",
        "type3Desc": "Fix one element with a loop, then use opposite direction two pointers on the remaining subarray (e.g. 3Sum).",
      };
    } else {
      return {
        "title": "Two Pointers — সম্পূর্ণ গাইড (FAANG ইন্টারভিউ ফোকাস)",
        "summary": "Two Pointers মানে দুইটা index/pointer ব্যবহার করে array বা string traverse করা, যাতে O(n²) brute force কে O(n) এ নামানো যায়।",
        "whenToUseTitle": "কখন বুঝবা Two Pointers লাগবে?",
        "whenToUse1": "Array/String sorted থাকে (বা sort করা যায়)",
        "whenToUse2": "Pair, triplet, বা subarray নিয়ে কাজ — sum/difference/condition match করতে হবে",
        "whenToUse3": "Palindrome check করতে হবে",
        "whenToUse4": "In-place array modify করতে হবে (duplicates remove, move zeros)",
        "whenToUse5": "Container, trapping water টাইপ problem (opposite direction pointer)",
        "typesTitle": "Main Types (৩ ধরনের pattern)",
        "type1Title": "১. Opposite Direction (বিপরীত দিক)",
        "type1Desc": "একটা pointer শুরুতে (left), একটা শেষে (right), মাঝে মিট করে।",
        "type2Title": "২. Same Direction (একই দিক)",
        "type2Desc": "দুইটা pointer একই দিকে move করে, একটা fast scan করে এবং অন্যটা slow placement নির্দেশ করে।",
        "type3Title": "৩. Fixed + Two Pointer (Triplets)",
        "type3Desc": "একটা element fixed রেখে বাকি দুইটা opposite direction এ move করানো হয় (যেমন 3Sum)।",
      };
    }
  }

  static List<TwoPointersProblem> getEasyProblems() {
    return const [
      TwoPointersProblem(
        title: "Two Sum II (Sorted Array)",
        difficulty: "Easy",
        companyTags: ["Amazon", "Google", "Meta"],
        keyIdeaEn: "Opposite direction pointers on sorted array. Shrink search space based on sum.",
        keyIdeaBn: "Sorted array তে বিপরীত দিকের pointer। Sum এর উপর ভিত্তি করে pointer সরান।",
        isPopular: true,
      ),
      TwoPointersProblem(
        title: "Valid Palindrome",
        difficulty: "Easy",
        companyTags: ["Meta", "Microsoft", "Amazon"],
        keyIdeaEn: "Left & right compare while skipping non-alphanumeric characters.",
        keyIdeaBn: "Left-right তুলনা করুন এবং non-alphanumeric অক্ষরগুলো বাদ দিন।",
      ),
      TwoPointersProblem(
        title: "Reverse String",
        difficulty: "Easy",
        companyTags: ["Google", "Apple"],
        keyIdeaEn: "Swap left and right characters in-place until pointers meet in center.",
        keyIdeaBn: "মাঝামাঝি পৌঁছানো পর্যন্ত ইন-প্লেস অক্ষর Swap করুন।",
      ),
      TwoPointersProblem(
        title: "Move Zeroes",
        difficulty: "Easy",
        companyTags: ["Meta", "Amazon", "Bloomberg"],
        keyIdeaEn: "Same direction slow-fast pointer swap. Non-zero elements moved to front.",
        keyIdeaBn: "Same direction slow-fast pointer ব্যবহার করে non-zero সামনে আনুন।",
        isPopular: true,
      ),
      TwoPointersProblem(
        title: "Remove Duplicates from Sorted Array",
        difficulty: "Easy",
        companyTags: ["Meta", "Microsoft"],
        keyIdeaEn: "Slow-fast pointers. Slow increments only when a new unique element is found.",
        keyIdeaBn: "Slow-fast pointer। ইউনিক এলিমেন্ট পেলে slow পয়েন্টার ১ বাড়ান।",
      ),
      TwoPointersProblem(
        title: "Squares of a Sorted Array",
        difficulty: "Easy",
        companyTags: ["Google", "Amazon"],
        keyIdeaEn: "Opposite direction compare absolute values, fill result array from back.",
        keyIdeaBn: "বিপরীত পয়েন্টার থেকে পরম মান তুলনা করে পেছন দিক থেকে রেজাল্ট বসান।",
      ),
      TwoPointersProblem(
        title: "Merge Sorted Array",
        difficulty: "Easy",
        companyTags: ["Meta", "Microsoft", "Amazon"],
        keyIdeaEn: "Two pointers from end to avoid overwriting elements in-place.",
        keyIdeaBn: "ওভাররাইট এড়াতে পেছন দিক থেকে টু-পয়েন্টার মার্জ করুন।",
      ),
      TwoPointersProblem(
        title: "Is Subsequence",
        difficulty: "Easy",
        companyTags: ["Amazon", "Google"],
        keyIdeaEn: "Same direction greedy matching on pattern and target string.",
        keyIdeaBn: "Same direction greedy ম্যাচিং করে সাবসিকোয়েন্স চেক করুন।",
      ),
    ];
  }

  static List<TwoPointersProblem> getMediumProblems() {
    return const [
      TwoPointersProblem(
        title: "3Sum",
        difficulty: "Medium",
        companyTags: ["Meta", "Amazon", "Microsoft", "Apple"],
        keyIdeaEn: "Sort array, fix element i, use Two Pointers for remainder. Skip duplicates!",
        keyIdeaBn: "অ্যারে সর্ট করে i ফিক্সড রেখে টু-পয়েন্টার চালাও। ডুপ্লিকেট স্কিপ আবশ্যক!",
        isPopular: true,
      ),
      TwoPointersProblem(
        title: "3Sum Closest",
        difficulty: "Medium",
        companyTags: ["Meta", "Amazon"],
        keyIdeaEn: "Fixed element + two pointers, track minimum absolute difference to target.",
        keyIdeaBn: "ফিক্সড এলিমেন্ট + টু পয়েন্টার দিয়ে টার্গেটের সবচেয়ে কাছের সাম ট্র্যাক করো।",
      ),
      TwoPointersProblem(
        title: "Container With Most Water",
        difficulty: "Medium",
        companyTags: ["Meta", "Amazon", "Google", "Bloomberg"],
        keyIdeaEn: "Opposite pointers. Move the pointer pointing to shorter height.",
        keyIdeaBn: "Opposite direction pointer। যেদিকের উচ্চতা ছোট সেই পয়েন্টার সরাও।",
        isPopular: true,
      ),
      TwoPointersProblem(
        title: "Sort Colors (Dutch National Flag)",
        difficulty: "Medium",
        companyTags: ["Meta", "Microsoft", "Amazon"],
        keyIdeaEn: "3-pointer partition (low, mid, high) to sort 0s, 1s, 2s in single pass.",
        keyIdeaBn: "৩টি পয়েন্টার (low, mid, high) দিয়ে ১ পাশেই 0, 1, 2 সর্ট করুন।",
        isPopular: true,
      ),
      TwoPointersProblem(
        title: "Remove Duplicates from Sorted Array II",
        difficulty: "Medium",
        companyTags: ["Meta", "Google"],
        keyIdeaEn: "Slow-fast pointer allowing max 2 duplicate frequencies.",
        keyIdeaBn: "Slow-fast পয়েন্টার যাতে সর্বোচ্চ ২টি ডুপ্লিকেট অনুমোদন পায়।",
      ),
      TwoPointersProblem(
        title: "4Sum",
        difficulty: "Medium",
        companyTags: ["Amazon", "Google"],
        keyIdeaEn: "Nested 2 fixed loops + two pointers for outer pair.",
        keyIdeaBn: "২টি নেস্টেড ফিক্সড লুপ + টু পয়েন্টার দিয়ে ৪টি সংখ্যা যোগফল মেলান।",
      ),
      TwoPointersProblem(
        title: "Boats to Save People",
        difficulty: "Medium",
        companyTags: ["Amazon", "Google"],
        keyIdeaEn: "Sort + greedy opposite direction pointers (heaviest + lightest).",
        keyIdeaBn: "সর্ট + গ্রিডি পয়েন্টার (সবচেয়ে ভারী + হালকা লোক একই সাথে)।",
      ),
      TwoPointersProblem(
        title: "Partition Labels",
        difficulty: "Medium",
        companyTags: ["Meta", "Amazon"],
        keyIdeaEn: "Track last occurrences map with sliding/two pointer window.",
        keyIdeaBn: "অক্ষরের শেষ পজিশন ম্যাপে রেখে উইন্ডো টু-পয়েন্টারে কাটুন।",
      ),
    ];
  }

  static List<TwoPointersProblem> getHardProblems() {
    return const [
      TwoPointersProblem(
        title: "Trapping Rain Water",
        difficulty: "Hard",
        companyTags: ["Amazon", "Google", "Meta", "Bloomberg"],
        keyIdeaEn: "Opposite direction pointers tracking leftMax & rightMax. O(1) space!",
        keyIdeaBn: "Opposite direction pointer দিয়ে leftMax এবং rightMax ট্র্যাক রাখা। O(1) স্পেস!",
        isPopular: true,
      ),
      TwoPointersProblem(
        title: "Minimum Window Substring",
        difficulty: "Hard",
        companyTags: ["Meta", "Amazon", "Uber"],
        keyIdeaEn: "Two pointers + frequency map sliding window hybrid.",
        keyIdeaBn: "টু পয়েন্টার এবং ফ্রিকোয়েন্সি ম্যাপের হাইব্রিড স্লাইডিং উইন্ডো।",
        isPopular: true,
      ),
      TwoPointersProblem(
        title: "Median of Two Sorted Arrays",
        difficulty: "Hard",
        companyTags: ["Google", "Amazon", "Microsoft"],
        keyIdeaEn: "Binary search partition combined with two pointer element comparison.",
        keyIdeaBn: "বাইনারি সার্চ পার্টিশন ও টু পয়েন্টার এলিমেন্ট তুলনা।",
        isPopular: true,
      ),
    ];
  }

  static List<Map<String, String>> getCommonMistakes(bool isEnglish) {
    if (isEnglish) {
      return [
        {
          "title": "1. Forgetting to Sort First",
          "desc": "Opposite direction pointers require a sorted array. Without sorting, condition checks like sum < target won't guide pointer movement reliably."
        },
        {
          "title": "2. Missing Duplicate Skips",
          "desc": "In problems like 3Sum, failure to skip identical elements using `while (left < right && arr[left] == arr[left-1]) left++` produces duplicate answers."
        },
        {
          "title": "3. Infinite Loop Hazards",
          "desc": "Not advancing `left++` or `right--` on matches causes infinite loops. Ensure pointers move forward on every branch."
        },
        {
          "title": "4. Off-by-One Boundary Errors",
          "desc": "Initializing right pointer to `arr.length` instead of `arr.length - 1` triggers IndexOutOfBounds Exception."
        },
        {
          "title": "5. Order Destruction",
          "desc": "If a problem requires preserving original relative order (e.g. Move Zeroes), do not use opposite direction pointers which reverse order."
        },
      ];
    } else {
      return [
        {
          "title": "১. Sort না করেই শুরু করা",
          "desc": "Opposite direction pointers এ array সর্টেড থাকা জরুরি। সর্ট না থাকলে left/right এর মান বাড়ানো বা কমানো কাজ করবে না।"
        },
        {
          "title": "২. Duplicate Skip করতে ভুলে যাওয়া",
          "desc": "3Sum এ ডুপ্লিকেট স্কিপ না করলে `while (left < right && arr[left] == arr[left-1]) left++` একই আউটপুট একাধিকবার আসবে।"
        },
        {
          "title": "৩. Infinite Loop এ পড়ে যাওয়া",
          "desc": "Match হওয়ার পর `left++` বা `right--` না করলে লুপ বন্ধ হবে না।"
        },
        {
          "title": "৪. Off-by-One Boundary Error",
          "desc": "Right pointer কে `arr.length - 1` না দিয়ে `arr.length` দিলে IndexOutOfBounds error হবে।"
        },
        {
          "title": "৫. Original Order নষ্ট করা",
          "desc": "যদি সমস্যাটিতে আগের অর্ডার ঠিক রাখার নির্দেশ থাকে (যেমন Move Zeroes), তবে opposite direction ব্যবহার করলে অর্ডার নষ্ট হতে পারে।"
        },
      ];
    }
  }
}
