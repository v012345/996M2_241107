local MoHuaTianShiB = {}
local cost1 = {{"[傳奇]防护者", 1},{"毁灭·魔化天使[永恆]", 1},{"天工之锤", 1288},{"焚天石", 1288},{"金币", 30000000}}
local cost2 = {{"[傳奇]防护者", 1},{"毁灭·魔化天使[永恆]", 1},{"天工之锤", 1288},{"焚天石", 1288},{"元宝", 2000000}}

function MoHuaTianShiB.Request(actor ,arg1)
    if arg1 == 1 then
        local name, num = Player.checkItemNumByTable(actor, cost1)
        if name then
            Player.sendmsgEx(actor, string.format("提示#251|:#255|你的|%s#249|不足|%d#249|...", name, num))
            return
        end
        if randomex(25, 100) then    --  显示70%  实际25%
            giveitem(actor, "毁灭·魔化天使[傳奇]", 1, 0)
            Player.takeItemByTable(actor, cost1, "扣除材料")
            Player.sendmsgEx(actor, "提示#251|:#255|恭喜你,合成|毁灭·魔化天使[永恆]#249|成功...")
        else
            Player.sendmsgEx(actor, "提示#251|:#255|对不起,合成|毁灭·魔化天使[永恆]#249|失败...")
            Player.takeItemByTable(actor, {{"金币", 30000000}}, "失败扣除金币")
        end
        MoHuaTianShiB.SyncResponse(actor)
    end

    if arg1 == 2 then
        local name, num = Player.checkItemNumByTable(actor, cost2)
        if name then
            Player.sendmsgEx(actor, string.format("提示#251|:#255|你的|%s#249|不足|%d#249|...", name, num))
            return
        end
        Player.takeItemByTable(actor, cost2, "扣除材料")
        giveitem(actor, "毁灭·魔化天使[傳奇]", 1, 0)
        Player.sendmsgEx(actor, "提示#251|:#255|恭喜你合成|毁灭·魔化天使[傳奇]#249|成功...")
        MoHuaTianShiB.SyncResponse(actor)
    end

end

function MoHuaTianShiB.SyncResponse(actor)
    Message.sendmsg(actor, ssrNetMsgCfg.MoHuaTianShiB_SyncResponse, 0, 0, 0, nil)
end

--注册网络消息
Message.RegisterNetMsg(ssrNetMsgCfg.MoHuaTianShiB, MoHuaTianShiB)
return MoHuaTianShiB