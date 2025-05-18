local LeiMingZhiLi = {}
LeiMingZhiLi.ID = "����֮��"
local npcID = 323
local abilGroup = 0
--local config = include("QuestDiary/cfgcsv/cfg_LeiMingZhiLi.lua") --����
local config = {
    "����֮��",
    "����",
    "���������֮��",
    "���ƿ��׵硹"
}
local flags = {
    VarCfg["F_����_����֮��_1"],
    VarCfg["F_����_����֮��_2"],
    VarCfg["F_����_����֮��_4"],
    VarCfg["F_����_����֮��_3"],
}
local attrIds = {
    { 4,   66 },
    { 1,   1222 },
    { 206, 4 },
    { 207, 4 },
}
--��������
function LeiMingZhiLi.Request(actor, arg1)
    local cfg = config[arg1]
    if not FCheckNPCRange(actor, npcID, 15) then
        Player.sendmsgEx(actor, "����PNC̫Զ!#249")
        return
    end
    local itemobj = linkbodyitem(actor, 43)
    if itemobj == "0" then
        Player.sendmsgEx(actor, "�ύʧ��,��û�д������ɷ���!")
        return
    end
    local flag = getflagstatus(actor, flags[arg1])
    if flag == 1 then
        Player.sendmsgEx(actor, string.format("%s#249|�Ѿ��ύ����!", cfg))
        return
    end
    local cost = { { cfg, 1 } }
    -- dump(cost)
    local name, num = Player.checkItemNumByTable(actor, cost)
    -- release_print(tostring(name))
    if name then
        Player.sendmsgEx(actor, string.format("�ύʧ��,�㱳����û��|%s#249", name))
        return
    end
    Player.takeItemByTable(actor, cost)
    setflagstatus(actor, flags[arg1], 1)
    local attr = attrIds[arg1]
    changecustomitemtext(actor, itemobj, "<IMG:res/tips/5.png>", abilGroup)
    local isPer = 0
    if arg1 == 3 or arg1 == 4 then
        isPer = 1
    end
    Player.addModifyCustomAttributes(actor, itemobj, abilGroup, arg1, 1, 250, attr[1], 0, isPer, attr[2])
    Player.sendmsgEx(actor, "�ύ�ɹ�")
    setflagstatus(actor, VarCfg["F_����֮��_���ύһ��"], 1)
    FSetTaskRedPoint(actor, VarCfg["F_����֮���ύһ��"], 20)
    LeiMingZhiLi.SyncResponse(actor)
end

--��װ��
local function _onTakeOn43(actor, itemobj)
    for index, value in ipairs(flags) do
        if getflagstatus(actor,value) == 1 then
            changecustomitemtext(actor, itemobj, "<IMG:res/tips/5.png>", abilGroup)
            local attr = attrIds[index]
            local isPer = 0
            if index == 3 or index == 4 then
                isPer = 1
            end
            Player.addModifyCustomAttributes(actor, itemobj, abilGroup, index, 1, 250, attr[1], 0, isPer, attr[2])
        end
    end
end
GameEvent.add(EventCfg.onTakeOn43, _onTakeOn43, LeiMingZhiLi)
--ͬ����Ϣ
function LeiMingZhiLi.SyncResponse(actor, logindatas)
    local data = {}
    for index, value in ipairs(flags) do
        table.insert(data, getflagstatus(actor, value))
    end
    local _login_data = {ssrNetMsgCfg.LeiMingZhiLi_SyncResponse, 0, 0, 0, data}
    if logindatas then
        table.insert(logindatas, _login_data)
    else
        Message.sendmsg(actor, ssrNetMsgCfg.LeiMingZhiLi_SyncResponse, 0, 0, 0, data)
    end
end
--��¼����
local function _onLoginEnd(actor, logindatas)
    LeiMingZhiLi.SyncResponse(actor, logindatas)
end
--�¼��ɷ�
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, LeiMingZhiLi)
--ע��������Ϣ
Message.RegisterNetMsg(ssrNetMsgCfg.LeiMingZhiLi, LeiMingZhiLi)
return LeiMingZhiLi
