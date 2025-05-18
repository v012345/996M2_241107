local SheChaoJinDi = {}
SheChaoJinDi.ID = "蛇巢禁地"
local npcID = 453
--local config = include("QuestDiary/cfgcsv/cfg_SheChaoJinDi.lua") --配置
local cost = { { "幻灵水晶", 188 }, { "元宝", 100000 } }
local give = { {} }
function she_chao_jin_di_end(actor)

end

function she_chao_jin_di(actor)
    senddelaymsg(actor, "1分钟之内杀死九只[噬渊之主·九头蛇]即可获得奖励,剩余时间:%s", 1799, 250, 1, "@she_chao_jin_di_end", 0)
end

function jiu_tou_she_shua_guai(actor, x, y)
    local myName = getbaseinfo(actor, ConstCfg.gbase.name)
    local newMapId = myName .. "蛇巢禁地"
    genmon(newMapId, tonumber(x), tonumber(y), "噬渊之主·九头蛇", 0, 1, 249)
end

--接收请求
function SheChaoJinDi.Request(actor)
    if not FCheckNPCRange(actor, npcID, 15) then
        Player.sendmsgEx(actor, "距离PNC太远!#249")
        return
    end

    local name, num = Player.checkItemNumByTable(actor, cost)
    if name then
        Player.sendmsgEx(actor, string.format("你的|%s#249|不足|%d#249", name, num))
        return
    end
    Player.takeItemByTable(actor, cost, "蛇巢禁地")
    local time = 1800
    local myName = getbaseinfo(actor, ConstCfg.gbase.name)
    local oldMapId = getbaseinfo(actor, ConstCfg.gbase.mapid)
    local x = getbaseinfo(actor, ConstCfg.gbase.x)
    local y = getbaseinfo(actor, ConstCfg.gbase.y)
    local newMapId = myName .. "蛇巢禁地"
    delmirrormap(newMapId)
    addmirrormap("zhixu", newMapId, "蛇巢禁地", time, oldMapId, 010380, x, y)
    mapmove(actor, newMapId, 44, 51, 0)
    delaygoto(actor, 1000, "she_chao_jin_di")
    genmon(newMapId, 34, 40, "噬渊之主·九头蛇", 0, 1, 249)
    genmon(newMapId, 34, 15, "噬渊之主·九头蛇", 0, 1, 249)
    genmon(newMapId, 41, 28, "噬渊之主·九头蛇", 0, 1, 249)
    genmon(newMapId, 50, 32, "噬渊之主·九头蛇", 0, 1, 249)
    genmon(newMapId, 44, 49, "噬渊之主·九头蛇", 0, 1, 249)
    genmon(newMapId, 24, 59, "噬渊之主·九头蛇", 0, 1, 249)
    genmon(newMapId, 18, 32, "噬渊之主·九头蛇", 0, 1, 249)
    genmon(newMapId, 27, 29, "噬渊之主·九头蛇", 0, 1, 249)
    genmon(newMapId, 44, 60, "噬渊之主·九头蛇", 0, 1, 249)
end

--同步消息
-- function SheChaoJinDi.SyncResponse(actor, logindatas)
--     local data = {}
--     local _login_data = {ssrNetMsgCfg.SheChaoJinDi_SyncResponse, 0, 0, 0, data}
--     if logindatas then
--         table.insert(logindatas, _login_data)
--     else
--         Message.sendmsg(actor, ssrNetMsgCfg.SheChaoJinDi_SyncResponse, 0, 0, 0, data)
--     end
-- end
-- --登录触发
-- local function _onLoginEnd(actor, logindatas)
--     SheChaoJinDi.SyncResponse(actor, logindatas)
-- end
-- --事件派发
-- GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, SheChaoJinDi)
--杀怪触发
local function _onKillMon(actor, monobj, monName)
    local myName = getbaseinfo(actor, ConstCfg.gbase.name)
    local newMapId = myName .. "蛇巢禁地"
    if FCheckMap(actor, newMapId) then
        local monName = monName
        if monName == "噬渊之主·九头蛇" then
            local x = getbaseinfo(monobj, ConstCfg.gbase.x)
            local y = getbaseinfo(monobj, ConstCfg.gbase.y)
            delaygoto(actor, 60000, string.format("jiu_tou_she_shua_guai,%s,%s", x, y))
            local monIdx = getdbmonfieldvalue("噬渊之主·九头蛇", "idx")
            local num = getmoncount(newMapId, monIdx, true)
            if num > 0 then
                Player.sendmsgEx(actor, "你击杀了|噬渊之主·九头蛇#249|一分钟后复活,1分钟内同时击杀才可以获得奖励!")
            else
                Player.sendmsgEx(actor, "九头蛇已全部消灭,获得奖励!")
                additemtodroplist(actor, monobj, "碧波三花曈")
                cleardelaygoto(actor)
                confertitle(actor, "不灭大蟒")
                -- setflagstatus(actor, VarCfg["F_蛇巢禁地_完成"], 1)
                FSetTaskRedPoint(actor, VarCfg["F_蛇巢禁地_完成"], 38)
            end
        end
    end
end
GameEvent.add(EventCfg.onKillMon, _onKillMon, SheChaoJinDi)

--注册网络消息
Message.RegisterNetMsg(ssrNetMsgCfg.SheChaoJinDi, SheChaoJinDi)
return SheChaoJinDi
