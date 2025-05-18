local FenJie = {}

local config = cfg_fen_jie

function FenJie.Request(actor, arg1, arg2, arg3, data)
    if #data == 0 then
        return
    end
    local isHuiShou = false
    local giveItems = {}
    local giveArray = {}
    for _, value in ipairs(data) do
        local config = config[value]
        if config then
            local itemName = config.equipName
            local itemNum = getbagitemcount(actor, config.equipName)
            if itemNum > 0 then
                local isSuccess = takeitemex(actor, itemName, itemNum, 0, "װ���ֽ�") --������Ʒ
                if isSuccess then
                    for i, v in ipairs(config.give) do
                        if not giveItems[v[1]] then --���key�ǿյģ��ʹ���һ��key
                            giveItems[v[1]] = v[2] * itemNum
                        else
                            giveItems[v[1]] = giveItems[v[1]] + v[2] * itemNum --������ǿյľ���ԭ�еĽ����ۼ�
                        end
                    end 
                end
                isHuiShou = true
            end
        end
    end
    if not isHuiShou then
        messagebox(actor, "[ϵͳ��ʾ]��\n\n    �㱳����û�п��Էֽ��װ����")
    end
    --�ѽ���keyת��������
    for key, value in pairs(giveItems) do
        local Array = { key, value }
        table.insert(giveArray, Array)
    end
    if isHuiShou then
        local gives = {}
        Player.giveItemByTable(actor, giveArray, "ϵͳ���ո���", 1)
        for index, value in ipairs(giveArray) do
            table.insert(gives, string.format("[%s*%d]", value[1], value[2]))
        end
        local finalStr = table.concat(gives, ",")
        messagebox(actor, "[ϵͳ��ʾ]��\n\n    �ѷֽ�װ���ɹ�,���"..finalStr)
    end
end

Message.RegisterNetMsg(ssrNetMsgCfg.FenJie, FenJie)
return FenJie