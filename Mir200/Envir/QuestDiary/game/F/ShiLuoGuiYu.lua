local ShiLuoGuiYu = {}
ShiLuoGuiYu.ID = "ʧ�����"
local npcID = 3064
--local config = include("QuestDiary/cfgcsv/cfg_ShiLuoGuiYu.lua") --����
local cost = {{"��",8},{"��",8},{"���",10000000}}
--��������
function ShiLuoGuiYu.Request(actor,index)
    if not FCheckNPCRange(actor, npcID, 15) then
        Player.sendmsgEx(actor, "����PNC̫Զ!#249")
        return
    end
    local falg = getflagstatus(actor,VarCfg["F_ʧ������ͼ����"])
    if index == 1 then
        if falg == 1  then
            Player.sendmsgEx(actor,"���Ѿ������˴˵�ͼ!#249")
            return
        end
        local name, num = Player.checkItemNumByTable(actor, cost)
        if name then
            Player.sendmsgEx(actor, string.format("����ʧ�����|%s#249|����|%d#249", name, num))
            return
        end
        setflagstatus(actor, VarCfg["F_ʧ������ͼ����"], 1)
        Player.takeItemByTable(actor, cost,"����ʧ�����")
        Player.sendmsgEx(actor,"������ͼ�ɹ�!")
        ShiLuoGuiYu.SyncResponse(actor)
    elseif index == 2 then
        if falg == 1 then
            FMapMoveEx(actor,"ʧ�����",25,275)
        else
            Player.sendmsgEx(actor,"�����ͼʧ��,��û�п����˵�ͼ!#249")
        end
    else

    end
end
--ͬ����Ϣ
function ShiLuoGuiYu.SyncResponse(actor, logindatas)
    local data = {}
    local falg = getflagstatus(actor,VarCfg["F_ʧ������ͼ����"])
    local _login_data = {ssrNetMsgCfg.ShiLuoGuiYu_SyncResponse, falg, 0, 0, data}
    if logindatas then
        table.insert(logindatas, _login_data)
    else
        Message.sendmsg(actor, ssrNetMsgCfg.ShiLuoGuiYu_SyncResponse, falg, 0, 0, data)
    end
end
--��¼����
local function _onLoginEnd(actor, logindatas)
    ShiLuoGuiYu.SyncResponse(actor, logindatas)
end
--�¼��ɷ�
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, ShiLuoGuiYu)
--ע��������Ϣ
Message.RegisterNetMsg(ssrNetMsgCfg.ShiLuoGuiYu, ShiLuoGuiYu)
return ShiLuoGuiYu