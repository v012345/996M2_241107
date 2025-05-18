local ChiYanTianZunGe = {}
ChiYanTianZunGe.ID = "炽焰天尊阁"

--接收请求
function ChiYanTianZunGe.Request(actor)
    local Bool = getflagstatus(actor,VarCfg["F_火焰劫击杀标识"])
    if Bool == 1 then
        map(actor, "炽焰天尊阁")
    else
        Player.sendmsgEx(actor, "提示#251|:#255|对不起,你未通过|火焰劫#249|无法进入...")
    end
end

--注册网络消息
Message.RegisterNetMsg(ssrNetMsgCfg.ChiYanTianZunGe, ChiYanTianZunGe)
return ChiYanTianZunGe