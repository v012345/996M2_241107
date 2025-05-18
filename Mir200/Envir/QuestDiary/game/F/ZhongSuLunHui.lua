local ZhongSuLunHui = {}
local cost ={{{"混沌之心",1},{"元宝", 5550000}},{{"破灭之核",1},{"元宝", 5550000}},{{"轮回之魂",1},{"灵符", 12888}}} 
local JianDingData = {
    {weizhi = 0, attrIndex = 1, looksIndex  = 34, attrValue  = 30000, clor  = 250},
    {weizhi = 1, attrIndex = 4, looksIndex  = 35, attrValue  = 1888, clor  = 250},
    {weizhi = 2, attrIndex = 174, looksIndex  = 36, attrValue  = 1, clor  = 250}
}

--获取激活状态
function ZhongSuLunHui.getFlagstate(actor)
    local state1 = getflagstatus(actor,VarCfg["F_重塑轮回1"])
    local state2 = getflagstatus(actor,VarCfg["F_重塑轮回2"])
    local state3 = getflagstatus(actor,VarCfg["F_重塑轮回3"])
    local flagTbl = {state1,state2,state3}
    return flagTbl
end
-- 破晓之境	77	107


function ZhongSuLunHui.Request(actor,var)
    local itemobj = nil
    for i = 77, 99 do
        local itemnane = getiteminfo(actor, linkbodyitem(actor, i), 7)
        if itemnane == "六道轮回盘" then
            itemobj = linkbodyitem(actor, i)
        end
    end

    if not itemobj then
        Player.sendmsgEx(actor, "[提示]:#251|对不起.你未穿戴|[六道轮回盘]#249|重塑失败!")
        return
    end

    local flagTbl = ZhongSuLunHui.getFlagstate(actor) --获取激活状态
    if flagTbl[var] == 1 then return end
    local name, num = Player.checkItemNumByTable(actor, cost[var])
    if name then
        Player.sendmsgEx(actor, string.format("提示#251|:#255|你的|%s#249|数量不足|%d#249|,重塑失败...", name, num))
        return
    end
    Player.takeItemByTable(actor, cost[var], "重塑轮回"..var.. "")
    local cfg = JianDingData[var]
    local weizhi = cfg.weizhi
    local attrIndex = cfg.attrIndex
    local looksIndex = cfg.looksIndex
    local attrValue = cfg.attrValue
    local clor = cfg.clor
    changecustomitemtext(actor, itemobj, "[轮混重塑]", 0)
    changecustomitemtextcolor(actor, itemobj, 253, 0)
    changecustomitemabil(actor,itemobj,weizhi,0,clor,0)      --自定义属性颜色
    changecustomitemabil(actor,itemobj,weizhi,1,attrIndex,0) --真实属性
    changecustomitemabil(actor,itemobj,weizhi,2,looksIndex,0) --显示属性
    changecustomitemabil(actor,itemobj,weizhi,4,weizhi,0)   --显示位置(0~9)
    changecustomitemvalue(actor,itemobj,weizhi,"=",attrValue,0)
    refreshitem(actor,itemobj)
    setflagstatus(actor,VarCfg["F_重塑轮回".. var ..""], 1)


    if var == 3 then
        changelevel(actor,"+", 1)
    end

    --刷新前端
    ZhongSuLunHui.SyncResponse(actor)
end

--人物穿装备----人物穿戴任意装备触发
local function _onTakeOnEx(actor, itemobj, where, itemname, makeid)
    if itemname == "六道轮回盘" then
        if getflagstatus(actor,VarCfg["F_重塑轮回3"]) == 1 then
            changelevel(actor,"+", 1)
        end
    end
end
GameEvent.add(EventCfg.onTakeOnEx, _onTakeOnEx, ZhongSuLunHui)

--人物脱装备---人物脱下任意装备触发
local function _onTakeOffEx(actor, itemobj, where, itemname, makeid)
    if itemname == "六道轮回盘" then
        if getflagstatus(actor,VarCfg["F_重塑轮回3"]) == 1 then
            changelevel(actor,"-", 1)
        end
    end
end
GameEvent.add(EventCfg.onTakeOffEx, _onTakeOffEx, ZhongSuLunHui)

--注册网络消息
function ZhongSuLunHui.SyncResponse(actor, logindatas)
    local data = ZhongSuLunHui.getFlagstate(actor) --获取激活状态
    local _login_data = { ssrNetMsgCfg.ZhongSuLunHui_SyncResponse, 0, 0, 0, data }
    if logindatas then
        table.insert(logindatas, _login_data)
    else
        Message.sendmsg(actor, ssrNetMsgCfg.ZhongSuLunHui_SyncResponse, 0, 0, 0, data)
    end
end
Message.RegisterNetMsg(ssrNetMsgCfg.ZhongSuLunHui, ZhongSuLunHui)

--登录触发
local function _onLoginEnd(actor, logindatas)
    ZhongSuLunHui.SyncResponse(actor, logindatas)
end
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, ZhongSuLunHui)

return ZhongSuLunHui
