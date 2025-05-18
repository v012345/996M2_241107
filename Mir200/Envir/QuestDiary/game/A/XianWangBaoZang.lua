local XianWangBaoZang = {}
XianWangBaoZang.ID = "��������"
local npcID = 443
local mapID = "xianwang"
--local config = include("QuestDiary/cfgcsv/cfg_XianWangBaoZang.lua") --����
local config = {
    { monName = "����֮�ػ��ߡ��ס�", num = 1, x = 58, y = 53, range = 1, color = 251 },
    { monName = "����֮�ػ��ߡ����", num = 1, x = 166, y = 53, range = 1, color = 251 },
    { monName = "����֮�ػ��ߡ����", num = 1, x = 166, y = 136, range = 1, color = 251 },
    { monName = "����֮�ػ��ߡ����", num = 1, x = 56, y = 137, range = 1, color = 251 },
    { monName = "����ū��", num = 70, x = 109, y = 97, range = 100, color = 227 },
    { monName = "�����̴�", num = 70, x = 109, y = 97, range = 100, color = 227 },
    { monName = "������Ů", num = 70, x = 109, y = 97, range = 100, color = 227 },
    { monName = "������ʿ", num = 70, x = 109, y = 97, range = 100, color = 227 },
}


local cost = { {} }
local give = { {} }
--��������
function XianWangBaoZang.Request(actor)
    FMapEx(actor,mapID)
    --local name, num = Player.checkItemNumByTable(actor, cost)
    --if name then
    --Player.sendmsgEx(actor, string.format("���|%s#249|����|%d#249", name, num))
    --return
    --end
end

function XianWangBaoZang.EnterMap(actor)
    FMapEx(actor,mapID)
end

--ͬ����Ϣ
-- function XianWangBaoZang.SyncResponse(actor, logindatas)
--     local data = {}
--     local _login_data = {ssrNetMsgCfg.XianWangBaoZang_SyncResponse, 0, 0, 0, data}
--     if logindatas then
--         table.insert(logindatas, _login_data)
--     else
--         Message.sendmsg(actor, ssrNetMsgCfg.XianWangBaoZang_SyncResponse, 0, 0, 0, data)
--     end
-- end
-- --��¼����
-- local function _onLoginEnd(actor, logindatas)
--     XianWangBaoZang.SyncResponse(actor, logindatas)
-- end
-- --�¼��ɷ�
-- GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, XianWangBaoZang)
--���ʼ
local function _onXianWangBaoZangStart()
    FsendHuoDongGongGao("�������ػ�ѿ������ɴӻ����������")
    setsysvar(VarCfg["G_��������ɱ��"], 0)
    for _, value in ipairs(config) do
        genmon(mapID, value.x, value.y, value.monName, value.range, value.num, value.color)
    end
end
GameEvent.add(EventCfg.onXianWangBaoZangStart, _onXianWangBaoZangStart, XianWangBaoZang)

local function _onKillMon(actor, monobj, monName)
    if FCheckMap(actor, mapID) then
        if string.find(monName,"��֮�ػ���") then
            local num = getsysvar(VarCfg["G_��������ɱ��"])
            setsysvar(VarCfg["G_��������ɱ��"], num + 1)
            if (num + 1) >= 4 then
                FsendHuoDongGongGao("���������ڵ�[��֮�ػ���]��ȫ����ɱ���ڵ�ͼ�м��ٻ���[����������֮�����ɵۡ�����]")
                setsysvar(VarCfg["G_��������ɱ��"], 0)
                genmon(mapID, 109, 97, "����������֮�����ɵۡ�����", 1, 1, 251)
            end
        end
    end
end
GameEvent.add(EventCfg.onKillMon, _onKillMon, XianWangBaoZang)

--ע��������Ϣ
Message.RegisterNetMsg(ssrNetMsgCfg.XianWangBaoZang, XianWangBaoZang)
return XianWangBaoZang
