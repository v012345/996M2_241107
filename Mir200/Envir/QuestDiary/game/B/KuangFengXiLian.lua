local KuangFengXiLian = {}
local config = include("QuestDiary/cfgcsv/cfg_KuangFengXiLian.lua") --洗练
local where = 14
KuangFengXiLian.ID = "狂风洗练"
function KuangFengXiLian.Request(actor, arg1, arg2, arg3, locks)
    local itemobj = linkbodyitem(actor, where)
    if itemobj == "0" then
        Player.sendmsgEx(actor, "你身上没有狂风装备!#249")
        return
    end

    local name = getiteminfo(actor,itemobj,ConstCfg.iteminfo.name)
    if name ~= "疾风刻印Lv.10" then
        Player.sendmsgEx(actor, "疾风刻印Lv.10才可以洗练!#249")
        return
    end

    if type(locks) ~= "table" then
        Player.sendmsgEx(actor, "数据错误1")
        return
    end
    if #locks ~= 5 then
        Player.sendmsgEx(actor, "数据错误2")
        return
    end

    local abilDataStr = getitemcustomabil(actor, itemobj)
    local isMaxLevel = KuangFengXiLian.IsMaxLevel(abilDataStr)
    if isMaxLevel then
        Player.sendmsgEx(actor, "您的洗练已经满级了!#249")
        return
    end
    --累加元宝
    local costYuanBao = { { "元宝", 100000 } }
    for i, v in ipairs(locks) do
        if v ~= 0 then
            costYuanBao[1][2] = costYuanBao[1][2] + 200000
        end
    end

    local count = getplaydef(actor, VarCfg["U_洗练元宝总数"])
    local name,mum = Player.checkItemNumByTable(actor,costYuanBao)
    if name then
        Player.sendmsgEx(actor, string.format("洗练失败,你的|%s#249|不足|%d#249|", name, mum))
        return
    end

    Player.takeItemByTable(actor,costYuanBao,"狂风洗练")

    setplaydef(actor, VarCfg["U_洗练元宝总数"], count + costYuanBao[1][2])

    GameEvent.push(EventCfg.onKuangFengXiLian,actor,count + costYuanBao[1][2])

    changecustomitemtext(actor, itemobj, "[洗练属性]:", 0)
    changecustomitemtextcolor(actor, itemobj, 250, 0)
    for index, value in ipairs(config) do
        if locks[index] == 0 then
            local attrValue = 0
            if index == 5 then
                attrValue = math.random(1, value.ransjstr)
                setplaydef(actor, VarCfg["U_记录疾风刻印爆率变量"], tonumber(attrValue) or 0)
            else
                local str = table.concat(value.ransjstr, "|")
                attrValue = ransjstr(str,1,3)
            end
            attrValue = tonumber(attrValue) or 0
            Player.addModifyCustomAttributes(actor, itemobj, 0, index, value.attrType, value.attrColor, value.realAttrId, value.attrId, value.isAttrPercent, attrValue)
        end
    end

    local costCount = getplaydef(actor, VarCfg["U_洗练元宝总数"])
    if costCount >= 9990000 then
        for index, value in ipairs(config) do
            if index == 5 then
                setplaydef(actor, VarCfg["U_记录疾风刻印爆率变量"], value.max)
            end
            Player.addModifyCustomAttributes(actor, itemobj, 0, index, value.attrType, value.attrColor, value.realAttrId, value.attrId, value.isAttrPercent, value.max)
        end

        changecustomitemtext(actor, itemobj, "[隐藏属性]", 1)
        changecustomitemtextcolor(actor, itemobj, 254, 1)
        --打怪经验
        Player.addModifyCustomAttributes(actor, itemobj, 1, 6, 2, 255, 203, 6 , 1, 100)
        --打怪修仙值
        Player.addModifyCustomAttributes(actor, itemobj, 1, 7, 2, 255, 217, 7 , 1, 100)
        -- Player.addModifyCustomAttributes(actor, itemobj, 1, 8, 2, 255, 204, 8 , 0, 1)
        messagebox(actor,"触发保底机制,你的消耗已经达到999w元宝,属性已全满!")
    end
    --同步一次消息
    Player.setAttList(actor, "爆率附加")
    KuangFengXiLian.SyncResponse(actor)
end
--判断洗练是否满级
function KuangFengXiLian.IsMaxLevel(abilDataStr)
    local maxLevel = 0
    if abilDataStr == "" then
        return false
    end
    local abilData = json2tbl(abilDataStr)
    local abilList1 = abilData["abil"][1].v
    local abilList2 = abilData["abil"][2].v
    if abilList1 then
        for i, v in ipairs(config) do
            if abilList1[i] then
                if abilList1[i][3] >= v.max then
                    maxLevel = maxLevel + 1
                end
            end
        end
    end

    if maxLevel >= 5 and abilList2 ~= nil then
        return true
    else
        return false
    end
end


--爆率属性
local function _onCalcBaoLv(actor, attrs)
    local shuxing = {}
    local equipObj = linkbodyitem(actor, where)
    local baolv = 0
    if equipObj ~= "0" then
        baolv = getplaydef(actor, VarCfg["U_记录疾风刻印爆率变量"])
    end
    if baolv > 0 then
        shuxing[204] = baolv
    end
    calcAtts(attrs, shuxing, "爆率附加:狂风洗练")
end
GameEvent.add(EventCfg.onCalcBaoLv, _onCalcBaoLv, KuangFengXiLian)

-------------网络消息↓↓↓--------------------------
Message.RegisterNetMsg(ssrNetMsgCfg.KuangFengXiLian, KuangFengXiLian)
function KuangFengXiLian.SyncResponse(actor, logindatas)
    local count = getplaydef(actor, VarCfg["U_洗练元宝总数"])
    local _login_data = { ssrNetMsgCfg.KuangFengXiLian_SyncResponse, count }
    if logindatas then
        table.insert(logindatas, _login_data)
    else
        Message.sendmsg(actor, ssrNetMsgCfg.KuangFengXiLian_SyncResponse, count)
    end
end

--登录触发
local function _onLoginEnd(actor, logindatas)
    KuangFengXiLian.SyncResponse(actor, logindatas)
end
--事件派发
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, KuangFengXiLian)

--穿装备
local function _onTakeOn14(actor, itemobj)
    Player.setAttList(actor, "爆率附加")
end
GameEvent.add(EventCfg.onTakeOn14, _onTakeOn14, KuangFengXiLian)

--脱装备哦
local function _onTakeOff14(actor, itemobj)
    Player.setAttList(actor, "爆率附加")
end
GameEvent.add(EventCfg.onTakeOff14, _onTakeOff14, KuangFengXiLian)

return KuangFengXiLian
