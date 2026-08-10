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
        timeComplexity: "Head Insert/Delete: O(1) | Search: O(N) | Access: O(N)",
        spaceComplexity: "O(N)",
        icon: Icons.link_outlined,
        themeColor: const Color(0xFF8B5CF6),
        descriptionEn:
            "A Linked List is a dynamic linear data structure composed of node objects allocated non-contiguously in heap memory. Each node stores a data value (`val`) and pointer references (`next` in Singly Linked Lists; `prev` and `next` in Doubly Linked Lists). Unlike arrays, inserting or deleting nodes at the head occurs in instant O(1) constant time without shifting memory elements.",
        descriptionBn:
            "লিঙ্কড লিস্ট (Linked List) হলো হিপ মেমোরিতে পয়েন্টার দিয়ে একে অপরের সাথে সংযুক্ত ডাইনামিক নোড অবজেক্টের সিকোয়েন্স। প্রতিটি নোডে একটি ডেটা ভ্যালু (`val`) এবং পয়েন্টার রেফারেন্স (Singly এ `next`, Doubly এ `prev` ও `next`) থাকে। অ্যারের মতো মেমোরিতে পরপর না থাকলেও লিঙ্কড লিস্টের শুরুতে (Head) উপাদান ইনসার্ট বা ডিলেট করার কাজ O(1) কনস্ট্যান্ট টাইমে সম্পন্ন করা যায়।",
        keyConceptsEn: [
          "Singly Linked List: Unidirectional node chain linked via `curr->next` pointer.",
          "Doubly Linked List: Bidirectional node chain linked via both `curr->prev` and `curr->next` pointers.",
          "O(1) Head Insertion: Attaching a new node before the current head requires updating only 2 pointer links.",
          "Fast & Slow Pointers (Floyd's Algorithm): Moving slow pointer 1 step and fast pointer 2 steps solves middle node and cycle detection in O(N) time."
        ],
        keyConceptsBn: [
          "Singly Linked List: একমুখী নোড চেইন যা শুধুমাত্র `curr->next` পয়েন্টার দিয়ে সংযুক্ত।",
          "Doubly Linked List: দ্বিমুখী নোড চেইন যা `curr->prev` এবং `curr->next` পয়েন্টার দ্বারা সংযুক্ত।",
          "O(1) হেড ইনসার্শন: হেডের সামনে নতুন নোড যুক্ত করতে কোনো উপাদান সরাতে হয় না, কেবল ২টি পয়েন্টার লিংক আপডেট করতে হয়।",
          "ফাস্ট ও স্লো পয়েন্টার (Floyd's Algorithm): স্লো পয়েন্টার ১ ধাপ ও ফাস্ট পয়েন্টার ২ ধাপ চালিয়ে মিডল নোড ও সাইকেল মেমোরিতে নির্ণয় করা।"
        ],
        multiDimCodeTemplates: {
          "Singly Linked List Node": {
            "C++": """
struct ListNode {
    int val;
    ListNode* next;
    ListNode(int x) : val(x), next(nullptr) {}
};""",
            "Java": """
class ListNode {
    int val;
    ListNode next;
    ListNode(int val) { this.val = val; }
}""",
            "Python": """
class ListNode:
    def __init__(self, val=0, next=None):
        self.val = val
        self.next = next""",
            "JavaScript": """
class ListNode {
    constructor(val = 0, next = null) {
        this.val = val;
        this.next = next;
    }
}"""
          },
          "Doubly Linked List Node": {
            "C++": """
struct Node {
    int val;
    Node* prev;
    Node* next;
    Node(int x) : val(x), prev(nullptr), next(nullptr) {}
};""",
            "Java": """
class Node {
    int val;
    Node prev;
    Node next;
    Node(int val) { this.val = val; }
}""",
            "Python": """
class Node:
    def __init__(self, val=0, prev=None, next=None):
        self.val = val
        self.prev = prev
        self.next = next""",
            "JavaScript": """
class Node {
    constructor(val = 0, prev = null, next = null) {
        this.val = val;
        this.prev = prev;
        this.next = next;
    }
}"""
          }
        },
        basicProblems: [
          DsaProblem(
            id: "ll-1",
            title: "1. Reverse Singly Linked List (Iterative)",
            category: "Singly Linked List Basic",
            keyIdeaEn: "Maintain `prev = NULL`, `curr = head`. Flip `curr->next = prev`, advance `prev = curr` and `curr = next` until `curr == NULL` in O(N) time.",
            keyIdeaBn: "`prev = NULL` ও `curr = head` ধরে লুপের প্রতিটি নোডের `curr->next = prev` উল্টে দিয়ে `prev` কে হেড বানান।",
            codeCpp: """
ListNode* reverseList(ListNode* head) {
    ListNode *prev = nullptr, *curr = head;
    while (curr != nullptr) {
        ListNode* nextTemp = curr->next;
        curr->next = prev;
        prev = curr;
        curr = nextTemp;
    }
    return prev;
}""",
            codeJava: """
public ListNode reverseList(ListNode head) {
    ListNode prev = null, curr = head;
    while (curr != null) {
        ListNode nextTemp = curr.next;
        curr.next = prev;
        prev = curr;
        curr = nextTemp;
    }
    return prev;
}""",
            codePython: """
def reverseList(head):
    prev, curr = None, head
    while curr:
        next_temp = curr.next
        curr.next = prev
        prev = curr
        curr = next_temp
    return prev""",
            codeJs: """
function reverseList(head) {
    let prev = null, curr = head;
    while (curr !== null) {
        let nextTemp = curr.next;
        curr.next = prev;
        prev = curr;
        curr = nextTemp;
    }
    return prev;
}""",
            descriptionEn: "Reverse a Singly Linked List in-place by re-pointing next references backward.",
            descriptionBn: "একটি Singly Linked List এর প্রতিটি পয়েন্টার রিভার্স করে লিঙ্কড লিস্টটি উল্টে দিন।",
            sampleInputs: ["head = [1 -> 2 -> 3 -> 4 -> 5]"],
            sampleOutputs: ["head = [5 -> 4 -> 3 -> 2 -> 1]"],
          ),
          DsaProblem(
            id: "ll-2",
            title: "2. Find Middle Node (Fast & Slow Pointers)",
            category: "Fast & Slow Pointer Pattern",
            keyIdeaEn: "Move `slow` 1 step and `fast` 2 steps. When `fast == NULL` or `fast->next == NULL`, `slow` points directly to the middle node.",
            keyIdeaBn: "`slow` ১ ধাপ এবং `fast` ২ ধাপ সরান। `fast` শেষ নোডে পৌঁছালে `slow` নোডটিই মিডল নোড হবে।",
            codeCpp: """
ListNode* middleNode(ListNode* head) {
    ListNode *slow = head, *fast = head;
    while (fast != nullptr && fast->next != nullptr) {
        slow = slow->next;
        fast = fast->next->next;
    }
    return slow;
}""",
            codeJava: """
public ListNode middleNode(ListNode head) {
    ListNode slow = head, fast = head;
    while (fast != null && fast.next != null) {
        slow = slow.next;
        fast = fast.next.next;
    }
    return slow;
}""",
            codePython: """
def middleNode(head):
    slow = fast = head
    while fast and fast.next:
        slow = slow.next
        fast = fast.next.next
    return slow""",
            codeJs: """
function middleNode(head) {
    let slow = head, fast = head;
    while (fast !== null && fast.next !== null) {
        slow = slow.next;
        fast = fast.next.next;
    }
    return slow;
}""",
            descriptionEn: "Find the middle node of a Singly Linked List in a single O(N) pass.",
            descriptionBn: "মাত্র একটি O(N) ট্রাভার্সালে লিঙ্কড লিস্টের মাঝের নোডটি (Middle Node) নির্ণয় করুন।",
            sampleInputs: ["head = [1 -> 2 -> 3 -> 4 -> 5]"],
            sampleOutputs: ["Middle Node Val: 3"],
          ),
          DsaProblem(
            id: "ll-3",
            title: "3. Doubly Linked List In-Place Reversal",
            category: "Doubly Linked List Basic",
            keyIdeaEn: "Traverse nodes and swap `curr->next` and `curr->prev` pointers for each node using a temporary pointer.",
            keyIdeaBn: "প্রতিটি নোডের `curr->next` এবং `curr->prev` পয়েন্টার অদলবদল (Swap) করে লিঙ্কড লিস্টটি উল্টান।",
            codeCpp: """
Node* reverseDLL(Node* head) {
    Node *temp = nullptr, *curr = head;
    while (curr != nullptr) {
        temp = curr->prev;
        curr->prev = curr->next;
        curr->next = temp;
        curr = curr->prev;
    }
    return temp ? temp->prev : head;
}""",
            codeJava: """
public Node reverseDLL(Node head) {
    Node temp = null, curr = head;
    while (curr != null) {
        temp = curr.prev;
        curr.prev = curr.next;
        curr.next = temp;
        curr = curr.prev;
    }
    return temp != null ? temp.prev : head;
}""",
            codePython: """
def reverseDLL(head):
    temp = None
    curr = head
    while curr:
        temp = curr.prev
        curr.prev = curr.next
        curr.next = temp
        curr = curr.prev
    return temp.prev if temp else head""",
            codeJs: """
function reverseDLL(head) {
    let temp = null, curr = head;
    while (curr !== null) {
        temp = curr.prev;
        curr.prev = curr.next;
        curr.next = temp;
        curr = curr.prev;
    }
    return temp !== null ? temp.prev : head;
}""",
            descriptionEn: "Reverse a Doubly Linked List by swapping both bidirectional pointers of every node.",
            descriptionBn: "একটি Doubly Linked List এর প্রতিটি নোডের দ্বিমুখী পয়েন্টার Swap করে অদলবদল করুন।",
            sampleInputs: ["head = [1 <-> 2 <-> 3 <-> 4]"],
            sampleOutputs: ["head = [4 <-> 3 <-> 2 <-> 1]"],
          ),
          DsaProblem(
            id: "ll-4",
            title: "4. Detect Cycle in Linked List (Floyd's Algorithm)",
            category: "Cycle Detection Pattern",
            keyIdeaEn: "Move `slow` by 1 step and `fast` by 2 steps. If a cycle exists, `slow` and `fast` pointers will meet at the same node.",
            keyIdeaBn: "`slow` ১ ধাপ এবং `fast` ২ ধাপ চালনা করুন। চক্র (Cycle) থাকলে `slow` ও `fast` পয়েন্টার একই নোডে মিলবে।",
            codeCpp: """
bool hasCycle(ListNode *head) {
    ListNode *slow = head, *fast = head;
    while (fast != nullptr && fast->next != nullptr) {
        slow = slow->next;
        fast = fast->next->next;
        if (slow == fast) return true;
    }
    return false;
}""",
            codeJava: """
public boolean hasCycle(ListNode head) {
    ListNode slow = head, fast = head;
    while (fast != null && fast.next != null) {
        slow = slow.next;
        fast = fast.next.next;
        if (slow == fast) return true;
    }
    return false;
}""",
            codePython: """
def hasCycle(head):
    slow = fast = head
    while fast and fast.next:
        slow = slow.next
        fast = fast.next.next
        if slow == fast:
            return True
    return False""",
            codeJs: """
function hasCycle(head) {
    let slow = head, fast = head;
    while (fast !== null && fast.next !== null) {
        slow = slow.next;
        fast = fast.next.next;
        if (slow === fast) return true;
    }
    return false;
}""",
            descriptionEn: "Determine if a Linked List contains a cycle where a node links back to a previous node.",
            descriptionBn: "একটি লিঙ্কড লিস্টের ভেতর কোনো চক্র (Cycle) বা লুপ বিদ্যমান কিনা তা O(1) স্পেসে নির্ণয় করুন।",
            sampleInputs: ["head = [3 -> 2 -> 0 -> -4] (pos = 1)"],
            sampleOutputs: ["Has Cycle: True"],
          ),
        ],
        commonMistakesEn: [
          {
            "title": "1. Null Pointer Dereference (NPE)",
            "desc": "Accessing `curr->next->val` without checking if `curr` or `curr->next` is nullptr triggers a runtime crash."
          },
          {
            "title": "2. Losing Head Pointer Reference",
            "desc": "Advancing `head = head->next` during traversal permanently loses reference to list start."
          },
          {
            "title": "3. Broken Prev Pointers in Doubly Linked List",
            "desc": "Updating `curr->next` but forgetting to set `curr->next->prev = curr` breaks bidirectional links."
          },
          {
            "title": "4. Memory Leak in C++",
            "desc": "Deleting a node without saving its `next` pointer causes dangling unfreeable nodes."
          }
        ],
        commonMistakesBn: [
          {
            "title": "১. নাল পয়েন্টার ডিরিফারেন্স ভুল (NullPointerException)",
            "desc": "`curr` বা `curr->next` নাল (nullptr) কিনা চেক না করে `curr->next->val` অ্যাক্সেস করতে গেলে অ্যাপ ক্র্যাশ করে।"
          },
          {
            "title": "২. হেড পয়েন্টার রেফারেন্স হারিয়ে ফেলা",
            "desc": "লিস্ট ট্রাভার্স করার সময় `head` পয়েন্টার সরানোর ফলে লিঙ্কড লিস্টের শুরুর এড্রেস হারিয়ে যাওয়া।"
          },
          {
            "title": "৩. Doubly Linked List এ Prev পয়েন্টার মিস হওয়া",
            "desc": "`curr->next` লিঙ্ক করার সময় `curr->next->prev = curr` লিঙ্ক করতে ভুলে যাওয়া।"
          },
          {
            "title": "৪. মেমোরি লিক (Memory Leak)",
            "desc": "C++ এ কোনো নোড `delete` করার আগে তার `next` পয়েন্টার ব্যাকআপ না রেখে ডিলিট করা।"
          }
        ],
        roadmapStepsEn: [
          {
            "step": "Step 1",
            "title": "Understand Heap Nodes & Pointer References",
            "desc": "Master node memory allocation (`val` + `next`) and reference variables."
          },
          {
            "step": "Step 2",
            "title": "Master Singly Linked List Traversal & Insert/Delete",
            "desc": "Learn linear node traversal, head insertion O(1), and tail insertion O(N)."
          },
          {
            "step": "Step 3",
            "title": "Master Iterative List Reversal (Pointer Flipping)",
            "desc": "Learn 3-pointer manipulation (`prev`, `curr`, `next`) to reverse list in O(1) space."
          },
          {
            "step": "Step 4",
            "title": "Master Fast & Slow Pointer Pattern",
            "desc": "Learn Floyd's Tortoise and Hare algorithm for finding middle node and cycle detection."
          },
          {
            "step": "Step 5",
            "title": "Master Doubly Linked List Bidirectional Operations",
            "desc": "Master swapping `next` and `prev` pointers for bidirectional linked list operations."
          }
        ],
        roadmapStepsBn: [
          {
            "step": "ধাপ ১",
            "title": "হিপ নোড মেমোরি ও পয়েন্টার রেফারেন্স",
            "desc": "হিপ মেমোরিতে নোড তৈরি (`val` + `next`) এবং পয়েন্টারের কাজ বোঝা।"
          },
          {
            "step": "ধাপ ২",
            "title": "Singly Linked List ট্রাভার্সাল ও ইনসার্ট/ডিলেট",
            "desc": "হেডে ও টেইলে নোড যোগ/বিয়োগ এবং নোড ট্রাভার্সিং আয়ত্ত করা।"
          },
          {
            "step": "ধাপ ৩",
            "title": "পয়েন্টার ফ্লিপিং দিয়ে লিস্ট রিভার্সাল",
            "desc": "৩টি পয়েন্টার (`prev`, `curr`, `next`) ব্যবহার করে ওয়ান (O(1)) স্পেসে লিঙ্কড লিস্ট উল্টানো।"
          },
          {
            "step": "ধাপ ৪",
            "title": "ফাস্ট ও স্লো পয়েন্টার অ্যালগরিদম",
            "desc": "মিডল নোড বের করা ও সাইকেল ডিটেকশনের জন্য Floyd's Tortoise and Hare পদ্ধতি শেখা।"
          },
          {
            "step": "ধাপ ৫",
            "title": "Doubly Linked List দ্বিমুখী পয়েন্টার মাস্টার",
            "desc": "`prev` ও `next` পয়েন্টার অদলবদল করে দ্বিমুখী লিঙ্কড লিস্ট কন্ট্রোল করা।"
          }
        ],
      ),

      // 3. STACK (LIFO)
      DsaTopic(
        id: 203,
        title: "Stack (LIFO)",
        category: "Linear Container Structure",
        timeComplexity: "Push: O(1) | Pop: O(1) | Top/Peek: O(1) | Search: O(N)",
        spaceComplexity: "O(N)",
        icon: Icons.layers_outlined,
        themeColor: const Color(0xFF10B981),
        descriptionEn:
            "A Stack is a linear container structure that operates under the strict Last-In, First-Out (LIFO) order. Elements are added (pushed) and removed (popped) exclusively from one end called the Top. All fundamental operations (`push`, `pop`, `top`/`peek`) execute in instant O(1) constant time. Stacks form the foundation of function call stacks, recursion, undo/redo mechanisms, and expression parsing.",
        descriptionBn:
            "স্ট্যাক (Stack) হলো একটি লিনিয়ার কন্টেইনার স্ট্রাকচার যা লাস্ট-ইন, ফার্স্ট-আউট (LIFO) নীতিতে কাজ করে। এখানে সবার শেষ যোগ করা উপাদানটি সবার আগে বের (Pop) করা হয়। উপাদান যোগ (Push) এবং বিয়োগ (Pop) কেবল একটি মাত্র প্রান্ত দিয়ে সম্পন্ন হয় যাকে 'Top' বলা হয়। সমস্ত মূল অপারেশন (`push`, `pop`, `top`) ওয়ান O(1) স্পিডে কাজ করে। ফাংশন কল স্ট্যাক, রিকার্শন, আনডু/রিডু এবং ব্র্যাকেট ম্যাচিংয়ে স্ট্যাকের ভূমিকা অপরিসীম।",
        keyConceptsEn: [
          "LIFO Principle: The last element pushed onto the stack is the first element popped.",
          "O(1) Top Operations: Constant time complexity for push, pop, and top/peek methods.",
          "Parentheses Matching: Using stack to pair opening brackets with closing brackets in O(N) time.",
          "Monotonic Stack: A stack maintained in strictly increasing or decreasing order to solve Next Greater Element in O(N) time."
        ],
        keyConceptsBn: [
          "LIFO নীতি: সবার শেষে পুশ করা উপাদানটি সবার আগে পপ হয়।",
          "O(1) টপ অপারেশন: পুশ, পপ এবং টপ দেখার মান বের করা O(1) কনস্ট্যান্ট টাইমে সম্পন্ন হয়।",
          "ব্র্যাকেট ম্যাচিং: ওপেনিং ব্র্যাকেট স্ট্যাকে রেখে ক্লোজিং ব্র্যাকেটের সাথে জোড়া মেলানোর алгоритм।",
          "মনোটোনিক স্ট্যাক: স্ট্যাকের উপাদান সর্টেড অর্ডারে রেখে Next Greater Element বা তাপমাত্রা সমস্যা O(N) এ সলভ করা।"
        ],
        multiDimCodeTemplates: {
          "Array-Based Stack": {
            "C++": """
#include <iostream>
#include <vector>
using namespace std;

class ArrayStack {
    vector<int> st;
public:
    void push(int x) { st.push_back(x); }
    void pop() { if (!st.empty()) st.pop_back(); }
    int top() { return st.back(); }
    bool empty() { return st.empty(); }
};""",
            "Java": """
import java.util.ArrayDeque;
import java.util.Deque;

public class StackDemo {
    public static void main(String[] args) {
        Deque<Integer> stack = new ArrayDeque<>();
        stack.push(10); // Push O(1)
        stack.push(20);
        System.out.println("Top: " + stack.peek()); // 20
        stack.pop(); // Pop O(1)
    }
}""",
            "Python": """
# Stack using Python list
stack = []
stack.append(10) # Push O(1)
stack.append(20)
print("Top:", stack[-1]) # 20
stack.pop() # Pop O(1)""",
            "JavaScript": """
// Stack using JS Array
const stack = [];
stack.push(10); // Push O(1)
stack.push(20);
console.log("Top:", stack[stack.length - 1]); // 20
stack.pop(); // Pop O(1)"""
          },
          "Monotonic Stack": {
            "C++": """
vector<int> nextGreaterElement(vector<int>& nums) {
    int n = nums.size();
    vector<int> res(n, -1);
    stack<int> st;
    for (int i = 0; i < n; i++) {
        while (!st.empty() && nums[st.top()] < nums[i]) {
            res[st.top()] = nums[i];
            st.pop();
        }
        st.push(i);
    }
    return res;
}""",
            "Java": """
public int[] nextGreaterElement(int[] nums) {
    int n = nums.length;
    int[] res = new int[n];
    Arrays.fill(res, -1);
    Deque<Integer> st = new ArrayDeque<>();
    for (int i = 0; i < n; i++) {
        while (!st.isEmpty() && nums[st.peek()] < nums[i]) {
            res[st.pop()] = nums[i];
        }
        st.push(i);
    }
    return res;
}""",
            "Python": """
def nextGreaterElement(nums):
    res = [-1] * len(nums)
    st = []
    for i, num in enumerate(nums):
        while st and nums[st[-1]] < num:
            res[st.pop()] = num
        st.append(i)
    return res""",
            "JavaScript": """
function nextGreaterElement(nums) {
    const res = new Array(nums.length).fill(-1);
    const st = [];
    for (let i = 0; i < nums.length; i++) {
        while (st.length > 0 && nums[st[st.length - 1]] < nums[i]) {
            res[st.pop()] = nums[i];
        }
        st.push(i);
    }
    return res;
}"""
          }
        },
        basicProblems: [
          DsaProblem(
            id: "st-1",
            title: "1. Valid Parentheses Matching (Balanced Brackets)",
            category: "Stack LIFO Basic",
            keyIdeaEn: "Push opening brackets '(', '[', '{' onto stack. When encountering closing bracket, verify top bracket matches and pop. Return stack.empty().",
            keyIdeaBn: "ওপেনিং ব্র্যাকেট স্ট্যাকে পুশ করুন। ক্লোজিং ব্র্যাকেট পেলে টপ ব্র্যাকেট পপ করে ম্যাচ যাচাই করুন। শেষে স্ট্যাক খালি হওয়া আবশ্যক।",
            codeCpp: """
bool isValid(string s) {
    stack<char> st;
    for (char c : s) {
        if (c == '(' || c == '[' || c == '{') st.push(c);
        else {
            if (st.empty()) return false;
            char top = st.top(); st.pop();
            if ((c == ')' && top != '(') ||
                (c == ']' && top != '[') ||
                (c == '}' && top != '{')) return false;
        }
    }
    return st.empty();
}""",
            codeJava: """
public boolean isValid(String s) {
    Deque<Character> st = new ArrayDeque<>();
    for (char c : s.toCharArray()) {
        if (c == '(' || c == '[' || c == '{') st.push(c);
        else {
            if (st.isEmpty()) return false;
            char top = st.pop();
            if ((c == ')' && top != '(') ||
                (c == ']' && top != '[') ||
                (c == '}' && top != '{')) return false;
        }
    }
    return st.isEmpty();
}""",
            codePython: """
def isValid(s: str) -> bool:
    st = []
    mapping = {')': '(', ']': '[', '}': '{'}
    for char in s:
        if char in mapping:
            top = st.pop() if st else '#'
            if mapping[char] != top:
                return False
        else:
            st.append(char)
    return not st""",
            codeJs: """
function isValid(s) {
    const st = [];
    const map = { ')': '(', ']': '[', '}': '{' };
    for (let c of s) {
        if (c === '(' || c === '[' || c === '{') st.push(c);
        else {
            if (st.length === 0 || st.pop() !== map[c]) return false;
        }
    }
    return st.length === 0;
}""",
            descriptionEn: "Determine if an input string of brackets '()[]{}' is valid and properly closed in correct order.",
            descriptionBn: "একটি ব্র্যাকেট দিয়ে তৈরি স্ট্রিং '()[]{}' সঠিকভাবে সঠিক ক্রমানুসারে ক্লোজ করা হয়েছে কিনা স্ট্যাক দিয়ে যাচাই করুন।",
            sampleInputs: ["s = \"()[]{}\"", "s = \"(]\""],
            sampleOutputs: ["True", "False"],
          ),
          DsaProblem(
            id: "st-2",
            title: "2. Min Stack (Get Minimum Element in O(1))",
            category: "Monotonic Stack Pattern",
            keyIdeaEn: "Maintain an auxiliary minStack alongside main stack. Push min(val, minStack.top()) to auxiliary stack to query O(1) minimum.",
            keyIdeaBn: "মূল স্ট্যাকের পাশাপাশি একটি সেকেন্ডারি minStack রাখুন। নতুন মান পুশ করার সময় সর্বনিম্ন মানও minStack এ পুশ করুন।",
            codeCpp: """
class MinStack {
    stack<int> st, minSt;
public:
    void push(int val) {
        st.push(val);
        if (minSt.empty() || val <= minSt.top()) minSt.push(val);
        else minSt.push(minSt.top());
    }
    void pop() { st.pop(); minSt.pop(); }
    int top() { return st.top(); }
    int getMin() { return minSt.top(); }
};""",
            codeJava: """
class MinStack {
    private Deque<Integer> st = new ArrayDeque<>();
    private Deque<Integer> minSt = new ArrayDeque<>();
    public void push(int val) {
        st.push(val);
        if (minSt.isEmpty() || val <= minSt.peek()) minSt.push(val);
        else minSt.push(minSt.peek());
    }
    public void pop() { st.pop(); minSt.pop(); }
    public int top() { return st.peek(); }
    public int getMin() { return minSt.peek(); }
}""",
            codePython: """
class MinStack:
    def __init__(self):
        self.st = []
        self.minSt = []
    def push(self, val: int) -> None:
        self.st.append(val)
        min_val = min(val, self.minSt[-1]) if self.minSt else val
        self.minSt.append(min_val)
    def pop(self) -> None:
        self.st.pop(); self.minSt.pop()
    def top(self) -> int: return self.st[-1]
    def getMin(self) -> int: return self.minSt[-1]""",
            codeJs: """
class MinStack {
    constructor() { this.st = []; this.minSt = []; }
    push(val) {
        this.st.push(val);
        const minVal = this.minSt.length > 0 ? Math.min(val, this.minSt[this.minSt.length - 1]) : val;
        this.minSt.push(minVal);
    }
    pop() { this.st.pop(); this.minSt.pop(); }
    top() { return this.st[this.st.length - 1]; }
    getMin() { return this.minSt[this.minSt.length - 1]; }
}""",
            descriptionEn: "Design a stack that supports push, pop, top, and retrieving the minimum element in constant O(1) time.",
            descriptionBn: "এমন একটি স্ট্যাক ডিজাইন করুন যা ওয়ান (O(1)) কনস্ট্যান্ট টাইমে সর্বনিম্ন মান (Minimum Element) প্রদান করে।",
            sampleInputs: ["push(-2), push(0), push(-3), getMin(), pop(), getMin()"],
            sampleOutputs: ["min = -3", "min = -2"],
          ),
          DsaProblem(
            id: "st-3",
            title: "3. Evaluate Reverse Polish Notation (Postfix)",
            category: "Expression Evaluation Pattern",
            keyIdeaEn: "Iterate tokens. Push numbers onto stack. When encountering operator (+,-,*,/), pop two top values `b` and `a`, evaluate `a op b`, and push result.",
            keyIdeaBn: "টোকেন ট্রাভার্স করুন। সংখ্যা পেলে স্ট্যাকে রাখুন। অপারেটর পেলে দুটি মান b ও a পপ করে a op b এর মান পুশ করুন।",
            codeCpp: """
int evalRPN(vector<string>& tokens) {
    stack<int> st;
    for (string& t : tokens) {
        if (t == "+" || t == "-" || t == "*" || t == "/") {
            int b = st.top(); st.pop();
            int a = st.top(); st.pop();
            if (t == "+") st.push(a + b);
            else if (t == "-") st.push(a - b);
            else if (t == "*") st.push(a * b);
            else st.push(a / b);
        } else {
            st.push(stoi(t));
        }
    }
    return st.top();
}""",
            codeJava: """
public int evalRPN(String[] tokens) {
    Deque<Integer> st = new ArrayDeque<>();
    for (String t : tokens) {
        if (t.equals("+") || t.equals("-") || t.equals("*") || t.equals("/")) {
            int b = st.pop(), a = st.pop();
            if (t.equals("+")) st.push(a + b);
            else if (t.equals("-")) st.push(a - b);
            else if (t.equals("*")) st.push(a * b);
            else st.push(a / b);
        } else {
            st.push(Integer.parseInt(t));
        }
    }
    return st.peek();
}""",
            codePython: """
def evalRPN(tokens: List[str]) -> int:
    st = []
    for t in tokens:
        if t in "+-*/":
            b, a = st.pop(), st.pop()
            if t == '+': st.append(a + b)
            elif t == '-': st.append(a - b)
            elif t == '*': st.append(a * b)
            else: st.append(int(a / b))
        else:
            st.append(int(t))
    return st[0]""",
            codeJs: """
function evalRPN(tokens) {
    const st = [];
    for (let t of tokens) {
        if (t === "+" || t === "-" || t === "*" || t === "/") {
            let b = st.pop(), a = st.pop();
            if (t === "+") st.push(a + b);
            else if (t === "-") st.push(a - b);
            else if (t === "*") st.push(a * b);
            else st.push(Math.trunc(a / b));
        } else {
            st.push(Number(t));
        }
    }
    return st[0];
}""",
            descriptionEn: "Evaluate the value of an arithmetic expression in Reverse Polish Notation (Postfix).",
            descriptionBn: "পোস্টফিক্স গাণিতিক এক্সপ্রেশন (Reverse Polish Notation) স্ট্যাক ব্যবহার করে সমাধান করুন।",
            sampleInputs: ["tokens = [\"2\", \"1\", \"+\", \"3\", \"*\"]"],
            sampleOutputs: ["Result: 9"],
          ),
          DsaProblem(
            id: "st-4",
            title: "4. Next Greater Element I (Monotonic Stack)",
            category: "Monotonic Stack Pattern",
            keyIdeaEn: "Use a monotonic decreasing stack. Iterate array right-to-left. Pop smaller elements from stack; stack top is next greater element.",
            keyIdeaBn: "মনোটোনিক স্ট্যাক ব্যবহার করুন। অ্যারের ডান থেকে বামে হেঁটে স্ট্যাকের ছোট মানগুলো পপ করুন; টপ মানই Next Greater Element।",
            codeCpp: """
vector<int> nextGreaterElement(vector<int>& arr) {
    int n = arr.size();
    vector<int> res(n, -1);
    stack<int> st;
    for (int i = n - 1; i >= 0; i--) {
        while (!st.empty() && st.top() <= arr[i]) st.pop();
        if (!st.empty()) res[i] = st.top();
        st.push(arr[i]);
    }
    return res;
}""",
            codeJava: """
public int[] nextGreaterElement(int[] arr) {
    int n = arr.length;
    int[] res = new int[n];
    Arrays.fill(res, -1);
    Deque<Integer> st = new ArrayDeque<>();
    for (int i = n - 1; i >= 0; i--) {
        while (!st.isEmpty() && st.peek() <= arr[i]) st.pop();
        if (!st.isEmpty()) res[i] = st.peek();
        st.push(arr[i]);
    }
    return res;
}""",
            codePython: """
def nextGreaterElement(arr):
    n = len(arr)
    res = [-1] * n
    st = []
    for i in range(n - 1, -1, -1):
        while st and st[-1] <= arr[i]:
            st.pop()
        if st:
            res[i] = st[-1]
        st.append(arr[i])
    return res""",
            codeJs: """
function nextGreaterElement(arr) {
    const n = arr.length;
    const res = new Array(n).fill(-1);
    const st = [];
    for (let i = n - 1; i >= 0; i--) {
        while (st.length > 0 && st[st.length - 1] <= arr[i]) {
            st.pop();
        }
        if (st.length > 0) res[i] = st[st.length - 1];
        st.push(arr[i]);
    }
    return res;
}""",
            descriptionEn: "Find the first greater element to the right of each element in an array using a Monotonic Stack.",
            descriptionBn: "মনোটোনিক স্ট্যাক ব্যবহার করে অ্যারের প্রতিটি উপাদানের ডানপাশের প্রথম বড় সংখ্যাটি (Next Greater Element) নির্ণয় করুন।",
            sampleInputs: ["arr = [4, 5, 2, 25]"],
            sampleOutputs: ["res = [5, 25, 25, -1]"],
          ),
        ],
        commonMistakesEn: [
          {
            "title": "1. Stack Underflow Exception",
            "desc": "Calling `st.top()` or `st.pop()` on an empty stack triggers a runtime crash."
          },
          {
            "title": "2. Bracket Mismatch Type Error",
            "desc": "Popping `(` when encountering `]` instead of validating exact bracket pairing."
          },
          {
            "title": "3. Leftover Unmatched Opening Brackets",
            "desc": "Forgetting to verify `st.empty()` at loop end (e.g. `s = \"((\"` leaves unmatched brackets)."
          },
          {
            "title": "4. Incorrect Operand Order in Postfix Subtraction / Division",
            "desc": "Popping `b` then `a` and incorrectly computing `b - a` instead of `a - b`."
          }
        ],
        commonMistakesBn: [
          {
            "title": "১. স্ট্যাক আন্ডারফ্লো এক্সেপশন (Empty Stack Pop)",
            "desc": "খালি স্ট্যাকে `st.top()` বা `st.pop()` কল করলে অ্যাপ ক্র্যাশ করে।"
          },
          {
            "title": "২. ভুল ব্র্যাকেট পেয়ারিং চেক",
            "desc": "`]` ব্র্যাকেটের বিপরীতে `(` পপ করা বা ব্র্যাকেটের ধরন না মিলিয়ে পপ করা।"
          },
          {
            "title": "৩. অবশিষ্ট ওপেনিং ব্র্যাকেট চেক না করা",
            "desc": "লুপ শেষে `st.empty()` ভেরিফাই না করা (যেমন: `s = \"((\"` এর ক্ষেত্রে স্ট্যাকে মান থেকে যায়)।"
          },
          {
            "title": "৪. পোস্টফিক্স বিয়োগ ও ভাগে অপারেটর অর্ডার ভুল",
            "desc": "`b` ও `a` পপ করে সঠিক `a - b` এর বদলে ভুল করে `b - a` হিসাব করা।"
          }
        ],
        roadmapStepsEn: [
          {
            "step": "Step 1",
            "title": "Understand LIFO (Last-In, First-Out) Discipline",
            "desc": "Master stack top pointer, LIFO order, and memory stack push/pop behavior."
          },
          {
            "step": "Step 2",
            "title": "Master Stack Operations & Array/List Implementation",
            "desc": "Master push O(1), pop O(1), peek O(1), and array-based stack implementation."
          },
          {
            "step": "Step 3",
            "title": "Master Balanced Parentheses & String Reversal",
            "desc": "Learn bracket matching, string reversal, and stack-based undo mechanisms."
          },
          {
            "step": "Step 4",
            "title": "Master Min Stack & Postfix Expression Evaluation",
            "desc": "Learn auxiliary minStack O(1) queries and Reverse Polish Notation (RPN) evaluation."
          },
          {
            "step": "Step 5",
            "title": "Master Monotonic Stack Pattern",
            "desc": "Learn monotonic stack for Next Greater Element, Daily Temperatures, and Histogram Area."
          }
        ],
        roadmapStepsBn: [
          {
            "step": "ধাপ ১",
            "title": "LIFO (লাস্ট-ইন, ফার্স্ট-আউট) নীতি বোঝা",
            "desc": "স্ট্যাক টপ পয়েন্টার, LIFO অর্ডার এবং পুশ/পপ আচরণ আয়ত্ত করা।"
          },
          {
            "step": "ধাপ ২",
            "title": "স্ট্যাক অপারেশন ও অ্যারে-ভিত্তিক ইমপ্লিমেন্টেশন",
            "desc": "পুশ O(1), পপ O(1), পিক O(1) এবং অ্যারে দিয়ে স্ট্যাক তৈরি করা শেখা।"
          },
          {
            "step": "ধাপ ৩",
            "title": "ব্যালেন্সড ব্র্যাকেটস ও স্ট্রিং রিভার্সাল",
            "desc": "ব্র্যাকেট ম্যাচিং, স্ট্রিং রিভার্স এবং স্ট্যাক-ভিত্তিক আনডু ফিচার তৈরি।"
          },
          {
            "step": "ধাপ ৪",
            "title": "Min Stack ও পোস্টফিক্স এক্সপ্রেশন মূল্যায়ন",
            "desc": "O(1) মিনিমাম কুয়েরি এবং রিভার্স পোলিশ নোটেশন (RPN) সলভ করা।"
          },
          {
            "step": "ধাপ ৫",
            "title": "মনোটোনিক স্ট্যাক প্যাটার্ন মাস্টারি",
            "desc": "Next Greater Element এবং ডেইলি টেম্পারেচার প্রবলেম মনোটোনিক স্ট্যাকে সমাধান করা।"
          }
        ],
      ),

      // 4. QUEUE (FIFO) & DEQUE
      DsaTopic(
        id: 204,
        title: "Queue (FIFO) & Deque",
        category: "Linear Pipeline Structure",
        timeComplexity: "Enqueue: O(1) | Dequeue: O(1) | Front: O(1) | Search: O(N)",
        spaceComplexity: "O(N)",
        icon: Icons.swap_horizontal_circle_outlined,
        themeColor: const Color(0xFFF59E0B),
        descriptionEn:
            "A Queue is a linear pipeline operating under the strict First-In, First-Out (FIFO) discipline. Elements enter at the Rear (Enqueue) and exit from the Front (Dequeue). A Double-Ended Queue (Deque) extends this by supporting O(1) push and pop operations at both Front and Rear ends. Queues are essential for Breadth-First Search (BFS) graph traversals, CPU task scheduling, print queues, and Sliding Window Maximum algorithms.",
        descriptionBn:
            "কিউ (Queue) হলো একটি লিনিয়ার পাইপলাইন স্ট্রাকচার যা ফার্স্ট-ইন, ফার্স্ট-আউট (FIFO) নীতিতে কাজ করে। এখানে সবার আগে আসা উপাদানটি সবার আগে বের (Dequeue) হয়। পেছন দিকে (Rear) উপাদান যোগ এবং সামনের দিক (Front) থেকে উপাদান বের করা হয়। ডাবল-এন্ডেড কিউ (Deque) এর সামনের ও পিছনের উভয় প্রান্ত দিয়ে O(1) স্পিডে যোগ/বিয়োগ করার সুবিধা দেয়। গ্রাফের BFS ট্রাভার্সাল, প্রসেসর টাস্ক সিডিউলিং এবং স্লাইডিং উইন্ডো সমস্যায় কিউ ব্যাপকভাবে ব্যবহৃত হয়।",
        keyConceptsEn: [
          "FIFO Principle: The first element added to the queue is the first element removed.",
          "O(1) Pipeline Operations: Constant time complexity for enqueue, dequeue, and front methods.",
          "Circular Queue Modulo Math: Utilizing `(rear + 1) % capacity` to reuse freed array slots in constant space.",
          "Monotonic Deque Pattern: Maintaining indices in a decreasing deque to find Sliding Window Maximum in O(N) time."
        ],
        keyConceptsBn: [
          "FIFO নীতি: সবার আগে এনকিউ (Enqueue) করা উপাদানটি সবার আগে ডিকিউ (Dequeue) করা হয়।",
          "O(1) পাইপলাইন অপারেশন: এনকিউ, ডিকিউ এবং ফ্রন্ট দেখার মান বের করা O(1) কনস্ট্যান্ট টাইমে সম্পন্ন হয়।",
          "সার্কুলার কিউ মডিউলো ম্যাথ: `(rear + 1) % capacity` সূত্রের মাধ্যমে অ্যারের খালি হওয়া মেমোরি স্লটগুলো পুনরায় ব্যবহার করা।",
          "মনোটোনিক Deque প্যাটার্ন: Deque এ ইনডেক্সসমূহ সাজিয়ে স্লাইডিং উইন্ডো ম্যাক্সিমাম O(N) টাইমে সমাধান করা।"
        ],
        multiDimCodeTemplates: {
          "Standard FIFO Queue": {
            "C++": """
#include <iostream>
#include <queue>
using namespace std;

int main() {
    queue<int> q;
    q.push(10); // Enqueue O(1)
    q.push(20);
    cout << "Front: " << q.front() << endl; // 10
    q.pop(); // Dequeue O(1)
    return 0;
}""",
            "Java": """
import java.util.ArrayDeque;
import java.util.Queue;

public class QueueDemo {
    public static void main(String[] args) {
        Queue<Integer> q = new ArrayDeque<>();
        q.offer(10); // Enqueue O(1)
        q.offer(20);
        System.out.println("Front: " + q.peek()); // 10
        q.poll(); // Dequeue O(1)
    }
}""",
            "Python": """
from collections import deque

q = deque()
q.append(10) # Enqueue O(1)
q.append(20)
print("Front:", q[0]) # 10
q.popleft() # Dequeue O(1)""",
            "JavaScript": """
// Deque / Double-ended queue array
const q = [];
q.push(10); // Enqueue Rear O(1)
q.push(20);
console.log("Front:", q[0]); // 10
q.shift(); // Dequeue Front"""
          },
          "Double-Ended Queue (Deque)": {
            "C++": """
#include <iostream>
#include <deque>
using namespace std;

int main() {
    deque<int> dq;
    dq.push_back(10);  // Push Rear
    dq.push_front(5);  // Push Front
    dq.pop_back();     // Pop Rear
    dq.pop_front();    // Pop Front
    return 0;
}""",
            "Java": """
import java.util.ArrayDeque;
import java.util.Deque;

public class DequeDemo {
    public static void main(String[] args) {
        Deque<Integer> dq = new ArrayDeque<>();
        dq.addLast(10);  // Push Rear
        dq.addFirst(5);  // Push Front
        dq.removeLast(); // Pop Rear
        dq.removeFirst();// Pop Front
    }
}""",
            "Python": """
from collections import deque

dq = deque()
dq.append(10)     # Push Rear
dq.appendleft(5)  # Push Front
dq.pop()          # Pop Rear
dq.popleft()      # Pop Front""",
            "JavaScript": """
const dq = [];
dq.push(10);    // Push Rear
dq.unshift(5);  // Push Front
dq.pop();       // Pop Rear
dq.shift();     // Pop Front"""
          }
        },
        basicProblems: [
          DsaProblem(
            id: "q-1",
            title: "1. Implement Queue using Stacks (Two Stack FIFO)",
            category: "Queue FIFO Basic",
            keyIdeaEn: "Use 2 stacks: `stIn` and `stOut`. Push onto `stIn`. On pop/peek, if `stOut` is empty, transfer all elements from `stIn` to `stOut` to reverse order to FIFO.",
            keyIdeaBn: "২টি স্ট্যাক ব্যবহার করুন: `stIn` এবং `stOut`। পুশ করার সময় `stIn` এ দিন। পপ/পিক করার সময় `stOut` খালি থাকলে `stIn` এর উপাদান স্থানান্তর করে FIFO অর্জন করুন।",
            codeCpp: """
class MyQueue {
    stack<int> stIn, stOut;
    void transfer() {
        if (stOut.empty()) {
            while (!stIn.empty()) {
                stOut.push(stIn.top());
                stIn.pop();
            }
        }
    }
public:
    void push(int x) { stIn.push(x); }
    int pop() { transfer(); int val = stOut.top(); stOut.pop(); return val; }
    int peek() { transfer(); return stOut.top(); }
    bool empty() { return stIn.empty() && stOut.empty(); }
};""",
            codeJava: """
class MyQueue {
    private Deque<Integer> stIn = new ArrayDeque<>();
    private Deque<Integer> stOut = new ArrayDeque<>();
    private void transfer() {
        if (stOut.isEmpty()) {
            while (!stIn.isEmpty()) stOut.push(stIn.pop());
        }
    }
    public void push(int x) { stIn.push(x); }
    public int pop() { transfer(); return stOut.pop(); }
    public int peek() { transfer(); return stOut.peek(); }
    public boolean empty() { return stIn.isEmpty() && stOut.isEmpty(); }
}""",
            codePython: """
class MyQueue:
    def __init__(self):
        self.stIn = []
        self.stOut = []
    def push(self, x: int) -> None:
        self.stIn.append(x)
    def transfer(self):
        if not self.stOut:
            while self.stIn:
                self.stOut.append(self.stIn.pop())
    def pop(self) -> int:
        self.transfer()
        return self.stOut.pop()
    def peek(self) -> int:
        self.transfer()
        return self.stOut[-1]
    def empty(self) -> bool:
        return not self.stIn and not self.stOut""",
            codeJs: """
class MyQueue {
    constructor() { this.stIn = []; this.stOut = []; }
    push(x) { this.stIn.push(x); }
    transfer() {
        if (this.stOut.length === 0) {
            while (this.stIn.length > 0) this.stOut.push(this.stIn.pop());
        }
    }
    pop() { this.transfer(); return this.stOut.pop(); }
    peek() { this.transfer(); return this.stOut[this.stOut.length - 1]; }
    empty() { return this.stIn.length === 0 && this.stOut.length === 0; }
}""",
            descriptionEn: "Implement a First-In, First-Out (FIFO) queue using only two standard stacks.",
            descriptionBn: "কেবলমাত্র দুটি স্ট্যাক ব্যবহার করে ফার্স্ট-ইন, ফার্স্ট-আউট (FIFO) কিউ ইমপ্লিমেন্ট করুন।",
            sampleInputs: ["push(1), push(2), peek(), pop(), empty()"],
            sampleOutputs: ["peek: 1", "pop: 1", "empty: false"],
          ),
          DsaProblem(
            id: "q-2",
            title: "2. Circular Queue Implementation (Modulo Ring)",
            category: "Circular Queue Pattern",
            keyIdeaEn: "Design a fixed-size Circular Queue using modulo arithmetic `(rear + 1) % K` and `(front + 1) % K` to reuse freed array slots.",
            keyIdeaBn: "মডিউলো পাটিগণিত `(rear + 1) % K` ব্যবহার করে ফিক্সড-সাইজ সার্কুলার কিউ ডিজাইন করুন যেন মেমোরি স্লট পুনরায় ব্যবহার করা যায়।",
            codeCpp: """
class MyCircularQueue {
    vector<int> arr;
    int front, rear, size, capacity;
public:
    MyCircularQueue(int k) {
        capacity = k; size = 0; front = 0; rear = -1;
        arr.resize(k);
    }
    bool enQueue(int value) {
        if (isFull()) return false;
        rear = (rear + 1) % capacity;
        arr[rear] = value;
        size++; return true;
    }
    bool deQueue() {
        if (isEmpty()) return false;
        front = (front + 1) % capacity;
        size--; return true;
    }
    int Front() { return isEmpty() ? -1 : arr[front]; }
    int Rear() { return isEmpty() ? -1 : arr[rear]; }
    bool isEmpty() { return size == 0; }
    bool isFull() { return size == capacity; }
};""",
            codeJava: """
class MyCircularQueue {
    private int[] arr;
    private int front = 0, rear = -1, size = 0, capacity;
    public MyCircularQueue(int k) {
        capacity = k; arr = new int[k];
    }
    public boolean enQueue(int value) {
        if (isFull()) return false;
        rear = (rear + 1) % capacity;
        arr[rear] = value; size++; return true;
    }
    public boolean deQueue() {
        if (isEmpty()) return false;
        front = (front + 1) % capacity; size--; return true;
    }
    public int Front() { return isEmpty() ? -1 : arr[front]; }
    public int Rear() { return isEmpty() ? -1 : arr[rear]; }
    public boolean isEmpty() { return size == 0; }
    public boolean isFull() { return size == capacity; }
}""",
            codePython: """
class MyCircularQueue:
    def __init__(self, k: int):
        self.arr = [0] * k
        self.capacity = k
        self.front = 0
        self.rear = -1
        self.size = 0
    def enQueue(self, value: int) -> bool:
        if self.isFull(): return False
        self.rear = (self.rear + 1) % self.capacity
        self.arr[self.rear] = value
        self.size += 1
        return True
    def deQueue(self) -> bool:
        if self.isEmpty(): return False
        self.front = (self.front + 1) % self.capacity
        self.size -= 1
        return True
    def Front(self) -> int: return -1 if self.isEmpty() else self.arr[self.front]
    def Rear(self) -> int: return -1 if self.isEmpty() else self.arr[self.rear]
    def isEmpty(self) -> bool: return self.size == 0
    def isFull(self) -> bool: return self.size == self.capacity""",
            codeJs: """
class MyCircularQueue {
    constructor(k) {
        this.arr = new Array(k);
        this.capacity = k;
        this.front = 0; this.rear = -1; this.size = 0;
    }
    enQueue(value) {
        if (this.isFull()) return false;
        this.rear = (this.rear + 1) % this.capacity;
        this.arr[this.rear] = value;
        this.size++; return true;
    }
    deQueue() {
        if (this.isEmpty()) return false;
        this.front = (this.front + 1) % this.capacity;
        this.size--; return true;
    }
    Front() { return this.isEmpty() ? -1 : this.arr[this.front]; }
    Rear() { return this.isEmpty() ? -1 : this.arr[this.rear]; }
    isEmpty() { return this.size === 0; }
    isFull() { return this.size === this.capacity; }
}""",
            descriptionEn: "Design a Circular Queue of fixed capacity K that reuses empty memory slots efficiently.",
            descriptionBn: "নির্দিষ্ট K সাইজের সার্কুলার কিউ তৈরি করুন যা মেমোরির খালি স্লটগুলো দক্ষভাবে পুনর্ব্যবহার করে।",
            sampleInputs: ["enQueue(1), enQueue(2), enQueue(3), deQueue(), enQueue(4)"],
            sampleOutputs: ["Front: 2", "Rear: 4"],
          ),
          DsaProblem(
            id: "q-3",
            title: "3. First Non-Repeating Character in a Stream",
            category: "Queue Stream Pattern",
            keyIdeaEn: "Track character frequencies in a map and push characters to queue. While queue is non-empty and front character frequency > 1, pop from queue.",
            keyIdeaBn: "অক্ষরের ফ্রিকোয়েন্সি ম্যাপে রাখুন এবং কিউতে এনকিউ করুন। `freq[q.front()] > 1` হলে পপ করে ডুপ্লিকেট রিমুভ করুন।",
            codeCpp: """
string firstNonRepeating(string s) {
    unordered_map<char, int> freq;
    queue<char> q;
    string res = "";
    for (char c : s) {
        freq[c]++;
        q.push(c);
        while (!q.empty() && freq[q.front()] > 1) {
            q.pop();
        }
        res += q.empty() ? '#' : q.front();
    }
    return res;
}""",
            codeJava: """
public String firstNonRepeating(String s) {
    Map<Character, Integer> freq = new HashMap<>();
    Queue<Character> q = new ArrayDeque<>();
    StringBuilder res = new StringBuilder();
    for (char c : s.toCharArray()) {
        freq.put(c, freq.getOrDefault(c, 0) + 1);
        q.offer(c);
        while (!q.isEmpty() && freq.get(q.peek()) > 1) {
            q.poll();
        }
        res.append(q.isEmpty() ? '#' : q.peek());
    }
    return res.toString();
}""",
            codePython: """
def firstNonRepeating(s: str) -> str:
    freq = {}
    q = deque()
    res = []
    for c in s:
        freq[c] = freq.get(c, 0) + 1
        q.append(c)
        while q and freq[q[0]] > 1:
            q.popleft()
        res.append(q[0] if q else '#')
    return "".join(res)""",
            codeJs: """
function firstNonRepeating(s) {
    const freq = {};
    const q = [];
    let res = "";
    for (let c of s) {
        freq[c] = (freq[c] || 0) + 1;
        q.push(c);
        while (q.length > 0 && freq[q[0]] > 1) {
            q.shift();
        }
        res += q.length === 0 ? '#' : q[0];
    }
    return res;
}""",
            descriptionEn: "Find the first non-repeating character at each insertion in a character stream.",
            descriptionBn: "একটি ইনপুট ক্যারেক্টার স্ট্রিম থেকে প্রতিটি ধাপে প্রথম অনাবৃত্ত (First Non-Repeating) বর্ণটি বের করুন।",
            sampleInputs: ["stream = \"aabccxb\""],
            sampleOutputs: ["result = \"a#bccxb\""],
          ),
          DsaProblem(
            id: "q-4",
            title: "4. Sliding Window Maximum (Monotonic Deque)",
            category: "Monotonic Deque Pattern",
            keyIdeaEn: "Maintain a Deque storing indices in decreasing order of array elements. Pop smaller element indices from back and out-of-window indices from front.",
            keyIdeaBn: "মনোটোনিক ডিক্রিজিং Deque ব্যবহার করুন। উইন্ডোর বাইরের ইনডেক্স ফ্রন্ট থেকে বাদ দিন এবং ছোট মানগুলোর ইনডেক্স ব্যাক থেকে রিমুভ করুন।",
            codeCpp: """
vector<int> maxSlidingWindow(vector<int>& nums, int k) {
    deque<int> dq;
    vector<int> res;
    for (int i = 0; i < nums.size(); i++) {
        if (!dq.empty() && dq.front() == i - k) dq.pop_front();
        while (!dq.empty() && nums[dq.back()] < nums[i]) dq.pop_back();
        dq.push_back(i);
        if (i >= k - 1) res.push_back(nums[dq.front()]);
    }
    return res;
}""",
            codeJava: """
public int[] maxSlidingWindow(int[] nums, int k) {
    Deque<Integer> dq = new ArrayDeque<>();
    int[] res = new int[nums.length - k + 1];
    int idx = 0;
    for (int i = 0; i < nums.length; i++) {
        if (!dq.isEmpty() && dq.peekFirst() == i - k) dq.pollFirst();
        while (!dq.isEmpty() && nums[dq.peekLast()] < nums[i]) dq.pollLast();
        dq.offerLast(i);
        if (i >= k - 1) res[idx++] = nums[dq.peekFirst()];
    }
    return res;
}""",
            codePython: """
def maxSlidingWindow(nums: List[int], k: int) -> List[int]:
    dq = deque()
    res = []
    for i, num in enumerate(nums):
        if dq and dq[0] == i - k:
            dq.popleft()
        while dq and nums[dq[-1]] < num:
            dq.pop()
        dq.append(i)
        if i >= k - 1:
            res.append(nums[dq[0]])
    return res""",
            codeJs: """
function maxSlidingWindow(nums, k) {
    const dq = [];
    const res = [];
    for (let i = 0; i < nums.length; i++) {
        if (dq.length > 0 && dq[0] === i - k) dq.shift();
        while (dq.length > 0 && nums[dq[dq.length - 1]] < nums[i]) {
            dq.pop();
        }
        dq.push(i);
        if (i >= k - 1) res.push(nums[dq[0]]);
    }
    return res;
}""",
            descriptionEn: "Find the maximum value in each sliding window of size K moving from left to right across an array.",
            descriptionBn: "K আকারের প্রতি স্লাইডিং উইন্ডোতে সর্বোচ্চ সংখ্যাটি Monotonic Deque ব্যবহার করে O(N) টাইমে বের করুন।",
            sampleInputs: ["nums = [1,3,-1,-3,5,3,6,7], k = 3"],
            sampleOutputs: ["result = [3, 3, 5, 5, 6, 7]"],
          ),
        ],
        commonMistakesEn: [
          {
            "title": "1. Using Vector/List `shift()` / `remove(0)` in Loops (Hidden O(N²))",
            "desc": "Calling `list.remove(0)` or `arr.shift()` in a loop causes hidden O(N) element shifting, leading to O(N²) quadratic time."
          },
          {
            "title": "2. Circular Queue Modulo Wrap Bug",
            "desc": "Forgetting modulo math `(rear + 1) % capacity` and incrementing `rear++` beyond array capacity."
          },
          {
            "title": "3. Queue Underflow Exception",
            "desc": "Invoking `q.front()` or `q.pop()` on an empty queue without checking `q.empty()`."
          },
          {
            "title": "4. Monotonic Deque Index Mismatch",
            "desc": "Storing element values instead of element indices in Deque, making window boundary check (`i - k`) impossible."
          }
        ],
        commonMistakesBn: [
          {
            "title": "১. লুপে লিস্টের ফ্রন্ট থেকে ডিলিটে O(N²) সময় নষ্ট",
            "desc": "লুপের ভেতর `list.remove(0)` বা `shift()` ব্যবহার করলে এলিমেন্ট শিফটিং এর জন্য O(N²) সময় নষ্ট হয়।"
          },
          {
            "title": "২. সার্কুলার কিউ মডিউলো বাউন্ড ভুল",
            "desc": "` (rear + 1) % capacity` না করে সরাসরি `rear++` বাড়িয়ে মেমোরি বাউন্ডের বাইরে চলে যাওয়া।"
          },
          {
            "title": "৩. কিউ আন্ডারফ্লো এক্সেপশন",
            "desc": "খালি কিউতে `q.front()` বা `q.pop()` ডিকিউ করার চেষ্টা করা।"
          },
          {
            "title": "৪. মনোটোনিক Deque এ ইনডেক্সের বদলে ভ্যালু স্টোর করা",
            "desc": "Deque এ ইনডেক্স না রেখে মান রাখলে উইন্ডো বাউন্ডারি (`i - k`) ভেরিফাই করা অসম্ভব হয়ে পড়ে।"
          }
        ],
        roadmapStepsEn: [
          {
            "step": "Step 1",
            "title": "Understand FIFO (First-In, First-Out) Pipeline Discipline",
            "desc": "Master queue front/rear pointers, FIFO order, and pipeline memory behavior."
          },
          {
            "step": "Step 2",
            "title": "Master Basic Queue Operations & Implementations",
            "desc": "Master enqueue O(1), dequeue O(1), front O(1), and array/linked-list queue implementations."
          },
          {
            "step": "Step 3",
            "title": "Master Circular Queue Modulo Index Math",
            "desc": "Learn `(i + 1) % capacity` modulo index wrapping for fixed-size ring buffers."
          },
          {
            "step": "Step 4",
            "title": "Master Queue Stream Processing & Double-Ended Queue (Deque)",
            "desc": "Learn stream processing, first non-repeating character, and bidirectional Deque operations."
          },
          {
            "step": "Step 5",
            "title": "Master Monotonic Deque Pattern (Sliding Window)",
            "desc": "Learn monotonic decreasing deque for Sliding Window Maximum in O(N) time."
          }
        ],
        roadmapStepsBn: [
          {
            "step": "ধাপ ১",
            "title": "FIFO (ফার্স্ট-ইন, ফার্স্ট-আউট) পাইপলাইন নীতি",
            "desc": "কিউ ফ্রন্ট/রিয়ার পয়েন্টার, FIFO অর্ডার এবং পাইপলাইন মেমোরি আচরণ বোঝা।"
          },
          {
            "step": "ধাপ ২",
            "title": "কিউ অপারেশন ও অ্যারে/লিস্ট ইমপ্লিমেন্টেশন",
            "desc": "এনকিউ O(1), ডিকিউ O(1), ফ্রন্ট O(1) এবং কিউ ডেটা স্ট্রাকচার তৈরি।"
          },
          {
            "step": "ধাপ ৩",
            "title": "সার্কুলার কিউ মডিউলো ইনডেক্স সূত্র",
            "desc": "` (i + 1) % capacity` সূত্রের মাধ্যমে ফিক্সড-সাইজ সার্কুলার কিউ সলভ করা।"
          },
          {
            "step": "ধাপ ৪",
            "title": "কিউ স্ট্রিম প্রসেসিং ও Double-Ended Queue (Deque)",
            "desc": "অনাবৃত্ত ক্যারেক্টার স্ট্রিম এবং দ্বিমুখী Deque দিয়ে ফ্রন্ট/রিয়ার অপারেশন শেখা।"
          },
          {
            "step": "ধাপ ৫",
            "title": "মনোটোনিক Deque প্যাটার্ন (Sliding Window Maximum)",
            "desc": "মনোটোনিক ডিক্রিজিং Deque দিয়ে স্লাইডিং উইন্ডো সর্বোচ্চ মান O(N) এ নির্ণয়।"
          }
        ],
      ),

      // 5. HASH TABLE & HASH MAP
      DsaTopic(
        id: 205,
        title: "Hash Table & Hash Map",
        category: "Associative Dictionary",
        timeComplexity: "Lookup: O(1) avg | Insert: O(1) avg | Delete: O(1) avg | Worst: O(N)",
        spaceComplexity: "O(N)",
        icon: Icons.grid_view_outlined,
        themeColor: const Color(0xFFEC4899),
        descriptionEn:
            "A Hash Table is an associative key-value dictionary structure that converts arbitrary key objects into integer array indices using a Hash Function. It enables lightning-fast average O(1) constant time lookups, insertions, and deletions. Hash collisions are resolved via Separate Chaining (Linked Lists / Red-Black Trees) or Open Addressing (Linear Probing). Hash Maps power database indexing, caching systems, frequency counting, and instant complement search algorithms.",
        descriptionBn:
            "হ্যাশ টেবিল (Hash Table) হলো একটি কী-ভ্যালু ডিকশনারি ডেটা স্ট্রাকচার যা হ্যাশ ফাংশন (Hash Function) ব্যবহার করে যেকোনো কী-কে অ্যারে ইনডেক্সে রূপান্তর করে। এর ফলে উপাদান খোঁজা (Lookup), যোগ (Insert) এবং ডিলেট করার কাজ গড়ে O(1) কনস্ট্যান্ট সময়ে সম্পন্ন হয়। ক্যালিগ্রাফি বা হ্যাশ কলিশন এড়াতে সেপারেট চেইনিং বা ওপেন এড্রেসিং পদ্ধতি ব্যবহার করা হয়। ডেটাবেজ ইনডেক্সিং, ক্যাশিং এবং টু-সাম সমস্যার জন্য হ্যাশ ম্যাপ অপরিহার্য।",
        keyConceptsEn: [
          "O(1) Average Complexity: Instant key lookup, insert, and delete operations via hash index calculation.",
          "Hash Collision Resolution: Handling duplicate hash indices using Separate Chaining (Linked List / Red-Black Tree) or Open Addressing.",
          "Frequency Map Pattern: Counting occurrences of characters or integers in O(N) time and O(K) space.",
          "Prefix Sum + Hash Map: Finding continuous subarrays matching target sum K by storing running prefix sum frequencies."
        ],
        keyConceptsBn: [
          "O(1) গড় জটিলতা: হ্যাশ ফাংশনের ইনডেক্স হিসাবের মাধ্যমে যেকোনো কী দ্রুত খুঁজে পাওয়া।",
          "হ্যাশ কলিশন হ্যান্ডলিং: একই ইনডেক্সে দুটি কী পাওয়া গেলে সেপারেট চেইনিং বা লিনিয়ার প্রোবিং ব্যবহার করা।",
          "ফ্রিকোয়েন্সি ম্যাপ প্যাটার্ন: ক্যারেক্টার বা সংখ্যার উপস্থিতি গণনা ও বালতি সাজানো।",
          "প্রেফিক্স সাম + হ্যাশ ম্যাপ: পূর্ববর্তী রানিং সাম জমা রেখে সাব-অ্যারে সাম K খুব সহজে বের করা।"
        ],
        multiDimCodeTemplates: {
          "Hash Map (Key-Value Pair)": {
            "C++": """
#include <iostream>
#include <unordered_map>
using namespace std;

int main() {
    unordered_map<string, int> mp;
    mp["apple"] = 5; // Insert O(1)
    mp["banana"] = 3;
    if (mp.find("apple") != mp.end()) {
        cout << "Apple count: " << mp["apple"] << endl;
    }
    return 0;
}""",
            "Java": """
import java.util.HashMap;
import java.util.Map;

public class HashMapDemo {
    public static void main(String[] args) {
        Map<String, Integer> map = new HashMap<>();
        map.put("apple", 5); // Insert O(1)
        map.put("banana", 3);
        System.out.println("Apple: " + map.get("apple"));
    }
}""",
            "Python": """
# Python dict implementation
mp = {}
mp["apple"] = 5 # Insert O(1)
mp["banana"] = 3
print("Apple count:", mp.get("apple", 0))""",
            "JavaScript": """
// JS Map object
const map = new Map();
map.set("apple", 5); // Insert O(1)
map.set("banana", 3);
console.log("Apple:", map.get("apple"));"""
          },
          "Hash Set (Unique Values)": {
            "C++": """
#include <iostream>
#include <unordered_set>
using namespace std;

int main() {
    unordered_set<int> st = {10, 20, 30};
    if (st.count(20)) cout << "Found 20!" << endl;
    return 0;
}""",
            "Java": """
import java.util.HashSet;
import java.util.Set;

public class SetDemo {
    public static void main(String[] args) {
        Set<Integer> set = new HashSet<>();
        set.add(10); set.add(20);
        System.out.println("Contains 20? " + set.contains(20));
    }
}""",
            "Python": """
st = {10, 20, 30}
if 20 in st:
    print("Found 20!")""",
            "JavaScript": """
const set = new Set([10, 20, 30]);
console.log(set.has(20));"""
          }
        },
        basicProblems: [
          DsaProblem(
            id: "hm-1",
            title: "1. Two Sum (Hash Map Complement Lookup)",
            category: "Hash Map Lookup Basic",
            keyIdeaEn: "Iterate array. Check if `target - nums[i]` exists in map. If found, return pair indices `{map[target - nums[i]], i}`. Otherwise store `map[nums[i]] = i`.",
            keyIdeaBn: "অ্যারে লুপ চালান। ম্যাপে `target - nums[i]` আছে কিনা চেক করুন। থাকলে ইনডেক্স জোড়া রিটার্ন করুন, না থাকলে `map[nums[i]] = i` সেভ করুন।",
            codeCpp: """
vector<int> twoSum(vector<int>& nums, int target) {
    unordered_map<int, int> mp;
    for (int i = 0; i < nums.size(); i++) {
        int complement = target - nums[i];
        if (mp.count(complement)) return {mp[complement], i};
        mp[nums[i]] = i;
    }
    return {};
}""",
            codeJava: """
public int[] twoSum(int[] nums, int target) {
    Map<Integer, Integer> map = new HashMap<>();
    for (int i = 0; i < nums.length; i++) {
        int complement = target - nums[i];
        if (map.containsKey(complement)) {
            return new int[]{map.get(complement), i};
        }
        map.put(nums[i], i);
    }
    return new int[0];
}""",
            codePython: """
def twoSum(nums: List[int], target: int) -> List[int]:
    mp = {}
    for i, num in enumerate(nums):
        complement = target - num
        if complement in mp:
            return [mp[complement], i]
        mp[num] = i
    return []""",
            codeJs: """
function twoSum(nums, target) {
    const map = new Map();
    for (let i = 0; i < nums.length; i++) {
        const complement = target - nums[i];
        if (map.has(complement)) {
            return [map.get(complement), i];
        }
        map.set(nums[i], i);
    }
    return [];
}""",
            descriptionEn: "Return indices of two numbers in an array that add up to a target sum in O(N) time.",
            descriptionBn: "একটি অ্যারে থেকে দুটি সংখ্যার ইনডেক্স বের করুন যাদের যোগফল target এর সমান হয়।",
            sampleInputs: ["nums = [2, 7, 11, 15], target = 9"],
            sampleOutputs: ["indices = [0, 1]"],
          ),
          DsaProblem(
            id: "hm-2",
            title: "2. Valid Anagram (Frequency Bucket Map)",
            category: "Frequency Counter Pattern",
            keyIdeaEn: "Count character frequencies for string `s` (+1) and string `t` (-1) using a Hash Map or 26-size frequency array. Return true if all counts are 0.",
            keyIdeaBn: "প্রথম স্ট্রিং `s` এর ক্যারেক্টার ফ্রিকোয়েন্সি বাড়িয়ে এবং `t` এর ফ্রিকোয়েন্সি কমিয়ে চেক করুন। সব গণনাসংখ্যা ০ হলে এটি সঠিক এনগ্রাম।",
            codeCpp: """
bool isAnagram(string s, string t) {
    if (s.length() != t.length()) return false;
    unordered_map<char, int> freq;
    for (char c : s) freq[c]++;
    for (char c : t) {
        if (--freq[c] < 0) return false;
    }
    return true;
}""",
            codeJava: """
public boolean isAnagram(String s, String t) {
    if (s.length() != t.length()) return false;
    int[] count = new int[26];
    for (int i = 0; i < s.length(); i++) {
        count[s.charAt(i) - 'a']++;
        count[t.charAt(i) - 'a']--;
    }
    for (int c : count) if (c != 0) return false;
    return true;
}""",
            codePython: """
def isAnagram(s: str, t: str) -> bool:
    if len(s) != len(t): return False
    freq = {}
    for c in s: freq[c] = freq.get(c, 0) + 1
    for c in t:
        if c not in freq or freq[c] == 0: return False
        freq[c] -= 1
    return True""",
            codeJs: """
function isAnagram(s, t) {
    if (s.length !== t.length) return false;
    const map = {};
    for (let c of s) map[c] = (map[c] || 0) + 1;
    for (let c of t) {
        if (!map[c]) return false;
        map[c]--;
    }
    return true;
}""",
            descriptionEn: "Determine if two strings contain identical character frequencies.",
            descriptionBn: "দুটি স্ট্রিংয়ের সমস্ত অক্ষরের ফ্রিকোয়েন্সি হুবহু একই কিনা তা ওয়ান (O(N)) টাইমে যাচাই করুন।",
            sampleInputs: ["s = \"anagram\", t = \"nagaram\"", "s = \"rat\", t = \"car\""],
            sampleOutputs: ["True", "False"],
          ),
          DsaProblem(
            id: "hm-3",
            title: "3. Group Anagrams (Sorted String Key Hash)",
            category: "Hash Bucket Pattern",
            keyIdeaEn: "Sort characters of each string alphabetically to form a unique bucket key. Store `key -> List<string>` in a Hash Map.",
            keyIdeaBn: "প্রতিটি স্ট্রিং অ্যালফাবেটিক্যালি সর্ট করে একটি নতুন কী বানান। সেই কী অনুযায়ী `key -> List<string>` ম্যাপে গ্রুপ করুন।",
            codeCpp: """
vector<vector<string>> groupAnagrams(vector<string>& strs) {
    unordered_map<string, vector<string>> mp;
    for (string& s : strs) {
        string key = s;
        sort(key.begin(), key.end());
        mp[key].push_back(s);
    }
    vector<vector<string>> res;
    for (auto& pair : mp) res.push_back(pair.second);
    return res;
}""",
            codeJava: """
public List<List<String>> groupAnagrams(String[] strs) {
    Map<String, List<String>> map = new HashMap<>();
    for (String s : strs) {
        char[] chars = s.toCharArray();
        Arrays.sort(chars);
        String key = new String(chars);
        map.putIfAbsent(key, new ArrayList<>());
        map.get(key).add(s);
    }
    return new ArrayList<>(map.values());
}""",
            codePython: """
def groupAnagrams(strs: List[str]) -> List[List[str]]:
    mp = defaultdict(list)
    for s in strs:
        key = "".join(sorted(s))
        mp[key].append(s)
    return list(mp.values())""",
            codeJs: """
function groupAnagrams(strs) {
    const map = {};
    for (let s of strs) {
        let key = s.split('').sort().join('');
        if (!map[key]) map[key] = [];
        map[key].push(s);
    }
    return Object.values(map);
}""",
            descriptionEn: "Group an array of strings into anagram buckets using a sorted key Hash Map.",
            descriptionBn: "স্ট্রিংয়ের অ্যারে থেকে একই বর্ণ দিয়ে গঠিত অ্যানাগ্রামগুলোকে একসাথে গ্রুপ (Group) করুন।",
            sampleInputs: ["strs = [\"eat\",\"tea\",\"tan\",\"ate\",\"nat\",\"bat\"]"],
            sampleOutputs: ["result = [[\"eat\",\"tea\",\"ate\"],[\"tan\",\"nat\"],[\"bat\"]]"],
          ),
          DsaProblem(
            id: "hm-4",
            title: "4. Subarray Sum Equals K (Prefix Sum + Hash Map)",
            category: "Prefix Sum Hash Pattern",
            keyIdeaEn: "Maintain running `prefixSum`. At each index, check if `prefixSum - K` exists in map; add frequency to total count. Store `map[prefixSum]++`.",
            keyIdeaBn: "রানিং `prefixSum` হিসাব করুন। প্রতিটি ধাপে ম্যাপে `prefixSum - K` এর ফ্রিকোয়েন্সি যোগ করুন এবং `map[prefixSum]++` আপডেট করুন।",
            codeCpp: """
int subarraySum(vector<int>& nums, int k) {
    unordered_map<int, int> mp;
    mp[0] = 1;
    int sum = 0, count = 0;
    for (int num : nums) {
        sum += num;
        if (mp.count(sum - k)) count += mp[sum - k];
        mp[sum]++;
    }
    return count;
}""",
            codeJava: """
public int subarraySum(int[] nums, int k) {
    Map<Integer, Integer> map = new HashMap<>();
    map.put(0, 1);
    int sum = 0, count = 0;
    for (int num : nums) {
        sum += num;
        if (map.containsKey(sum - k)) {
            count += map.get(sum - k);
        }
        map.put(sum, map.getOrDefault(sum, 0) + 1);
    }
    return count;
}""",
            codePython: """
def subarraySum(nums: List[int], k: int) -> int:
    mp = {0: 1}
    sum = 0
    count = 0
    for num in nums:
        sum += num
        if (sum - k) in mp:
            count += mp[sum - k]
        mp[sum] = mp.get(sum, 0) + 1
    return count""",
            codeJs: """
function subarraySum(nums, k) {
    const map = new Map();
    map.set(0, 1);
    let sum = 0, count = 0;
    for (let num of nums) {
        sum += num;
        if (map.has(sum - k)) count += map.get(sum - k);
        map.set(sum, (map.get(sum) || 0) + 1);
    }
    return count;
}""",
            descriptionEn: "Find total number of continuous subarrays whose elements sum to K using Prefix Sum Hash Map.",
            descriptionBn: "অ্যারের ভেতরে যেসব সাব-অ্যারের উপাদানগুলোর যোগফল K এর সমান তাদের মোট সংখ্যা O(N) এ নির্ণয় করুন।",
            sampleInputs: ["nums = [1, 1, 1], k = 2"],
            sampleOutputs: ["Subarray Count: 2"],
          ),
        ],
        commonMistakesEn: [
          {
            "title": "1. Using Custom Object Keys Without `hashCode()` and `equals()`",
            "desc": "Storing custom objects as map keys without overriding `hashCode()` and `equals()` leads to duplicate key insertion or lookup failures."
          },
          {
            "title": "2. Modifying Keys While Stored in Hash Map",
            "desc": "Mutating an object key after inserting it into a map alters its hash code, corrupting internal bucket lookup."
          },
          {
            "title": "3. Hash Collision Degradation to O(N)",
            "desc": "Poor hash functions causing all keys to hash to the same bucket degrade O(1) operations into O(N) linked list traversals."
          },
          {
            "title": "4. Off-By-One Insertion Bug in Two Sum",
            "desc": "Inserting current element into map before checking `target - nums[i]` causes matching an element with itself."
          }
        ],
        commonMistakesBn: [
          {
            "title": "১. কাস্টম অবজেক্ট কী-তে `hashCode()` মিস হওয়া",
            "desc": "কাস্টম ক্লাস অবজেক্টকে কী হিসাবে রাখার সময় `hashCode()` এবং `equals()` ওভাররাইড না করলে ম্যাপ লুকআপ ফেইল করে।"
          },
          {
            "title": "২. ম্যাপে থাকার সময় কী (Key) অবজেক্ট মিউটেট করা",
            "desc": "হ্যাশ ম্যাপে সেভ করার পর অবজেক্টের মান পরিবর্তন করলে তার হ্যাশ কোড বদলে ইন্টারনাল বাকেট নষ্ট হয়ে যায়।"
          },
          {
            "title": "৩. হ্যাশ কলিশনের কারণে ওয়ান (O(1)) থেকে O(N) এ অবনতি",
            "desc": "খারাপ হ্যাশ ফাংশনের কারণে সব মান একটি বাকেটে জমা হলে O(1) অপারেশনের সুবিধা নষ্ট হয়।"
          },
          {
            "title": "৪. Two Sum এ চেক করার আগে মান পুশ করার ভুল",
            "desc": "`target - nums[i]` ম্যাপে খোঁজার আগেই বর্তমান সংখ্যাটি ম্যাপে পুশ করলে সংখ্যাটি নিজের সাথেই যোগফল পেয়ে যায়।"
          }
        ],
        roadmapStepsEn: [
          {
            "step": "Step 1",
            "title": "Understand Hash Function & Bucket Array Mapping",
            "desc": "Master hash code generation, bucket indexing, and key-value storage principles."
          },
          {
            "step": "Step 2",
            "title": "Master O(1) Average Operations & Collision Handling",
            "desc": "Master lookup O(1), insert O(1), delete O(1), separate chaining, and open addressing."
          },
          {
            "step": "Step 3",
            "title": "Master Frequency Counter & Set De-duplication Patterns",
            "desc": "Master character frequency maps, duplicate detection, and anagram string grouping."
          },
          {
            "step": "Step 4",
            "title": "Master Complement Search & Pair Matching",
            "desc": "Master Two Sum complement lookup (`target - x`) and pair matching in O(N) time."
          },
          {
            "step": "Step 5",
            "title": "Master Prefix Sum + Hash Map Pattern",
            "desc": "Master running prefix sum tracking to solve Subarray Sum Equals K in O(N) time."
          }
        ],
        roadmapStepsBn: [
          {
            "step": "ধাপ ১",
            "title": "হ্যাশ ফাংশন ও বাকেট অ্যারে ম্যাপিং",
            "desc": "হ্যাশ কোড জেনারেট, অ্যারে ইনডেক্সিং এবং কী-ভ্যালু পেয়ার কনসেপ্ট বোঝা।"
          },
          {
            "step": "ধাপ ২",
            "title": "O(1) গড়ে সমাধান ও কলিশন হ্যান্ডলিং",
            "desc": "লুকআপ, ইনসার্ট, ডিলেট এবং সেপারেট চেইনিং অ্যালগরিদম শেখা।"
          },
          {
            "step": "ধাপ ৩",
            "title": "ফ্রিকোয়েন্সি কাউন্টার ও ইউনিক সেট ডি-ডুপ্লিকেশন",
            "desc": "ফ্রিকোয়েন্সি ম্যাপ, ডুপ্লিকেট সংখ্যা শনাক্ত এবং অ্যানাগ্রাম গ্রুপ তৈরি।"
          },
          {
            "step": "ধাপ ৪",
            "title": "কমপ্লিমেন্ট সার্চ ও টু-সাম জোড়া খোঁজা",
            "desc": "Two Sum কমপ্লিমেন্ট লুকআপ (`target - x`) এবং O(N) এ পেয়ার ম্যাচিং।"
          },
          {
            "step": "ধাপ ৫",
            "title": "প্রেফিক্স সাম + হ্যাশ ম্যাপ প্যাটার্ন",
            "desc": "রানিং প্রেফিক্স সাম ট্র্যাকিং দিয়ে সাব-অ্যারে সাম K অত্যন্ত সহজে সলভ করা।"
          }
        ],
      ),

      // 6. BINARY SEARCH TREE (BST)
      DsaTopic(
        id: 206,
        title: "Binary Search Tree (BST)",
        category: "Hierarchical Tree Structure",
        timeComplexity: "Search: O(log N) avg | Insert: O(log N) avg | Delete: O(log N) avg | Worst: O(N)",
        spaceComplexity: "O(N)",
        icon: Icons.account_tree_outlined,
        themeColor: const Color(0xFF06B6D4),
        descriptionEn:
            "A Binary Search Tree (BST) is a hierarchical node-based binary tree structure that strictly enforces the BST Invariant: for every node, all values in its Left Subtree are strictly smaller (`val < root->val`), and all values in its Right Subtree are strictly greater (`val > root->val`). This invariant allows Binary Search over dynamic data in average O(log N) logarithmic time. Inorder Traversal (`Left -> Root -> Right`) of a valid BST always yields a perfectly sorted array.",
        descriptionBn:
            "বাইনারি সার্চ ট্রি (BST) হলো একটি নোড-ভিত্তিক হায়ারার্কিকাল ট্রি ডেটা স্ট্রাকচার যা BST নিয়ম মেনে চলে: যেকোনো নোডের বাম সাবট্রির সমস্ত মান মূল রুটের চেয়ে ছোট (`val < root->val`) এবং ডান সাবট্রির সমস্ত মান মূল রুটের চেয়ে বড় (`val > root->val`) হয়। এই নিয়মের ফলে ডাইনামিক ডেটাতে O(log N) সময়ে অনুসন্ধান (Search) ও সংযোজন (Insert) করা যায়। একটি সঠিক BST এর Inorder Traversal করলে সব উপাদান ক্রমানুসারে (Sorted) পাওয়া যায়।",
        keyConceptsEn: [
          "BST Invariant: Every node satisfies Left Subtree < Node < Right Subtree.",
          "Inorder Sorted Property: Inorder Traversal (`Left -> Root -> Right`) visits BST values in strictly ascending sorted order.",
          "O(log N) Logarithmic Search: Halving search space at each level by branching left or right based on value comparison.",
          "Lowest Common Ancestor (LCA): Finding the lowest node where two target nodes `p` and `q` split into opposite subtrees."
        ],
        keyConceptsBn: [
          "BST নিয়ম: প্রতিটি নোডের বাম সাবট্রি < নোড < ডান সাবট্রি শর্ত মেনে চলা।",
          "Inorder সর্টেড বৈশিষ্ট্য: Inorder Traversal করলে BST এর সমস্ত মান ছোট থেকে বড় ক্রমানুসারে পাওয়া যায়।",
          "O(log N) অনুসন্ধান: প্রতিটি ধাপে মান তুলনা করে ডানে বা বামে গিয়ে সার্চ স্পেস অর্ধেক করা।",
          "Lowest Common Ancestor (LCA): যে সর্বনিম্ন নোডে দুটি লক্ষ্য নোড `p` ও `q` দুই দিকে আলাদা হয়ে যায়।"
        ],
        multiDimCodeTemplates: {
          "TreeNode Node Definition": {
            "C++": """
struct TreeNode {
    int val;
    TreeNode *left;
    TreeNode *right;
    TreeNode(int x) : val(x), left(nullptr), right(nullptr) {}
};""",
            "Java": """
class TreeNode {
    int val;
    TreeNode left;
    TreeNode right;
    TreeNode(int val) { this.val = val; }
}""",
            "Python": """
class TreeNode:
    def __init__(self, val=0, left=None, right=None):
        self.val = val
        self.left = left
        self.right = right""",
            "JavaScript": """
class TreeNode {
    constructor(val = 0, left = null, right = null) {
        this.val = val;
        this.left = left;
        this.right = right;
    }
}"""
          },
          "BST Inorder Traversal (Sorted)": {
            "C++": """
void inorder(TreeNode* root, vector<int>& res) {
    if (!root) return;
    inorder(root->left, res);
    res.push_back(root->val);
    inorder(root->right, res);
}""",
            "Java": """
public void inorder(TreeNode root, List<Integer> res) {
    if (root == null) return;
    inorder(root.left, res);
    res.add(root.val);
    inorder(root.right, res);
}""",
            "Python": """
def inorder(root, res):
    if not root: return
    inorder(root.left, res)
    res.append(root.val)
    inorder(root.right, res)""",
            "JavaScript": """
function inorder(root, res = []) {
    if (!root) return res;
    inorder(root.left, res);
    res.push(root.val);
    inorder(root.right, res);
    return res;
}"""
          }
        },
        basicProblems: [
          DsaProblem(
            id: "bst-1",
            title: "1. Search in a Binary Search Tree",
            category: "BST Search Basic",
            keyIdeaEn: "Compare `val` with `root->val`. If `val < root->val`, search left subtree. If `val > root->val`, search right subtree. If equal, return `root`.",
            keyIdeaBn: "মান রুটের সাথে তুলনা করুন। ছোট হলে বামে যান, বড় হলে ডানে যান। মিলে গেলে ওই নোডের পয়েন্টার রিটার্ন করুন।",
            codeCpp: """
TreeNode* searchBST(TreeNode* root, int val) {
    if (!root || root->val == val) return root;
    if (val < root->val) return searchBST(root->left, val);
    return searchBST(root->right, val);
}""",
            codeJava: """
public TreeNode searchBST(TreeNode root, int val) {
    if (root == null || root.val == val) return root;
    if (val < root.val) return searchBST(root.left, val);
    return searchBST(root.right, val);
}""",
            codePython: """
def searchBST(root: Optional[TreeNode], val: int) -> Optional[TreeNode]:
    if not root or root.val == val:
        return root
    if val < root.val:
        return searchBST(root.left, val)
    return searchBST(root.right, val)""",
            codeJs: """
function searchBST(root, val) {
    if (!root || root.val === val) return root;
    if (val < root.val) return searchBST(root.left, val);
    return searchBST(root.right, val);
}""",
            descriptionEn: "Find the node in a Binary Search Tree that matches a target value in average O(log N) time.",
            descriptionBn: "একটি বাইনারি সার্চ ট্রি থেকে টার্গেট মানের নোডটি ওয়ান (O(log N)) টাইমে খুঁজে বের করুন।",
            sampleInputs: ["root = [4, 2, 7, 1, 3], val = 2"],
            sampleOutputs: ["Subtree = [2, 1, 3]"],
          ),
          DsaProblem(
            id: "bst-2",
            title: "2. Insert into a Binary Search Tree",
            category: "BST Mutation Pattern",
            keyIdeaEn: "Traverse tree comparing insertion value. Reaching a `nullptr` spot, create and return new `TreeNode(val)` attached to parent.",
            keyIdeaBn: "ট্রি ট্রাভার্স করে খালি নাল (`nullptr`) স্থান খুঁজে নিয়ে সেখানে নতুন `TreeNode(val)` যোগ করুন।",
            codeCpp: """
TreeNode* insertIntoBST(TreeNode* root, int val) {
    if (!root) return new TreeNode(val);
    if (val < root->val) root->left = insertIntoBST(root->left, val);
    else root->right = insertIntoBST(root->right, val);
    return root;
}""",
            codeJava: """
public TreeNode insertIntoBST(TreeNode root, int val) {
    if (root == null) return new TreeNode(val);
    if (val < root.val) root.left = insertIntoBST(root.left, val);
    else root.right = insertIntoBST(root.right, val);
    return root;
}""",
            codePython: """
def insertIntoBST(root: Optional[TreeNode], val: int) -> Optional[TreeNode]:
    if not root:
        return TreeNode(val)
    if val < root.val:
        root.left = insertIntoBST(root.left, val)
    else:
        root.right = insertIntoBST(root.right, val)
    return root""",
            codeJs: """
function insertIntoBST(root, val) {
    if (!root) return new TreeNode(val);
    if (val < root.val) root.left = insertIntoBST(root.left, val);
    else root.right = insertIntoBST(root.right, val);
    return root;
}""",
            descriptionEn: "Insert a new key into a Binary Search Tree while preserving the BST property.",
            descriptionBn: "BST নিয়ম বজায় রেখে একটি নতুন মান সঠিক স্থানে ইনসার্ট করুন।",
            sampleInputs: ["root = [4, 2, 7, 1, 3], val = 5"],
            sampleOutputs: ["root = [4, 2, 7, 1, 3, 5]"],
          ),
          DsaProblem(
            id: "bst-3",
            title: "3. Validate Binary Search Tree",
            category: "BST Invariant Pattern",
            keyIdeaEn: "Recursively validate `validate(node, minBound, maxBound)`. Left child must be `< node.val`; right child must be `> node.val`.",
            keyIdeaBn: "রিকার্সিভলি প্রতিটি নোডের সীমানা (`minBound < node.val < maxBound`) ভ্যালিডেট করুন।",
            codeCpp: """
bool validate(TreeNode* node, long minBound, long maxBound) {
    if (!node) return true;
    if (node->val <= minBound || node->val >= maxBound) return false;
    return validate(node->left, minBound, node->val) &&
           validate(node->right, node->val, maxBound);
}
bool isValidBST(TreeNode* root) {
    return validate(root, LONG_MIN, LONG_MAX);
}""",
            codeJava: """
public boolean validate(TreeNode node, Integer min, Integer max) {
    if (node == null) return true;
    if ((min != null && node.val <= min) || (max != null && node.val >= max)) return false;
    return validate(node.left, min, node.val) && validate(node.right, node.val, max);
}
public boolean isValidBST(TreeNode root) {
    return validate(root, null, null);
}""",
            codePython: """
def isValidBST(root: Optional[TreeNode]) -> bool:
    def validate(node, low=float('-inf'), high=float('inf')):
        if not node: return True
        if node.val <= low or node.val >= high: return False
        return validate(node.left, low, node.val) and validate(node.right, node.val, high)
    return validate(root)""",
            codeJs: """
function isValidBST(root) {
    function validate(node, min = -Infinity, max = Infinity) {
        if (!node) return true;
        if (node.val <= min || node.val >= max) return false;
        return validate(node.left, min, node.val) && validate(node.right, node.val, max);
    }
    return validate(root);
}""",
            descriptionEn: "Determine if a binary tree is a valid Binary Search Tree using min/max range constraints.",
            descriptionBn: "একটি বাইনারি ট্রি সঠিক BST নিয়ম অনুসরণ করছে কিনা তা মিনিমাম/ম্যাক্সিমাম রেঞ্জ চেক করে যাচাই করুন।",
            sampleInputs: ["root = [2, 1, 3]", "root = [5, 1, 4, null, null, 3, 6]"],
            sampleOutputs: ["True", "False"],
          ),
          DsaProblem(
            id: "bst-4",
            title: "4. Lowest Common Ancestor (LCA) in a BST",
            category: "BST Navigation Pattern",
            keyIdeaEn: "If both `p` and `q` are smaller than `root`, go left. If both are greater, go right. The split node is the Lowest Common Ancestor!",
            keyIdeaBn: "যদি `p` ও `q` উভয়েই রুটের চেয়ে ছোট হয় বামে যান, বড় হলে ডানে যান। যে নোডে দুটি মান দুই দিকে ভাগ হয়ে যায় সেটিই LCA!",
            codeCpp: """
TreeNode* lowestCommonAncestor(TreeNode* root, TreeNode* p, TreeNode* q) {
    if (p->val < root->val && q->val < root->val)
        return lowestCommonAncestor(root->left, p, q);
    if (p->val > root->val && q->val > root->val)
        return lowestCommonAncestor(root->right, p, q);
    return root;
}""",
            codeJava: """
public TreeNode lowestCommonAncestor(TreeNode root, TreeNode p, TreeNode q) {
    if (p.val < root.val && q.val < root.val)
        return lowestCommonAncestor(root.left, p, q);
    if (p.val > root.val && q.val > root.val)
        return lowestCommonAncestor(root.right, p, q);
    return root;
}""",
            codePython: """
def lowestCommonAncestor(root: 'TreeNode', p: 'TreeNode', q: 'TreeNode') -> 'TreeNode':
    if p.val < root.val and q.val < root.val:
        return lowestCommonAncestor(root.left, p, q)
    if p.val > root.val and q.val > root.val:
        return lowestCommonAncestor(root.right, p, q)
    return root""",
            codeJs: """
function lowestCommonAncestor(root, p, q) {
    if (p.val < root.val && q.val < root.val)
        return lowestCommonAncestor(root.left, p, q);
    if (p.val > root.val && q.val > root.val)
        return lowestCommonAncestor(root.right, p, q);
    return root;
}""",
            descriptionEn: "Find the lowest common ancestor node of two given nodes p and q in a BST.",
            descriptionBn: "একটি BST এর যেকোনো দুটি নোড p ও q এর সর্বনিম্ন সাধারণ পূর্বপুরুষ (LCA) নোড বের করুন।",
            sampleInputs: ["root = [6, 2, 8, 0, 4, 7, 9], p = 2, q = 8"],
            sampleOutputs: ["LCA Node = 6"],
          ),
        ],
        commonMistakesEn: [
          {
            "title": "1. Validating Only Immediate Parent-Child Relationship",
            "desc": "Checking `node.left < node` and `node.right > node` locally is insufficient. All nodes in right subtree must be strictly greater than root."
          },
          {
            "title": "2. Degeneration into Skewed Linked List (O(N) Worst Case)",
            "desc": "Inserting sorted data `1, 2, 3, 4, 5` into an unbalanced BST degenerates tree height to O(N), ruining O(log N) performance."
          },
          {
            "title": "3. Null Pointer Dereference on Missing Subtrees",
            "desc": "Traversing `curr.left.val` without verifying `curr.left != null` causes NullPointerException."
          },
          {
            "title": "4. Duplicate Values Handling Bug",
            "desc": "Forgetting to define explicit rules for duplicate values (strictly less `<` vs `<=`) causes infinite loops or invalid node placements."
          }
        ],
        commonMistakesBn: [
          {
            "title": "১. কেবল রুট ও চাইল্ডের সাময়িক মান চেক করার ভুল",
            "desc": "শুধু `node.left < node` চেক করা ভুল; ডান সাবট্রির সমস্ত নোডের মান মূল রুটের চেয়ে বড় হতে হবে।"
          },
          {
            "title": "২. আনব্যালেন্সড ট্রিতে ওয়ান (O(N)) এ অবনতি",
            "desc": "সর্টেড ডেটা `1, 2, 3, 4, 5` ইনসার্ট করলে BST স্কিউড লিঙ্কড লিস্টের রূপ নেয় এবং O(log N) স্পিড নষ্ট হয়।"
          },
          {
            "title": "৩. নাল চাইল্ড পয়েন্টার চেক না করা",
            "desc": "`curr.left != null` চেক না করে `curr.left.val` ডাইরেক্ট অ্যাক্সেস করলে অ্যাপ ক্র্যাশ করা।"
          },
          {
            "title": "৪. ডুপ্লিকেট মানের শর্ত মিস হওয়া",
            "desc": "সমান মান পাওয়ার কন্ডিশন না রাখলে ইনফিনিট লুপ তৈরি হওয়া।"
          }
        ],
        roadmapStepsEn: [
          {
            "step": "Step 1",
            "title": "Understand BST Invariant (Left Subtree < Root < Right Subtree)",
            "desc": "Master BST structural invariant and tree height logarithmic bounds."
          },
          {
            "step": "Step 2",
            "title": "Master Search O(log N) and Insert O(log N) Traversals",
            "desc": "Master tree searching, node insertion, and recursion/iteration patterns."
          },
          {
            "step": "Step 3",
            "title": "Master Inorder Traversal (Sorted Output Generation)",
            "desc": "Master Inorder (`Left -> Root -> Right`) to output sorted tree values."
          },
          {
            "step": "Step 4",
            "title": "Master Tree Range Validation & Bounded Min/Max Constraints",
            "desc": "Master valid BST detection using range bounds `(minBound, maxBound)`."
          },
          {
            "step": "Step 5",
            "title": "Master Lowest Common Ancestor (LCA) & Deletion",
            "desc": "Master split point navigation for LCA and Hibbard Deletion node replacement."
          }
        ],
        roadmapStepsBn: [
          {
            "step": "ধাপ ১",
            "title": "BST নিয়ম (বাম সাবট্রি < রুট < ডান সাবট্রি) বোঝা",
            "desc": "BST এর মূল নিয়ম এবং ট্রি হাইটের লগারিমিক স্পিড কনসেপ্ট বোঝা।"
          },
          {
            "step": "ধাপ ২",
            "title": "খোঁজা (Search) ও সংযোজন (Insert) ট্রাভার্সাল",
            "desc": "O(log N) সময়ে অনুসন্ধান এবং নতুন নোড সঠিক স্থানে যুক্ত করা।"
          },
          {
            "step": "ধাপ ৩",
            "title": "Inorder Traversal (সর্টেড ডেটা তৈরি)",
            "desc": "Inorder (`Left -> Root -> Right`) ট্রাভার্সাল করে ট্রি ডেটা ছোট থেকে বড় সাজানো।"
          },
          {
            "step": "ধাপ ৪",
            "title": "মিনিমাম/ম্যাক্সিমাম বাউন্ড দিয়ে BST ভ্যালিডেশন",
            "desc": "রিকার্সিভ সীমানা `(minBound, maxBound)` ব্যবহার করে ভ্যালিড BST নির্ণয়।"
          },
          {
            "step": "ধাপ ৫",
            "title": "Lowest Common Ancestor (LCA) ও নোড ডিলেশন",
            "desc": "LCA সপ্লিট পয়েন্ট নেভিগেশন এবং নোড ডিলেট করার অ্যালগরিদম শেখা।"
          }
        ],
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
