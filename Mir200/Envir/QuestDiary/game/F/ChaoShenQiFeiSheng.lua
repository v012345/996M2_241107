local ChaoShenQiFeiSheng = {}
local config = include("QuestDiary/cfgcsv/cfg_ChaoShenQiFeiSheng.lua") --配置


--鉴定属性
function ChaoShenQiFeiSheng.Request(actor,var)
    local itemobj = linkbodyitem(actor, var) --获取物品对象
    if itemobj == "0" then return end  --对象为空 返回
    local itemname = getiteminfo(actor, itemobj, 7) --获取物品名称  
    local  StarNum = getitemaddvalue(actor, itemobj, 2, 3) --获取星星数量
    if StarNum >= 5 then
        Player.sendmsgEx(actor, "提示#251|:#255|对不起,你的|".. itemname .."#249|已经飞升|".. StarNum .."次#249|...")
        return
    end
    local cfg = config[itemname]
    -- 检测扣除费用
    local name, num = Player.checkItemNumByTable(actor, cfg["cost"..StarNum+1])
    if name then
        Player.sendmsgEx(actor, string.format("你的|%s#249|不足|%d#249|枚,鉴定失败...", name, num))
        return
    end
    Player.takeItemByTable(actor, cfg["cost"..StarNum+1],itemname.."飞升扣除")
    setitemaddvalue(actor, itemobj, 2, 3, StarNum+1) --设置星星
    -- setitemaddvalue(actor, itemobj, 2, 3, 1) --设置星星
    local AttrCfg = config[StarNum+1]
    clearitemcustomabil(actor,itemobj,-1)
    local tbl = {
                ["abil"] = {
                    {
                        ["i"] = 0,
                        ["t"] = "[超神器飞升]",
                        ["c"] = 250,
                        ["v"] = {
                            --全属性
                            {0,208,AttrCfg.Attr1,0,78, 1,1},
                            {0,209,AttrCfg.Attr1,0,78, 1,2},
                            {0,210,AttrCfg.Attr1,0,78, 1,3},
                            {0,211,AttrCfg.Attr1,0,78, 1,4},
                            {0,212,AttrCfg.Attr1,0,78, 1,5},
                            {0,213,AttrCfg.Attr1,0,78, 1,6},
                            {0,214,AttrCfg.Attr1,0,78, 1,7},
                            --攻击力
                            {0,210,AttrCfg.Attr2,0,79, 2,8},
                            --血量值
                            {0,208,AttrCfg.Attr2,0,80, 3,9},

                        },
                    },
                },
            }
    setitemcustomabil(actor,itemobj,tbl2json(tbl))
    refreshitem(actor,itemobj)
    ChaoShenQiFeiSheng.SyncResponse(actor)
    Player.setAttList(actor, "属性附加")
end

--属性附加触发
local StarAttr = {
    [1] = {["防爆属性"] = 5, ["神魂属性"] = 5},
    [2] = {["防爆属性"] = 10, ["神魂属性"] = 8},
    [3] = {["防爆属性"] = 15, ["神魂属性"] = 12},
    [4] = {["防爆属性"] = 30, ["神魂属性"] = 18},
    [5] = {["防爆属性"] = 50, ["神魂属性"] = 25}
}

--属性刷新触发
local function _onCalcAttr(actor,attrs)
    if getplaydef(actor,VarCfg["U_记录大陆"]) < 7 then return end
    --获取最小等级
    local NumData = {}
    for i = 71, 76 do
        local itemobj = linkbodyitem(actor, i) --获取物品对象
        local  _StarNum = getitemaddvalue(actor, itemobj, 2, 3) --获取星星数量
        local StarNum = (_StarNum < 0 and 0) or _StarNum
        table.insert(NumData, StarNum)
    end

    local min = math.min(NumData[1], NumData[2], NumData[3], NumData[4], NumData[5], NumData[6])
    if StarAttr[min] then
        setplaydef(actor,VarCfg["U_超神套装等级"],min)
        local shuxing = {} -- 属性表
        shuxing[32] = StarAttr[min]["防爆属性"]
        shuxing[229] = StarAttr[min]["神魂属性"]
        shuxing[230] = StarAttr[min]["神魂属性"]
        calcAtts(attrs,shuxing,"超神飞升套装属性")
    end
end
--属性附加触发
GameEvent.add(EventCfg.onCalcAttr, _onCalcAttr, ChaoShenQiFeiSheng)

local ItemData = {["一缕神念"] = true, ["暮潮"] = true, ["金色黎明的圣物箱"] = true, ["永恒凛冬"] = true, ["降星者"] = true, ["孤影流觞"] = true}
--穿装备触发
local function _onTakeOnEx(actor, itemobj, where, itemname, makeid)
    if getplaydef(actor,VarCfg["U_记录大陆"]) < 7 then return end
    if ItemData[itemname] then
        Player.setAttList(actor, "属性附加")
    end
end
GameEvent.add(EventCfg.onTakeOnEx, _onTakeOnEx, ChaoShenQiFeiSheng)

--脱装备触发
local function _onTakeOffEx(actor, itemobj, where, itemname, makeid)
    if getplaydef(actor,VarCfg["U_记录大陆"]) < 7 then return end
    if ItemData[itemname] then
        Player.setAttList(actor, "属性附加")
    end
end
GameEvent.add(EventCfg.onTakeOffEx, _onTakeOffEx, ChaoShenQiFeiSheng)

--注册网络消息
function ChaoShenQiFeiSheng.SyncResponse(actor, logindatas)
    Message.sendmsg(actor, ssrNetMsgCfg.ChaoShenQiFeiSheng_SyncResponse, 0, 0, 0, nil)
end
Message.RegisterNetMsg(ssrNetMsgCfg.ChaoShenQiFeiSheng, ChaoShenQiFeiSheng)


return ChaoShenQiFeiSheng
