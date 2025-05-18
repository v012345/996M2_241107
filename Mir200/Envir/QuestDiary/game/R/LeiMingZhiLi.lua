local LeiMingZhiLi = {}
LeiMingZhiLi.ID = "雷鸣之力"
local npcID = 323
local abilGroup = 0
--local config = include("QuestDiary/cfgcsv/cfg_LeiMingZhiLi.lua") --配置
local config = {
    "天雷之环",
    "万雷",
    "神兵·雷神之威",
    "「掌控雷电」"
}
local flags = {
    VarCfg["F_剧情_雷鸣之力_1"],
    VarCfg["F_剧情_雷鸣之力_2"],
    VarCfg["F_剧情_雷鸣之力_4"],
    VarCfg["F_剧情_雷鸣之力_3"],
}
local attrIds = {
    { 4,   66 },
    { 1,   1222 },
    { 206, 4 },
    { 207, 4 },
}
--接收请求
function LeiMingZhiLi.Request(actor, arg1)
    local cfg = config[arg1]
    if not FCheckNPCRange(actor, npcID, 15) then
        Player.sendmsgEx(actor, "距离PNC太远!#249")
        return
    end
    local itemobj = linkbodyitem(actor, 43)
    if itemobj == "0" then
        Player.sendmsgEx(actor, "提交失败,你没有穿戴修仙法器!")
        return
    end
    local flag = getflagstatus(actor, flags[arg1])
    if flag == 1 then
        Player.sendmsgEx(actor, string.format("%s#249|已经提交过了!", cfg))
        return
    end
    local cost = { { cfg, 1 } }
    -- dump(cost)
    local name, num = Player.checkItemNumByTable(actor, cost)
    -- release_print(tostring(name))
    if name then
        Player.sendmsgEx(actor, string.format("提交失败,你背包内没有|%s#249", name))
        return
    end
    Player.takeItemByTable(actor, cost)
    setflagstatus(actor, flags[arg1], 1)
    local attr = attrIds[arg1]
    changecustomitemtext(actor, itemobj, "<IMG:res/tips/5.png>", abilGroup)
    local isPer = 0
    if arg1 == 3 or arg1 == 4 then
        isPer = 1
    end
    Player.addModifyCustomAttributes(actor, itemobj, abilGroup, arg1, 1, 250, attr[1], 0, isPer, attr[2])
    Player.sendmsgEx(actor, "提交成功")
    setflagstatus(actor, VarCfg["F_雷鸣之力_已提交一次"], 1)
    FSetTaskRedPoint(actor, VarCfg["F_雷鸣之力提交一次"], 20)
    LeiMingZhiLi.SyncResponse(actor)
end

--穿装备
local function _onTakeOn43(actor, itemobj)
    for index, value in ipairs(flags) do
        if getflagstatus(actor,value) == 1 then
            changecustomitemtext(actor, itemobj, "<IMG:res/tips/5.png>", abilGroup)
            local attr = attrIds[index]
            local isPer = 0
            if index == 3 or index == 4 then
                isPer = 1
            end
            Player.addModifyCustomAttributes(actor, itemobj, abilGroup, index, 1, 250, attr[1], 0, isPer, attr[2])
        end
    end
end
GameEvent.add(EventCfg.onTakeOn43, _onTakeOn43, LeiMingZhiLi)
--同步消息
function LeiMingZhiLi.SyncResponse(actor, logindatas)
    local data = {}
    for index, value in ipairs(flags) do
        table.insert(data, getflagstatus(actor, value))
    end
    local _login_data = {ssrNetMsgCfg.LeiMingZhiLi_SyncResponse, 0, 0, 0, data}
    if logindatas then
        table.insert(logindatas, _login_data)
    else
        Message.sendmsg(actor, ssrNetMsgCfg.LeiMingZhiLi_SyncResponse, 0, 0, 0, data)
    end
end
--登录触发
local function _onLoginEnd(actor, logindatas)
    LeiMingZhiLi.SyncResponse(actor, logindatas)
end
--事件派发
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, LeiMingZhiLi)
--注册网络消息
Message.RegisterNetMsg(ssrNetMsgCfg.LeiMingZhiLi, LeiMingZhiLi)
return LeiMingZhiLi
