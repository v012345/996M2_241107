local MoHuaTianShiC = {}
local cost1 = {{"[無盡]死神之盾", 1},{"毁灭·魔化天使[傳奇]", 1},{"天工之锤", 1888},{"焚天石", 1888},{"金币", 60000000}}
local cost2 = {{"[無盡]死神之盾", 1},{"毁灭·魔化天使[傳奇]", 1},{"天工之锤", 1888},{"焚天石", 1888},{"元宝", 5000000}}

function MoHuaTianShiC.Request(actor ,arg1)
    if arg1 == 1 then
        local name, num = Player.checkItemNumByTable(actor, cost1)
        if name then
            Player.sendmsgEx(actor, string.format("提示#251|:#255|你的|%s#249|不足|%d#249|...", name, num))
            return
        end
        MoHuaTianShiC.SyncResponse(actor)

        if randomex(15, 100) then    --  显示40%  实际15%
            giveitem(actor, "毁灭·魔化天使[無盡]", 1, 0)
            Player.takeItemByTable(actor, cost1, "扣除材料")
            Player.sendmsgEx(actor, "提示#251|:#255|恭喜你,合成|毁灭·魔化天使[永恆]#249|成功...")
        else
            Player.sendmsgEx(actor, "提示#251|:#255|对不起,合成|毁灭·魔化天使[永恆]#249|失败...")
            Player.takeItemByTable(actor, {{"金币", 60000000}}, "失败扣除金币")
        end
    end

    if arg1 == 2 then
        local name, num = Player.checkItemNumByTable(actor, cost2)
        if name then
            Player.sendmsgEx(actor, string.format("提示#251|:#255|你的|%s#249|不足|%d#249|...", name, num))
            return
        end
        Player.takeItemByTable(actor, cost2, "扣除材料")
        giveitem(actor, "毁灭·魔化天使[無盡]", 1, 0)
        Player.sendmsgEx(actor, "提示#251|:#255|恭喜你合成|毁灭·魔化天使[無盡]#249|成功...")
        MoHuaTianShiC.SyncResponse(actor)
    end
end

function MoHuaTianShiC.SyncResponse(actor)
    Message.sendmsg(actor, ssrNetMsgCfg.MoHuaTianShiC_SyncResponse, 0, 0, 0, nil)
end

--注册网络消息
Message.RegisterNetMsg(ssrNetMsgCfg.MoHuaTianShiC, MoHuaTianShiC)
return MoHuaTianShiC