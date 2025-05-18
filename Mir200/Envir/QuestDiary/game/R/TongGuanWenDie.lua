local TongGuanWenDie = {}
TongGuanWenDie.ID = "通关文牒"
local config = include("QuestDiary/cfgcsv/cfg_TongGuanWenDie.lua") --配置
local MainConditions = include("QuestDiary/game/R/GetJQMainConditions.lua")   --配置
local cost = {{}}
local give = {{}}
local function allTrue(array)
    for i = 1, #array do
        local element = array[i]
        if type(element) == "table" then
            if #element == 2 then
                if element[1] < element[2] then
                    return false
                end
            else
                return false
            end
        elseif type(element) == "boolean" then
            if not element then
                return false
            end
        else
            return false
        end
    end
    return true
end
--接收请求
function TongGuanWenDie.Request(actor,index,npcID)
    -- release_print(npcID)
    local taskList = Player.getJsonTableByVar(actor,VarCfg["T_通关文牒领取记录"])
    local cfg = config[npcID]
    if not cfg then
        Player.sendmsgEx(actor, "参数错误1#249")
        return
    end
    if taskList[tostring(index)] then
        Player.sendmsgEx(actor, "已领取#249")
        return
    end
    local func = MainConditions[index]
    if not func then
        Player.sendmsgEx(actor, "参数错误#249")
        return
    end
    local data = MainConditions[index](actor)
    if not data then
        Player.sendmsgEx(actor, "参数错误#249")
        return
    end
    local bool = allTrue(data)
    if not bool then
        Player.sendmsgEx(actor, "你没有完成全部剧情任务,无法领取#249")
        return
    end
    taskList[tostring(index)] = 1
    Player.setJsonVarByTable(actor,VarCfg["T_通关文牒领取记录"],taskList)
    local userId = getbaseinfo(actor,ConstCfg.gbase.id)
    confertitle(actor, cfg.title, 1)
    Player.setAttList(actor,"属性附加")
    Player.giveMailByTable(userId,1, "通关文牒奖励-"..cfg.title,"请领取您的通关文牒奖励,称号["..cfg.title.."]已自动穿戴!",cfg.reward, 1, true)
    Player.sendmsgEx(actor, string.format("[系统提示]： 领取成功：奖励已发送到邮件!"))
    TongGuanWenDie.SyncResponse(actor)
end
--同步消息
function TongGuanWenDie.SyncResponse(actor, logindatas)
    local data = Player.getJsonTableByVar(actor,VarCfg["T_通关文牒领取记录"])
    local _login_data = {ssrNetMsgCfg.TongGuanWenDie_SyncResponse, 0, 0, 0, data}
    if logindatas then
        table.insert(logindatas, _login_data)
    else
        Message.sendmsg(actor, ssrNetMsgCfg.TongGuanWenDie_SyncResponse, 0, 0, 0, data)
    end
end
--登录触发
local function _onLoginEnd(actor, logindatas)
    TongGuanWenDie.SyncResponse(actor, logindatas)
end
--事件派发
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, TongGuanWenDie)
--注册网络消息
function TongGuanWenDie.Sync1(actor, parentIndex, arg1, arg2, data)
    if not parentIndex or type(parentIndex) ~= "number" then
        Player.sendmsgEx(actor, "参数错误#249")
        return
    end
    local func = MainConditions[parentIndex]
    if not func then
        Player.sendmsgEx(actor, "参数错误#249")
        return
    end
    local data = func(actor)
    if not data then
        Player.sendmsgEx(actor, "参数错误#249")
        return
    end
    Message.sendmsg(actor, ssrNetMsgCfg.TongGuanWenDie_Sync1, parentIndex, 0, 0, data)
end
Message.RegisterNetMsg(ssrNetMsgCfg.TongGuanWenDie, TongGuanWenDie)
return TongGuanWenDie