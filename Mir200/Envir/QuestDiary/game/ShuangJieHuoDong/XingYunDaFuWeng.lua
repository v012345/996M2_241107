local XingYunDaFuWeng = {}
XingYunDaFuWeng.ID = "幸运大富翁"
local npcID = 158
--local config = include("QuestDiary/cfgcsv/cfg_XingYunDaFuWeng.lua") --配置

local GiveData = { [5]  = {"异界神石", 5},[10] = {"圣诞花环", 5},[15] = {"圣诞幸运星", 3},[20] = {"圣诞花环", 10},[25] = {"圣诞幸运星", 3},[30] = {"圣诞花环", 15},[35] = {"圣诞幸运星", 3},
                   [40] = {"圣诞花环", 20},[45] = {"圣诞幸运星", 3},[50] = {"大富翁礼包", 1}}

local NumData = {50000, 100000, 200000, 300000, 400000, 500000}
--获取数据
function XingYunDaFuWeng.getVariableState(actor)
    local num1 = getplaydef(actor, VarCfg["J_大富翁次数"])
    local num2 = getplaydef(actor, VarCfg["J_大富翁位置"])

    if num2 == 0 then
        setplaydef(actor, VarCfg["J_大富翁位置"], 1)
        num2 = getplaydef(actor, VarCfg["J_大富翁位置"])
    end
    return num1, num2
end

function fa_fang_jiang_li(actor,var)
    local var = tonumber(var)
    if GiveData[var] then
       giveitem(actor, GiveData[var][1], GiveData[var][2], ConstCfg.binding, "大富翁给与")
       Player.sendmsgEx(actor, "提示#251|:#255|恭喜你,获得|".. GiveData[var][1] .."#249|数量|x".. GiveData[var][2] .."#249|...")
    end
end

function checkitemex(actor)
    local time1 = getplaydef(actor, "N$大富翁时间戳")
    local time2 = os.time()
    if time1 == 0 then
        return true
    end

    if time2 - time1 >= 3 then
        return true
    else
        return false
    end
end



function XingYunDaFuWeng.Request(actor, var)
    
    if not checkitemex(actor) then
        Player.sendmsgEx(actor,"[提示]:#251|人物移动中,请等待结束...")
        return
    end


    local num1, num2 = XingYunDaFuWeng.getVariableState(actor)
    if num2 >= 50 then
        Player.sendmsgEx(actor,"[提示]:#251|你今天已经|到达终点#249|请明天再来...")
        return
    end
    --普通骰子
    if var == 1 then
        if num1 >= 5 then
            local _num = num1 - 5 + 1
            local num = (_num >= 6 and 6) or _num
            local CostNum = NumData[num]
            local cost = {{"元宝", CostNum}}

            local ItemName, ItemNum = Player.checkItemNumByTable(actor, cost)
            if ItemName then
                Player.sendmsgEx(actor, string.format("[提示]:#251|对不起,你的|%s#249|不足|%d枚#249|投掷失败...", ItemName, ItemNum))
                return
            end
            Player.takeItemByTable(actor, cost, "大富翁骰子")

            setplaydef(actor, VarCfg["J_大富翁次数"], num1 + 1)
            local Steps = math.random(1, 6) --步数
            -- local Steps = 4 --步数
            local site = (num2 + Steps >= 50 and 50) or num2 + Steps
            setplaydef(actor, VarCfg["J_大富翁位置"], site)
            Message.sendmsg(actor, ssrNetMsgCfg.XingYunDaFuWeng_PlayAnimation, num2, site, Steps, nil)
            XingYunDaFuWeng.SyncResponse(actor)
            delaygoto(actor, 3000, "fa_fang_jiang_li,"..site)
            setplaydef(actor, "N$大富翁时间戳", os.time())
        else
            num1 = num1 + 1
            setplaydef(actor, VarCfg["J_大富翁次数"], num1)
            local Steps = math.random(1, 6) --步数
            -- local Steps = 4 --步数
            local site = (num2 + Steps >= 50 and 50) or num2 + Steps
            setplaydef(actor, VarCfg["J_大富翁位置"], site)
            Message.sendmsg(actor, ssrNetMsgCfg.XingYunDaFuWeng_PlayAnimation, num2, site, Steps, nil)
            XingYunDaFuWeng.SyncResponse(actor)
            delaygoto(actor, 3000, "fa_fang_jiang_li,"..site)
            setplaydef(actor, "N$大富翁时间戳", os.time())
        end
    end

    --金骰子
    if var == 2 then
        if querymoney(actor, 7) < 200 then
            Player.sendmsgEx(actor,"[提示]:#251|对不起,你的|非绑灵符#249|不足|200枚#249|投掷失败...")
            return
        end
        changemoney(actor, 7, "-", 200, "购买大富翁骰子", true)
        local Steps = 6 --步数
        local site = (num2 + Steps >= 50 and 50) or num2 + Steps
        setplaydef(actor, VarCfg["J_大富翁位置"], site)
        Message.sendmsg(actor, ssrNetMsgCfg.XingYunDaFuWeng_PlayAnimation, num2, site, Steps, nil)
        XingYunDaFuWeng.SyncResponse(actor)
        delaygoto(actor, 3000, "fa_fang_jiang_li,"..site)
        setplaydef(actor, "N$大富翁时间戳", os.time())
    end
end


--同步消息
function XingYunDaFuWeng.SyncResponse(actor, logindatas)
    local num1, num2 = XingYunDaFuWeng.getVariableState(actor)
    local _login_data = {ssrNetMsgCfg.XingYunDaFuWeng_SyncResponse, 0, 0, 0, {num1, num2}}
    if logindatas then
        table.insert(logindatas, _login_data)
    else
        Message.sendmsg(actor, ssrNetMsgCfg.XingYunDaFuWeng_SyncResponse, 0, 0, 0, {num1, num2})
    end
end

--登录触发
local function _onLoginEnd(actor, logindatas)
    XingYunDaFuWeng.SyncResponse(actor, logindatas)
end
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, XingYunDaFuWeng)

--0:0:10 新的一天触发
local function _onNewDay(actor)
    XingYunDaFuWeng.SyncResponse(actor)
end
GameEvent.add(EventCfg.onNewDay, _onNewDay, XingYunDaFuWeng)


--注册网络消息
Message.RegisterNetMsg(ssrNetMsgCfg.XingYunDaFuWeng, XingYunDaFuWeng)
return XingYunDaFuWeng