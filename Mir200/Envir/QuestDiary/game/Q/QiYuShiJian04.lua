local QiYuShiJian04 = {}
local num = nil

function QiYuShiJian04.Request(actor, arg1)
    ----------------验证奇遇----------------
    local verify = getplaydef(actor,VarCfg["S$奇遇事件4"])
    if verify ~= "荒野迷宫" then
        Player.sendmsgEx(actor, "提示#251|:#255|非法请求#249|")
        return
    end

    if num ~=  arg1 then
        Player.sendmsgEx(actor, "提示#251|:#255|非法请求#249|")
        return
    end
    ----------------验证奇遇----------------

    if arg1 == 1 then
        if verify == "荒野迷宫" then
            local UserId = getconst(actor, "<$USERID>")
            sendmail(UserId, 5001, "荒野迷宫", "恭喜你获得焚天石x10","焚天石#10")
            Player.sendmsgEx(actor, "提示#251|:#255|恭喜你,获得|焚天石x10#249|...")
            setplaydef(actor, VarCfg["S$奇遇事件4"], "")
        end
    elseif arg1 == 2 then  --减少20血量
        humanhp(actor, "-", Player.getHpValue(actor, 20), 1)
        Player.sendmsgEx(actor, "提示#251|:#255|你掉进了陷阱内,|生命值#249|减少|20%#249|...")
        setplaydef(actor, VarCfg["S$奇遇事件4"], "")
    elseif arg1 == 3 then
        if verify == "荒野迷宫" then
            local UserId = getconst(actor, "<$USERID>")
            sendmail(UserId, 5001, "荒野迷宫", "恭喜你获得10万金币","绑定金币#100000")
            Player.sendmsgEx(actor, "提示#251|:#255|恭喜你,获得|10万#249|金币...")
            setplaydef(actor, VarCfg["S$奇遇事件4"], "")
        end
    elseif arg1 == 4 then
        addmpper(actor, "=", 0)
        Player.sendmsgEx(actor, "提示#251|:#255|你掉进了陷阱内,|魔法值#249|减少|100%#249|...")
        setplaydef(actor, VarCfg["S$奇遇事件4"], "")
    end
end

function QiYuShiJian04.CloseUI(actor)
    ----------------验证奇遇----------------
    local verify = getplaydef(actor,VarCfg["S$奇遇事件4"])
    if verify ~= "荒野迷宫" then
        Player.sendmsgEx(actor, "提示#251|:#255|非法请求#249|")
        return
    end
    ----------------验证奇遇----------------
    QiYuHeZi.ClientAddEvent(actor,verify)
    setplaydef(actor,VarCfg["S$奇遇事件4"],"")
end

--触发事件后 初始变量
local function _LuckyEventinitVar(actor, LuckyEventName)
    if LuckyEventName == "荒野迷宫" then
        setplaydef(actor, VarCfg["S$奇遇事件4"], "荒野迷宫" )
    end
end
GameEvent.add(EventCfg.LuckyEventinitVar, _LuckyEventinitVar, QiYuShiJian04)

--注册网络消息
function QiYuShiJian04.SyncResponse(actor, logindatas)
    num = math.random(1, 4)
    local data = {num}
    Message.sendmsg(actor, ssrNetMsgCfg.QiYuShiJian04_SyncResponse, 0, 0, 0, data)
end
Message.RegisterNetMsg(ssrNetMsgCfg.QiYuShiJian04, QiYuShiJian04)


return QiYuShiJian04
