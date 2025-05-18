local YongHengHuiJi = {}
YongHengHuiJi.ID = "����ռ�"
local npcID = 332
local config = include("QuestDiary/cfgcsv/cfg_YongHengHuiJi.lua") --����
--�жϳƺ��Ƿ������ȡ
local function isClaimable(actor)
    local result = true
    for index, value in ipairs(config) do
        local num = getplaydef(actor, value.var)
        if num < 3 then
            result = false
            break
        end
    end
    return result
end
--��������
function YongHengHuiJi.Request1(actor, index)
    local cfg = config[index]
    if not cfg then
        Player.sendmsgEx(actor, "��������!#249")
        return
    end
    if checktitle(actor,"׷������֮·") then
        Player.sendmsgEx(actor, "���ֻ���ύ����#249")
        return
    end
    local count = getplaydef(actor, cfg.var)
    if count >= 3 then
        Player.sendmsgEx(actor, "���ֻ���ύ����!#249")
        return
    end
    local cost = cfg.cost
    local name, num = Player.checkItemNumByTable(actor, cost)
    if name then
        Player.sendmsgEx(actor, string.format("�ύʧ��,���|%s#249|����|%d#249", name, num))
        return
    end
    Player.takeItemByTable(actor, cost, "����ռ�")
    setplaydef(actor, cfg.var, count + 1)
    Player.sendmsgEx(actor, string.format("�ɹ��ύ[%s]#249", cfg.cost[1][1]))
    Player.setAttList(actor, "���Ը���")
    YongHengHuiJi.SyncResponse(actor)

end

function YongHengHuiJi.Request2(actor)
    local boolean = isClaimable(actor)
    if not boolean then
        Player.sendmsgEx(actor, "ÿ���ռ��ύ3��,�ſ�����ȡ�ƺ�#249")
        return
    end
    if checktitle(actor,"׷������֮·") then
        Player.sendmsgEx(actor, "���Ѿ�ӵ���˸ĳƺ�#249")
        return
    end
    confertitle(actor, "׷������֮·")
    Player.sendmsgEx(actor, "��ϲ���óƺ�|׷������֮·#249")
    YongHengHuiJi.SyncResponse(actor)
    Player.setAttList(actor, "���Ը���")
    Player.setAttList(actor, "���ʸ���")
end

--ͬ����Ϣ
function YongHengHuiJi.SyncResponse(actor, logindatas)
    local data = {}
    for index, value in ipairs(config) do
        table.insert(data, getplaydef(actor, value.var))
    end
    local _login_data = { ssrNetMsgCfg.YongHengHuiJi_SyncResponse, 0, 0, 0, data }
    if logindatas then
        table.insert(logindatas, _login_data)
    else
        Message.sendmsg(actor, ssrNetMsgCfg.YongHengHuiJi_SyncResponse, 0, 0, 0, data)
    end
end

--��¼����
local function _onLoginEnd(actor, logindatas)
    YongHengHuiJi.SyncResponse(actor, logindatas)
end
--�¼��ɷ�
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, YongHengHuiJi)

--���Ը���
local function _onCalcAttr(actor, attrs)
    if checktitle(actor,"׷������֮·") then
        return
    end
    local shuxing = {
    }
    for index, value in ipairs(config) do
        local num = getplaydef(actor, value.var)
        if num > 0 then
            for i, v in ipairs(value.attrs) do
                shuxing[v[1]] = v[2] * num
            end
        end
    end
    calcAtts(attrs, shuxing, "����ռ�")
end
GameEvent.add(EventCfg.onCalcAttr, _onCalcAttr, YongHengHuiJi)

--ע��������Ϣ
Message.RegisterNetMsg(ssrNetMsgCfg.YongHengHuiJi, YongHengHuiJi)
return YongHengHuiJi
