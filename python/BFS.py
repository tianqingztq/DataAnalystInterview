"""
-- 应用场景

1. 连通块问题：connected component 图的连通问题；
    iteration solution for all possible results 非递归方式找所有方案
2. 分层遍历：图的层次遍历
    simple path shortest path
        simple path: 边的权重都一样
3. topological sorting 拓扑排序
    求任意拓扑排序
    求是否有拓扑排序
    求字典序最小的拓扑序
    求是否是唯一的拓扑序


-- 问最短路径
    简单图：bfs
    复杂图：floyd，dijkstra，bellman-ford

-- 问最长路径
    bfs不能做（不能让遍历过程绕圈）
    用dfs
    如果图可以分层：dp

-- 二叉树 vs 图的bfs
    
如果图中有环， 同一个节点可能重复进入队列（hash）

"""

#### clone graph 连通块问题 lc 133
"""
1. 通过一个nerd，找到所有的nerd，- bfs
2. 然后复制nodes, - 存储新老节点映射关系 mapping
3. then edges
"""

"""
# Definition for a Node.
class Node:
    def __init__(self, val = 0, neighbors = None):
        self.val = val
        self.neighbors = neighbors if neighbors is not None else []
"""


class Solution:
    def cloneGraph(self, node: "Node") -> "Node":
        root = node  # soft copy
        # base case:
        if node is None:
            return node

        # 1. bfs, find all nodes objects
        nodes = self.get_nodes(node)

        # 2. copy nodes & store the old -> new mapping info in a hash map
        mapping = {}
        for i in nodes:
            mapping[i] = Node(i.val, [])

        # 3. copy edges (neighbors)
        for i in nodes:
            new_node = mapping[i]
            for neighbor in i.neighbors:
                new_neighbor = mapping[neighbor]
                new_node.neighbors.append(new_neighbor)

        return mapping[root]

    ## BFS!!!
    def get_nodes_bfs(self, node):
        # put the initial node in the queue
        q = collections.deque([node])
        result = set([node])
        while q:
            head = q.popleft()
            # iterate through all the neighbors of the node
            for neighbor in head.neighbors:
                if neighbor in result:
                    continue
                result.add(neighbor)
                q.append(neighbor)

        return list(result)

    ## DFS
    def get_nodes_dfs(self, node):
        q = collections.deque([node])
        result = set([node])
        # print([q[-1].val])

        while q:  # 当q不是空的时候
            tail = q[-1]
            qlen = len(q)
            for neighbor in tail.neighbors:
                if neighbor in q:
                    continue
                if neighbor in result:
                    continue
                q.append(neighbor)
            if qlen == len(q):
                result.add(q[-1])
                q.pop()
            # print([x.val for x in q])
        return list(result)
