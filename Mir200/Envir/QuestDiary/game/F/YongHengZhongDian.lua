local YongHengZhongDian = {}
local cost =  {
    {{"虚空之晶", 1},{"元宝", 300000}},
    {{"时光碎片", 1},{"元宝", 300000}},
    {{"永恒精魄", 1},{"元宝", 300000}},
}


function YongHengZhongDian.Request(actor,var)
    -- if not checktitle(actor,"追逐永恒之路") then
    --     Player.sendmsgEx(actor, "提示#251|:#255|对不起,你还未激活|追逐永恒之路#249|无法使用该功能...")
    --     return
    -- end
    local _Type = {"虚空", "时光", "永恒", "称号"}
    local CheckType = {}
    local NumTbl = {}
    local T_Table = Player.getJsonTableByVar(actor, VarCfg["T_永恒终点状态"])
    local T_Num = Player.getJsonTableByVar(actor, VarCfg["T_永恒终点次数"])

    for _, k in ipairs(_Type) do
        local state = (T_Table[k] == "" and 0) or T_Table[k] or 0
        table.insert(CheckType, state)
        local Num = (T_Num[k] == nil and 0) or tonumber(T_Num[k]) or 0
        NumTbl[k] = Num
    end

    if var ~= 4 then
        if CheckType[var] == 1 then
           Player.sendmsgEx(actor, "提示#251|:#255|对不起,你已|".. cost[var][1][1] .."#249|了,请勿重复提交...")
           return
        end
        local name, num = Player.checkItemNumByTable(actor, cost[var])
        if name then
            Player.sendmsgEx(actor, string.format("提示#251|:#255|你的|%s#249|不足|%d#249|枚,激活失败...", name, num))
            return
        end
        Player.takeItemByTable(actor, cost[var], "扣除材料")

        NumTbl[_Type[var]] = NumTbl[_Type[var]] + 1
        Player.setJsonVarByTable(actor, VarCfg["T_永恒终点次数"], NumTbl)
        if NumTbl[_Type[var]] >= 5 then
            Player.sendmsgEx(actor, "提示#251|:#255|恭喜你,成功激活|".. cost[var][1][1] .."#249|,战力获得大幅提升...")
            local data = { }
            for K, v in ipairs(_Type) do
                if K == var then
                    data[v] = 1
                else
                    data[v] =  CheckType[K]
                end
            end
            Player.setJsonVarByTable(actor, VarCfg["T_永恒终点状态"], data)
            Player.setAttList(actor, "属性附加")
        else
            if randomex(15, 100) then
                Player.sendmsgEx(actor, "提示#251|:#255|恭喜你,成功激活|".. cost[var][1][1] .."#249|,战力获得大幅提升...")
                local data = { }
                for K, v in ipairs(_Type) do
                    if K == var then
                        data[v] = 1
                    else
                        data[v] =  CheckType[K]
                    end
                end
                Player.setJsonVarByTable(actor, VarCfg["T_永恒终点状态"], data)
                Player.setAttList(actor, "属性附加")
            else
                Player.sendmsgEx(actor, "提示#251|:#255|对不起,激活|".. cost[var][1][1] .."#249|失败,材料扣除...")
            end
        end
        YongHengZhongDian.SyncResponse(actor)
    end

    if var == 4 then
        if CheckType[var] == 1 then
            Player.sendmsgEx(actor, "提示#251|:#255|对不起,你已经有|永恒没有终点#249|称号了,请勿重复领取...")
            return
        end

        if CheckType[1] == 0 then
            Player.sendmsgEx(actor, "提示#251|:#255|对不起,你还未提交|虚空之晶#249|无法领取...")
            return
        elseif CheckType[2] == 0 then
            Player.sendmsgEx(actor, "提示#251|:#255|对不起,你还未提交|时光碎片#249|无法领取...")
            return
        elseif CheckType[3] == 0 then
            Player.sendmsgEx(actor, "提示#251|:#255|对不起,你还未提交|永恒精魄#249|无法领取...")
            return
        else
            deprivetitle(actor,"追逐永恒之路")
            confertitle(actor,"永恒没有终点")
            local data = { }
            for K, v in ipairs(_Type) do
                if K == var then
                    data[v] = 1
                else
                    data[v] =  CheckType[K]
                end
            end
            local liveMax = getplaydef(actor,VarCfg["U_等级上限"])
            setplaydef(actor,VarCfg["U_等级上限"],liveMax + 1)
            setlocklevel(actor, 1, getplaydef(actor, VarCfg["U_等级上限"]))
            changelevel(actor, "+", 1)
            Player.setJsonVarByTable(actor, VarCfg["T_永恒终点状态"], data)
            Player.sendmsgEx(actor, "提示#251|:#255|恭喜你,成功激活|追逐永恒之路#249|,战力获得大幅提升...")
        end
    end
end

local function _onCalcAttr(actor, attrs)
    local T_Table = Player.getJsonTableByVar(actor, VarCfg["T_永恒终点状态"])
    local state1 = (T_Table["虚空"] == "" and 0) or T_Table["虚空"] or 0
    local state2 = (T_Table["时光"] == "" and 0) or T_Table["时光"] or 0
    local state3 = (T_Table["永恒"] == "" and 0) or T_Table["永恒"] or 0
    local state4 = (T_Table["称号"] == "" and 0) or T_Table["称号"] or 0
    local shuxing = {}
    local atts = {}
    if state1 == 1 then
        atts[4] = 144
    end
    if state2 == 1 then
        atts[1] = 5000
    end
    if state3 == 1 then
        atts[200] = 4444
    end
    attsMerge(atts, shuxing)
    calcAtts(attrs, shuxing, "永恒终点")
end
GameEvent.add(EventCfg.onCalcAttr, _onCalcAttr, YongHengZhongDian)




--注册网络消息
function YongHengZhongDian.SyncResponse(actor, logindatas)
    local T_Table = Player.getJsonTableByVar(actor, VarCfg["T_永恒终点状态"])
    local state1 = (T_Table["虚空"] == "" and 0) or T_Table["虚空"] or 0
    local state2 = (T_Table["时光"] == "" and 0) or T_Table["时光"] or 0
    local state3 = (T_Table["永恒"] == "" and 0) or T_Table["永恒"] or 0
    local state4 = (T_Table["称号"] == "" and 0) or T_Table["称号"] or 0
    local data = {state1, state2, state3, state4}
    local _login_data = { ssrNetMsgCfg.YongHengZhongDian_SyncResponse, 0, 0, 0, data }
    if logindatas then
        table.insert(logindatas, _login_data)
    else
        Message.sendmsg(actor, ssrNetMsgCfg.YongHengZhongDian_SyncResponse, 0, 0, 0, data)
    end
end
Message.RegisterNetMsg(ssrNetMsgCfg.YongHengZhongDian, YongHengZhongDian)

--登录触发
local function _onLoginEnd(actor, logindatas)
    YongHengZhongDian.SyncResponse(actor, logindatas)
end
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, YongHengZhongDian)

Message.RegisterNetMsg(ssrNetMsgCfg.YongHengZhongDian, YongHengZhongDian)

return YongHengZhongDian
