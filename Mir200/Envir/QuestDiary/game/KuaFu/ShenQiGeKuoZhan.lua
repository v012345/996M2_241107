local ShenQiGeKuoZhan = {}
ShenQiGeKuoZhan.ID = "��������չ"
local npcID = 129
local config = include("QuestDiary/cfgcsv/cfg_ShenQiGeKuoZhan.lua") --����
local function _getCurrShenQiGeZi(actor)
    return getplaydef(actor, VarCfg["U_�¼ӱ�������������"])
end
--���ø�����
local function _setCurrShenQiGeZi(actor, num)
    setplaydef(actor, VarCfg["U_�¼ӱ�������������"], num)
end
--��������
function ShenQiGeKuoZhan.Request(actor, index)
    if not index then
        return
    end
    local currShenQiGeZi = _getCurrShenQiGeZi(actor)
    local cfg = config[currShenQiGeZi + 1]
    if not cfg then
        Player.sendmsgEx(actor, "���ֻ����չʮ������!#249")
        return
    end
    local cost = {}
    if index == 1 then
        cost = cfg.freeCost
    elseif index == 2 then
        cost = cfg.payCost
    else
        Player.sendmsgEx(actor, "��������!#249")
        return
    end
    local name, num = Player.checkItemNumByTable(actor, cost)
    if name then
        Player.sendmsgEx(actor, string.format("���|%s#249|����|%d#249", name, num))
        return
    end
    Player.takeItemByTable(actor, cost, "��������չ", 1)
    _setCurrShenQiGeZi(actor, currShenQiGeZi + 1)
    Player.sendmsgEx(actor, "��չ�ɹ�!")
    ShenQiGeKuoZhan.SyncResponse(actor)
end

--ͬ����Ϣ
function ShenQiGeKuoZhan.SyncResponse(actor, logindatas)
    local num = _getCurrShenQiGeZi(actor)
    local data = {}
    local _login_data = { ssrNetMsgCfg.ShenQiGeKuoZhan_SyncResponse, num, 0, 0, data }
    if logindatas then
        table.insert(logindatas, _login_data)
    else
        Message.sendmsg(actor, ssrNetMsgCfg.ShenQiGeKuoZhan_SyncResponse, num, 0, 0, data)
    end
end

--��¼����
local function _onLoginEnd(actor, logindatas)
    ShenQiGeKuoZhan.SyncResponse(actor, logindatas)
end
--�¼��ɷ�
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, ShenQiGeKuoZhan)
--ע��������Ϣ
Message.RegisterNetMsg(ssrNetMsgCfg.ShenQiGeKuoZhan, ShenQiGeKuoZhan)
return ShenQiGeKuoZhan
