local YueYeMiShi = {}
YueYeMiShi.ID = "��ҹ����"
local npcID = 827
--local config = include("QuestDiary/cfgcsv/cfg_YueYeMiShi.lua") --����
local cost = { { "̩���µĽ��㽶", 1 }, { "�����ʯ", 8 } }
local give = { {} }
function exit_yue_ye_mi_shi(actor)
    mapmove(actor, "�»Ե�������", 79, 76, 2)
    if getflagstatus(actor, VarCfg.F_isGuaJi) == 1 then
        startautoattack(actor)
    end
end

function delay_run_yue_ye_mi_shi_exit(actor)
    senddelaymsg(actor, "��ǰ��ͼʣ��ʱ��:%s", 7200, 250, 1, "exit_yue_ye_mi_shi", 0)
end

--��������
function YueYeMiShi.Request(actor)
    local name, num = Player.checkItemNumByTable(actor, cost)
    if name then
        Player.sendmsgEx(actor, string.format("�����ͼʧ��,���|%s#249|����|%d#249", name, num))
        return
    end
    Player.takeItemByTable(actor, cost, "��ҹ���ҽ���")
    map(actor, "��ҹ����")
    delaygoto(actor, 1000, "delay_run_yue_ye_mi_shi_exit")
end

--ͬ����Ϣ
-- function YueYeMiShi.SyncResponse(actor, logindatas)
--     local data = {}
--     local _login_data = {ssrNetMsgCfg.YueYeMiShi_SyncResponse, 0, 0, 0, data}
--     if logindatas then
--         table.insert(logindatas, _login_data)
--     else
--         Message.sendmsg(actor, ssrNetMsgCfg.YueYeMiShi_SyncResponse, 0, 0, 0, data)
--     end
-- end
--��¼����
local function _onLoginEnd(actor, logindatas)
    -- YueYeMiShi.SyncResponse(actor, logindatas)
    if FCheckBagEquip(actor, "������") then
        setontimer(actor,11,15,0,1)
    end
end
--�¼��ɷ�
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, YueYeMiShi)
local function _onTakeOnEx(actor, itemobj, where, itemname, makeid)
    if itemname == "������" then
        setontimer(actor,11,15,0,1)
    end
end
GameEvent.add(EventCfg.onTakeOnEx, _onTakeOnEx, YueYeMiShi)
local function _onTakeOffEx(actor, itemobj, where, itemname, makeid)
    if itemname == "������" then
        setofftimer(actor,11)
    end
end
GameEvent.add(EventCfg.onTakeOffEx, _onTakeOffEx, YueYeMiShi)


--ע��������Ϣ
Message.RegisterNetMsg(ssrNetMsgCfg.YueYeMiShi, YueYeMiShi)
return YueYeMiShi
