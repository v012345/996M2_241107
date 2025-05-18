local WuXuKongJian = {}
WuXuKongJian.ID = "无序空间"
local npcID = 829
local config = include("QuestDiary/cfgcsv/cfg_WuXuKongJian.lua") --配置
--接收请求
function WuXuKongJian.Request(actor)
    local data = Player.getJsonTableByVar(actor, VarCfg["T_无秩空间"])
    local condition1 = data["bai"] or 0
    local condition2 = data["hui"] or 0
    if condition1 < 300 then
        Player.sendmsgEx(actor, "进入地图失败,你的新月白名BOSS击杀不足300!#249")
        return
    end
    if condition2 < 50 then
        Player.sendmsgEx(actor, "进入地图失败,你的新月灰名领主击杀不足50!#249")
        return
    end
    map(actor, "无序空间")
end

function WuXuKongJian.OpenUI(actor)
    local data = Player.getJsonTableByVar(actor, VarCfg["T_无秩空间"])
    Message.sendmsg(actor, ssrNetMsgCfg.WuXuKongJian_OpenUI, 0, 0, 0, data)
end

--同步消息
-- function WuXuKongJian.SyncResponse(actor, logindatas)
--     local data = {}
--     local _login_data = {ssrNetMsgCfg.WuXuKongJian_SyncResponse, 0, 0, 0, data}
--     if logindatas then
--         table.insert(logindatas, _login_data)
--     else
--         Message.sendmsg(actor, ssrNetMsgCfg.WuXuKongJian_SyncResponse, 0, 0, 0, data)
--     end
-- end
-- --登录触发
-- local function _onLoginEnd(actor, logindatas)
--     WuXuKongJian.SyncResponse(actor, logindatas)
-- end
-- --事件派发
-- GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, WuXuKongJian)
--杀怪触发
local function _onKillMon(actor, monobj, monName)
    local cfg = config[monName]
    if cfg then
        local data = Player.getJsonTableByVar(actor, VarCfg["T_无秩空间"])
        -- 白名怪
        if cfg.value == 1 then
            if (data["bai"] or 0) >= 300 then
                return
            end
            if not data["bai"] then
                data["bai"] = 1
            else
                data["bai"] = data["bai"] + 1
            end
        else -- 灰名怪
            if (data["hui"] or 0) >= 50 then
                return
            end
            if not data["hui"] then
                data["hui"] = 1
            else
                data["hui"] = data["hui"] + 1
            end
        end
        Player.setJsonVarByTable(actor, VarCfg["T_无秩空间"], data)
    end
end
GameEvent.add(EventCfg.onKillMon, _onKillMon, WuXuKongJian)
--注册网络消息
Message.RegisterNetMsg(ssrNetMsgCfg.WuXuKongJian, WuXuKongJian)
return WuXuKongJian
