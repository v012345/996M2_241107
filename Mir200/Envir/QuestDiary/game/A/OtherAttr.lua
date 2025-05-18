OtherAttr = {}
OtherAttr.ID = "其他属性"
function OtherAttr.LoadAttr(actor)
    local attlist ={}
    local attackMultiple = 100
    local QieGe = 0
    local shaguaibaolv = 0
    --狂暴之力
    if getflagstatus(actor,2) == 1 then
        --倍功
        attackMultiple = attackMultiple + 10
        --切割
        QieGe = QieGe + 1000
    end
    --计算装备切割
    local equipname = getconst(actor,"<$SRIGHTHAND>")
    if equipname ~= "" then
        local qiegenum = getstditeminfo(equipname,ConstCfg.stditeminfo.custom29)
        QieGe = QieGe + qiegenum
    end
    --增加倍功
    powerrate(actor,attackMultiple,65535)

    --增加切割
    setplaydef(actor,"N$怪物切割",QieGe)
    
    table.insert(attlist,QieGe) --1切割
    table.insert(attlist,attackMultiple) --2倍功
    
    Message.sendmsg(actor, ssrNetMsgCfg.OtherAttr_SyncResponse,0,0,0,attlist)
    
end
--登录同步一次
GameEvent.add(EventCfg.onOtherAttr,OtherAttr.LoadAttr,OtherAttr)

--穿装备
local function _onTakeOnEx(actor, itemobj, where, itemname, makeid)
    local StdMode = getstditeminfo(itemname, ConstCfg.stditeminfo.stdmode)
    if StdMode == 83 then
        OtherAttr.LoadAttr(actor)
    end
end
GameEvent.add(EventCfg.onTakeOnEx, _onTakeOnEx, OtherAttr)
--脱装备
local function _onTakeOffEx(actor, itemobj, where, itemname, makeid)
    local StdMode = getstditeminfo(itemname, ConstCfg.stditeminfo.stdmode)
    if StdMode == 83 then
        OtherAttr.LoadAttr(actor)
    end
end

GameEvent.add(EventCfg.onTakeOffEx, _onTakeOffEx, OtherAttr)

Message.RegisterNetMsg(ssrNetMsgCfg.OtherAttr, OtherAttr)

return OtherAttr