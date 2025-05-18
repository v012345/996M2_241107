local ZhuangBeiBuffMain = {}
local cfg_ZhuangBeiBuff = include("QuestDiary/cfgcsv/cfg_ZhuangBeiBuff.lua")
local ZhuangBeiBuff = include("QuestDiary/game/A/ZhuangBeiBuffList.lua")
ZhuangBeiBuffMain.ID = "װ��BUFF"
local playerBuffCahce = {}
--��ʼ������
local function initCache(actor)
    playerBuffCahce[actor] = {
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
        }
    }

    for _, value in ipairs(ConstCfg.equipWhere) do
        local equipobj = linkbodyitem(actor, value)
        if equipobj ~= "0" then
            local equipName = getiteminfo(actor, equipobj, ConstCfg.iteminfo.name)
            local cfg = cfg_ZhuangBeiBuff[equipName]
            if cfg then
                if cfg.isAttack == 1 and cfg.buffId ~= nil then
                    local tmpTbl = playerBuffCahce[actor]["����������Ч��"][cfg.attackType]
                    table.insert(tmpTbl, cfg.buffId)
                    table.uniqueArray(tmpTbl) --ɾ���ظ��������BUG
                end
            end
        end
    end
    local suitIds = Player.getJsonTableByVar(actor, VarCfg["T_��¼��װID"])
    if #suitIds > 0 then
        for _, value in ipairs(suitIds) do
            local cfg = cfg_ZhuangBeiBuff[value]
            if cfg then
                if cfg.otherType == 8 and cfg.buffId ~= nil then
                    local tmpTbl = playerBuffCahce[actor]["����������Ч��"][cfg.attackType]
                    table.insert(tmpTbl, cfg.buffId)
                    table.uniqueArray(tmpTbl) --ɾ���ظ��������BUG
                end
            end
        end
    end
end

--���ظ�����
local function reloadInitCache()
    local playerList = getplayerlst()
    for _, actor in ipairs(playerList) do
        if not getbaseinfo(actor, ConstCfg.gbase.offline) then
            initCache(actor)
        end
    end
end

--���ظ�����
reloadInitCache()
-- dump(playerBuffCahce)

--��ȡ����Ĺ���������Ч��
local function onGetZhuangBeiBuff(actor, index)
    if not playerBuffCahce[actor] then
        return {}
    end
    local result = playerBuffCahce[actor]["����������Ч��"][index]
    if not result then
        return {}
    end
    return result
end

--ȫ������������1000��ͷ��
local function _onAttack(actor, Target, Hiter, MagicId)
    local BuffList = onGetZhuangBeiBuff(actor,1) -- {1000,1001}
    if #BuffList > 0 then
        for _, v in ipairs(BuffList) do
            local buffFunc = ZhuangBeiBuff[v]
            if buffFunc then
                buffFunc(actor, Target, Hiter, MagicId)
            end
        end
    end
end
GameEvent.add(EventCfg.onAttack, _onAttack, ZhuangBeiBuffMain)

--�����˴�����2000��ͷ��
local function _onAttackPlayer(actor, Target, Hiter, MagicId)
    local BuffList = onGetZhuangBeiBuff(actor,2)
    if #BuffList > 0 then
        for _, v in ipairs(BuffList) do
            local buffFunc = ZhuangBeiBuff[v]
            if buffFunc then
                buffFunc(actor, Target, Hiter, MagicId)
            end
        end
    end
end
GameEvent.add(EventCfg.onAttackPlayer, _onAttackPlayer, ZhuangBeiBuffMain)

--�������ﴥ����3000��ͷ��
local function _onAttackMonster(actor, Target, Hiter, MagicId)
    local BuffList = onGetZhuangBeiBuff(actor,3)
    if #BuffList > 0 then
        for _, v in ipairs(BuffList) do
            local buffFunc = ZhuangBeiBuff[v]
            if buffFunc then
                buffFunc(actor, Target, Hiter, MagicId)
            end
        end
    end
end
GameEvent.add(EventCfg.onAttackMonster, _onAttackMonster, ZhuangBeiBuffMain)

--ȫ������ǰ��������Ѫǰ����4000��ͷ��
local function _onAttackDamage(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    local BuffList = onGetZhuangBeiBuff(actor,4)
    if #BuffList > 0 then
        for _, v in ipairs(BuffList) do
            local buffFunc = ZhuangBeiBuff[v]
            if buffFunc then
                buffFunc(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
            end
        end
    end
end
GameEvent.add(EventCfg.onAttackDamage, _onAttackDamage, ZhuangBeiBuffMain)

--������ǰ��������Ѫǰ����5000��ͷ��
local function _onAttackDamagePlayer(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    local BuffList = onGetZhuangBeiBuff(actor,5)
    if #BuffList > 0 then
        for _, v in ipairs(BuffList) do
            local buffFunc = ZhuangBeiBuff[v]
            if buffFunc then
                buffFunc(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
            end
        end
    end
end
GameEvent.add(EventCfg.onAttackDamagePlayer, _onAttackDamagePlayer, ZhuangBeiBuffMain)

--��������ǰ��������Ѫǰ����6000��ͷ��
local function _onAttackDamageMonster(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
    local BuffList = onGetZhuangBeiBuff(actor,6)
    if #BuffList > 0 then
        for _, v in ipairs(BuffList) do
            local buffFunc = ZhuangBeiBuff[v]
            if buffFunc then
                buffFunc(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
            end
        end
    end
end
GameEvent.add(EventCfg.onAttackDamageMonster, _onAttackDamageMonster, ZhuangBeiBuffMain)

--��ȫ������������7000��ͷ��-----------------------------------
local function _onStruck(actor, Target, Hiter, MagicId)
    local BuffList = onGetZhuangBeiBuff(actor,7)
    if #BuffList > 0 then
        for _, v in ipairs(BuffList) do
            local buffFunc = ZhuangBeiBuff[v]
            if buffFunc then
                buffFunc(actor, Target, Hiter, MagicId)
            end
        end
    end
end
GameEvent.add(EventCfg.onStruck, _onStruck, ZhuangBeiBuffMain)

--���˹���������8000��ͷ��
local function _onStruckPlayer(actor, Target, Hiter, MagicId)
    local BuffList = onGetZhuangBeiBuff(actor,8)
    if #BuffList > 0 then
        for _, v in ipairs(BuffList) do
            local buffFunc = ZhuangBeiBuff[v]
            if buffFunc then
                buffFunc(actor, Target, Hiter, MagicId)
            end
        end
    end
end
GameEvent.add(EventCfg.onStruckPlayer, _onStruckPlayer, ZhuangBeiBuffMain)

--���ֹ���������9000��ͷ��
local function _onStruckMonster(actor, Target, Hiter, MagicId)
    local BuffList = onGetZhuangBeiBuff(actor,9)
    if #BuffList > 0 then
        for _, v in ipairs(BuffList) do
            local buffFunc = ZhuangBeiBuff[v]
            if buffFunc then
                buffFunc(actor, Target, Hiter, MagicId)
            end
        end
    end
end
GameEvent.add(EventCfg.onStruckMonster, _onStruckMonster, ZhuangBeiBuffMain)

--��ȫ������������10000��ͷ��
local function _onStruckDamage(actor, Target, Hiter, MagicId, Damage, attackDamageData)
    local BuffList = onGetZhuangBeiBuff(actor,10)
    if #BuffList > 0 then
        for _, v in ipairs(BuffList) do
            local buffFunc = ZhuangBeiBuff[v]
            if buffFunc then
                buffFunc(actor, Target, Hiter, MagicId, Damage, attackDamageData)
            end
        end
    end
end
GameEvent.add(EventCfg.onStruckDamage, _onStruckDamage, ZhuangBeiBuffMain)

--����ҹ���������11000��ͷ��
local function _onStruckDamagePlayer(actor, Target, Hiter, MagicId, Damage, attackDamageData)
    local BuffList = onGetZhuangBeiBuff(actor,11)
    if #BuffList > 0 then
        for _, v in ipairs(BuffList) do
            local buffFunc = ZhuangBeiBuff[v]
            if buffFunc then
                buffFunc(actor, Target, Hiter, MagicId, Damage, attackDamageData)
            end
        end
    end
end
GameEvent.add(EventCfg.onStruckDamagePlayer, _onStruckDamagePlayer, ZhuangBeiBuffMain)

--���ֹ���������12000��ͷ��
local function _onStruckDamageMonster(actor, Target, Hiter, MagicId, Damage, attackDamageData)
    local BuffList = onGetZhuangBeiBuff(actor,12)
    if #BuffList > 0 then
        for _, v in ipairs(BuffList) do
            local buffFunc = ZhuangBeiBuff[v]
            if buffFunc then
                buffFunc(actor, Target, Hiter, MagicId, Damage, attackDamageData)
            end
        end
    end
end
GameEvent.add(EventCfg.onStruckDamageMonster, _onStruckDamageMonster, ZhuangBeiBuffMain)
-------------------------------------------��������--------------------------------------------------
--���ﴩװ������
local function _onTakeOnEx(actor, itemobj, where, itemname, makeid)
    if itemname == "�Ž���" then
        addbuff(actor,31067)
        return
    end

    local cfg = cfg_ZhuangBeiBuff[itemname] --��ȡBUFF����
    if cfg then
        if cfg.isAttack == 1 and cfg.buffId ~= nil then
            local tmpTbl = playerBuffCahce[actor]["����������Ч��"][cfg.attackType] --��ȡ��ǰ�����BUFF
            table.insert(tmpTbl, cfg.buffId) --��BUFFID
            table.uniqueArray(tmpTbl) --ɾ���ظ��������BUG
        elseif cfg.isAttack == 0 and cfg.otherType == 1 then
            Player.setAttList(actor, "���Ը���")
        elseif cfg.otherType == 3 then
            Player.setAttList(actor, "��������")
        elseif cfg.isAttack == 0 and cfg.otherType == 4 then
            changelevel(actor, "+", cfg.otherValue)
        elseif cfg.otherType == 6 then
            setflagstatus(actor, cfg.otherValue, 1)
        elseif cfg.otherType == 7 then
            Player.setAttList(actor, "��Ѫ����")
        end
    end
end
GameEvent.add(EventCfg.onTakeOnEx, _onTakeOnEx, ZhuangBeiBuffMain)

--������װ������
local function _onTakeOffEx(actor, itemobj, where, itemname, makeid)
    if itemname == "�Ž���" then
        FkfDelBuff(actor,31067)
        return
    end

    local cfg = cfg_ZhuangBeiBuff[itemname] --��ȡBUFF����
    if cfg then
        local isKuaFu = checkkuafu(actor)
        --�ж��Ƿ��ǹ���������BUFF
        if cfg.isAttack == 1 and cfg.buffId ~= nil then
            local tmpTbl = playerBuffCahce[actor]["����������Ч��"][cfg.attackType] --��ȡ����
            table.removebyvalue(tmpTbl, cfg.buffId, true)
            table.uniqueArray(tmpTbl) --ɾ���ظ��������BUG
        elseif cfg.isAttack == 0 and cfg.otherType == 1 then
            local equipObj = linkbodyitem(actor, where)
            if equipObj == "0" then --û��װ����ִ�У������ظ�ִ�У�
                if isKuaFu then
                    FKuaFuToBenFuEvent(actor,EventCfg.onKTBzhuangBeiBUffShuXing,"")
                else
                    Player.setAttList(actor, "���Ը���")
                end
            end
        elseif cfg.otherType == 3 then
            local equipObj = linkbodyitem(actor, where)
            if equipObj == "0" then --û��װ����ִ�У������ظ�ִ�У�
                if isKuaFu then
                    FKuaFuToBenFuEvent(actor,EventCfg.onKTBzhuangBeiBUffBeiGong,"")
                else
                    Player.setAttList(actor, "��������")
                end
            end
        elseif cfg.isAttack == 0 and cfg.otherType == 4 then --�ȼ��Ӽ�
            if isKuaFu then
                FKuaFuToBenFuEvent(actor,EventCfg.onKTBzhuangBeiBUffLevel,cfg.otherValue)
            else
                changelevel(actor, "-", cfg.otherValue)
            end
        elseif cfg.otherType == 6 then
            setflagstatus(actor, cfg.otherValue, 0)
        elseif cfg.otherType == 7 then
            if isKuaFu then
                FKuaFuToBenFuEvent(actor,EventCfg.onKTBzhuangBeiBUffHuiXue,"")
            else
                Player.setAttList(actor, "��Ѫ����")
            end
        end
    end
end
GameEvent.add(EventCfg.onTakeOffEx, _onTakeOffEx, ZhuangBeiBuffMain)
local function _onKTBzhuangBeiBUffShuXing(actor)
    Player.setAttList(actor, "���Ը���")
end
GameEvent.add(EventCfg.onKTBzhuangBeiBUffShuXing, _onKTBzhuangBeiBUffShuXing, ZhuangBeiBuffMain)
local function _onKTBzhuangBeiBUffBeiGong(actor)
    Player.setAttList(actor, "��������")
end
GameEvent.add(EventCfg.onKTBzhuangBeiBUffBeiGong, _onKTBzhuangBeiBUffBeiGong, ZhuangBeiBuffMain)

local function _onKTBzhuangBeiBUffHuiXue(actor)
    Player.setAttList(actor, "��Ѫ����")
end
GameEvent.add(EventCfg.onKTBzhuangBeiBUffHuiXue, _onKTBzhuangBeiBUffHuiXue, ZhuangBeiBuffMain)
--ȥ���ȼ�
local function _onKTBzhuangBeiBUffLevel(actor, arg1)
    local level = tonumber(arg1) or 0
    changelevel(actor, "-", level)
end
GameEvent.add(EventCfg.onKTBzhuangBeiBUffLevel, _onKTBzhuangBeiBUffLevel, ZhuangBeiBuffMain)
--ɾ��buff
local function _onKTBzhuangBeiBUffDelBuff(actor, arg1)
    local buffid = tonumber(arg1) or 0
    delbuff(actor, buffid)
end
GameEvent.add(EventCfg.onKTBzhuangBeiBUffDelBuff, _onKTBzhuangBeiBUffDelBuff, ZhuangBeiBuffMain)

--����װ����
local function _onGroupItemOnex(actor, idx)
    local cfg = cfg_ZhuangBeiBuff[tostring(idx)] --��ȡBUFF����
    if cfg then
        if cfg.otherType == 8 and cfg.buffId ~= nil then
            local tmpTbl = playerBuffCahce[actor]["����������Ч��"][cfg.attackType] --��ȡ��ǰ�����BUFF
            table.insert(tmpTbl, cfg.buffId) --��BUFFID
            table.uniqueArray(tmpTbl) --ɾ���ظ��������BUG
        elseif cfg.otherType == 8 and cfg.otherValue == 7 then
            Player.setAttList(actor, "��Ѫ����")
        end
    end
end
GameEvent.add(EventCfg.onGroupItemOnEx, _onGroupItemOnex, ZhuangBeiBuffMain)

--����װ����
local function _onGroupItemOffEx(actor, idx)
    local cfg = cfg_ZhuangBeiBuff[tostring(idx)] --��ȡBUFF����
    if cfg then
        if cfg.otherType == 8 and cfg.buffId ~= nil then
            local tmpTbl = playerBuffCahce[actor]["����������Ч��"][cfg.attackType] --��ȡ����
            table.removebyvalue(tmpTbl, cfg.buffId, true)
            table.uniqueArray(tmpTbl) --ɾ���ظ��������BUG
        elseif cfg.otherType == 8 and cfg.otherValue == 7 then
            Player.setAttList(actor, "��Ѫ����")
        end
    end
end
GameEvent.add(EventCfg.onGroupItemOffEx, _onGroupItemOffEx, ZhuangBeiBuffMain)


--�������Դ���
local function _onCalcAttr(actor, attrs)
    --���������ۼ�
    local function calcTable(t, id, num)
        if t[id] == nil then
            t[id] = num
        else
            t[id] = t[id] + num
        end
    end
    local shuxing = {}
    for i = 0, 41, 1 do
        local equipobj = linkbodyitem(actor, i)
        if equipobj ~= "0" then
            local equipName = getiteminfo(actor, equipobj, ConstCfg.iteminfo.name)
            local cfg = cfg_ZhuangBeiBuff[equipName]
            if cfg then
                if cfg.isAttack == 0 and cfg.otherType == 1 then
                    local level = getbaseinfo(actor, ConstCfg.gbase.level)
                    local value = level * cfg.otherValue
                    calcTable(shuxing, 4, value)
                end
            end
        end
    end
    calcAtts(attrs, shuxing, "װ��BUFF")
end
GameEvent.add(EventCfg.onCalcAttr, _onCalcAttr, ZhuangBeiBuffMain)


--����С�˴���--������
local function _onExitGame(actor)
    playerBuffCahce[actor] = nil
end
GameEvent.add(EventCfg.onExitGame, _onExitGame, ZhuangBeiBuffMain)

--��½����
local function _onLoginEnd(actor)
    initCache(actor)
end
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, ZhuangBeiBuffMain)
--�����½
GameEvent.add(EventCfg.onKFLogin, _onLoginEnd, ZhuangBeiBuffMain)
--�������
GameEvent.add(EventCfg.onKuaFuEnd, _onLoginEnd, ZhuangBeiBuffMain)

--ˢ���ҽ�ָ����
local function _onRing_R_AttRefresh(actor, itemobj, number1, number2)
    local tbl1 = json2tbl(getcustomitemprogressbar(actor, itemobj, 0))            --����֮����Ϣ
    local tbl2 = json2tbl(getcustomitemprogressbar(actor, itemobj, 1))            --���ɱ�����Ϣ
    local num1 = tbl1["cur"] * 20       --���㹥����
    local num2 = tbl1["cur"] * 200      --����Ѫ��
    local num3 = tbl2["cur"] * 100       --���㱶��
    setaddnewabil(actor, -2, "=", "3#4#"..num1.."|3#1#"..num2.."|3#67#"..num3.."|", itemobj)
    refreshitem(actor, itemobj)
end

--ɱ�ִ���
local function _onKillMon(actor, monobj)
    local array_6 = onGetZhuangBeiBuff(actor,6)
    if array_6 and #array_6 > 0 then
        if table.contains(array_6, 6004) then
            local onKillMonNum = getplaydef(actor, VarCfg["U_ɱ����������"])
            setplaydef(actor, VarCfg["U_ɱ����������"], onKillMonNum + 1)
        end
    end

    if getflagstatus(actor, VarCfg["F_����֮�񱦲�"]) == 1 then
        local itemobj = linkbodyitem(actor, 26) --��ȡ��Ʒ����
        if itemobj ~= "0" then
            local nowexp = Player.progressbarEX(actor, itemobj, 0, "cur", "��ѯ")
            if type(nowexp) == "number" then
                Player.progressbarEX(actor, itemobj, 0, "cur", "����", nowexp + 1)
                local OpenNumber = getplaydef(actor, VarCfg["J_���俪������"])
                if OpenNumber == 2 then return end
                if nowexp + 1 >= 666 then
                    local num1 = math.random(3, 6)
                    local num2 = math.random(50, 188)
                    local num3 = math.random(10, 30)
                    local userid = getbaseinfo(actor, ConstCfg.gbase.id)
                    local equalid = getiteminfo(actor, monobj, 2)
                    local level = Player.progressbarEX(actor, itemobj, 0, "level", "��ѯ")
                    Player.progressbarEX(actor, itemobj, 0, "cur", "����", 0)
                    Player.progressbarEX(actor, itemobj, 0, "level", "����", level + 1)
                    if level >= 3 then
                        sendmail(userid, equalid, "����֮�񱦲�",
                            "�ڡ�" .. level + 1 .. "����������֮�񱦲�\\����֮�񱦲ظ�װ��������\\��ñ��ؽ���������x" .. num1 .. "��ʯx" .. num3 .. "����ˮ��x" ..
                            num2, "����#" .. num1 .. "&��ʯ#" .. num3 .. "&����ˮ��#" .. num2)
                        setplaydef(actor, VarCfg["J_���俪������"], OpenNumber + 1)
                        local itemname = getconst(actor, "<$SRIGHTHAND>")
                        takew(actor, itemname, 1)
                    else
                        sendmail(userid, equalid, "����֮�񱦲�",
                            "�ڡ�" .. level + 1 .. "����������֮�񱦲�\\��ñ��ؽ���������x" .. num1 .. "��ʯx" .. num3 .. "����ˮ��x" .. num2,
                            "����#" .. num1 .. "&��ʯ#" .. num3 .. "&����ˮ��#" .. num2)
                        setplaydef(actor, VarCfg["J_���俪������"], OpenNumber + 1)
                    end
                end
            end
        end
    end
    --����ħ����ʹ[����] ��ɱ����ʱ�и�������(1��)����ֵ  1/58���� �����������Ϊ[100]�� ÿ������ֵ���ɸ���200������ֵ 10�㹥����
    if checkitemw(actor, "����ħ����ʹ[����]", 1) then
        if randomex(1, 58) then --���� 1/128
            local num = getplaydef(actor, VarCfg["J_�������ɴ���"])
            if num < 100 then --�������ɴ���С��100
                setplaydef(actor, VarCfg["J_�������ɴ���"], num + 1) --���ɴ�����1
                local itemobj = linkbodyitem(actor, 16)
                local itemName = getiteminfo(actor, itemobj, 7)
                local iteminfo = json2tbl(getitemcustomabil(actor, itemobj))
                if iteminfo == "" then
                    local tbl = {
                        ["abil"] = {
                            {
                                ["i"] = 5,
                                ["t"] = "[��������]\\<IMG:3>\\",
                                ["c"] = 251,
                                ["v"] = {
                                    { 0, 1, 1,  0, 31, 0, 1 },
                                    { 0, 4, 20, 0, 32, 1, 2 },
                                },
                            },
                        },
                        ["name"] = itemName .. "[���� + 1]",
                    }
                    setitemcustomabil(actor, itemobj, tbl2json(tbl))
                else
                    local level = iteminfo.abil[6].v[2][3] / 20
                    local maxNum = 999
                    --̰����ֹ������
                    if getflagstatus(actor,VarCfg["F_����_̰����ֹ_���1"]) == 1 then
                        maxNum = maxNum + 333
                    end
                    if getflagstatus(actor,VarCfg["F_����_̰����ֹ_���2"]) == 1 then
                        maxNum = maxNum + 666
                    end
                    if getflagstatus(actor,VarCfg["F_����_̰����ֹ_���3"]) == 1 then
                        maxNum = maxNum + 999
                    end
                    if level < maxNum then
                        level = level + 1
                        setplaydef(actor,VarCfg["U_ħ����ʹ_����_����"],level)
                        local tbl = {
                            ["abil"] = {
                                {
                                    ["i"] = 5,
                                    ["t"] = "[��������]\\<IMG:3>\\",
                                    ["c"] = 251,
                                    ["v"] = {
                                        { 0, 4, 1 * level,  0, 31, 0, 1 },
                                        { 0, 1, 20 * level, 0, 32, 1, 2 },
                                    },
                                },
                            },
                            ["name"] = itemName .. "[���� + " .. level .. "][����:" .. maxNum .. "]",
                        }
                        clearitemcustomabil(actor, itemobj, 5)
                        setitemcustomabil(actor, itemobj, tbl2json(tbl))
                    end
                end
            end
        end
    end
    --���ɻ꡿��֮��Ӱ ��ɱ�����и�������(1��)�ɻ�֮��    ����100
    local itemname = getconst(actor, "<$RING_R>")
    if itemname == "���ɻ꡿��֮��Ӱ" then
        if randomex(1, 128) then --���� 1/128
            local itemobj = linkbodyitem(actor, 7)
            local tbl = json2tbl(getcustomitemprogressbar(actor, itemobj, 0))            --��ȡ��һ����������Ϣ
            if tbl["open"] == 1 and tbl["cur"] < 100  then
                local num = tbl["cur"] + 1
                setcustomitemprogressbar(actor, itemobj, 0, tbl2json({["cur"] = num}))
                _onRing_R_AttRefresh(actor, itemobj)
            end
        end
    end
end
GameEvent.add(EventCfg.onKillMon, _onKillMon, ZhuangBeiBuffMain)

--ɱ�˴���
local function _onkillplay(actor, play)
    -- --���ɻ꡿��֮��Ӱ ��ɱ�����и�������(1��)�ɻ�֮��    ����100
    if getflagstatus(play, VarCfg.F_is_open_kuangbao) == 1 then     --�Ƿ��п�
        local itemname = getconst(actor, "<$RING_R>")
        if itemname == "���ɻ꡿��֮��Ӱ" then
            local itemobj = linkbodyitem(actor, 7)
            local tbl1 = json2tbl(getcustomitemprogressbar(actor, itemobj, 0))            --��ȡ��һ����������Ϣ
            local tbl2 = json2tbl(getcustomitemprogressbar(actor, itemobj, 1))            --��ȡ�ڶ�����������Ϣ
            if tbl1["open"] == 1 and tbl1["cur"] < 100  then
                local num = tbl1["cur"] + 1
                setcustomitemprogressbar(actor, itemobj, 0, tbl2json({["cur"] = num}))
            end
            if tbl2["open"] == 1 and tbl2["cur"] < 10  then
                local num = tbl2["cur"] + 1
                setcustomitemprogressbar(actor, itemobj, 1, tbl2json({["cur"] = num}))
                Player.setAttList(actor, "��������")
            end
         _onRing_R_AttRefresh(actor, itemobj)
        end
    end
end
GameEvent.add(EventCfg.onkillplay, _onkillplay, ZhuangBeiBuffMain)

--���㱶������
local function _onCalcBeiGong(actor, beiGongs)
    for i = 0, 41, 1 do
        local equipobj = linkbodyitem(actor, i)
        if equipobj ~= "0" then
            local equipName = getiteminfo(actor, equipobj, ConstCfg.iteminfo.name)
            local cfg = cfg_ZhuangBeiBuff[equipName]
            if cfg then
                if cfg.otherType == 3 then
                    local value = cfg.otherValue
                    beiGongs[1] = beiGongs[1] + value
                end
            end
        end
    end
end
GameEvent.add(EventCfg.onCalcBeiGong, _onCalcBeiGong, ZhuangBeiBuffMain)

-- �����
local function _onRevive(actor)
    -- ���֮�� �����Ǵ��� ���︴���ض����[100%��������] (�������ʵ�BUFF����ʱ��Ϊ5��)
    if getflagstatus(actor, VarCfg["F_���֮��"]) == 1 then
        changehumnewvalue(actor, 21, 100, 5)
        Player.buffTipsMsg(actor, "[���֮��]:��ñ�������[{+100%/FCOLOR=243}]����[{5/FCOLOR=243}]��...")
    end

    --�������Ѻۡ� ����󴥷�����[50%]����󹥻���(BUFFЧ������5�롤�޷��ظ�����)
    if getconst(actor, "<$BELT>") == "�������Ѻۡ�" then
        local buff = hasbuff(actor, 30044)
        if not buff then
            addbuff(actor, 30044, 5, 1, actor)
            Player.buffTipsMsg(actor, "[�������Ѻۡ�]:����{50%/FCOLOR=243}���������޳���{5/FCOLOR=243}��...")
        end
    end

    --�������� �����︴�����������״̬2�� �´ι�����նɱ����15%������ֵ
    if getconst(actor, "<$HAT>") == "��������" then
        if not Player.checkCd(actor, VarCfg["����CD"], 60, true) then return end

        changemode(actor, 2, 2) --����2����
        setplaydef(actor, VarCfg["S$_��������"], 1)
        Player.buffTipsMsg(actor, "[��������]:��������״̬,����[{1/FCOLOR=243}]��...")
    end

    -- ����֮��  ���︴��󴥷�����[2��]�´ι��� �ض����[3.0]���˺�[CD:30��]
    if checkitemw(actor, "����֮��", 1) then
        if not Player.checkCd(actor, VarCfg["����CD"], 60, true) then return end

        local buffcd = hasbuff(actor, 30029)
        if not buffcd then
            changemode(actor, 2, 2) --����2����
            Player.buffTipsMsg(actor, "[����֮��]:��������״̬,����[{2/FCOLOR=243}]��...")
            setplaydef(actor, VarCfg["S$_����֮��"], 1)
            addbuff(actor, 30029, 30, 1, actor)
        end
    end

    --����֮̾Ϣ��      ����󴥷��������[����״̬10��]�˺�     ����[+20%],�������ֵ[+30%]֮������޵�״̬1��(����CD180��)  [{2/FCOLOR=243}]
    if checkitemw(actor, "����֮̾Ϣ��", 1)  then
        local buffcd = hasbuff(actor, 30025)
        if not buffcd then
            changemode(actor, 1, 1) --�޵�1��
            addbuff(actor, 30034, 10, 1, actor)  --����buff  10��
            addbuff(actor, 30035, 120, 1, actor)
            Player.buffTipsMsg(actor,"[����֮̾Ϣ��]:�޵�{1/FCOLOR=243}�벢����[{����/FCOLOR=243}]״̬,��������[{30%/FCOLOR=243}],�˺���������[{20%/FCOLOR=243}],����[{10/FCOLOR=243}]��...")
        end
    end

    --��գ�ǧ��֮�� ���︴����ܽ���[�޵�״̬]1���� ������ʱ��(50%)�ĸ��ʿ�ԭ������
    if getflagstatus(actor, VarCfg["F_ǧ��֮��"]) == 1 then
        changemode(actor, 1, 1, nil, nil) --�޵�1��
        Player.buffTipsMsg(actor, "[��գ�ǧ��֮��]:�޵�{1/FCOLOR=243}��...")
    end

    --��������һ��ʱ�� ���︴�������(50%)�ı����˺�(BUFF����10�롤ÿ�θ���ɴ���)
    if getflagstatus(actor, VarCfg["F_��������һ��ʱ��"]) == 1 then
        changehumnewvalue(actor, 22, 50, 10) --����50%�����˺� ����10��
        Player.buffTipsMsg(actor, "[��������һ��ʱ��]:�����˺�����{50%/FCOLOR=243},����{10/FCOLOR=243}��...")
    end

    --������� ������������״̬[����]�����´ι������[3.0]���˺���
    if checkitemw(actor, "�������", 1) then
        changemode(actor, 2, 2) --����2����
        setplaydef(actor, VarCfg["S$_�������"], 1)
    end

    -- ����֮��  ���ﴥ�������ÿ��ָ�����[10%]���������ֵ��Ч������(5��)
    if checkitemw(actor, "����֮��", 1) then
        addbuff(actor, 30064, 5, 1, actor)
        Player.buffTipsMsg(actor, "[����֮��]:ÿ��ָ�10%����,����5��...")
    end

    -- ʱ���ɳ©  �����ﴥ��������[�޵�2��],�ڼ��޷������޷��ƶ�!(����ʱ������)
    if checkitemw(actor, "ʱ���ɳ©", 1) then
        if not getbaseinfo(actor, ConstCfg.gbase.issbk) then --���ڹ�������
            changemode(actor, 1, 2, nil, nil)                --�޵�2��
            changemode(actor, 10, 2, nil, nil)               --����2��
            Player.buffTipsMsg(actor, "[ʱ���ɳ©]:�޵�{2/FCOLOR=243}��,���޷��ƶ�...")
        end
    end

    --����ͷ�� ���ﴥ�������ÿ��ָ�����[10%]���������ֵ��Ч������(5��)
    if checkitemw(actor, "����ͷ��", 1) then
        addbuff(actor, 30088, 5, 1, actor)
        Player.buffTipsMsg(actor, "[����ͷ��]:ÿ��ָ�{10%/FCOLOR=243}����,����{5/FCOLOR=243}��...")
    end

    --����� �����������1~2���޵�
    if checkitemw(actor, "�����", 1) then
        local  times = math.random(1, 2)
        changemode(actor, 1, times, nil, nil) --�޵�1��
        Player.buffTipsMsg(actor, "[�����]:�޵�{".. times .."/FCOLOR=243}��...")
    end

end


GameEvent.add(EventCfg.onRevive, _onRevive, ZhuangBeiBuffMain)

return ZhuangBeiBuffMain
