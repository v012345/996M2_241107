local AnHeiZhiDi = {}
AnHeiZhiDi.ID = "暗黑之地"
local npcID = 3456
--local config = include("QuestDiary/cfgcsv/cfg_AnHeiZhiDi.lua") --配置
local cost = {{}}
local give = {{}}
function chuansongdianfengdengji(actor)
    if getplaydef(actor,VarCfg["U_记录大陆"]) >= 5 then
        FOpenNpcShowEx(actor, 422)
    else
        Player.sendmsgEx(actor, "我报警了!#249")
    end
end

--接收请求
function AnHeiZhiDi.Request(actor)
    local var = getplaydef(actor,VarCfg["U_巅峰等级1"])
    if var < 1 then
        messagebox(actor,"你的巅峰·入世不足1重，是否前往提升？", "@chuansongdianfengdengji", "@quxiao")
        return
    end
    FMapMoveEx(actor, "暗黑之地", 207, 47, 0)
    --local name, num = Player.checkItemNumByTable(actor, cost)
    --if name then
        --Player.sendmsgEx(actor, string.format("你的|%s#249|不足|%d#249", name, num))
        --return
    --end
end
--同步消息
-- function AnHeiZhiDi.SyncResponse(actor, logindatas)
--     local data = {}
--     local _login_data = {ssrNetMsgCfg.AnHeiZhiDi_SyncResponse, 0, 0, 0, data}
--     if logindatas then
--         table.insert(logindatas, _login_data)
--     else
--         Message.sendmsg(actor, ssrNetMsgCfg.AnHeiZhiDi_SyncResponse, 0, 0, 0, data)
--     end
-- end
-- --登录触发
-- local function _onLoginEnd(actor, logindatas)
--     AnHeiZhiDi.SyncResponse(actor, logindatas)
-- end
-- --事件派发
-- GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, AnHeiZhiDi)
--注册网络消息
Message.RegisterNetMsg(ssrNetMsgCfg.AnHeiZhiDi, AnHeiZhiDi)
return AnHeiZhiDi