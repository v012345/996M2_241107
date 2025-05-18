local ShiLuoGuiYu = {}
ShiLuoGuiYu.ID = "失落鬼域"
local npcID = 3064
--local config = include("QuestDiary/cfgcsv/cfg_ShiLuoGuiYu.lua") --配置
local cost = {{"阴",8},{"阳",8},{"金币",10000000}}
--接收请求
function ShiLuoGuiYu.Request(actor,index)
    if not FCheckNPCRange(actor, npcID, 15) then
        Player.sendmsgEx(actor, "距离PNC太远!#249")
        return
    end
    local falg = getflagstatus(actor,VarCfg["F_失落鬼域地图开启"])
    if index == 1 then
        if falg == 1  then
            Player.sendmsgEx(actor,"你已经开启了此地图!#249")
            return
        end
        local name, num = Player.checkItemNumByTable(actor, cost)
        if name then
            Player.sendmsgEx(actor, string.format("开启失败你的|%s#249|不足|%d#249", name, num))
            return
        end
        setflagstatus(actor, VarCfg["F_失落鬼域地图开启"], 1)
        Player.takeItemByTable(actor, cost,"开启失落鬼域")
        Player.sendmsgEx(actor,"开启地图成功!")
        ShiLuoGuiYu.SyncResponse(actor)
    elseif index == 2 then
        if falg == 1 then
            FMapMoveEx(actor,"失落鬼域",25,275)
        else
            Player.sendmsgEx(actor,"进入地图失败,你没有开启此地图!#249")
        end
    else

    end
end
--同步消息
function ShiLuoGuiYu.SyncResponse(actor, logindatas)
    local data = {}
    local falg = getflagstatus(actor,VarCfg["F_失落鬼域地图开启"])
    local _login_data = {ssrNetMsgCfg.ShiLuoGuiYu_SyncResponse, falg, 0, 0, data}
    if logindatas then
        table.insert(logindatas, _login_data)
    else
        Message.sendmsg(actor, ssrNetMsgCfg.ShiLuoGuiYu_SyncResponse, falg, 0, 0, data)
    end
end
--登录触发
local function _onLoginEnd(actor, logindatas)
    ShiLuoGuiYu.SyncResponse(actor, logindatas)
end
--事件派发
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, ShiLuoGuiYu)
--注册网络消息
Message.RegisterNetMsg(ssrNetMsgCfg.ShiLuoGuiYu, ShiLuoGuiYu)
return ShiLuoGuiYu