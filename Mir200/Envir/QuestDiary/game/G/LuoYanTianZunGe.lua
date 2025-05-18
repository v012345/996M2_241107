local LuoYanTianZunGe = {}
LuoYanTianZunGe.ID = "落岩天尊阁"

--接收请求
function LuoYanTianZunGe.Request(actor)
    local Bool = getflagstatus(actor,VarCfg["F_土缚劫击杀标识"])
    if Bool == 1 then
        map(actor, "落岩天尊阁")
    else
        Player.sendmsgEx(actor, "提示#251|:#255|对不起,你未通过|土缚劫#249|无法进入...")
    end
end

--注册网络消息
Message.RegisterNetMsg(ssrNetMsgCfg.LuoYanTianZunGe, LuoYanTianZunGe)
return LuoYanTianZunGe