local YueYeMiShi = {}
YueYeMiShi.ID = "月夜密室"
local npcID = 827
--local config = include("QuestDiary/cfgcsv/cfg_YueYeMiShi.lua") --配置
local cost = { { "泰兰德的金香蕉", 1 }, { "异界神石", 8 } }
local give = { {} }
function exit_yue_ye_mi_shi(actor)
    mapmove(actor, "月辉殿堂三层", 79, 76, 2)
    if getflagstatus(actor, VarCfg.F_isGuaJi) == 1 then
        startautoattack(actor)
    end
end

function delay_run_yue_ye_mi_shi_exit(actor)
    senddelaymsg(actor, "当前地图剩余时间:%s", 7200, 250, 1, "exit_yue_ye_mi_shi", 0)
end

--接收请求
function YueYeMiShi.Request(actor)
    local name, num = Player.checkItemNumByTable(actor, cost)
    if name then
        Player.sendmsgEx(actor, string.format("进入地图失败,你的|%s#249|不足|%d#249", name, num))
        return
    end
    Player.takeItemByTable(actor, cost, "月夜密室进入")
    map(actor, "月夜密室")
    delaygoto(actor, 1000, "delay_run_yue_ye_mi_shi_exit")
end

--同步消息
-- function YueYeMiShi.SyncResponse(actor, logindatas)
--     local data = {}
--     local _login_data = {ssrNetMsgCfg.YueYeMiShi_SyncResponse, 0, 0, 0, data}
--     if logindatas then
--         table.insert(logindatas, _login_data)
--     else
--         Message.sendmsg(actor, ssrNetMsgCfg.YueYeMiShi_SyncResponse, 0, 0, 0, data)
--     end
-- end
--登录触发
local function _onLoginEnd(actor, logindatas)
    -- YueYeMiShi.SyncResponse(actor, logindatas)
    if FCheckBagEquip(actor, "月亮井") then
        setontimer(actor,11,15,0,1)
    end
end
--事件派发
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, YueYeMiShi)
local function _onTakeOnEx(actor, itemobj, where, itemname, makeid)
    if itemname == "月亮井" then
        setontimer(actor,11,15,0,1)
    end
end
GameEvent.add(EventCfg.onTakeOnEx, _onTakeOnEx, YueYeMiShi)
local function _onTakeOffEx(actor, itemobj, where, itemname, makeid)
    if itemname == "月亮井" then
        setofftimer(actor,11)
    end
end
GameEvent.add(EventCfg.onTakeOffEx, _onTakeOffEx, YueYeMiShi)


--注册网络消息
Message.RegisterNetMsg(ssrNetMsgCfg.YueYeMiShi, YueYeMiShi)
return YueYeMiShi
