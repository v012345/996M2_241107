local BenFutoKuaFuRunScript = {}

--跨服到本服执行攻沙传送
BenFutoKuaFuRunScript[1] = function(actor, arg1)
    arg1            = tonumber(arg1)
    local isInRange = FCheckNPCRange(actor, 126, 15)
    if not isInRange then
        Player.sendmsgEx(actor, "距离太远#249")
        return
    end
    local isGongSha = castleinfo(5)
    if not isGongSha then
        Player.sendmsgEx(actor, "非攻沙时间,禁止传送#249")
        return
    end
    if arg1 == 1 then
        mapmove(actor, "kuafu3", 146, 160) --复活点
    elseif arg1 == 2 then
        mapmove(actor, "kuafu3", 134, 184) --武器店
    elseif arg1 == 3 then
        mapmove(actor, "kuafu3", 166, 152) --衣服店
    elseif arg1 == 4 then
        mapmove(actor, "kuafu3", 173, 200) --大门
    end
    local name = getbaseinfo(actor, ConstCfg.gbase.name)
    guildnoticemsg(actor, 251, 249, "勇士【" .. name .. "】开始征战沙城！")
end

BenFutoKuaFuRunScript[2] = function(actor, arg1)
    GameEvent.push(EventCfg.onKFGongShaRewardSync, actor)
end

BenFutoKuaFuRunScript[3] = function(actor, arg1)
    GameEvent.push(EventCfg.onKFGongShaLinQu, actor)
end
return BenFutoKuaFuRunScript
