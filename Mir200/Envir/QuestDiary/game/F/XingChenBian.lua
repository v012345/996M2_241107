local XingChenBian = {}
local cost = {{"星辉碎片", 1},{"混沌本源", 2}}
local TypeData = {"贪狼","巨门","禄存","武曲","破军","文曲","廉贞"}

--检查T变量并返回一个Tbl
function CheckLevelIsTbl(actor)
    local IsTbl = Player.getJsonTableByVar(actor, VarCfg["T_星辰变进度记录"])
    local NewTbl = {}
    for _, v in ipairs(TypeData) do
        local Num = (IsTbl[v] == "" and 0) or IsTbl[v]  or 0
        NewTbl[v] = Num
    end
    return NewTbl
end

--领取奖励
function XingChenBian.Request1(actor)
    local state = true
    local data = CheckLevelIsTbl(actor)
    for k, v in pairs(data) do
        if v < 50 then
            state = false
            break
        end
    end
    if not state then
        Player.sendmsgEx(actor, "提示#251|:#255|对不起,你的星辰还|未满级#249|领取失败...")
        return
    end
    local lingqu = getflagstatus(actor,VarCfg["F_星辰变领取状态"])
    if lingqu == 1 then
        Player.sendmsgEx(actor, "提示#251|:#255|你已领取过星辰变|满级奖励#249|请勿重复领取...")
        return
    end
    local UserId = getconst(actor, "<$USERID>")
    sendmail(UserId, 5001, "星辰变", "恭喜你获得星辰变奖励","七星生灵草#1&〈〈太阴星君〉〉[时装]#1")
    Player.sendmsgEx(actor, "提示#251|:#255|恭喜你,领取|星辰变#249|满级奖励,已通过|邮件#249|发放...")
    setflagstatus(actor,VarCfg["F_星辰变领取状态"],1)
end

-- 七星拱月阵	100	117

--注入星魂之力
function XingChenBian.Request2(actor)
    local data = CheckLevelIsTbl(actor)
    local NewTbl = {}
    --筛选是否都已经满级
    for _, v in ipairs(TypeData) do
        if data[v] ~= 50 then
            table.insert(NewTbl, v)
        end
    end
    if #NewTbl == 0 then
        Player.sendmsgEx(actor, "提示#251|:#255|星辰变|已满级#249|无法继续提升了...")
        return
    end

    local name, num = Player.checkItemNumByTable(actor, cost)
    if name then
        Player.sendmsgEx(actor, string.format("提示#251|:#255|你的|%s#249|不足|%d#249|枚,注入失败...", name, num))
        return
    end
    Player.takeItemByTable(actor, cost, "星辰变扣除")
    local TypeName = NewTbl[math.random(1, #NewTbl)]                    --随机取值
    data[TypeName] = data[TypeName] + 1                                 --增加1级
    Player.sendmsgEx(actor, "提示#251|:#255|星辰|".. TypeName .."星#249|进度|+1#249|...")
    Player.setJsonVarByTable(actor, VarCfg["T_星辰变进度记录"], data)    --保存进度
    XingChenBian.SyncResponse(actor)
    Player.setAttList(actor, "属性附加")
end


--属性刷新
local function _onCalcAttr(actor, attrs)
    local data = CheckLevelIsTbl(actor)

    local IsDouble = true
    local multiple = 1
    for _, v in ipairs(TypeData) do
        if data[v] < 50 then
            IsDouble = false
        end
    end
    if IsDouble then
        multiple = 2
    end

    local attrtbl = {}
    if data["贪狼"] > 0 then
        attrtbl[4] =  10 * data["贪狼"] * multiple          --攻击
    end
    if data["巨门"] > 0 then
        attrtbl[6] =  10 * data["巨门"] * multiple          --攻击
    end
    if data["禄存"] > 0 then
        attrtbl[8] =  10 * data["禄存"] * multiple          --攻击
    end
    if data["武曲"] > 0 then
        attrtbl[10] =  10 * data["武曲"] * multiple         --攻击
    end
    if data["破军"] > 0 then
        attrtbl[12] =  10 * data["破军"] * multiple         --攻击
    end
    if data["文曲"] > 0 then
        attrtbl[1] =  200 * data["文曲"] * multiple          --攻击
    end
    if data["廉贞"] > 0 then
        attrtbl[2] =  200 * data["廉贞"] * multiple          --攻击
    end
    calcAtts(attrs, attrtbl, "星辰变")
end
GameEvent.add(EventCfg.onCalcAttr, _onCalcAttr, XingChenBian)

--注册网络消息
function XingChenBian.SyncResponse(actor, logindatas)
    local data = CheckLevelIsTbl(actor)
    local lingqu = getflagstatus(actor,VarCfg["F_星辰变领取状态"])
    local _login_data = { ssrNetMsgCfg.XingChenBian_SyncResponse, lingqu, 0, 0, data }
    if logindatas then
        table.insert(logindatas, _login_data)
    else
        Message.sendmsg(actor, ssrNetMsgCfg.XingChenBian_SyncResponse, lingqu, 0, 0, data)
    end
end
Message.RegisterNetMsg(ssrNetMsgCfg.XingChenBian, XingChenBian)


--登录触发
local function _onLoginEnd(actor, logindatas)
    XingChenBian.SyncResponse(actor, logindatas)
end
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, XingChenBian)

return XingChenBian
