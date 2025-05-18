
local TeShuHeCheng = {}
local cfg_TeShu_DouLi = include("QuestDiary/cfgcsv/cfg_TeShu_DouLi.lua")
local cfg_TeShu_GuangHuan = include("QuestDiary/cfgcsv/cfg_TeShu_GuangHuan.lua")
local cfg_TeShu_LongZhiXin = include("QuestDiary/cfgcsv/cfg_TeShu_LongZhiXin.lua")
local cfg_TeShu_ShenShouHu = include("QuestDiary/cfgcsv/cfg_TeShu_ShenShouHu.lua")
local cfg_TeShu_DunPai = include("QuestDiary/cfgcsv/cfg_TeShu_DunPai.lua")
local config = {
    {pos = 13, config = cfg_TeShu_DouLi, name="破魔斗笠"},
    {pos = 2, config = cfg_TeShu_GuangHuan, name="恢复光环"},
    {pos = 9, config = cfg_TeShu_LongZhiXin, name="龙·之心"},
    {pos = 15, config = cfg_TeShu_ShenShouHu, name="神·守护"},
    {pos = 16, config = cfg_TeShu_DunPai, name="圣灵壁垒"}
}

function TeShuHeCheng.Request(actor, pos, index)
    local cfg = config[pos]
    if not cfg then
        Player.sendmsg(actor, "提交错误!")
        return
    end
    local equipObj  = linkbodyitem(actor,cfg.pos)
    local equipName
    local field1
    if equipObj ~= "0" then
        equipName = getiteminfo(actor,equipObj,ConstCfg.iteminfo.name)
        field1 = getstditeminfo(equipName,ConstCfg.stditeminfo.custom29)
    else
        field1 = 0
    end
    --兼容未穿戴装备
    if field1 == 0 and index == 1 then
        index = 0
    end
    if not Bag.checkBagEmptyNum(actor,5) then
        Player.sendmsgEx(actor, "你的背包格子不足!")
        return
    end
    local HC_cfg = cfg.config[index]
    if not HC_cfg then
        Player.sendmsgEx(actor, string.format("你的|%s#249|已满级或者有其他更高级的装备",cfg.name))
        return
    end

    if equipName ~= HC_cfg.equip and HC_cfg.equip ~= "未穿戴" then
        Player.sendmsgEx(actor, string.format("你身上没有穿戴|%s#249",HC_cfg.equip))
        return
    end
    
    local name,num = Player.checkItemNumByTable(actor, HC_cfg.cost)
    if name then
        Player.sendmsgEx(actor, string.format("你的|%s#249|不足|%s#249", name, num))
        return
    end
    Player.takeItemByTable(actor, HC_cfg.cost)
    if HC_cfg.equip ~= "未穿戴" then
        takew(actor, HC_cfg.equip, 1)
    end
    --如果是龙之心
    if pos == 3 then
        GameEvent.push(EventCfg.LongZhiXinUp, actor, HC_cfg.give)
    end

    giveonitem(actor, cfg.pos, HC_cfg.give)

    Player.sendmsgEx(actor, "合成成功!")
    Message.sendmsg(actor,ssrNetMsgCfg.TeShuHeCheng_SyncResponse)
end
------网络消息注册------
Message.RegisterNetMsg(ssrNetMsgCfg.TeShuHeCheng, TeShuHeCheng)

return TeShuHeCheng