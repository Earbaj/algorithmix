import 'package:flutter/material.dart';

class DsaProblem {
  final String id;
  final String title;
  final String category; // e.g. "1D Array Basic", "2D Matrix Pattern"
  final String keyIdeaEn;
  final String keyIdeaBn;
  final String codeCpp;
  final String codeJava;
  final String codePython;
  final String codeJs;
  final String descriptionEn;
  final String descriptionBn;
  final List<String> sampleInputs;
  final List<String> sampleOutputs;

  const DsaProblem({
    required this.id,
    required this.title,
    required this.category,
    required this.keyIdeaEn,
    required this.keyIdeaBn,
    required this.codeCpp,
    required this.codeJava,
    required this.codePython,
    required this.codeJs,
    required this.descriptionEn,
    required this.descriptionBn,
    required this.sampleInputs,
    required this.sampleOutputs,
  });
}

class DsaTopic {
  final int id;
  final String title;
  final String category;
  final String timeComplexity;
  final String spaceComplexity;
  final String descriptionEn;
  final String descriptionBn;
  final IconData icon;
  final Color themeColor;
  final List<String> keyConceptsEn;
  final List<String> keyConceptsBn;
  final Map<String, Map<String, String>> multiDimCodeTemplates;
  final List<DsaProblem> basicProblems;
  final List<Map<String, String>> commonMistakesEn;
  final List<Map<String, String>> commonMistakesBn;
  final List<Map<String, String>> roadmapStepsEn;
  final List<Map<String, String>> roadmapStepsBn;

  const DsaTopic({
    required this.id,
    required this.title,
    required this.category,
    required this.timeComplexity,
    required this.spaceComplexity,
    required this.descriptionEn,
    required this.descriptionBn,
    required this.icon,
    required this.themeColor,
    required this.keyConceptsEn,
    required this.keyConceptsBn,
    required this.multiDimCodeTemplates,
    required this.basicProblems,
    required this.commonMistakesEn,
    required this.commonMistakesBn,
    required this.roadmapStepsEn,
    required this.roadmapStepsBn,
  });
}

class DsaDataRepository {
  static List<DsaTopic> getTopics() {
    return [
      // 1. ARRAYS & DYNAMIC LISTS
      DsaTopic(
        id: 201,
        title: "Arrays & Dynamic Lists",
        category: "Linear & Multi-Dimensional Structure",
        timeComplexity: "Access O(1) | Search O(N) | Insertion O(N)",
        spaceComplexity: "1D: O(N) | 2D: O(R×C) | 3D: O(D×R×C)",
        icon: Icons.view_column_outlined,
        themeColor: const Color(0xFF3B82F6),
        descriptionEn:
            "An Array is a contiguous memory allocation storing elements of the same data type. It supports instant O(1) constant time element access using zero-based indices (`arr[i]`). Dynamic Lists (like `vector` in C++, `ArrayList` in Java, `list` in Python, or `Array` in JS) automatically resize by doubling memory capacity when full. Multi-dimensional Arrays extend this into 2D Matrices (`matrix[row][col]`) and 3D Tensors (`tensor[depth][row][col]`).",
        descriptionBn:
            "অ্যারে (Array) হলো একই ধরনের ডেটা টাইপ মেমোরিতে পর পর (Contiguous) সাজিয়ে রাখার স্ট্রাকচার। এটি শূন্য-ভিত্তিক ইনডেক্স (`arr[i]`) ব্যবহার করে ওয়ান (O(1)) স্পিডে এলিমেন্ট অ্যাক্সেস করতে পারে। ডাইনামিক লিস্ট (যেমন C++ এর `vector`, Java এর `ArrayList`, Python এর `list`, JS এর `Array`) ফুল হয়ে গেলে ক্যাপাসিটি দ্বিগুণ বাড়িয়ে স্বয়ংক্রিয় রি-অ্যালকোপেশন করে। মাল্টি-ডাইমেনশনাল অ্যারে এটিকে ২টি মাত্রায় ২D ম্যাট্রিক্স (`matrix[row][col]`) এবং ৩টি মাত্রায় ৩D টেনসরে (`tensor[depth][row][col]`) রূপান্তরিত করে।",
        keyConceptsEn: [
          "O(1) Direct Access: `arr[i]` computes memory address in constant O(1) time using base address + (index × element_size).",
          "Dynamic Array Resizing: When capacity is reached, memory is reallocated with 2x capacity, amortizing insertion time to O(1).",
          "2D Matrix Grid: Formatted as rows and columns (`arr[r][c]`), mapped to 1D memory as `r * C + c` in Row-Major order.",
          "3D Tensor Volume: Extends matrices into depth layers (`arr[d][r][c]`), mapped to 1D memory as `d * R * C + r * C + c`.",
          "Cache Locality Advantage: Contiguous memory storage enables CPU spatial cache locality, making array iterations extremely fast."
        ],
        keyConceptsBn: [
          "O(1) সরাসরি অ্যাক্সেস: `arr[i]` বেস এড্রেস + (ইন্ডেক্স × সাইজ) সূত্র ব্যবহার করে O(1) কনস্ট্যান্ট টাইমে মান বের করে।",
          "ডাইনামিক অ্যারে রিসাইজিং: ক্যাপাসিটি ফুল হলে মেমোরি দ্বিগুণ (2x) বাড়িয়ে রিঅ্যালোকেশন ঘটে, যা গড় ইনসার্শন টাইম O(1) করে।",
          "২D ম্যাট্রিক্স গ্রিড: সারি (Rows) ও কলাম (Cols) দ্বারা গঠিত (`arr[r][c]`), মেমোরিতে Row-Major নিয়মে `r * C + c` এ সংরক্ষিত থাকে।",
          "৩D টেনসর ভলিউম: ডেপথ লেয়ার নিয়ে গঠিত ৩D ব্লক (`arr[d][r][c]`), মেমোরিতে `d * R * C + r * C + c` সূত্রের সাহায্যে থাকে।",
          "ক্যাশ লোকালিটি সুবিধা: পরপর মেমোরি সাজানো থাকায় CPU Spatial Cache Locality এর কারণে অ্যারে লুপ অত্যন্ত দ্রুত কাজ করে।"
        ],
        multiDimCodeTemplates: {
          "1D Dynamic Array": {
            "C++": """
#include <iostream>
#include <vector>
using namespace std;

int main() {
    // 1D Dynamic Array (std::vector)
    vector<int> arr = {10, 20, 30, 40};
    
    // O(1) Access & Update
    arr[0] = 15;
    
    // Amortized O(1) Push Back
    arr.push_back(50);
    
    // Iterate elements O(N)
    for (int num : arr) {
        cout << num << " ";
    }
    return 0;
}""",
            "Java": """
import java.util.ArrayList;

public class Array1DDemo {
    public static void main(String[] args) {
        // 1D Dynamic Array (ArrayList)
        ArrayList<Integer> list = new ArrayList<>();
        list.add(10);
        list.add(20);
        list.add(30);
        
        // O(1) Access & Update
        list.set(0, 15);
        System.out.println("First Element: " + list.get(0));
        
        // Iterate elements O(N)
        for (int num : list) {
            System.out.print(num + " ");
        }
    }
}""",
            "Python": """
# 1D Dynamic Array (Python list)
arr = [10, 20, 30, 40]

# O(1) Access & Update
arr[0] = 15

# Amortized O(1) Append
arr.append(50)

# Iterate elements O(N)
for num in arr:
    print(num, end=" ")""",
            "JavaScript": """
// 1D Dynamic Array (JS Array)
const arr = [10, 20, 30, 40];

// O(1) Access & Update
arr[0] = 15;

// Amortized O(1) Push
arr.push(50);

// Iterate elements O(N)
arr.forEach(num => console.log(num));"""
          },
          "2D Matrix Grid": {
            "C++": """
#include <iostream>
#include <vector>
using namespace std;

int main() {
    // 2D Matrix (3 rows x 3 cols)
    vector<vector<int>> matrix = {
        {1, 2, 3},
        {4, 5, 6},
        {7, 8, 9}
    };
    
    // O(1) Element Access: matrix[row][col]
    cout << "Center element: " << matrix[1][1] << endl; // 5
    
    // Traversing 2D Matrix O(R x C)
    for (int r = 0; r < matrix.size(); r++) {
        for (int c = 0; c < matrix[0].size(); c++) {
            cout << matrix[r][c] << " ";
        }
        cout << endl;
    }
    return 0;
}""",
            "Java": """
public class Matrix2DDemo {
    public static void main(String[] args) {
        int[][] matrix = {
            {1, 2, 3},
            {4, 5, 6},
            {7, 8, 9}
        };
        
        System.out.println("Center element: " + matrix[1][1]);
        
        for (int r = 0; r < matrix.length; r++) {
            for (int c = 0; c < matrix[0].length; c++) {
                System.out.print(matrix[r][c] + " ");
            }
            System.out.println();
        }
    }
}""",
            "Python": """
matrix = [
    [1, 2, 3],
    [4, 5, 6],
    [7, 8, 9]
]

print("Center element:", matrix[1][1])

for row in matrix:
    for val in row:
        print(val, end=" ")
    print()""",
            "JavaScript": """
const matrix = [
    [1, 2, 3],
    [4, 5, 6],
    [7, 8, 9]
];

console.log("Center element:", matrix[1][1]);

for (let r = 0; r < matrix.length; r++) {
    let rowStr = "";
    for (let c = 0; c < matrix[0].length; c++) {
        rowStr += matrix[r][c] + " ";
    }
    console.log(rowStr);
}"""
          },
          "3D Tensor Volume": {
            "C++": """
#include <iostream>
#include <vector>
using namespace std;

int main() {
    // 3D Tensor: 2 depth layers x 2 rows x 2 cols
    vector<vector<vector<int>>> tensor = {
        { {1, 2}, {3, 4} },
        { {5, 6}, {7, 8} }
    };
    
    // O(1) Tensor element access: tensor[depth][row][col]
    cout << "Layer 1, Row 1, Col 1: " << tensor[1][1][1] << endl; // 8
    
    // Traversing 3D Tensor O(D x R x C)
    for (int d = 0; d < tensor.size(); d++) {
        for (int r = 0; r < tensor[0].size(); r++) {
            for (int c = 0; c < tensor[0][0].size(); c++) {
                cout << tensor[d][r][c] << " ";
            }
        }
    }
    return 0;
}""",
            "Java": """
public class Tensor3DDemo {
    public static void main(String[] args) {
        int[][][] tensor = {
            { {1, 2}, {3, 4} },
            { {5, 6}, {7, 8} }
        };
        
        System.out.println("Layer 1, Row 1, Col 1: " + tensor[1][1][1]);
    }
}""",
            "Python": """
tensor = [
    [[1, 2], [3, 4]],
    [[5, 6], [7, 8]]
]

print("Layer 1, Row 1, Col 1:", tensor[1][1][1])""",
            "JavaScript": """
const tensor = [
    [[1, 2], [3, 4]],
    [[5, 6], [7, 8]]
];

console.log("Layer 1, Row 1, Col 1:", tensor[1][1][1]);"""
          }
        },
        basicProblems: [
          DsaProblem(
            id: "arr-1",
            title: "1. Find Minimum & Maximum in 1D Array",
            category: "1D Array Basic",
            keyIdeaEn: "Initialize `minVal` and `maxVal` with `arr[0]`. Scan array from index 1 to N-1 and update bounds in O(N) time.",
            keyIdeaBn: "`arr[0]` দিয়ে `minVal` এবং `maxVal` শুরু করুন। ইন্ডেক্স ১ থেকে N-1 পর্যন্ত লুপ চালিয়ে O(N) সময়ে সর্বনিম্ন ও সর্বোচ্চ মান আপডেট করুন।",
            codeCpp: """
pair<int, int> findMinMax(vector<int>& arr) {
    int minVal = arr[0], maxVal = arr[0];
    for (int i = 1; i < arr.size(); i++) {
        if (arr[i] < minVal) minVal = arr[i];
        if (arr[i] > maxVal) maxVal = arr[i];
    }
    return {minVal, maxVal};
}""",
            codeJava: """
public static int[] findMinMax(int[] arr) {
    int minVal = arr[0], maxVal = arr[0];
    for (int i = 1; i < arr.length; i++) {
        if (arr[i] < minVal) minVal = arr[i];
        if (arr[i] > maxVal) maxVal = arr[i];
    }
    return new int[]{minVal, maxVal};
}""",
            codePython: """
def findMinMax(arr):
    min_val, max_val = arr[0], arr[0]
    for num in arr[1:]:
        if num < min_val: min_val = num
        if num > max_val: max_val = num
    return (min_val, max_val)""",
            codeJs: """
function findMinMax(arr) {
    let minVal = arr[0], maxVal = arr[0];
    for (let i = 1; i < arr.length; i++) {
        if (arr[i] < minVal) minVal = arr[i];
        if (arr[i] > maxVal) maxVal = arr[i];
    }
    return [minVal, maxVal];
}""",
            descriptionEn: "Find the smallest (minimum) and largest (maximum) numbers in an unsorted 1D array.",
            descriptionBn: "একটি আনসর্টেড ১D অ্যারে থেকে সবচেয়ে ছোট (Minimum) এবং সবচেয়ে বড় (Maximum) সংখ্যা দুটি বের করুন।",
            sampleInputs: ["arr = [15, 42, 8, 99, 23]"],
            sampleOutputs: ["Min: 8, Max: 99"],
          ),
          DsaProblem(
            id: "arr-2",
            title: "2. In-Place Array Reversal (Two Pointers)",
            category: "Two Pointer Pattern",
            keyIdeaEn: "Set `left = 0` and `right = N-1`. Swap `arr[left]` and `arr[right]`, then move `left++` and `right--` until pointers meet in O(N) time.",
            keyIdeaBn: "`left = 0` এবং `right = N-1` সেট করুন। `arr[left]` এবং `arr[right]` অদলবদল (Swap) করে `left++` ও `right--` করতে থাকুন।",
            codeCpp: """
void reverseArray(vector<int>& arr) {
    int left = 0, right = arr.size() - 1;
    while (left < right) {
        swap(arr[left], arr[right]);
        left++;
        right--;
    }
}""",
            codeJava: """
public static void reverseArray(int[] arr) {
    int left = 0, right = arr.length - 1;
    while (left < right) {
        int temp = arr[left];
        arr[left] = arr[right];
        arr[right] = temp;
        left++; right--;
    }
}""",
            codePython: """
def reverseArray(arr):
    left, right = 0, len(arr) - 1
    while left < right:
        arr[left], arr[right] = arr[right], arr[left]
        left += 1
        right -= 1""",
            codeJs: """
function reverseArray(arr) {
    let left = 0, right = arr.length - 1;
    while (left < right) {
        let temp = arr[left];
        arr[left] = arr[right];
        arr[right] = temp;
        left++; right--;
    }
}""",
            descriptionEn: "Reverse an array in-place without using extra memory array space.",
            descriptionBn: "কোনো অতিরিক্ত ইন-মেমোরি অ্যারে ব্যবহার না করেই মূল অ্যারের উপাদানগুলো উল্টে (Reverse) দিন।",
            sampleInputs: ["arr = [1, 2, 3, 4, 5]"],
            sampleOutputs: ["arr = [5, 4, 3, 2, 1]"],
          ),
          DsaProblem(
            id: "arr-3",
            title: "3. 2D Matrix Transpose (Swap Rows and Columns)",
            category: "2D Matrix Pattern",
            keyIdeaEn: "Swap elements across the main diagonal: `result[c][r] = matrix[r][c]` for an R × C matrix.",
            keyIdeaBn: "ম্যাট্রিক্সের সারি এবং কলাম অদলবদল করুন: `result[c][r] = matrix[r][c]`।",
            codeCpp: """
vector<vector<int>> transposeMatrix(vector<vector<int>>& matrix) {
    int R = matrix.size(), C = matrix[0].size();
    vector<vector<int>> res(C, vector<int>(R));
    for (int r = 0; r < R; r++) {
        for (int c = 0; c < C; c++) {
            res[c][r] = matrix[r][c];
        }
    }
    return res;
}""",
            codeJava: """
public static int[][] transposeMatrix(int[][] matrix) {
    int R = matrix.length, C = matrix[0].length;
    int[][] res = new int[C][R];
    for (int r = 0; r < R; r++) {
        for (int c = 0; c < C; c++) {
            res[c][r] = matrix[r][c];
        }
    }
    return res;
}""",
            codePython: """
def transposeMatrix(matrix):
    R, C = len(matrix), len(matrix[0])
    res = [[0] * R for _ in range(C)]
    for r in range(R):
        for c in range(C):
            res[c][r] = matrix[r][c]
    return res""",
            codeJs: """
function transposeMatrix(matrix) {
    const R = matrix.length, C = matrix[0].length;
    const res = Array.from({length: C}, () => new Array(R).fill(0));
    for (let r = 0; r < R; r++) {
        for (let c = 0; c < C; c++) {
            res[c][r] = matrix[r][c];
        }
    }
    return res;
}""",
            descriptionEn: "Transpose an R x C matrix into a C x R matrix by swapping rows with columns.",
            descriptionBn: "একটি R x C ম্যাট্রিক্সের সারিকে কলাম এবং কলামকে সারিতে রূপান্তর (Transpose) করে C x R ম্যাট্রিক্সে প্রকাশ করুন।",
            sampleInputs: ["matrix = [[1,2,3],[4,5,6]]"],
            sampleOutputs: ["result = [[1,4],[2,5],[3,6]]"],
          ),
          DsaProblem(
            id: "arr-4",
            title: "4. 3D Tensor Layer Depth Sum",
            category: "3D Tensor Basic",
            keyIdeaEn: "Iterate through 3D Tensor volume using 3 nested loops (depth d, row r, col c) and accumulate sum in O(D × R × C) time.",
            keyIdeaBn: "৩টি নেস্টেড লুপ (ডেপথ d, রো r, কলাম c) ব্যবহার করে ৩D টেনসরের সব উপাদানের মোট সমষ্টি যোগ করুন।",
            codeCpp: """
int tensorSum(vector<vector<vector<int>>>& tensor) {
    int total = 0;
    for (int d = 0; d < tensor.size(); d++) {
        for (int r = 0; r < tensor[0].size(); r++) {
            for (int c = 0; c < tensor[0][0].size(); c++) {
                total += tensor[d][r][c];
            }
        }
    }
    return total;
}""",
            codeJava: """
public static int tensorSum(int[][][] tensor) {
    int total = 0;
    for (int d = 0; d < tensor.length; d++) {
        for (int r = 0; r < tensor[0].length; r++) {
            for (int c = 0; c < tensor[0][0].length; c++) {
                total += tensor[d][r][c];
            }
        }
    }
    return total;
}""",
            codePython: """
def tensorSum(tensor):
    total = 0
    for layer in tensor:
        for row in layer:
            for val in row:
                total += val
    return total""",
            codeJs: """
function tensorSum(tensor) {
    let total = 0;
    for (let d = 0; d < tensor.length; d++) {
        for (let r = 0; r < tensor[0].length; r++) {
            for (let c = 0; c < tensor[0][0].length; c++) {
                total += tensor[d][r][c];
            }
        }
    }
    return total;
}""",
            descriptionEn: "Calculate the sum of all numerical values stored inside a 3D Tensor volume.",
            descriptionBn: "একটি ৩D টেনসর ভলিউমের ভেতরে থাকা সমস্ত পূর্ণসংখ্যার সমষ্টি (Total Sum) হিসাব করুন।",
            sampleInputs: ["tensor = [[[1,2],[3,4]], [[5,6],[7,8]]]"],
            sampleOutputs: ["Total Sum: 36"],
          ),
        ],
        commonMistakesEn: [
          {
            "title": "1. Array Index Out of Bounds Exception",
            "desc": "Accessing `arr[N]` instead of `arr[N-1]` in zero-indexed arrays triggers ArrayIndexOutOfBoundsException or Segmentation Fault."
          },
          {
            "title": "2. Off-by-One Loop Boundary Bug",
            "desc": "Using `<=` instead of `<` when iterating `i = 0; i <= arr.length` causes index overflow past array end."
          },
          {
            "title": "3. Inefficient Element Insertion / Deletion at Front",
            "desc": "Calling `list.remove(0)` or `arr.unshift()` inside a loop causes hidden O(N) element shifting, leading to O(N²) overall time complexity."
          },
          {
            "title": "4. Fixed-Size Array Overflow",
            "desc": "Attempting to insert elements beyond pre-allocated fixed array capacity without dynamic resizing."
          }
        ],
        commonMistakesBn: [
          {
            "title": "১. অ্যারে ইনডেক্স আউট অফ বাউন্ডস ভুল",
            "desc": "০-ভিত্তিক অ্যারেতে N টি উপাদানের শেষ ইনডেক্স N-1। `arr[N]` এক্সেস করতে গেলে Segmentation Fault বা Exception ঘটে।"
          },
          {
            "title": "২. লুপের সীমানায় Off-by-One ভুল",
            "desc": "লুপ চালানোর সময় `i < arr.length` এর জায়গায় `i <= arr.length` লিখলে শেষ ধাপে বাউন্ডের বাইরে চলে যায়।"
          },
          {
            "title": "৩. লিস্টের শুরুতে ইনসার্ট বা ডিলেশনে O(N²) সময় নষ্ট",
            "desc": "লুপের ভেতর `list.remove(0)` বা `shift()` কল করলে প্রতিটি উপাদান বামে সরানোর কারণে O(N²) সময় নষ্ট হয়।"
          },
          {
            "title": "৪. ফিক্সড-সাইজ অ্যারে ওভারফ্লো",
            "desc": "নির্দিষ্ট সাইজের অ্যারে ডাইনামিক না বাড়িয়ে অতিরিক্ত উপাদান যোগ করতে গিয়ে মেমোরি ওভারফ্লো ঘটানো।"
          }
        ],
        roadmapStepsEn: [
          {
            "step": "Step 1",
            "title": "Understand Contiguous Memory & 0-Based Index Math",
            "desc": "Master direct memory addressing `base_addr + index * element_bytes` and O(1) element access."
          },
          {
            "step": "Step 2",
            "title": "Master 1D Array Traversals & Two Pointer Reversal",
            "desc": "Learn linear scanning, Min/Max searching, and in-place array reversal using Two Pointers."
          },
          {
            "step": "Step 3",
            "title": "Understand Dynamic Array Resizing (Amortized Analysis)",
            "desc": "Learn dynamic array capacity doubling (vector/ArrayList) and amortized O(1) push operations."
          },
          {
            "step": "Step 4",
            "title": "Master 2D Matrix Grid Traversals & Transpose",
            "desc": "Master row-major vs column-major order, 2D matrix iteration, and grid transpose algorithms."
          },
          {
            "step": "Step 5",
            "title": "Master 3D Tensors & Multi-Dimensional Array Flattening",
            "desc": "Master 3D Tensor volume iteration and flattening multi-dimensional indices into 1D memory offset."
          }
        ],
        roadmapStepsBn: [
          {
            "step": "ধাপ ১",
            "title": "পরপর মেমোরি সাজানো ও ০-ভিত্তিক ইনডেক্সিং",
            "desc": "ডিরেক্ট মেমোরি এড্রেসিং `base_addr + index * element_bytes` এবং O(1) মান বের করার সুত্র শিখুন।"
          },
          {
            "step": "ধাপ ২",
            "title": "১D অ্যারে ট্রাভার্সাল ও টু-পয়েন্টার রিভার্সাল",
            "desc": "লিনিয়ার সার্চিং, Min/Max বের করা এবং টু-পয়েন্টার দিয়ে মেমোরি অপচয় না করে অ্যারে রিভার্স করা।"
          },
          {
            "step": "ধাপ ৩",
            "title": "ডাইনামিক অ্যারে মেমোরি রিসাইজিং (2x Capacity)",
            "desc": "ডাইনামিক অ্যারের ক্যাপাসিটি ডাবল হওয়া (Vector/ArrayList) এবং Amortized O(1) ইনসার্শন শেখা।"
          },
          {
            "step": "ধাপ ৪",
            "title": "২D ম্যাট্রিক্স ট্রাভার্সাল ও ট্রান্সপোজ",
            "desc": "Row-Major ট্রাভার্সাল, ২D গ্রিড সলভিং এবং সারি-কলাম অদলবদল (Transpose) অ্যালগরিদম মাস্টার করুন।"
          },
          {
            "step": "ধাপ ৫",
            "title": "৩D টেনসর ভলিউম ও মাল্টি-ডাইমেনশনাল ফ্ল্যাটেনিং",
            "desc": "৩D টেনসর লুপ এবং ৩D ইনডেক্সকে ১D মেমোরি অফসেটে রূপান্তর সূত্র সলভ করা।"
          }
        ],
      ),

      // 2. SINGLY & DOUBLY LINKED LIST
      DsaTopic(
        id: 202,
        title: "Singly & Doubly Linked List",
        category: "Dynamic Pointer Structure",
        timeComplexity: "Head Insert/Delete: O(1) | Search: O(N)",
        spaceComplexity: "O(N)",
        icon: Icons.link_outlined,
        themeColor: const Color(0xFF8B5CF6),
        descriptionEn: "A Linked List is a linear data structure of heap-allocated Node objects connected via pointers.",
        descriptionBn: "লিঙ্কড লিস্ট হলো হিপ মেমোরিতে পয়েন্টার দ্বারা সংযুক্ত নোড অবজেক্টের লিনিয়ার সিকোয়েন্স।",
        keyConceptsEn: ["Singly Linked List", "Doubly Linked List", "Circular Linked List"],
        keyConceptsBn: ["Singly Linked List", "Doubly Linked List", "Circular Linked List"],
        multiDimCodeTemplates: {
          "Singly Linked List": {
            "C++": "struct Node { int val; Node* next; };",
            "Java": "class Node { int val; Node next; }",
            "Python": "class Node: pass",
            "JavaScript": "class Node {}"
          }
        },
        basicProblems: [],
        commonMistakesEn: [],
        commonMistakesBn: [],
        roadmapStepsEn: [],
        roadmapStepsBn: [],
      ),

      // 3. STACK (LIFO)
      DsaTopic(
        id: 203,
        title: "Stack (LIFO)",
        category: "Linear Container Structure",
        timeComplexity: "Push O(1) | Pop O(1) | Top/Peek O(1)",
        spaceComplexity: "O(N)",
        icon: Icons.layers_outlined,
        themeColor: const Color(0xFF10B981),
        descriptionEn: "A Stack is a linear data structure operating under the strict Last-In, First-Out (LIFO) discipline.",
        descriptionBn: "স্ট্যাক হলো একটি লিনিয়ার কন্টেইনার যা লাস্ট-ইন, ফার্স্ট-আউট (LIFO) নীতিতে কাজ করে।",
        keyConceptsEn: ["LIFO Discipline", "O(1) Push/Pop"],
        keyConceptsBn: ["LIFO নীতি", "O(1) পুশ/পপ"],
        multiDimCodeTemplates: {
          "Array-Based Stack": {
            "C++": "vector<int> st; st.push_back(10); st.pop_back();",
            "Java": "Deque<Integer> st = new ArrayDeque<>();",
            "Python": "st = []; st.append(10); st.pop()",
            "JavaScript": "const st = []; st.push(10); st.pop()"
          }
        },
        basicProblems: [],
        commonMistakesEn: [],
        commonMistakesBn: [],
        roadmapStepsEn: [],
        roadmapStepsBn: [],
      ),

      // 4. QUEUE (FIFO) & DEQUE
      DsaTopic(
        id: 204,
        title: "Queue (FIFO) & Deque",
        category: "Linear Pipeline Structure",
        timeComplexity: "Enqueue O(1) | Dequeue O(1) | Front O(1)",
        spaceComplexity: "O(N)",
        icon: Icons.swap_horizontal_circle_outlined,
        themeColor: const Color(0xFFF59E0B),
        descriptionEn: "A Queue is a linear pipeline operating under the strict First-In, First-Out (FIFO) discipline.",
        descriptionBn: "কিউ হলো একটি ফার্স্ট-ইন, ফার্স্ট-আউট (FIFO) লিনিয়ার পাইপলাইন।",
        keyConceptsEn: ["FIFO Discipline", "Circular Queue", "Deque"],
        keyConceptsBn: ["FIFO নীতি", "সার্কুলার কিউ", "Deque"],
        multiDimCodeTemplates: {
          "Queue (FIFO)": {
            "C++": "queue<int> q; q.push(10); q.pop();",
            "Java": "Queue<Integer> q = new ArrayDeque<>();",
            "Python": "q = deque(); q.append(10); q.popleft()",
            "JavaScript": "const q = []; q.push(10); q.shift()"
          }
        },
        basicProblems: [],
        commonMistakesEn: [],
        commonMistakesBn: [],
        roadmapStepsEn: [],
        roadmapStepsBn: [],
      ),

      // 5. HASH TABLE & HASH MAP
      DsaTopic(
        id: 205,
        title: "Hash Table & Hash Map",
        category: "Associative Dictionary",
        timeComplexity: "Lookup O(1) avg | Insert O(1) avg | Delete O(1) avg",
        spaceComplexity: "O(N)",
        icon: Icons.grid_view_outlined,
        themeColor: const Color(0xFFEC4899),
        descriptionEn: "A Hash Table is an associative dictionary mapping keys to array indices using a Hash Function.",
        descriptionBn: "হ্যাশ টেবিল হলো একটি কী-ভ্যালু ডিকশনারি যা হ্যাশ ফাংশন দিয়ে ইনডেক্সিং করে।",
        keyConceptsEn: ["O(1) Average Lookup", "Collision Handling"],
        keyConceptsBn: ["O(1) গড়ে সমাধান", "কলিশন হ্যান্ডলিং"],
        multiDimCodeTemplates: {
          "Hash Map (Key-Value)": {
            "C++": "unordered_map<string, int> mp;",
            "Java": "Map<String, Integer> map = new HashMap<>();",
            "Python": "mp = {}",
            "JavaScript": "const map = new Map();"
          }
        },
        basicProblems: [],
        commonMistakesEn: [],
        commonMistakesBn: [],
        roadmapStepsEn: [],
        roadmapStepsBn: [],
      ),

      // 6. BINARY SEARCH TREE (BST)
      DsaTopic(
        id: 206,
        title: "Binary Search Tree (BST)",
        category: "Hierarchical Tree Structure",
        timeComplexity: "Search O(log N) avg | Insert O(log N) avg | Delete O(log N) avg",
        spaceComplexity: "O(N)",
        icon: Icons.account_tree_outlined,
        themeColor: const Color(0xFF06B6D4),
        descriptionEn: "A BST is a node-based binary tree maintaining the invariant Left Subtree < Root < Right Subtree.",
        descriptionBn: "বাইনারি সার্চ ট্রি হলো নোড-ভিত্তিক গাছ যা বাম সাবট্রি < রুট < ডান সাবট্রি নিয়ম মানে।",
        keyConceptsEn: ["BST Invariant", "Inorder Sorted Traversal"],
        keyConceptsBn: ["BST নিয়ম", "Inorder সর্টেড ট্রাভার্সাল"],
        multiDimCodeTemplates: {
          "Standard BST": {
            "C++": "struct TreeNode { int val; TreeNode *left, *right; };",
            "Java": "class TreeNode { int val; TreeNode left, right; }",
            "Python": "class TreeNode: pass",
            "JavaScript": "class TreeNode {}"
          }
        },
        basicProblems: [],
        commonMistakesEn: [],
        commonMistakesBn: [],
        roadmapStepsEn: [],
        roadmapStepsBn: [],
      ),

      // 7. MIN & MAX HEAP
      DsaTopic(
        id: 207,
        title: "Min & Max Heap (Priority Queue)",
        category: "Priority Tree & Array Structure",
        timeComplexity: "Peek O(1) | Push O(log N) | Extract Top O(log N)",
        spaceComplexity: "O(N)",
        icon: Icons.unfold_more_double_outlined,
        themeColor: const Color(0xFF84CC16),
        descriptionEn: "A Binary Heap is a complete binary tree mapped onto a 1D array.",
        descriptionBn: "বাইনারি হিপ হলো ১D অ্যারেতে সাজানো কমপ্লিট বাইনারি ট্রি।",
        keyConceptsEn: ["Heap Invariant", "Bubble Up & Down"],
        keyConceptsBn: ["হিপ ইনভেরিয়েন্ট", "বাবল আপ ও বাবল ডাউন"],
        multiDimCodeTemplates: {
          "Min Heap": {
            "C++": "priority_queue<int, vector<int>, greater<int>> minHeap;",
            "Java": "PriorityQueue<Integer> pq = new PriorityQueue<>();",
            "Python": "import heapq",
            "JavaScript": "class MinHeap {}"
          }
        },
        basicProblems: [],
        commonMistakesEn: [],
        commonMistakesBn: [],
        roadmapStepsEn: [],
        roadmapStepsBn: [],
      ),

      // 8. GRAPH
      DsaTopic(
        id: 208,
        title: "Graph (Adjacency List & Matrix)",
        category: "Non-Linear Network Structure",
        timeComplexity: "BFS O(V + E) | DFS O(V + E)",
        spaceComplexity: "Adj List: O(V + E) | Matrix: O(V²)",
        icon: Icons.hub_outlined,
        themeColor: const Color(0xFF0284C7),
        descriptionEn: "A Graph is a non-linear network of Vertices and Edges.",
        descriptionBn: "গ্রাফ হলো নোড ও এজের নন-লিনিয়ার নেটওয়ার্ক।",
        keyConceptsEn: ["Adj List & Matrix", "BFS & DFS"],
        keyConceptsBn: ["অ্যাডজাসেন্সি লিস্ট ও ম্যাট্রিক্স", "BFS ও DFS"],
        multiDimCodeTemplates: {
          "Graph": {
            "C++": "vector<vector<int>> adj;",
            "Java": "List<List<Integer>> adj = new ArrayList<>();",
            "Python": "adj = collections.defaultdict(list)",
            "JavaScript": "const adj = {};"
          }
        },
        basicProblems: [],
        commonMistakesEn: [],
        commonMistakesBn: [],
        roadmapStepsEn: [],
        roadmapStepsBn: [],
      ),

      // 9. TRIE
      DsaTopic(
        id: 209,
        title: "Trie (Prefix Tree)",
        category: "Advanced Character Tree",
        timeComplexity: "Insert O(L) | Search O(L) | StartsWith O(L)",
        spaceComplexity: "O(N × L)",
        icon: Icons.sort_by_alpha_outlined,
        themeColor: const Color(0xFFA855F7),
        descriptionEn: "A Trie is an N-ary tree data structure used for fast string prefix searching.",
        descriptionBn: "ট্রাই হলো একটি ক্যারেক্টার ট্রি যা দ্রুত প্রিফিক্স সার্চ করতে ব্যবহৃত হয়।",
        keyConceptsEn: ["O(L) Fast Lookup", "Prefix Sharing"],
        keyConceptsBn: ["O(L) দ্রুত লুকআপ", "প্রিফিক্স শেয়ারিং"],
        multiDimCodeTemplates: {
          "Standard Trie": {
            "C++": "class TrieNode { unordered_map<char, TrieNode*> children; };",
            "Java": "class TrieNode { TrieNode[] children = new TrieNode[26]; }",
            "Python": "class TrieNode: pass",
            "JavaScript": "class TrieNode {}"
          }
        },
        basicProblems: [],
        commonMistakesEn: [],
        commonMistakesBn: [],
        roadmapStepsEn: [],
        roadmapStepsBn: [],
      ),
    ];
  }
}
