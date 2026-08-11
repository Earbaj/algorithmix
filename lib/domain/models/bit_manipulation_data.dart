class BitManipulationProblem {
  final String title;
  final String difficulty; // Easy, Medium, Hard
  final List<String> companyTags;
  final String keyIdeaEn;
  final String keyIdeaBn;
  final bool isPopular;

  const BitManipulationProblem({
    required this.title,
    required this.difficulty,
    required this.companyTags,
    required this.keyIdeaEn,
    required this.keyIdeaBn,
    this.isPopular = false,
  });
}

class BitManipulationData {
  static Map<String, String> getConceptIntro(bool isEnglish) {
    if (isEnglish) {
      return {
        "title": "Bit Manipulation Pattern — Complete Deep Dive (C++ & FAANG Focus)",
        "summary": "Bit Manipulation involves directly operating on binary digits (bits) of integers using bitwise operators (& AND, | OR, ^ XOR, ~ NOT, << Left Shift, >> Right Shift). It enables constant time O(1) and space O(1) solutions for arithmetic, subset generation, parity checks, and duplicate detection.",
        "whenToUseTitle": "When to Use Bit Manipulation?",
        "whenToUse1": "Finding single unique or missing numbers (Single Number LeetCode 136, Missing Number LeetCode 268).",
        "whenToUse2": "Counting set 1-bits / Hamming Weight (Number of 1 Bits LeetCode 191, Counting Bits LeetCode 338).",
        "whenToUse3": "Power of two or power of four checks (Power of Two LeetCode 231).",
        "whenToUse4": "Bitmasking subsets and state representation in DP (Subsets LeetCode 78, Shortest Path Visiting All Nodes LeetCode 847).",
        "whenToUse5": "Reversing binary bits or swapping numbers without extra space (Reverse Bits LeetCode 190).",
        "typesTitle": "3 Main Bit Manipulation Patterns",
        "type1Title": "1. XOR Cancellation Tricks (A ^ A = 0, A ^ 0 = A)",
        "type1Desc": "XORing all numbers in an array cancels out identical pairs in O(N) time and O(1) space, leaving only the unique element.",
        "type2Title": "2. Brian Kernighan's Algorithm (n & (n - 1))",
        "type2Desc": "n & (n - 1) clears the rightmost set 1-bit of n in O(1) time. n > 0 && (n & (n - 1)) == 0 checks if n is a power of 2.",
        "type3Title": "3. Bit Masking (1 << i) & Subset Generation",
        "type3Desc": "Test bit: (n >> i) & 1. Set bit: n | (1 << i). Clear bit: n & ~(1 << i). Generate 2^N subsets iterating masks 0 to (1 << N) - 1.",
      };
    } else {
      return {
        "title": "Bit Manipulation Pattern — সম্পূর্ণ গাইড (C++ ও FAANG ফোকাস)",
        "summary": "Bit Manipulation হলো বিটওয়াইজ অপারেটর (& AND, | OR, ^ XOR, ~ NOT, << Left Shift, >> Right Shift) ব্যবহার করে সরাসরি বাইনারি বিটে অপারেশন চালানো। এটি ও(১) সময় ও মেমোরিতে গানিতিক হিসাব, সাবসেট তৈরি, প্যারিটি চেক এবং ইউনিক মান সনাক্ত করতে সাহায্য করে।",
        "whenToUseTitle": "কখন বুঝবা Bit Manipulation লাগবে?",
        "whenToUse1": "অ্যারেতে একটি মাত্র ইউনিক বা নিখোঁজ সংখ্যা বের করতে (Single Number LeetCode 136, Missing Number LeetCode 268)।",
        "whenToUse2": "বাইনারিতে ১-বিটের সংখ্যা বা হামিং ওয়েট মেপে বের করতে (Number of 1 Bits LeetCode 191, Counting Bits LeetCode 338)।",
        "whenToUse3": "সংখ্যাটি ২ এর পাওয়ার কিনা তা ১ স্টেপে পরীক্ষা করতে (Power of Two LeetCode 231)।",
        "whenToUse4": "বিটমাস্কিং দিয়ে সাবসেট জেনারেশন বা DP স্টেট রিপ্রেজেন্ট করতে (Subsets LeetCode 78)।",
        "whenToUse5": "বাইনারি বিট উল্টানো বা অতিরিক্ত ভ্যারিয়েবল ছাড়া মান সোয়াপ করতে (Reverse Bits LeetCode 190)।",
        "typesTitle": "Main Types (৩ ধরনের pattern)",
        "type1Title": "১. XOR ক্যানসেলেশন ট্রিক (A ^ A = 0, A ^ 0 = A)",
        "type1Desc": "অ্যারের সব সংখ্যা XOR করলে সমান জোড়াগুলো ০ হয়ে বাতিল হয়ে যায় এবং কেবল অনন্য বা ইউনিক সংখ্যাটি ও(১) মেমোরিতে অবশিষ্ট থাকে।",
        "type2Title": "২. Brian Kernighan's অ্যালগরিদম (n & (n - 1))",
        "type2Desc": "`n & (n - 1)` ও(১) সময়ে সবচেয়ে ডানপাশের ১-বিট মুছে দেয়। `n > 0 && (n & (n - 1)) == 0` দিয়ে ২ এর পাওয়ার চেক করা যায়।",
        "type3Title": "৩. বিট মাস্কিং (1 << i) ও সাবসেট জেনারেশন",
        "type3Desc": "বিট টেস্ট: `(n >> i) & 1`। বিট সেট: `n | (1 << i)`। মাস্ক `0` থেকে `(1 << N) - 1` পর্যন্ত চালিয়ে `2^N` টি সাবসেট তৈরি করো।",
      };
    }
  }

  static List<BitManipulationProblem> getEasyProblems() {
    return const [
      BitManipulationProblem(
        title: "Single Number",
        difficulty: "Easy",
        companyTags: ["Amazon", "Meta", "Google", "Microsoft"],
        keyIdeaEn: "XOR all elements together in O(N) time and O(1) space: duplicate pairs cancel out.",
        keyIdeaBn: "সব সংখ্যা XOR করুন, জোড়াগুলো বাতিল হয়ে ইউনিক সংখ্যা বের হবে।",
        isPopular: true,
      ),
      BitManipulationProblem(
        title: "Number of 1 Bits (Hamming Weight)",
        difficulty: "Easy",
        companyTags: ["Amazon", "Meta", "Google", "Microsoft"],
        keyIdeaEn: "Brian Kernighan's loop n &= (n - 1) counting set bits in O(set bits) time.",
        keyIdeaBn: "n &= (n - 1) লুপ চালিয়ে ১-বিটের সংখ্যা গণনা করুন।",
        isPopular: true,
      ),
      BitManipulationProblem(
        title: "Reverse Bits",
        difficulty: "Easy",
        companyTags: ["Amazon", "Meta", "Google"],
        keyIdeaEn: "Iterate 32 bits building result: res = (res << 1) | (n & 1); n >>= 1.",
        keyIdeaBn: "৩২ বিট লুপে বিট শিফট করে উল্টো বাইনারি সংখ্যা বানান।",
        isPopular: true,
      ),
      BitManipulationProblem(
        title: "Missing Number",
        difficulty: "Easy",
        companyTags: ["Amazon", "Google", "Meta", "Microsoft"],
        keyIdeaEn: "XOR all indices 0..N with array values to find missing number.",
        keyIdeaBn: "ইনডেক্স ০..N এবং এরে এলিমেন্ট XOR করে মিসিং মান পান।",
      ),
      BitManipulationProblem(
        title: "Power of Two",
        difficulty: "Easy",
        companyTags: ["Amazon", "Google", "Meta"],
        keyIdeaEn: "O(1) check: n > 0 && (n & (n - 1)) == 0.",
        keyIdeaBn: "n > 0 && (n & (n - 1)) == 0 দিয়ে ২ এর পাওয়ার চেক করুন।",
      ),
      BitManipulationProblem(
        title: "Counting Bits",
        difficulty: "Easy",
        companyTags: ["Amazon", "Meta", "Google"],
        keyIdeaEn: "1D Bitwise DP dp[i] = dp[i >> 1] + (i & 1).",
        keyIdeaBn: "বিট শিফট DP দিয়ে ০ থেকে N পর্যন্ত ১-বিট গণনা করুন।",
      ),
      BitManipulationProblem(
        title: "Hamming Distance",
        difficulty: "Easy",
        companyTags: ["Google", "Meta", "Amazon"],
        keyIdeaEn: "Count set bits of (x ^ y).",
        keyIdeaBn: "(x ^ y) এর ১-বিটের সংখ্যা গণনা করুন।",
      ),
      BitManipulationProblem(
        title: "Binary Number with Alternating Bits",
        difficulty: "Easy",
        companyTags: ["Google", "Amazon"],
        keyIdeaEn: "Check if (n ^ (n >> 1)) is all 1-bits.",
        keyIdeaBn: "(n ^ (n >> 1)) দিয়ে অল্টারনেটিং বিট চেক করুন।",
      ),
    ];
  }

  static List<BitManipulationProblem> getMediumProblems() {
    return const [
      BitManipulationProblem(
        title: "Single Number II",
        difficulty: "Medium",
        companyTags: ["Google", "Amazon", "Meta", "Microsoft"],
        keyIdeaEn: "Bit counting sum of 32 bits modulo 3 or 2-bit state variables ones and twos.",
        keyIdeaBn: "৩২টি বিটের সামকে ৩ দিয়ে ভাগশেষ মেপে বা ২-বিট স্টেট দিয়ে সমাধান করুন।",
        isPopular: true,
      ),
      BitManipulationProblem(
        title: "Single Number III",
        difficulty: "Medium",
        companyTags: ["Google", "Amazon", "Meta", "Microsoft"],
        keyIdeaEn: "XOR all numbers to get a ^ b. Find rightmost set bit diffBit = xorSum & (-xorSum) to partition array into two groups.",
        keyIdeaBn: "XOR সামের রাইটমোস্ট ১-বিট দিয়ে ২ গ্রুপে ভাগ করে ২টি অনন্য মান পান।",
        isPopular: true,
      ),
      BitManipulationProblem(
        title: "Subsets (Bitmask Approach)",
        difficulty: "Medium",
        companyTags: ["Meta", "Amazon", "Google", "Microsoft"],
        keyIdeaEn: "Iterate mask from 0 to (1 << N) - 1. Build subset if bit (mask & (1 << i)) is non-zero.",
        keyIdeaBn: "মাস্ক 0 থেকে (1 << N) - 1 চালিয়ে 2^N টি সাবসেট জেনারেট করুন।",
        isPopular: true,
      ),
      BitManipulationProblem(
        title: "Bitwise AND of Numbers Range",
        difficulty: "Medium",
        companyTags: ["Google", "Amazon", "Meta"],
        keyIdeaEn: "Shift right left and right until left == right, then shift left back by shift count.",
        keyIdeaBn: "লেফট ও রাইট সমান না হওয়া পর্যন্ত রাইট শিফট করে কমন প্রিফিক্স পান।",
      ),
      BitManipulationProblem(
        title: "Sum of Two Integers (Bitwise Addition)",
        difficulty: "Medium",
        companyTags: ["Meta", "Amazon", "Google", "Microsoft"],
        keyIdeaEn: "Bitwise addition without + or -: sum = a ^ b, carry = (unsigned)(a & b) << 1.",
        keyIdeaBn: "+ ও - ছাড়া XOR ও AND শিফট করে যোগফল হিসেব করুন।",
        isPopular: true,
      ),
      BitManipulationProblem(
        title: "Maximum Product of Word Lengths",
        difficulty: "Medium",
        companyTags: ["Google", "Amazon", "Meta"],
        keyIdeaEn: "Convert each word to 26-bit bitmask. Product valid if (mask[i] & mask[j]) == 0.",
        keyIdeaBn: "শব্দগুলোকে ২৬-বিট মাস্কে কনভার্ট করে (mask[i] & mask[j]) == 0 হলে প্রোডাক্ট নিন।",
      ),
      BitManipulationProblem(
        title: "Divide Two Integers",
        difficulty: "Medium",
        companyTags: ["Meta", "Amazon", "Google", "Microsoft"],
        keyIdeaEn: "Bitwise left shift subtraction: subtract divisor * (1 << i) from dividend.",
        keyIdeaBn: "বিট শিফট বিয়োগ দিয়ে গুণের বদলে ভাগফল হিসেব করুন।",
      ),
      BitManipulationProblem(
        title: "Minimum Flips to Make a OR b Equal to c",
        difficulty: "Medium",
        companyTags: ["Amazon", "Google", "Meta"],
        keyIdeaEn: "Check bit by bit: if bit in c is 0, count set bits in a and b; if 1, check if both are 0.",
        keyIdeaBn: "বিট বাই বিট তুলনা করে ফ্লিফ সংখ্যা গণনা করুন।",
      ),
    ];
  }

  static List<BitManipulationProblem> getHardProblems() {
    return const [
      BitManipulationProblem(
        title: "Shortest Path Visiting All Nodes (Bitmask BFS)",
        difficulty: "Hard",
        companyTags: ["Google", "Amazon", "Meta"],
        keyIdeaEn: "BFS queue tracking (u, mask). Target state mask == (1 << N) - 1.",
        keyIdeaBn: "বিটমাস্ক ক্যু (u, mask) দিয়ে সব নোড ভিজিটের শর্টেস্ট পাথ BFS চালান।",
        isPopular: true,
      ),
      BitManipulationProblem(
        title: "Maximum Score Words Formed by Letters",
        difficulty: "Hard",
        companyTags: ["Google", "Amazon", "Meta"],
        keyIdeaEn: "Bitmask subset generation checking char frequency bounds for max score.",
        keyIdeaBn: "বিটমাস্ক সাবসেট দিয়ে অক্ষরের ফ্রিকোয়েন্সি মেপে সর্বোচ্চ স্কোর পান।",
      ),
      BitManipulationProblem(
        title: "Find Minimum Time to Finish All Tasks",
        difficulty: "Hard",
        companyTags: ["Google", "Amazon"],
        keyIdeaEn: "Bitmask Dynamic Programming tracking completed tasks state.",
        keyIdeaBn: "বিটমাস্ক ডাইনামিক প্রোগ্রামিং দিয়ে টাস্ক সম্পন্ন করার মিনিমাম সময় পান।",
      ),
    ];
  }

  static List<Map<String, String>> getCommonMistakes(bool isEnglish) {
    if (isEnglish) {
      return [
        {
          "title": "1. Operator Precedence Pitfall",
          "desc": "In C++, bitwise operators (`&`, `|`, `^`) have LOWER precedence than comparison operators (`==`, `!=`). Writing `if (n & 1 == 0)` parses as `n & (1 == 0)`! Always wrap bitwise operations in parentheses: `if ((n & 1) == 0)`."
        },
        {
          "title": "2. Signed 32-Bit Integer Overflow During Left Shift (`1 << 31`)",
          "desc": "Left-shifting 1 by 31 in signed 32-bit `int` causes undefined behavior / integer overflow! Use `1LL << i` or unsigned types."
        },
        {
          "title": "3. Negative Bit Shift Undefined Behavior",
          "desc": "Shift amounts must be in range `[0, 31]` for 32-bit integers. Shifting by negative numbers or >= 32 causes UB."
        },
        {
          "title": "4. Confusing Logical Right Shift (`>>>`) vs Arithmetic Right Shift (`>>`)",
          "desc": "In Java/Dart, `>>` fills sign bit (1 for negative numbers), whereas `>>>` fills 0s."
        },
        {
          "title": "5. Forgetting 0 Power of Two Base Case",
          "desc": "`n & (n - 1) == 0` returns `true` for `n = 0`, but 0 is NOT a power of two! Always check `n > 0 && (n & (n - 1)) == 0`."
        },
      ];
    } else {
      return [
        {
          "title": "১. বিটওয়াইজ ও তুলনা অপারেটর প্রেসিডেন্স ভুল",
          "desc": "C++ এ বিটওয়াইজ অপারেটর (`&`, `|`, `^`) এর মান তুলনা অপারেটরের (`==`, `!=`) চেয়ে কম। `if (n & 1 == 0)` লিখলে ভুল উত্তর আসবে। সবসময় ব্র্যাকেট দিন: `if ((n & 1) == 0)`।"
        },
        {
          "title": "২. ৩১-বিট লেফট শিফটে ইনটিজার ওভারফ্লো (`1 << 31`)",
          "desc": "সাইনড ৩২-বিট ইনটিজারে `1 << 31` করলে ওভারফ্লো ও আনডিফাইন্ড বিহেভিয়ার ঘটবে। `1LL << i` ব্যবহার করুন।"
        },
        {
          "title": "৩. নেগেটিভ বা ৩২ এর সমান বিট শিফট করা",
          "desc": "শিফট অ্যামাউন্ট অবশ্যই `[0, 31]` রেঞ্জের মধ্যে হতে হবে। ঋণাত্মক বা ৩২+ শিফট আনডিফাইন্ড।"
        },
        {
          "title": "৪. লজিক্যাল রাইট শিফট (`>>>`) ও অ্যারিথমেটিক রাইট শিফট (`>>`) ভুল করা",
          "desc": "`>>` নেগেটিভ সংখ্যার সাইন বিট (১) দিয়ে ফিল করে, যেখানে `>>>` জিরো (০) দিয়ে ফিল করে।"
        },
        {
          "title": "৫. ২ এর পাওয়ার চেকে ০ কে বেস কেস হিসেবে বাদ না দেওয়া",
          "desc": "`n & (n - 1) == 0` প্রবলেমে `n = 0` এর জন্য সত্য দেখাবে, কিন্তু ০ ২ এর পাওয়ার নয়! সবসময় `n > 0 && (n & (n - 1)) == 0` লিখুন।"
        },
      ];
    }
  }
}
