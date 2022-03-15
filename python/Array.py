## LC 1. Two Sum
class Solution:
    def twoSum(self, nums: List[int], target: int) -> List[int]:
        hashtable = dict()  # 数：对应的index
        for i, v in enumerate(nums):
            if target - v in hashtable:
                return [hashtable[target - v], i]

            # save the index into the dict
            hashtable[nums[i]] = i 
        # return []
        