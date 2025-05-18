local LongQiMieShiHaiGu = {}
LongQiMieShiHaiGu.ID = "������������"
local npcID = 509
--local config = include("QuestDiary/cfgcsv/cfg_LongQiMieShiHaiGu.lua") --����
local cost = { { "[����]����̖��", 1 }, { "�컯�ᾧ", 188 }, { "����ħ���ᾧ", 1 }, { "Ԫ��", 5550000 } }
local give = { { "[����]��������", 1 } }
--��������
function LongQiMieShiHaiGu.Request(actor)
    if not FCheckNPCRange(actor, npcID, 15) then
        Player.sendmsgEx(actor, "����PNC̫Զ!#249")
        return
    end
    local name, num = Player.checkItemNumByTable(actor, cost)
    if name then
        Player.sendmsgEx(actor, string.format("���|%s#249|����|%d#249", name, num))
        return
    end
    if not Bag.checkBagEmptyNum(actor, 5) then
        Player.sendmsgEx(actor, "��ı������Ӳ���,��������5���ո�!#249")
        stop(actor)
        return
    end
    Player.takeItemByTable(actor, cost, "������������")
    setflagstatus(actor, VarCfg["F_������������"], 1)
    Player.giveItemByTable(actor, give, "������������", 1, true)
    local myName = getbaseinfo(actor, ConstCfg.gbase.name)
    Player.sendmsgnewEx(actor, 0, 0, string.format("���|%s#253|��|��������#249|�ɹ��ϳ�|[����]��������#249|ʵ����ô������", myName))
    Player.sendmsgEx(actor, "��ϲ��ϳɳɹ�!")
end

--ͬ����Ϣ
-- function LongQiMieShiHaiGu.SyncResponse(actor, logindatas)
--     local data = {}
--     local _login_data = {ssrNetMsgCfg.LongQiMieShiHaiGu_SyncResponse, 0, 0, 0, data}
--     if logindatas then
--         table.insert(logindatas, _login_data)
--     else
--         Message.sendmsg(actor, ssrNetMsgCfg.LongQiMieShiHaiGu_SyncResponse, 0, 0, 0, data)
--     end
-- end
-- --��¼����
-- local function _onLoginEnd(actor, logindatas)
--     LongQiMieShiHaiGu.SyncResponse(actor, logindatas)
-- end
-- --�¼��ɷ�
-- GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, LongQiMieShiHaiGu)
--ע��������Ϣ
Message.RegisterNetMsg(ssrNetMsgCfg.LongQiMieShiHaiGu, LongQiMieShiHaiGu)
return LongQiMieShiHaiGu
