local XinYueMiBaoGe1 = {}

--接收请求
function XinYueMiBaoGe1.Request(actor, var)
    if var == 1 then
        if not checkitems(actor,"高级幻境通行证#1",0,0) then
            Player.sendmsgEx(actor, "提示#251|:#255|对不起,你背包内没有|高级幻境通行证#249|无法进入...")
            return
        end

        if getsysvar(VarCfg["A_幻境地图开关"]) ~= "开" then
            Player.sendmsgEx(actor, "提示#251|:#255|对不起,请在|22点05分--10点05分#249|之间进入...")
            return
        end
        map(actor, "新月秘宝阁1")
    end

    if var == 2 then
        local RiChongNum = getplaydef(actor, VarCfg["J_日冲记录"])
        if RiChongNum < 68 then
            Player.sendmsgEx(actor, "提示#251|:#255|对不起,你今日充值|不足68元#249|无法领取...")
            return
        end

        if getplaydef(actor, VarCfg["J_高级通行证领取状态"]) == 1 then
            Player.sendmsgEx(actor, "提示#251|:#255|对不起,你已领取过|高级幻境通行证#249|请勿重复领取...")
            return
        end

        if checkitems(actor, "高级幻境通行证#1", 0, 0) then
            local ItemObj = getitemobj(actor,"高级幻境通行证")
            local _time  = getitemaddvalue(actor, ItemObj, 2, 0)
            local time = (_time + 86400 >= 172800 and 172800) or _time + 86400
            setitemaddvalue(actor,ItemObj, 2, 0, time)
            Player.sendmsgEx(actor, "提示#251|:#255|恭喜你,成功领取|高级幻境通行证#249|时间已叠加24小时...")
        else
            giveitem(actor, "高级幻境通行证", 1, 0, "每日充值获取")
            Player.sendmsgEx(actor, "提示#251|:#255|恭喜你,成功领取|高级幻境通行证#249|已经发放到背包...")
        end

        setplaydef(actor, VarCfg["J_高级通行证领取状态"], 1)
        XinYueMiBaoGe1.SyncResponse(actor)
    end


end
--同步消息
function XinYueMiBaoGe1.SyncResponse(actor, logindatas)
    local TongXingZheng = 0
    if checkitems(actor, "高级幻境通行证#1", 0, 0) then
        TongXingZheng = 1
    end
    local RiChongNum = getplaydef(actor, VarCfg["J_日冲记录"])

    local _login_data = {ssrNetMsgCfg.XinYueMiBaoGe1_SyncResponse, TongXingZheng, RiChongNum, 0, nil}
    if type(logindatas) == "table" then
        table.insert(logindatas, _login_data)
    else
        Message.sendmsg(actor, ssrNetMsgCfg.XinYueMiBaoGe1_SyncResponse, TongXingZheng, RiChongNum, 0, nil)
    end
end
Message.RegisterNetMsg(ssrNetMsgCfg.XinYueMiBaoGe1, XinYueMiBaoGe1)


--登录触发
local function _onLoginEnd(actor, logindatas)
    XinYueMiBaoGe1.SyncResponse(actor, logindatas)
end
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, XinYueMiBaoGe1)


return XinYueMiBaoGe1