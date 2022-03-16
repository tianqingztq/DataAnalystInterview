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


## LC 697. Degree of an Array
class Solution:
    def findShortestSubArray(self, nums: List[int]) -> int:

        # calculate the degree,
        # and save the index where
        # the element first occur and last

        # value: [start_index, end_index, frequency]
        hash_degree = defaultdict(list)
        for i, v in enumerate(nums):
            if nums[i] in hash_degree:
                hash_degree[nums[i]][1] = i
                hash_degree[nums[i]][2] += 1
            else:
                hash_degree[v] = [i, i, 1]

        degree = max([x[2] for x in hash_degree.values()])

        smallest_len = len(nums)  # init

        for i in hash_degree:

            if hash_degree[i][2] == degree:
                temp_len = hash_degree[i][1] - hash_degree[i][0] + 1

                if smallest_len > temp_len:
                    smallest_len = temp_len

        return smallest_len
        # O(n)
