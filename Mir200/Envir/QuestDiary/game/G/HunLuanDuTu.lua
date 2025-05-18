local HunLuanDuTu = {}
HunLuanDuTu.ID = "���Ҷ�ͽ"
local npcID = 832
local config = include("QuestDiary/cfgcsv/cfg_HunLuanDuTu.lua") --����
local cost = { { "Ԫ��", 300000 } }
local cooling = 43200

function delay_hun_luan_du_tu_result(actor, resultIndex)
    if getplaydef(actor, "N$���Ҷ�ͽ��ֹˢ") ~= 1 then
        return
    end
    resultIndex = tonumber(resultIndex)
    local cfg = config[resultIndex]
    local userid = Player.GetUUID(actor)
    if type(cfg.give) == "table" then
        local msgStr = getItemArrToStr(cfg.give)
        Player.sendmsgEx(actor, string.format("��ϲ����|%s#249|,�����ѷ��͵��ʼ�!", msgStr))
        local mailTitle = "���Ҷ�ͽ��ȡ����"
        local mailContent = string.format("��ϲ����%s", msgStr)
        Player.giveMailByTable(userid, 1, mailTitle, mailContent, cfg.give, 1, true)
    else
        Player.sendmsgEx(actor, "��Ǹ,��û�л�ȡ�κν���!#249")
        local mailTitle = "���Ҷ�ͽ��ȡ����"
        local mailContent = "��Ǹ,��û�л�ȡ�κν���!"
        sendmail(userid, 1, mailTitle, mailContent)
    end
    setplaydef(actor, "N$���Ҷ�ͽ��ֹˢ", 0)
end

--��������
function HunLuanDuTu.Request(actor)
    if getplaydef(actor, "N$���Ҷ�ͽ��ֹˢ") == 1 then
        Player.sendmsgEx(actor, "��ȴ���һ�γ�ȡ���!#249")
        return
    end
    local lastTime = getplaydef(actor, VarCfg["B_�ϴγ�ȡʱ��"])
    local currTime = os.time()
    local diff = currTime - lastTime
    if diff < cooling then
        local name, num = Player.checkItemNumByTable(actor, cost)
        if name then
            Player.sendmsgEx(actor, string.format("���|%s#249|����|%d#249", name, num))
            return
        end
        Player.takeItemByTable(actor, cost, "���Ҷ�ͽ")
    else
        setplaydef(actor, VarCfg["B_�ϴγ�ȡʱ��"], os.time())
        Player.sendmsgEx(actor, "��ǰ��ȡ���")
        HunLuanDuTu.Sync(actor)
    end
    local count = getplaydef(actor, VarCfg["B_��¼��ȡ����"])
    local startIndex = 1
    if count < 19 then
        startIndex = 2
    end
    local weights = {}
    for i = startIndex, #config do
        local tmp = { i, config[i].weight }
        table.insert(weights, table.concat(tmp, "#"))
    end
    local weightStr = table.concat(weights, "|")
    local result1 = ransjstr(weightStr, 1, 3)
    local resultIndex = tonumber(result1)
    if count == 29 then
        resultIndex = 1
    end
    setplaydef(actor, VarCfg["B_��¼��ȡ����"], count + 1)
    setplaydef(actor, "N$���Ҷ�ͽ��ֹˢ", 1)
    delaygoto(actor, 1200, "delay_hun_luan_du_tu_result,"..resultIndex)
    Message.sendmsg(actor, ssrNetMsgCfg.HunLuanDuTu_Response, resultIndex, 0, 0, {})
end

function HunLuanDuTu.Sync(actor)
    local lastTime = getplaydef(actor, VarCfg["B_�ϴγ�ȡʱ��"])
    local currTime = os.time()
    local diff = currTime - lastTime
    local flag = 0
    if diff >= cooling then
        flag = 1
    else
        flag = 0
    end
    diff = math.floor(cooling - diff)
    if diff < 0 then
        diff = 0
    end
    Message.sendmsg(actor, ssrNetMsgCfg.HunLuanDuTu_Sync, diff, flag, 0, {})
end

--ͬ����Ϣ
-- function HunLuanDuTu.SyncResponse(actor, logindatas)
--     local data = {}
--     local _login_data = {ssrNetMsgCfg.HunLuanDuTu_SyncResponse, 0, 0, 0, data}
--     if logindatas then
--         table.insert(logindatas, _login_data)
--     else
--         Message.sendmsg(actor, ssrNetMsgCfg.HunLuanDuTu_SyncResponse, 0, 0, 0, data)
--     end
-- end
-- --��¼����
-- local function _onLoginEnd(actor, logindatas)
--     HunLuanDuTu.SyncResponse(actor, logindatas)
-- end
-- --�¼��ɷ�
-- GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, HunLuanDuTu)
--ע��������Ϣ
Message.RegisterNetMsg(ssrNetMsgCfg.HunLuanDuTu, HunLuanDuTu)
return HunLuanDuTu
