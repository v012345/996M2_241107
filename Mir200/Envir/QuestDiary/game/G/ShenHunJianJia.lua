local ShenHunJianJia = {}
ShenHunJianJia.ID = "神魂剑甲"
local npcID = 802
local config = include("QuestDiary/cfgcsv/cfg_ShenHunJianJia.lua") --配置
local abilGroup = 3                                                      --自定义属性位置
function ShenHunJianJia.Request(actor, where, arg2)
    local isInRange = FCheckNPCRange(actor, npcID, 15)
    if not isInRange then
        Player.sendmsgEx(actor, "距离太远#249")
        return
    end
    if where ~= 1 and where ~= 0 then
        Player.sendmsgEx(actor, "[提示]:#251|请放入衣服或者武器!#249")
        return
    end

    local itemobj = linkbodyitem(actor, where)
    if itemobj == "0" then
        if where == 1 then
            Player.sendmsgEx(actor, "提示：#251|你的#250|武器#249|部位#250|没有装备#249|强化失败...#250")
        else
            Player.sendmsgEx(actor, "提示：#251|你的#250|衣服#249|部位#250|没有装备#249|强化失败...#250")
        end
        return
    end

    local B_var
    local equipName = ""
    local realAttrId
    local attrId

    if where == 1 then
        B_var = VarCfg["B_神魂武器"]
        equipName = "武器"
        realAttrId = 229
        attrId = 81
    else
        B_var = VarCfg["B_神魂衣服"]
        equipName = "衣服"
        realAttrId = 230
        attrId = 82
    end

    local qianghualevel = getplaydef(actor, B_var)
    local cfg = config[qianghualevel]

    if qianghualevel >= 10 then
        Player.sendmsgEx(actor, "提示#251|:#255|对不起,你的|" .. equipName .. "#249|已经强化到|10#249|级了,无法继续强化...")
        return
    end

    if arg2 == 1 then
        local name, mum = Player.checkItemNumByTable(actor, cfg.cost1)
        if name then
            Player.sendmsgEx(actor, string.format("[提示]:#251|你的|%s#249|不足|%d#249|,强化失败...", name, mum))
            return
        end
        Player.takeItemByTable(actor, cfg.cost1, "神魂剑甲")
        local percentage = cfg.percentage1 --概率
        local minimum = cfg.minimum        --最少次数
        local currNum = getplaydef(actor, VarCfg["B_神魂武器_保底"])
        if minimum > currNum then          --如果最少次数比保底次数大 概率0
            percentage = 0
        end
        if currNum >= 9 then --10次保底 概率100%   因为需要点击十次,因为初始值是0到9次是点击10次
            percentage = 100
        end
        if randomex(percentage, 100) then
            setplaydef(actor, B_var, qianghualevel + 1)
            local attrValue = config[qianghualevel + 1].attr
            clearitemcustomabil(actor, itemobj, abilGroup)
            changecustomitemtext(actor, itemobj, "[神魂属性]:", abilGroup)
            changecustomitemtextcolor(actor, itemobj, 252, abilGroup)
            Player.addModifyCustomAttributes(actor, itemobj, abilGroup, 1, 0, 0, realAttrId, attrId, 1, attrValue) --设置属性
            Player.sendmsgEx(actor, "[提示]:恭喜,你的" .. equipName .. "强化成功#250")
            setplaydef(actor, VarCfg["B_神魂武器_保底"], 0)
        else
            Player.sendmsgEx(actor, "[提示]:抱歉,你的" .. equipName .. "强化失败#249")
            setplaydef(actor, VarCfg["B_神魂武器_保底"], currNum + 1)
            ShenHunJianJia.SyncResponse(actor)
        end
    elseif arg2 == 2 then
        -- B_神魂衣服_保底
        local name, mum = Player.checkItemNumByTable(actor, cfg.cost2)
        if name then
            Player.sendmsgEx(actor, string.format("[提示]:#251|你的|%s#249|不足|%d#249|,强化失败...", name, mum))
            return
        end
        Player.takeItemByTable(actor, cfg.cost2, "神魂剑甲")
        local percentage = cfg.percentage3 --概率
        local minimum = cfg.minimum        --最少次数
        local currNum = getplaydef(actor, VarCfg["B_神魂衣服_保底"])
        if minimum > currNum then          --如果最少次数比保底次数大 概率0
            percentage = 0
        end
        if currNum >= 10 then --10次保底 概率100%
            percentage = 100
        end
        if randomex(percentage, 100) then
            setplaydef(actor, B_var, qianghualevel + 1)
            local attrValue = config[qianghualevel + 1].attr
            clearitemcustomabil(actor, itemobj, abilGroup)
            changecustomitemtext(actor, itemobj, "[淬炼属性]:", abilGroup)
            changecustomitemtextcolor(actor, itemobj, 252, abilGroup)
            Player.addModifyCustomAttributes(actor, itemobj, abilGroup, 1, 0, 0, realAttrId, 0, 1, attrValue) --设置属性
            Player.sendmsgEx(actor, "[提示]:恭喜,你的" .. equipName .. "强化成功#250")
            setplaydef(actor, VarCfg["B_神魂衣服_保底"], 0)
        else
            Player.sendmsgEx(actor, "[提示]:抱歉,你的" .. equipName .. "强化失败#249")
            setplaydef(actor, VarCfg["B_神魂衣服_保底"], currNum + 1)
            ShenHunJianJia.SyncResponse(actor)
        end
    end


    local WuQiNum = getplaydef(actor, VarCfg["B_神魂武器"])
    local YiFuNum = getplaydef(actor, VarCfg["B_神魂衣服"])
    setplaydef(actor, VarCfg["B_神魂剑甲总次数"], WuQiNum + YiFuNum)
    setflagstatus(actor, VarCfg["F_了解剑甲淬炼完成"], 1)
    --同步一次消息
    ShenHunJianJia.SyncResponse(actor)
end

-- function ShenHunJianJia.Open(actor)
--     local flag = getflagstatus(actor,VarCfg["F_了解剑甲淬炼完成"])
--     if  flag == 0 then
--         setflagstatus(actor,VarCfg["F_了解剑甲淬炼完成"],1)
--         local taskPanelID = getplaydef(actor, VarCfg["U_主线任务面板进度"])
--         if taskPanelID == 10 then
--             FCheckTaskRedPoint(actor)
--         end
--     end
-- end

------------引擎出发↓↓↓--------------------------
--穿装备触发
local function _onTakeOn(actor, itemobj)
    local itemidx = getiteminfo(actor, itemobj, ConstCfg.iteminfo.idx)
    local stdmode = getstditeminfo(itemidx, ConstCfg.stditeminfo.stdmode)
    local where = ConstCfg.stdmodewheremap[stdmode]
    local B_var
    local realAttrId
    local attrId
    clearitemcustomabil(actor, itemobj, abilGroup)
    if where[1] == 1 then
        B_var = VarCfg["B_神魂武器"]
        realAttrId = 229
        attrId = 81
    else
        B_var = VarCfg["B_神魂衣服"]
        realAttrId = 230
        attrId = 82
    end
    local index = getplaydef(actor, B_var)
    if index == 0 then
        return
    end
    local cfg = config[index]
    if cfg == nil then
        return
    end
    changecustomitemtext(actor, itemobj, "[神魂属性]:", abilGroup)
    changecustomitemtextcolor(actor, itemobj, 252, abilGroup)
    Player.addModifyCustomAttributes(actor, itemobj, abilGroup, 1, 0, 0, realAttrId, attrId, 1, cfg.attr)
    refreshitem(actor, itemobj)
end
--脱装备出发
local function _onTakeOff(actor, itemobj)
    local itemidx = getiteminfo(actor, itemobj, ConstCfg.iteminfo.idx)
    local stdmode = getstditeminfo(itemidx, ConstCfg.stditeminfo.stdmode)
    local where = ConstCfg.stdmodewheremap[stdmode]

    --清空属性
    local itemobj1 = linkbodyitem(actor, where[1])
    clearitemcustomabil(actor, itemobj, abilGroup)
    refreshitem(actor, itemobj)
    -- recalcabilitys(actor)
end

local function _onLoginEnd(actor, logindatas)
    ShenHunJianJia.SyncResponse(actor, logindatas)
end

GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, ShenHunJianJia)

--穿戴武器前
GameEvent.add(EventCfg.onTakeOnWeapon, _onTakeOn, ShenHunJianJia)
--脱下武器前
GameEvent.add(EventCfg.onTakeOffWeapon, _onTakeOff, ShenHunJianJia)

--穿戴衣服前
GameEvent.add(EventCfg.onTakeOnDress, _onTakeOn, ShenHunJianJia)
--脱下衣服前
GameEvent.add(EventCfg.onTakeOffDress, _onTakeOff, ShenHunJianJia)

-------------网络消息↓↓↓--------------------------
Message.RegisterNetMsg(ssrNetMsgCfg.ShenHunJianJia, ShenHunJianJia)

function ShenHunJianJia.SyncResponse(actor, logindatas)
    local B9 = getplaydef(actor, VarCfg["B_神魂武器"])
    local B10 = getplaydef(actor, VarCfg["B_神魂衣服"])
    local data = { B9, B10 }
    local _login_data = { ssrNetMsgCfg.ShenHunJianJia_SyncResponse, 0, 0, 0, data }
    if logindatas then
        table.insert(logindatas, _login_data)
    else
        Message.sendmsg(actor, ssrNetMsgCfg.ShenHunJianJia_SyncResponse, 0, 0, 0, data)
    end
end

return ShenHunJianJia
