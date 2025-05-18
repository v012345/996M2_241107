local QiYuShiJian16 = {}
local config = include("QuestDiary/cfgcsv/cfg_LuckyEvent_HeiShiShangRen.lua")

function QiYuShiJian16.Request(actor, arg1)
    ------------------------------验证奇遇--------------------------------
    local verify = getplaydef(actor,VarCfg["S$奇遇事件16"])
    if verify ~= "黑市商人" then
        Player.sendmsgEx(actor, "提示#251|:#255|非法请求#249|")
        return
    end
    ------------------------------验证奇遇--------------------------------
    local cfg = config[arg1]
    local var1 = getplaydef(actor, VarCfg["J_".. cfg.varname ..""])

    if var1 >= 3 then
        Player.sendmsgEx(actor, "提示#251|:#255|已购买|3#249|次...")
        return
    end

    local name, num = Player.checkItemNumByTable(actor, cfg.price)
    if name then
        Player.sendmsgEx(actor, string.format("提示#251|:#255|你的|%s#249|不足|%d#249|...", name, num))
        return
    end
    Player.takeItemByTable(actor, cfg.price, "消耗")
    Player.giveItemByTable(actor,cfg.item,"黑市商人", 1, true)
    setplaydef(actor, VarCfg["J_".. cfg.varname ..""], var1 + 1)
    QiYuShiJian16.SyncResponse(actor)
    GameEvent.push(EventCfg.onHeiShiShangRneBuy, actor)
end

--注册网络消息
function QiYuShiJian16.SyncResponse(actor)
    local num1 = getplaydef(actor, VarCfg["J_黑市限购1"])
    local num2 = getplaydef(actor, VarCfg["J_黑市限购2"])
    local num3 = getplaydef(actor, VarCfg["J_黑市限购3"])
    local num4 = getplaydef(actor, VarCfg["J_黑市限购4"])
    local num5 = getplaydef(actor, VarCfg["J_黑市限购5"])
    local num6 = getplaydef(actor, VarCfg["J_黑市限购6"])
    local num7 = getplaydef(actor, VarCfg["J_黑市限购7"])
    local num8 = getplaydef(actor, VarCfg["J_黑市限购8"])
    local data = {num1,num2,num3,num4,num5,num6,num7,num8}
    Message.sendmsg(actor, ssrNetMsgCfg.QiYuShiJian16_SyncResponse, 0, 0, 0, data)
end
Message.RegisterNetMsg(ssrNetMsgCfg.QiYuShiJian16, QiYuShiJian16)

function QiYuShiJian16.CloseUI(actor)
    ----------------验证奇遇----------------
    local verify = getplaydef(actor,VarCfg["S$奇遇事件16"])
    if verify ~= "黑市商人" then
        Player.sendmsgEx(actor, "提示#251|:#255|非法请求#249|")
        return
    end
    ----------------验证奇遇----------------
    QiYuHeZi.ClientAddEvent(actor,verify)
    setplaydef(actor,VarCfg["S$奇遇事件16"],"")
end


--灵符改变触发
local function _OverloadMoneyLingFu(actor, MoneyNum)
    if checktitle(actor,"地下皇帝") then
        local MoneyNum = getbindmoney(actor, "灵符")
        delattlist(actor, "地下皇帝属性组") --属性组
        local Attr = math.floor(MoneyNum / 1000) * 3
        if Attr > 15 then
            Attr = 15
        end
        local Attstr = "3#208#".. Attr .."|3#209#".. Attr .."|3#210#".. Attr .."|3#211#".. Attr .."|3#212#".. Attr .."|3#213#".. Attr .."|3#214#".. Attr ..""
        addattlist(actor,"地下皇帝属性组","+", Attstr)
    end
end
GameEvent.add(EventCfg.OverloadMoneyLingFu, _OverloadMoneyLingFu, QiYuShiJian16)


--登录触发
local function _onLoginEnd(actor)
    _OverloadMoneyLingFu(actor)
end
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, QiYuShiJian16)

--触发事件后 初始变量
local function _LuckyEventinitVar(actor, LuckyEventName,hezi)
    if LuckyEventName == "黑市商人" then
        if hezi == "盒子打开" then
            setplaydef(actor, VarCfg["S$奇遇事件16"], "黑市商人" )
            QiYuShiJian16.SyncResponse(actor)
        else
            setplaydef(actor, VarCfg["J_黑市限购1"], 0 )
            setplaydef(actor, VarCfg["J_黑市限购2"], 0 )
            setplaydef(actor, VarCfg["J_黑市限购3"], 0 )
            setplaydef(actor, VarCfg["J_黑市限购4"], 0 )
            setplaydef(actor, VarCfg["J_黑市限购5"], 0 )
            setplaydef(actor, VarCfg["J_黑市限购6"], 0 )
            setplaydef(actor, VarCfg["J_黑市限购7"], 0 )
            setplaydef(actor, VarCfg["J_黑市限购8"], 0 )
            setplaydef(actor, VarCfg["S$奇遇事件16"], "黑市商人" )
        end
    end
end
GameEvent.add(EventCfg.LuckyEventinitVar, _LuckyEventinitVar, QiYuShiJian16)


return QiYuShiJian16
