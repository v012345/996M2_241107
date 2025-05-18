local HaiWanYuFu = {}
local cost       = { { "����ʯƬ", 188 } }
local give       = { { "����֮��", 1 } }
function get_hai_ling_zhi_lei(actor)
    local num = getplaydef(actor, VarCfg["U_����֮���ȡ"])
    if num >= 3 then
        Player.sendmsgEx(actor, "����֮��ֻ�ܻ�ȡ3��#249")
        return
    else
        setplaydef(actor, VarCfg["U_����֮���ȡ"], num + 1)
        Player.giveItemByTable(actor, give, "����֮���ȡ", 1, true)
    end
end

function HaiWanYuFu.Request(actor)
    local name, num = Player.checkItemNumByTable(actor, cost)
    if name then
        Player.sendmsgEx(actor, string.format("��ʾ#251|:#255|���|%s#249|����|%d#249|...", name, num))
        return
    end
    Player.takeItemByTable(actor, cost, "��Ӱ��ì��ȡ")
    giveitem(actor, "��Ӱ��ì", 1, ConstCfg.binding)
    FSetTaskRedPoint(actor, VarCfg["F_��Ӱ��ì�ϳ�"], 52)
    setflagstatus(actor, VarCfg["F_��Ӱ��ì�ϳ�"], 1)
    Player.sendmsgEx(actor, "��ʾ#251|:#255|��ϲ��ϳ�|��Ӱ��ì#249|�ɹ�...")
    HaiWanYuFu.SyncResponse(actor)
end

--�Գ��������˺� - 20000
local function _onAttackMonster(actor, Target, Hiter, MagicId, qieGe)
    local MonName = getbaseinfo(Target, ConstCfg.gbase.name)
    if MonName ~= "��������" then return end
    if not checkitemw(actor, "��Ӱ��ì", 1) then return end
    humanhp(Target, "-", 20000, 1, 0, actor)
end
GameEvent.add(EventCfg.onAttackMonster, _onAttackMonster, HaiWanYuFu)

-- ͬ��һ����Ϣ
function HaiWanYuFu.SyncResponse(actor)
    Message.sendmsg(actor, ssrNetMsgCfg.HaiWanYuFu_SyncResponse, 0, 0, 0, nil)
end

local function _onClicknpc(actor, npcid, npcobj)
    if npcid == 623 then
        showprogressbardlg(actor, 3, "@get_hai_ling_zhi_lei", "��ȡ����֮��%s...", 1, "")
    end
end

GameEvent.add(EventCfg.onClicknpc, _onClicknpc, HaiWanYuFu)

Message.RegisterNetMsg(ssrNetMsgCfg.HaiWanYuFu, HaiWanYuFu)

return HaiWanYuFu
