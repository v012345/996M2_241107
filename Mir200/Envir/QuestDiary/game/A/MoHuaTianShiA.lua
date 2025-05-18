local MoHuaTianShiA = {}
local cost = {{"魔化的眼罩", 1},{"圣灵壁垒+10", 1},{"天工之锤", 888},{"焚天石", 888},{"金币", 6000000}}

function MoHuaTianShiA.Request(actor ,arg1)
    local name, num = Player.checkItemNumByTable(actor, cost)
    if name then
        Player.sendmsgEx(actor, string.format("提示#251|:#255|你的|%s#249|不足|%d#249|...", name, num))
        return
    end
    Player.takeItemByTable(actor, cost, "扣除材料")
    giveitem(actor, "毁灭·魔化天使[永恆]", 1, 0)
    Player.sendmsgEx(actor, "提示#251|:#255|恭喜你合成|毁灭·魔化天使[永恆]#249|成功...")
    MoHuaTianShiA.SyncResponse(actor)
end

function MoHuaTianShiA.SyncResponse(actor)
    Message.sendmsg(actor, ssrNetMsgCfg.MoHuaTianShiA_SyncResponse, 0, 0, 0, nil)
end

--注册网络消息
Message.RegisterNetMsg(ssrNetMsgCfg.MoHuaTianShiA, MoHuaTianShiA)
return MoHuaTianShiA