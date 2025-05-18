local HuiShou = {}

local newConfig = {}

for i, v in ipairs(cfg_HuiShou) do
    v.id = i
    newConfig[v.idx] = v
end
local cfg_UseItem = include("QuestDiary/cfgcsv/cfg_UseItem.lua") --��Ʒʹ������


--�Զ����յ���Ʒ
local function RecoveryItem(actor, itemName)
    if not itemName then
        return
    end
    local itemNum = getbagitemcount(actor, itemName)
    if itemNum <= 0 then
        return
    end
    local value = cfg_UseItem[itemName]
    if not value then
        return
    end
    if value.type == 1 then
        local total = value.value * itemNum
        if checkitemw(actor,"ţ������ӡ",1) then
            if randomex(20) then
                total = total * 2
            end
        end
        local data = splitLargeNumber(4000000000, total)
        if #data > 0 then
            local liveMax = getplaydef(actor, VarCfg["U_�ȼ�����"])
            local myLevel = getbaseinfo(actor, ConstCfg.gbase.level)
            if myLevel < liveMax then
                for _, v in ipairs(data) do
                    changeexp(actor, "+", v, true)
                end
            else
                sendmsg(actor,1,'{"Msg":"��ĵȼ��Ѿ��ﵽ����,ʹ�þ�����޷�������þ���!","FColor":255,"BColor":249,"Type":1,"Time":3,"SendName":"��ʾ","SendId":"123"}')
            end
            takeitemex(actor, itemName, itemNum, 0, "�Զ��Ծ���")
        end
    elseif value.type == 2 then
        local total = value.value * itemNum
        local data = splitLargeNumber(2000000000, total)
        if #data > 0 then
            for _, v in ipairs(data) do
                changemoney(actor, 2, "+", v, "�Զ���" .. itemName, true)
            end
            takeitemex(actor, itemName, itemNum, 0, "�Զ���Ԫ��")
        end
    elseif value.type == 3 then
        local randomValue = math.random(value.value[1], value.value[2])
        local total = randomValue * itemNum
        if checkitemw(actor,"ţ������ӡ",1) then
            if randomex(20) then
                total = total * 2
            end
        end
        local data = splitLargeNumber(2000000000, total)
        local goldId = FGetBindGoldId(actor)
        if #data > 0 then
            for _, v in ipairs(data) do
                changemoney(actor, goldId, "+", v, "�Զ���" .. itemName, true)
            end
            takeitemex(actor, itemName, itemNum, 0, "�Զ��Ժ��")
        end
    end
end

--MakeID����
function HuiShou.Request(actor, arg1, arg2, arg3, datas)
    local isHuiShou = false
    local giveItems = {}
    local giveArray = {}
    local makeIdItems = {}
    for _, makeId in ipairs(datas) do
        local itemObj = getitembymakeindex(actor, makeId)
        if itemObj ~= "0" then
            local idx = getiteminfo(actor, itemObj, ConstCfg.iteminfo.idx)
            local itemInfo = newConfig[idx]
            -- dump(itemInfo)
            if itemInfo then
                table.insert(makeIdItems, makeId)
                local itemNum = getiteminfo(actor, itemObj, ConstCfg.iteminfo.overlap)
                if itemNum == 0 then
                    itemNum = 1
                end
                for _, value in ipairs(itemInfo.give) do
                    if not giveItems[value[1]] then --���key�ǿյģ��ʹ���һ��key
                        giveItems[value[1]] = value[2] * itemNum
                    else
                        giveItems[value[1]] = giveItems[value[1]] + value[2] * itemNum --������ǿյľ���ԭ�еĽ����ۼ�
                    end
                end
            end
        end
    end
    local markupAttr = getbaseinfo(actor, ConstCfg.gbase.custom_attr, 216)
    if markupAttr == 0 then markupAttr = 100 end
    local markup = markupAttr / 100
    --�ѽ���keyת��������
    for key, value in pairs(giveItems) do
        if key == "���" then
            value = math.floor(value * markup)
        end
        local Array = { key, value }
        table.insert(giveArray, Array)
    end
    -- dump(giveArray)
    isHuiShou = delitembymakeindex(actor, table.concat(makeIdItems, ","), 0, "ϵͳ����")
    if isHuiShou then
        -- release_print(getflagstatus(actor, VarCfg["F_���״̬"]))
        if getflagstatus(actor, VarCfg["F_���״̬"]) == 0 then
            for i = 1, #giveArray do
                if giveArray[i][1] == "���" then
                    giveArray[i][1] = "�󶨽��"
                end
            end
            Player.giveItemByTable(actor, giveArray, "ϵͳ���ո����", 1,true)
        else
            Player.giveItemByTable(actor, giveArray, "ϵͳ���ո���δ��", 1,true)
        end
        GameEvent.push(EventCfg.onHuiShouFinish, actor, giveArray)
    end
end

--�������װ��idx����
-- function HuiShou.Request(actor, arg1, arg2, arg3, datas)
--     local isHuiShou = false
--     local giveItems = {}
--     local giveArray = {}
--     for _, idx in ipairs(datas) do
--         local itemInfo = newConfig[idx]
--         -- dump(itemInfo)
--         if itemInfo then
--             local itemName = itemInfo.equipName
--             local itemNum = getbagitemcount(actor, itemName) --��ȡ��Ʒ����
--             if itemNum > 0 then
--                 local isSuccess = takeitemex(actor, itemName, itemNum, 0, "ϵͳ����") --������Ʒ
--                 if isSuccess then --�Ƿ�ɹ�����
--                     for _, value in ipairs(itemInfo.give) do
--                         if not giveItems[value[1]] then --���key�ǿյģ��ʹ���һ��key
--                             giveItems[value[1]] = value[2] * itemNum
--                         else
--                             giveItems[value[1]] = giveItems[value[1]] + value[2] * itemNum --������ǿյľ���ԭ�еĽ����ۼ�
--                         end
--                     end
--                     isHuiShou = true
--                 end
--             end
--         end
--     end
--     --�ѽ���keyת��������
--     for key, value in pairs(giveItems) do
--         local Array = { key, value }
--         table.insert(giveArray, Array)
--     end
--     if isHuiShou then
--         Player.giveItemByTable(actor, giveArray, "ϵͳ���ո���", 1)
--     end
-- end

--����ʹ�õ���
function HuiShou.UseItem(actor, arg1, arg2, arg3, datas)
    for _, value in ipairs(datas) do
        local itemName = getstditeminfo(value, ConstCfg.stditeminfo.name)
        RecoveryItem(actor, itemName)
    end
end

--��¼ͬ������
function HuiShou.SyncResponse(actor, logindatas)
    local data = Player.getJsonTableByVar(actor, "T1")
    local flag1 = getflagstatus(actor, VarCfg.F_is_auto_money)
    local flag2 = getflagstatus(actor, VarCfg.F_is_auto_exp)
    local flag3 = getflagstatus(actor, VarCfg.F_is_auto_recovery)
    local flag4 = getflagstatus(actor, VarCfg.F_is_auto_custom_attributes)
    local flag5 = getflagstatus(actor, VarCfg["F_�Ƿ���տ�����װ��"])
    data["markup"] = getbaseinfo(actor, ConstCfg.gbase.custom_attr, 216)
    data["flag4"] = flag4
    data["flag5"] = flag5
    local _login_data = { ssrNetMsgCfg.HuiShou_SyncResponse, flag1, flag2, flag3, data }
    if logindatas then
        table.insert(logindatas, _login_data)
    else
        Message.sendmsg(actor, ssrNetMsgCfg.HuiShou_SyncResponse, flag1, flag2, flag3, data)
    end
end

--��ѡ����
function HuiShou.RequestCheck(actor, arg1, arg2, arg3, data)
    Player.setJsonVarByTable(actor, "T1", data)
end

-- ssrNetMsgCfg.HuiShou_AutoHuiShou             = 11005      --��ѡ�Զ�����
-- ssrNetMsgCfg.HuiShou_AutoMoney               = 11006      --��ѡ�Զ�����
-- ssrNetMsgCfg.HuiShou_AutoExp                 = 11007      --��ѡ�Զ�����

--��ѡ�Զ�����
function HuiShou.AutoHuiShou(actor, arg1)
    local flag = getflagstatus(actor, VarCfg.F_is_auto_recovery) == 0 and 1 or 0
    setflagstatus(actor, VarCfg.F_is_auto_recovery, flag)
    Message.sendmsg(actor, ssrNetMsgCfg.HuiShou_AutoHuiShou, flag)
end

--�Զ��Ի���
function HuiShou.AutoMoney(actor, arg1)
    local flag = getflagstatus(actor, VarCfg.F_is_auto_money) == 0 and 1 or 0
    setflagstatus(actor, VarCfg.F_is_auto_money, flag)
    Message.sendmsg(actor, ssrNetMsgCfg.HuiShou_AutoMoney, flag)
end

--�Զ��Ծ���
function HuiShou.AutoExp(actor, arg1)
    local flag = getflagstatus(actor, VarCfg.F_is_auto_exp) == 0 and 1 or 0
    setflagstatus(actor, VarCfg.F_is_auto_exp, flag)
    Message.sendmsg(actor, ssrNetMsgCfg.HuiShou_AutoExp, flag)
end

--�Ƿ���ռ���ǿ��
function HuiShou.CheckCustomAttributes(actor, arg1)
    local flag = getflagstatus(actor, VarCfg.F_is_auto_custom_attributes) == 0 and 1 or 0
    setflagstatus(actor, VarCfg.F_is_auto_custom_attributes, flag)
    Message.sendmsg(actor, ssrNetMsgCfg.HuiShou_CheckCustomAttributes, flag)
end

--�Ƿ���ռ���ǿ��
function HuiShou.CheckKeTiSheng(actor, arg1)
    local flag = getflagstatus(actor, VarCfg["F_�Ƿ���տ�����װ��"]) == 0 and 1 or 0
    setflagstatus(actor, VarCfg["F_�Ƿ���տ�����װ��"], flag)
    Message.sendmsg(actor, ssrNetMsgCfg.HuiShou_CheckKeTiSheng, flag)
end

Message.RegisterNetMsg(ssrNetMsgCfg.HuiShou, HuiShou)
--��¼����
local function _onLoginEnd(actor, logindatas)
    HuiShou.SyncResponse(actor, logindatas)
end
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, HuiShou)

local function _onCalcAttr(actor, attrs)
    local shuxing = {
        [216] = 100
    }
    calcAtts(attrs, shuxing, "����Ĭ��100%")
end
--����
GameEvent.add(EventCfg.onCalcAttr, _onCalcAttr, HuiShou)

return HuiShou
