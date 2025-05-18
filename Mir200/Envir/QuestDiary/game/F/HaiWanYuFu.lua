local HaiWanYuFu = {}
local cost       = { { "海纹石片", 188 } }
local give       = { { "海灵之泪", 1 } }
function get_hai_ling_zhi_lei(actor)
    local num = getplaydef(actor, VarCfg["U_海灵之泪获取"])
    if num >= 3 then
        Player.sendmsgEx(actor, "海灵之泪只能获取3次#249")
        return
    else
        setplaydef(actor, VarCfg["U_海灵之泪获取"], num + 1)
        Player.giveItemByTable(actor, give, "海灵之泪获取", 1, true)
    end
end

function HaiWanYuFu.Request(actor)
    local name, num = Player.checkItemNumByTable(actor, cost)
    if name then
        Player.sendmsgEx(actor, string.format("提示#251|:#255|你的|%s#249|不足|%d#249|...", name, num))
        return
    end
    Player.takeItemByTable(actor, cost, "潮影钩矛获取")
    giveitem(actor, "潮影钩矛", 1, ConstCfg.binding)
    FSetTaskRedPoint(actor, VarCfg["F_潮影钩矛合成"], 52)
    setflagstatus(actor, VarCfg["F_潮影钩矛合成"], 1)
    Player.sendmsgEx(actor, "提示#251|:#255|恭喜你合成|潮影钩矛#249|成功...")
    HaiWanYuFu.SyncResponse(actor)
end

--对沉船遗物伤害 - 20000
local function _onAttackMonster(actor, Target, Hiter, MagicId, qieGe)
    local MonName = getbaseinfo(Target, ConstCfg.gbase.name)
    if MonName ~= "沉船遗物" then return end
    if not checkitemw(actor, "潮影钩矛", 1) then return end
    humanhp(Target, "-", 20000, 1, 0, actor)
end
GameEvent.add(EventCfg.onAttackMonster, _onAttackMonster, HaiWanYuFu)

-- 同步一次消息
function HaiWanYuFu.SyncResponse(actor)
    Message.sendmsg(actor, ssrNetMsgCfg.HaiWanYuFu_SyncResponse, 0, 0, 0, nil)
end

local function _onClicknpc(actor, npcid, npcobj)
    if npcid == 623 then
        showprogressbardlg(actor, 3, "@get_hai_ling_zhi_lei", "获取海灵之泪%s...", 1, "")
    end
end

GameEvent.add(EventCfg.onClicknpc, _onClicknpc, HaiWanYuFu)

Message.RegisterNetMsg(ssrNetMsgCfg.HaiWanYuFu, HaiWanYuFu)

return HaiWanYuFu
