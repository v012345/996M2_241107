local JiMieGuiXu = {}
local cost = {{"黑暗精华", 288},{"书页", 3888}}
function JiMieGuiXu.Request(actor)
    local skillinfo = getskillinfo(actor,2023,1)
    if skillinfo then
        Player.sendmsgEx(actor, "提示#251|:#255|你已经学习|寂灭归墟#249|请勿重复学习...")
        setflagstatus(actor,VarCfg["F_学习寂寞归墟"],1)
        return
    end

    local name, num = Player.checkItemNumByTable(actor, cost)
    if name then
        Player.sendmsgEx(actor, string.format("提示#251|:#255|你的|%s#249|数量不足|%d#249|,学习失败...", name, num))
        return
    end
    Player.takeItemByTable(actor, cost, "寂灭归墟学习")
    setflagstatus(actor,VarCfg["F_学习寂寞归墟"],1)
    addskill(actor, 2023,3)
    Player.sendmsgEx(actor, "提示#251|:#255|恭喜你,学习|寂灭归墟#249|成功...")

    JiMieGuiXu.SyncResponse(actor)
end

--使用技能触发
local function _onJiMieGuiXu(actor, target)
    if not Player.IsPlayer(target) then return end
    local MyLevel = getbaseinfo(actor,ConstCfg.gbase.level)
    local TgtLevel = getbaseinfo(target,ConstCfg.gbase.level)
    local x, y = Player.GetX(target),Player.GetY(target)
    if randomex(1,2) then
        rangeharm(actor, x, y, 3, 0, 6, getbaseinfo(actor,ConstCfg.gbase.dc2))    -- 冰冻2*2范围内敌人1秒
        if MyLevel > TgtLevel then           --对等级低于你的玩家概率将其冰冻2S
            rangeharm(actor, x, y, 3, 0, 2, 2, 0, 1)    -- 冰冻2*2范围内敌人1秒
        else                                 --对等级高于你的玩家概率减速2S.
            rangeharm(actor, x, y, 3, 0, 7, 2, 0, 1)    -- 冰冻2*2范围内敌人2秒
        end
    end
end
GameEvent.add(EventCfg["使用寂灭归墟"], _onJiMieGuiXu, JiMieGuiXu)

--注册网络消息
function JiMieGuiXu.SyncResponse(actor, logindatas)
    Message.sendmsg(actor, ssrNetMsgCfg.JiMieGuiXu_SyncResponse, 0, 0, 0, nil)
end
Message.RegisterNetMsg(ssrNetMsgCfg.JiMieGuiXu, JiMieGuiXu)

--登录触发
local function _onLoginEnd(actor, logindatas)
    JiMieGuiXu.SyncResponse(actor, logindatas)
end
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, JiMieGuiXu)

return JiMieGuiXu
