local ZhenBaoJianDing = {}
local cost1 = { { "灵石", 2 }, { "元宝", 60000 }}       --重置消耗
local cost2 = { { "幻灵水晶", 50 }, { "金币", 660000 }}  --鉴定消耗
local config = include("QuestDiary/cfgcsv/cfg_ZhenBaoJianDing.lua") --配置
---* 获取装备鉴定的属性条数
---* 参数1 玩家对象
---* 参数2 物品对象
function ZhenBaoJianDing.Attributelocation(actor, itemobj)
    local WeiZhiNum = 0
    local _data = getitemcustomabil(actor,itemobj)
    if _data == "" then
        return 0
    else
        local _data = json2tbl(_data)
        local data = _data.abil[1].v
        for _, v in ipairs(data) do
            if v then
                WeiZhiNum = WeiZhiNum + 1
            end
        end
    end
    return WeiZhiNum
end
---* 开始鉴定属性
---* 参数1 玩家对象
---* 参数2 物品对象
---* 参数3 属性名字
function ZhenBaoJianDing.setItemAttr(actor,itemobj,TypeName)
    local AttrNum = ZhenBaoJianDing.Attributelocation(actor, itemobj)
    local cfg = config[TypeName]
    if AttrNum == 0 then
        changecustomitemtext(actor, itemobj, "[珍宝鉴定]：", 0)
        changecustomitemtextcolor(actor, itemobj, 253, 0)
    end
    local weizhi = AttrNum --位置
    local realAttrId = cfg.realAttrId
    local attrId = cfg.attrId
    local attrValue = math.random(1, cfg.max)
    local isAttrPercent = cfg.isAttrPercent
    changecustomitemabil(actor,itemobj,weizhi,1,realAttrId,0) --真实属性
    changecustomitemabil(actor,itemobj,weizhi,2,attrId,0) --显示属性
    changecustomitemabil(actor,itemobj,weizhi,3,isAttrPercent,0) --是否百分比
    changecustomitemabil(actor,itemobj,weizhi,4,weizhi,0)   --显示位置(0~9)
    changecustomitemvalue(actor,itemobj,weizhi,"=",attrValue,0)
end

--清除属性
function ZhenBaoJianDing.Request1(actor,var)
    local itemobj = linkbodyitem(actor, var) --获取物品对象
    if itemobj == "0" then return end  --对象为空 返回
    local itemname = getiteminfo(actor, itemobj, 7) --获取物品名称
    local AttrNum = ZhenBaoJianDing.Attributelocation(actor, itemobj)
    if AttrNum == 0 then
        Player.sendmsgEx(actor, "提示#251|:#255|你的|".. itemname .."#249|没有鉴定过,重置失败...")
        return
    end
    local name, num = Player.checkItemNumByTable(actor, cost1)
    if name then
        Player.sendmsgEx(actor, string.format("你的|%s#249|不足|%d#249|枚,重置属性失败...", name, num))
        return
    end

    Player.takeItemByTable(actor, cost1,"珍宝属性重置")
    clearitemcustomabil(actor,itemobj,-1)
    Player.sendmsgEx(actor, "提示#251|:#255|你的|".. itemname .."#249|重置成功...")
    refreshitem(actor,itemobj)
    ZhenBaoJianDing.SyncResponse(actor)
    delaygoto(actor,1000,"yan_chi_shua_xin_gong_su")

end
--鉴定属性
function ZhenBaoJianDing.Request2(actor,var)
    local itemobj = linkbodyitem(actor, var) --获取物品对象
    if itemobj == "0" then return end  --对象为空 返回
    local itemname = getiteminfo(actor, itemobj, 7) --获取物品名称

    local AttrNum = ZhenBaoJianDing.Attributelocation(actor, itemobj)
    if AttrNum == 5 then
        Player.sendmsgEx(actor, "提示#251|:#255|你的|".. itemname .."#249|鉴定条数已达到5条...")
        return
    end

    -- 检测扣除费用
    local name, num = Player.checkItemNumByTable(actor, cost2)
    if name then
        Player.sendmsgEx(actor, string.format("你的|%s#249|不足|%d#249|枚,鉴定失败...", name, num))
        return
    end
    Player.takeItemByTable(actor, cost2,"珍宝鉴定")
    local num = getplaydef(actor,VarCfg["B_珍宝鉴定次数"])
    setplaydef(actor,VarCfg["B_珍宝鉴定次数"],num+1)
    if randomex(config[AttrNum+1].randomNum,100) then
    -- if randomex(1,1) then
        local _str = config[AttrNum+1].ransjstr
        local str = table.concat(_str, "|")
        local TypeName, _ = ransjstr(str, 1, 3)
        ZhenBaoJianDing.setItemAttr(actor,itemobj,TypeName)
        delaygoto(actor,1000,"yan_chi_shua_xin_gong_su")
    else
        Player.sendmsgEx(actor, "提示#251|:#255|对不起,你的|".. itemname .."#249|鉴定失败,材料扣除...")
    end

    refreshitem(actor,itemobj)
    ZhenBaoJianDing.SyncResponse(actor)
end

--延迟属性附加
function yan_chi_shua_xin_gong_su(actor)
    Player.setAttList(actor, "攻速附加")
end

-- 攻速附加
local function _onCalcAttackSpeed(actor, attackSpeeds)
    local gongSu = getbaseinfo(actor, 51, 232) --连爆概率
    attackSpeeds[1] = attackSpeeds[1] + gongSu
end
GameEvent.add(EventCfg.onCalcAttackSpeed, _onCalcAttackSpeed, ZhenBaoJianDing)

--穿装备触发
local function _onTakeOnEx(actor, itemobj, where, itemname, makeid)
    if getplaydef(actor,VarCfg["U_记录大陆"]) < 7 then return end
    if where >= 30 and where <= 37 then
        delaygoto(actor,1000,"yan_chi_shua_xin_gong_su")
    end
end
GameEvent.add(EventCfg.onTakeOnEx, _onTakeOnEx, ZhenBaoJianDing)

--脱装备触发
local function _onTakeOffEx(actor, itemobj, where, itemname, makeid)
    if getplaydef(actor,VarCfg["U_记录大陆"]) < 7 then return end
    if where >= 30 and where <= 37 then
        delaygoto(actor,1000,"yan_chi_shua_xin_gong_su")
    end
end
GameEvent.add(EventCfg.onTakeOffEx, _onTakeOffEx, ZhenBaoJianDing)


--注册网络消息
function ZhenBaoJianDing.SyncResponse(actor, logindatas)
    Message.sendmsg(actor, ssrNetMsgCfg.ZhenBaoJianDing_SyncResponse, 0, 0, 0, nil)
end
Message.RegisterNetMsg(ssrNetMsgCfg.ZhenBaoJianDing, ZhenBaoJianDing)

return ZhenBaoJianDing
