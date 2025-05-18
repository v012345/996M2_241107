local KongJianFaShi = {}

local cost = {{"破碎的魔法阵", 20}}
local give = {{"斗转星移[残]", 1}}


function KongJianFaShi.Request(actor)
    local name, num = Player.checkItemNumByTable(actor,cost)

    if getflagstatus(actor, VarCfg["F_空间法师"]) == 1 then
        Player.sendmsgEx(actor, "提示#251|:#255|你的|空间法师#249|任务|已完成#249|请勿重复提交...")
        return
    end

    if name then
        Player.sendmsgEx(actor, "提示#251|:#255|你的|破碎的魔法阵#249|不足|20个#249|领取失败...")
        return
    end
    Player.takeItemByTable(actor,cost,"拿走破碎的魔法阵")
    Player.giveItemByTable(actor,give,"给与斗转星移[残]")
    Player.sendmsgEx(actor, "提示#251|:#255|恭喜你完成|空间法师#249|获得|斗转星移[残]#249|x1...")
    setflagstatus(actor,VarCfg["F_空间法师"],1)
    -- FSetTaskRedPoint(actor, VarCfg["F_空间法师"], 3)
end

--注册网络消息，必备
Message.RegisterNetMsg(ssrNetMsgCfg.KongJianFaShi, KongJianFaShi)

return KongJianFaShi