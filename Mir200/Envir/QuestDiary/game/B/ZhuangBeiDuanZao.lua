local ZhuangBeiDuanZao = {}
local config = include("QuestDiary/cfgcsv/cfg_ZhuangBeiDuanZao.lua") --洗练
local abilGroup = 0 --自定义属性位置

function ZhuangBeiDuanZao.Request(actor, where, arg2)

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

    local U_var
    local equipName = ""
    local realAttrId
    local attrId

    if where == 1 then
        U_var = VarCfg["U_武器锻造"]
        equipName = "武器"
        realAttrId = 206
        attrId = 4
    else
        U_var = VarCfg["U_衣服锻造"]
        equipName = "衣服"
        realAttrId = 207
        attrId = 5
    end

    local qianghualevel = getplaydef(actor, U_var)
    local cfg = config[qianghualevel]

    if qianghualevel >= 15 then
        Player.sendmsgEx(actor, "提示#251|:#255|对不起,你的|"..equipName.."#249|已经强化到|15#249|级了,无法继续强化...")
        return
    end

    if arg2 == 1 then

        local name, mum = Player.checkItemNumByTable(actor, cfg.cost1)
        if name then
            Player.sendmsgEx(actor, string.format("[提示]:#251|你的|%s#249|不足|%d#249|枚,锻造失败...", name, mum))
            return
        end
            Player.takeItemByTable(actor,cfg.cost1,"拿走所需材料及其货币")

        if randomex(cfg.percentage1,100) then
            setplaydef(actor, U_var, qianghualevel+1)
            local attrValue = config[qianghualevel+1].attr
            clearitemcustomabil(actor, itemobj,abilGroup)
            changecustomitemtext(actor, itemobj, "[淬炼属性]:", abilGroup)
            changecustomitemtextcolor(actor, itemobj, 252, abilGroup)
            Player.addModifyCustomAttributes(actor, itemobj, abilGroup, 1, 0, 0, realAttrId, attrId, 1, attrValue) --设置属性
            Player.sendmsgEx(actor, "[提示]:恭喜,你的"..equipName.."锻造成功#250")
        else
            Player.sendmsgEx(actor, "[提示]:抱歉,你的"..equipName.."锻造失败#249")
            ZhuangBeiDuanZao.SyncResponse(actor)
        end

    elseif arg2 == 2 then
        local name, mum = Player.checkItemNumByTable(actor, cfg.cost2)
        if name then
            Player.sendmsgEx(actor, string.format("[提示]:#251|你的|%s#249|不足|%d#249|枚,锻造失败...", name, mum))
            return
        end
            Player.takeItemByTable(actor,cfg.cost2,"拿走所需材料及其货币")
            setplaydef(actor, U_var, qianghualevel+1)
            local attrValue = config[qianghualevel+1].attr
            clearitemcustomabil(actor, itemobj,abilGroup)
            changecustomitemtext(actor, itemobj, "[淬炼属性]:", abilGroup)
            changecustomitemtextcolor(actor, itemobj, 252, abilGroup)
            Player.addModifyCustomAttributes(actor, itemobj, abilGroup, 1, 0, 0, realAttrId, attrId, 1, attrValue) --设置属性
            Player.sendmsgEx(actor, "[提示]:恭喜,你的"..equipName.."锻造成功#250")
    end


    local  WuQiNum = getplaydef(actor,VarCfg["U_武器锻造"])
    local  YiFuNum = getplaydef(actor,VarCfg["U_衣服锻造"])
    setplaydef(actor,VarCfg["U_剑甲淬炼总次数"],WuQiNum+YiFuNum)
    setflagstatus(actor,VarCfg["F_了解剑甲淬炼完成"],1)
    --任务红点
    -- if WuQiNum+YiFuNum == 1 then
    --     local taskPanelID = getplaydef(actor, VarCfg["U_主线任务面板进度"])
    --     if taskPanelID == 10 then
    --         FCheckTaskRedPoint(actor)
    --     end
    -- end

    GameEvent.push(EventCfg.onJianJiaCuLian, actor, WuQiNum+YiFuNum)
    --同步一次消息
    ZhuangBeiDuanZao.SyncResponse(actor)
end

function ZhuangBeiDuanZao.Open(actor)
    local flag = getflagstatus(actor,VarCfg["F_了解剑甲淬炼完成"])
    if  flag == 0 then
        setflagstatus(actor,VarCfg["F_了解剑甲淬炼完成"],1)
        local taskPanelID = getplaydef(actor, VarCfg["U_主线任务面板进度"])
        if taskPanelID == 10 then
            FCheckTaskRedPoint(actor)
        end
    end
end

------------引擎出发↓↓↓--------------------------
--穿装备触发
local function _onTakeOn(actor, itemobj)
    local itemidx = getiteminfo(actor, itemobj ,ConstCfg.iteminfo.idx)
    local stdmode = getstditeminfo(itemidx, ConstCfg.stditeminfo.stdmode)
    local where = ConstCfg.stdmodewheremap[stdmode]
    local U_var
    local realAttrId
    local attrId
    clearitemcustomabil(actor, itemobj,abilGroup)
    if where[1] == 1 then
        U_var = VarCfg["U_武器锻造"]
        realAttrId = 206
        attrId = 4
    else
        U_var = VarCfg["U_衣服锻造"]
        realAttrId = 207
        attrId = 5
    end
    local index = getplaydef(actor, U_var)
    if index == 0 then
        return
    end
    local cfg = config[index]
    if cfg == nil then
        return
    end
    changecustomitemtext(actor, itemobj, "[淬炼属性]:", abilGroup)
    changecustomitemtextcolor(actor, itemobj, 252, abilGroup)
    Player.addModifyCustomAttributes(actor, itemobj, abilGroup, 1, 0, 0, realAttrId, attrId, 1, cfg.attr)
    refreshitem(actor, itemobj)
end
--脱装备出发
local function _onTakeOff(actor, itemobj)
    local itemidx = getiteminfo(actor, itemobj ,ConstCfg.iteminfo.idx)
    local stdmode = getstditeminfo(itemidx, ConstCfg.stditeminfo.stdmode)
    local where = ConstCfg.stdmodewheremap[stdmode]

    -- release_print(where[1])
    --清空属性
    local itemobj1 = linkbodyitem(actor, where[1])
    -- release_print(itemobj1, itemobj)
    clearitemcustomabil(actor,itemobj,abilGroup)
    refreshitem(actor, itemobj)
    -- recalcabilitys(actor)

end

local function _onLoginEnd(actor, logindatas)
    ZhuangBeiDuanZao.SyncResponse(actor, logindatas)
end

GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, ZhuangBeiDuanZao)

--穿戴武器前
GameEvent.add(EventCfg.onTakeOnWeapon, _onTakeOn, ZhuangBeiDuanZao)
--脱下武器前
GameEvent.add(EventCfg.onTakeOffWeapon, _onTakeOff, ZhuangBeiDuanZao)

--穿戴衣服前
GameEvent.add(EventCfg.onTakeOnDress, _onTakeOn, ZhuangBeiDuanZao)
--脱下衣服前
GameEvent.add(EventCfg.onTakeOffDress, _onTakeOff, ZhuangBeiDuanZao)

-------------网络消息↓↓↓--------------------------
Message.RegisterNetMsg(ssrNetMsgCfg.ZhuangBeiDuanZao, ZhuangBeiDuanZao)

function ZhuangBeiDuanZao.SyncResponse(actor, logindatas)
    local U14 = getplaydef(actor,VarCfg["U_武器锻造"])
    local U15 = getplaydef(actor,VarCfg["U_衣服锻造"])
    local data = {U14,U15}
    local _login_data = {ssrNetMsgCfg.ZhuangBeiDuanZao_SyncResponse, 0, 0, 0, data}
    if logindatas then
        table.insert(logindatas, _login_data)
    else
        Message.sendmsg(actor, ssrNetMsgCfg.ZhuangBeiDuanZao_SyncResponse, 0, 0, 0, data)
    end
end

return ZhuangBeiDuanZao
