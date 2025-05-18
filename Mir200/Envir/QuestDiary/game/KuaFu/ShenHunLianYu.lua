local ShenHunLianYu = {}
ShenHunLianYu.ID = "神魂炼狱"
local npcID = 138
local config = include("QuestDiary/cfgcsv/cfg_ShenHunLianYu.lua") --配置
local function _onShenHunLianYuKuaFuEnter(actor, mapID)
    local name = getbaseinfo(actor, ConstCfg.gbase.name)
    sendmsg("0", 2, '{"Msg":"[' .. name .. ']进入' .. mapID .. '","FColor":251,"BColor":0,"Type":6,"Time":6,"SendName":"系统：","SendId":"123","X":"-300"}')
    map(actor, mapID)
end
GameEvent.add(EventCfg.onShenHunLianYuKuaFuEnter, _onShenHunLianYuKuaFuEnter, ShenHunLianYu)
--接收请求
function ShenHunLianYu.Request(actor, index)
    if not checkkuafu(actor) then
        return
    end
    local cfg = config[index]
    if not cfg then
        Player.sendmsgEx(actor, "参数错误!")
        return
    end
    local isKangBao = getflagstatus(actor, VarCfg.F_is_open_kuangbao) --是否开启狂暴之力
    if isKangBao == 0 then
        Player.sendmsgEx(actor, "进入地图失败,你没有开启狂暴之力!#249")
        return
    end
    local myLeve = Player.GetLevel(actor)
    if myLeve < cfg.tiaoJian1 then
        Player.sendmsgEx(actor, string.format("进入地图失败,你的等级不足%d,无法进入!#249", cfg.tiaoJian1))
        return
    end
    local power = Player.GetPower(actor)
    if cfg.tiaoJian2 then
        if power < cfg.tiaoJian2 then
            Player.sendmsgEx(actor, string.format("进入地图失败,你的战力不足%d,无法进入!#249", cfg.tiaoJian2))
            return
        end
    end
    FBenFuToKuaFuEvent(actor, EventCfg.onShenHunLianYuKuaFuEnter, cfg.mapID)
end

local function _getMonData()
    local results = {}
    for _, value in ipairs(config) do
        local result = mapbossinfo(value.mapID, value.mobName, 0, 0)
        local str = result[1]
        local data = {}
        if str then
            local strs = string.split(str, "#")
            data = {
                [1] = tonumber(strs[3]), --剩余刷新时间
                [2] = strs[6]            --归属
            }
        end
        table.insert(results, data)
    end
    return results
end

local function _onShenHunLianYuKuaFu(actor)
    local data = _getMonData()
    Message.sendmsg(actor, ssrNetMsgCfg.ShenHunLianYu_OpenUI, 0, 0, 0, data)
end

GameEvent.add(EventCfg.onShenHunLianYuKuaFu, _onShenHunLianYuKuaFu, ShenHunLianYu)

function ShenHunLianYu.OpenUI(actor)
    FBenFuToKuaFuEvent(actor, EventCfg.onShenHunLianYuKuaFu, "")
end

--同步消息
-- function ShenHunLianYu.SyncResponse(actor, logindatas)
--     local data = {}
--     local _login_data = {ssrNetMsgCfg.ShenHunLianYu_SyncResponse, 0, 0, 0, data}
--     if logindatas then
--         table.insert(logindatas, _login_data)
--     else
--         Message.sendmsg(actor, ssrNetMsgCfg.ShenHunLianYu_SyncResponse, 0, 0, 0, data)
--     end
-- end
-- --登录触发
-- local function _onLoginEnd(actor, logindatas)
--     ShenHunLianYu.SyncResponse(actor, logindatas)
-- end
-- --事件派发
-- GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, ShenHunLianYu)
--注册网络消息
Message.RegisterNetMsg(ssrNetMsgCfg.ShenHunLianYu, ShenHunLianYu)
return ShenHunLianYu
