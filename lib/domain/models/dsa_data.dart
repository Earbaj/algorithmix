import 'package:flutter/material.dart';

class DsaProblem {
  final String id;
  final String title;
  final String category; // e.g. "1D Array", "2D Matrix", "3D Array"
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
  final Map<String, Map<String, String>> multiDimCodeTemplates; // Dimension (1D, 2D, 3D) -> (Language -> Code)
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
      // 1. ARRAYS & DYNAMIC LISTS (1D, 2D, 3D)
      DsaTopic(
        id: 201,
        title: "Arrays & Dynamic Lists",
        category: "Linear & Multi-Dimensional Structure",
        timeComplexity: "Access O(1) | Search O(N) | Insertion O(N)",
        spaceComplexity: "1D: O(N) | 2D: O(R×C) | 3D: O(D×R×C)",
        icon: Icons.view_column_outlined,
        themeColor: const Color(0xFF3B82F6),
        descriptionEn:
            "An Array is a contiguous memory allocation storing elements of the same type. It supports 1D Lists, 2D Matrices/Grids, and 3D Cubes/Tensors. Dynamic arrays automatically double capacity when full, maintaining amortized O(1) insertion while supporting instant O(1) index access via Base Address arithmetic: Address(i) = Base + (i * size).",
        descriptionBn:
            "মেমোরিতে পরপর (Contiguous) সাজানো একই ধরনের উপাদানের স্ট্রাকচার। এটি ১D লিনিয়ার লিস্ট, ২D গ্রিড/ম্যাট্রিক্স এবং ৩D কিউব/টেনসর সাপোর্ট করে। ডাইনামিক অ্যারে মেমোরি ফুল হলে ক্যাপাসিটি দ্বিগুণ করে। বেস এড্রেস সূত্র Address(i) = Base + (i * size) ব্যবহার করে সরাসরি O(1) সময়ে যেকোনো ইন্ডেক্সে অ্যাক্সেস করা যায়।",
        keyConceptsEn: [
          "1D Dynamic Array: Sequential memory layout with Base + (i * elementSize) direct O(1) indexing.",
          "2D Matrix / Grid: Row-major allocation `arr[row][col]`. Memory offset = Base + (row * cols + col) * size.",
          "3D Cube / Tensor: Multi-layered 3-axis collection `arr[depth][row][col]` used for spatial data & image channels.",
          "Static Array vs Dynamic List: Static has fixed length at compile time; Dynamic resizes automatically (1 -> 2 -> 4 -> 8).",
          "Cache Locality: Contiguous memory bytes pre-fetched together into CPU L1/L2 cache lines for ultra-fast traversal."
        ],
        keyConceptsBn: [
          "১D ডাইনামিক অ্যারে: পরপর মেমোরি সাজানো, Base + (i * size) দিয়ে সরাসরি O(1) ইন্ডেক্সিং।",
          "২D ম্যাট্রিক্স/গ্রিড: Row-major লেআউট `arr[row][col]`। মেমোরি অফসেট = Base + (row * cols + col) * size।",
          "৩D কিউব/টেনসর: ৩টি অক্ষ বিশিষ্ট লেয়ার্ড কালেকশন `arr[depth][row][col]`, যা স্পেশিয়াল ডেটা ও ইমেজ প্রসেসিংয়ে ব্যবহৃত হয়।",
          "স্ট্যাটিক বনাম ডাইনামিক: স্ট্যাটিকের দৈর্ঘ্য নির্দিষ্ট; ডাইনামিক স্বয়ংক্রিয়ভাবে মেমোরি ডাবল করে বাড়ায় (১ -> ২ -> ৪ -> ৮)।",
          "ক্যাশ লোকালিটি: কনটিগুয়াস মেমোরি হওয়ার কারণে CPU L1/L2 ক্যাশে ডাটা দ্রুত প্রি-ফেচ হয়ে ট্রাভার্সাল স্পিড বাড়ায়।"
        ],
        multiDimCodeTemplates: {
          "1D Array": {
            "C++": """
#include <iostream>
#include <vector>
using namespace std;

int main() {
    // 1D Static Array
    int staticArr[5] = {10, 20, 30, 40, 50};
    
    // 1D Dynamic List (vector)
    vector<int> dynamicArr = {10, 20, 30};
    dynamicArr.push_back(40); // Amortized O(1) append
    
    cout << "1D Index 2 Value: " << dynamicArr[2] << endl;
    return 0;
}""",
            "Java": """
import java.util.ArrayList;

public class OneDArray {
    public static void main(String[] args) {
        // 1D Primitive Array
        int[] staticArr = {10, 20, 30, 40};
        
        // 1D Dynamic List
        ArrayList<Integer> dynamicList = new ArrayList<>();
        dynamicList.add(10); dynamicList.add(20);
        
        System.out.println("1D Index 1: " + dynamicList.get(1));
    }
}""",
            "Python": """
# 1D Dynamic List in Python
arr1d = [10, 20, 30, 40]

# O(1) Direct Access
print("1D Index 2:", arr1d[2])

# Amortized O(1) Append
arr1d.append(50)""",
            "JavaScript": """
// 1D Array in JavaScript
const arr1d = [10, 20, 30, 40];

// O(1) Access
console.log("1D Index 2:", arr1d[2]);
arr1d.push(50);"""
          },
          "2D Array (Matrix)": {
            "C++": """
#include <iostream>
#include <vector>
using namespace std;

int main() {
    // 2D Matrix (3 Rows x 4 Columns)
    int rows = 3, cols = 4;
    vector<vector<int>> matrix(rows, vector<int>(cols, 0));
    
    // Assign values
    matrix[0][0] = 5;
    matrix[1][2] = 15;
    matrix[2][3] = 25;
    
    // Iterate 2D Grid
    for (int r = 0; r < rows; r++) {
        for (int c = 0; c < cols; c++) {
            cout << matrix[r][c] << " ";
        }
        cout << endl;
    }
    return 0;
}""",
            "Java": """
public class TwoDMatrix {
    public static void main(String[] args) {
        // 2D Array (3x3 Grid)
        int[][] matrix = {
            {1, 2, 3},
            {4, 5, 6},
            {7, 8, 9}
        };
        
        // Access row 1, col 2 -> 6
        System.out.println("2D [1][2]: " + matrix[1][2]);
    }
}""",
            "Python": """
# 2D Matrix (3x3)
matrix = [
    [1, 2, 3],
    [4, 5, 6],
    [7, 8, 9]
]

# Access row 1, col 2 -> 6
print("2D [1][2]:", matrix[1][2])

# Dynamic 2D Matrix Creation (Rows x Cols)
r, c = 3, 4
grid = [[0] * c for _ in range(r)]""",
            "JavaScript": """
// 2D Matrix
const matrix = [
    [1, 2, 3],
    [4, 5, 6],
    [7, 8, 9]
];

console.log("2D [1][2]:", matrix[1][2]);"""
          },
          "3D Array (Tensor / Cube)": {
            "C++": """
#include <iostream>
#include <vector>
using namespace std;

int main() {
    // 3D Tensor: Depth x Rows x Cols (2 x 3 x 3)
    int depth = 2, rows = 3, cols = 3;
    vector<vector<vector<int>>> cube(depth, vector<vector<int>>(rows, vector<int>(cols, 0)));
    
    // Assign value in Layer 1, Row 2, Col 0
    cube[1][2][0] = 99;
    
    cout << "3D Element [1][2][0]: " << cube[1][2][0] << endl;
    return 0;
}""",
            "Java": """
public class ThreeDCube {
    public static void main(String[] args) {
        // 3D Array [Depth][Row][Col] (2 x 3 x 3)
        int[][][] cube = new int[2][3][3];
        cube[0][1][2] = 42;
        cube[1][2][1] = 88;
        
        System.out.println("3D [0][1][2]: " + cube[0][1][2]);
    }
}""",
            "Python": """
# 3D Tensor / Cube [Depth][Row][Col]
cube = [
    [[1, 2], [3, 4]], # Layer 0
    [[5, 6], [7, 8]]  # Layer 1
]

print("3D [1][0][1]:", cube[1][0][1]) # Output: 6""",
            "JavaScript": """
// 3D Array [Depth][Row][Col]
const cube = [
    [[1, 2], [3, 4]], // Layer 0
    [[5, 6], [7, 8]]  # Layer 1
];

console.log("3D [1][0][1]:", cube[1][0][1]);"""
          }
        },
        basicProblems: [
          DsaProblem(
            id: "basic-1",
            title: "1. Find Minimum and Maximum in Array",
            category: "1D Array Basic",
            keyIdeaEn: "Initialize min & max with first element, iterate array once updating min/max.",
            keyIdeaBn: "প্রথম উপাদান দিয়ে min ও max ধরে অ্যারে ১ বার লুপ করে আপডেট করুন।",
            codeCpp: """
pair<int, int> findMinMax(vector<int>& arr) {
    int minVal = arr[0], maxVal = arr[0];
    for (int num : arr) {
        if (num < minVal) minVal = num;
        if (num > maxVal) maxVal = num;
    }
    return {minVal, maxVal};
}""",
            codeJava: """
public static int[] findMinMax(int[] arr) {
    int min = arr[0], max = arr[0];
    for (int num : arr) {
        if (num < min) min = num;
        if (num > max) max = num;
    }
    return new int[]{min, max};
}""",
            codePython: """
def findMinMax(arr):
    min_val, max_val = arr[0], arr[0]
    for num in arr:
        if num < min_val: min_val = num
        if num > max_val: max_val = num
    return min_val, max_val""",
            codeJs: """
function findMinMax(arr) {
    let min = arr[0], max = arr[0];
    for (let num of arr) {
        if (num < min) min = num;
        if (num > max) max = num;
    }
    return [min, max];
}""",
            descriptionEn: "Find the smallest and largest numbers in a 1D array in O(N) time.",
            descriptionBn: "১D অ্যারের সবচেয়ে ছোট এবং সবচেয়ে বড় সংখ্যাটি বের করুন।",
            sampleInputs: ["arr = [15, 42, 8, 99, 23]"],
            sampleOutputs: ["Min: 8, Max: 99"],
          ),
          DsaProblem(
            id: "basic-2",
            title: "2. Reverse Array In-Place",
            category: "1D Array Basic",
            keyIdeaEn: "Two pointers (left at 0, right at N-1). Swap elements while left < right.",
            keyIdeaBn: "বাম (0) এবং ডান (N-1) দুই পয়েন্টার দিয়ে মাঝামাঝি মিট করা পর্যন্ত Swap করুন।",
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
        [arr[left], arr[right]] = [arr[right], arr[left]];
        left++; right--;
    }
}""",
            descriptionEn: "Reverse a 1D array in-place without using extra memory allocation.",
            descriptionBn: "কোনো অতিরিক্ত মেমোরি ব্যবহার না করে অ্যারেটি উল্টে ফেলুন।",
            sampleInputs: ["arr = [1, 2, 3, 4, 5]"],
            sampleOutputs: ["[5, 4, 3, 2, 1]"],
          ),
          DsaProblem(
            id: "basic-3",
            title: "3. Transpose of a 2D Matrix",
            category: "2D Matrix Basic",
            keyIdeaEn: "Swap matrix[i][j] with matrix[j][i] for all i < j.",
            keyIdeaBn: "ম্যাট্রিক্সের সারির উপাদানকে কলামে এবং কলামকে সারিতে রুপান্তর (matrix[i][j] <-> matrix[j][i]) করুন।",
            codeCpp: """
vector<vector<int>> transpose(vector<vector<int>>& matrix) {
    int r = matrix.size(), c = matrix[0].size();
    vector<vector<int>> result(c, vector<int>(r));
    for (int i = 0; i < r; i++) {
        for (int j = 0; j < c; j++) {
            result[j][i] = matrix[i][j];
        }
    }
    return result;
}""",
            codeJava: """
public static int[][] transpose(int[][] matrix) {
    int r = matrix.length, c = matrix[0].length;
    int[][] res = new int[c][r];
    for (int i = 0; i < r; i++) {
        for (int j = 0; j < c; j++) {
            res[j][i] = matrix[i][j];
        }
    }
    return res;
}""",
            codePython: """
def transpose(matrix):
    r, c = len(matrix), len(matrix[0])
    res = [[0] * r for _ in range(c)]
    for i in range(r):
        for j in range(c):
            res[j][i] = matrix[i][j]
    return res""",
            codeJs: """
function transpose(matrix) {
    let r = matrix.length, c = matrix[0].length;
    let res = Array.from({length: c}, () => Array(r).fill(0));
    for (let i = 0; i < r; i++) {
        for (let j = 0; j < c; j++) {
            res[j][i] = matrix[i][j];
        }
    }
    return res;
}""",
            descriptionEn: "Flip a 2D matrix over its diagonal, switching row and column indices.",
            descriptionBn: "একটি ২D ম্যাট্রিক্সের সারি ও কলাম অদলবদল করে ট্রান্সপোজ ম্যাট্রিক্স গঠন করুন।",
            sampleInputs: ["matrix = [[1,2,3],[4,5,6]]"],
            sampleOutputs: ["[[1,4],[2,5],[3,6]]"],
          ),
          DsaProblem(
            id: "basic-4",
            title: "4. Calculate 3D Tensor Layer Sum",
            category: "3D Array Basic",
            keyIdeaEn: "Iterate through 3D indices `[depth][row][col]` summing all elements for each depth layer.",
            keyIdeaBn: "৩D ট্রিপল লুপ চালিয়ে প্রতিটি ডেপথ লেয়ারের সব উপাদানের যোগফল হিসাব করুন।",
            codeCpp: """
vector<int> layerSums(vector<vector<vector<int>>>& cube) {
    vector<int> sums;
    for (int d = 0; d < cube.size(); d++) {
        int currentSum = 0;
        for (int r = 0; r < cube[d].size(); r++) {
            for (int c = 0; c < cube[d][r].size(); c++) {
                currentSum += cube[d][r][c];
            }
        }
        sums.push_back(currentSum);
    }
    return sums;
}""",
            codeJava: """
public static int[] layerSums(int[][][] cube) {
    int[] sums = new int[cube.length];
    for (int d = 0; d < cube.length; d++) {
        int sum = 0;
        for (int r = 0; r < cube[d].length; r++) {
            for (int c = 0; c < cube[d][r].length; c++) {
                sum += cube[d][r][c];
            }
        }
        sums[d] = sum;
    }
    return sums;
}""",
            codePython: """
def layerSums(cube):
    sums = []
    for layer in cube:
        layer_sum = sum(sum(row) for row in layer)
        sums.append(layer_sum)
    return sums""",
            codeJs: """
function layerSums(cube) {
    return cube.map(layer => 
        layer.reduce((sum, row) => sum + row.reduce((a, b) => a + b, 0), 0)
    );
}""",
            descriptionEn: "Compute total element sum for each 2D slice layer inside a 3D Cube.",
            descriptionBn: "একটি ৩D কিউবের প্রতিটি ২D স্লাইস লেয়ারের উপাদানগুলোর যোগফল নির্ণয় করুন।",
            sampleInputs: ["cube = [[[1,2],[3,4]], [[5,6],[7,8]]]"],
            sampleOutputs: ["Layer 0 Sum: 10, Layer 1 Sum: 26"],
          ),
        ],
        commonMistakesEn: [
          {
            "title": "1. Off-by-One Boundary Errors",
            "desc": "Accessing index `N` instead of `N-1` in 1D array triggers Out of Bounds runtime crash."
          },
          {
            "title": "2. 2D Matrix Row/Col Index Swapping",
            "desc": "Confusing row index `r` with col index `c` in `matrix[r][c]` causes IndexOutOfBoundsException when rows != cols."
          },
          {
            "title": "3. Uninitialized 3D Array Dimension Access",
            "desc": "Accessing `cube[d][r][c]` before initializing inner row/col arrays leads to NullPointerException."
          },
          {
            "title": "4. Inefficient Element Shifting inside Loop",
            "desc": "Inserting or deleting at index 0 inside an N-iteration loop causes hidden O(N²) quadratic time complexity."
          }
        ],
        commonMistakesBn: [
          {
            "title": "১. Off-by-One বাউন্ডারি ভুল",
            "desc": "১D অ্যারের শেষ ইনডেক্স `N-1` এর বদলে `N` দিয়ে মান পড়তে গেলে প্রোগ্রাম ক্র্যাশ করে (Segmentation Fault)।"
          },
          {
            "title": "২. ২D ম্যাট্রিক্সে Row ও Col ওলোটপালোট",
            "desc": "`matrix[r][c]` এ সারি `r` এবং কলাম `c` মিলাতে ভুল করলে (বিশেষ করে রিক্ট্যাঙ্গুলার ম্যাট্রিক্সে) ইনডেক্স ভুল দেখায়।"
          },
          {
            "title": "৩. ৩D অ্যারে ইনিশিয়ালাইজ না করেই এক্সেস",
            "desc": "৩D কিউবে ভেতরের লেয়ার/রো ইনিশিয়ালাইজ না করে `cube[d][r][c]` অ্যাক্সেস করলে NullPointerException হয়।"
          },
          {
            "title": "৪. লুপের ভেতর বারবার Element Shift করা",
            "desc": "লুপের মধ্যে `insert(0)` বা `remove(0)` করলে পুরো অ্যারে ডানে/বামে সরাতে হয়, ফলে লুকানো O(N²) সময় নষ্ট হয়।"
          }
        ],
        roadmapStepsEn: [
          {
            "step": "Step 1",
            "title": "Master 1D Arrays & Base Address Arithmetic",
            "desc": "Understand direct index access `Address = Base + (i * elementSize)`, dynamic resizing doubling capacity."
          },
          {
            "step": "Step 2",
            "title": "Practice 1D Operations & Two Pointers",
            "desc": "Implement array reversal, min/max search, sliding window, and two pointer element swapping."
          },
          {
            "step": "Step 3",
            "title": "Understand 2D Matrices & Grid Traversal",
            "desc": "Master row-major memory order, matrix transpose, diagonal sum, and row-by-row traversal."
          },
          {
            "step": "Step 4",
            "title": "Explore 3D Tensors & Spatial Arrays",
            "desc": "Learn multi-axis depth layering `[depth][row][col]`, layer sums, and multi-dimensional loops."
          },
          {
            "step": "Step 5",
            "title": "Optimize Cache Locality & Memory Overhead",
            "desc": "Avoid shifting in loops, pre-allocate vector capacity `reserve()`, and write cache-friendly sequential loops."
          }
        ],
        roadmapStepsBn: [
          {
            "step": "ধাপ ১",
            "title": "১D অ্যারে ও বেস এড্রেস সূত্র শিখুন",
            "desc": "ডিরেক্ট ইন্ডেক্স এক্সেস `Address = Base + (i * size)` এবং ডাইনামিক ক্যাপাসিটি ডাবলিং কনসেপ্ট বুঝুন।"
          },
          {
            "step": "ধাপ ২",
            "title": "১D অপারেশন ও টু-পয়েন্টার প্র্যাকটিস",
            "desc": "ইন-প্লেস রিভার্সাল, min/max সার্চ, স্লাইডিং উইন্ডো এবং টু-পয়েন্টার এলিমেন্ট সোয়াপিং সমাধান করুন।"
          },
          {
            "step": "ধাপ ৩",
            "title": "২D ম্যাট্রিক্স ও গ্রিড ট্রাভার্সাল আয়ত্ত করুন",
            "desc": "Row-major মেমোরি লেআউট, ম্যাট্রিক্স ট্রান্সপোজ, ডায়াগনাল যোগফল এবং রো-বাই-রো লুপ ক্লিয়ার করুন।"
          },
          {
            "step": "ধাপ ৪",
            "title": "৩D টেনসর ও স্পেশিয়াল অ্যারে শিখুন",
            "desc": "মাল্টি-এক্সিস লেয়ারিং `[depth][row][col]`, লেয়ার সাম এবং ৩D ট্রিপল লুপ ট্রাভার্সাল আয়ত্ত করুন।"
          },
          {
            "step": "ধাপ ৫",
            "title": "ক্যাশ লোকালিটি ও মেমোরি অপ্টিমাইজেশন",
            "desc": "লুপের ভেতর শিফটিং এড়ানো, vector capacity `reserve()` করা এবং ক্যাশ-ফ্রেন্ডলি সিকোয়েনশিয়াল কোড লিখুন।"
          }
        ],
      ),

      // 2. LINKED LIST
      DsaTopic(
        id: 202,
        title: "Singly & Doubly Linked List",
        category: "Linear Data Structure",
        timeComplexity: "Insert/Delete O(1) | Access O(N)",
        spaceComplexity: "O(N)",
        icon: Icons.link_outlined,
        themeColor: const Color(0xFF8B5CF6),
        descriptionEn: "Linear sequence of node objects where each node stores data and pointer to next (and previous) node.",
        descriptionBn: "নোড অবজেক্টের লিনিয়ার সিকোয়েন্স, যেখানে প্রতিটি নোডে ডেটা এবং পরবর্তী নোডের পয়েন্টার থাকে।",
        keyConceptsEn: ["Node pointer reference traversal", "O(1) Head Insertion"],
        keyConceptsBn: ["পয়েন্টার ট্রাভার্সাল", "Head এ O(1) ইনসারশন"],
        multiDimCodeTemplates: {
          "Linked List": {
            "C++": "struct ListNode { int val; ListNode* next; };",
            "Java": "class ListNode { int val; ListNode next; }",
            "Python": "class ListNode: def __init__(self, val=0, next=None): self.val = val; self.next = next",
            "JavaScript": "class ListNode { constructor(val = 0, next = null) { this.val = val; this.next = next; } }"
          }
        },
        basicProblems: [],
        commonMistakesEn: [],
        commonMistakesBn: [],
        roadmapStepsEn: [],
        roadmapStepsBn: [],
      ),

      // 3. STACK
      DsaTopic(
        id: 203,
        title: "Stack (LIFO)",
        category: "Linear Data Structure",
        timeComplexity: "Push O(1) | Pop O(1)",
        spaceComplexity: "O(N)",
        icon: Icons.layers_outlined,
        themeColor: const Color(0xFF10B981),
        descriptionEn: "Last-In, First-Out container.",
        descriptionBn: "লাস্ট-ইন, ফার্স্ট-আউট কন্টেইনার।",
        keyConceptsEn: ["LIFO structure"],
        keyConceptsBn: ["LIFO নীতি"],
        multiDimCodeTemplates: {
          "Stack": {
            "C++": "stack<int> st; st.push(10); st.pop();",
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

      // 4. QUEUE
      DsaTopic(
        id: 204,
        title: "Queue (FIFO) & Deque",
        category: "Linear Data Structure",
        timeComplexity: "Enqueue O(1) | Dequeue O(1)",
        spaceComplexity: "O(N)",
        icon: Icons.swap_horizontal_circle_outlined,
        themeColor: const Color(0xFFF59E0B),
        descriptionEn: "First-In, First-Out pipeline.",
        descriptionBn: "ফার্স্ট-ইন, ফার্স্ট-আউট পাইপলাইন।",
        keyConceptsEn: ["FIFO discipline"],
        keyConceptsBn: ["FIFO নীতি"],
        multiDimCodeTemplates: {
          "Queue": {
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

      // 5. HASH TABLE
      DsaTopic(
        id: 205,
        title: "Hash Table & Hash Map",
        category: "Associative Array",
        timeComplexity: "Lookup O(1) avg",
        spaceComplexity: "O(N)",
        icon: Icons.grid_view_outlined,
        themeColor: const Color(0xFFEC4899),
        descriptionEn: "Key-Value lookup table.",
        descriptionBn: "কী-ভ্যালু পেয়ার লুপআপ টেবিল।",
        keyConceptsEn: ["Hash key mapping"],
        keyConceptsBn: ["হ্যাশ কী গণনা"],
        multiDimCodeTemplates: {
          "Hash Table": {
            "C++": "unordered_map<string, int> mp;",
            "Java": "HashMap<String, Integer> map = new HashMap<>();",
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

      // 6. BST
      DsaTopic(
        id: 206,
        title: "Binary Search Tree (BST)",
        category: "Hierarchical",
        timeComplexity: "Search O(log N)",
        spaceComplexity: "O(N)",
        icon: Icons.account_tree_outlined,
        themeColor: const Color(0xFF06B6D4),
        descriptionEn: "Left < Root < Right tree.",
        descriptionBn: "বাম পাশে ছোট ও ডান পাশে বড় মান।",
        keyConceptsEn: ["Ordered BST"],
        keyConceptsBn: ["সর্টেড বাইনারি ট্রি"],
        multiDimCodeTemplates: {
          "BST": {
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

      // 7. HEAP
      DsaTopic(
        id: 207,
        title: "Min & Max Heap (Priority Queue)",
        category: "Priority Structure",
        timeComplexity: "Peek O(1)",
        spaceComplexity: "O(N)",
        icon: Icons.unfold_more_double_outlined,
        themeColor: const Color(0xFF84CC16),
        descriptionEn: "Priority binary tree.",
        descriptionBn: "প্রাইওরিটি কিউ ট্র্যাকিং।",
        keyConceptsEn: ["Heap invariant"],
        keyConceptsBn: ["হিপ ইনভেরিয়েন্ট"],
        multiDimCodeTemplates: {
          "Heap": {
            "C++": "priority_queue<int> maxHeap;",
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
        category: "Non-Linear Network",
        timeComplexity: "BFS/DFS O(V + E)",
        spaceComplexity: "O(V + E)",
        icon: Icons.hub_outlined,
        themeColor: const Color(0xFF0284C7),
        descriptionEn: "Network of vertices and edges.",
        descriptionBn: "নোড এবং এজের গ্রাফ নেটওয়ার্ক।",
        keyConceptsEn: ["Graph BFS/DFS"],
        keyConceptsBn: ["গ্রাফ ট্রাভার্সাল"],
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
        category: "Advanced Tree",
        timeComplexity: "Search O(L)",
        spaceComplexity: "O(N * L)",
        icon: Icons.sort_by_alpha_outlined,
        themeColor: const Color(0xFFA855F7),
        descriptionEn: "Character prefix tree.",
        descriptionBn: "অক্ষরভিত্তিক প্রিফিক্স ট্রি।",
        keyConceptsEn: ["Prefix tree branches"],
        keyConceptsBn: ["শব্দ খোঁজার ট্রি"],
        multiDimCodeTemplates: {
          "Trie": {
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
