local YiJiangGongChengWanGuKu = {}
YiJiangGongChengWanGuKu.ID = "һ��������ſ�"
local npcID = 326
local give = {{"���ý���[װ��ʱװ]",1}}
--local config = include("QuestDiary/cfgcsv/cfg_YiJiangGongChengWanGuKu.lua") --����
local config = {
    { var = VarCfg["F_����_һ��������ſ�1"], equipName = "��Ȫ" },
    { var = VarCfg["F_����_һ��������ſ�2"], equipName = "���" },
    { var = VarCfg["F_����_һ��������ſ�3"], equipName = "��Ԩ֮��" },
}
--�ύװ��
function YiJiangGongChengWanGuKu.Request1(actor, index)
    if not FCheckNPCRange(actor, npcID, 15) then
        Player.sendmsgEx(actor, "����PNC̫Զ!#249")
        return
    end
    local cfg = config[index]
    if not cfg then
        Player.sendmsgEx("��������!")
        return
    end
    if getflagstatus(actor, cfg.var) == 1 then
        Player.sendmsgEx(actor, string.format("%s#249|�Ѿ��ύ����!", cfg.equipName))
        return
    end
    local cost = { { cfg.equipName, 1 } }
    -- dump(cost)
    local name, num = Player.checkItemNumByTable(actor, cost)
    if name then
        Player.sendmsgEx(actor, string.format("���|%s#249|����|%d#249", name, num))
        return
    end
    Player.sendmsgEx(actor, string.format("%s#249|�ɹ��ύ!", cfg.equipName))
    Player.takeItemByTable(actor, cost, "һ��������ſ�")
    setflagstatus(actor, cfg.var, 1)
    YiJiangGongChengWanGuKu.SyncResponse(actor)
end

--��ȡװ��
function YiJiangGongChengWanGuKu.Request2(actor)
    if not FCheckNPCRange(actor, npcID, 15) then
        Player.sendmsgEx(actor, "����PNC̫Զ!#249")
        return
    end
    if getflagstatus(actor,VarCfg["F_����_ʱװ�Ƿ���ȡ"]) == 1 then
        Player.sendmsgEx(actor, "���Ѿ���ȡ����,�����ظ���ȡ!#249")
        return
    end
    if not Bag.checkBagEmptyNum(actor, 5) then
        Player.sendmsgEx(actor, "��ı������Ӳ���,��������5���ո�!#249")
        stop(actor)
    end
    local flag1 = getflagstatus(actor, VarCfg["F_����_һ��������ſ�1"])
    local flag2 = getflagstatus(actor, VarCfg["F_����_һ��������ſ�2"])
    local flag3 = getflagstatus(actor, VarCfg["F_����_һ��������ſ�3"])
    if flag1 == 1 and flag2 == 1 and flag3 == 1 then
        Player.giveItemByTable(actor, give, "һ��������ſ�", 1, true)
        Player.sendmsgEx(actor, "��ϲ����|���ý���[ʱװ]#249")
        YiJiangGongChengWanGuKu.SyncResponse(actor)
        setflagstatus(actor,VarCfg["F_����_ʱװ�Ƿ���ȡ"],1)
    else
        Player.sendmsgEx(actor, "�㻹��װ��û�ύ��!#249")
    end
end
--ͬ����Ϣ
function YiJiangGongChengWanGuKu.SyncResponse(actor, logindatas)
    local data = {}
    for index, value in ipairs(config) do
        local flag = getflagstatus(actor, value.var)
        table.insert(data, flag)
    end
    local flag = getflagstatus(actor,VarCfg["F_����_ʱװ�Ƿ���ȡ"])
    local _login_data = {ssrNetMsgCfg.YiJiangGongChengWanGuKu_SyncResponse, flag, 0, 0, data}
    if logindatas then
        table.insert(logindatas, _login_data)
    else
        Message.sendmsg(actor, ssrNetMsgCfg.YiJiangGongChengWanGuKu_SyncResponse, flag, 0, 0, data)
    end
end
--��¼����
local function _onLoginEnd(actor, logindatas)
    YiJiangGongChengWanGuKu.SyncResponse(actor, logindatas)
end
--�¼��ɷ�
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, YiJiangGongChengWanGuKu)
-- --�¼��ɷ�
-- GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, YiJiangGongChengWanGuKu)
--ע��������Ϣ
Message.RegisterNetMsg(ssrNetMsgCfg.YiJiangGongChengWanGuKu, YiJiangGongChengWanGuKu)
return YiJiangGongChengWanGuKu
