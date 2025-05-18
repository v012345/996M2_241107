local MoHuaTianShiD = {}
local cost1 = {{"[吞噬]骨火之灵", 1},{"毁灭·魔化天使[無盡]", 1},{"天工之锤", 2888},{"焚天石", 2888},{"元宝", 4000000}}
local cost2 = {{"[吞噬]骨火之灵", 1},{"毁灭·魔化天使[無盡]", 1},{"天工之锤", 2888},{"焚天石", 2888},{"灵符", 10000}}

function MoHuaTianShiD.Request(actor ,arg1)
    if arg1 == 1 then
        local _num = getplaydef(actor,VarCfg["U_魔化天使[吞噬]"])
        local name, num = Player.checkItemNumByTable(actor, cost1)
        if name then
            Player.sendmsgEx(actor, string.format("提示#251|:#255|你的|%s#249|不足|%d#249|...", name, num))
            return
        end
        _num = _num + 1
        setplaydef(actor, VarCfg["U_魔化天使[吞噬]"], _num)
        if _num == 1 or _num == 2 or _num == 3 then
            Player.sendmsgEx(actor, "提示#251|:#255|对不起,合成|毁灭·魔化天使[吞噬]#249|失败...")
            Player.takeItemByTable(actor, {{"元宝", 4000000}}, "毁灭·魔化天使[吞噬]失败扣除元宝")
        elseif _num == 4 or _num == 5 then
            if randomex(1, 2) then --4-5是50%
                giveitem(actor, "毁灭·魔化天使[吞噬]", 1, ConstCfg.binding)
                Player.takeItemByTable(actor, cost1, "吞噬成功扣除材料")
                setflagstatus(actor,VarCfg["F_毁灭·魔化天使[吞噬]_完成"],1)
                Player.sendmsgEx(actor, "提示#251|:#255|恭喜你,合成|毁灭·魔化天使[永恆]#249|成功...")
            else
                Player.sendmsgEx(actor, "提示#251|:#255|对不起,合成|毁灭·魔化天使[吞噬]#249|失败...")
                Player.takeItemByTable(actor, {{"元宝", 4000000}}, "毁灭·魔化天使[吞噬]失败扣除元宝")
            end
        elseif _num >= 6 then
            giveitem(actor, "毁灭·魔化天使[吞噬]", 1, ConstCfg.binding)
            Player.sendmsgEx(actor, "提示#251|:#255|恭喜你,合成|毁灭·魔化天使[永恆]#249|成功...")
            Player.takeItemByTable(actor, cost1, "吞噬成功扣除材料")
            setflagstatus(actor,VarCfg["F_毁灭·魔化天使[吞噬]_完成"],1)
        end
        MoHuaTianShiD.SyncResponse(actor)
    end

    if arg1 == 2 then
        local name, num = Player.checkItemNumByTable(actor, cost2)
        if name then
            Player.sendmsgEx(actor, string.format("提示#251|:#255|你的|%s#249|不足|%d#249|...", name, num))
            return
        end
        Player.takeItemByTable(actor, cost2, "吞噬成功扣除材料")
        giveitem(actor, "毁灭·魔化天使[吞噬]", 1, ConstCfg.binding)
        setflagstatus(actor,VarCfg["F_毁灭·魔化天使[吞噬]_完成"],1)
        Player.sendmsgEx(actor, "提示#251|:#255|恭喜你合成|毁灭·魔化天使[無盡]#249|成功...")
        MoHuaTianShiD.SyncResponse(actor)
    end

end

function MoHuaTianShiD.SyncResponse(actor)
    Message.sendmsg(actor, ssrNetMsgCfg.MoHuaTianShiD_SyncResponse, 0, 0, 0, nil)
end

--注册网络消息
Message.RegisterNetMsg(ssrNetMsgCfg.MoHuaTianShiD, MoHuaTianShiD)
return MoHuaTianShiD