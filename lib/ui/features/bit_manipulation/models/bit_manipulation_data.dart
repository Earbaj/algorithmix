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
        "whenToUse4": "বিটমাস্কিং দিয়ে সাবসেট জেনারেটর বা DP স্টেট রিপ্রেজেন্ট করতে (Subsets LeetCode 78)।",
        "whenToUse5": "বাইনারি বিট উল্টানো বা অতিরিক্ত ভ্যারিয়েবল ছাড়া মান সোয়াপ করতে (Reverse Bits LeetCode 190)।",
        "typesTitle": "Main Types (৩ ধরনের pattern)",
        "type1Title": "১. XOR ক্যানসেলেশন ট্রিক (A ^ A = 0, A ^ 0 = A)",
        "type1Desc": "অ্যারের সব সংখ্যা XOR করলে সমান জোড়াগুলো ০ হয়ে বাতিল হয়ে যায় এবং কেবল অনন্য বা ইউনিক সংখ্যাটি ও(১) মেমোরিতে অবশিষ্ট থাকে।",
        "type2Title": "২. Brian Kernighan's অ্যালগরিদম (n & (n - 1))",
        "type2Desc": "`n & (n - 1)` ও(১) সময়ে সবচেয়ে ডানপাশের ১-বিট মুছে দেয়। `n > 0 && (n & (n - 1)) == 0` দিয়ে ২ এর পাওয়ার চেক করা যায়।",
        "type3Title": "৩. বিট মাস্কিং (1 << i) ও সাবসেট জেনারেটর",
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
        companyTags: ["Google", "Meta", "Amazon"],
        keyIdeaEn: "Bitmask subset search verifying character counts against valid frequency map.",
        keyIdeaBn: "বিটমাস্ক সাবসেট সার্চ চালিয়ে ফ্রিকোয়েন্সি ম্যাপ দিয়ে স্কোরের মান বের করুন।",
        isPopular: true,
      ),
      BitManipulationProblem(
        title: "Find Longest Awesome Substring",
        difficulty: "Hard",
        companyTags: ["Google", "Amazon", "Meta"],
        keyIdeaEn: "Prefix bitmask tracking parity of digits 0..9 in HashMap.",
        keyIdeaBn: "০..৯ ডিডিটের প্যারিটি বিটমাস্ক ট্র্যাকিং করে লংগেস্ট প্যালিন্ড্রোম পান।",
      ),
    ];
  }

  static List<Map<String, String>> getCommonMistakes(bool isEnglish) {
    if (isEnglish) {
      return [
        {
          "title": "1. Operator Precedence Errors (Bitwise vs Comparison)",
          "desc": "Comparison operators `==` have HIGHER precedence than bitwise `&` or `^`! Writing `n & 1 == 0` evaluates as `n & (1 == 0)`. Always wrap bitwise ops in parentheses `(n & 1) == 0`!"
        },
        {
          "title": "2. Signed Integer Right Shift vs Unsigned Shift (`>>` vs `>>>`)",
          "desc": "Right shifting negative numbers `>>` preserves the sign bit (1s prefix). Shift carefully or cast to unsigned for logical shifts."
        },
        {
          "title": "3. Overflowing Bit Shift (`1 << 31`) in 32-bit Signed Int",
          "desc": "`1 << 31` overflows 32-bit signed integer into negative value `-2147483648`. Use `1LL << 31` for 64-bit shifts."
        },
        {
          "title": "4. Assuming `A ^ B == 0` Means A and B Are Positive",
          "desc": "`A ^ B == 0` only guarantees A and B are equal, not positive."
        },
        {
          "title": "5. Missing Parentheses in Complex Bitmasking Expressions",
          "desc": "Forgetting parentheses in `mask & 1 << i` evaluates as `mask & (1 << i)`. Be explicit with parentheses."
        },
      ];
    } else {
      return [
        {
          "title": "১. অপারেটর প্রিসিডেন্স ভুল (Bitwise বনাম Comparison)",
          "desc": "`==` অপারেটরের ক্ষমতা `&` বা `^` এর চেয়ে বেশি! `n & 1 == 0` লিখলে `n & (1 == 0)` হিসেবে কাজ করবে। অবশ্যই ব্র্যাকেট দিন `(n & 1) == 0`!"
        },
        {
          "title": "২. ঋণাত্মক সংখ্যার রাইট শিফট ভুল (`>>`)",
          "desc": "ঋণাত্মক সংখ্যাকে `>>` শিফট করলে চিহ্নের বিট ১ বহাল থাকে। লজিক্যাল শিফটের জন্য unsigned টাইপ কাস্ট ব্যবহার করুন।"
        },
        {
          "title": "৩. ৩২-বিট সাইনড ইনটিজারে শিফট ওভারফ্লো (`1 << 31`)",
          "desc": "`1 << 31` করলে সাইনড ইনটিজারে ওভারফ্লো হয়ে ঋণাত্মক সংখ্যা আসবে। ৬৪-বিটের জন্য `1LL << 31` ব্যবহার করুন।"
        },
        {
          "title": "৪. `A ^ B == 0` মানেই ধনাত্মক সংখ্যা ভাবা",
          "desc": "`A ^ B == 0` কেবল নির্দেশ করে A ও B সমান, ধনাত্মক বা ঋণাত্মক যাই হোক না কেন।"
        },
        {
          "title": "৫. জটিল বিটমাস্ক এক্সপ্রেশনে ব্র্যাকেটের অভাব",
          "desc": "`mask & 1 << i` এর মতো জটিল প্রকাশে ব্র্যাকেট না দিলে অনাকাঙ্ক্ষিত ফলাফল আসবে।"
        },
      ];
    }
  }
}
