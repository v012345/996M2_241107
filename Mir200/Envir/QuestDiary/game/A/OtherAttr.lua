OtherAttr = {}
OtherAttr.ID = "��������"
function OtherAttr.LoadAttr(actor)
    local attlist ={}
    local attackMultiple = 100
    local QieGe = 0
    local shaguaibaolv = 0
    --��֮��
    if getflagstatus(actor,2) == 1 then
        --����
        attackMultiple = attackMultiple + 10
        --�и�
        QieGe = QieGe + 1000
    end
    --����װ���и�
    local equipname = getconst(actor,"<$SRIGHTHAND>")
    if equipname ~= "" then
        local qiegenum = getstditeminfo(equipname,ConstCfg.stditeminfo.custom29)
        QieGe = QieGe + qiegenum
    end
    --���ӱ���
    powerrate(actor,attackMultiple,65535)

    --�����и�
    setplaydef(actor,"N$�����и�",QieGe)
    
    table.insert(attlist,QieGe) --1�и�
    table.insert(attlist,attackMultiple) --2����
    
    Message.sendmsg(actor, ssrNetMsgCfg.OtherAttr_SyncResponse,0,0,0,attlist)
    
end
--��¼ͬ��һ��
GameEvent.add(EventCfg.onOtherAttr,OtherAttr.LoadAttr,OtherAttr)

--��װ��
local function _onTakeOnEx(actor, itemobj, where, itemname, makeid)
    local StdMode = getstditeminfo(itemname, ConstCfg.stditeminfo.stdmode)
    if StdMode == 83 then
        OtherAttr.LoadAttr(actor)
    end
end
GameEvent.add(EventCfg.onTakeOnEx, _onTakeOnEx, OtherAttr)
--��װ��
local function _onTakeOffEx(actor, itemobj, where, itemname, makeid)
    local StdMode = getstditeminfo(itemname, ConstCfg.stditeminfo.stdmode)
    if StdMode == 83 then
        OtherAttr.LoadAttr(actor)
    end
end

GameEvent.add(EventCfg.onTakeOffEx, _onTakeOffEx, OtherAttr)

Message.RegisterNetMsg(ssrNetMsgCfg.OtherAttr, OtherAttr)

return OtherAttr