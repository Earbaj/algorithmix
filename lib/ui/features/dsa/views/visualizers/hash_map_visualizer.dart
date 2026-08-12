import 'debug_array_step.dart';

// ─── HASH MAP: CODE LINES ─────────────────────────────────────────────────────

const List<String> hm1CodeLines = [
  "vector<int> twoSum(vector<int>& nums, int target) {",
  "    unordered_map<int, int> mp;",
  "    for (int i = 0; i < nums.size(); i++) {",
  "        int complement = target - nums[i];",
  "        if (mp.count(complement)) return {mp[complement], i};",
  "        mp[nums[i]] = i;",
  "    }",
  "    return {};",
  "}",
];

const List<String> hm2CodeLines = [
  "bool isAnagram(string s, string t) {",
  "    if (s.length() != t.length()) return false;",
  "    unordered_map<char, int> freq;",
  "    for (char c : s) freq[c]++;",
  "    for (char c : t) { if (--freq[c] < 0) return false; }",
  "    return true;",
  "}",
];

const List<String> hm3CodeLines = [
  "vector<vector<string>> groupAnagrams(vector<string>& strs) {",
  "    unordered_map<string, vector<string>> mp;",
  "    for (string& s : strs) {",
  "        string key = s; sort(key.begin(), key.end());",
  "        mp[key].push_back(s);",
  "    }",
  "    return getValues(mp);",
  "}",
];

const List<String> hm4CodeLines = [
  "int subarraySum(vector<int>& nums, int k) {",
  "    unordered_map<int, int> mp; mp[0] = 1;",
  "    int sum = 0, count = 0;",
  "    for (int num : nums) {",
  "        sum += num;",
  "        if (mp.count(sum - k)) count += mp[sum - k];",
  "        mp[sum]++;",
  "    }",
  "    return count;",
  "}",
];

// ─── HASH MAP: STEPS ──────────────────────────────────────────────────────────

const List<DebugArrayStep> hm1Steps = [
  DebugArrayStep(
    activeLineIndex: 1,
    hashMapItems: {},
    array1D: [2, 7, 11, 15],
    explanationEn: "Line 2: Initialize empty Hash Map mp = {}. Target = 9.",
    explanationBn: "লাইন ২: খালি হ্যাশ ম্যাপ mp = {} সূচনা। টার্গেট = 9।",
  ),
  DebugArrayStep(
    activeLineIndex: 5,
    hashMapItems: {"2": "0"},
    array1D: [2, 7, 11, 15],
    pointer1: 0,
    explanationEn: "Line 6: i = 0 (val 2): complement (9 - 2 = 7) not in map -> Store mp[2] = 0.",
    explanationBn: "লাইন ৬: i = 0 (মান 2): কমপ্লিমেন্ট (9 - 2 = 7) ম্যাপে নেই -> mp[2] = 0 সেভ।",
  ),
  DebugArrayStep(
    activeLineIndex: 4,
    hashMapItems: {"2": "0"},
    array1D: [2, 7, 11, 15],
    pointer1: 1,
    explanationEn: "🎉 Line 5: i = 1 (val 7): complement (9 - 7 = 2) MATCH FOUND at mp[2] = 0! Return {0, 1}!",
    explanationBn: "🎉 লাইন ৫: i = 1 (মান 7): কমপ্লিমেন্ট (9 - 7 = 2) ম্যাপে পাওয়া গেছে! Return {0, 1}!",
  ),
];

const List<DebugArrayStep> hm2Steps = [
  DebugArrayStep(
    activeLineIndex: 3,
    hashMapItems: {"a": "3", "n": "1", "g": "1", "r": "1", "m": "1"},
    explanationEn: "Line 4: Count s = 'anagram' char frequencies -> {a:3, n:1, g:1, r:1, m:1}.",
    explanationBn: "লাইন ৪: s = 'anagram' ক্যারেক্টার কাউন্ট -> {a:3, n:1, g:1, r:1, m:1}।",
  ),
  DebugArrayStep(
    activeLineIndex: 4,
    hashMapItems: {"a": "0", "n": "0", "g": "0", "r": "0", "m": "0"},
    explanationEn: "Line 5: Decrement counts for t = 'nagaram' -> All frequencies decremented to 0.",
    explanationBn: "লাইন ৫: t = 'nagaram' ক্যারেক্টার বিয়োগ -> সব ফ্রিকোয়েন্সি কমে ০ হলো।",
  ),
  DebugArrayStep(
    activeLineIndex: 5,
    hashMapItems: {"a": "0", "n": "0", "g": "0", "r": "0", "m": "0"},
    explanationEn: "🎉 Line 6: All character counts match perfectly! Return TRUE!",
    explanationBn: "🎉 লাইন ৬: সমস্ত অক্ষরের গণনাসংখ্যা হুবহু মিলেছে! Return TRUE!",
  ),
];

const List<DebugArrayStep> hm3Steps = [
  DebugArrayStep(
    activeLineIndex: 4,
    hashMapItems: {"aet": "[\"eat\", \"tea\", \"ate\"]"},
    explanationEn: "Line 5: Grouped sorted key 'aet' -> [eat, tea, ate].",
    explanationBn: "লাইন ৫: সর্টেড কী 'aet' দিয়ে গ্রুপ -> [eat, tea, ate]।",
  ),
  DebugArrayStep(
    activeLineIndex: 4,
    hashMapItems: {"aet": "[\"eat\", \"tea\", \"ate\"]", "ant": "[\"tan\", \"nat\"]", "abt": "[\"bat\"]"},
    explanationEn: "Line 5: Grouped sorted keys 'ant' -> [tan, nat] and 'abt' -> [bat].",
    explanationBn: "লাইন ৫: সর্টেড কী 'ant' -> [tan, nat] এবং 'abt' -> [bat] গ্রুপ।",
  ),
  DebugArrayStep(
    activeLineIndex: 6,
    hashMapItems: {"aet": "[\"eat\", \"tea\", \"ate\"]", "ant": "[\"tan\", \"nat\"]", "abt": "[\"bat\"]"},
    explanationEn: "🎉 Line 7: Group Anagrams Complete! Return 3 grouped anagram buckets.",
    explanationBn: "🎉 লাইন ৭: অ্যানাগ্রাম গ্রুপিং সম্পন্ন! ৩টি অ্যানাগ্রাম বাকেট রিটার্ন করা হলো।",
  ),
];

const List<DebugArrayStep> hm4Steps = [
  DebugArrayStep(
    activeLineIndex: 1,
    hashMapItems: {"0": "1"},
    array1D: [1, 1, 1],
    explanationEn: "Line 2: Set mp[0] = 1 (base prefix sum 0), k = 2.",
    explanationBn: "লাইন ২: বেস প্রেফিক্স সাম mp[0] = 1 সেট, k = 2।",
  ),
  DebugArrayStep(
    activeLineIndex: 5,
    hashMapItems: {"0": "1", "1": "1"},
    array1D: [1, 1, 1],
    pointer1: 0,
    explanationEn: "Line 6: i = 0 (val 1): sum = 1. sum - k = -1 not in map. Store mp[1] = 1.",
    explanationBn: "লাইন ৬: i = 0 (মান 1): sum = 1। (1 - 2 = -1) ম্যাপে নেই -> mp[1] = 1 সেভ।",
  ),
  DebugArrayStep(
    activeLineIndex: 5,
    hashMapItems: {"0": "1", "1": "1", "2": "1"},
    array1D: [1, 1, 1],
    pointer1: 1,
    minVal: 1,
    explanationEn: "Line 6: i = 1 (val 1): sum = 2. sum - k = 0 (FOUND in mp). count = 1. Store mp[2] = 1.",
    explanationBn: "লাইন ৬: i = 1 (মান 1): sum = 2। (2 - 2 = 0) ম্যাপে পাওয়া গেছে! count = 1।",
  ),
  DebugArrayStep(
    activeLineIndex: 8,
    hashMapItems: {"0": "1", "1": "1", "2": "1", "3": "1"},
    array1D: [1, 1, 1],
    pointer1: 2,
    minVal: 2,
    explanationEn: "🎉 Line 9: i = 2 (val 1): sum = 3. sum - k = 1 (FOUND in mp). Final Subarray Count = 2!",
    explanationBn: "🎉 লাইন ৯: i = 2 (মান 1): sum = 3। (3 - 2 = 1) ম্যাপে পাওয়া গেছে! চূড়ান্ত গণনা = 2!",
  ),
];

// ─── GETTERS ──────────────────────────────────────────────────────────────────

List<String> getHashMapCodeLines(String id) {
  if (id == "hm-2") return hm2CodeLines;
  if (id == "hm-3") return hm3CodeLines;
  if (id == "hm-4") return hm4CodeLines;
  return hm1CodeLines;
}

List<DebugArrayStep> getHashMapSteps(String id) {
  if (id == "hm-2") return hm2Steps;
  if (id == "hm-3") return hm3Steps;
  if (id == "hm-4") return hm4Steps;
  return hm1Steps;
}
