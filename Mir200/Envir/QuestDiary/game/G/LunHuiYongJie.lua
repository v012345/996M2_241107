local LunHuiYongJie = {}
LunHuiYongJie.ID = "�ֻ�����"
local npcID = 805
local abilGroup = 0
--local config = include("QuestDiary/cfgcsv/cfg_LunHuiYongJie.lua") --����
local cost = { { "���籾Դ", 88 }, { "�컯�ᾧ", 88 }, { "Ԫ��", 4880000 } }
local function _getTianMingList(actor)
    local result = {}
    for i = 1, 24 do
        local Tvar = VarCfg["T_������¼_" .. i]
        if Tvar then
            local value = Player.getJsonTableByVar(actor, Tvar)
            table.insert(result, { Tvar, value })
        end
    end
    return result
end
local function _checkLaiQuZiRu(actor)
    local result = false
    local values = _getTianMingList(actor)
    for _, value in ipairs(values) do
        local datas = json2tbl(value[2])
        if datas[1] == 4 and datas[2] == 35 then
            result = true
            break
        end
    end
    return result
end
local function _getLaiQuZiRuVar(actor)
    local values = _getTianMingList(actor)
    for _, value in ipairs(values) do
        local datas = json2tbl(value[2])
        if datas[1] == 4 and datas[2] == 35 then
            return value[1]
        end
    end
    return nil
end
--��������
function LunHuiYongJie.Request(actor)
    local isInRange = FCheckNPCRange(actor, npcID, 15)
    if not isInRange then
        Player.sendmsgEx(actor, "����̫Զ#249")
        return
    end
    if getflagstatus(actor, VarCfg["F_�ֻ�����"]) == 1 then
        Player.sendmsgEx(actor, "���Ѿ����ɹ���!#249")
        return
    end
    local Tvar = _getLaiQuZiRuVar(actor)
    if not Tvar then
        Player.sendmsgEx(actor, "����ʧ��,��û��|ʥƷ����#243|��ȥ����#249")
        return
    end
    local itemobj = linkbodyitem(actor, 29)
    local equipName = getiteminfo(actor, itemobj, ConstCfg.iteminfo.name)
    if equipName ~= "������ʱ����ת" then
        Player.sendmsgEx(actor, "����ʧ��,��û�д���|������ʱ����ת#249")
        return
    end
    local name, num = Player.checkItemNumByTable(actor, cost)
    if name then
        Player.sendmsgEx(actor, string.format("����ʧ��,���|%s#249|����|%d#249", name, num))
        return
    end
    Player.takeItemByTable(actor, cost, "�ֻ�����")
    setplaydef(actor, Tvar, "")
    TianMing.clearCache(actor)
    TianMing.setCache(actor)
    changecustomitemtext(actor, itemobj, "[�ֻ�����]:", abilGroup)
    changecustomitemtextcolor(actor, itemobj, 252, abilGroup)
    Player.addModifyCustomAttributes(actor, itemobj, abilGroup, 1, 0, 0, 170, 91, 1, 1) --��������1
    setflagstatus(actor, VarCfg["F_������ȥ����"], 0)
    setflagstatus(actor, VarCfg["F_�ֻ�����"], 1)
    messagebox(actor, "��ϲ����[��������ս��״̬,��ʱ����ս��]ʥƷ����[��ȥ����]��ʧ!")
    LunHuiYongJie.SyncResponse(actor)
end

--ͬ����Ϣ
function LunHuiYongJie.SyncResponse(actor)
    local data = {}
    Message.sendmsg(actor, ssrNetMsgCfg.LunHuiYongJie_SyncResponse, 0, 0, 0, data)
end
-- --��¼����
-- local function _onLoginEnd(actor, logindatas)
--     LunHuiYongJie.SyncResponse(actor, logindatas)
-- end
-- --�¼��ɷ�
-- GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, LunHuiYongJie)
--ע��������Ϣ
Message.RegisterNetMsg(ssrNetMsgCfg.LunHuiYongJie, LunHuiYongJie)
return LunHuiYongJie
