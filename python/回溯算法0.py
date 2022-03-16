"""
回溯问题其实就是一个决策树遍历过程
1. 路径：已经做出的选择
2. 选择列表：当前可以做的选择
3. 结束条件：到达决策树底层，无法再做选择的条件

** 代码框架 **
** 核心：for循环里的递归 **

result = []
def backtrack(road, option_list):
    if 满足条件:
        result.add(road)
        return

    for 选择 in option_list:
        做选择 (
            将该选择从optionlist移除；
            路径.add(选择)； 
            backtrack(road, option_list
            )
        self.backtrack(road, option_list)
        撤销选择 (
            路径.remove(选择)
            将该选择再加入选择列表
        )


** 多叉树遍历框架 **
void traverse(TreeNode root) {

    for (TreeNode child : root.childern)

        // 前序遍历需要的操作

        traverse(child);

        // 后序遍历需要的操作

}

# 前序遍历的代码在进入某一个节点之前的那个时间点执行，
# 后序遍历代码在离开某个节点之后的那个时间点执行。
"""


## 全排列
## 46. Permutations


class Solution:
    def permute(self, nums: List[int]) -> List[List[int]]:
        def backtrack(nums, track, used):
            """
            track: road
            option_list: those not in track
            end_criteria: len(nums) == len(track)
            used: bool
            """

            # 退出条件：nums所有的元素都进入了track
            if len(track) == len(nums):
                res.append(track[:])
                # 注意python的拷贝问题！！！

            for i in range(len(nums)):
                if used[i]:
                    # 如果这个num已经用过了，就跳过
                    continue

                # 做选择
                track.append(nums[i])
                used[i] = True
                # 进入下一层决策树
                backtrack(nums, track, used)

                # 取消选择
                track.pop()
                used[i] = False

        res = []
        track = []
        used = [False] * len(nums)
        backtrack(nums, track, used)
        return res


# O(n^n)

## Solution 2
class Solution:
    def permute(self, nums: List[int]) -> List[List[int]]:
        res = []
        n = len(nums)

        def backtrack(x, n):
            # x是res的index， 从左往右遍历到n为止

            # 结束条件
            if x == n:
                res.append(nums[:])

            for i in range(x, n):
                # permute
                # x这个数跟后面所有数都换一遍
                nums[x], nums[i] = nums[i], nums[x]

                # next integer
                backtrack(x + 1, n)

                # permute back
                nums[x], nums[i] = nums[i], nums[x]

        backtrack(0, n)
        return res


# O(n! * n)

# be careful about append! make sure you append
# only the number! but not the address!
# The following is a wrong example
# l78z = []
# nums_temp = nums
# l78z.append(nums_temp)
# nums_temp[0] = 3
# print(l78z)


#### N皇后
class Solution:
    def solveNQueens(self, n: int) -> List[List[str]]:
        board = [["."] * n for rows in range(n)]  # init the board
        self.n = n
        res = []

        def is_valid(board, row, col):
            # n = self.n

            # 检查过去的row有没有填过这列col
            for i in range(row):
                if board[i][col] == "Q":
                    return False
            # 检查左上方
            i = row - 1
            j = col - 1
            while i >= 0 and j >= 0:
                if board[i][j] == "Q":
                    return False
                i -= 1
                j -= 1

            # 检查右上方
            i = row - 1
            j = col + 1
            while i >= 0 and j < n:
                if board[i][j] == "Q":
                    return False
                i -= 1
                j += 1

            return True

        def backtrack(board, row):
            """
            父节点Q已存在 (r, c)
            斜对角，同行，同列不能出现:col.used
            避免同行：遍历row
            避免同列：col_used, continue
            避免斜对角：只用看左上角右上角
            """
            # trace: board中小于row的行都放了皇后
            # 选择列表：第row行所有列
            # 结束条件：row超过board最后一行

            # n = self.n

            # exit
            if row == n:
                res.append(["".join(b) for b in board])

                return

            for col in range(n):
                # exclude under restrictions
                if not is_valid(board, row, col):
                    continue

                board[row][col] = "Q"
                backtrack(board, row + 1)
                board[row][col] = "."

        backtrack(board, 0)

        return res
