"""
-- 转移方程思考：

明确bad case 
-> 明确“状态” 
-> 明确“选择” 
-> 定义dp数组/函数含义

-- 框架：

# 初始化 base case

dp[0][0][...] = base

# 进行状态转移 (穷举所有的状态)

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
    # 时间：加法运算 - 1，调用了2^n次，所以 o(2^n * 1)
    -- 递归算法的时间复杂度：递归函数调用的次数 * 递归函数本身的复杂度

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
        if n in memo:  # 如果算过了，直接返回结果就可以了
            return memo[n]
        memo[n] = self.helper(memo, n - 1) + self.helper(memo, n - 2)
        return memo[n]

    def fib(self, n: int) -> int:
        memo = {}

        return self.helper(memo, n)

    # time: o(n * 1)
    # space: o(n)  -- 以空间换时间


# Solution 2
"""
dp数组的迭代解法
（受到备忘录启发->备忘录独立一张表）

-- DP table: 自底向上：从base case往上推
"""


class Solution:
    def fib(self, n: int) -> int:
        if n == 0:
            return 0

        dp = {}

        # base case
        dp[0] = 0
        dp[1] = 1

        # 状态转移
        for i in range(2, n + 1):
            dp[i] = dp[i - 1] + dp[i - 2]

        return dp[n]


# space & time: o(n)


# Solution 3
"""
进一步优化：空间复杂度降为o(1)
因为其实不需要一整个dp table去储存所有的状态
存n之前的两个状态就可以了
"""


class Solution:
    def fib(self, n: int) -> int:
        if n == 0:
            return 0

        # base case
        dp_n_2 = 0
        dp_n_1 = 1

        # 滚动更新
        for i in range(2, n + 1):
            dp_i = dp_n_1 + dp_n_2

            dp_n_2 = dp_n_1
            dp_n_1 = dp_i

        return dp_n_1


#### LC 322. Coin Change

# -- 1. 自顶向下递归，用备忘录优化
class Solution:
    def coinChange(self, coins: List[int], amount: int) -> int:

        # base case
        if amount == 0:
            return 0
        if amount < 0:
            return -1

        # dp = [float(inf)] * (amount + 1)

        # dp[0] = 0
        dp = float(inf)

        # 状态转移
        for coin in coins:
            # 对于每一个子问题，计算结果 （递归）
            subProb = self.coinChange(coins, amount - coin)
            # 子问题无解则跳过
            if subProb == -1:
                continue

            # 在子问题中选择最优解
            res = min(res, 1 + subProb)

        if res == float(inf):
            return -1

        return res


# 确定状态：找原问题和子问题中会变化的变量
# 状态 即 amount
# amount变化：硬币的面值
# 明确dp定义：dp(n):
# 输入一个目标金额n，
# coinChange: 返回凑出目标金额n所需的最少硬币数量
# -> 每一步都最小（每一个节点都最少）
# -- 2. 自底向上迭代解法
class Solution:
    def coinChange(self, coins: List[int], amount: int) -> int:  
        
        # dp: index is amount, value is coins number
        # 初始化为一个最大值
        dp = [float('inf')] * (amount + 1)
        dp[0] = 0
        
        for coin in coins:
            
            for x in range(coin, amount+1):
                # 先更新一块钱能干的事情
                # 再更新两块钱的最优解（路径变短了）
                # 五块钱的时候五个一块钱的事情，一个五块钱就可以搞定了
                dp[x] = min(dp[x], dp[x - coin] + 1)
                
        if dp[amount] == float('inf'):
            return -1
        
        return dp[amount]
        