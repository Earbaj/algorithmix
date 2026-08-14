class MonotonicStackProblem {
  final String title;
  final String difficulty; // Easy, Medium, Hard
  final List<String> companyTags;
  final String keyIdeaEn;
  final String keyIdeaBn;
  final bool isPopular;

  const MonotonicStackProblem({
    required this.title,
    required this.difficulty,
    required this.companyTags,
    required this.keyIdeaEn,
    required this.keyIdeaBn,
    this.isPopular = false,
  });
}

class MonotonicStackData {
  static Map<String, String> getConceptIntro(bool isEnglish) {
    if (isEnglish) {
      return {
        "title": "Monotonic Stack Pattern — Complete Deep Dive (C++ & FAANG Focus)",
        "summary": "A Monotonic Stack is a stack whose elements are strictly increasing or strictly decreasing. It is used to solve 'Next Greater Element', 'Next Smaller Element', or range boundary problems in linear O(N) time, reducing brute force O(N^2) nested loops down to a single pass where every element is pushed and popped at most once.",
        "whenToUseTitle": "When to Use Monotonic Stack?",
        "whenToUse1": "Next Greater Element or Next Smaller Element queries for each array element (Next Greater Element I LeetCode 496, Next Greater Element II LeetCode 503).",
        "whenToUse2": "Finding wait days until warmer temperature or stock span (Daily Temperatures LeetCode 739, Online Stock Span LeetCode 901).",
        "whenToUse3": "Max area of rectangle in histogram or binary matrix (Largest Rectangle in Histogram LeetCode 84, Maximal Rectangle LeetCode 85).",
        "whenToUse4": "Trapping Rain Water using stack (Trapping Rain Water LeetCode 42).",
        "whenToUse5": "Lexicographically smallest subsequence / String removal (Remove K Digits LeetCode 402, Remove Duplicate Letters LeetCode 316).",
        "typesTitle": "3 Main Monotonic Stack Patterns",
        "type1Title": "1. Monotonic Decreasing Stack (Next Greater Element)",
        "type1Desc": "Maintain stack elements in decreasing order. When larger element nums[i] arrives, pop elements while nums[i] > nums[st.top()]. Popped nodes found Next Greater Element!",
        "type2Title": "2. Monotonic Increasing Stack (Next Smaller Element / Histogram)",
        "type2Desc": "Maintain stack in increasing order. Pop elements while nums[i] < nums[st.top()]. Used for histogram left/right boundary calculation.",
        "type3Title": "3. Lexicographical Monotonic Stack (Subsequence Building)",
        "type3Desc": "Maintain increasing order of characters, popping larger characters if remaining count is sufficient (Remove K Digits / Duplicate Letters).",
      };
    } else {
      return {
        "title": "Monotonic Stack Pattern — সম্পূর্ণ গাইড (C++ ও FAANG ফোকাস)",
        "summary": "Monotonic Stack হলো এমন একটি স্ট্যাক যেখানে উপাদানগুলো সর্বদা ধারাবাহিকভাবে উর্ধ্বগামী (Increasing) বা নিম্নগামী (Decreasing) থাকে। এটি 'Next Greater Element' বা 'Next Smaller Element' প্রবলেমে ও(N^২) নেস্টেড লুপকে ১ পাসে O(N) সময়ে নিয়ে আসে, যেখানে প্রতিটি উপাদান সর্বোচ্চ ১ বার পুশ ও পপ হয়।",
        "whenToUseTitle": "কখন বুঝবা Monotonic Stack লাগবে?",
        "whenToUse1": "প্রতিটি উপাদানের পরবর্তী বড় বা ছোট মান খুঁজে বের করতে (Next Greater Element I LeetCode 496, LeetCode 503)।",
        "whenToUse2": "পরবর্তী গরম দিনের জন্য অপেক্ষার সময় বা স্টক স্প্যান পরিমাপে (Daily Temperatures LeetCode 739, Online Stock Span LeetCode 901)।",
        "whenToUse3": "হিস্টোগ্রাম বা বাইনারি ম্যাট্রিক্সে সর্বোচ্চ আয়তক্ষেত্রের ক্ষেত্রফল বের করতে (Largest Rectangle in Histogram LeetCode 84)।",
        "whenToUse4": "স্ট্যাক ব্যবহার করে জমানো বৃষ্টির পানি গণনা করতে (Trapping Rain Water LeetCode 42)।",
        "whenToUse5": "শব্দের ক্যারেক্টার বাদ দিয়ে ডিকশনারি ক্রমানুসারে ছোট সাবসিকোয়েন্স বানাতে (Remove K Digits LeetCode 402)।",
        "typesTitle": "Main Types (৩ ধরনের pattern)",
        "type1Title": "১. Monotonic Decreasing Stack (পরবর্তী বড় মান/Next Greater)",
        "type1Desc": "স্ট্যাকে উপাদানগুলো বড় থেকে ছোট আকারে রাখো। একটি বড় মান `nums[i]` আসলে `nums[i] > nums[st.top()]` মেপে পপ করো। পপ হওয়া মানগুলোর Next Greater পাওয়া গেছে!",
        "type2Title": "২. Monotonic Increasing Stack (পরবর্তী ছোট মান/হিস্টোগ্রাম)",
        "type2Desc": "স্ট্যাকে ছোট থেকে বড় মান রাখো। `nums[i] < nums[st.top()]` মেপে পপ করো। হিস্টোগ্রামের সীমানা নির্ধারণে ব্যবহৃত হয়।",
        "type3Title": "৩. Lexicographical Monotonic Stack (অক্ষর সর্টেড সাবসিকোয়েন্স)",
        "type3Desc": "ছোট অক্ষর দিয়ে স্ট্যাক সাজাও এবং হাতে অতিরিক্ত অক্ষর থাকলে বড় অক্ষর পপ করে ছোট স্ট্রিং তৈরি করো।",
      };
    }
  }

  static List<MonotonicStackProblem> getEasyProblems() {
    return const [
      MonotonicStackProblem(
        title: "Next Greater Element I",
        difficulty: "Easy",
        companyTags: ["Amazon", "Meta", "Google", "Microsoft"],
        keyIdeaEn: "Monotonic decreasing stack with HashMap mapping nums1 elements to Next Greater value.",
        keyIdeaBn: "ডিক্রিজিং স্ট্যাক ও হ্যাশম্যাপ দিয়ে Next Greater মান ম্যাপ করুন।",
        isPopular: true,
      ),
      MonotonicStackProblem(
        title: "Final Prices With a Special Discount in a Shop",
        difficulty: "Easy",
        companyTags: ["Amazon", "Meta"],
        keyIdeaEn: "Monotonic increasing stack finding next smaller or equal price discount.",
        keyIdeaBn: "ইনক্রিজিং স্ট্যাক দিয়ে পরবর্তী ছোট বা সমান মূল্যের ডিসকাউন্ট বিয়োগ করুন।",
        isPopular: true,
      ),
      MonotonicStackProblem(
        title: "Valid Parentheses",
        difficulty: "Easy",
        companyTags: ["Amazon", "Meta", "Google", "Microsoft"],
        keyIdeaEn: "Classic stack matching opening and closing bracket pairs.",
        keyIdeaBn: "স্ট্যাক দিয়ে বন্ধনী জোড়া সঠিক কিনা ভ্যালিডেট করুন।",
      ),
      MonotonicStackProblem(
        title: "BackSpace String Compare",
        difficulty: "Easy",
        companyTags: ["Google", "Amazon"],
        keyIdeaEn: "Stack pushing chars and popping on '#' backspace.",
        keyIdeaBn: "'#' ব্যাকস্পেস পেলেই স্ট্যাক থেকে শেষ অক্ষর পপ করুন।",
      ),
      MonotonicStackProblem(
        title: "Make The String Great",
        difficulty: "Easy",
        companyTags: ["Amazon", "Google"],
        keyIdeaEn: "Stack popping adjacent uppercase and lowercase identical characters.",
        keyIdeaBn: "পাশাপাশি বড় হাতের ও ছোট হাতের একই অক্ষর থাকলে পপ করুন।",
      ),
      MonotonicStackProblem(
        title: "Crawler Log Folder",
        difficulty: "Easy",
        companyTags: ["Amazon", "Meta"],
        keyIdeaEn: "Stack depth counter tracking folder navigation.",
        keyIdeaBn: "স্ট্যাক গভীরতা ট্র্যাক করে মেইন ফোল্ডারে ফেরার ধাপ হিসাব করুন।",
      ),
      MonotonicStackProblem(
        title: "Remove Outermost Parentheses",
        difficulty: "Easy",
        companyTags: ["Google", "Amazon"],
        keyIdeaEn: "Stack counter removing outer brackets.",
        keyIdeaBn: "বাইরের বন্ধনী ছেঁটে মূল বন্ধনী ফিল্টার করুন।",
      ),
      MonotonicStackProblem(
        title: "Baseball Game",
        difficulty: "Easy",
        companyTags: ["Amazon", "Meta"],
        keyIdeaEn: "Stack evaluating '+' and 'D' baseball scores.",
        keyIdeaBn: "স্ট্যাক অপারেশন দিয়ে বেসবলের স্কোর যোগ করুন।",
      ),
    ];
  }

  static List<MonotonicStackProblem> getMediumProblems() {
    return const [
      MonotonicStackProblem(
        title: "Daily Temperatures",
        difficulty: "Medium",
        companyTags: ["Meta", "Amazon", "Google", "Microsoft", "Bloomberg"],
        keyIdeaEn: "Monotonic decreasing stack storing indices. When T[i] > T[st.top()], pop index idx and answer[idx] = i - idx.",
        keyIdeaBn: "ডিক্রিজিং স্ট্যাকে ইনডেক্স রেখে T[i] > T[st.top()] হলে পপ করে অপেক্ষার দিন (i - idx) পান।",
        isPopular: true,
      ),
      MonotonicStackProblem(
        title: "Next Greater Element II (Circular)",
        difficulty: "Medium",
        companyTags: ["Meta", "Amazon", "Google", "Microsoft"],
        keyIdeaEn: "Monotonic decreasing stack running on duplicated virtual array length 2 * N using index i % N.",
        keyIdeaBn: "সার্কুলার এরে প্রবলেমে 2 * N লুপ চালিয়ে ইনডেক্স i % N মেইনটেইন করে স্ট্যাক ব্যবহার করুন।",
        isPopular: true,
      ),
      MonotonicStackProblem(
        title: "Online Stock Span",
        difficulty: "Medium",
        companyTags: ["Amazon", "Meta", "Google", "Microsoft", "Bloomberg"],
        keyIdeaEn: "Monotonic stack storing pair {price, span}. Pop while st.top().price <= price and accumulate spans.",
        keyIdeaBn: "{price, span} জোড়া স্ট্যাকে রেখে ছোট মান পপ করে মোট স্প্যান সাম করুন।",
        isPopular: true,
      ),
      MonotonicStackProblem(
        title: "Remove K Digits",
        difficulty: "Medium",
        companyTags: ["Google", "Amazon", "Meta", "Microsoft"],
        keyIdeaEn: "Monotonic increasing stack popping stack.top() > digit while k > 0 to build smallest number.",
        keyIdeaBn: "k > 0 থাকা পর্যন্ত বড় ডিজিট পপ করে ছোটতম সংখ্যা গঠন করুন।",
        isPopular: true,
      ),
      MonotonicStackProblem(
        title: "Remove Duplicate Letters",
        difficulty: "Medium",
        companyTags: ["Google", "Amazon", "Meta", "Microsoft"],
        keyIdeaEn: "Monotonic stack with last-occurrence frequency map ensuring lexicographical order and uniqueness.",
        keyIdeaBn: "লাস্ট অ্যাক্সুরেন্স মেপে ডিকশনারি ক্রমানুসারে ছোটতম ইউনিক ক্যারেক্টার স্ট্রিং বানান।",
      ),
      MonotonicStackProblem(
        title: "Sum of Subarray Minimums",
        difficulty: "Medium",
        companyTags: ["Amazon", "Meta", "Google", "Microsoft"],
        keyIdeaEn: "Find Next Smaller Element (NSE) and Previous Smaller Element (PSE) using monotonic stack.",
        keyIdeaBn: "স্ট্যাক দিয়ে বাম ও ডানের ছোট মান মেপে সাবএরের মিনিমামের সাম পান।",
      ),
      MonotonicStackProblem(
        title: "Asteroid Collision",
        difficulty: "Medium",
        companyTags: ["Meta", "Amazon", "Google", "Microsoft"],
        keyIdeaEn: "Stack simulating left and right moving asteroids exploding upon collision.",
        keyIdeaBn: "স্ট্যাক দিয়ে ডান ও বামের অ্যাস্টেরয়েড সংঘর্ষ সিমুলেট করুন।",
      ),
      MonotonicStackProblem(
        title: "132 Pattern",
        difficulty: "Medium",
        companyTags: ["Meta", "Amazon", "Google", "Microsoft"],
        keyIdeaEn: "Monotonic stack keeping track of the candidate for s3 while searching for s1 < s3.",
        keyIdeaBn: "ডিক্রিজিং স্ট্যাকে s3 ক্যান্ডিডেট রেখে s1 < s3 প্যাটার্ন টেস্ট করুন।",
      ),
    ];
  }

  static List<MonotonicStackProblem> getHardProblems() {
    return const [
      MonotonicStackProblem(
        title: "Largest Rectangle in Histogram",
        difficulty: "Hard",
        companyTags: ["Meta", "Amazon", "Google", "Microsoft", "Bloomberg", "Apple"],
        keyIdeaEn: "Monotonic increasing stack of indices. When height decreases, pop bar h and calculate area h * (i - st.top() - 1).",
        keyIdeaBn: "ইনক্রিজিং স্ট্যাকে উচ্চতা কমলেই বার পপ করে রেক্টেঙ্গেল এরিয়া মেপে সর্বোচ্চ মান নিন।",
        isPopular: true,
      ),
      MonotonicStackProblem(
        title: "Maximal Rectangle",
        difficulty: "Hard",
        companyTags: ["Google", "Meta", "Amazon", "Microsoft"],
        keyIdeaEn: "Convert 2D binary matrix into row histogram and apply Largest Rectangle in Histogram using stack.",
        keyIdeaBn: "২D বাইনারি ম্যাট্রিক্সকে রো-বাই-রো হিস্টোগ্রামে রূপান্তর করে স্ট্যাক দিয়ে حل করুন।",
        isPopular: true,
      ),
      MonotonicStackProblem(
        title: "Trapping Rain Water (Stack Approach)",
        difficulty: "Hard",
        companyTags: ["Google", "Amazon", "Meta"],
        keyIdeaEn: "Monotonic decreasing stack of bar indices tracking trapped water bounded by left and right walls.",
        keyIdeaBn: "ডিক্রিজিং স্ট্যাকে বার ইনডেক্স রেখে দুই দেয়ালের মাঝের জমানো পানি গণনা করুন।",
      ),
    ];
  }

  static List<Map<String, String>> getCommonMistakes(bool isEnglish) {
    if (isEnglish) {
      return [
        {
          "title": "1. Storing Values Instead of Indices in Stack",
          "desc": "Storing array values instead of array indices prevents calculating distance `i - st.top()` needed for Daily Temperatures or Histogram width."
        },
        {
          "title": "2. Using Strictly Greater (`>`) vs Greater Or Equal (`>=`) Incorrectly",
          "desc": "Using `>` when handling duplicates can cause infinite loops or overcounting. Always be strict about `>=` vs `>` based on duplicate handling."
        },
        {
          "title": "3. Forgetting to Flush Remaining Stack Elements After Main Loop",
          "desc": "Elements remaining in stack after array iteration represent nodes with no Next Greater/Smaller element. Set default fallback value `-1` or `0`."
        },
        {
          "title": "4. Off-by-One in Histogram Width Calculation",
          "desc": "Width formula `w = st.empty() ? i : i - st.top() - 1` requires careful handling of empty stack edge case."
        },
        {
          "title": "5. Confusing Monotonic Decreasing vs Increasing Stack Purpose",
          "desc": "Use Decreasing Stack for Next Greater Element; use Increasing Stack for Next Smaller Element or Histogram boundaries."
        },
      ];
    } else {
      return [
        {
          "title": "১. স্ট্যাকে ইনডেক্সের বদলে সরাসরি ভ্যালু রাখা",
          "desc": "ইনডেক্স না রেখে ভ্যালু রাখলে পরবর্তী গরম দিনের দূরত্ব `i - st.top()` বা হিস্টোগ্রামের প্রস্থ হিসেব করা অসম্ভব হয়ে পড়ে।"
        },
        {
          "title": "২. `>` এবং `>=` শর্ত ব্যবহারে ভুল করা",
          "desc": "ডুপ্লিকেট মানের ক্ষেত্রে strict `>`, নাকি `>=` দেবেন তা ভুল করলে পপ কাউন্টে বা লুপে অমিল দেখা দেবে।"
        },
        {
          "title": "৩. প্রধান লুপ শেষে স্ট্যাক খালি না করা (Flush Stack)",
          "desc": "লুপ শেষে স্ট্যাকে রয়ে যাওয়া নোডগুলোর জন্য কোনো Next Greater/Smaller নেই, সেগুলোর জন্য ডিফল্ট `-1` বা `0` বরাদ্দ করুন।"
        },
        {
          "title": "৪. হিস্টোগ্রামের প্রস্থ (Width) গণনায় ১ এর গরমিল",
          "desc": "প্রস্থের সূত্র `w = st.empty() ? i : i - st.top() - 1` এ খালি স্ট্যাকের ক্ষেত্রে সীমানা সঠিকভাবে হ্যান্ডেল করুন।"
        },
        {
          "title": "৫. Decreasing বনাম Increasing স্ট্যাক গুলিয়ে ফেলা",
          "desc": "Next Greater Element এর জন্য Decreasing Stack এবং Next Smaller Element বা হিস্টোগ্রামের জন্য Increasing Stack ব্যবহার করুন।"
        },
      ];
    }
  }
}
