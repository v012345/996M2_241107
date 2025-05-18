local WangLingZhiShu = {}
WangLingZhiShu.ID = "����֮��"
local npcID = 454
local config = include("QuestDiary/cfgcsv/cfg_WangLingZhiShu.lua") --����
--��������
function WangLingZhiShu.Request1(actor, index)
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
    Player.takeItemByTable(actor, cost, "����֮��")
    Player.sendmsgEx(actor,"�ύ�ɹ�!")
    setflagstatus(actor,cfg.flag,1)
    Player.setAttList(actor,"���Ը���")
    WangLingZhiShu.SyncResponse(actor)
end
--��������
function WangLingZhiShu.Request2(actor)
    if checktitle(actor,"��С��ѧϰ") then
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
        confertitle(actor,"��С��ѧϰ")
        Player.sendmsgEx(actor,"��ϲ���óƺ�:|��С��ѧϰ#249")
    else
        Player.sendmsgEx(actor,"��û���ύȫ��!#249")
    end
end
--ͬ����Ϣ
function WangLingZhiShu.SyncResponse(actor, logindatas)
    local data = {}
    for index, value in ipairs(config) do
        data[index] = getflagstatus(actor, value.flag)
    end
    local _login_data = {ssrNetMsgCfg.WangLingZhiShu_SyncResponse, 0, 0, 0, data}
    if logindatas then
        table.insert(logindatas, _login_data)
    else
        Message.sendmsg(actor, ssrNetMsgCfg.WangLingZhiShu_SyncResponse, 0, 0, 0, data)
    end
end
--��¼����
local function _onLoginEnd(actor, logindatas)
    WangLingZhiShu.SyncResponse(actor, logindatas)
end
--�¼��ɷ�
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, WangLingZhiShu)


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
    calcAtts(attrs, shuxing, "����֮��")
end
--����
GameEvent.add(EventCfg.onCalcAttr, _onCalcAttr, WangLingZhiShu)

local function _onAttackDamagePlayer(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    if checktitle(actor,"��С��ѧϰ") then
        if not checktitle(actor,"��С��ѧϰ") then
            attackDamageData.damage = attackDamageData.damage + math.ceil(Damage * 0.5)
        end
    end
end
GameEvent.add(EventCfg.onAttackDamagePlayer, _onAttackDamagePlayer, WangLingZhiShu)

--ע��������Ϣ
Message.RegisterNetMsg(ssrNetMsgCfg.WangLingZhiShu, WangLingZhiShu)
return WangLingZhiShu