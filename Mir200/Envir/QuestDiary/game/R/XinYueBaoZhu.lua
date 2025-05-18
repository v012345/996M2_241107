local XinYueBaoZhu = {}
XinYueBaoZhu.ID = "���±���"
local cost = { { "�¹�ӡ��", 1 }, { "�¹��ֻ�", 1 }, { "����֮��", 1 } }
local give = { { "���±���", 1 } }
local npcID = 232
--local config = include("QuestDiary/cfgcsv/cfg_XinYueBaoZhu.lua") --����
--��������
function XinYueBaoZhu.Request(actor)
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
    end
    Player.takeItemByTable(actor, cost, "���±������")
    Player.giveItemByTable(actor, give, "���±������", 1, true)
    XinYueBaoZhu.SyncResponse(actor)
    Player.sendmsgEx(actor, "��ʾ��#251|��ϲ������|���±���#249")
    setflagstatus(actor, VarCfg["F_���±���_���"], 1)
end

--ͬ����Ϣ
function XinYueBaoZhu.SyncResponse(actor, logindatas)
    local data = {}
    local _login_data = { ssrNetMsgCfg.XinYueBaoZhu_SyncResponse, 0, 0, 0, data }
    if logindatas then
        table.insert(logindatas, _login_data)
    else
        Message.sendmsg(actor, ssrNetMsgCfg.XinYueBaoZhu_SyncResponse, 0, 0, 0, data)
    end
end

--��������
local function attrReload(actor)
    delattlist(actor, "��ҹ��˵")
    if checkitemw(actor, "���±���", 1) then
        if checktimeInPeriod(22, 59, 7, 59) then
            addattlist(actor, "��ҹ��˵", "=", "3#3#160|3#4#160", 1)
        end
    end
end
------------��¼����
local function _onLoginEnd(actor, logindatas)
    -- XinYueBaoZhu.SyncResponse(actor, logindatas)
    attrReload(actor)
end
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, XinYueBaoZhu)
------------ҹ����
local function _noStartingDark(actor)
    attrReload(actor)
end
GameEvent.add(EventCfg.onStartingDark, _noStartingDark, XinYueBaoZhu)
-----------���촥��
local function _noStartingDay(actor)
    attrReload(actor)
end
GameEvent.add(EventCfg.onStartingDay, _noStartingDay, XinYueBaoZhu)
--��װ��
local function _onTakeOnEx(actor, itemobj, where, itemname, makeid)
    if itemname == "���±���" then
        attrReload(actor)
    end
end
GameEvent.add(EventCfg.onTakeOnEx, _onTakeOnEx, XinYueBaoZhu)

--��װ��
local function _onTakeOffEx(actor, itemobj, where, itemname, makeid)
    if itemname == "���±���" then
        attrReload(actor)
    end
end
GameEvent.add(EventCfg.onTakeOffEx, _onTakeOffEx, XinYueBaoZhu)
--ע��������Ϣ
Message.RegisterNetMsg(ssrNetMsgCfg.XinYueBaoZhu, XinYueBaoZhu)
return XinYueBaoZhu
--init����
