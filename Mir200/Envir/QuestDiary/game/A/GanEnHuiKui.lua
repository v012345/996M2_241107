local GanEnHuiKui = {}

--打开前端日冲界面

function GanEnHuiKui.Request(actor,  var)
    if var == 1 then
        local heQuDay = tonumber(getconst("0", "<$HFCOUNT>"))
        if heQuDay == 0 then
            Player.sendmsgEx(actor, "提示#251|:#255|当前区服|还未合区#249|请合区后查看...")
        else
            Message.sendmsg(actor, ssrNetMsgCfg.GanEnHuiKui_OpenClientUI, 0, 0, 0, nil)
        end
    end

    if var == 2 then
        local ZhiGouBoll = getflagstatus(actor, VarCfg["F_解绑状态"])
        if ZhiGouBoll == 0 then
            Player.sendmsgEx(actor, "提示#251|:#255|对不起,你不是|特权玩家#249|无法领取...")
            return
        end
        local LingQuState = getplaydef(actor, VarCfg["Z_每日特权礼包领取状态"])
        if LingQuState == "已领取" then
            Player.sendmsgEx(actor, "提示#251|:#255|对不起,你今天已经领取过|特权礼包#249|了,请到明天再来...")
            return
        end
        giveitem(actor,"10元充值红包",1,ConstCfg.binding,"感恩活动每日领取")
        giveitem(actor,"每日特权礼包",1,ConstCfg.binding,"感恩活动每日领取")
        setplaydef(actor, VarCfg["Z_每日特权礼包领取状态"],"已领取")
        GanEnHuiKui.SyncResponse(actor)
    end

    if var == 3 then
        if checktitle(actor,"感恩回馈") then
            Player.sendmsgEx(actor, "提示#251|:#255|对不起,你已领取过|感恩回馈#249|称号了...")
            return
        end
        confertitle(actor,"感恩回馈",1)
        Player.sendmsgEx(actor, "提示#251|:#255|恭喜你,获得|感恩回馈#249|称号...")
        Player.setAttList(actor, "属性附加")
    end

end

--注册网络消息
function GanEnHuiKui.SyncResponse(actor)
    local LingQuBoll = getplaydef(actor, VarCfg["Z_每日特权礼包领取状态"])
    local data = {LingQuBoll}
    Message.sendmsg(actor, ssrNetMsgCfg.GanEnHuiKui_SyncResponse, 0, 0, 0, data)
end
Message.RegisterNetMsg(ssrNetMsgCfg.GanEnHuiKui, GanEnHuiKui)

return GanEnHuiKui
