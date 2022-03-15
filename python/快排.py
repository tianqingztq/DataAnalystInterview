#### 快排
# 交换元素


def quick_sort(self, start: int, end: int, nums: List[int]) -> List[int]:
    # 如果是[x], [] 这种情况，直接可以return停止sort了，不输出任何新的list
    if start >= end:
        return

    left, right = start, end
    # pivot任意取值，此处定义为中点
    pivot = nums[(start + end) // 2]

    while left < right:
        # 遍历左侧
        while left <= right and nums[left] < pivot:
            left += 1
        # 遍历右侧，如果比pivot大就继续往pivot的地方遍历，找到比pivot的小的丢到左边去
        while left <= right and nums[right] > pivot:
            right -= 1
        if left <= right:  # and nums[left] >= pivot or nums[right] <= pivot
            # 交换nums[left] & nums[right]
            nums[left], nums[right] = nums[right], nums[left]
            left += 1
            right -= 1

    self.quick_sort(start, right, nums)
    self.quick_sort(left, end, nums)
    # ?
    self.quick_sort(
        start,
    )


# LC 215, Kth Largest Element in an Array
# 最后我们一定要让pivot在kth的位置上
def quick_select(self, nums: List[int], start: int, end: int, k: int) -> int:
    if start == end:
        return nums[start]

    # all the same with quick_sort
    left, right = start, end
    pivot = nums[(start + end) // 2]
    while left < right:
        # 遍历左侧
        while left <= right and nums[left] < pivot:
            left += 1
        # 遍历右侧，如果比pivot大就继续往pivot的地方遍历，找到比pivot的小的丢到左边去
        while left <= right and nums[right] > pivot:
            right -= 1
        if left <= right:  # and nums[left] >= pivot or nums[right] <= pivot
            # 交换nums[left] & nums[right]
            nums[left], nums[right] = nums[right], nums[left]
            left += 1
            right -= 1

    # 让k在pivot的位置上
    if k <= right:
        return self.quick_select(nums, start, right, k)
    if k >= left:
        return self.quick_select(nums, left, end, k)

    return nums[k]
