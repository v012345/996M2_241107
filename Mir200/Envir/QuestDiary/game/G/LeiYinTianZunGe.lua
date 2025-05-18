local LeiYinTianZunGe = {}
LeiYinTianZunGe.ID = "雷隐天尊阁"

--接收请求
function LeiYinTianZunGe.Request(actor)
    local Bool = getflagstatus(actor,VarCfg["F_风隙劫击杀标识"])
    if Bool == 1 then
        map(actor, "雷隐天尊阁")
    else
        Player.sendmsgEx(actor, "提示#251|:#255|对不起,你未通过|风隙劫#249|无法进入...")
    end

end
--注册网络消息
Message.RegisterNetMsg(ssrNetMsgCfg.LeiYinTianZunGe, LeiYinTianZunGe)
return LeiYinTianZunGe