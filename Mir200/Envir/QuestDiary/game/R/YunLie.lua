local YunLie = {}
YunLie.ID = "����"
local npcID = 319
--local config = include("QuestDiary/cfgcsv/cfg_YunLie.lua") --����
local cost = { { "ħ����", 10 }, { "ħ����", 10 } }
-- local give = {{}}
--��������
function YunLie.Request1(actor)
    setflagstatus(actor, VarCfg["F_����_����_��ȡ"], 1)
    YunLie.SyncResponse(actor)
end

--�ٻ�
function YunLie.Request2(actor)
    if not FCheckNPCRange(actor, npcID, 15) then
        Player.sendmsgEx(actor, "����PNC̫Զ!#249")
        return
    end
    local name, num = Player.checkItemNumByTable(actor, cost)
    if name then
        Player.sendmsgEx(actor, string.format("���|%s#249|����|%d#249", name, num))
        return
    end
    Player.takeItemByTable(actor, cost, "���Ҿ���")
    local x = getbaseinfo(actor, ConstCfg.gbase.x)
    local y = getbaseinfo(actor, ConstCfg.gbase.y)
    genmon("�Ϸ�ɭ��", x, y, "�Ϲ�ħ��", 1, 1, 255)
    Player.sendmsgEx(actor, "��ɹ��ٻ���|�Ϲ�ħ��#249|��ɱboss,�и��ʻ��������Ʒ!")
    Player.sendmsgEx(actor, "��ɹ��ٻ���|�Ϲ�ħ��#249|��ɱboss,�и��ʻ��������Ʒ!")
    Player.sendmsgEx(actor, "��ɹ��ٻ���|�Ϲ�ħ��#249|��ɱboss,�и��ʻ��������Ʒ!")
    local num = getplaydef(actor, VarCfg["U_�Ϲ�ħ���ٻ�_����"])
    if num < 3 then
        setplaydef(actor, VarCfg["U_�Ϲ�ħ���ٻ�_����"],num+1)
        if num+1 == 1 then
            local taskPanelID = getplaydef(actor, VarCfg["U_��������������"])
            if taskPanelID == 18 then
                FCheckTaskRedPoint(actor)
            end
        end
    end
    Message.sendmsg(actor, ssrNetMsgCfg.YunLie_Close, 0, 0, 0, {})
end

--ͬ����Ϣ
function YunLie.SyncResponse(actor, logindatas)
    local data = {}
    local flag = getflagstatus(actor, VarCfg["F_����_����_��ȡ"])
    local _login_data = { ssrNetMsgCfg.YunLie_SyncResponse, flag, 0, 0, data }
    if logindatas then
        table.insert(logindatas, _login_data)
    else
        Message.sendmsg(actor, ssrNetMsgCfg.YunLie_SyncResponse, flag, 0, 0, data)
    end
end

--��¼����
local function _onLoginEnd(actor, logindatas)
    YunLie.SyncResponse(actor, logindatas)
end
--�¼��ɷ�
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, YunLie)
--ע��������Ϣ
Message.RegisterNetMsg(ssrNetMsgCfg.YunLie, YunLie)
return YunLie
