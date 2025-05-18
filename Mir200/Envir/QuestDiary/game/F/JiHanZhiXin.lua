local JiHanZhiXin = {}
-- local cost = { { "冰河之心", 1 }, { "金币", 18800000 } }
local cost = { { "冰河之心", 1 }, { "金币", 1 } }

local function heChengSuccess(actor)
    giveitem(actor, "冰魂结晶", 1, ConstCfg.binding)
    setflagstatus(actor, VarCfg["F_冰魂结晶成功"], 1)
    Player.sendmsgEx(actor, "提示#251|:#255|恭喜你合成|冰魂结晶#249|成功...")
end
function JiHanZhiXin.Request(actor)
    local name, num = Player.checkItemNumByTable(actor, cost)
    if name then
        Player.sendmsgEx(actor, string.format("提示#251|:#255|你的|%s#249|不足|%d#249|枚,淬炼失败...", name, num))
        return
    end
    Player.takeItemByTable(actor, cost, "冰魂结晶扣除材料")
    local _Num = getplaydef(actor, VarCfg["T_极寒之心合成次数"])
    local Num = (_Num == "" and 0) or tonumber(_Num)
    setplaydef(actor, VarCfg["T_极寒之心合成次数"], Num + 1)
    if Num + 1 <= 6 then
        if randomex(5) then
            heChengSuccess(actor)
        else
            Player.sendmsgEx(actor, "提示#251|:#255|对不起,合成|冰魂结晶#249|失败...")
        end
    elseif Num + 1 >= 7 then
        heChengSuccess(actor)
    end
    JiHanZhiXin.SyncResponse(actor)
end

-- 同步一次消息
function JiHanZhiXin.SyncResponse(actor)
    Message.sendmsg(actor, ssrNetMsgCfg.JiHanZhiXin_SyncResponse, 0, 0, 0, nil)
end

Message.RegisterNetMsg(ssrNetMsgCfg.JiHanZhiXin, JiHanZhiXin)

return JiHanZhiXin
