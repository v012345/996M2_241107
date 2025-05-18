local ShengMingShenZhu = {}
ShengMingShenZhu.ID = "��������"
local npcID = 3473
--local config = include("QuestDiary/cfgcsv/cfg_ShengMingShenZhu.lua") --����
local cost = { {} }
local give = { {} }

local xianJiVar = {
    [3475] = VarCfg["G_���ս���׼�1"],
    [3476] = VarCfg["G_���ս���׼�2"],
    [2509] = VarCfg["U_���ս���׼�1"],
    [2510] = VarCfg["U_���ս���׼�2"],
}

local mapIDs = {
    ["�����³�һ��"] = "dixiachengyiceng",
    ["�����³Ƕ���"] = "dixiachengerceng",
    ["�����³�����"] = "dixiachengsanceng",
    ["�����³�(��)"] = "dixiachengdiceng",
}

local function GETgetsysvarOrgetplaydef(actor, var)
    if string.find(var, "G") then
        return getsysvar(var)
    elseif string.find(var, "U") then
        return getplaydef(actor, var)
    else
        return 0
    end
end

local function SETsetsysvarOrsetplaydef(actor, var, value)
    if string.find(var, "G") then
        return setsysvar(var, value)
    elseif string.find(var, "U") then
        return setplaydef(actor, var, value)
    else
        return 0
    end
end
--��������
function ShengMingShenZhu.Request(actor, npcid)
    local currHp = getbaseinfo(actor, ConstCfg.gbase.curhp)
    if currHp < 300000 then
        Player.sendmsgEx(actor, "���Ѫ��С��30W,�޷��׼�!#249")
        return
    end
    local cfg = xianJiVar[npcid]
    if not cfg then
        Player.sendmsgEx(actor, "��������!")
        return
    end

    local currXj = GETgetsysvarOrgetplaydef(actor, cfg)
    if currXj >= 3000000 then
        Player.sendmsgEx(actor, "�׼�ʧ��,��ǰ�׼�Ѫ���ѳ���3000��!#249")
        return
    end
    SETsetsysvarOrsetplaydef(actor, cfg, currXj + 300000)
    humanhp(actor, "-", 300000, 1)
    Player.sendmsgEx(actor, "�׼��ɹ�,�۳�30WѪ��!")
    local var1 = ""
    local var2 = ""
    if getflagstatus(actor, VarCfg["F_�����³ǽ��빫��or˽��"]) == 0 then
        var1 = VarCfg["G_���ս���׼�1"]
        var2 = VarCfg["G_���ս���׼�2"]
    else
        var1 = VarCfg["U_���ս���׼�1"]
        var2 = VarCfg["U_���ս���׼�2"]
    end

    local currxj1 = GETgetsysvarOrgetplaydef(actor, var1)
    local currxj2 = GETgetsysvarOrgetplaydef(actor, var2)

    local totalHP = currxj1 + currxj2
    if totalHP >= 6000000 then
        if getflagstatus(actor, VarCfg["F_�����³ǽ��빫��or˽��"]) == 0 then
            FsendHuoDongGongGao("���ս���׼�����ɣ��ڵ�ͼ�м�(153.170)�ٻ���[��硤ͼ���Ȳ�]")
            genmon("dixiachengerceng", 153, 170, "��硤ͼ���Ȳ�", 1, 1, 251)
        else
            local name = getbaseinfo(actor, ConstCfg.gbase.name)
            local newMapId = name .. mapIDs["�����³�һ��"]
            local remainingTime = mirrormaptime(newMapId, 0)
            senddelaymsg(actor, "���ս���׼�����ɣ��ڵ�ͼ�м�(153.170)�ٻ���[��硤ͼ���Ȳ�],����ʣ��ʱ��:%s", remainingTime or 0, 250, 1)
            genmon(name .. "dixiachengerceng", 153, 170, "��硤ͼ���Ȳ�[���˼�BOSS]", 1, 1, 251)
        end
    end
    if getflagstatus(actor, VarCfg["F_�����³ǽ��빫��or˽��"]) == 0 then
        local players = getplaycount("dixiachengerceng", 1, 1)
        for index, player in ipairs(type(players) == "table" and players or {}) do
            ShengMingShenZhu.SyncResponse(player)
        end
    else
        ShengMingShenZhu.SyncResponse(actor)
    end
end

--ͬ����Ϣ
function ShengMingShenZhu.SyncResponse(actor)
    if getflagstatus(actor, VarCfg["F_�����³ǽ��빫��or˽��"]) == 0 then
        local var1 = VarCfg["G_���ս���׼�1"]
        local var2 = VarCfg["G_���ս���׼�2"]
        local currxj1 = GETgetsysvarOrgetplaydef(actor, var1)
        local currxj2 = GETgetsysvarOrgetplaydef(actor, var2)
        local data = {
            ["3475"] = currxj1,
            ["3476"] = currxj2
        }
        Message.sendmsg(actor, ssrNetMsgCfg.ShengMingShenZhu_SyncResponse, 0, 0, 0, data)
    else
        local var1 = VarCfg["U_���ս���׼�1"]
        local var2 = VarCfg["U_���ս���׼�2"]
        local currxj1 = GETgetsysvarOrgetplaydef(actor, var1)
        local currxj2 = GETgetsysvarOrgetplaydef(actor, var2)
        local data = {
            ["2509"] = currxj1,
            ["2510"] = currxj2
        }
        Message.sendmsg(actor, ssrNetMsgCfg.ShengMingShenZhu_SyncResponse, 0, 0, 0, data)
    end
end

-- --��¼����
-- local function _onLoginEnd(actor, logindatas)
--     ShengMingShenZhu.SyncResponse(actor, logindatas)
-- end
-- --�¼��ɷ�
-- GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, ShengMingShenZhu)
function ge_ren_di_xia_cheng_jin_ru_er_ceng(actor, time)
    local remainingTime = tonumber(time) or 0
    senddelaymsg(actor, "ǰ��(77,47),(261,249)�׼�����,�ٻ�[��硤ͼ���Ȳ�],����ʣ��ʱ��:%s", remainingTime, 250, 1)
end

function ge_ren_di_xia_cheng_jin_ru_san_ceng(actor, time)
    local remainingTime = tonumber(time) or 0
    senddelaymsg(actor, "ǰ��(147,155)���������Գ�,����ʣ��ʱ��:%s", remainingTime, 250, 1)
end

function ge_ren_di_xia_cheng_jin_ru_zhong(actor, time)
    local remainingTime = tonumber(time) or 0
    senddelaymsg(actor, "ǰ��(147,155)��ɱ����BOSS[��硤������˹],����ʣ��ʱ��:%s", remainingTime, 250, 1)
end

--�ȵ㴥��
local function _onBeforerOute(actor, mapid, x, y)
    local name = Player.GetName(actor)
    local mapID = name .. mapIDs["�����³Ƕ���"]
    local mapID3 = name .. mapIDs["�����³�����"]
    local mapID4 = name .. mapIDs["�����³�(��)"]
    if mapid == mapID then
        local newMapId = name .. mapIDs["�����³�һ��"]
        local remainingTime = tonumber(mirrormaptime(newMapId, 0)) or 0
        delaygoto(actor, 500, "ge_ren_di_xia_cheng_jin_ru_er_ceng," .. remainingTime)
        local npcObj1 = getnpcbyindex(2509)
        local npcObj2 = getnpcbyindex(2510)
        if npcObj1 == nil or npcObj2 == nil then
            delaygoto(actor, 500, "yan_chi_chuang_jian_npc,"..mapID)
        end
    elseif mapid == mapID3 then
        local newMapId = name .. mapIDs["�����³�һ��"]
        local remainingTime = tonumber(mirrormaptime(newMapId, 0)) or 0
        delaygoto(actor, 500, "ge_ren_di_xia_cheng_jin_ru_san_ceng," .. remainingTime)
    elseif mapid == mapID4 then
        local newMapId = name .. mapIDs["�����³�(��)"]
        local remainingTime = tonumber(mirrormaptime(newMapId, 0)) or 0
        delaygoto(actor, 500, "ge_ren_di_xia_cheng_jin_ru_zhong," .. remainingTime)
    end
end
GameEvent.add(EventCfg.onBeforerOute, _onBeforerOute, ShengMingShenZhu)
--ע��������Ϣ
Message.RegisterNetMsg(ssrNetMsgCfg.ShengMingShenZhu, ShengMingShenZhu)
return ShengMingShenZhu
