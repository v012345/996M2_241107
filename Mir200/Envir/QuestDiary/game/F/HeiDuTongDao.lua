local HeiDuTongDao = {}
local ItemCfg = {["腐化メ虚伪"]= true,["腐化メ恐惧"]= true,["腐化メ残暴"]= true,["腐化メ奸诈"]= true}
function HeiDuTongDao.Request(actor)
    local itemNum = 0
    for i = 77, 99 do
        local itemnane = getiteminfo(actor, linkbodyitem(actor, i), 7)
        if ItemCfg[itemnane] then
            itemNum = itemNum + 1
        end
    end
    if itemNum < 2 then
        Player.sendmsgEx(actor, "提示#251|:#255|对不起,你佩戴的|腐化装备#249|,不足|2件#249|,进入失败...")
        return
    end

    local DianFengLevel = getplaydef(actor,VarCfg["U_巅峰等级3"])
    if DianFengLevel < 5 then
        Player.sendmsgEx(actor, "提示#251|:#255|对不起,你未达到|巅峰内敛5#249|,进入失败...")
        return
    end


    map(actor,"黑度通道")

end

--注册网络消息
Message.RegisterNetMsg(ssrNetMsgCfg.HeiDuTongDao, HeiDuTongDao)
return HeiDuTongDao
