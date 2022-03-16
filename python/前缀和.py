## 560. Subarray Sum Equals K


class Solution:
    def subarraySum(self, nums: List[int], k: int) -> int:
        """
        # time exceed
        # 构造前缀和
        # Time complexity O(n^2)
        preSum = [0] * (len(nums)+1)
        temp = 0
        for i in range(len(nums)):
            temp += nums[i]
            preSum[i+1] = temp

        cnt = 0

        for left in range(0, len(nums)):
            for right in range(left, len(nums)):
                if preSum[right + 1] - preSum[left] == k:
                    cnt += 1

        return cnt
        """
        sum_map = defaultdict(int)
        # 注意：sum-k这里要包括0, 因为要计算第一个的和
        sum_map[0] = 1
        preSum = 0
        cnt = 0

        for i in range(len(nums)):
            preSum += nums[i]
            if preSum - k in sum_map:
                cnt += sum_map[preSum - k]

            sum_map[preSum] += 1

        return cnt
        # time complexity O(n)
        # space complexity O(n)


# right - left
