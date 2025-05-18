local HeiShuiMiJi = {}
HeiShuiMiJi.ID = "��ˮ�ؼ�"
local npcID = 455
--local config = include("QuestDiary/cfgcsv/cfg_HeiShuiMiJi.lua") --����
local cost = { { "��ˮ��ҳ", 222 }, { "��ҳ", 2222 } }
local give = { {} }
--��������
function HeiShuiMiJi.Request(actor)
    if not FCheckNPCRange(actor, npcID, 15) then
        Player.sendmsgEx(actor, "����PNC̫Զ!#249")
        return
    end
    local skillInfo = getskillinfo(actor, 2018, 1)
    if skillInfo then
        Player.sendmsgEx(actor, "���Ѿ�ѧϰ���ü���!#249")
        FSetTaskRedPoint(actor, VarCfg["F_��ˮ�ؼ�_���"], 40)
        return
    end
    local name, num = Player.checkItemNumByTable(actor, cost)
    if name then
        Player.sendmsgEx(actor, string.format("���|%s#249|����|%d#249", name, num))
        return
    end
    Player.takeItemByTable(actor, cost, "��ˮ�ؼ�")
    -- setflagstatus(actor,VarCfg["F_��ˮ�ؼ�_���"],1)
    FSetTaskRedPoint(actor, VarCfg["F_��ˮ�ؼ�_���"], 40)
    addskill(actor, 2018, 3)
    messagebox(actor, "��ϲ��ѧϰ����[��ˮ����]")
end

--ͬ����Ϣ
-- function HeiShuiMiJi.SyncResponse(actor, logindatas)
--     local data = {}
--     local _login_data = {ssrNetMsgCfg.HeiShuiMiJi_SyncResponse, 0, 0, 0, data}
--     if logindatas then
--         table.insert(logindatas, _login_data)
--     else
--         Message.sendmsg(actor, ssrNetMsgCfg.HeiShuiMiJi_SyncResponse, 0, 0, 0, data)
--     end
-- end
-- --��¼����
-- local function _onLoginEnd(actor, logindatas)
--     HeiShuiMiJi.SyncResponse(actor, logindatas)
-- end
-- --�¼��ɷ�
-- GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, HeiShuiMiJi)
--ע��������Ϣ
Message.RegisterNetMsg(ssrNetMsgCfg.HeiShuiMiJi, HeiShuiMiJi)
return HeiShuiMiJi
