-- 双向链表节点
local function ListNode(key, value)
    return {
        key = key,
        value = value,
        prev = nil,
        next = nil
    }
end

-- LRU缓存类
local LRUCache = {}
LRUCache.__index = LRUCache

-- 创建新的LRU缓存
function LRUCache.new(capacity)
    local self = setmetatable({}, LRUCache)
    self.capacity = capacity
    self.map = {}
    self.head = ListNode(nil, nil) -- 哨兵头节点
    self.tail = ListNode(nil, nil) -- 哨兵尾节点
    self.head.next = self.tail
    self.tail.prev = self.head
    return self
end

-- 将节点插入到双向链表头部
function LRUCache:insertNode(node)
    node.next = self.head.next
    node.prev = self.head
    self.head.next.prev = node
    self.head.next = node
end

-- 从链表中移除节点
function LRUCache:removeNode(node)
    node.prev.next = node.next
    node.next.prev = node.prev
end

-- 获取值，访问时将节点移动到头部
function LRUCache:get(key)
    local node = self.map[key]
    if not node then
        return nil -- 未找到
    end
    -- 移动节点到头部
    self:removeNode(node)
    self:insertNode(node)
    return node.value
end

-- 插入或更新缓存中的值
function LRUCache:put(key, value)
    local node = self.map[key]
    if node then
        -- 更新值并移动到头部
        node.value = value
        self:removeNode(node)
        self:insertNode(node)
    else
        -- 检查容量并淘汰最旧的节点
        if self.capacity == 0 then
            local oldest = self.tail.prev
            self:removeNode(oldest)
            self.map[oldest.key] = nil
            self.capacity = self.capacity + 1
        end
        -- 插入新节点到头部
        local newNode = ListNode(key, value)
        self.map[key] = newNode
        self:insertNode(newNode)
        self.capacity = self.capacity - 1
    end
end

return LRUCache