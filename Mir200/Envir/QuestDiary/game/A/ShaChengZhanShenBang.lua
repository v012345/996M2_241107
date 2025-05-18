local ShaChengZhanShenBang = {}
ShaChengZhanShenBang.ID = "ɳ��ս���"
local npcID = 0
--local config = include("QuestDiary/cfgcsv/cfg_ShaChengZhanShenBang.lua") --����
local cost = { {} }
local gives = {
    { "������", 1 },
    { "��ʯ����", 1 },
    { "�ƽ���", 1 },
    { "��������", 1 },
    { "��������", 1 },
    { "��������", 1 } }
--�ж����Ƿ������а��� ���ҷ�������
local function checkMyRank(actor, ranks)
    if not ranks then
        return
    end
    if #ranks == 0 then
        return
    end
    local myName = getbaseinfo(actor, ConstCfg.gbase.name)
    for i, v in ipairs(ranks) do
        if v.name == myName then
            return i
        end
    end
end
--��������
function ShaChengZhanShenBang.Request(actor)
    local lingQuList = Player.getJsonTableByVar(nil, VarCfg["A_���а���ȡ��¼"])
    local userId = getbaseinfo(actor, ConstCfg.gbase.id)
    if table.contains(lingQuList, userId) then
        Player.sendmsgEx(actor, string.format("���Ѿ���ȡ����!#249"))
        return
    end
    local isTime = isTimeInRange(22, 04, 23, 00)
    if not isTime then
        Player.sendmsgEx(actor, string.format("����|22:05-23:00#249|��ȡ����!"))
        return
    end
    local Tdata = Player.getJsonTableByVar(nil, VarCfg["A_�л���ּ�¼"])
    local gongshaRank = {}
    for i, v in pairs(Tdata) do
        for key, value in pairs(v) do
            table.insert(gongshaRank,
                {
                    name = key,
                    point = value
                }
            )
        end
    end
    --����
    table.sort(gongshaRank, function(a, b)
        return a.point > b.point
    end)
    --ֻȡǰ����
    if #gongshaRank > 6 then
        for i = #gongshaRank, 7, -1 do
            table.remove(gongshaRank, i)
        end
    end
    --��ȡ�ҵ�����
    local myRank = checkMyRank(actor, gongshaRank)
    if not myRank then
        Player.sendmsgEx(actor, string.format("��û�������а�!#249"))
        return
    end
    local give = gives[myRank]
    if not give then
        Player.sendmsgEx(actor, string.format("��ȡ����ʧ��!#249"))
        return
    end
    Player.sendmsgEx(actor, string.format("��ɹ���ȡ�˵�%d������,�뵽�ʼ�����!#249", myRank))
    Player.giveMailByTable(userId, 1, "ɳ��ս���", string.format("ɳ��ս����%d������", myRank), { give }, 1, true)
    table.insert(lingQuList, userId)
    Player.setJsonVarByTable(nil, VarCfg["A_���а���ȡ��¼"], lingQuList)
end

--ͬ����Ϣ
-- function ShaChengZhanShenBang.SyncResponse(actor, logindatas)
--     local data = {}
--     local _login_data = {ssrNetMsgCfg.ShaChengZhanShenBang_SyncResponse, 0, 0, 0, data}
--     if logindatas then
--         table.insert(logindatas, _login_data)
--     else
--         Message.sendmsg(actor, ssrNetMsgCfg.ShaChengZhanShenBang_SyncResponse, 0, 0, 0, data)
--     end
-- end
-- --��¼����
-- local function _onLoginEnd(actor, logindatas)
--     ShaChengZhanShenBang.SyncResponse(actor, logindatas)
-- end
-- --�¼��ɷ�
-- GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, ShaChengZhanShenBang)
--ע��������Ϣ
Message.RegisterNetMsg(ssrNetMsgCfg.ShaChengZhanShenBang, ShaChengZhanShenBang)
return ShaChengZhanShenBang
