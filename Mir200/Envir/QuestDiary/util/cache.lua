-- ˫������ڵ�
local function ListNode(key, value)
    return {
        key = key,
        value = value,
        prev = nil,
        next = nil
    }
end

-- LRU������
local LRUCache = {}
LRUCache.__index = LRUCache

-- �����µ�LRU����
function LRUCache.new(capacity)
    local self = setmetatable({}, LRUCache)
    self.capacity = capacity
    self.map = {}
    self.head = ListNode(nil, nil) -- �ڱ�ͷ�ڵ�
    self.tail = ListNode(nil, nil) -- �ڱ�β�ڵ�
    self.head.next = self.tail
    self.tail.prev = self.head
    return self
end

-- ���ڵ���뵽˫������ͷ��
function LRUCache:insertNode(node)
    node.next = self.head.next
    node.prev = self.head
    self.head.next.prev = node
    self.head.next = node
end

-- ���������Ƴ��ڵ�
function LRUCache:removeNode(node)
    node.prev.next = node.next
    node.next.prev = node.prev
end

-- ��ȡֵ������ʱ���ڵ��ƶ���ͷ��
function LRUCache:get(key)
    local node = self.map[key]
    if not node then
        return nil -- δ�ҵ�
    end
    -- �ƶ��ڵ㵽ͷ��
    self:removeNode(node)
    self:insertNode(node)
    return node.value
end

-- �������»����е�ֵ
function LRUCache:put(key, value)
    local node = self.map[key]
    if node then
        -- ����ֵ���ƶ���ͷ��
        node.value = value
        self:removeNode(node)
        self:insertNode(node)
    else
        -- �����������̭��ɵĽڵ�
        if self.capacity == 0 then
            local oldest = self.tail.prev
            self:removeNode(oldest)
            self.map[oldest.key] = nil
            self.capacity = self.capacity + 1
        end
        -- �����½ڵ㵽ͷ��
        local newNode = ListNode(key, value)
        self.map[key] = newNode
        self:insertNode(newNode)
        self.capacity = self.capacity - 1
    end
end

return LRUCache