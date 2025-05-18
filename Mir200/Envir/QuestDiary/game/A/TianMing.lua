TianMing = {}
TianMing.ID = "����"
local TianMingList = {
    [1] = include("QuestDiary/cfgcsv/cfg_TianMing_Fan.lua"),   --������
    [2] = include("QuestDiary/cfgcsv/cfg_TianMing_Ling.lua"),  --������
    [3] = include("QuestDiary/cfgcsv/cfg_TianMing_Xian.lua"),  --������
    [4] = include("QuestDiary/cfgcsv/cfg_TianMing_Sheng.lua"), --������
    [5] = include("QuestDiary/cfgcsv/cfg_TianMing_Di.lua"),    --������
}
--[[
�� - 40%
�� - 30%
�� - 15%
�� - 10%
�� - 5%
]]
local weight = "1#40|2#30|3#15|4#10|5#5" --Ȩ��

--ö����������
local CostType = {
    [1] = { { "���˾���", 1 } }, --1
    [2] = { { "ת�˽�", 1 } }, --2
    [3] = { { "���", 200 } }, -- 3
}

--ö��Ʒ������
local enumeQualityName = {
    [1] = "��Ʒ",
    [2] = "��Ʒ",
    [3] = "��Ʒ",
    [4] = "ʥƷ",
    [5] = "��Ʒ",
}

--ö����������ͼ������
local enumeTianMingVar = {
    [1] = VarCfg.T_TianMing_Fan,
    [2] = VarCfg.T_TianMing_Ling,
    [3] = VarCfg.T_TianMing_Xian,
    [4] = VarCfg.T_TianMing_Sheng,
    [5] = VarCfg.T_TianMing_Di,
}

--ö�ټ���ͼ�������ʾ������ɫ
local enumeTianMingColor = {
    [1] = "7",
    [2] = "168",
    [3] = "241",
    [4] = "58",
    [5] = "249",
}

--ͼ������
local TianMingTuJianConfig = {
    [1] = { var = VarCfg.T_TianMing_Fan, max = 18, attr = { [1] = 10000, [4] = 5000 }, baoLvAddtion = { [218] = 5 } },
    [2] = { var = VarCfg.T_TianMing_Ling, max = 20, attr = { [75] = 1500, [200] = 30000 }, baoLvAddtion = { [218] = 10 } },
    [3] = { var = VarCfg.T_TianMing_Xian, max = 24, attr = { [21] = 15, [22] = 15 }, baoLvAddtion = { [218] = 20 } },
    [4] = { var = VarCfg.T_TianMing_Sheng, max = 28, attr = { [79] = 1500, [80] = 15 }, baoLvAddtion = { [218] = 30 } },
    [5] = { var = VarCfg.T_TianMing_Di, max = 34, attr = { [208] = 15, [209] = 15, [210] = 15, [211] = 15, [212] = 15, [213] = 15, [214] = 15, [221] = 15, [222] = 15, [223] = 15, [224] = 15, [225] = 15, [202] = 1 }, baoLvAddtion = { [218] = 30 } },
}
--ö��ͼ��������״���ʾ��ʶ
local enumeTianMingFirstTipFalg = {
    [1] = VarCfg["F_����ͼ�����״����"],
    [2] = VarCfg["F_����ͼ�����״����"],
    [3] = VarCfg["F_����ͼ�����״����"],
    [4] = VarCfg["F_����ͼ��ʥ�״����"],
    [5] = VarCfg["F_����ͼ�����״����"],
}

--���쿪��
local enumeOpenHouTian = {
    [1] = { { "�����컯��", 10 } },
    [2] = { { "�����컯��", 10 } },
    [3] = { { "�����컯��", 10 } },
    [4] = { { "�����컯��", 10 } },
    [5] = { { "�����컯��", 10 } },
    [6] = { { "�����컯��", 10 } },
    [7] = { { "�����컯��", 10 } },
    [8] = { { "�����컯��", 10 } },
    [9] = { { "�����컯��", 10 } },
    [10] = { { "�����컯��", 10 } },
}

--���쿪����ʶ
local enumeOpenHouTianFlag = {
    [1] = VarCfg["F_�������˿���_1"],
    [2] = VarCfg["F_�������˿���_2"],
    [3] = VarCfg["F_�������˿���_3"],
    [4] = VarCfg["F_�������˿���_4"],
    [5] = VarCfg["F_�������˿���_5"],
    [6] = VarCfg["F_�������˿���_6"],
    [7] = VarCfg["F_�������˿���_7"],
    [8] = VarCfg["F_�������˿���_8"],
    [9] = VarCfg["F_�������˿���_9"],
    [10] = VarCfg["F_�������˿���_10"],
}
----------------��������---------------------
local TianMingBuffList = include("QuestDiary/game/A/TianMingBuffList.lua")
local TianMingFunc = include("QuestDiary/game/A/TianMingFunc.lua")
--����ר��
TianMing.ZhuanShu = include("QuestDiary/cfgcsv/cfg_ZhuanShu.lua")
--��ȡ���������б�---�״λ�ȡ
local function GetTianMingList(actor)
    local result = {}
    --�жϽ�ɫ�Ƿ��ڿ��
    if checkkuafu(actor) then
        local arr1 = json2tbl(getplayvar(actor, "HUMAN", "KFZF1"))
        local arr2 = json2tbl(getplayvar(actor, "HUMAN", "KFZF2"))
        result = table.appendArray(arr1, arr2)
    else
        for i = 1, 24 do
            local Tvar = VarCfg["T_������¼_" .. i]
            if Tvar then
                local value = Player.getJsonTableByVar(actor, Tvar)
                table.insert(result, value)
            end
        end
    end
    return result
end

--��ӹ�����������Ч��
local function AddAttackBuff(actor, cache, attackType, buffId)
    if type(attackType) == "number" then
        local tmpTbl = cache[attackType]
        table.insert(tmpTbl, buffId)
        table.uniqueArray(tmpTbl) --ɾ���ظ��������BUG
    elseif type(attackType) == "table" then
        for i, v in ipairs(attackType) do
            local tmpTbl = cache[v]
            table.insert(tmpTbl, buffId[i] or 0)
            table.uniqueArray(tmpTbl) --ɾ���ظ��������BUG
        end
    end
end

--��ӹ�����������Ч��
local function DelAttackBuff(actor, cache, attackType, buffId)
    if type(attackType) == "number" then
        local tmpTbl = cache[attackType]
        table.removebyvalue(tmpTbl, buffId)
        table.uniqueArray(tmpTbl) --ɾ���ظ��������BUG
    elseif type(attackType) == "table" then
        for i, v in ipairs(attackType) do
            local tmpTbl = cache[v]
            table.removebyvalue(tmpTbl, buffId[i] or 0)
            table.uniqueArray(tmpTbl) --ɾ���ظ��������BUG
        end
    end
end


local tianMingBuffCahce = {}
--��ʼ������
local function initCache(actor)
    tianMingBuffCahce[actor] = {
        ["����������Ч��"] = {
            [1]  = {}, --ȫ����������               ��1000��ͷ��
            [2]  = {}, --�����˴���                 ��2000��ͷ��
            [3]  = {}, --�������ﴥ��               ��3000��ͷ��
            [4]  = {}, --ȫ������ǰ��������Ѫǰ��    ��4000��ͷ��
            [5]  = {}, --������ǰ��������Ѫǰ��      ��5000��ͷ��
            [6]  = {}, --��������ǰ��������Ѫǰ��    ��6000��ͷ��
            [7]  = {}, --��ȫ����������             ��7000��ͷ��
            [8]  = {}, --���˹�������               ��8000��ͷ��
            [9]  = {}, --�����﹥������             ��9000��ͷ��
            [10] = {}, --��ȫ����������--ǰ         ��10000��ͷ��
            [11] = {}, --���˹�������--ǰ           ��11000��ͷ��
            [12] = {}, --�����﹥������--ǰ         ��12000��ͷ��
            [13] = {}, --����Ч��                  ��13000��ͷ��
            [14] = {}, --ɱ��                      ��14000��ͷ��
            [15] = {}, --ɱ��                      ��15000��ͷ��
            [16] = {}, --������                    ��16000��ͷ��
        },
        ["��������"] = {},
    }
    local tianMingList = GetTianMingList(actor)
    tianMingBuffCahce[actor]["��������"] = tianMingList
    for index, value in ipairs(tianMingList) do
        if #value > 1 then
            local cfg = TianMingList[value[1]][value[2]]
            -- dump(cfg)
            if cfg then
                if type(cfg.TMtype) == "number" then
                    if cfg.TMtype == 1 and cfg.buffId ~= nil then
                        local tmpTbl = tianMingBuffCahce[actor]["����������Ч��"]
                        AddAttackBuff(actor, tmpTbl, cfg.attackType, cfg.buffId)
                    end
                end
                --����ж��
                if type(cfg.TMtype) == "table" then
                    for _, v in ipairs(cfg.TMtype) do
                        if v == 1 and cfg.buffId ~= nil then
                            local tmpTbl = tianMingBuffCahce[actor]["����������Ч��"]
                            AddAttackBuff(actor, tmpTbl, cfg.attackType, cfg.buffId)
                        end
                    end
                end
            end
        end
    end
end
--���ظ�����
local function reloadInitCache()
    local playerList = getplayerlst(1)
    for _, actor in ipairs(playerList) do
        if not getbaseinfo(actor, ConstCfg.gbase.offline) then
            initCache(actor)
        end
    end
end

--���ظ�����
reloadInitCache()
-- dump(tianMingBuffCahce)

--���������Ļ���
function TianMing.clearCache(actor)
    tianMingBuffCahce[actor] = nil
end
--���û���
function TianMing.setCache(actor)
    initCache(actor)
end
--��ȡ���������б�
function TianMing.GetTianMingList(actor)
    if tianMingBuffCahce[actor] then
        if #tianMingBuffCahce[actor]["��������"] > 0 then
            return tianMingBuffCahce[actor]["��������"]
        end
    end
    local result = {}
    for i = 1, 24 do
        local Tvar = VarCfg["T_������¼_" .. i]
        if Tvar then
            local value = Player.getJsonTableByVar(actor, Tvar)
            table.insert(result, value)
        end
    end
    return result
end

--����Ʒ�ʻ�ȡ��������
function TianMing.GetTianMingNum(actor, quality)
    local TianMingList = TianMing.GetTianMingList(actor)
    local num = 0
    for _, value in ipairs(TianMingList) do
        if value[1] == quality then
            num = num + 1
        end
    end
    return num
end

--��ȡ�Ѿ����ڵ������б���Ҫ�����ظ����
function TianMing.GetHasTianMingList(actor, quality)
    local result = TianMing.GetTianMingList(actor)
    local newResult = {}
    for index, value in ipairs(result) do
        if #value > 0 then
            if not newResult[value[1]] then
                newResult[value[1]] = { value[2] }
            else
                table.insert(newResult[value[1]], value[2])
            end
        end
    end
    return newResult[quality]
end

--�ж������Ľ���״̬
function TianMing.GetLockState(actor, pos)
    --��ʼ��״̬
    local unLockArr = {
        [1] = 0,
        [2] = 0,
        [3] = 0,
        [4] = 0,
        [5] = 0,
        [6] = 0,
        [7] = 0,
        [8] = 0,
        [9] = 0,
        [10] = 0,
        [11] = 0,
        [12] = 0,
        [13] = 0,
        [14] = 0,
        [15] = 0,
        [16] = 0,
        [17] = 0,
        [18] = 0,
        [19] = 0,
        [20] = 0,
        [21] = 0,
        [22] = 0,
        [23] = 0,
        [24] = 0,
    }
    local reLevel = getbaseinfo(actor, ConstCfg.gbase.renew_level) --ת���ȼ�
    local maxLevel = getplaydef(actor, VarCfg["U_����������ĵȼ�"]) --���������ȼ�
    local vipLevel = getplaydef(actor, VarCfg["U_VIP�ȼ�"])

    local fanNumTbl = Player.getJsonTableByVar(actor, VarCfg.T_TianMing_Fan)
    local fanNum = table.nums(fanNumTbl) or 0
    local lingNumTbl = Player.getJsonTableByVar(actor, VarCfg.T_TianMing_Sheng)
    local lingNum = table.nums(lingNumTbl) or 0

    --��������
    unLockArr[1] = maxLevel >= 60 and 1 or 0
    unLockArr[2] = maxLevel >= 80 and 1 or 0
    unLockArr[3] = maxLevel >= 100 and 1 or 0
    unLockArr[4] = maxLevel >= 120 and 1 or 0
    unLockArr[5] = maxLevel >= 180 and 1 or 0
    unLockArr[6] = maxLevel >= 240 and 1 or 0
    unLockArr[7] = reLevel >= 1 and 1 or 0
    unLockArr[8] = reLevel >= 2 and 1 or 0
    unLockArr[9] = reLevel >= 3 and 1 or 0
    unLockArr[10] = reLevel >= 4 and 1 or 0
    unLockArr[11] = reLevel >= 5 and 1 or 0
    unLockArr[12] = reLevel >= 6 and 1 or 0

    --��������
    unLockArr[13] = getflagstatus(actor, VarCfg["F_�������˿���_1"])
    unLockArr[14] = getflagstatus(actor, VarCfg["F_�������˿���_2"])
    unLockArr[15] = getflagstatus(actor, VarCfg["F_�������˿���_3"])
    unLockArr[16] = getflagstatus(actor, VarCfg["F_�������˿���_4"])
    unLockArr[17] = getflagstatus(actor, VarCfg["F_�������˿���_5"])
    unLockArr[18] = getflagstatus(actor, VarCfg["F_�������˿���_6"])
    unLockArr[19] = getflagstatus(actor, VarCfg["F_�������˿���_7"])
    unLockArr[20] = getflagstatus(actor, VarCfg["F_�������˿���_8"])
    unLockArr[21] = getflagstatus(actor, VarCfg["F_�������˿���_9"])
    unLockArr[22] = getflagstatus(actor, VarCfg["F_�������˿���_10"])
    unLockArr[23] = fanNum >= TianMingTuJianConfig[1].max and 1 or 0
    unLockArr[24] = lingNum >= TianMingTuJianConfig[4].max and 1 or 0
    if not pos then
        return unLockArr
    else
        return unLockArr[pos]
    end
end

--����λ�ü����������
function TianMing.OpenHouTian(actor, index)
    local cost = enumeOpenHouTian[index]
    if not cost then
        Player.sendmsgEx(actor, "��������!#249")
        return
    end
    local flag = enumeOpenHouTianFlag[index]
    if not flag then
        Player.sendmsgEx(actor, "��������2!#249")
        return
    end
    if getflagstatus(actor, flag) == 1 then
        Player.sendmsgEx(actor, "���Ѿ��������!#249")
        return
    end
    local name, num = Player.checkItemNumByTable(actor, cost)
    if name then
        Player.sendmsgEx(actor, string.format("���|%s#249|����|%d#249|,���|��������#249|��|��������#249|�ɻ��|%s#249", name, num, name))
        return
    end
    Player.takeItemByTable(actor, cost, "������������" .. index)
    setflagstatus(actor, VarCfg["F_���������������"], 1)
    setflagstatus(actor, flag, 1)
    Player.sendmsgEx(actor, "�����ɹ��������˳ɹ�!")
    Message.sendmsg(actor, ssrNetMsgCfg.TianMing_OpenHouTian, index)
end

--��������������а���ͼ��
---* actor�����
---* pos������λ��
---* quality������Ʒ��
---* value���������
function TianMing.AddTianMing(actor, pos, quality, value)
    --��¼����
    local Tvar = VarCfg["T_������¼_" .. pos]
    if Tvar then
        local t = { quality, value }
        Player.setJsonVarByTable(actor, Tvar, t)
        tianMingBuffCahce[actor]["��������"][pos] = t
    end
    --�������ͼ��
    local tuJianVar = enumeTianMingVar[quality]
    if tuJianVar then
        --����ͼ��
        local tbl = Player.getJsonTableByVar(actor, tuJianVar)
        if not tbl[tostring(value)] then
            tbl[tostring(value)] = 1
            local qualityName = enumeQualityName[quality]
            local tianMingName = TianMingList[quality][value].name or ""
            local color = enumeTianMingColor[quality]
            Player.setJsonVarByTable(actor, tuJianVar, tbl)
            Player.sendmsgEx(actor, string.format("��ϲ�������ͼ��|%s��%s#%s", qualityName, tianMingName, color))
            Player.setAttList(actor, "���Ը���")
            Player.setAttList(actor, "���ʸ���")
        end
    end
end

--��ʶ��buff����
---* actor�����
---* flagVar����ʶ����
---* flagValue����ʶֵ
function TianMing.SetFlagBuffAndRunFunc(actor, flagVar, flagValue)
    setflagstatus(actor, flagVar, flagValue)
    local func = TianMingFunc[flagVar]
    if func then
        func(actor, 1)
    end
end

--���buff����������
---* actor�����
---* cfg����������
function TianMing.AddTianMingCahce(actor, TMtype, cfg)
    if TMtype == 1 and cfg.buffId ~= nil then
        local tmpTbl = tianMingBuffCahce[actor]["����������Ч��"]
        AddAttackBuff(actor, tmpTbl, cfg.attackType, cfg.buffId)
    elseif TMtype == 2 then
        Player.setAttList(actor, "���Ը���")
    elseif TMtype == 3 then
        TianMing.SetFlagBuffAndRunFunc(actor, cfg.value, 1)
    elseif TMtype == 4 and cfg.buffId ~= nil then
        addbuff(actor, cfg.buffId)
    elseif TMtype == 6 then
        local userId = getbaseinfo(actor, ConstCfg.gbase.id)
        Player.sendmsgEx(actor, "��ϲ���[һҹ����],�뵽�ʼ���ȡ3000W���!")
        sendmail(userId, 1, "һҹ����", "ѡ���ֱ�ӻ��3000W�󶨽��,����ȡ", "�󶨽��#30000000#0")
    elseif TMtype == 7 then
        local liveMax = getplaydef(actor, VarCfg["U_�ȼ�����"])
        setplaydef(actor, VarCfg["U_�ȼ�����"], liveMax + cfg.value)
        setlocklevel(actor, 1, getplaydef(actor, VarCfg["U_�ȼ�����"]))
        -- changelevel(actor, "+", cfg.value)
    end
end

--���buff����������
---* actor�����
---* cfg����������
function TianMing.DelTianMingCahce(actor, TMtype, lastCfg)
    if TMtype == 1 and lastCfg.buffId ~= nil then
        local tmpTbl = tianMingBuffCahce[actor]["����������Ч��"] --��ȡ����
        DelAttackBuff(actor, tmpTbl, lastCfg.attackType, lastCfg.buffId)
    elseif TMtype == 2 then
        Player.setAttList(actor, "���Ը���")
    elseif TMtype == 3 then
        TianMing.SetFlagBuffAndRunFunc(actor, lastCfg.value, 0)
    elseif TMtype == 4 and lastCfg.buffId ~= nil then
        FkfDelBuff(actor, lastCfg.buffId)
    elseif TMtype == 7 then
        local liveMax = getplaydef(actor, VarCfg["U_�ȼ�����"])
        setplaydef(actor, VarCfg["U_�ȼ�����"], liveMax - lastCfg.value)
        setlocklevel(actor, 1, getplaydef(actor, VarCfg["U_�ȼ�����"]))
        -- changelevel(actor, "-", lastCfg.value)
    end
end

--����buff��ӵ�����
---* actor�����
---* cfg����������
---* lastTianMing:�ϴ�����
function TianMing.AddTianMingBuff(actor, cfg, lastTianMing, value)
    local lastCfg = nil
    if #lastTianMing > 1 then
        lastCfg = TianMingList[lastTianMing[1]][lastTianMing[2]]
    end
    --���ϴε�BUFF�����Ƴ�
    if lastCfg then
        if type(lastCfg.TMtype) == "number" then
            --����������
            TianMing.DelTianMingCahce(actor, lastCfg.TMtype, lastCfg)
        end
        --����
        if type(lastCfg.TMtype) == "table" then
            for _, v in ipairs(lastCfg.TMtype) do
                TianMing.DelTianMingCahce(actor, v, lastCfg)
            end
        end
    end
    --�Ե�ǰ�������
    if type(cfg.TMtype) == "number" then
        --����������
        TianMing.AddTianMingCahce(actor, cfg.TMtype, cfg)
    end
    --����
    if type(cfg.TMtype) == "table" then
        for _, v in ipairs(cfg.TMtype) do
            --����������
            TianMing.AddTianMingCahce(actor, v, cfg)
        end
    end
end

local HYDTcost = { { "���˵�ͷ", 1 } }
---* ��������
--*  actor ���
--*  pos ����λ��
function TianMing.Request(actor, pos, costType, isHYDT)
    if not pos then
        Player.sendmsgEx(actor, "���˲�������1")
        return
    end
    local isUnLock = TianMing.GetLockState(actor, pos)
    if not isUnLock then
        Player.sendmsgEx(actor, "���˲�������2")
        return
    end
    if not costType then
        Player.sendmsgEx(actor, "���˲�������3")
        return
    end
    if costType > 2 or costType == 0 then
        Player.sendmsgEx(actor, "���˲�������4")
        return
    end
    local recordVar = VarCfg["T_������¼_" .. pos] --��ǰ��¼�ı���
    if not recordVar then
        Player.sendmsgEx(actor, "���˲�������5")
        return
    end

    if isUnLock == 0 then
        Player.sendmsgEx(actor, "δ����")
        return
    end
    local record = Player.getJsonTableByVar(actor, recordVar)
    local costIndex = 1 --�ж���������  1���˾��� 2ת�˽� 3���
    local cost = {}
    if pos <= 12 and costType == 1 then
        costIndex = 1
    else
        costIndex = 2
    end
    if costType == 2 then
        costIndex = 3
    end
    --����Ǻ��˵�ͷ����
    if isHYDT == 1 then
        local name, num = Player.checkItemNumByTable(actor, HYDTcost)
        if name then
            Player.sendmsgEx(actor, string.format("���#249|[%s]#250|����#249|%d#250", name, num))
            return
        end
    end
    cost = CostType[costIndex]
    local name, num = Player.checkItemNumByTable(actor, cost)
    --�����ǰλ���ǿյ� ���ֹ��Ʒ���
    if #record == 0 then
        name = nil
        num = nil
    end
    if name then
        Player.sendmsgEx(actor, string.format("���#249|[%s]#250|����#249|%d#250", name, num))
        return
    end
    --��ȡȨ��
    local quality = ransjstr(weight, 1, 3)
    quality = tonumber(quality)
    local baoDiCiShu = getplaydef(actor, VarCfg["U_�������״���"])
    -- release_print(baoDiCiShu)
    --����5�Ǳ���
    if baoDiCiShu >= 25 then
        -- release_print("������������")
        quality = 5
    end
    --���˵�ͷ�س���Ʒ��
    if isHYDT == 1 then
        quality = 5
    end
    if quality == 5 then
        setplaydef(actor, VarCfg["U_�������״���"], 0) --���ñ��״���
    end

    -- quality = 4 --ǿ���޸�Ʒ��
    --��ȡ����
    local list = TianMingList[quality]
    if list then
        local hasList = TianMing.GetHasTianMingList(actor, quality)
        --�����Ʒ�Ѿ����˾ͳ�ȡ��Ʒ
        if hasList then
            if quality == 1 and #hasList >= 18 then
                quality = 2
                list = TianMingList[quality]
                hasList = TianMing.GetHasTianMingList(actor, quality)
            end
        end
        --�����Ʒ�Ѿ����˾ͳ�ȡ��Ʒ
        if hasList then
            if quality == 2 and #hasList >= 20 then
                quality = 3
                list = TianMingList[quality]
                hasList = TianMing.GetHasTianMingList(actor, quality)
            end
        end

        --�����Ķ�����24����˲�����������Ҫ�жϣ�
        local randomNum
        --����Ѿ������˾ͳ�һ�������ڵı��
        if hasList then
            randomNum = generateRandomExclude(hasList, #list) --��һ�������ڵı��
            --����Ѿ����ˣ������������
            if not randomNum then
                randomNum = math.random(#list) -- �������
            end
        else
            randomNum = math.random(#list) -- �������
        end
        -- randomNum = 35  --ǿ���޸�
        -- release_print(tostring(randomNum),tostring(quality))
        local baoDiCiShu = getplaydef(actor, VarCfg["U_�������״���"])
        setplaydef(actor, VarCfg["U_�������״���"], baoDiCiShu + 1)
        if isHYDT == 1 then
            Player.takeItemByTable(actor, HYDTcost, "��������")
            setplaydef(actor, VarCfg["U_�������״���"], 0)
        end
        --��ǰλ�ò��ǿյĲſ۲���
        if #record > 0 then
            Player.takeItemByTable(actor, cost, "��������")
        end

        local Tvar = VarCfg["T_������¼_" .. pos]
        local lastTianMing = {}
        if Tvar then
            lastTianMing = Player.getJsonTableByVar(actor, Tvar) --��¼�ϴ�����
        end
        TianMing.AddTianMing(actor, pos, quality, randomNum)     --���浽������
        --���ϴ��������
        local shiFouQiYun = getflagstatus(actor, VarCfg["F_�Ƿ�ϴ��������"])
        if shiFouQiYun == 0 then
            setflagstatus(actor, VarCfg["F_�Ƿ�ϴ��������"], 1)
            local taskPanelID = getplaydef(actor, VarCfg["U_��������������"])
            if taskPanelID == 2 then
                FCheckTaskRedPoint(actor)
            end
        end
        --���ϴ�����������
        Message.sendmsg(actor, ssrNetMsgCfg.TianMing_CQResponse, pos, quality, randomNum)
        if quality == 5 then
            local myName = getbaseinfo(actor, ConstCfg.gbase.name)
            FSendMsgNew(actor,
                string.format("��ϲ���[{%s/FCOLOR=245}]��������,���[{%s��%s/FCOLOR=249}]", myName, enumeQualityName[quality],
                    list[randomNum].name))
            if getflagstatus(actor, VarCfg["F_����_�鸣�����ʶ"]) == 1 then
                Player.setAttList(actor, "���Ը���")
            end
        end
        TianMing.AddTianMingBuff(actor, list[randomNum], lastTianMing, randomNum) --���������buff
    end
end

--ĳ�������Ƿ����
---* actor ���
---* quality Ʒ��
---* index ����
function TianMing.GetIsTianMing(actor, quality, index)
    local tbl = TianMing.GetTianMingList(actor)
    for _, value in ipairs(tbl) do
        if #value > 1 then
            if value[1] == quality and value[2] == index then
                return true, value
            end
        end
    end
    return false, {}
end

--ĳ�������Ƿ���ڷ��ز�������
---* actor ���
---* quality Ʒ��
---* index ����
function TianMing.GetIsTianMingBool(actor, quality, index)
    local tbl = TianMing.GetTianMingList(actor)
    for _, value in ipairs(tbl) do
        if #value > 1 then
            if value[1] == quality and value[2] == index then
                return true
            end
        end
    end
    return false
end

--��Ӧͼ������
function TianMing.TJResponse(actor)
    local data = {}
    for index, value in ipairs(enumeTianMingVar) do
        local t = Player.getJsonTableByVar(actor, value)
        table.insert(data, t)
    end
    Message.sendmsg(actor, ssrNetMsgCfg.TianMing_TJResponse, 0, 0, 0, data)
end

--�����UI
function TianMing.openUI(actor)
    local data = {}
    local unLockData = TianMing.GetLockState(actor)
    local myTianMingData = TianMing.GetTianMingList(actor)
    data.unLock = unLockData
    data.myTianMing = myTianMingData
    Message.sendmsg(actor, ssrNetMsgCfg.TianMing_openUI, 0, 0, 0, data)
end

--����ͬ���������
function TianMing.SyncKuaFu(actor)
    --��ȡ�����б�
    local tianMingList = TianMing.GetTianMingList(actor)
    local split_index = math.ceil(#tianMingList / 2)
    local arr1 = {}
    local arr2 = {}
    for i = 1, split_index do
        arr1[i] = tianMingList[i]
    end
    for i = split_index + 1, #tianMingList do
        arr2[i - split_index] = tianMingList[i]
    end
    local str1 = tbl2json(arr1)
    local str2 = tbl2json(arr2)
    setplayvar(actor, "HUMAN", "KFZF1", str1, 1)
    setplayvar(actor, "HUMAN", "KFZF2", str2, 1)
end

--ע��������Ϣ
Message.RegisterNetMsg(ssrNetMsgCfg.TianMing, TianMing)

--��������������
local function CalcTianMingAttr(actor, attrs)
    local tianMingData = TianMing.GetTianMingList(actor)
    for i, value in ipairs(tianMingData) do
        if #value > 1 then
            local cfg = TianMingList[value[1]][value[2]]
            if cfg then
                if type(cfg.TMtype) == "number" then
                    if cfg.TMtype == 2 then
                        for j, v1 in ipairs(cfg.attr) do
                            if not attrs[v1[1]] then
                                attrs[v1[1]] = v1[2]
                            else
                                attrs[v1[1]] = attrs[v1[1]] + v1[2]
                            end
                        end
                    end
                end

                if type(cfg.TMtype) == "table" then
                    for k, v2 in ipairs(cfg.TMtype) do
                        if v2 == 2 then
                            for l, v3 in ipairs(cfg.attr) do
                                if not attrs[v3[1]] then
                                    attrs[v3[1]] = v3[2]
                                else
                                    attrs[v3[1]] = attrs[v3[1]] + v3[2]
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end

--���Դ���
local function _onCalcAttr(actor, attrs)
    local shuxing = {}
    for i, value in ipairs(TianMingTuJianConfig) do
        local tuJianData = Player.getJsonTableByVar(actor, value.var)
        local tuJianCount = table.nums(tuJianData)
        if tuJianCount >= value.max then
            for k, v in pairs(value.attr) do
                if not shuxing[k] then
                    shuxing[k] = v
                else
                    shuxing[k] = shuxing[k] + v
                end
            end

            --�״μ�����ʾ
            local falg = getflagstatus(actor, enumeTianMingFirstTipFalg[i])
            if falg == 0 then
                messagebox(actor, string.format("��ϲ�㼤����ȫ��[%s]ͼ��,ʵ����ô������!", enumeQualityName[i]))
                local myName = getbaseinfo(actor, ConstCfg.gbase.name)
                FSendMsgNew(actor,
                    string.format("��ϲ���[{%s/FCOLOR=245}]����ȫ��[{%s/FCOLOR=249}]ͼ��,ʵ����ô������!", myName, enumeQualityName[i]))
                setflagstatus(actor, enumeTianMingFirstTipFalg[i], 1)
            end
        end
    end
    --�������
    if getflagstatus(actor, VarCfg["F_����_������ֱ�ʶ"]) == 1 then
        local currentLevel = getbaseinfo(actor, ConstCfg.gbase.level)
        if not shuxing[200] then
            shuxing[200] = currentLevel * 150
        else
            shuxing[200] = shuxing[200] + currentLevel * 150
        end
    end
    --��������
    if getflagstatus(actor, VarCfg["F_����_�������˱�ʶ"]) == 1 then
        local heQuDay = tonumber(getconst(actor, "<$HFCOUNT>"))
        if heQuDay > 0 then
            if not shuxing[26] then
                shuxing[26] = 10
            else
                shuxing[26] = shuxing[26] + 10
            end

            if not shuxing[208] then
                shuxing[208] = 20
            else
                shuxing[208] = shuxing[208] + 20
            end

            if not shuxing[75] then
                shuxing[75] = 1000
            else
                shuxing[75] = shuxing[75] + 1000
            end
        end
    end
    if getflagstatus(actor, VarCfg["F_����_�鸣�����ʶ"]) == 1 then
        local num = TianMing.GetTianMingNum(actor, 5)
        local addtion = 5 + num * 2
        local tmpshuxing = {
            [208] = addtion,
            [209] = addtion,
            [210] = addtion,
            [211] = addtion,
            [212] = addtion,
            [213] = addtion,
            [214] = addtion,
            [221] = addtion,
            [222] = addtion,
            [223] = addtion,
            [224] = addtion,
            [225] = addtion,
        }
        attsMerge(tmpshuxing, shuxing)
    end
    if getflagstatus(actor, VarCfg["F_����_δ��սʿ��ʶ"]) == 1 then
        local level = getbaseinfo(actor, ConstCfg.gbase.level)
        if level > 100 then
            local attack = (level - 100) * 60
            local hp = (level - 100) * 1000
            local tmpshuxing = {
                [1] = hp,
                [4] = attack
            }
            attsMerge(tmpshuxing, shuxing)
        end
    end

    if getflagstatus(actor, VarCfg["F_����_ԡѪ��ħ��ʶ"]) == 1 then
        local currHp = getplaydef(actor, VarCfg["U_����_ԡѪ��ħ_Ѫ��"])
        if currHp > 0 then
            local tmpshuxing = {
                [1] = currHp,
            }
            attsMerge(tmpshuxing, shuxing)
        end
    end

    CalcTianMingAttr(actor, shuxing)
    calcAtts(attrs, shuxing, "����������ͼ��")
end
--����
GameEvent.add(EventCfg.onCalcAttr, _onCalcAttr, TianMing)

--��������
local function _onCalcBeiGong(actor, beiGongs)
    if getflagstatus(actor, VarCfg["F_����_ԡѪ��ħ��ʶ"]) == 1 then
        beiGongs[1] = beiGongs[1] + 5
    end

    if getflagstatus(actor, VarCfg["F_��������"]) == 1 then
        beiGongs[1] = beiGongs[1] + 5
    end

    if getflagstatus(actor, VarCfg["F_��������ȫ��"]) == 1 then
        beiGongs[1] = beiGongs[1] + 5
    end
end
GameEvent.add(EventCfg.onCalcBeiGong, _onCalcBeiGong, TianMing)

--��������
local function _onCalcBaoLv(actor, attrs)
    local shuxing = {}
    for i, value in ipairs(TianMingTuJianConfig) do
        local tuJianData = Player.getJsonTableByVar(actor, value.var)
        local tuJianCount = table.nums(tuJianData)
        if tuJianCount >= value.max then
            for k, v in pairs(value.baoLvAddtion) do
                if not shuxing[k] then
                    shuxing[k] = v
                else
                    shuxing[k] = shuxing[k] + v
                end
            end
        end
    end
    if getflagstatus(actor, VarCfg["F_����_��ѡ֮�˱�ʶ_��"]) == 1 then
        if not shuxing[204] then
            shuxing[204] = 20
        else
            shuxing[204] = shuxing[204] + 20
        end
    end
    if getflagstatus(actor, VarCfg["F_����_����ת����ʶ"]) == 1 then
        if not shuxing[204] then
            shuxing[204] = 33
        else
            shuxing[204] = shuxing[204] + 33
        end
    end
    calcAtts(attrs, shuxing, "���ʸ���:�������Լӳɸ���")
end
GameEvent.add(EventCfg.onCalcBaoLv, _onCalcBaoLv, TianMing)

--���㹥��
local function _onCalcAttackSpeed(actor, attackSpeeds)
    if getflagstatus(actor, VarCfg["F_����_����Ѹ�ױ�ʶ"]) == 1 then
        attackSpeeds[1] = attackSpeeds[1] + 20
    end
    if getflagstatus(actor, VarCfg["F_��������֮��"]) == 1 then
        attackSpeeds[1] = attackSpeeds[1] + 66
    end
    if getflagstatus(actor, VarCfg["F_��������˫��"]) == 1 then
        attackSpeeds[1] = attackSpeeds[1] + 38
    end
    if getflagstatus(actor, VarCfg["F_��������֮��"]) == 1 then
        attackSpeeds[1] = attackSpeeds[1] + 8
    end
end

GameEvent.add(EventCfg.onCalcAttackSpeed, _onCalcAttackSpeed, TianMing)

--����С�˴���--������
local function _onExitGame(actor)
    tianMingBuffCahce[actor] = nil
end
GameEvent.add(EventCfg.onExitGame, _onExitGame, TianMing)

--��½����
local function _onLoginEnd(actor)
    initCache(actor)
    --������һ�ε�¼��������ֹ���ܳ�������
    local tianMingList = TianMing.GetTianMingList(actor)
    for index, value in ipairs(tianMingList) do
        if #value > 1 then
            local cfg = TianMingList[value[1]][value[2]]
            -- dump(cfg)
            if cfg then
                if type(cfg.TMtype) == "number" then
                    if cfg.TMtype == 3 then
                        local Func = TianMingFunc[cfg.value]
                        if Func then
                            Func(actor)
                        end
                    end
                end
                --����ж��
                if type(cfg.TMtype) == "table" then
                    for _, v in ipairs(cfg.TMtype) do
                        if v == 3 then
                            local Func = TianMingFunc[cfg.value]
                            if Func then
                                Func(actor)
                            end
                        end
                    end
                end
            end
        end
    end
    if not checkkuafu(actor) then
        if getflagstatus(actor, VarCfg["F_����_��������ʶ"]) == 1 then
            setontimer(actor, 10, 3, 0, 1)
        end
    end
end
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, TianMing)
GameEvent.add(EventCfg.onKFLogin, _onLoginEnd, TianMing)
--��ȡ����Ĺ���������Ч��
local function onGetTianMingBuff(actor, index)
    if not tianMingBuffCahce[actor] then
        return {}
    end
    local result = tianMingBuffCahce[actor]["����������Ч��"][index]
    if not result then
        return {}
    end
    return result
end

-----------------------------����BUFF��ʼ---------------------------------
--ȫ������������1000��ͷ��
local function _onAttack(actor, Target, Hiter, MagicId)
    local BuffList = onGetTianMingBuff(actor, 1) -- {1000,1001}
    if #BuffList > 0 then
        for _, v in ipairs(BuffList) do
            local buffFunc = TianMingBuffList[v]
            if buffFunc then
                buffFunc(actor, Target, Hiter, MagicId)
            end
        end
    end
end
GameEvent.add(EventCfg.onAttack, _onAttack, TianMingBuffList)

--�����˴�����2000��ͷ��
local function _onAttackPlayer(actor, Target, Hiter, MagicId)
    local BuffList = onGetTianMingBuff(actor, 2)
    if #BuffList > 0 then
        for _, v in ipairs(BuffList) do
            local buffFunc = TianMingBuffList[v]
            if buffFunc then
                buffFunc(actor, Target, Hiter, MagicId)
            end
        end
    end
end
GameEvent.add(EventCfg.onAttackPlayer, _onAttackPlayer, TianMingBuffList)

--�������ﴥ����3000��ͷ��
local function _onAttackMonster(actor, Target, Hiter, MagicId, qieGe)
    local BuffList = onGetTianMingBuff(actor, 3)
    if #BuffList > 0 then
        for _, v in ipairs(BuffList) do
            local buffFunc = TianMingBuffList[v]
            if buffFunc then
                buffFunc(actor, Target, Hiter, MagicId, qieGe)
            end
        end
    end
end
GameEvent.add(EventCfg.onAttackMonster, _onAttackMonster, TianMingBuffList)

--ȫ������ǰ��������Ѫǰ����4000��ͷ��
local function _onAttackDamage(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    local BuffList = onGetTianMingBuff(actor, 4)
    if #BuffList > 0 then
        for _, v in ipairs(BuffList) do
            local buffFunc = TianMingBuffList[v]
            if buffFunc then
                buffFunc(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
            end
        end
    end
end
GameEvent.add(EventCfg.onAttackDamage, _onAttackDamage, TianMingBuffList)

--������ǰ��������Ѫǰ����5000��ͷ��
local function _onAttackDamagePlayer(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    local BuffList = onGetTianMingBuff(actor, 5)
    if #BuffList > 0 then
        for _, v in ipairs(BuffList) do
            local buffFunc = TianMingBuffList[v]
            if buffFunc then
                buffFunc(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
            end
        end
    end
end
GameEvent.add(EventCfg.onAttackDamagePlayer, _onAttackDamagePlayer, TianMingBuffList)

--��������ǰ��������Ѫǰ����6000��ͷ��
local function _onAttackDamageMonster(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    local BuffList = onGetTianMingBuff(actor, 6)
    if #BuffList > 0 then
        for _, v in ipairs(BuffList) do
            local buffFunc = TianMingBuffList[v]
            if buffFunc then
                buffFunc(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
            end
        end
    end
end
GameEvent.add(EventCfg.onAttackDamageMonster, _onAttackDamageMonster, TianMingBuffList)


--��ȫ������������7000��ͷ��-----------------------------------
local function _onStruck(actor, Target, Hiter, MagicId)
    local BuffList = onGetTianMingBuff(actor, 7)
    if #BuffList > 0 then
        for _, v in ipairs(BuffList) do
            local buffFunc = TianMingBuffList[v]
            if buffFunc then
                buffFunc(actor, Target, Hiter, MagicId)
            end
        end
    end
end
GameEvent.add(EventCfg.onStruck, _onStruck, TianMingBuffList)

--���˹���������8000��ͷ��
local function _onStruckPlayer(actor, Target, Hiter, MagicId)
    local BuffList = onGetTianMingBuff(actor, 8)
    if #BuffList > 0 then
        for _, v in ipairs(BuffList) do
            local buffFunc = TianMingBuffList[v]
            if buffFunc then
                buffFunc(actor, Target, Hiter, MagicId)
            end
        end
    end
end
GameEvent.add(EventCfg.onStruckPlayer, _onStruckPlayer, TianMingBuffList)

--���ֹ���������9000��ͷ��
local function _onStruckMonster(actor, Target, Hiter, MagicId)
    local BuffList = onGetTianMingBuff(actor, 9)
    if #BuffList > 0 then
        for _, v in ipairs(BuffList) do
            local buffFunc = TianMingBuffList[v]
            if buffFunc then
                buffFunc(actor, Target, Hiter, MagicId)
            end
        end
    end
end
GameEvent.add(EventCfg.onStruckMonster, _onStruckMonster, TianMingBuffList)

--��ȫ������������10000��ͷ��
local function _onStruckDamage(actor, Target, Hiter, MagicId, Damage, attackDamageData)
    local BuffList = onGetTianMingBuff(actor, 10)
    if #BuffList > 0 then
        for _, v in ipairs(BuffList) do
            local buffFunc = TianMingBuffList[v]
            if buffFunc then
                buffFunc(actor, Target, Hiter, MagicId, Damage, attackDamageData)
            end
        end
    end
end
GameEvent.add(EventCfg.onStruckDamage, _onStruckDamage, TianMingBuffList)

--����ҹ���������11000��ͷ��
local function _onStruckDamagePlayer(actor, Target, Hiter, MagicId, Damage, attackDamageData)
    local BuffList = onGetTianMingBuff(actor, 11)
    if #BuffList > 0 then
        for _, v in ipairs(BuffList) do
            local buffFunc = TianMingBuffList[v]
            if buffFunc then
                buffFunc(actor, Target, Hiter, MagicId, Damage, attackDamageData)
            end
        end
    end
end
GameEvent.add(EventCfg.onStruckDamagePlayer, _onStruckDamagePlayer, TianMingBuffList)

--���ֹ���������12000��ͷ��
local function _onStruckDamageMonster(actor, Target, Hiter, MagicId, Damage, attackDamageData)
    local BuffList = onGetTianMingBuff(actor, 12)
    if #BuffList > 0 then
        for _, v in ipairs(BuffList) do
            local buffFunc = TianMingBuffList[v]
            if buffFunc then
                buffFunc(actor, Target, Hiter, MagicId, Damage, attackDamageData)
            end
        end
    end
end
GameEvent.add(EventCfg.onStruckDamageMonster, _onStruckDamageMonster, TianMingBuffList)

--�������13000��ͷ��
local function _onRevive(actor)
    local BuffList = onGetTianMingBuff(actor, 13)
    if #BuffList > 0 then
        for _, v in ipairs(BuffList) do
            local buffFunc = TianMingBuffList[v]
            if buffFunc then
                buffFunc(actor)
            end
        end
    end
end
GameEvent.add(EventCfg.onRevive, _onRevive, TianMingBuffList)

--ɱ�ִ�����14000��ͷ��
local function _onKillMon(actor, monobj)
    local BuffList = onGetTianMingBuff(actor, 14)
    if #BuffList > 0 then
        for _, v in ipairs(BuffList) do
            local buffFunc = TianMingBuffList[v]
            if buffFunc then
                buffFunc(actor, monobj)
            end
        end
    end
end
GameEvent.add(EventCfg.onKillMon, _onKillMon, TianMingBuffList)

--ɱ�˴�����15000��ͷ��
local function _onkillplay(actor, play)
    local BuffList = onGetTianMingBuff(actor, 15)
    if #BuffList > 0 then
        for _, v in ipairs(BuffList) do
            local buffFunc = TianMingBuffList[v]
            if buffFunc then
                buffFunc(actor, play)
            end
        end
    end
end
GameEvent.add(EventCfg.onkillplay, _onkillplay, TianMingBuffList)


--����������16000��ͷ��
local function _onPlaydie(actor, hiter)
    local BuffList = onGetTianMingBuff(actor, 16)
    if #BuffList > 0 then
        for _, v in ipairs(BuffList) do
            local buffFunc = TianMingBuffList[v]
            if buffFunc then
                buffFunc(actor, hiter)
            end
        end
    end
end
GameEvent.add(EventCfg.onPlaydie, _onPlaydie, TianMingBuffList)

local wuShuZhiRenMap = {
    [27] = true,
    [82] = true,
    [114] = true,
    [2014] = true,
    [2018] = true,
    [2020] = true,
    [2023] = true,
}
--ʹ�ü��ܴ��� ����֮��
local function _onUseSkill(actor, MagicId)
    local BuffList = onGetTianMingBuff(actor, 1)
    if table.contains(BuffList, 1004) then
        -- 27  Ұ����ײ
        -- 82 ʮ��һɱ
        -- 2014 �ٻ�����
        -- 2018	��ˮ����
        -- 114 ����ٵ�
        -- 2020	ȼ�շ���
        -- 2023	�������
        if wuShuZhiRenMap[MagicId] then
            setplaydef(actor, VarCfg["N$�ͷ��������ܸ����˺�"], 1)
        end
    end
end
GameEvent.add(EventCfg["ʹ�ü���ͨ���ɷ�"], _onUseSkill, TianMingBuffList)


local function _onEnterGroup(actor)
    -- local name = getbaseinfo(actor,ConstCfg.gbase.name)
    -- release_print(name.."�������")
    TianMingFunc[29](actor)
end
GameEvent.add(EventCfg.onEnterGroup, _onEnterGroup, TianMingBuffList)

local function _onLeaveGroup(actor)
    -- local name = getbaseinfo(actor,ConstCfg.gbase.name)
    -- release_print(name.."�뿪����")
    TianMingFunc[29](actor)
end
GameEvent.add(EventCfg.onLeaveGroup, _onLeaveGroup, TianMingBuffList)

------------ҹ����
local function _noStartingDark(actor)
    TianMingFunc[28](actor)
    TianMingFunc[50](actor)
    TianMingFunc[234](actor)
end
GameEvent.add(EventCfg.onStartingDark, _noStartingDark, TianMingBuffList)
-----------���촥��
local function _noStartingDay(actor)
    TianMingFunc[28](actor)
    TianMingFunc[50](actor)
    TianMingFunc[235](actor)
end
GameEvent.add(EventCfg.onStartingDay, _noStartingDay, TianMingBuffList)
--------------------------ʰȡ����---------------------------------------------
local function _goPickUpItemEx(actor, itemobj, itemidx, itemMakeIndex, ItemName)
    if TianMing.ZhuanShu[ItemName] then
        if getflagstatus(actor, VarCfg["F_���������ӱ�"]) == 1 then
            if hasbuff(actor, 31071) then
                delbuff(actor, 31071)
            end
        end
    end
end
GameEvent.add(EventCfg.goPickUpItemEx, _goPickUpItemEx, TianMing)
-----------------------------��������-------------------------------------
local function _onSkillPower(actor, skillrs)
    if getflagstatus(actor, VarCfg["F_������ɱ���i"]) == 1 then
        local shuxing = {}
        shuxing["�һ𽣷�"] = 3
        shuxing["����ն"] = 3
        shuxing["���ս���"] = 3
        calcAtts(skillrs, shuxing, "������ɱ���i������������")
    end
end

GameEvent.add(EventCfg.onAddSkillPower, _onSkillPower, TianMingFunc)
-------------------------�����л�ʱ����---------------------------------
local function _onLoadGuild(actor, guildobj)
    TianMingFunc[VarCfg["F_����������Ȩ"]](actor)
    TianMingFunc[VarCfg["F_����������Ⱥ"]](actor)
end
GameEvent.add(EventCfg.onLoadGuild, _onLoadGuild, TianMing)
-------------------------------��ɢ�л�--------------------------------------
local function _onCloseGuild(actor)
    TianMingFunc[VarCfg["F_����������Ȩ"]](actor)
    TianMingFunc[VarCfg["F_����������Ⱥ"]](actor)
end
GameEvent.add(EventCfg.onCloseGuild, _onCloseGuild, TianMing)
--------------------------�����л�----------------------------
local function _onGuildAddMemberAfter(actor)
    TianMingFunc[VarCfg["F_����������Ⱥ"]](actor)
end
GameEvent.add(EventCfg.onGuildAddMemberAfter, _onGuildAddMemberAfter, TianMing)
------------------------�˳��л�-------------------------------
local function _onGuilddelMember(actor)
    TianMingFunc[VarCfg["F_����������Ⱥ"]](actor)
end
GameEvent.add(EventCfg.onGuilddelMember, _onGuilddelMember, TianMing)
-----------------------��������----------------------------------
local function _onPlayLevelUp(actor, cur_level, before_level)
    TianMingFunc[242](actor)
end

GameEvent.add(EventCfg.onPlayLevelUp, _onPlayLevelUp, TianMing)
----------------��ұ仯����-------------------------------
local function _OverloadMoneyJinBi(actor, money)
    if getflagstatus(actor, VarCfg["F_����ʡ�ŵ㻨"]) == 1 then
        TianMingFunc[243](actor)
    end
end
GameEvent.add(EventCfg.OverloadMoneyJinBi, _OverloadMoneyJinBi, TianMing)
----------------�л���ͼ����-------------------------------

local function _goSwitchMap(actor, cur_mapid, former_mapid, x, y)
    local myName = Player.GetName(actor)
    local newMapId = myName .. "y"
    if former_mapid == newMapId then
        if getplaydef(actor, "N$���޶��۽����Ƿ�һ�") == 1 then
            startautoattack(actor)
            setplaydef(actor, "N$���޶��۽����Ƿ�һ�", 0)
        end
    end
end
GameEvent.add(EventCfg.goSwitchMap, _goSwitchMap, TianMing)
-----------------------------����BUFF����---------------------------------
return TianMing
