local QianMenBaJiang = {}
QianMenBaJiang.ID = "千门八将"
local config = include("QuestDiary/cfgcsv/cfg_QianMenBaJiang.lua") --配置

-- 月辉神居	44	42

-- 正将印信
-- 提将印信
-- 反将印信
-- 脱将印信
-- 风将印信
-- 火将印信
-- 除将印信
-- 谣将印信

--接收请求
function QianMenBaJiang.Request(actor,var)
    --领取称号
    if var == 9 then
        if checktitle(actor, "千王之王") then return end
        local data = Player.getJsonTableByVar(actor, VarCfg["T_千门八将"])
        local state = true
        if table.nums(data) == 8 then
            for _, v in ipairs(data) do
                if not v.State then
                    state = false
                    break
                end
            end
        else
            state = false
        end

        if state then
            confertitle(actor, "千王之王", 1)
            local LevelMax = getplaydef(actor, VarCfg["U_等级上限"])
            LevelMax = LevelMax + 1
            setplaydef(actor, VarCfg["U_等级上限"], LevelMax)
            giveitem(actor, "八将复苏珠", 1, ConstCfg.binding, "千门八将领取")
            Player.sendmsgEx(actor, "提示#251|:#255|恭喜你领取成功,称号已自动穿戴!")
            QianMenBaJiang.SyncResponse(actor)
        else
            Player.sendmsgEx(actor, "提示#251|:#255|你没有全部激活,领取失败!#249")
        end
    end
    if not config[var] then return end
    local Data = Player.getJsonTableByVar(actor, VarCfg["T_千门八将"])
    local Type = config[var].name
    --获取升级次数以及状态
    local State = ""   --当前状态
    local Number = 0  --当前次数
    if Data[Type] then
        State = Data[Type].State or ""
        Number = Data[Type].Number
    end
    if State == "已激活" then return end
    local name, num = Player.checkItemNumByTable(actor, config[var].cost)
    if name then
        Player.sendmsgEx(actor, string.format("你的|%s#249|数量不足|%d#249|,激活失败...", name, num))
        return
    end
    Player.takeItemByTable(actor, config[var].cost, "千门八将"..Type.."扣除")

    if Number >= 10 then
        Data[Type] = {State = "已激活", Number = Number + 1}
        Player.sendmsgEx(actor, "提示#251|:#255|".. Type .."门#249|激活成功...")
        Player.setJsonVarByTable(actor, VarCfg["T_千门八将"], Data)
        Player.setAttList(actor, "属性附加")
        Player.setAttList(actor, "爆率附加")
    else
        if randomex(config[var].value, 100) then
            Data[Type] = {State = "已激活", Number = Number + 1}
            Player.sendmsgEx(actor, "提示#251|:#255|".. Type .."门#249|激活成功...")
            Player.setJsonVarByTable(actor, VarCfg["T_千门八将"], Data)
            Player.setAttList(actor, "属性附加")
            Player.setAttList(actor, "爆率附加")
        else
            Data[Type] = {Number = Number + 1}
            Player.sendmsgEx(actor, "提示#251|:#255|对不起,|".. Type .."门#249|激活失败...")
            Player.setJsonVarByTable(actor, VarCfg["T_千门八将"], Data)
        end
    end
    QianMenBaJiang.SyncResponse(actor)
end

--属性刷新
local function _onCalcAttr(actor, attrs)
    local data = Player.getJsonTableByVar(actor, VarCfg["T_千门八将"])
    local shuxingMap = {}

    if data["正"] then
        if data["正"].State == "已激活" then
            shuxingMap[210] = 5 --攻击增加5%
        end
    end

    if data["提"] then
        if data["提"].State == "已激活" then
            shuxingMap[208] = 5 --生命增加5%
        end
    end

    if data["反"] then
        if data["反"].State == "已激活" then
            shuxingMap[213] = 5 --防御增加5%
        end
    end

    if data["脱"] then
        if data["脱"].State == "已激活" then
            shuxingMap[25] = 5 --攻击伤害增加5%
        end
    end

    if data["风"] then
        if data["风"].State == "已激活" then
            shuxingMap[4] = 188 --攻击上限增加188点
        end
    end

    if data["火"] then
        if data["火"].State == "已激活" then
            shuxingMap[1] = 2222 --生命上限增加2222点
        end
    end

    if data["除"] then
        if data["除"].State == "已激活" then
            shuxingMap[26] = 5  --物理伤害减免增加5%
        end
    end
    calcAtts(attrs, shuxingMap, "千门八将")
end
GameEvent.add(EventCfg.onCalcAttr, _onCalcAttr, QianMenBaJiang)

--爆率刷新
local function _onCalcBaoLv(actor, attrs)
    local data = Player.getJsonTableByVar(actor, VarCfg["T_千门八将"])
    if data["谣"] then
        if data["谣"].State == "已激活" then
            local shuxing = {
                [204] = 30
            }
            calcAtts(attrs, shuxing, "千门八将")
        end
    end
end
GameEvent.add(EventCfg.onCalcBaoLv, _onCalcBaoLv, QianMenBaJiang)

-- 同步消息
function QianMenBaJiang.SyncResponse(actor, logindatas)
    local data= Player.getJsonTableByVar(actor, VarCfg["T_千门八将"])
    local state = (checktitle(actor, "千王之王") and 1) or 0
    local _login_data = {ssrNetMsgCfg.QianMenBaJiang_SyncResponse, 0, 0, state, data}
    if logindatas then
        table.insert(logindatas, _login_data)
    else
        Message.sendmsg(actor, ssrNetMsgCfg.QianMenBaJiang_SyncResponse, 0, 0, state, data)
    end
end

--登录触发
local function _onLoginEnd(actor, logindatas)
    QianMenBaJiang.SyncResponse(actor, logindatas)
end
--事件派发
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, QianMenBaJiang)
--注册网络消息
Message.RegisterNetMsg(ssrNetMsgCfg.QianMenBaJiang, QianMenBaJiang)
return QianMenBaJiang