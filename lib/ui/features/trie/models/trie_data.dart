class TrieProblem {
  final String title;
  final String difficulty; // Easy, Medium, Hard
  final List<String> companyTags;
  final String keyIdeaEn;
  final String keyIdeaBn;
  final bool isPopular;

  const TrieProblem({
    required this.title,
    required this.difficulty,
    required this.companyTags,
    required this.keyIdeaEn,
    required this.keyIdeaBn,
    this.isPopular = false,
  });
}

class TrieData {
  static Map<String, String> getConceptIntro(bool isEnglish) {
    if (isEnglish) {
      return {
        "title": "Trie (Prefix Tree) Pattern — Complete Deep Dive (C++ & FAANG Focus)",
        "summary": "A Trie (or Prefix Tree) is a tree-like data structure used to store a dynamic set of strings where keys are usually strings. It enables fast string operations such as prefix lookups, exact word matching, autocomplete suggestions, and bitwise XOR queries in O(L) time, where L is the length of the string/key.",
        "whenToUseTitle": "When to Use Trie (Prefix Tree)?",
        "whenToUse1": "Fast prefix lookup or autocomplete suggestions (Implement Trie LeetCode 208, Search Suggestions System LeetCode 1268).",
        "whenToUse2": "Word dictionary search with wildcard characters '.' (Design Add and Search Words Data Structure LeetCode 211).",
        "whenToUse3": "Finding maximum XOR pair of numbers (Maximum XOR of Two Numbers in an Array LeetCode 421).",
        "whenToUse4": "Matrix Boggle / Word Search II with multiple dictionary words (Word Search II LeetCode 212).",
        "whenToUse5": "Longest Common Prefix or Replace Words with roots (Replace Words LeetCode 648, Longest Word in Dictionary LeetCode 720).",
        "typesTitle": "3 Main Trie Patterns",
        "type1Title": "1. Standard Trie (26-Child Array + isEnd)",
        "type1Desc": "TrieNode contains TrieNode* children[26] and bool isEnd. Traverse character by character in O(L) time.",
        "type2Title": "2. Wildcard Search Trie (DFS Backtracking)",
        "type2Desc": "When encountering '.' wildcard in search, recursively try all non-null child nodes 0..25 in DFS traversal.",
        "type3Title": "3. Bitwise Binary Trie (31-Bit Maximum XOR)",
        "type3Desc": "Store numbers as 31-bit binary trees (0/1). Greedily traverse opposite bit (1 - bit) to find maximum XOR pair.",
      };
    } else {
      return {
        "title": "Trie (Prefix Tree) Pattern — সম্পূর্ণ গাইড (C++ ও FAANG ফোকাস)",
        "summary": "Trie (বা Prefix Tree) একটি বিশেষ ট্রি ডাটা স্ট্রাকচার যা দ্রুত স্ট্রিং সেট সংরক্ষণ ও অনুসন্ধান করতে ব্যবহৃত হয়। এটি অটোকমপ্লিট, প্রিফিক্স লুকআপ, ওয়াইল্ডকার্ড ওয়ার্ড সার্চ এবং বিটওয়াইজ XOR অনুসন্ধানে প্রতিটি অপারেশনকে O(L) টাইমে সম্পন্ন করে, যেখানে L হলো স্ট্রিংয়ের দৈর্ঘ্য।",
        "whenToUseTitle": "কখন বুঝবা Trie (Prefix Tree) লাগবে?",
        "whenToUse1": "দ্রুত স্ট্রিং প্রিফিক্স লুকআপ বা অটোকমপ্লিট সার্চে (Implement Trie LeetCode 208, Search Suggestions LeetCode 1268)।",
        "whenToUse2": "ওয়াইল্ডকার্ড ক্যারেক্টার (যেমন '.') সহ ডিকশনারি ওয়ার্ড সার্চে (LeetCode 211)।",
        "whenToUse3": "দুটি সংখ্যার সর্বোচ্চ XOR এর মান খুঁজে বের করতে (Maximum XOR LeetCode 421)।",
        "whenToUse4": "বোগল বা গ্রিডে ডিকশনারির একাধিক শব্দ খুঁজতে (Word Search II LeetCode 212)।",
        "whenToUse5": "দীর্ঘতম কমন প্রিফিক্স বা রুট ওয়ার্ড দিয়ে সাবস্টিটিউট করতে (Replace Words LeetCode 648)।",
        "typesTitle": "Main Types (৩ ধরনের pattern)",
        "type1Title": "১. Standard Trie (২৬টি চাইল্ড এরে ও isEnd)",
        "type1Desc": "`TrieNode` এ `children[26]` ও `isEnd` মেইনটেইন করো। অক্ষর অনুযায়ী O(L) সময়ে ট্রি ট্রাভার্স করো।",
        "type2Title": "২. Wildcard Search Trie (DFS ব্যাকট্যাকিং)",
        "type2Desc": "সার্চে `.` ওয়াইল্ডকার্ড ক্যারেক্টার পেলে সবকটি চাইল্ড নোডে রিকার্সিভ DFS ব্যাকট্র্যাকিং চালাও।",
        "type3Title": "৩. Bitwise Binary Trie (৩১-বিট ম্যাক্সিমাম XOR)",
        "type3Desc": "সংখ্যার ৩১-বিট বাইনারি রূপ (০/১) ট্রিতে রাখো। ম্যাক্সিমাম XOR এর জন্য বিপরীত বিটে (`1 - bit`) গ্রিডি ট্রাভার্স করো।",
      };
    }
  }

  static List<TrieProblem> getEasyProblems() {
    return const [
      TrieProblem(
        title: "Longest Common Prefix (Trie Approach)",
        difficulty: "Easy",
        companyTags: ["Amazon", "Meta", "Google"],
        keyIdeaEn: "Insert strings into Trie and traverse root until node has multiple children or isEnd.",
        keyIdeaBn: "ট্রিতে স্ট্রিংগুলো ইনসার্ট করে একাধিক চাইল্ড না পাওয়া পর্যন্ত প্রিফিক্স রিটার্ন করুন।",
        isPopular: true,
      ),
      TrieProblem(
        title: "Longest Word in Dictionary",
        difficulty: "Easy",
        companyTags: ["Amazon", "Google"],
        keyIdeaEn: "Trie DFS checking if every prefix character has isEnd == true.",
        keyIdeaBn: "Trie DFS দিয়ে প্রতিটি প্রিফিক্স অক্ষরের isEnd == true ভেরিফাই করুন।",
        isPopular: true,
      ),
      TrieProblem(
        title: "Map Sum Pairs",
        difficulty: "Easy",
        companyTags: ["Amazon", "Google", "Meta"],
        keyIdeaEn: "Store sum value at each Trie node prefix.",
        keyIdeaBn: "প্রতিটি Trie নোড প্রিফিক্সে ভ্যালুর সাম সংরক্ষণ করুন।",
      ),
      TrieProblem(
        title: "Index Pairs of a String",
        difficulty: "Easy",
        companyTags: ["Amazon", "Google"],
        keyIdeaEn: "Insert target words in Trie and search substrings.",
        keyIdeaBn: "ডিকশনারির শব্দগুলো ট্রিতে রেখে সাবস্ট্রিং ইন্ডেক্স ম্যাচ করুন।",
      ),
      TrieProblem(
        title: "Search Suggestions Simple",
        difficulty: "Easy",
        companyTags: ["Amazon", "Meta"],
        keyIdeaEn: "Trie prefix traversal collecting top 3 words.",
        keyIdeaBn: "প্রিফিক্স ম্যাচ করে ৩টি সেরা সাজেস্টেড শব্দ ফিল্টার করুন।",
      ),
      TrieProblem(
        title: "Implement Trie Node Simple",
        difficulty: "Easy",
        companyTags: ["Google", "Amazon"],
        keyIdeaEn: "Basic 26-child array TrieNode initialization.",
        keyIdeaBn: "২৬-চাইল্ড বিশিষ্ট বেসিক TrieNode ইমপ্লিমেন্ট করুন।",
      ),
      TrieProblem(
        title: "Replace Words Simple",
        difficulty: "Easy",
        companyTags: ["Amazon", "Meta"],
        keyIdeaEn: "Find shortest root word prefix in Trie.",
        keyIdeaBn: "ট্রিতে রুট ওয়ার্ডের শর্টেস্ট প্রিফিক্স পান।",
      ),
      TrieProblem(
        title: "Prefix and Suffix Search (Easy)",
        difficulty: "Easy",
        companyTags: ["Google", "Amazon"],
        keyIdeaEn: "Combined prefix#suffix Trie key lookup.",
        keyIdeaBn: "প্রিফিক্স ও সাফিক্স জোড়া দিয়ে Trie ট্রাভার্স করুন।",
      ),
    ];
  }

  static List<TrieProblem> getMediumProblems() {
    return const [
      TrieProblem(
        title: "Implement Trie (Prefix Tree)",
        difficulty: "Medium",
        companyTags: ["Meta", "Amazon", "Google", "Microsoft", "Bloomberg"],
        keyIdeaEn: "Build Trie with insert(word), search(word), and startsWith(prefix) in O(L) time.",
        keyIdeaBn: "insert(word), search(word) এবং startsWith(prefix) সহ O(L) সময়ে Trie বানিয়ে সমাধান করুন।",
        isPopular: true,
      ),
      TrieProblem(
        title: "Design Add and Search Words Data Structure",
        difficulty: "Medium",
        companyTags: ["Meta", "Amazon", "Google", "Microsoft", "Bloomberg"],
        keyIdeaEn: "Trie search using DFS backtracking when processing '.' wildcard character.",
        keyIdeaBn: "'.' ওয়াইল্ডকার্ড ক্যারেক্টার প্রসেস করতে Trie তে DFS ব্যাকট্র্যাকিং চালান।",
        isPopular: true,
      ),
      TrieProblem(
        title: "Search Suggestions System",
        difficulty: "Medium",
        companyTags: ["Amazon", "Meta", "Google", "Microsoft"],
        keyIdeaEn: "Insert products into Trie. For each prefix, collect lexicographically top 3 words using DFS.",
        keyIdeaBn: "প্রোডাক্টগুলো ট্রিতে ইনসার্ট করে প্রতিটি প্রিফিক্সের সেরা ৩টি শব্দ সাজেস্ট করুন।",
        isPopular: true,
      ),
      TrieProblem(
        title: "Maximum XOR of Two Numbers in an Array",
        difficulty: "Medium",
        companyTags: ["Google", "Amazon", "Meta", "Microsoft"],
        keyIdeaEn: "Build 31-bit Bitwise Binary Trie. Greedily traverse opposite bit (1 - bit) to find max XOR.",
        keyIdeaBn: "৩১-বিট বাইনারি Trie বানিয়ে বিপরীত বিটে (1 - bit) গ্রিডি ট্রাভার্স করে ম্যাক্সিমাম XOR পান।",
        isPopular: true,
      ),
      TrieProblem(
        title: "Replace Words",
        difficulty: "Medium",
        companyTags: ["Uber", "Amazon", "Google", "Meta"],
        keyIdeaEn: "Store roots in Trie. For each word in sentence, find shortest root prefix match in O(L) time.",
        keyIdeaBn: "রুট শব্দগুলো ট্রিতে রেখে ব্যাক্যের শব্দের শর্টেস্ট রুট প্রিফিক্স প্রতিস্থাপন করুন।",
      ),
      TrieProblem(
        title: "Design Search Autocomplete System",
        difficulty: "Medium",
        companyTags: ["Amazon", "Meta", "Google", "Microsoft"],
        keyIdeaEn: "Trie storing sentence historical search frequency at each node.",
        keyIdeaBn: "Trie নোডে সার্চের হিস্টোরিকাল ফ্রিকোয়েন্সি স্টোর করে অটোকমপ্লিট বানান।",
      ),
      TrieProblem(
        title: "Camelcase Matching",
        difficulty: "Medium",
        companyTags: ["Amazon", "Google"],
        keyIdeaEn: "Trie pattern matching uppercase characters.",
        keyIdeaBn: "ক্যামেলকেস প্যাটার্ন ক্যারেক্টার Trie দিয়ে ম্যাচ করুন।",
      ),
      TrieProblem(
        title: "Stream of Characters",
        difficulty: "Medium",
        companyTags: ["Google", "Amazon", "Meta"],
        keyIdeaEn: "Reverse Trie storing reversed dictionary words to check query stream suffixes.",
        keyIdeaBn: "উল্টো শব্দ ট্রিতে ফিল করে কোয়েরি স্ট্রিম সাফিক্স চেক করুন।",
      ),
    ];
  }

  static List<TrieProblem> getHardProblems() {
    return const [
      TrieProblem(
        title: "Word Search II",
        difficulty: "Hard",
        companyTags: ["Meta", "Amazon", "Google", "Microsoft", "Bloomberg", "Apple"],
        keyIdeaEn: "Build Trie from dictionary words. Run DFS grid traversal pruning branches that are not in Trie.",
        keyIdeaBn: "শব্দগুলো ট্রিতে রেখে গ্রিডে DFS চালান এবং ট্রিতে না থাকা ব্রাঞ্চ ছেঁটে দিন।",
        isPopular: true,
      ),
      TrieProblem(
        title: "Maximum XOR With an Element From Array",
        difficulty: "Hard",
        companyTags: ["Google", "Meta", "Amazon"],
        keyIdeaEn: "Offline queries sorted by limit val, dynamically inserting elements <= limit into Binary Trie.",
        keyIdeaBn: "কোয়েরি সর্ট করে ট্রিতে শর্তসাপেক্ষ সংখ্যা ইনসার্ট করে XOR সমাধান করুন।",
        isPopular: true,
      ),
      TrieProblem(
        title: "Palindrome Pairs",
        difficulty: "Hard",
        companyTags: ["Google", "Amazon", "Meta"],
        keyIdeaEn: "Store reversed words in Trie and search palindrome suffixes.",
        keyIdeaBn: "রিভার্স শব্দ ট্রিতে সেভ করে প্যালিন্ড্রোম পেয়ার বের করুন।",
      ),
    ];
  }

  static List<Map<String, String>> getCommonMistakes(bool isEnglish) {
    if (isEnglish) {
      return [
        {
          "title": "1. Forgetting to Allocate 26-Child Array Null Pointers",
          "desc": "Initializing `children[26]` without setting all pointers to `nullptr` leads to segmentation faults during lookup!"
        },
        {
          "title": "2. Forgetting `isEnd` Boolean Flag",
          "desc": "Failing to set `isEnd = true` makes prefix search work, but exact word search `search(word)` fails incorrectly!"
        },
        {
          "title": "3. Off-by-One Character Index Calculation (`c - 'a'`)",
          "desc": "Calculating child array index using `c` directly instead of `c - 'a'` causes out of bounds memory access crash!"
        },
        {
          "title": "4. Missing Memory Cleanup in Destructor",
          "desc": "Dynamically allocating `new TrieNode()` without recursive post-order deletion causes massive memory leaks!"
        },
        {
          "title": "5. Wrong Bit Shift Count in Binary Trie (31 vs 30)",
          "desc": "Shifting bits using 31 for signed integers when highest bit is sign bit (30-bit needed for non-negative int)."
        },
      ];
    } else {
      return [
        {
          "title": "১. চাইল্ড এরে নাল পয়েন্টার ইনিশিয়ালাইজ না করা",
          "desc": "`children[26]` অ্যারে বানানোর সময় সব ইলিমেন্ট `nullptr` না করলে গার্বেজ ভ্যালুর কারণে সেগমেন্টেশন ফল্ট হবে!"
        },
        {
          "title": "২. শব্দের শেষে `isEnd = true` ফ্ল্যাগ না দেওয়া",
          "desc": "শব্দ ইনসার্টের পর `isEnd` ফ্ল্যাগ ট্রু না করলে প্রিফিক্স মিললেও সম্পূর্ণ শব্দ খোঁজার ফাংশন ভুল উত্তর দেবে।"
        },
        {
          "title": "৩. অক্ষরের ইনডেক্স গণনায় ভুল (`c - 'a'`)",
          "desc": "ইনডেক্স বের করতে `c - 'a'` এর বদলে শুধু `c` ব্যবহার করলে অ্যারের সীমানা ছাড়িয়ে ক্র্যাশ করবে।"
        },
        {
          "title": "৪. ডিস্ট্রাক্টরে ডায়নামিক মেমোরি রিলিজ না করা",
          "desc": "`new TrieNode()` দিয়ে নোড বানিয়ে পরে মুছে না দিলে প্রচুর মেমোরি লিক (Memory Leak) হবে।"
        },
        {
          "title": "৫. বাইনারি ট্রিতে ভুল বিট শিফটিং কাউন্ট",
          "desc": "ধনাত্মক পূর্ণসংখ্যার জন্য সর্বোচ্চ বিট ৩০ ধরে শিফট না করে ৩১ ধরলে চিহ্নের বিটে ভুল হিসেব আসবে।"
        },
      ];
    }
  }
}
