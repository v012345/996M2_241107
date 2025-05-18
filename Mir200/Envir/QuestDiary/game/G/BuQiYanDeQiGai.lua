local BuQiYanDeQiGai = {}
BuQiYanDeQiGai.ID = "�����۵���ؤ"
local npcID = 831
--local config = include("QuestDiary/cfgcsv/cfg_BuQiYanDeQiGai.lua") --����
local cost = { {} }
local give = { { "ҥ��ӡ��", 1 } }
local targetNum = 1000000000
--��������
function BuQiYanDeQiGai.Request(actor, goldNum)
    if type(goldNum) ~= "number" then
        Player.sendmsgEx(actor, "��������!#249")
        return
    end
    if goldNum <= 0 then
        Player.sendmsgEx(actor, "������������ȷ!#249")
        return
    end
    local cost = { { "���", goldNum } }
    local name, num = Player.checkItemNumByTable(actor, cost)
    if name then
        Player.sendmsgEx(actor, string.format("���|%s#249|����|%d#249", name, num))
        return
    end
    Player.takeItemByTable(actor, cost, BuQiYanDeQiGai.ID)
    local currNum = getplaydef(actor, VarCfg["B_�����۵���ؤ�������"])
    setplaydef(actor, VarCfg["B_�����۵���ؤ�������"], currNum + goldNum)
    BuQiYanDeQiGai.SyncResponse(actor)
end

function BuQiYanDeQiGai.LingQu(actor)
    local currNum = getplaydef(actor, VarCfg["B_�����۵���ؤ�������"])
    if currNum < targetNum then
        Player.sendmsgEx(actor, "��������!#249")
        return
    end
    if not Bag.checkBagEmptyNum(actor, 5) then
        Player.sendmsgEx(actor, "��ı������Ӳ���,��������5���ո�!#249")
        return
    end
    Player.giveItemByTable(actor, give, "ҥ��ӡ��", 1, true)
    setflagstatus(actor, VarCfg["F_�����۵���ؤ�Ƿ���ȡ"], 1)
    Player.sendmsgEx(actor, "��ϲ����|ҥ��ӡ��#249")
    setplaydef(actor, VarCfg["B_�����۵���ؤ�������"], 0)
    BuQiYanDeQiGai.SyncResponse(actor)
end

-- VarCfg["B_�����۵���ؤ�������"]
-- VarCfg["F_�����۵���ؤ�Ƿ���ȡ"]
--ͬ����Ϣ
function BuQiYanDeQiGai.SyncResponse(actor, logindatas)
    local data = {}
    local currNum = getplaydef(actor, VarCfg["B_�����۵���ؤ�������"])
    -- local flag = getflagstatus(actor, VarCfg["F_�����۵���ؤ�Ƿ���ȡ"])
    local _login_data = { ssrNetMsgCfg.BuQiYanDeQiGai_SyncResponse, currNum, 0, 0, data }
    if logindatas then
        table.insert(logindatas, _login_data)
    else
        Message.sendmsg(actor, ssrNetMsgCfg.BuQiYanDeQiGai_SyncResponse, currNum, 0, 0, data)
    end
end

--��¼����
local function _onLoginEnd(actor, logindatas)
    BuQiYanDeQiGai.SyncResponse(actor, logindatas)
end
--�¼��ɷ�
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, BuQiYanDeQiGai)
--ע��������Ϣ
Message.RegisterNetMsg(ssrNetMsgCfg.BuQiYanDeQiGai, BuQiYanDeQiGai)
return BuQiYanDeQiGai
