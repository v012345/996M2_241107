local DanChen = {}
DanChen.ID = "丹尘"
local npcID = 504
local config = include("QuestDiary/cfgcsv/cfg_DanChen.lua") --配置
local itemNames = {
    ["风灵叶"] = 1,
    ["天香迷花"] = 1,
    ["地狱灵芝"] = 1,
}
--任务用buff
local taskBuffId = 31036
--接收请求
function DanChen.OpenUI(actor)
    local flag1 = getflagstatus(actor, VarCfg["F_剧情_丹尘_采集任务接取"])
    local flag2 = getflagstatus(actor, VarCfg["F_剧情_丹尘_采集任务完成"])
    local flag3 = getflagstatus(actor, VarCfg["F_剧情_丹尘_可以炼丹"])
    local state = 1
    if flag1 == 1 and hasbuff(actor, taskBuffId) then
        state = 2 --领取了任务 和 任务中
    end
    if flag1 == 1 and not hasbuff(actor, taskBuffId) then
        state = 3 --任务失败
    end
    if flag2 == 1 then
        state = 4
    end
    if flag3 == 1 then
        state = 5
    end
    Message.sendmsg(actor, ssrNetMsgCfg.DanChen_OpenUI, state)
end

function DanChen.Request(actor, index)
    local cfg = config[index]
    if not cfg then
        Player.sendmsgEx(actor, "参数错误!#249")
        return
    end
    local cost = cfg.cost
    local name, num = Player.checkItemNumByTable(actor, cost)
    if name then
        Player.sendmsgEx(actor, string.format("你的|%s#249|不足|%d#249", name, num))
        return
    end
    Player.takeItemByTable(actor, cost, "丹尘炼丹")

    local quanzhong = table.concat(cfg.quanzhong, "|")
    local result1 = ransjstr(quanzhong, 1, 3)
    local give = { { result1, 1 } }
    Player.giveItemByTable(actor, give, "炼丹", 1, true)
    Message.sendmsg(actor, ssrNetMsgCfg.DanChen_Success, 0, 0, 0, give)
    local num = getplaydef(actor, VarCfg["U_丹尘炼丹次数"])
    if num < 10 then
        setplaydef(actor, VarCfg["U_丹尘炼丹次数"], num + 1)
    end
    DanChen.SyncResponse(actor)
end

function dan_chen_cai_ji_jie_shu(actor)
    newdeletetask(actor, 201)
    messagebox(actor,"抱歉,您的采集任务失败了,可以到极恶大陆(75,111)找到丹尘,再次领取采集任务")
end

local function receiveTask(actor)
    if hasbuff(actor, taskBuffId) then
        Player.sendmsgEx(actor, "你已经领取过了,抓紧时间去完成吧")
        return
    end
    addbuff(actor, taskBuffId)
    local buffTime = getbuffinfo(actor, taskBuffId, 2)
    -- local buffNum = getbuffinfo(actor, taskBuffId, 1) - 1
    newchangetask(actor, 201, 0)
    sendcentermsg(actor, 250, 0, "请在: {%d秒/FCOLOR=249}内完成采集任务...", 0, buffTime, "@dan_chen_cai_ji_jie_shu")
    setflagstatus(actor, VarCfg["F_剧情_丹尘_采集任务接取"], 1)
end
--领取
function DanChen.ColleTask(actor)
    receiveTask(actor)
end

--重试
function DanChen.Retry(actor)
    receiveTask(actor)
end

--放弃
function DanChen.GiveUp(actor)
    setflagstatus(actor, VarCfg["F_剧情_丹尘_采集任务接取"], 0)
    Player.sendmsgEx(actor, "你放弃了任务!")
end

function DanChen.FinishTask(actor)
    if getflagstatus(actor, VarCfg["F_剧情_丹尘_采集任务完成"]) == 1 then
        setflagstatus(actor, VarCfg["F_剧情_丹尘_可以炼丹"], 1)
        newdeletetask(actor, 201)
        DanChen.OpenUI(actor)
    else
        -- Player.sendmsgEx(actor, "??")
    end
end

--同步消息
function DanChen.SyncResponse(actor, logindatas)
    local data = {}
    local _login_data = { ssrNetMsgCfg.DanChen_SyncResponse, 0, 0, 0, data }
    if logindatas then
        table.insert(logindatas, _login_data)
    else
        Message.sendmsg(actor, ssrNetMsgCfg.DanChen_SyncResponse, 0, 0, 0, data)
    end
end

--登录触发
local function _onLoginEnd(actor, logindatas)
    if hasbuff(actor, taskBuffId) then
        local buffTime = getbuffinfo(actor, taskBuffId, 2)
        local buffNum = getbuffinfo(actor, taskBuffId, 1) - 1
        newchangetask(actor, 201, buffNum)
        sendcentermsg(actor, 250, 0, "请在: {%d秒/FCOLOR=249}内完成采集任务...", 0, buffTime)
    end
    if getflagstatus(actor, VarCfg["F_剧情_丹尘_采集任务完成"]) == 1 and getflagstatus(actor, VarCfg["F_剧情_丹尘_可以炼丹"]) ~= 1 then
        newcompletetask(actor, 201)
    end
    DanChen.SyncResponse(actor, logindatas)
end
--事件派发
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, DanChen)

--采集触发
local function _onCollectTask(actor, monName, monMakeIndex, itemName)
    if itemNames[itemName] then
        if hasbuff(actor, taskBuffId) then
            addbuff(actor, taskBuffId)
            local buffNum = getbuffinfo(actor, taskBuffId, 1) - 1
            newchangetask(actor, 201, buffNum)
            if buffNum >= 30 then
                setflagstatus(actor, VarCfg["F_剧情_丹尘_采集任务完成"], 1)
                FkfDelBuff(actor, taskBuffId)
                newcompletetask(actor, 201)
                confertitle(actor, "丹道学徒")
                cleardelaygoto(actor, 1)
                messagebox(actor, "恭喜你完成任务,获得称号[丹道学徒]")
            end
        end
    end
end

GameEvent.add(EventCfg.onCollectTask, _onCollectTask, DanChen)

--注册网络消息
Message.RegisterNetMsg(ssrNetMsgCfg.DanChen, DanChen)
return DanChen
