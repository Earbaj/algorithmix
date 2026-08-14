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
        "title": "Two Pointers — Complete Deep Dive (C++ & FAANG Focus)",
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
        "title": "Two Pointers — সম্পূর্ণ গাইড (C++ ও FAANG ইন্টারভিউ ফোকাস)",
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
        keyIdeaEn: "Sliding window two pointers with character frequency map.",
        keyIdeaBn: "ফ্রিকোয়েন্সি ম্যাপ সহ স্লাইডিং উইন্ডো টু-পয়েন্টার।",
      ),
      TwoPointersProblem(
        title: "Substring with Concatenation of All Words",
        difficulty: "Hard",
        companyTags: ["Amazon", "Microsoft"],
        keyIdeaEn: "Fixed word size sliding window two pointers.",
        keyIdeaBn: "ফিক্সড ওয়ার্ড সাইজ স্লাইডিং উইন্ডো টু-পয়েন্টার।",
      ),
    ];
  }

  static List<Map<String, String>> getCommonMistakes(bool isEnglish) {
    if (isEnglish) {
      return [
        {
          "title": "1. Forget to Sort the Array First",
          "desc": "Two Pointers (Opposite Direction) logic assumes sorted data! If not sorted, target sum decision making fails completely."
        },
        {
          "title": "2. Off-by-one Error in Loop Condition (`<` vs `<=`)",
          "desc": "In palindrome check, use `left < right`. In array scanning, make sure not to skip edge elements or cause OutOfBounds."
        },
        {
          "title": "3. Not Handling Duplicate Triplets in 3Sum",
          "desc": "After finding a triplet, you must skip duplicate values for both `left` and `right` (`while(left < right && arr[left] == arr[left+1]) left++;`)."
        },
        {
          "title": "4. Incorrect Pointer Movement Strategy",
          "desc": "Moving the wrong pointer (e.g. moving the taller wall in Container With Most Water) will skip optimal answers."
        },
        {
          "title": "5. Modifying Array While Iterating Without Care",
          "desc": "In Same Direction (slow/fast), swapping or overwriting incorrectly can erase elements before fast pointer reads them."
        },
      ];
    } else {
      return [
        {
          "title": "১. অ্যারে আগে সর্ট করতে ভুলে যাওয়া",
          "desc": "Opposite Direction টু-পয়েন্টার কাজ করার মূল শর্ত অ্যারে সর্টেড থাকা। সর্টেড না থাকলে টার্গেট সাম অনুযায়ী পয়েন্টার সরানো ভুল হবে।"
        },
        {
          "title": "২. লুপের শর্তে অফ-বাই-ওয়ান ভুল (`<` বনাম `<=`)",
          "desc": "প্যালিনড্রোম চেকিং এ `left < right` ব্যবহার করো। স্ক্যানিং এর সময় যেন বাউন্ডারির বাইরের ঘর অ্যাক্সেস না হয় তা নিশ্চিত করো।"
        },
        {
          "title": "৩. 3Sum এ ডুপ্লিকেট ট্রিপলেট স্কিপ না করা",
          "desc": "একটা ট্রিপলেট পাওয়ার পর `left` ও `right` উভয় পয়েন্টারের ডুপ্লিকেট মান স্কিপ করতে হবে।"
        },
        {
          "title": "৪. ভুল পয়েন্টার সরানোর সিদ্ধান্ত",
          "desc": "যেমন Container With Most Water প্রবলেমে উঁচু দেয়ালের পয়েন্টার সরালে সেরা উত্তর হাতছাড়া হয়ে যাবে।"
        },
        {
          "title": "৫. পয়েন্টার ট্রাভার্সকালে অ্যারের মান ভুলভাবে পরিবর্তন",
          "desc": "Slow/Fast পয়েন্টার দিয়ে সোয়াপ করার সময় ফাস্ট পয়েন্টার পড়ার আগেই মান হারিয়ে যাওয়ার ঝুঁকি থাকে।"
        },
      ];
    }
  }
}
