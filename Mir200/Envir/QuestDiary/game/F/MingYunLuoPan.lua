local MingYunLuoPan = {}
local cost = {{"命运碎片·海啸之纹", 10}}

function MingYunLuoPan.Request(actor)

    local name, num = Player.checkItemNumByTable(actor, cost)
    if name then
        Player.sendmsgEx(actor, string.format("提示#251|:#255|你的|%s#249|不足|%d#249|枚,打造失败...", name, num))
        return
    end

    Player.takeItemByTable(actor, cost, "§§命运罗盘§§")
    giveitem(actor, "§§命运罗盘§§", 1, ConstCfg.binding)
    setflagstatus(actor, VarCfg["F_§§命运罗盘§§_获取"], 1)
    Player.sendmsgEx(actor, "提示#251|:#255|恭喜你打造|§§命运罗盘§§#249|成功...")
    MingYunLuoPan.SyncResponse(actor)
end
local function _onKillMon(actor, monobj, monName)
    if getflagstatus(actor,VarCfg["F_深海恐惧·克拉肯_击杀"]) == 1 then
        return
    end
    if monName == "深海恐惧·克拉肯" then
        setflagstatus(actor,VarCfg["F_深海恐惧·克拉肯_击杀"],1)
    end
end

GameEvent.add(EventCfg.onKillMon, _onKillMon, MingYunLuoPan)
-- 同步一次消息
function MingYunLuoPan.SyncResponse(actor)
    Message.sendmsg(actor, ssrNetMsgCfg.MingYunLuoPan_SyncResponse, 0, 0, 0, nil)
end
Message.RegisterNetMsg(ssrNetMsgCfg.MingYunLuoPan, MingYunLuoPan)

return MingYunLuoPan
