local QiYuFuBen = {}
local config = include("QuestDiary/cfgcsv/cfg_LuckyEvent_BoxData.lua")
local FuBenName = { "ʱ֮��϶-��ڤ", "ʱ֮��϶-�þ�", "ʱ֮��϶-����", "ʱ֮��϶-��ڤ", "ʱ֮��϶-����", "ʱ֮��϶-���", "ʱ֮��϶-����", "ʱ֮��϶-����" }
local qyBanMaps = {
    ["��ҹ����"] = true
}
function QiYuFuBen.Request(actor, arg1, arg2, arg3, arg4)
    local NowMapID = getbaseinfo(actor, ConstCfg.gbase.mapid)
    if qyBanMaps[NowMapID] then
        Player.sendmsgEx(actor, "��ʾ#251|:#255|��ǰ��ͼ��ֹ������������!#249")
        return
    end
    local EventName = getplaydef(actor, VarCfg["S$��������"])
    ------------------��֤����------------------
    local NotInTheFuBen = true
    for _, v in ipairs(FuBenName) do
        if v == EventName then
            NotInTheFuBen = false
            break
        end
    end
    if NotInTheFuBen then return end
    ------------------��֤����------------------
    local cfg = {}
    for _, V in ipairs(config) do
        if V.EnevtName == EventName then
            cfg = V
            break
        end
    end

    local NowX, NowY = getbaseinfo(actor, ConstCfg.gbase.x), getbaseinfo(actor, ConstCfg.gbase.y)

    local HuiChenginfo = { ["NowMapID"] = NowMapID, ["NowX"] = NowX, ["NowY"] = NowY }
    Player.setJsonVarByTable(actor, VarCfg["T_���븱����¼�˳���Ϣ"], HuiChenginfo)

    local UserName = getconst(actor, "<$USERID>")
    local FormerMapId = cfg.MapID                    --��ȡԭʼ��ͼID
    local NewMapId = FormerMapId .. UserName         --����ԭʼ��ͼid  �����µ�ͼID

    local NameTbl = string.split(cfg.EnevtName, "-") --��ȡ��������  NameTbl[2] --����
    local NewMapName = NameTbl[2] .. "[����]"
    local MonTbl = cfg.Mob_MonName
    if checkmirrormap(NewMapId) then
        killmonsters(NewMapId, "*", 0, false) --ɱ����ǰ��ͼ���й���
        delmirrormap(NewMapId)                --ɾ�������ͼ
        addmirrormap(FormerMapId, NewMapId, NewMapName, 1800, NowMapID, nil, NowX, NowY)
    else
        addmirrormap(FormerMapId, NewMapId, NewMapName, 1800, NowMapID, nil, NowX, NowY)
    end
    map(actor, NewMapId)

    --������������ �ر�Ѳ���һ�
    XunHangGuaJi.CloseGuaJi(actor)
    --�����ͼˢ��
    for i = 1, #MonTbl do
        genmon(NewMapId, 0, 0, MonTbl[i], 50, cfg.Mob_MonNum, 249)
    end
    setplaydef(actor, VarCfg["S$��������"], "")

    GameEvent.push(EventCfg.onEntetMirrorMap, actor)
end

GameEvent.add(EventCfg.onKillMon, _onKillMon, QiYuFuBen)

function QiYuFuBen.CloseUI(actor, arg1, arg2, arg3, _QDevent)
    ----------------��֤����----------------
    local verify = getplaydef(actor, VarCfg["S$��������"])
    if verify ~= _QDevent[1] then
        Player.sendmsgEx(actor, "��ʾ#251|:#255|�Ƿ�����#249|")
        return
    end
    ----------------��֤����----------------
    QiYuHeZi.ClientAddEvent(actor, verify)
    setplaydef(actor, VarCfg["S$��������"], "")
end

--�����¼��� ��ʼ����
local function _LuckyEventinitVar(actor, LuckyEventName)
    local IsFuBen = false
    for _, v in ipairs(FuBenName) do
        if v == LuckyEventName then
            IsFuBen = true
            break
        end
    end
    if IsFuBen then
        setplaydef(actor, VarCfg["S$��������"], LuckyEventName)
    end
end
GameEvent.add(EventCfg.LuckyEventinitVar, _LuckyEventinitVar, QiYuFuBen)

--ע��������Ϣ
Message.RegisterNetMsg(ssrNetMsgCfg.QiYuFuBen, QiYuFuBen)
return QiYuFuBen
