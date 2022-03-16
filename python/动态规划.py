"""
-- 转移方程思考：

明确bad case -> 明确“状态” -> 明确“选择” -> 定义dp数组/函数含义

-- 框架：

# 初始化 base case

dp[0][0][...] = base

# 进行状态转移

for 状态1 in 状态1的所有取值：

    for 状态2 in 状态2的所有取值：

        for ...

            dp[状态1][状态2][...] = 求最值(选择1，选择2...)


"""

#### 斐波那契
# 509. Fibonacci Number
class Solution:
    """
    # Solution 0: 递归
    # 但是存在重叠子问题, 有节点的重复计算
    # o(2^n)
    def fib(self, n: int) -> int:
        if n <= 1:
            return n
        return self.fib(n-1) + self.fib(n-2)
    """
    
    # 备忘录递归：记录已经算过的子节点
    def helper(self, memo, n):
        # base case
        if n <= 1:
            return n
        if n in memo:
            return memo[n]
        memo[n] = self.helper(memo, n-1) + self.helper(memo, n-2)
        return memo[n]
        
    
    def fib(self, n: int) -> int:
        memo = {}
        
        return self.helper(memo, n)
    

# Solution 2
"""
dp数组的迭代解法
（受到备忘录启发->备忘录独立一张表）

-- DP table: 自底向上：从base case往上推
"""
class Solution:
    def fib(self, n: int) -> int:
        if n == 0: return 0
        
        dp = {}

        # base case
        dp[0] = 0
        dp[1] = 1
        
        # 状态转移
        for i in range(2, n+1):
            dp[i] = dp[i-1] + dp[i-2]
        
        return dp[n]


# Solution 3
"""
进一步优化：空间复杂度降为o(1)
因为其实不需要一整个dp table去储存所有的状态
存n之前的两个状态就可以了
"""
class Solution:
    def fib(self, n: int) -> int:
        if n == 0: return 0

        # base case
        dp_n_2 = 0
        dp_n_1 = 1
        
        # 滚动更新
        for i in range(2, n+1):
            dp_i = dp_n_1 + dp_n_2

            dp_n_2 = dp_n_1
            dp_n_1 = dp_i
        
        return dp_n_1

        
        