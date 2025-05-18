ShengSiJingJie = {}
ShengSiJingJie.ID = "生死境界"
local npcID = 325
--local config = include("QuestDiary/cfgcsv/cfg_ShengSiJingJie.lua") --配置
local cost = {{"金币",30000000}}
function go_ling_hun_lao_long_npc(actor)
    opennpcshowex(actor,324,2,2)
end
--接收请求
function ShengSiJingJie.Request1(actor)
    if not FCheckNPCRange(actor, npcID, 15) then
        Player.sendmsgEx(actor, "距离PNC太远!#249")
        return
    end
    if getflagstatus(actor,VarCfg["F_剧情_生死境界_地图开启"]) == 1 then
        Player.sendmsgEx(actor, "你已经开启了[生死境界]地图!#249")
        return
    end
    local count = getplaydef(actor,VarCfg["U_剧情_灵魂牢笼_次数"])
    if count < 10 then
        messagebox(actor, "解放灵魂次数不足10次,无法开启地图,是否前往NPC[灵魂牢笼]解放灵魂?","@go_ling_hun_lao_long_npc","@exit")
        return
    end
    local name, num = Player.checkItemNumByTable(actor, cost)
    if name then
        Player.sendmsgEx(actor, string.format("开启失败,你的|%s#249|不足|%d#249", name, num))
        return
    end
    Player.takeItemByTable(actor, cost, "生死境界")
    setflagstatus(actor,VarCfg["F_剧情_生死境界_地图开启"],1)
    Player.sendmsgEx(actor, "恭喜你成功开启[生死境界]地图!")
end
function ShengSiJingJie.Request2(actor)
    if not FCheckNPCRange(actor, npcID, 15) then
        Player.sendmsgEx(actor, "距离PNC太远!#249")
        return
    end
    if getflagstatus(actor,VarCfg["F_剧情_生死境界_地图开启"]) == 0 then
        Player.sendmsgEx(actor, "你没有开启[生死境界]地图,无法进入!")
        return
    end
    map(actor, "生死境界")
end
--同步消息
function ShengSiJingJie.SyncResponse(actor, logindatas)
    local data = {}
    local count = getplaydef(actor,VarCfg["U_剧情_灵魂牢笼_次数"])
    local flag = getflagstatus(actor,VarCfg["F_剧情_生死境界_地图开启"])
    local _login_data = {ssrNetMsgCfg.ShengSiJingJie_SyncResponse, count, flag, 0, data}
    if logindatas then
        table.insert(logindatas, _login_data)
    else
        Message.sendmsg(actor, ssrNetMsgCfg.ShengSiJingJie_SyncResponse, count, flag, 0, data)
    end
end
--登录触发
local function _onLoginEnd(actor, logindatas)
    ShengSiJingJie.SyncResponse(actor, logindatas)
end
--事件派发
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, ShengSiJingJie)
--注册网络消息
Message.RegisterNetMsg(ssrNetMsgCfg.ShengSiJingJie, ShengSiJingJie)
return ShengSiJingJie