local HongHuangZhiLi = {}
HongHuangZhiLi.ID = "���֮��"
local npcID = 511
local config = include("QuestDiary/cfgcsv/cfg_HongHuangZhiLi.lua") --����
local cost = {{}}
local give = {{}}
--��������
function HongHuangZhiLi.Request1(actor, index)
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
    Player.takeItemByTable(actor, cost, "���֮��")
    Player.sendmsgEx(actor,"�ύ�ɹ�!")
    setflagstatus(actor,cfg.flag,1)
    Player.setAttList(actor,"���Ը���")
    HongHuangZhiLi.SyncResponse(actor)
end
function HongHuangZhiLi.Request2(actor)
    if checktitle(actor,"���֮��") then
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
        confertitle(actor,"���֮��")
        GameEvent.push(EventCfg.onGetTaskTitle, actor, "���֮��") --���񴥷�
        Player.sendmsgEx(actor,"��ϲ���óƺ�:|���֮��#249")
        Player.setAttList(actor,"���Ը���")
    else
        Player.sendmsgEx(actor,"��û���ύȫ��!#249")
    end
    HongHuangZhiLi.SyncResponse(actor)
end
--ͬ����Ϣ
function HongHuangZhiLi.SyncResponse(actor, logindatas)
    local data = {}
    for index, value in ipairs(config) do
        data[index] = getflagstatus(actor, value.flag)
    end
    local _login_data = {ssrNetMsgCfg.HongHuangZhiLi_SyncResponse, 0, 0, 0, data}
    if logindatas then
        table.insert(logindatas, _login_data)
    else
        Message.sendmsg(actor, ssrNetMsgCfg.HongHuangZhiLi_SyncResponse, 0, 0, 0, data)
    end
end
--��¼����
local function _onLoginEnd(actor, logindatas)
    HongHuangZhiLi.SyncResponse(actor, logindatas)
end
--�¼��ɷ�
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, HongHuangZhiLi)


local function _onCalcAttr(actor, attrs)
    local shuxing = {}
    for index, value in ipairs(config) do
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
    calcAtts(attrs, shuxing, "���֮��")
end
--����
GameEvent.add(EventCfg.onCalcAttr, _onCalcAttr, HongHuangZhiLi)

--ע��������Ϣ
Message.RegisterNetMsg(ssrNetMsgCfg.HongHuangZhiLi, HongHuangZhiLi)
return HongHuangZhiLi