local FengXingZhe = {}
FengXingZhe.ID = "������"
local npcID = 507
local config = include("QuestDiary/cfgcsv/cfg_FengXingZhe.lua") --����
--��������
function FengXingZhe.Request1(actor,index)
    if not FCheckNPCRange(actor, npcID, 15) then
        Player.sendmsgEx(actor, "����PNC̫Զ!#249")
        return
    end
    local cfg = config[index]
    if not cfg then
        Player.sendmsgEx(actor,"��������!#249")
        return
    end
    if getflagstatus(actor,cfg.flag) == 1 then
        Player.sendmsgEx(actor,"���Ѿ��ύ����!#249")
        return
    end
    local cost = cfg.cost
    local name, num = Player.checkItemNumByTable(actor, cost)
    if name then
        Player.sendmsgEx(actor, string.format("���|%s#249|����|%d#249", name, num))
        return
    end
    Player.takeItemByTable(actor, cost, "������")
    Player.sendmsgEx(actor,"�ύ�ɹ�!")
    setflagstatus(actor,cfg.flag,1)
    Player.setAttList(actor,"���Ը���")
    FengXingZhe.SyncResponse(actor)
end
--��������
function FengXingZhe.Request2(actor)
    if checktitle(actor,"������") then
        Player.sendmsgEx(actor,"���Ѿ�ӵ���˸ĳƺ�!#249")
        return
    end
    local result = true
    for index, value in ipairs(config) do
        if getflagstatus(actor, value.flag) == 0 then
            result = false
            break
        end
    end
    if result then
        confertitle(actor,"������")
        GameEvent.push(EventCfg.onGetTaskTitle, actor, "������") --���񴥷�
        --������buff
        addbuff(actor,31033)
        Player.sendmsgEx(actor,"��ϲ���óƺ�:|������#249")
        --��װ��
        ZhuangBan.AddFashionToVar(actor, 12200, VarCfg["T_�㼣��¼"])
        ZhuangBan.SetCurrFashion(actor, 12200)
        Player.setAttList(actor,"���Ը���")
    else
        Player.sendmsgEx(actor,"��û���ύȫ��!#249")
    end
    FengXingZhe.SyncResponse(actor)
end
--ͬ����Ϣ
function FengXingZhe.SyncResponse(actor, logindatas)
    local data = {}
    for index, value in ipairs(config) do
        data[index] = getflagstatus(actor, value.flag)
    end
    local _login_data = {ssrNetMsgCfg.FengXingZhe_SyncResponse, 0, 0, 0, data}
    if logindatas then
        table.insert(logindatas, _login_data)
    else
        Message.sendmsg(actor, ssrNetMsgCfg.FengXingZhe_SyncResponse, 0, 0, 0, data)
    end
end
--��¼����
local function _onLoginEnd(actor, logindatas)
    FengXingZhe.SyncResponse(actor, logindatas)
end
--�¼��ɷ�
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, FengXingZhe)

local function _onCalcAttr(actor, attrs)
    local shuxing = {}
    for _, value in ipairs(config) do
        if getflagstatus(actor, value.flag) == 1 then
            for _, v in ipairs(value.attrs or {}) do
                if shuxing[v[1]] then
                    shuxing[v[1]] = shuxing[v[1]] + v[2]
                else
                    shuxing[v[1]] = v[2]
                end
            end
        end
    end
    calcAtts(attrs, shuxing, "������")
end
--����
GameEvent.add(EventCfg.onCalcAttr, _onCalcAttr, FengXingZhe)

--ע��������Ϣ
Message.RegisterNetMsg(ssrNetMsgCfg.FengXingZhe, FengXingZhe)
return FengXingZhe