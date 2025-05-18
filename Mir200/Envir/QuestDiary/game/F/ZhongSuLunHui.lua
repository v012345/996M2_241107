local ZhongSuLunHui = {}
local cost ={{{"����֮��",1},{"Ԫ��", 5550000}},{{"����֮��",1},{"Ԫ��", 5550000}},{{"�ֻ�֮��",1},{"���", 12888}}} 
local JianDingData = {
    {weizhi = 0, attrIndex = 1, looksIndex  = 34, attrValue  = 30000, clor  = 250},
    {weizhi = 1, attrIndex = 4, looksIndex  = 35, attrValue  = 1888, clor  = 250},
    {weizhi = 2, attrIndex = 174, looksIndex  = 36, attrValue  = 1, clor  = 250}
}

--��ȡ����״̬
function ZhongSuLunHui.getFlagstate(actor)
    local state1 = getflagstatus(actor,VarCfg["F_�����ֻ�1"])
    local state2 = getflagstatus(actor,VarCfg["F_�����ֻ�2"])
    local state3 = getflagstatus(actor,VarCfg["F_�����ֻ�3"])
    local flagTbl = {state1,state2,state3}
    return flagTbl
end
-- ����֮��	77	107


function ZhongSuLunHui.Request(actor,var)
    local itemobj = nil
    for i = 77, 99 do
        local itemnane = getiteminfo(actor, linkbodyitem(actor, i), 7)
        if itemnane == "�����ֻ���" then
            itemobj = linkbodyitem(actor, i)
        end
    end

    if not itemobj then
        Player.sendmsgEx(actor, "[��ʾ]:#251|�Բ���.��δ����|[�����ֻ���]#249|����ʧ��!")
        return
    end

    local flagTbl = ZhongSuLunHui.getFlagstate(actor) --��ȡ����״̬
    if flagTbl[var] == 1 then return end
    local name, num = Player.checkItemNumByTable(actor, cost[var])
    if name then
        Player.sendmsgEx(actor, string.format("��ʾ#251|:#255|���|%s#249|��������|%d#249|,����ʧ��...", name, num))
        return
    end
    Player.takeItemByTable(actor, cost[var], "�����ֻ�"..var.. "")
    local cfg = JianDingData[var]
    local weizhi = cfg.weizhi
    local attrIndex = cfg.attrIndex
    local looksIndex = cfg.looksIndex
    local attrValue = cfg.attrValue
    local clor = cfg.clor
    changecustomitemtext(actor, itemobj, "[�ֻ�����]", 0)
    changecustomitemtextcolor(actor, itemobj, 253, 0)
    changecustomitemabil(actor,itemobj,weizhi,0,clor,0)      --�Զ���������ɫ
    changecustomitemabil(actor,itemobj,weizhi,1,attrIndex,0) --��ʵ����
    changecustomitemabil(actor,itemobj,weizhi,2,looksIndex,0) --��ʾ����
    changecustomitemabil(actor,itemobj,weizhi,4,weizhi,0)   --��ʾλ��(0~9)
    changecustomitemvalue(actor,itemobj,weizhi,"=",attrValue,0)
    refreshitem(actor,itemobj)
    setflagstatus(actor,VarCfg["F_�����ֻ�".. var ..""], 1)


    if var == 3 then
        changelevel(actor,"+", 1)
    end

    --ˢ��ǰ��
    ZhongSuLunHui.SyncResponse(actor)
end

--���ﴩװ��----���ﴩ������װ������
local function _onTakeOnEx(actor, itemobj, where, itemname, makeid)
    if itemname == "�����ֻ���" then
        if getflagstatus(actor,VarCfg["F_�����ֻ�3"]) == 1 then
            changelevel(actor,"+", 1)
        end
    end
end
GameEvent.add(EventCfg.onTakeOnEx, _onTakeOnEx, ZhongSuLunHui)

--������װ��---������������װ������
local function _onTakeOffEx(actor, itemobj, where, itemname, makeid)
    if itemname == "�����ֻ���" then
        if getflagstatus(actor,VarCfg["F_�����ֻ�3"]) == 1 then
            changelevel(actor,"-", 1)
        end
    end
end
GameEvent.add(EventCfg.onTakeOffEx, _onTakeOffEx, ZhongSuLunHui)

--ע��������Ϣ
function ZhongSuLunHui.SyncResponse(actor, logindatas)
    local data = ZhongSuLunHui.getFlagstate(actor) --��ȡ����״̬
    local _login_data = { ssrNetMsgCfg.ZhongSuLunHui_SyncResponse, 0, 0, 0, data }
    if logindatas then
        table.insert(logindatas, _login_data)
    else
        Message.sendmsg(actor, ssrNetMsgCfg.ZhongSuLunHui_SyncResponse, 0, 0, 0, data)
    end
end
Message.RegisterNetMsg(ssrNetMsgCfg.ZhongSuLunHui, ZhongSuLunHui)

--��¼����
local function _onLoginEnd(actor, logindatas)
    ZhongSuLunHui.SyncResponse(actor, logindatas)
end
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, ZhongSuLunHui)

return ZhongSuLunHui
