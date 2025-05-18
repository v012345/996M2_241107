local YeFengWangZuo = {}
YeFengWangZuo.ID = "夜风王座"
--接收请求
function YeFengWangZuo.Request(actor)
    if checkitemw(actor,"黑刀·夜", 1) then
        map(actor, "夜风王座")
    else
        Player.sendmsgEx(actor, "提示#251|:#255|对不起,你没有配到|黑刀·夜#249|无法进入...")
        return
    end
end
--注册网络消息
Message.RegisterNetMsg(ssrNetMsgCfg.YeFengWangZuo, YeFengWangZuo)
return YeFengWangZuo