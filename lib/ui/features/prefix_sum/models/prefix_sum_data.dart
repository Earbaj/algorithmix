class PrefixSumProblem {
  final String title;
  final String difficulty; // Easy, Medium, Hard
  final List<String> companyTags;
  final String keyIdeaEn;
  final String keyIdeaBn;
  final bool isPopular;

  const PrefixSumProblem({
    required this.title,
    required this.difficulty,
    required this.companyTags,
    required this.keyIdeaEn,
    required this.keyIdeaBn,
    this.isPopular = false,
  });
}

class PrefixSumData {
  static Map<String, String> getConceptIntro(bool isEnglish) {
    if (isEnglish) {
      return {
        "title": "Prefix Sum Pattern — Complete Deep Dive (C++ & FAANG Focus)",
        "summary": "The Prefix Sum pattern involves precomputing a cumulative sum array P where P[i] = sum(nums[0..i]). It reduces range sum query time from O(N) brute force down to O(1) constant time using the formula RangeSum(L, R) = P[R] - P[L-1]. Combined with a Hash Map, it solves subarray sum equals K in a single O(N) pass.",
        "whenToUseTitle": "When to Use Prefix Sum?",
        "whenToUse1": "Multiple range sum queries on an array or 2D matrix (Range Sum Query Immutable LeetCode 303, Range Sum Query 2D Immutable LeetCode 304).",
        "whenToUse2": "Finding total count of subarrays with sum equal to K (Subarray Sum Equals K LeetCode 560).",
        "whenToUse3": "Finding total count of continuous subarrays divisible by K (Subarray Sums Divisible by K LeetCode 974).",
        "whenToUse4": "Finding equilibrium index or pivot index where left sum equals right sum (Find Pivot Index LeetCode 724).",
        "whenToUse5": "Prefix/Suffix product calculations or range updates (Product of Array Except Self LeetCode 238, Corporate Flight Bookings / Difference Array LeetCode 1109).",
        "typesTitle": "3 Main Prefix Sum Patterns",
        "type1Title": "1. 1D Prefix Sum Array & Range Query Formula",
        "type1Desc": "Precompute 1-indexed prefix[i+1] = prefix[i] + nums[i]. Calculate RangeSum(L, R) = prefix[R+1] - prefix[L] in O(1) time.",
        "type2Title": "2. Prefix Sum + HashMap (Subarray Sum Equals K)",
        "type2Desc": "Maintain cumulative currSum and map[currSum] count. Subarray with sum K exists if map.count(currSum - k). Initialize map[0] = 1!",
        "type3Title": "3. 2D Matrix Prefix Sum & Difference Array",
        "type3Desc": "Precompute 2D cumulative sum grid P[r][c]. Matrix region sum = P[r2][c2] - P[r1-1][c2] - P[r2][c1-1] + P[r1-1][c1-1].",
      };
    } else {
      return {
        "title": "Prefix Sum Pattern — সম্পূর্ণ গাইড (C++ ও FAANG ফোকাস)",
        "summary": "Prefix Sum প্যাটার্নে একটি কিউমুলেটিভ যোগফল এরে P তৈরি করা হয় যেখানে P[i] = sum(nums[0..i])। এটি রেঞ্জ সাম কোয়েরি O(N) থেকে কমিয়ে ও(১) সময়ে নিয়ে আসে সূত্র `RangeSum(L, R) = P[R] - P[L-1]` ব্যবহারের মাধ্যমে। হ্যাশম্যাপের সাথে যুক্ত করে ১ পাসে O(N) সময়ে `Subarray Sum Equals K` সমাধান করা যায়।",
        "whenToUseTitle": "কখন বুঝবা Prefix Sum লাগবে?",
        "whenToUse1": "অ্যারে বা ২D ম্যাট্রিক্সে একাধিক রেঞ্জ সাম কোয়েরি থাকলে (Range Sum Query LeetCode 303, 304)।",
        "whenToUse2": "যোগফল K এর সমান হওয়া মোট সাবএরের সংখ্যা গণনা করতে (Subarray Sum Equals K LeetCode 560)।",
        "whenToUse3": "যোগফল K দিয়ে বিভাজ্য হওয়া সাবএরের সংখ্যা মেপে বের করতে (Subarray Sums Divisible by K LeetCode 974)।",
        "whenToUse4": "অ্যারের ভারসাম্য বা পিভট ইনডেক্স খুঁজে বের করতে যেখানে বাম সাম == ডান সাম (Find Pivot Index LeetCode 724)।",
        "whenToUse5": "নিজের উপাদান বাদ দিয়ে প্রিফিক্স/সাফিক্স গুণফল বা রেঞ্জ আপডেট করতে (Product of Array Except Self LeetCode 238, Difference Array LeetCode 1109)।",
        "typesTitle": "Main Types (৩ ধরনের pattern)",
        "type1Title": "১. ১D Prefix Sum এরে ও রেঞ্জ সাম ফর্মুলা",
        "type1Desc": "১-বেসড এরে `prefix[i+1] = prefix[i] + nums[i]` তৈরি করো। ও(১) সময়ে `RangeSum(L, R) = prefix[R+1] - prefix[L]` মেপে উত্তর বের করো।",
        "type2Title": "২. Prefix Sum + HashMap (Subarray Sum Equals K)",
        "type2Desc": "চলতি `currSum` মেপে `map[currSum - k]` চেক করো। থাকলে কাউন্ট যোগ করো। শুরুতে অবশ্যই `map[0] = 1` ইনিশিয়ালাইজ করো!",
        "type3Title": "৩. ২D ম্যাট্রিক্স Prefix Sum ও ডিফারেন্স এরে",
        "type3Desc": "২D কিউমুলেটিভ ম্যাট্রিক্স `P[r][c]` বানিয়ে `P[r2][c2] - P[r1-1][c2] - P[r2][c1-1] + P[r1-1][c1-1]` সূত্রে ক্ষেত্রফল সাম বের করো।",
      };
    }
  }

  static List<PrefixSumProblem> getEasyProblems() {
    return const [
      PrefixSumProblem(
        title: "Range Sum Query - Immutable",
        difficulty: "Easy",
        companyTags: ["Amazon", "Meta", "Google", "Microsoft"],
        keyIdeaEn: "Precompute 1D prefix sum array. Query sum in O(1) time: prefix[right+1] - prefix[left].",
        keyIdeaBn: "১D প্রিফিক্স সাম এরে বানিয়ে O(1) সময়ে রেঞ্জ সাম ফেরত দিন।",
        isPopular: true,
      ),
      PrefixSumProblem(
        title: "Find Pivot Index",
        difficulty: "Easy",
        companyTags: ["Amazon", "Meta", "Google"],
        keyIdeaEn: "Calculate totalSum. Iterate array tracking leftSum: pivot occurs when leftSum == totalSum - leftSum - nums[i].",
        keyIdeaBn: "টোটাল সাম ধরে leftSum == totalSum - leftSum - nums[i] হলে পিভট ইনডেক্স পান।",
        isPopular: true,
      ),
      PrefixSumProblem(
        title: "Running Sum of 1d Array",
        difficulty: "Easy",
        companyTags: ["Amazon", "Google"],
        keyIdeaEn: "In-place prefix sum: nums[i] += nums[i-1].",
        keyIdeaBn: "ইন-প্লেস যোগফল হিসেব করে রানিং সাম এরে পান।",
      ),
      PrefixSumProblem(
        title: "Find the Highest Altitude",
        difficulty: "Easy",
        companyTags: ["Amazon", "Meta"],
        keyIdeaEn: "Prefix sum tracking maximum altitude accumulated.",
        keyIdeaBn: "প্রিফিক্স সাম বাড়িয়ে সর্বোচ্চ অলটিটিউড ট্র্যাক করুন।",
      ),
      PrefixSumProblem(
        title: "Left and Right Sum Differences",
        difficulty: "Easy",
        companyTags: ["Amazon", "Meta"],
        keyIdeaEn: "Absolute difference between leftSum and rightSum arrays.",
        keyIdeaBn: "বাম ও ডান যোগফলের পরম পার্থক্য বের করুন।",
      ),
      PrefixSumProblem(
        title: "Find Middle Index in Array",
        difficulty: "Easy",
        companyTags: ["Google", "Amazon"],
        keyIdeaEn: "Same as Find Pivot Index.",
        keyIdeaBn: "মিডল ইনডেক্স বা পিভট ইনডেক্স খুঁজে বের করুন।",
      ),
      PrefixSumProblem(
        title: "Minimum Value to Get Positive Step by Step Sum",
        difficulty: "Easy",
        companyTags: ["Google", "Amazon"],
        keyIdeaEn: "Find minimum prefix sum minSum. Return 1 - minSum if minSum < 0 else 1.",
        keyIdeaBn: "সর্বনিম্ন প্রিফিক্স সাম মেপে স্টার্ট ভ্যালু হিসেব করুন।",
      ),
      PrefixSumProblem(
        title: "Matrix Block Sum Simple",
        difficulty: "Easy",
        companyTags: ["Amazon", "Meta"],
        keyIdeaEn: "Simple 2D matrix range query.",
        keyIdeaBn: "সহজ ২D ম্যাট্রিক্স ব্লক সাম বের করুন।",
      ),
    ];
  }

  static List<PrefixSumProblem> getMediumProblems() {
    return const [
      PrefixSumProblem(
        title: "Subarray Sum Equals K",
        difficulty: "Medium",
        companyTags: ["Meta", "Amazon", "Google", "Microsoft", "Bloomberg"],
        keyIdeaEn: "Prefix Sum + HashMap initialized with map[0]=1. Count occurrences of (currSum - k) in map in single O(N) pass.",
        keyIdeaBn: "প্রিফিক্স সাম ও map[0]=1 হ্যাশম্যাপ দিয়ে ১ পাসে (currSum - k) এর কাউন্ট যোগ করে প্রবলেম মেটান।",
        isPopular: true,
      ),
      PrefixSumProblem(
        title: "Product of Array Except Self",
        difficulty: "Medium",
        companyTags: ["Meta", "Amazon", "Google", "Microsoft", "Bloomberg", "Apple"],
        keyIdeaEn: "Compute prefix product pass left-to-right into ans[], then accumulate suffix product right-to-left in O(N) time and O(1) extra space.",
        keyIdeaBn: "বাম থেকে ডান প্রিফিক্স প্রোডাক্ট ও ডান থেকে বাম সাফিক্স প্রোডাক্ট মেপে O(1) স্পেসে গুণফল পান।",
        isPopular: true,
      ),
      PrefixSumProblem(
        title: "Subarray Sums Divisible by K",
        difficulty: "Medium",
        companyTags: ["Meta", "Amazon", "Google", "Microsoft"],
        keyIdeaEn: "Prefix Sum + Remainder HashMap tracking mod values: rem = ((currSum % k) + k) % k.",
        keyIdeaBn: "প্রিফিক্স সামে ক্যানোনিকাল রিমাইন্ডার মেপে ক দ্বারা বিভাজ্য সাবএরে গুণুন।",
        isPopular: true,
      ),
      PrefixSumProblem(
        title: "Continuous Subarray Sum",
        difficulty: "Medium",
        companyTags: ["Meta", "Amazon", "Google", "Microsoft"],
        keyIdeaEn: "Prefix sum mod K mapped to first index seen. Subarray length >= 2 if (i - map[rem]) >= 2.",
        keyIdeaBn: "রিমাইন্ডার ১ম ইনডেক্স হ্যাশম্যাপে রেখে লেন্থ >= ২ ভ্যালিডেট করুন।",
      ),
      PrefixSumProblem(
        title: "Range Sum Query 2D - Immutable",
        difficulty: "Medium",
        companyTags: ["Meta", "Amazon", "Google", "Microsoft", "Bloomberg"],
        keyIdeaEn: "Precompute 2D prefix sum grid. Query region sum in O(1) time using inclusion-exclusion formula.",
        keyIdeaBn: "২D প্রিফিক্স সাম ম্যাট্রিক্স বানিয়ে O(1) সময়ে রেঞ্জ সাম ফেরত দিন।",
      ),
      PrefixSumProblem(
        title: "Corporate Flight Bookings (Difference Array)",
        difficulty: "Medium",
        companyTags: ["Amazon", "Meta", "Google"],
        keyIdeaEn: "Difference Array technique: for range [l, r] with val v, diff[l] += v and diff[r+1] -= v, then prefix sum.",
        keyIdeaBn: "ডিফারেন্স এরে দিয়ে রেঞ্জ আপডেট diff[l] += v, diff[r+1] -= v চালিয়ে প্রিফিক্স সাম নিন।",
      ),
      PrefixSumProblem(
        title: "Car Pooling",
        difficulty: "Medium",
        companyTags: ["Amazon", "Meta", "Google"],
        keyIdeaEn: "Difference Array range update tracking passenger capacity bounds.",
        keyIdeaBn: "ডিফারেন্স এরে দিয়ে পিকআপ ও ড্রপ ড্রাইভে মোট প্যাসেঞ্জার সংখ্যা চেক করুন।",
      ),
      PrefixSumProblem(
        title: "Maximum Size Subarray Sum Equals k",
        difficulty: "Medium",
        companyTags: ["Meta", "Amazon", "Google", "Microsoft"],
        keyIdeaEn: "Prefix sum HashMap storing first occurrence index of each prefix sum to maximize length.",
        keyIdeaBn: "সর্বপ্রথম ইনডেক্স হ্যাশম্যাপে রেখে সর্বোচ্চ দৈর্ঘ্যের সাবএরে পান।",
      ),
    ];
  }

  static List<PrefixSumProblem> getHardProblems() {
    return const [
      PrefixSumProblem(
        title: "Max Sum of Rectangle No Larger Than K",
        difficulty: "Hard",
        companyTags: ["Google", "Amazon", "Meta"],
        keyIdeaEn: "2D Prefix Sum column compression + 1D std::set lower_bound prefix sum search in O(R^2 * C log C).",
        keyIdeaBn: "কলাম সাম কম্প্রেস করে set lower_bound দিয়ে K এর সমান/ছোট ম্যাক্স এরিয়া পান।",
        isPopular: true,
      ),
      PrefixSumProblem(
        title: "Count of Range Sum",
        difficulty: "Hard",
        companyTags: ["Google", "Amazon", "Meta", "Microsoft"],
        keyIdeaEn: "Merge Sort / Fenwick Tree (BIT) on prefix sums counting range lower <= P[j] - P[i] <= upper.",
        keyIdeaBn: "মার্জ সর্ট বা ডাবল পয়েন্টার দিয়ে প্রিফিক্স সামের রেঞ্জ কাউন্ট করুন।",
        isPopular: true,
      ),
      PrefixSumProblem(
        title: "Grid Illumination",
        difficulty: "Hard",
        companyTags: ["Google", "Amazon", "Meta"],
        keyIdeaEn: "HashMaps tracking row, col, diagonal1 (r - c), and diagonal2 (r + c) lamp count prefix sums.",
        keyIdeaBn: "রো, কলাম ও দুই ডায়াগোনালের ল্যাম্প কাউন্ট প্রিফিক্স ট্র্যাক করুন।",
      ),
    ];
  }

  static List<Map<String, String>> getCommonMistakes(bool isEnglish) {
    if (isEnglish) {
      return [
        {
          "title": "1. Forgetting Base Case `prefixMap[0] = 1`",
          "desc": "Failing to initialize `prefixMap[0] = 1` causes subarrays starting from index 0 whose sum equals K to be missed completely!"
        },
        {
          "title": "2. Handling Negative Modulo Values in C++ (`currSum % k`)",
          "desc": "In C++, `%` operator returns negative values for negative integers. Always use canonical modulo `rem = ((currSum % k) + k) % k`!"
        },
        {
          "title": "3. Off-by-One in 1D Prefix Sum Indexing",
          "desc": "Using 0-indexed prefix array requires `prefix[R] - prefix[L-1]` (checking L > 0). Using 1-indexed `prefix[R+1] - prefix[L]` avoids boundary checks."
        },
        {
          "title": "4. Incorrect Inclusion-Exclusion in 2D Matrix Prefix Sum",
          "desc": "Adding back overlapping top-left region twice or missing subtract terms `P[r1-1][c2]` and `P[r2][c1-1]`."
        },
        {
          "title": "5. Modifying Map Count Before Checking `currSum - k`",
          "desc": "Updating `prefixMap[currSum]++` BEFORE checking `currSum - k` leads to incorrect self-matching when k == 0."
        },
      ];
    } else {
      return [
        {
          "title": "১. বেস কেস `prefixMap[0] = 1` সেট করতে ভুলে যাওয়া",
          "desc": "শুরুতে `prefixMap[0] = 1` না রাখলে ইনডেক্স ০ থেকে শুরু হওয়া সাবএরে যার যোগফল K, সেটি মিস হয়ে যাবে!"
        },
        {
          "title": "২. C++ এ ঋণাত্মক ভাগশেষের ভুল হ্যান্ডলিং (`currSum % k`)",
          "desc": "C++ এ `%` অপারেটর ঋণাত্মক সংখ্যার জন্য নেগেটিভ দেয়। ক্যানোনিকাল ফর্মুলা `rem = ((currSum % k) + k) % k` ব্যবহার করুন।"
        },
        {
          "title": "৩. ১D প্রিফিক্স এরে ইনডেক্সিংয়ে ১ এর ভুল",
          "desc": "০-বেসড এরেতে `prefix[R] - prefix[L-1]` এ L > 0 চেক লাগে। ১-বেসড `prefix[R+1] - prefix[L]` ব্যবহারে এই বাউন্ডারি ঝামেলা নেই।"
        },
        {
          "title": "৪. ২D ম্যাট্রিক্স প্রিফিক্স সামে ইনক্লুশন-এক্সক্লুশন ভুল",
          "desc": "`P[r2][c2] - P[r1-1][c2] - P[r2][c1-1] + P[r1-1][c1-1]` সূত্রে ওপরের বাম কোনা পুনরায় যোগ করতে ভুলে যাওয়া।"
        },
        {
          "title": "৫. `currSum - k` চেকের আগেই ম্যাপ আপডেট করা",
          "desc": "ক্যালকুলেশন চেকের আগেই `prefixMap[currSum]++` করলে k == 0 হলে নিজের সাথে নিজেকে ম্যাচ করে ভুল উত্তর দেবে।"
        },
      ];
    }
  }
}
