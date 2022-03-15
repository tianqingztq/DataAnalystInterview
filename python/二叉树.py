#### ** 如何把题目的要求细化成每个节点需要做的事情 **
"""
递归算法的关键要明确函数的定义，
相信这个定义，
而不要跳进递归细节。

写二叉树的算法题，都是基于递归框架的，
我们先要搞清楚 root 节点它自己要做什么，
然后根据题目要求选择使用前序，中序，后续的递归框架
"""

#### 翻转二叉树
#### 226. Invert Binary Tree
# TreeNode{
#     val: 4, left: TreeNode{
#         val: 2, left: TreeNode{
#             val: 1, left: None, right: None
#             }, right: TreeNode{
#                 val: 3, left: None, right: None
#                 }
#         }, right: TreeNode{
#             val: 7, left: TreeNode{
#                 val: 6, left: None, right: None
#                 }, right: TreeNode{
#                     val: 9, left: None, right: None
#                     }
#                 }
#     }


# Definition for a binary tree node.
# class TreeNode:
#     def __init__(self, val=0, left=None, right=None):
#         self.val = val
#         self.left = left
#         self.right = right
class Solution:
    def invertTree(self, root: Optional[TreeNode]) -> Optional[TreeNode]:
        # recursive: 遍历
        # ** 适用情况 **: 父节点和它的所有子节点都在做同一个运算
        # 对每一个节点交换它的左右子节点

        # base case
        # 如果子节点None, just return None
        if root is None:
            return None

        ## 前序遍历
        root.left, root.right = self.invertTree(root.right), self.invertTree(root.left)

        # print(root)
        return root


#### 填充二叉树节点的右侧指针
## 116. Populating Next Right Pointers in Each Node
"""
# Definition for a Node.
class Node:
    def __init__(self, val: int = 0, left: 'Node' = None, right: 'Node' = None, next: 'Node' = None):
        self.val = val
        self.left = left
        self.right = right
        self.next = next
"""


class Solution:
    """
    二叉树的层序遍历，基于广度优先搜索
    """

    def connect(self, root: "Optional[Node]") -> "Optional[Node]":
        # base case
        if root is None:
            return None

        # 把每两个相邻节点都穿起来
        # 此处需要跨过父节点，把相邻子节点连起来
        # -> 增加函数参数

        self.connect_two_node(root.left, root.right)

        return root

    def connect_two_node(self, node1, node2):
        if node1 is None or node2 is None:
            return None

        node1.next = node2
        # 相同父节点的子节点连接
        self.connect_two_node(node1.left, node1.right)
        self.connect_two_node(node2.left, node2.right)
        # 相邻父节点的子节点连接
        self.connect_two_node(node1.right, node2.left)


### 将二叉树展开为链表
## 114. Flatten Binary Tree to Linked List
# key is 递归！！

# Definition for a binary tree node.
# class TreeNode:
#     def __init__(self, val=0, left=None, right=None):
#         self.val = val
#         self.left = left
#         self.right = right
class Solution:
    def flatten(self, root: Optional[TreeNode]) -> None:
        """
        Do not return anything, modify root in-place instead.

        "你看，这就是递归的魅力，
        你说 flatten 函数是怎么把左右子树拉平的？
        说不清楚，但是只要知道 flatten 的定义如此，
        相信这个定义，让 root 做它该做的事情，
        然后 flatten 函数就会按照定义工作。
        另外注意递归框架是后序遍历，
        因为我们要先拉平左右子树才能进行后续操作"
        """
        # 将root的左子树和右子树fllaten
        # 将root的右子树接到左子树下方
        # 将整个左子树变为右子树
        
        if root is None:
            return None
        
        # 相信flatten可以把左右子树拉平
        # we "suppose" that recursion does all the hard work for us 
        # and flattens out the left and the right subtrees 
        self.flatten(root.left)
        self.flatten(root.right)
        
        # **后序遍历**
        # 1. 获取左右子树（此时已被拉平成一条链表）
        left = root.left
        right = root.right
        
        # 2. 将左子树变成右子树，left置空
        root.left = None
        root.right = left 
        
        # 3. 将原来的右子树接到当前右子树的末端
        right_node = root
        while right_node.right is not None:
            right_node = right_node.right
        if right_node.right is None:
            right_node.right = right


            
            