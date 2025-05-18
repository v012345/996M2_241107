local YueHuiBiHu = {}
YueHuiBiHu.ID = "�»Աӻ�"
local npcID = 828
--local config = include("QuestDiary/cfgcsv/cfg_YueHuiBiHu.lua") --����
local cost = { { "���ػꨕ", 1 }, { "���", 888 } }
--��������
function YueHuiBiHu.Request(actor)
    local count = getplaydef(actor, VarCfg["B_�»Աӻ�_����"])
    if count >= 5 then
        Player.sendmsgEx(actor, "���ֻ���ύ5��!#249")
        return
    end
    local name, num = Player.checkItemNumByTable(actor, cost)
    if name then
        Player.sendmsgEx(actor, string.format("���|%s#249|����|%d#249", name, num))
        return
    end
    Player.takeItemByTable(actor, cost, YueHuiBiHu.ID)
    setplaydef(actor, VarCfg["B_�»Աӻ�_����"], count + 1)
    Player.setAttList(actor, "���Ը���")
    YueHuiBiHu.SyncResponse(actor)
    Player.sendmsgEx(actor, "�ύ�ɹ�!")
end

--ͬ����Ϣ
function YueHuiBiHu.SyncResponse(actor, logindatas)
    local data = {}
    local num = getplaydef(actor, VarCfg["B_�»Աӻ�_����"])
    local _login_data = { ssrNetMsgCfg.YueHuiBiHu_SyncResponse, num, 0, 0, data }
    if logindatas then
        table.insert(logindatas, _login_data)
    else
        Message.sendmsg(actor, ssrNetMsgCfg.YueHuiBiHu_SyncResponse, num, 0, 0, data)
    end
end

local function _onCalcAttr(actor, attrs)
    local Num = getplaydef(actor, VarCfg["B_�»Աӻ�_����"])
    local shuxing = {}
    if Num > 0 and Num <= 10 then
        shuxing[233] = Num
    end
    calcAtts(attrs, shuxing, "�¹�ӻ�")
end
GameEvent.add(EventCfg.onCalcAttr, _onCalcAttr, YueHuiBiHu)

--��¼����
local function _onLoginEnd(actor, logindatas)
    YueHuiBiHu.SyncResponse(actor, logindatas)
end
--�¼��ɷ�
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, YueHuiBiHu)
--ע��������Ϣ
Message.RegisterNetMsg(ssrNetMsgCfg.YueHuiBiHu, YueHuiBiHu)
return YueHuiBiHu
