local BiBoTianZunGe = {}
BiBoTianZunGe.ID = "碧波天尊阁"

--接收请求
function BiBoTianZunGe.Request(actor)
    local Bool = getflagstatus(actor,VarCfg["F_水镜劫击杀标识"])
    if Bool == 1 then
        map(actor, "碧波天尊阁")
    else
        Player.sendmsgEx(actor, "提示#251|:#255|对不起,你未通过|水镜劫#249|无法进入...")
    end
end

--注册网络消息
Message.RegisterNetMsg(ssrNetMsgCfg.BiBoTianZunGe, BiBoTianZunGe)
return BiBoTianZunGe