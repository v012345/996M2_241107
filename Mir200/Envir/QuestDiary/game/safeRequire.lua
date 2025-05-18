-- safe_require.lua

-- ����ԭʼ�� require ����
--local originalRequire = require
local originalRequire = include
-- ��װ�İ�ȫ require ����
local function safeRequire(moduleName)
    local status, result = pcall(originalRequire, moduleName)
    if status then
        return result
    else
        -- �������߼��������¼������ӡ������Ϣ
        release_print("Error loading module '" .. moduleName .. "':", result)
        -- ���� nil����ʾ����ʧ��
        return nil
    end
end

-- ��ѡ������ȫ�ֵ� require ����
-- �����´���ȡ��ע�ͼ���ȫ���滻 require
require = safeRequire

return safeRequire
