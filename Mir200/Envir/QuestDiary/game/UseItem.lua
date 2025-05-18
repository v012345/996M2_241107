---------------------------------------------------------------------------------------
---------------------------------������ 31����Ʒ���� ������----------------------------------
---------------------------------------------------------------------------------------
local cfg_huichengshi = include("QuestDiary/cfgcsv/cfg_huichengshi.lua")                         --�س�ʯ����
local cfg_map_xz = include("QuestDiary/cfgcsv/cfg_map_xz.lua")                                   --
local cfg_UseItem = include("QuestDiary/cfgcsv/cfg_UseItem.lua")                                 --
local cfg_DianShiChengJin = include("QuestDiary/cfgcsv/cfg_DianShiChengJin.lua")                 --��ʯ�ɽ�
local cfg_GaoJiShenQiMangHe = include("QuestDiary/cfgcsv/cfg_GaoJiShenQiMangHe.lua")             --�߼�����ä��
local cfg_ShenMiZhuanShuMangHe = include("QuestDiary/cfgcsv/cfg_ShenMiZhuanShuMangHe.lua")       --����ר��ä��
local cfg_YongQiHaoYunBaoRandom = include("QuestDiary/cfgcsv/cfg_YongQiHaoYunBaoRandom.lua")     --�������˰����
local cfg_YongQiHaoYunBao = include("QuestDiary/cfgcsv/cfg_YongQiHaoYunBao.lua")                 --�������˰�
local cfg_XianShuChouShenQi = include("QuestDiary/cfgcsv/cfg_XianShuChouShenQi.lua")             --������ȡ��
local cfg_ShenMiGuDongXiangRandom = include("QuestDiary/cfgcsv/cfg_ShenMiGuDongXiangRandom.lua") --���صĹŶ���
local cfg_ShenMiGuDongXiang = include("QuestDiary/cfgcsv/cfg_ShenMiGuDongXiang.lua")             --���صĹŶ���
local cfg_WangDeBaoXiang = include("QuestDiary/cfgcsv/cfg_WangDeBaoXiang.lua")                   --���ı���
local cfg_ShaChengBaoXiang = include("QuestDiary/cfgcsv/cfg_ShaChengBaoXiang.lua")               --ɳ�Ǳ���
--�س�
local function backCity(actor, item)
    local state = false
    if hasbuff(actor, 30089) then
        local buffTime = getbuffinfo(actor, 30089, 2)
        Player.sendmsgEx(actor, string.format("�㱻ʹ����[|�ռ�����#249|],|%s#249|�����޷��س�!", buffTime + 1))
        stop(actor)
        return
    end

    local cfg = cfg_map_xz
    local mapid = getbaseinfo(actor, ConstCfg.gbase.mapid)
    for i = 1, #cfg do
        if mapid == cfg[i]["huicheng"] then --��ֹʹ�س�
            sendmsg(actor, ConstCfg.notice.own, '{"Msg":"<font color=\'#ff0000\'>��ֹʹ�ûس�</font>","Type":9}')
            stop(actor)
            return
        end
    end

    if checkitemw(actor, "��Ԩ֮��", 1) or checkitemw(actor, "�����项", 1) then
        state = true
    end

    local taskID = getplaydef(actor, VarCfg["U_�����������"])
    if taskID < 7 then
        mapmove(actor, "��Դ��", 113, 249, 2)
        stop(actor)
        return
    end

    if getflagstatus(actor, VarCfg["F_������ȥ����"]) == 0 and getflagstatus(actor, VarCfg["F_�ֻ�����"]) == 0 then
        if hasbuff(actor, 10001) and not state then
            local buffTime = getbuffinfo(actor, 10001, 2)
            Player.sendmsgEx(actor, string.format("����ս��[|%s#249|]�����ܻس�", buffTime + 1))
            stop(actor)
            return
        end
    end

    local _MapInfo = Player.getJsonTableByVar(actor, VarCfg["T_���븱����¼�˳���Ϣ"])
    local qyBanMaps = {
        ["��ҹ����"] = true,
        ["��С��"] = true
    }
    if not qyBanMaps[_MapInfo.NowMapID] then
        if _MapInfo.NowMapID ~= nil then
            mapmove(actor, _MapInfo.NowMapID, _MapInfo.NowX, _MapInfo.NowY, 1)
            setplaydef(actor, VarCfg["T_���븱����¼�˳���Ϣ"], "")
            return
        end
    end

    local ncount = getbaseinfo(actor, 38)
    for i = 0, ncount - 1 do
        local mon = getslavebyindex(actor, i)
        killmonbyobj(actor, mon, false, false, true) --ɱ������
    end

    --����С�Ⱥ��֮ŭ��buff �س�ʱ ɾ����buff
    local buffState = hasbuff(actor, 31079)
    if buffState then
        delbuff(actor, 31079)
    end

    if cfg_huichengshi[mapid] ~= nil then
        mapmove(actor, cfg_huichengshi[mapid]["Id"], cfg_huichengshi[mapid]["npc"], cfg_huichengshi[mapid]["npcidx"])
    else
        mapmove(actor, ConstCfg.main_city, 330, 330, 5)
    end
end

local function KFbackCity(actor, item)
    if hasbuff(actor, 30089) then
        local buffTime = getbuffinfo(actor, 30089, 2)
        Player.sendmsgEx(actor, string.format("�㱻ʹ����[|�ռ�����#249|],|%s#249|�����޷��س�!", buffTime + 1))
        stop(actor)
        return
    end

    local cfg = cfg_map_xz
    local mapid = getbaseinfo(actor, ConstCfg.gbase.mapid)
    for i = 1, #cfg do
        if mapid == cfg[i]["huicheng"] then --��ֹʹ�س�
            sendmsg(actor, ConstCfg.notice.own, '{"Msg":"<font color=\'#ff0000\'>��ֹʹ�ûس�</font>","Type":9}')
            stop(actor)
            return
        end
    end

    local taskID = getplaydef(actor, VarCfg["U_�����������"])
    if taskID < 7 then
        mapmove(actor, "��Դ��", 113, 249, 2)
        stop(actor)
        return
    end

    local _MapInfo = Player.getJsonTableByVar(actor, VarCfg["T_���븱����¼�˳���Ϣ"])
    local qyBanMaps = {
        ["��ҹ����"] = true,
        ["��С��"] = true
    }
    if not qyBanMaps[_MapInfo.NowMapID] then
        if _MapInfo.NowMapID ~= nil then
            mapmove(actor, _MapInfo.NowMapID, _MapInfo.NowX, _MapInfo.NowY, 1)
            setplaydef(actor, VarCfg["T_���븱����¼�˳���Ϣ"], "")
            return
        end
    end

    local ncount = getbaseinfo(actor, 38)
    for i = 0, ncount - 1 do
        local mon = getslavebyindex(actor, i)
        killmonbyobj(actor, mon, false, false, true) --ɱ������
    end

    --����С�Ⱥ��֮ŭ��buff �س�ʱ ɾ����buff
    local buffState = hasbuff(actor, 31079)
    if buffState then
        delbuff(actor, 31079)
    end

    if cfg_huichengshi[mapid] ~= nil then
        local result = FMapMoveKF(actor, cfg_huichengshi[mapid]["Id"], cfg_huichengshi[mapid]["npc"],
            cfg_huichengshi[mapid]["npcidx"])
        if not result then
            stop(actor)
        end
    else
        local result = FMapMoveKF(actor, "kuafu2", 136, 166, 5)
        if not result then
            stop(actor)
        end
    end
end

--�������
local suiJiCost = { { "���", 100000 } }
local function randomTransfer(actor)
    if hasbuff(actor, 30089) then
        local buffTime = getbuffinfo(actor, 30089, 2)
        Player.sendmsgEx(actor, string.format("�㱻ʹ����[|�ռ�����#249|],|%s#249|�����޷����!", buffTime + 1))
        stop(actor)
        return
    end

    local cfg = cfg_map_xz
    local mapid = Player.GetVarMap(actor)
    for i = 1, #cfg do
        if mapid == cfg[i]["suiji"] then --��ֹʹ�����
            sendmsg(actor, ConstCfg.notice.own, '{"Msg":"<font color=\'#ff0000\'>��ֹʹ�����</font>","Type":9}')
            stop(actor)
            return
        end
    end

    if getflagstatus(actor, VarCfg["F_������ȥ����"]) == 0 and getflagstatus(actor, VarCfg["F_�ֻ�����"]) == 0 then
        if hasbuff(actor, 10001) then
            local buffTime = getbuffinfo(actor, 10001, 2)
            Player.sendmsgEx(actor, string.format("����ս��[|%s#249|]���������", buffTime + 1))
            stop(actor)
            return
        end
    end

    local mapID = getbaseinfo(actor, ConstCfg.gbase.mapid)
    if mapID == "qipan" then
        local name, num = Player.checkItemNumByTable(actor, suiJiCost)
        if name then
            Player.sendmsgEx(actor, string.format("���|%s#249|����|%d#249|�޷��������!", name, num))
            return
        end
        Player.takeItemByTable(actor, suiJiCost, "���ʯ")
    end

    local GuaJiState = getflagstatus(actor, VarCfg.F_isGuaJi)
    --����ڿ���������ʹ�ü�¼�ı���
    if checkkuafu(actor) then
        map(actor, mapid)
    else
        map(actor, mapID)
    end
    --����һ��漴������һ�
    if GuaJiState == 1 then
        delaygoto(actor, 100, "sui_ji_start_auto_attack", 0)
    end
end

function stdmodefunc1(actor, item) --�س�ʯ
    if getflagstatus(actor, VarCfg["F_��������"]) == 1 then
        stop(actor)
        return
    end
    backCity(actor)
    stop(actor)
end

function stdmodefunc2(actor, item) --���ʯ
    if getflagstatus(actor, VarCfg["F_��������"]) == 1 then
        stop(actor)
        return
    end
    randomTransfer(actor)
    stop(actor)
end

function stdmodefunc3(actor, item) --������ϴ��
    local tab1 = Player.getJsonTableByVar(actor, VarCfg["T_��¼ʯ1"])
    local tab2 = Player.getJsonTableByVar(actor, VarCfg["T_��¼ʯ2"])
    local tab3 = Player.getJsonTableByVar(actor, VarCfg["T_��¼ʯ3"])
    local tab4 = Player.getJsonTableByVar(actor, VarCfg["T_��¼ʯ4"])
    local tab5 = Player.getJsonTableByVar(actor, VarCfg["T_��¼ʯ5"])
    local tab6 = Player.getJsonTableByVar(actor, VarCfg["T_��¼ʯ6"])
    local data = { tab1, tab2, tab3, tab4, tab5, tab6 }
    Message.sendmsg(actor, ssrNetMsgCfg.JiLuShi_OpenUI, 0, 0, 0, data)
    stop(actor)
end

--����س�ʯ
function stdmodefunc4(actor, item)
    -- mapmove(actor, "kuafu2", 136, 166)
    if getflagstatus(actor, VarCfg["F_��������"]) == 1 then
        stop(actor)
        return
    end
    if not checkkuafuconnect() then
        Player.sendmsgEx(actor, "��ǰû�п������,�޷���������ȫ��#249")
        stop(actor)
        return
    end
    local isTime = isTimeInRange(10, 00, 00, 00)
    if not isTime then
        Player.sendmsgEx(actor, string.format("�������ʱ��|10:00-24:00#249"))
        stop(actor)
        return
    end
    KFbackCity(actor)
end

-- function stdmodefunc5(actor, item) --�������ʯ
--     randomTransfer(actor)
--     stop(actor)
-- end

-- function stdmodefunc6(actor, item) --��¼ʯ
--     randomTransfer(actor)
--     stop(actor)
-- end

--�����س�ʯ
function stdmodefunc40(actor, item)
    mapmove(actor, ConstCfg.main_city, 330, 330, 5)
end

--��Ч����ҩ
local zhiLiaoYaoMap = {
    "dixiachengyiceng",
    "dixiachengerceng",
    "dixiachengsanceng",
    "dixiachengdiceng",
}
function stdmodefunc55(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        local bool = false
        local myName = getbaseinfo(actor, ConstCfg.gbase.name)
        for _, value in ipairs(zhiLiaoYaoMap) do
            if FCheckMap(actor, value) then
                bool = true
                break
            end
        end
        for _, value in ipairs(zhiLiaoYaoMap) do
            if FCheckMap(actor, myName .. value) then
                bool = true
                break
            end
        end
        if bool then
            addhpper(actor, "+", 10)
            Player.sendmsgEx(actor, "�������ֵ�ָ���10%")
        else
            Player.sendmsgEx(actor, "ֻ���������³Ǹ�����ʹ��!#249")
            stop(actor)
        end
    end
end

--���Ի�ԭ��
function stdmodefunc56(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        restbonuspoint(actor)
        Player.sendmsgEx(actor, "�������Ե��ѻ�ԭ!")
    end
end

--������ϴ��
function stdmodefunc57(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        setbaseinfo(actor, ConstCfg.sbase.pkvalue, 0)
        Player.sendmsgEx(actor, "����PKֵ�Ѿ���0��")
        GameEvent.push(EventCfg.onUseHongMingQingXiKa, actor)
    end
end

--����ף����
function stdmodefunc58(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        local num = math.random(1, 7)
        callscriptex(actor, "CHANGEITEMADDVALUE", 1, 5, "=", num)
        Player.sendmsgEx(actor, string.format("������������%d������!", num))
    end
end

--���˸���
function stdmodefunc59(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        if not Bag.checkBagEmptyNum(actor, 5) then
            Player.sendmsgEx(actor, "��ı������Ӳ���,��������5���ո�!#249")
            stop(actor)
            return
        end
        local goldNum = math.random(100000, 400000)
        local huanLingShuiJingNum = math.random(1, 9)
        local tianGongZhiChuiNum = math.random(1, 99)
        local fenTianShiNumNum = math.random(1, 99)
        local giveItems = {
            { "����ˮ��", huanLingShuiJingNum },
            { "�칤֮��", tianGongZhiChuiNum },
            { "����ʯ", fenTianShiNumNum },
            { "���", goldNum }
        }
        Player.giveItemByTable(actor, giveItems, "ʹ�����˸���")
        local msgStr = getItemArrToStr(giveItems)
        messagebox(actor, string.format("[ϵͳ��ʾ]�� ��ʹ��[���˸���]��ã�[%s]", msgStr))
    end
end

--����ä�к���
local function OpenMangHe(actor, cfg, desc)
    local index = math.random(#cfg)
    local randomResult = cfg[index]
    if randomResult then
        local itemName = randomResult.value
        giveitem(actor, itemName, 1, ConstCfg.binding, desc)
        messagebox(actor, string.format("[ϵͳ��ʾ]�� ��ʹ��[%s]��ã�[%s]��", desc, itemName))
    end
end
--�߼�����ä��
function stdmodefunc60(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        if not Bag.checkBagEmptyNum(actor, 5) then
            Player.sendmsgEx(actor, "��ı������Ӳ���,��������5���ո�!#249")
            stop(actor)
            return
        end
        OpenMangHe(actor, cfg_GaoJiShenQiMangHe, "�߼�����ä��")
    end
end

--����ר��ä��
function stdmodefunc61(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        if not Bag.checkBagEmptyNum(actor, 5) then
            Player.sendmsgEx(actor, "��ı������Ӳ���,��������5���ո�!#249")
            stop(actor)
            return
        end
        OpenMangHe(actor, cfg_ShenMiZhuanShuMangHe, "����ר��ä��")
    end
end

--��ر�Դ
function stdmodefunc63(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then

    end
end

--���絤
function stdmodefunc64(actor, item)
    --�������ֵ����
    local allMaxCost = { { "���", 500000 } }
    local name, num = Player.checkItemNumByTable(actor, allMaxCost)
    if name then
        Player.sendmsgEx(actor, string.format("���|%s#249|����|%d#249|...", name, num))
        stop(actor)
        return
    end
    Player.takeItemByTable(actor, allMaxCost, "�Ծ��絤�۳�")


    local function AddXiuXianZhi(actor, value)
        if not value or type(value) ~= "number" then
            return
        end
        local currFaBaoExp = getplaydef(actor, VarCfg["U_������ǰ����"])
        local currValue = currFaBaoExp + value
        setplaydef(actor, VarCfg["U_������ǰ����"], currValue)
        local itemObj = linkbodyitem(actor, 43)
        if itemObj == "0" then
            return
        end
        local tbl = {
            ["cur"] = currValue,
        }
        setcustomitemprogressbar(actor, itemObj, 0, tbl2json(tbl))
        refreshitem(actor, itemObj)
    end
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        local value = math.random(100, 300)
        AddXiuXianZhi(actor, value)
        Player.sendmsgEx(actor, string.format("��ķ�������ֵ������%d��!", value))
    end
end

--����ħ����
function stdmodefunc65(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        if getskillinfo(actor, 31, 1) == 3 then
            Player.sendmsgEx(actor, "����ϰ��|[3��ħ����]#249")
            stop(actor)
            return
        end
        delskill(actor, 31)
        addskill(actor, 31, 3)
        Player.sendmsgEx(actor, "��ϲ��ϰ��|[3��ħ����]#249")
    end
end

--�������
function stdmodefunc66(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        if getskillinfo(actor, 75, 1) then
            Player.sendmsgEx(actor, "����ϰ��|[3���������]#249")
            stop(actor)
            return
        end
        addskill(actor, 75, 3)
        Player.sendmsgEx(actor, "��ϲ��ϰ��|[3���������]#249")
    end
end

--�����ı���
function stdmodefunc67(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        if not Bag.checkBagEmptyNum(actor, 5) then
            Player.sendmsgEx(actor, "��ı������Ӳ���!#249")
            stop(actor)
            return
        end
        local itemType = cfg_YongQiHaoYunBaoRandom[math.random(1, #cfg_YongQiHaoYunBaoRandom)]
        local cfg = cfg_YongQiHaoYunBao[itemType.value]
        if cfg.type == 1 then
            local giveNum = 0
            if type(cfg.num) == "table" then
                giveNum = math.random(cfg.num[1], cfg.num[2])
            else
                giveNum = cfg.num
            end
            local giveItems = {
                { cfg.itemName, giveNum },
            }
            Player.giveItemByTable(actor, giveItems, "ʹ�������ı������", 1, true)
            local msgStr = table.concat(giveItems[1], "*")
            Player.sendmsgEx(actor, string.format("[ϵͳ��ʾ]�����[�����ı���]��ã�|[%s]#249", msgStr))
        elseif cfg.type == 0 then
            local result1 = ransjstr("1#80|2#20|3#10", 1, 3)
            result1 = tonumber(result1)
            local equipList = {}
            for i = 1, result1, 1 do
                local randomNum = math.random(1, #cfg_XianShuChouShenQi)
                local cfg = cfg_XianShuChouShenQi[randomNum]
                table.insert(equipList, { cfg.value, 1 })
            end

            Player.giveItemByTable(actor, equipList, "ʹ�������ı���", 1, true)
            local msgStr = getItemArrToStr(equipList)
            Player.sendmsgEx(actor,
                string.format("[ϵͳ��ʾ]�� ���[�����ı���]���%s��������|[%s]#249", formatNumberToChinese(result1), msgStr))
        elseif cfg.type == 2 then
            local randomNum = math.random(10, 30)
            local giveItems = { { "����ʯ", randomNum }, { "�칤֮��", randomNum } }
            Player.giveItemByTable(actor, giveItems, "ʹ�������ı���", 1, true)
            local msgStr = getItemArrToStr(giveItems)
            Player.sendmsgEx(actor, string.format("[ϵͳ��ʾ]�� ���[�����ı���]��ã�|[%s]#249", msgStr))
        end
    end
end

--���عŶ���
function stdmodefunc68(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if not Bag.checkBagEmptyNum(actor, 5) then
        Player.sendmsgEx(actor, "��ı������Ӳ���!#249")
        stop(actor)
        return
    end
    if Bag.checkItemNum(actor, idx, 1) then
        local itemType = cfg_ShenMiGuDongXiangRandom[math.random(1, #cfg_ShenMiGuDongXiangRandom)]
        local cfg = cfg_ShenMiGuDongXiang[itemType.value]
        if cfg.type == 0 then
            local result1 = ransjstr("1#80|2#20|3#10", 1, 3)
            result1 = tonumber(result1)
            local equipList = {}
            for i = 1, result1, 1 do
                local randomNum = math.random(1, #cfg_XianShuChouShenQi)
                local cfg = cfg_XianShuChouShenQi[randomNum]
                table.insert(equipList, { cfg.value, 1 })
            end
            Player.giveItemByTable(actor, equipList, "ʹ�����عŶ���", 1, true)
            local msgStr = getItemArrToStr(equipList)
            Player.sendmsgEx(actor,
                string.format("[ϵͳ��ʾ]�� ���[���عŶ���]���%s��������|[%s]#249", formatNumberToChinese(result1), msgStr))
        elseif cfg.type == 1 then
            local giveNum = 0
            if type(cfg.num) == "table" then
                giveNum = math.random(cfg.num[1], cfg.num[2])
            else
                giveNum = cfg.num
            end
            local giveItems = {
                { cfg.itemName, giveNum },
            }
            Player.giveItemByTable(actor, giveItems, "ʹ�����عŶ���", 1, true)
            local msgStr = table.concat(giveItems[1], "*")
            Player.sendmsgEx(actor, string.format("[ϵͳ��ʾ]�� ���[���عŶ���]��ã�|[%s]#249", msgStr))
        elseif cfg.type == 2 then
            local index = math.random(#cfg_ShenMiZhuanShuMangHe)
            local randomResult = cfg_ShenMiZhuanShuMangHe[index]
            if randomResult then
                local itemName = randomResult.value
                giveitem(actor, itemName, 1, ConstCfg.binding, "ʹ�����عŶ���")
                Player.sendmsgEx(actor, string.format("[ϵͳ��ʾ]�� ���[���عŶ���]���һ��ϡ��ר����|[%s]#249", itemName))
            end
        end
    end
end

--�޸�����
function change_qi_yun(actor)
    local itemNum = getbagitemcount(actor, "���ô���6", 0)
    if itemNum < 1 then
        return
    end
    local gmLv = getgmlevel(actor)
    if gmLv < 10 then
        return
    end
    local inputStr = getconst(actor, "<$NPCINPUT(6)>")
    local strs = string.split(inputStr, "|")
    if strs and type(strs) == "table" then
        local name = strs[1]
        local pos = tonumber(strs[2]) or 0
        local quality = tonumber(strs[3]) or 0
        local value = tonumber(strs[4]) or 0
        local player = getplayerbyname(name)
        if not player or player == "" or player == "0" or not isnotnull(player) then
            return
        end
        if pos == 0 or quality == 0 or value == 0 then
            return
        end
        TianMing.AddTianMing(player, pos, quality, value)
        Player.sendmsgEx(actor, "�޸ĳɹ�")
    end
end

function item_cha_attr(actor)
    local itemNum = getbagitemcount(actor, "���ô���6", 0)
    if itemNum < 1 then
        return
    end
    local gmLv = getgmlevel(actor)
    if gmLv < 10 then
        return
    end
    local inputStr = getconst(actor, "<$NPCINPUT(6)>")
    local strs = string.split(inputStr, "|")
    local name = strs[1]
    local pos = tonumber(strs[2]) or 0
    local player = getplayerbyname(name)
    if not player or player == "" or player == "0" or not isnotnull(player) then
        Player.sendmsgEx(actor, name .. "--������")
        return
    end
    local attrNum = getbaseinfo(player, ConstCfg.gbase.custom_attr, pos)
    Player.sendmsgEx(actor, attrNum)
end

--�޸�����
function stdmodefunc69(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        say(actor, [[<Img|move=0|bg=1|reset=1|img=public_win32/bg_npc_01.png|loadDelay=1|show=4|esc=1>
        <Layout|x=545|y=0|width=80|height=80|link=@exit>
        <Button|x=546|y=0|pimg=public/1900000511.png|nimg=public/1900000510.png|link=@exit>
        <Img|x=58.0|y=66.0|width=200|height=32|scale9r=0|esc=0|scale9b=0|img=public/1900000668.png|scale9l=0|scale9t=0>
        <Input|x=62.0|y=69.0|width=196|height=25|isChatInput=0|inputid=6|size=16|color=255|type=0>
        <Button|x=275.0|y=57.0|nimg=public/00000361.png|submitInput=6|color=255|link=@change_qi_yun>
        <Button|x=275.0|y=100.0|nimg=public/00000361.png|submitInput=6|color=255|link=@item_cha_attr>
        ]])
        stop(actor)
    end
end

--ţ������
function stdmodefunc70(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        local randomNum = math.random(1, 888)
        local gives = { { "�����", randomNum } }
        Player.giveItemByTable(actor, gives, "ʹ��ţ������", 1, true)
        local msgStr = getItemArrToStr(gives)
        messagebox(actor, string.format("[ϵͳ��ʾ]�� ���[ţ������]��ã�[%s]", msgStr))
    end
end

--ţ�������
function stdmodefunc71(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        local randomNum = math.random(1, 888)
        local gives = { { "�����", randomNum } }
        Player.giveItemByTable(actor, gives, "ʹ��ţ�������", 1, true)
        local msgStr = getItemArrToStr(gives)
        messagebox(actor, string.format("[ϵͳ��ʾ]�� ���[ţ�������]��ã�[%s]", msgStr))
    end
end

--ʱ�մ����߾���
function stdmodefunc72(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        local takes = { { "���", 2888 } }
        local name, num = Player.checkItemNumByTable(actor, takes)
        if name then
            Player.sendmsgEx(actor, string.format("[ϵͳ��ʾ]�� ʹ��[ʱ�մ����߾���]��Ҫ|2888�����#249"))
            stop(actor)
            return
        end
        --ʱ������
        -- ʱ������
        if not checktitle(actor, "ʱ������") then
            Player.sendmsgEx(actor, string.format("[ϵͳ��ʾ]�� ʹ��[ʱ�մ����߾���]��Ҫӵ��|[ʱ������]#249|�ƺ�"))
            stop(actor)
            return
        end
        if not checktitle(actor, "ʱ������") then
            Player.sendmsgEx(actor, string.format("[ϵͳ��ʾ]�� ʹ��[ʱ�մ����߾���]��Ҫӵ��|[ʱ������]#249|�ƺ�"))
            stop(actor)
            return
        end
        Player.takeItemByTable(actor, takes, "ʹ��ʱ�մ����߾���")
        deprivetitle(actor, "ʱ������")
        deprivetitle(actor, "ʱ������")
        confertitle(actor, "ʱ�մ�����")
        Player.setAttList(actor, "���ʸ���")
        messagebox(actor, "[ϵͳ��ʾ]��   [ʱ�մ�����]�ƺ��Ѿ�����Ͽ�����һ�°ɣ�")
    end
end

--����!EX�������
function stdmodefunc73(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        if not checkitemw(actor, "ɱ¾��ӡLv.15", 1) then
            Player.sendmsgEx(actor, string.format("[ϵͳ��ʾ]�� ������û�д���|[ɱ¾��ӡLv.15]#249|����ʧ��!"))
            stop(actor)
            return
        end
        local takes = { { "���", 12888 } }
        local name, num = Player.checkItemNumByTable(actor, takes)
        if name then
            Player.sendmsgEx(actor, string.format("[ϵͳ��ʾ]�� ʹ��[����!EX�������]��Ҫ|%s%d#249", name, num))
            stop(actor)
            return
        end
        if not Bag.checkBagEmptyNum(actor, 5) then
            Player.sendmsgEx(actor, "��ı������Ӳ���,��������5���ո�!#249")
            stop(actor)
            return
        end
        Player.takeItemByTable(actor, takes, "ʹ��ʱ��EX�������")
        takew(actor, "ɱ¾��ӡLv.15", 1)
        giveonitem(actor, 12, "��EX��������", 1, ConstCfg.binding)
        Player.sendmsgEx(actor, string.format("[ϵͳ��ʾ]�� ��ʹ��[����!EX�������]���ɹ�����|[��EX��������]#249|��Ϊ���Զ�����!"))
    end
end

--���ı���
function stdmodefunc74(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        local gives = { { "����Կ��", 1 } }
        local name, num = Player.checkItemNumByTable(actor, gives)
        if name then
            Player.sendmsgEx(actor, "��û��|[����Կ��]#249|��������ʧ��!")
            stop(actor)
            return
        end
        if not Bag.checkBagEmptyNum(actor, 5) then
            Player.sendmsgEx(actor, "��ı������Ӳ���,��������5���ո�!#249")
            stop(actor)
            return
        end
        Player.takeItemByTable(actor, gives, "ʹ�����ı���")
        local index = ransjstr("1#40|2#20|3#10|4#5|5#5|6#5|7#5|8#5|9#5|10#4|11#3|12#2|13#1|14#20", 1, 3)
        index = tonumber(index)
        local cfg = cfg_WangDeBaoXiang[index]
        local giveGold = { { "�󶨽��", 5000000 } }
        Player.giveItemByTable(actor, giveGold, "ʹ�����ı���")
        if not cfg then
            Player.sendmsgEx(actor, "���ź�,��ֻ��ȡ��500W���!")
            return
        end
        if index == 3 or index == 11 then
            local gives = {}
            for i = 1, 2, 1 do
                local randomNum = math.random(#cfg.items)
                local item = { cfg.items[randomNum], 1 }
                table.insert(gives, item)
            end
            Player.giveItemByTable(actor, gives, "�������ı���", 1, true)
            local msgStr = getItemArrToStr(gives)
            messagebox(actor, string.format("�㿪��[���ı���]���%s:[%s]", cfg.name or "", msgStr))
        else
            local num = 0
            if type(cfg.num) == "table" then
                num = math.random(cfg.num[1], cfg.num[2])
            else
                num = cfg.num
            end
            local randomNum = math.random(#cfg.items)
            local gives = { { cfg.items[randomNum], num } }
            Player.giveItemByTable(actor, gives, "�������ı���", 1, true)
            local msgStr = getItemArrToStr(gives)
            messagebox(actor, string.format("�㿪��[���ı���]���%s:[%s]", cfg.name or "", msgStr))
        end
    end
end

--�۱���[��ӡ]
function stdmodefunc75(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        local cost = { { "����ˮ��", 388 }, { "��ʯ", 20 } }
        local name, num = Player.checkItemNumByTable(actor, cost)
        if name then
            Player.sendmsgEx(actor, string.format("�۱���[����]����ʧ��,���|%s#249|����|%d#249", name, num))
            stop(actor)
            return
        end
        if not Bag.checkBagEmptyNum(actor, 5) then
            Player.sendmsgEx(actor, "��ı������Ӳ���,��������5���ո�!#249")
            stop(actor)
            return
        end
        Player.takeItemByTable(actor, cost, "�۱���[��ӡ]����")
        local itemObj = giveitem(actor, "�۱���[����]", 1, 0, "�۱���[��ӡ]����")
        local huiAddition = math.random(20, 88)
        setaddnewabil(actor, -2, "=", "3#216#" .. huiAddition, itemObj)
        Player.sendmsgEx(actor, "���Ѿ��ɹ������|�۱���[����]#249|���ռӳ�+|" .. huiAddition .. "%#249")
    end
end

local moJieKuLouWangList = { "ħ�䡤������(A)", "ħ�䡤������(A)", "ħ�䡤������(A)", "ħ�䡤������(A)", "ħ�䡤������(A)", "ħ�䡤������(S)", "ħ�䡤������(S)",
    "ħ�䡤������(S)", "ħ�䡤������(S)", "ħ�䡤������(SR)", "ħ�䡤������(SR)", "ħ�䡤������(SR)", "ħ�䡤������(SSR)", "ħ�䡤������(SSR)", "ħ�䡤������(SSSR)" }
--�̺�ħ���İ׹�
function stdmodefunc76(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        local cost = { { "����ˮ��", 888 }, { "��ʯ", 38 }, { "���", 30000000 } }
        local name, num = Player.checkItemNumByTable(actor, cost)
        if name then
            Player.sendmsgEx(actor, string.format("[ϵͳ��ʾ]�� ����ʧ��,���|%s#249|����|%s#249", name, num))
            stop(actor)
            return
        end
        if not Bag.checkBagEmptyNum(actor, 5) then
            Player.sendmsgEx(actor, "��ı������Ӳ���,��������5���ո�!#249")
            stop(actor)
            return
        end
        Player.takeItemByTable(actor, cost, "ʹ���̺�ħ���İ׹�")
        local index = math.random(#moJieKuLouWangList)
        local equipName = moJieKuLouWangList[index]
        local gives = { { equipName, 1 } }
        Player.giveItemByTable(actor, gives, "ʹ���̺�ħ���İ׹�", 1, true)
        messagebox(actor, string.format("[ϵͳ��ʾ]�� ��ɹ������[%s]", equipName))
    end
end

--�����̤λ���
function stdmodefunc77(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        changehumnewvalue(actor, 204, 50, 1800)
        Player.sendmsgEx(actor, "��ı���������50%,����30����!")
    end
end

--@�����Ĵ���
-- function stdmodefunc78(actor, item)
--     local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
--     if Bag.checkItemNum(actor, idx, 1) then
--         if getflagstatus(actor, VarCfg["F_�����Ĵ�����Ʒʹ��"]) == 1 then
--             Player.sendmsgEx(actor, "[�����Ĵ���]ֻ��ʹ��һ��!#249")
--             stop(actor)
--             return
--         end
--         setflagstatus(actor, VarCfg["F_�����Ĵ�����Ʒʹ��"], 1)
--         Player.sendmsgEx(actor, "[�����Ĵ���]����Ч!")
--         Player.setAttList(actor, "���Ը���")
--         messagebox(actor, "[ϵͳ��ʾ]�� �����˹����Ĵ��У��Ѿ����Ӵ������ԣ�")
--     end
-- end

--����ӡ�Ľ���
local beiFengYinDeJianLing = { "����ӡ�Ľ���(A)", "����ӡ�Ľ���(A)", "����ӡ�Ľ���(A)", "����ӡ�Ľ���(A)", "����ӡ�Ľ���(A)", "����ӡ�Ľ���(S)", "����ӡ�Ľ���(S)",
    "����ӡ�Ľ���(S)", "����ӡ�Ľ���(S)", "����ӡ�Ľ���(SR)", "����ӡ�Ľ���(SR)", "����ӡ�Ľ���(SR)", "����ӡ�Ľ���(SSR)", "����ӡ�Ľ���(SSR)", "����ӡ�Ľ���(SSSR)",
    "����ӡ�Ľ���(A)", "����ӡ�Ľ���(A)", "����ӡ�Ľ���(A)", "����ӡ�Ľ���(A)", "����ӡ�Ľ���(A)", "����ӡ�Ľ���(S)", "����ӡ�Ľ���(S)", "����ӡ�Ľ���(S)", "����ӡ�Ľ���(S)",
    "����ӡ�Ľ���(SR)", "����ӡ�Ľ���(SR)", "����ӡ�Ľ���(SR)", "����ӡ�Ľ���(SSR)", "����ӡ�Ľ���(SSR)", "����ӡ�Ľ���(A)", "����ӡ�Ľ���(A)", "����ӡ�Ľ���(A)",
    "����ӡ�Ľ���(A)", "����ӡ�Ľ���(A)", "����ӡ�Ľ���(S)", "����ӡ�Ľ���(S)", "����ӡ�Ľ���(S)", "����ӡ�Ľ���(S)", "����ӡ�Ľ���(SR)", "����ӡ�Ľ���(SR)",
    "����ӡ�Ľ���(SR)", "����ӡ�Ľ���(SSR)", "����ӡ�Ľ���(SSR)", "����ӡ�Ľ���(A)", "����ӡ�Ľ���(A)", "����ӡ�Ľ���(A)", "����ӡ�Ľ���(A)", "����ӡ�Ľ���(A)",
    "����ӡ�Ľ���(S)", "����ӡ�Ľ���(S)", "����ӡ�Ľ���(S)", "����ӡ�Ľ���(S)", "����ӡ�Ľ���(SR)", "����ӡ�Ľ���(SR)", "����ӡ�Ľ���(SR)", "����ӡ�Ľ���(SSR)",
    "����ӡ�Ľ���(SSR)", "����ӡ�Ľ���(A)", "����ӡ�Ľ���(A)", "����ӡ�Ľ���(A)", "����ӡ�Ľ���(A)", "����ӡ�Ľ���(A)", "����ӡ�Ľ���(S)", "����ӡ�Ľ���(S)", "����ӡ�Ľ���(S)",
    "����ӡ�Ľ���(S)", "����ӡ�Ľ���(SR)", "����ӡ�Ľ���(SR)", "����ӡ�Ľ���(SR)", "����ӡ�Ľ���(SSR)", "����ӡ�Ľ���(SSR)", "����ӡ�Ľ���(A)", "����ӡ�Ľ���(A)",
    "����ӡ�Ľ���(A)", "����ӡ�Ľ���(A)", "����ӡ�Ľ���(A)", "����ӡ�Ľ���(S)", "����ӡ�Ľ���(S)", "����ӡ�Ľ���(S)", "����ӡ�Ľ���(S)", "����ӡ�Ľ���(SR)", "����ӡ�Ľ���(SR)",
    "����ӡ�Ľ���(SR)", "����ӡ�Ľ���(SSR)", "����ӡ�Ľ���(SSR)" }
function stdmodefunc79(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        if not Bag.checkBagEmptyNum(actor, 5) then
            Player.sendmsgEx(actor, "��ı������Ӳ���,��������5���ո�!#249")
            stop(actor)
            return
        end
        local index = math.random(#beiFengYinDeJianLing)
        local equipName = beiFengYinDeJianLing[index]
        local gives = { { equipName, 1 } }
        Player.giveItemByTable(actor, gives, "ʹ���̺�ħ���İ׹�", 1, true)
        messagebox(actor, string.format("[ϵͳ��ʾ]�� ��ɹ������[%s]", equipName))
    end
end

--����֮��
-- function stdmodefunc80(actor, item)
--     local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
--     if Bag.checkItemNum(actor, idx, 1) then
--         local attackAttrNum = getplaydef(actor, VarCfg["U_����֮�����Լ�¼"])
--         if attackAttrNum > 249 then
--             Player.sendmsgEx(actor, "����õĽ���֮���Ѿ��ﵽ������ޣ�#249")
--             stop(actor)
--         else
--             setplaydef(actor, VarCfg["U_����֮�����Լ�¼"], attackAttrNum + 50)
--             local itemObj = linkbodyitem(actor, 1)
--             setitemaddvalue(actor, itemObj, 1, 2, attackAttrNum + 50)
--             Player.sendmsgEx(actor, string.format("�����Ѿ����Ӷ�������,��ǰ����Ϊ:|%s#249|�㹥��", attackAttrNum + 50))
--         end
--     end
-- end

--����ӡ�Ĺײ�
local beiFengYinDeGuanCai = { "����Ź�", "����Ź�", "����Ź�", "����Ź�", "����Ź�", "ǧ��Ź�", "ǧ��Ź�", "ǧ��Ź�", "ǧ��Ź�", "ǧ��Ź�", "ǧ��Ź�",
    "ǧ��Ź�", "����Ź�",
    "����Ź�", "ʮ����Ź�" }
function stdmodefunc81(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        local cost = { { "����ˮ��", 1888 }, { "��ʯ", 38 }, { "���", 15000000 } }
        local name, num = Player.checkItemNumByTable(actor, cost)
        if name then
            Player.sendmsgEx(actor, string.format("[ϵͳ��ʾ]�� ����ʧ��,���|%s#249|����|%s#249", name, num))
            stop(actor)
            return
        end
        if not Bag.checkBagEmptyNum(actor, 5) then
            Player.sendmsgEx(actor, "��ı������Ӳ���,��������5���ո�!#249")
            stop(actor)
            return
        end
        Player.takeItemByTable(actor, cost, "ʹ�ñ���ӡ�Ĺײ�")
        local index = math.random(#beiFengYinDeGuanCai)
        local equipName = beiFengYinDeGuanCai[index]
        local gives = { { equipName, 1 } }
        Player.giveItemByTable(actor, gives, "ʹ�ñ���ӡ�Ĺײ�", 1, true)
        messagebox(actor, string.format("[ϵͳ��ʾ]�� ��ɹ������[%s]", equipName))
        FSetTaskRedPoint(actor, VarCfg["F_����ӡ�Ĺײ�ʹ��_���"], 12)
    end
end

--�İ��Ĺ���֮��
function stdmodefunc82(actor, item)
    local youAnDeGuShenZhiXiang = { { "������Ѫ", 34, 300 }, { "��ֱ���", 204, 88 }, { "�Թ�����", 75, 1200 }, { "��󹥻���", 210, 5 }, { "�������ֵ", 208, 5 } }
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    local lastUseTime = getplaydef(actor, VarCfg["U_�İ��Ĺ���֮��ʱ���¼"])
    if lastUseTime > os.time() then
        messagebox(actor, "[ϵͳ��ʾ]���㻹û�е��������֮���ʱ����أ�")
        stop(actor)
        return
    end
    if Bag.checkItemNum(actor, idx, 1) then
        local num = 0
        if randomex(50) then
            num = 2
        else
            num = 1
        end
        local atts = {}
        local tips = {}
        local tipsList = {}
        for i = 1, num, 1 do
            local index = math.random(1, #youAnDeGuShenZhiXiang)
            local element = youAnDeGuShenZhiXiang[index]
            table.remove(youAnDeGuShenZhiXiang, index)
            table.insert(atts, { element[2], element[3] })
            local showAttr
            if element[2] == 34 or element[2] == 75 then
                showAttr = element[3] / 100
            else
                showAttr = element[3]
            end
            tips = { element[1], showAttr }
            table.insert(tipsList, tips)
        end
        Player.setJsonVarByTable(actor, VarCfg["T_�İ��Ĺ���֮�����Լ�¼"], atts)
        local attrStrArray = {}
        for _, value in ipairs(tipsList) do
            local tmpStr = table.concat(value, "����") .. "%"
            table.insert(attrStrArray, tmpStr)
        end
        local msgStr = table.concat(attrStrArray, "��")
        messagebox(actor, string.format("[ϵͳ��ʾ]�����Ѿ���������������%s��", msgStr))
        Player.setAttList(actor, "���Ը���")
        setplaydef(actor, VarCfg["U_�İ��Ĺ���֮��ʱ���¼"], os.time() + 7200)
    end
end

local qiHeiDeDao = { "ħ�С��ɻ�(A)", "ħ�С��ɻ�(A)", "ħ�С��ɻ�(A)", "ħ�С��ɻ�(A)", "ħ�С��ɻ�(A)", "ħ�С��ɻ�(S)", "ħ�С��ɻ�(S)", "ħ�С��ɻ�(S)",
    "ħ�С��ɻ�(S)", "ħ�С��ɻ�(SR)", "ħ�С��ɻ�(SR)", "ħ�С��ɻ�(SR)", "ħ�С��ɻ�(SSR)", "ħ�С��ɻ�(SSR)", "ħ�С��ɻ�(SSSR)" }
--��ڵĵ�
function stdmodefunc83(actor, item)
    local cost = { { "����ˮ��", 1888 }, { "��ʯ", 38 }, { "���", 50000000 } }
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        local name, num = Player.checkItemNumByTable(actor, cost)
        if name then
            Player.sendmsgEx(actor, string.format("[ϵͳ��ʾ]�� ����ʧ��,���|%s#249|����|%s#249", name, num))
            stop(actor)
            return
        end
        if not Bag.checkBagEmptyNum(actor, 5) then
            Player.sendmsgEx(actor, "��ı������Ӳ���,��������5���ո�!#249")
            stop(actor)
            return
        end
        Player.takeItemByTable(actor, cost, "ʹ����ڵĵ�")
        local index = math.random(#qiHeiDeDao)
        local equipName = qiHeiDeDao[index]
        local gives = { { equipName, 1 } }
        Player.giveItemByTable(actor, gives, "ʹ����ڵĵ�", 1, true)
        messagebox(actor, string.format("[ϵͳ��ʾ]�� ��ɹ������[%s]", equipName))
    end
end

--����?
local diGuoShenLong = { "�۹�������(������)", "�۹�������(������)", "�۹�������(������)", "�۹�������(������)", "�۹�������(������)", "�۹�������(�ɳ���)", "�۹�������(�ɳ���)",
    "�۹�������(�ɳ���)", "�۹�������(�ɳ���)", "�۹�������(������)", "�۹�������(������)", "�۹�������(������)", "�۹�������(��ȫ��)", "�۹�������(��ȫ��)", "�۹�������(������)" }
function stdmodefunc84(actor, item)
    local cost = { { "����ˮ��", 1888 }, { "��ʯ", 38 }, { "���", 50000000 } }
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        local name, num = Player.checkItemNumByTable(actor, cost)
        if name then
            Player.sendmsgEx(actor, string.format("[ϵͳ��ʾ]�� ����ʧ��,���|%s#249|����|%s#249", name, num))
            stop(actor)
            return
        end
        if not Bag.checkBagEmptyNum(actor, 5) then
            Player.sendmsgEx(actor, "��ı������Ӳ���,��������5���ո�!#249")
            stop(actor)
            return
        end
        Player.takeItemByTable(actor, cost, "ʹ������")
        local index = math.random(#diGuoShenLong)
        local equipName = diGuoShenLong[index]
        local gives = { { equipName, 1 } }
        Player.giveItemByTable(actor, gives, "ʹ������", 1, true)
        messagebox(actor, string.format("[ϵͳ��ʾ]�� ��ɹ������[%s]", equipName))
    end
end

--ʱ�������ƺž�
function stdmodefunc85(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        if checktitle(actor, "ʱ�մ�����") then
            messagebox(actor, "[ϵͳ��ʾ]�����Ѿ�ӵ��ʱʱ�մ����ߺţ�")
            stop(actor)
            return
        end
        if checktitle(actor, "ʱ������") then
            messagebox(actor, "[ϵͳ��ʾ]�����Ѿ�ӵ��ʱ�������ƺţ�")
            stop(actor)
            return
        else
            confertitle(actor, "ʱ������")
            messagebox(actor, "[ϵͳ��ʾ]���Ѿ���Ϊʱ�����������Դ������ӣ�")
        end
    end
end

--ʱ�����˳ƺž�
function stdmodefunc86(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        if Bag.checkItemNum(actor, idx, 1) then
            if checktitle(actor, "ʱ�մ�����") then
                messagebox(actor, "[ϵͳ��ʾ]�����Ѿ�ӵ��ʱʱ�մ����ߺţ�")
                stop(actor)
                return
            end
            if checktitle(actor, "ʱ������") then
                messagebox(actor, "[ϵͳ��ʾ]�����Ѿ�ӵ��ʱ�����˳ƺţ�")
                stop(actor)
                return
            else
                confertitle(actor, "ʱ������")
                messagebox(actor, "[ϵͳ��ʾ]���Ѿ���Ϊʱ�����ˣ����Դ������ӣ�")
            end
        end
    end
end

local guiHuaFu = { "����(A)", "����(A)", "����(A)", "����(A)", "����(A)", "����(S)", "����(S)", "����(S)", "����(S)", "����(SR)",
    "����(SR)", "����(SR)", "����(SSR)", "����(SSR)", "����(SSSR)" }
--һ�����ҵ�ֽ
function stdmodefunc87(actor, item)
    local cost = { { "����ˮ��", 3888 }, { "��ʯ", 88 }, { "���", 80000000 } }
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        local name, num = Player.checkItemNumByTable(actor, cost)
        if name then
            Player.sendmsgEx(actor, string.format("[ϵͳ��ʾ]�� ����ʧ��,���|%s#249|����|%s#249", name, num))
            stop(actor)
            return
        end
        if not Bag.checkBagEmptyNum(actor, 5) then
            Player.sendmsgEx(actor, "��ı������Ӳ���,��������5���ո�!#249")
            stop(actor)
            return
        end
        Player.takeItemByTable(actor, cost, "ʹ��һ�����ҵ�ֽ")
        local index = math.random(#guiHuaFu)
        local equipName = guiHuaFu[index]
        local gives = { { equipName, 1 } }
        Player.giveItemByTable(actor, gives, "ʹ��һ�����ҵ�ֽ", 1, true)
        messagebox(actor, string.format("[ϵͳ��ʾ]�� ��ɹ������[%s]", equipName))
    end
end

--����֮�һ����޵�1
function stdmodefunc88(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
    end
end

--�������(�ƺž�)
function stdmodefunc89(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        if Bag.checkItemNum(actor, idx, 1) then
            if checktitle(actor, "�������") then
                messagebox(actor, "[ϵͳ��ʾ]�����Ѿ�ӵ��������˳ƺţ�")
                stop(actor)
                return
            else
                confertitle(actor, "�������", 1)
                messagebox(actor, "[ϵͳ��ʾ]���Ѿ���Ϊ������ˣ����Դ������ӣ�")
            end
        end
    end
end

--����é®�ƺž�
function stdmodefunc90(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        if Bag.checkItemNum(actor, idx, 1) then
            if checktitle(actor, "����é®") then
                messagebox(actor, "[ϵͳ��ʾ]�����Ѿ�ӵ�г���é®�ƺţ�")
                stop(actor)
                return
            else
                confertitle(actor, "����é®")
                messagebox(actor, "[ϵͳ��ʾ]���Ѿ���Ϊ����é®�����Դ������ӣ�")
            end
        end
    end
end

--����ţ��(�ƺž�)
function stdmodefunc92(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        if Bag.checkItemNum(actor, idx, 1) then
            if checktitle(actor, "����ţ��") then
                messagebox(actor, "[ϵͳ��ʾ]�����Ѿ�ӵ�в���ţ��ƺţ�")
                stop(actor)
                return
            else
                confertitle(actor, "����ţ��", 1)
                Player.setAttList(actor, "���Ը���")
                messagebox(actor, "[ϵͳ��ʾ]���Ѿ���Ϊ����ţ�����Դ������ӣ�")
            end
        end
    end
end

--�������[�ƺ�]
function stdmodefunc93(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        if Bag.checkItemNum(actor, idx, 1) then
            if checktitle(actor, "�������") then
                messagebox(actor, "[ϵͳ��ʾ]�����Ѿ�ӵ�й������ƺţ�")
                stop(actor)
                return
            else
                confertitle(actor, "�������", 1)
                Player.setAttList(actor, "���Ը���")
                messagebox(actor, "[ϵͳ��ʾ]���Ѿ�ӵ�й������ƺţ�")
            end
        end
    end
end

--��������[�ƺ�]
function stdmodefunc94(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        if Bag.checkItemNum(actor, idx, 1) then
            if checktitle(actor, "��������") then
                messagebox(actor, "[ϵͳ��ʾ]�����Ѿ�ӵ�ж������³ƺţ�")
                stop(actor)
                return
            else
                confertitle(actor, "��������", 1)
                Player.setAttList(actor, "���Ը���")
                messagebox(actor, "[ϵͳ��ʾ]����ϲ����[��������]�ƺţ�")
            end
        end
    end
end

function stdmodefunc96(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        if Bag.checkItemNum(actor, idx, 1) then
            if checktitle(actor, "һ�ٶ��") then
                messagebox(actor, "[ϵͳ��ʾ]�����Ѿ�ӵ��һ�ٶ���ƺţ�")
                stop(actor)
                return
            else
                confertitle(actor, "һ�ٶ��", 1)
                Player.setAttList(actor, "���Ը���")
                messagebox(actor, "[ϵͳ��ʾ]����ϲ����[һ�ٶ��]�ƺţ�")
            end
        end
    end
end

function stdmodefunc97(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        if Bag.checkItemNum(actor, idx, 1) then
            if checktitle(actor, "���µ�һ") then
                messagebox(actor, "[ϵͳ��ʾ]�����Ѿ�ӵ�����µ�һ�ƺţ�")
                stop(actor)
                return
            else
                confertitle(actor, "���µ�һ", 1)
                Player.setAttList(actor, "���Ը���")
                messagebox(actor, "[ϵͳ��ʾ]����ϲ����[���µ�һ]�ƺţ�")
            end
        end
    end
end

--if not checktitle(actor,GuanMing.config[1].title) then
--    confertitle(actor,GuanMing.config[1].title,1)
--end
--�����ʹ��
function stdmodefunc100(actor, item)
    if not item then
        return
    end
    local itemName = getiteminfo(actor, item, ConstCfg.iteminfo.name)
    local value = cfg_UseItem[itemName]
    if value then
        local itemNum = getiteminfo(actor, item, ConstCfg.iteminfo.overlap)
        if itemNum <= 0 then
            return
        end
        local makeId = getiteminfo(actor, item, ConstCfg.iteminfo.id)
        local total = value.value * itemNum
        if checkitemw(actor, "ţ������ӡ", 1) then
            if randomex(20) then
                total = total * 2
            end
        end
        if getflagstatus(actor, VarCfg["F_����_����ѧԺ��ʶ"]) == 1 then
            local addtion = getplaydef(actor, VarCfg["N$����ѧԺ����ӳ�"])
            total = total + math.floor(total * addtion / 100)
        end
        local data = splitLargeNumber(4000000000, total)
        if #data > 0 then
            local liveMax = getplaydef(actor, VarCfg["U_�ȼ�����"])
            local myLevel = getbaseinfo(actor, ConstCfg.gbase.level)
            if myLevel < liveMax then
                for _, v in ipairs(data) do
                    changeexp(actor, "+", v, false)
                end
            else
                sendmsg(actor, 1,
                    '{"Msg":"��ĵȼ��Ѿ��ﵽ����,ʹ�þ�����޷�������þ���!","FColor":255,"BColor":249,"Type":1,"Time":3,"SendName":"��ʾ","SendId":"123"}')
            end
            delitembymakeindex(actor, makeId, itemNum, "ʹ����Ʒ")
        end
    end
    stop(actor)
end

--Ԫ����ʹ��
function stdmodefunc101(actor, item)
    if not item then
        return
    end
    local itemName = getiteminfo(actor, item, ConstCfg.iteminfo.name)
    local value = cfg_UseItem[itemName]
    if value then
        local itemNum = getiteminfo(actor, item, ConstCfg.iteminfo.overlap)
        if itemNum <= 0 then
            return
        end
        local makeId = getiteminfo(actor, item, ConstCfg.iteminfo.id)
        local total = value.value * itemNum
        local data = splitLargeNumber(2000000000, total)
        if #data > 0 then
            for _, v in ipairs(data) do
                changemoney(actor, 2, "+", v, "ʹ����Ʒ:" .. itemName, true)
            end
            delitembymakeindex(actor, makeId, itemNum, "ʹ����Ʒ")
        end
    end
    stop(actor)
end

--��Һ��
function stdmodefunc102(actor, item)
    if not item then
        return
    end
    local itemName = getiteminfo(actor, item, ConstCfg.iteminfo.name)
    local value = cfg_UseItem[itemName]
    if value then
        local itemNum = getiteminfo(actor, item, ConstCfg.iteminfo.overlap)
        if itemNum <= 0 then
            return
        end
        local makeId = getiteminfo(actor, item, ConstCfg.iteminfo.id)
        local value = math.random(value.value[1], value.value[2])
        local total = value * itemNum
        if checkitemw(actor, "ţ������ӡ", 1) then
            if randomex(20) then
                total = total * 2
            end
        end
        local data = splitLargeNumber(2000000000, total)
        local goldId = FGetBindGoldId(actor)
        if #data > 0 then
            for _, v in ipairs(data) do
                changemoney(actor, goldId, "+", v, "ʹ����Ʒ:" .. itemName, true)
            end
            delitembymakeindex(actor, makeId, itemNum, "ʹ����Ʒ")
        end
    end
    stop(actor)
end

--������
function stdmodefunc103(actor, item)
    if not item then
        return
    end
    local itemName = getiteminfo(actor, item, ConstCfg.iteminfo.name)
    local value = cfg_UseItem[itemName]
    if value then
        local itemNum = getiteminfo(actor, item, ConstCfg.iteminfo.overlap)
        if itemNum <= 0 then
            return
        end
        local makeId = getiteminfo(actor, item, ConstCfg.iteminfo.id)
        local randomValue = math.random(value.value[1], value.value[2])
        local total = randomValue * itemNum
        local data = splitLargeNumber(2000000000, total)
        if #data > 0 then
            for _, v in ipairs(data) do
                changemoney(actor, 20, "+", v, "ʹ����Ʒ:" .. itemName, true)
            end
            delitembymakeindex(actor, makeId, itemNum, "ʹ����Ʒ")
        end
    end
    stop(actor)
end

--����
function stdmodefunc104(actor, item)
    if not item then
        return
    end
    local itemName = getiteminfo(actor, item, ConstCfg.iteminfo.name)
    local value = cfg_UseItem[itemName]
    if value then
        local itemNum = getiteminfo(actor, item, ConstCfg.iteminfo.overlap)
        if itemNum <= 0 then
            return
        end
        local makeId = getiteminfo(actor, item, ConstCfg.iteminfo.id)
        local total = value.value * itemNum
        local data = splitLargeNumber(2000000000, total)
        local goldId = FGetBindGoldId(actor)
        if #data > 0 then
            for _, v in ipairs(data) do
                changemoney(actor, goldId, "+", v, "ʹ����Ʒ:" .. itemName, true)
            end
            delitembymakeindex(actor, makeId, itemNum, "ʹ����Ʒ")
        end
    end
    stop(actor)
end

function stdmodefunc105(actor, item)
    local mapId = getbaseinfo(actor, ConstCfg.gbase.mapid)
    local x = getbaseinfo(actor, ConstCfg.gbase.x)
    local y = getbaseinfo(actor, ConstCfg.gbase.y)
    if mapId == "��̳" and x == 35 and y == 17 then
        map(actor, "�ڳݱ���")
    else
        Player.sendmsgEx(actor, "����|[��]#249|���|[��̳(35.17)]#249|ʹ�ñʼ�!")
    end
    stop(actor)
end

--�������(�ƺž�)
function stdmodefunc106(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        if Bag.checkItemNum(actor, idx, 1) then
            if checktitle(actor, "�������") then
                messagebox(actor, "[ϵͳ��ʾ]�����Ѿ�ӵ�в�������ƺţ�")
                stop(actor)
                return
            else
                confertitle(actor, "�������")
                messagebox(actor, "[ϵͳ��ʾ]���ɹ���ò�������ƺţ�")
            end
        end
    end
end

--�ɽٵ� ��ٲ���
function stdmodefunc107(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        addbuff(actor, 31032)
        local remainingTime = getbuffinfo(actor, 31032, 2)
        local num = getplaydef(actor, VarCfg["U_��ٲ��𵤱���"])
        setplaydef(actor, VarCfg["U_��ٲ��𵤱���"], num + 1)
        Player.sendmsgEx(actor, string.format("��ʹ����|��ٲ���#249|��������˺�,����|%d#249|��,��ǰ��ʹ��|%s#249|��", remainingTime, num + 1))
    end
end

--����ħ����
function stdmodefunc108(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        if getskillinfo(actor, 31, 1) == 2 then
            Player.sendmsgEx(actor, "����ϰ��|[2��ħ����]#249")
            stop(actor)
            return
        end
        if getskillinfo(actor, 31, 1) == 3 then
            Player.sendmsgEx(actor, "����ϰ��|[3��ħ����]#249")
            stop(actor)
            return
        end
        delskill(actor, 31)
        addskill(actor, 31, 2)
        Player.sendmsgEx(actor, "��ϲ��ϰ��|[2��ħ����]#249")
    end
end

--��������Ƭ
function stdmodefunc109(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        local count = getplaydef(actor, VarCfg["U_��������Ƭ_ʹ�ô���"])
        if count >= 20 then
            Player.sendmsgEx(actor, "����ʹ�ù�20�Σ��޷���ʹ�ã�#249")
            stop(actor)
            return
        end
        local itemObj = linkbodyitem(actor, 0)
        if itemObj == "0" then
            Player.sendmsgEx(actor, "��û�д����·�!#249")
            stop(actor)
            return
        end
        local gf = getitemaddvalue(actor, itemObj, 1, 0, 0)
        local mf = getitemaddvalue(actor, itemObj, 1, 1, 0)
        setitemaddvalue(actor, itemObj, 1, 0, gf + 20)
        setitemaddvalue(actor, itemObj, 1, 1, mf + 20)
        refreshitem(actor, itemObj)
        recalcabilitys(actor)
        setplaydef(actor, VarCfg["U_��������Ƭ_ʹ�ô���"], count + 1)
    end
end

--��ѩ���[װ��ʱװ]
function stdmodefunc110(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        ZhuangBan.AddFashionToVar(actor, 40090, VarCfg["T_ʱװ��¼"])
        ZhuangBan.SetCurrFashion(actor, 40090)
    end
end

-- ���������
function stdmodefunc111(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    local name = getiteminfo(actor, item, ConstCfg.iteminfo.name)
    local buffId = 31037
    local hpmpper = 15
    if Bag.checkItemNum(actor, idx, 1) then
        if hasbuff(actor, buffId) then
            local remainder = getbuffinfo(actor, buffId, 2)
            Player.sendmsgEx(actor, string.format("%d��#249|��ſ��Լ���ʹ��|%s#249", remainder, name))
            stop(actor)
            return
        else
            addbuff(actor, buffId)
            addhpper(actor, "+", hpmpper)
            addmpper(actor, "+", hpmpper)
            Player.sendmsgEx(actor, string.format("����ֵ,ħ��ֵ����|%d%%#249", hpmpper))
        end
    end
end

-- �Ż���¶��
function stdmodefunc112(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    local name = getiteminfo(actor, item, ConstCfg.iteminfo.name)
    local buffId = 31038
    local hpmpper = 30
    if Bag.checkItemNum(actor, idx, 1) then
        if hasbuff(actor, buffId) then
            local remainder = getbuffinfo(actor, buffId, 2)
            Player.sendmsgEx(actor, string.format("%d��#249|��ſ��Լ���ʹ��|%s#249", remainder, name))
            stop(actor)
            return
        else
            addbuff(actor, buffId)
            addhpper(actor, "+", hpmpper)
            addmpper(actor, "+", hpmpper)
            Player.sendmsgEx(actor, string.format("����ֵ,ħ��ֵ����|%d%%#249", hpmpper))
        end
    end
end

-- ʮ�㷵����
function stdmodefunc113(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    local name = getiteminfo(actor, item, ConstCfg.iteminfo.name)
    local buffId = 31039
    local hpmpper = 50
    if Bag.checkItemNum(actor, idx, 1) then
        if hasbuff(actor, buffId) then
            local remainder = getbuffinfo(actor, buffId, 2)
            Player.sendmsgEx(actor, string.format("%d��#249|��ſ��Լ���ʹ��|%s#249", remainder, name))
            stop(actor)
            return
        else
            addbuff(actor, buffId)
            addhpper(actor, "+", hpmpper)
            addmpper(actor, "+", hpmpper)
            Player.sendmsgEx(actor, string.format("����ֵ,ħ��ֵ����|%d%%#249", hpmpper))
        end
    end
end

-- ���˵�
-- ����
-- ����
-- ���ĵ�
-- ������
local cfg_UseXianYao = include("QuestDiary/cfgcsv/cfg_UseXianYao.lua") --����
function stdmodefunc114(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    local name = getiteminfo(actor, item, ConstCfg.iteminfo.name)
    if Bag.checkItemNum(actor, idx, 1) then
        local cfg = cfg_UseXianYao[name]
        if not cfg then
            stop(actor)
            return
        end
        local buffId = cfg.buffId
        if hasbuff(actor, buffId) then
            local remainder = getbuffinfo(actor, buffId, 2)
            Player.sendmsgEx(actor, string.format("%d��#249|��ſ��Լ���ʹ��|%s#249", remainder, name))
            stop(actor)
            return
        else
            local shuxing = {}
            if cfg.attrs then
                for _, value in ipairs(cfg.attrs) do
                    shuxing[value[1]] = value[2]
                end
            end
            addbuff(actor, buffId, 0, 1, actor, shuxing)
            if buffId == 31040 then
                Player.setAttList(actor, "���ʸ���")
            end
            Player.sendmsgEx(actor,
                string.format("��ʹ����|%s#249|,|%s+%d%%#249|,����|%s#249|����", name, cfg.desc, cfg.addNum, cfg.time))
        end
    end
end

function stdmodefunc114(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    local name = getiteminfo(actor, item, ConstCfg.iteminfo.name)
    if Bag.checkItemNum(actor, idx, 1) then
        local cfg = cfg_UseXianYao[name]
        if not cfg then
            stop(actor)
            return
        end
        local buffId = cfg.buffId
        if hasbuff(actor, buffId) then
            local remainder = getbuffinfo(actor, buffId, 2)
            Player.sendmsgEx(actor, string.format("%d��#249|��ſ��Լ���ʹ��|%s#249", remainder, name))
            stop(actor)
            return
        else
            local shuxing = {}
            if cfg.attrs then
                for _, value in ipairs(cfg.attrs) do
                    shuxing[value[1]] = value[2]
                end
            end
            addbuff(actor, buffId, 0, 1, actor, shuxing)
            Player.sendmsgEx(actor,
                string.format("��ʹ����|%s#249|,|%s+%d%%#249|,����|%s#249|����", name, cfg.desc, cfg.addNum, cfg.time))
        end
    end
end

-- ����������
-- ϴ�����赤
-- ��ղ�����
-- ����ն�µ�
local cfg_UseShengYao = include("QuestDiary/cfgcsv/cfg_UseShengYao.lua") --����
function stdmodefunc115(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    local name = getiteminfo(actor, item, ConstCfg.iteminfo.name)
    if Bag.checkItemNum(actor, idx, 1) then
        local cfg = cfg_UseShengYao[name]
        if not cfg then
            stop(actor)
            return
        end
        local buffId = cfg.buffId
        if hasbuff(actor, buffId) then
            local remainder = getbuffinfo(actor, buffId, 2)
            Player.sendmsgEx(actor, string.format("%d��#249|��ſ��Լ���ʹ��|%s#249", remainder, name))
            stop(actor)
            return
        else
            local shuxing = {}
            if cfg.attrs then
                for _, value in ipairs(cfg.attrs) do
                    shuxing[value[1]] = value[2]
                end
            end
            local count = getplaydef(actor, cfg.var)
            if count < 10 then
                setplaydef(actor, cfg.var, count + 1)
                --�������ԣ�����ն�µ� ���ع��� ��������
                if buffId == 31048 then
                    Player.setAttList(actor, "���ٸ���")
                else
                    Player.setAttList(actor, "���Ը���")
                end
            end
            addbuff(actor, buffId, 0, 1, actor, shuxing)
            Player.sendmsgEx(actor,
                string.format("��ʹ����|%s#249|,|%s+%d%%#249|,����|%s#249|����", name, cfg.desc, cfg.addNum, cfg.time))
        end
    end
end

--������Ƭ
function stdmodefunc116(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 10) then
        local num = Bag.getItemNum(actor, idx)
        local num2 = math.floor(num / 10)
        takeitemex(actor, "������Ƭ", num2 * 10, 0, "���˾��Ǻϳ�")
        giveitem(actor, "���˾���", num2, ConstCfg.binding, "���˾�����Ƭ�ϳ�")
        Player.sendmsgEx(actor, string.format("��ʹ��|%d#249|��|������Ƭ#249|�ɹ��ϳ�|%d#249|��|���˾���#249", num2 * 10, num2))
    else
        Player.sendmsgEx(actor, "������Ƭ#249|����|10#249|�޷��ϳ�")
    end
    stop(actor)
end

--ת��֮��
function stdmodefunc117(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 10) then
        local num = Bag.getItemNum(actor, idx)
        local num2 = math.floor(num / 10)
        takeitemex(actor, "ת��֮��", num2 * 10, 0, "ת�˽𵤺ϳ�")
        giveitem(actor, "ת�˽�", num2, ConstCfg.binding, "ת�˽���Ƭ�ϳ�")
        Player.sendmsgEx(actor, string.format("��ʹ��|%d#249|��|ת��֮��#249|�ɹ��ϳ�|%d#249|��|ת�˽�#249", num2 * 10, num2))
    else
        Player.sendmsgEx(actor, "ת��֮��#249|����|10#249|�޷��ϳ�")
    end
    stop(actor)
end

--���ý���[װ��ʱװ]
function stdmodefunc118(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        ZhuangBan.AddFashionToVar(actor, 26000, VarCfg["T_ʱװ��¼"])
        ZhuangBan.SetCurrFashion(actor, 26000)
    end
end

--��ֵ��ʹ��
function stdmodefunc119(actor, item)
    if not item then
        return
    end
    local itemName = getiteminfo(actor, item, ConstCfg.iteminfo.name)
    local value = cfg_UseItem[itemName]
    if value then
        local itemNum = getiteminfo(actor, item, ConstCfg.iteminfo.overlap)
        if itemNum <= 0 then
            return
        end
        local makeId = getiteminfo(actor, item, ConstCfg.iteminfo.id)
        local total = value.value * itemNum
        local data = splitLargeNumber(2000000000, total)
        if #data > 0 then
            for _, v in ipairs(data) do
                local num = getplaydef(actor, VarCfg["U_�����ֵ"])
                setplaydef(actor, VarCfg["U_�����ֵ"], num + 1)
                changemoney(actor, 20, "+", v, "ʹ����Ʒ:" .. itemName, true)
                changemoney(actor, 11, "+", math.ceil(v / 10), "ʹ����Ʒ:" .. itemName, true)
            end
            delitembymakeindex(actor, makeId, itemNum, "ʹ����Ʒ")
        end
    end
    stop(actor)
end

--�������
function stdmodefunc120(actor, item)
    stop(actor)
    if not item then
        return
    end
    local itemNum = getiteminfo(actor, item, ConstCfg.iteminfo.overlap)
    if itemNum <= 0 then
        return
    end
    if checktitle(actor, "��������") then
        Player.sendmsgEx(actor, "��ʾ#251|:#255|�Բ���,���Ѽ���|��������#249|�����ظ�����...")
        return
    end
    if itemNum < 10 then
        Player.sendmsgEx(actor, "��ʾ#251|:#255|�Բ���,���|�������#249|����|10ö#249|ö...")
        return
    else
        takeitem(actor, "�������", 10, 0)
        confertitle(actor, "��������", 1)
        addbuff(actor, 31065)
        Player.sendmsgEx(actor, "��ʾ#251|:#255|��ϲ��,���|��������#249|�ƺ�...")
    end
end

--���н��
function stdmodefunc121(actor, item)
    stop(actor)
    if not item then
        return
    end
    local itemNum = getiteminfo(actor, item, ConstCfg.iteminfo.overlap)
    if itemNum <= 0 then
        return
    end
    if checktitle(actor, "���»ʵ�") then
        Player.sendmsgEx(actor, "��ʾ#251|:#255|�Բ���,���Ѽ���|���»ʵ�#249|�����ظ�����...")
        return
    end
    if itemNum < 10 then
        Player.sendmsgEx(actor, "��ʾ#251|:#255|�Բ���,���|���н��#249|����|10ö#249|ö...")
        return
    else
        takeitem(actor, "���н��", 10, 0)
        confertitle(actor, "���»ʵ�", 1)
        moneychange7(actor)
        Player.sendmsgEx(actor, "��ʾ#251|:#255|��ϲ��,���|���»ʵ�#249|�ƺ�...")
    end
end

--��˿С��è������
function stdmodefunc123(actor, item)
    stop(actor)
    local buff = hasbuff(actor, 31066)
    if buff then
        FkfDelBuff(actor, 31066)
    else
        addbuff(actor, 31066)
    end
end

--ÿ����Ȩ���
function stdmodefunc124(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        Player.giveItemByTable(actor, { { "����ʯ", 50 } }, "ÿ����Ȩ���", 1, true)
        Player.giveItemByTable(actor, { { "�칤֮��", 50 } }, "ÿ����Ȩ���", 1, true)
        Player.giveItemByTable(actor, { { "����ˮ��", 20 } }, "ÿ����Ȩ���", 1, true)
        Player.giveItemByTable(actor, { { "��ʯ", 5 } }, "ÿ����Ȩ���", 1, true)
    end
end


--�ܽ�ʱװ��
function stdmodefunc125(actor, item)
    local data = {"�����͠D[ʱװ]","��Ӱ֮��[ʱװ]","�Ĺ�[ʱװ]","����ǹ��[ʱװ]","����[ʱװ]","�����ɲ[ʱװ]","����[ʱװ]","����[ʱװ]",
                    "�л�����[ʱװ]","Ѫɱ֮��[ʱװ]","���ս��[ʱװ]","����ʥ��[ʱװ]","����֮��[ʱװ]","ҹ��[ʱװ]","����[ʱװ]","����[ʱװ]"}
    Message.sendmsg(actor, ssrNetMsgCfg.FenJinShiZhuangHe_OpenUI, 0, 0, 0, data)
    stop(actor)
end

--�ܽ��������
local FenJinBaoXiangData = {["�ܽ�ʱװ��"] = 1,["�����Ƭ"] = 5,["���籾Դ"] = 20,["��������չ��"] = 1,["���˾���"] = 1,["ת�˽�"] = 1,["��걦��(С)"] = 1}
function stdmodefunc126(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        local Award, _ = ransjstr("�ܽ�ʱװ��#2000|�����Ƭ#1000|���籾Դ#2500|��������չ��#500|���˾���#1500|ת�˽�#1500|��걦��(С)#1500", 1, 3)
        local Num = FenJinBaoXiangData[Award]
        local Name = Award
        giveitem(actor, Name, Num, ConstCfg.binding, "ʹ�÷ܽ��������")
        local str = string.format("{����ϲ��/FCOLOR=249}��{%s/FCOLOR=250} {��[�ܽ��������]���/FCOLOR=249}{%s/FCOLOR=250} ",
            Player.GetName(actor), Name)
        sendmovemsg(actor, 1, 249, 0, 100, 1, str)
    end
end




--500���   ������500���(��)
function stdmodefunc127(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        changemoney(actor, 20, "+", 500, "ʹ��500������", true)
    end
end

--ף����
function stdmodefunc45(actor, item)
    callscriptex(actor, "CHANGEITEMADDVALUE", 1, 5, "=", 0)
    sendmsg(actor, ConstCfg.notice.own, '{"Msg":"<font color=\'#FFFFFF\'>������������ϴ��</font>","Type":9}')
end
local cfg_JingZhiXiaoHui = include("QuestDiary/cfgcsv/cfg_JingZhiXiaoHui.lua") --��ֹ���ٵ㻯
--����ָ��ʯ�ɽ�
function stdmodeshow1(actor)
    local pointItemMakeId = getconst(actor, "<$BagItemMakeIndex>")
    local pointItemName = getconst(actor, "<$BagItemName>")
    if pointItemMakeId == "" then
        stop(actor)
        return
    end
    if cfg_JingZhiXiaoHui[pointItemName] then
        Player.sendmsgEx(actor,"��".. pointItemName .."����ֹ�㻯!#249")
        stop(actor)
        return
    end
    local isSuccess = delitembymakeindex(actor, pointItemMakeId, 1, "����ָ��ʯ�ɽ�")
    if isSuccess then
        local index = math.random(#cfg_DianShiChengJin)
        local randomResult = cfg_DianShiChengJin[index]
        if randomResult then
            local itemName = randomResult.value
            giveitem(actor, itemName, 1, ConstCfg.binding, "����ָ��ʯ�ɽ�")
            messagebox(actor, string.format("[ϵͳ��ʾ]�� ��ͨ����ʯ�ɽ�[%s]����Ϊ��[%s]��", pointItemName, itemName))
        end
    end
end

--������
function stdmodefunc200(actor, item)
    if checkkuafu(actor) then
        Player.sendmsgEx(actor, "�����,��ֹ����!#249")
        stop(actor)
        return
    end
    say(actor, [[
        <Img|loadDelay=1|show=4|img=custom/public/gaimingjiemian.png|esc=1|move=0|reset=1|bg=1>
        <Layout|x=570.0|y=24.0|width=80|height=80|link=@exit>
        <Button|x=589.0|y=41.0|pimg=public/1900000511.png|nimg=public/1900000510.png|link=@exit>
        <Input|x=215.0|y=76.0|width=268|height=31|color=249|mincount=2|place="�������µ�����"|type=0|inputid=1|size=18|maxcount=16|isNameInput=1|errortips=1>
        <Button|x=207.0|y=164.0|submitInput=1|nimg=custom/public/btn_quedingxiugai.png|link=@alterplayernameitem>
    ]])
    stop(actor)
end

function alterplayernameitem(actor)
    if checkkuafu(actor) then
        Player.sendmsgEx(actor, "�����,��ֹ����!#249")
        stop(actor)
        return
    end
    if checkitems(actor, "������#1", 0, 0) then
        local NewName = getconst(actor, "<$NPCINPUT(1)>")
        local _Type = changehumname(actor, NewName)
        if _Type == 0 then
            GameEvent.push(EventCfg.onUseGaiMingKa, actor)
            takeitem(actor, "������", 1, 0)
            close(actor)
        end
    end
end

--���ڲ�ѯ�������
function queryinghumname(actor)
    sendmsg(actor, 1, '{"Msg":"<font color=\'#ff0000\'>���ڲ�ѯ���Ժ󡣡���</font>","Type":9}')
end

--���Ʊ�����
function humnamefilter(actor)
    sendmsg(actor, 1, '{"Msg":"<font color=\'#ff0000\'>���Ʊ����ˡ�����</font>","Type":9}')
end

--���Ȳ�����Ҫ��
function namelengthfail(actor)
    sendmsg(actor, 1, '{"Msg":"<font color=\'#ff0000\'>���Ȳ�����Ҫ��</font>","Type":9}')
end

--�����Ѿ�����
function humnameexists(actor)
    sendmsg(actor, 1, '{"Msg":"<font color=\'#ff0000\'>�����Ѿ�����</font>","Type":9}')
end

--����ִ�и�������
function changeinghumname(actor)
    sendmsg(actor, 1, '{"Msg":"<font color=\'#ff0000\'>�����޸����Ժ󡣡���</font>","Type":9}')
end

--����ʧ��
function changehumnamefail(actor)
    sendmsg(actor, 1, '{"Msg":"<font color=\'#ff0000\'>�޸�����ʧ��</font>","Type":9}')
end

function gai_ming_xiao_tui_yan_chi(actor)
    openhyperlink(actor, 34)
end

--�����ɹ�
function changehumnameok(actor)
    local OldName = getconst(actor, "<$USERNAME>")
    local NewName = getconst(actor, "<$USERNEWNAME>")
    sendmsgnew(actor, 250, 0,
        "{��λ���: /FCOLOR=251}���{" ..
        OldName .. "/FCOLOR=249}�ɹ�����,�����֡�{" .. NewName .. "/FCOLOR=249}�����λ��ʿ ����Ҫ�Ҵ����ˣ�������������",
        0, 3)
    sendmsgnew(actor, 250, 0,
        "{��λ���: /FCOLOR=251}���{" ..
        OldName .. "/FCOLOR=249}�ɹ�����,�����֡�{" .. NewName .. "/FCOLOR=249}�����λ��ʿ ����Ҫ�Ҵ����ˣ�������������",
        0, 3)
    sendmsgnew(actor, 250, 0,
        "{��λ���: /FCOLOR=251}���{" ..
        OldName .. "/FCOLOR=249}�ɹ�����,�����֡�{" .. NewName .. "/FCOLOR=249}�����λ��ʿ ����Ҫ�Ҵ����ˣ�������������",
        0, 3)
    delaygoto(actor, 2000, "gai_ming_xiao_tui_yan_chi", 0)
end

--����������̡��  ռ������
function stdmodefunc300(actor, item)
    local ZhanBuTbl = Player.getJsonTableByVar(actor, VarCfg["T_����ռ����¼"])
    local Type = { "ף��", "�ٶ�", "����", "����", "ŭ��", "����", "�ƻ�", "��ɱ", "��͸", "˺��" }
    local NewTbl = {}
    for _, v in ipairs(Type) do
        local Num = (ZhanBuTbl[v] == "" and 0) or ZhanBuTbl[v] or 0
        table.insert(NewTbl, Num)
    end
    Message.sendmsg(actor, ssrNetMsgCfg.LuoPanZhanBu_OpenUI, 0, 0, 0, NewTbl)
    stop(actor)
end

--ħ����[����]
function stdmodefunc301(actor, item)
    addskill(actor, 31, 1)
end

--�򹤻ʵ�[�ƺ�]
function stdmodefunc302(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        if Bag.checkItemNum(actor, idx, 1) then
            if checktitle(actor, "�򹤻ʵ�") then
                messagebox(actor, "[ϵͳ��ʾ]�����Ѿ�ӵ�д򹤻ʵ۳ƺţ�")
                stop(actor)
                return
            else
                confertitle(actor, "�򹤻ʵ�")
                messagebox(actor, "[ϵͳ��ʾ]���ɹ���ô򹤻ʵ۳ƺţ�")
            end
        end
    end
end

--��������[�ƺ�]
function stdmodefunc303(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        if Bag.checkItemNum(actor, idx, 1) then
            if checktitle(actor, "��������") then
                messagebox(actor, "[ϵͳ��ʾ]�����Ѿ�ӵ�й������˳ƺţ�")
                stop(actor)
                return
            else
                confertitle(actor, "��������")
                messagebox(actor, "[ϵͳ��ʾ]���ɹ���ù������˳ƺţ�")
            end
        end
    end
end

--����ˮ����
function stdmodefunc304(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        if Bag.checkItemNum(actor, idx, 1) then
            giveitem(actor, "����ˮ��", 100, ConstCfg.bangding, "QFʹ�û���ˮ����")
        end
    end
end

--��ʯ��
function stdmodefunc305(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        if Bag.checkItemNum(actor, idx, 1) then
            giveitem(actor, "��ʯ", 100, ConstCfg.bangding, "QFʹ����ʯ��")
        end
    end
end

local AwardList = {}
AwardList["����ר��"] = function(actor)
    local Tbl = { "��G���ı�", "�쵼˦�Ĺ�", "ͬ�»���ˮ", "�Լ�������", "�߻��ڵĿ�", "���������" }
    local Num = math.random(1, #Tbl)
    local Name = Tbl[Num]
    giveitem(actor, Name, 1, ConstCfg.bangding, "QFʹ�ñ���ר��")
    local str = string.format("{����ϲ��/FCOLOR=249}��{%s/FCOLOR=250} {��[���ߺ������]���/FCOLOR=249}{%s/FCOLOR=250} ",
        Player.GetName(actor), Name)
    sendmovemsg(actor, 1, 249, 0, 100, 1, str)
end
AwardList["����ʱװ"] = function(actor)
    local Tbl = { "��������[ʱװ]", "��������[ʱװ]", "�綾����[ʱװ]", "�������[ʱװ]", "���������[ʱװ]", "�������[ʱװ]", "����ǯ��[ʱװ]", "��è��ɮ[ʱװ]",
        "��͸�Ĵ���Ϻ[ʱװ]", "������ʿ[ʱװ]", "����սʿ[ʱװ]", "�á�ʤ��Ů��[ʱװ]", "�á�������Ů[ʱװ]", "��սʤ��[ʱװ]", "��̳ʹ��[ʱװ]", "����ս��[ʱװ]" }
    local Num = math.random(1, #Tbl)
    local Name = Tbl[Num]
    giveitem(actor, Name, 1, ConstCfg.bangding, "QFʹ�ñ���ר��")
    local str = string.format("{����ϲ��/FCOLOR=249}��{%s/FCOLOR=250} {��[���ߺ������]���/FCOLOR=249}{%s/FCOLOR=250} ",
        Player.GetName(actor), Name)
    sendmovemsg(actor, 1, 249, 0, 100, 1, str)
end
AwardList["��������"] = function(actor)
    local Tbl = { "���˾���", "ת�˽�", "���絤", "1�ھ����", "����ָ", "5000W�����" }
    local Num = math.random(1, #Tbl)
    local Name = Tbl[Num]
    if Name == "���絤" then
        giveitem(actor, Name, 3, ConstCfg.bangding, "QFʹ�ñ���ר��")
    else
        giveitem(actor, Name, 1, ConstCfg.bangding, "QFʹ�ñ���ר��")
    end
    local str = string.format("{����ϲ��/FCOLOR=249}��{%s/FCOLOR=250} {��[���ߺ������]���/FCOLOR=249}{%s/FCOLOR=250} ",
        Player.GetName(actor), Name)
    sendmovemsg(actor, 1, 249, 0, 100, 1, str)
end


--ɳ�����а���
function stdmodefunc91(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    local name = getiteminfo(actor, item, ConstCfg.iteminfo.name)
    if Bag.checkItemNum(actor, idx, 1) then
        local cfg = cfg_ShaChengBaoXiang[name]
        local gives = {}
        for index, value in ipairs(cfg.reward) do
            if randomex(value[3]) then
                if value[1] == "����ʱװ" then
                    AwardList["����ʱװ"](actor)
                    return
                end
                gives = { { value[1], value[2] } }
            end
        end
        if #gives < 1 then
            gives = cfg.baoDi
        end
        setmetatable(gives, {
            __tostring = function(t)
                return t[1][1] .. "*" .. t[1][2]
            end
        })
        Player.giveItemByTable(actor, gives, "ʹ��" .. name, 1, true)
        messagebox(actor, string.format("[ϵͳ��ʾ]�� �㿪����%s�ɹ����[%s]", name, tostring(gives)))
    end
end

function stdmodefunc306(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        if Bag.checkItemNum(actor, idx, 1) then
            local Award, _ = ransjstr("����ר��#500|����ʱװ#1500|��������#7000", 1, 3)
            AwardList[Award](actor)
        end
    end
end

--�����䵶
function stdmodefunc307(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        addskill(actor, 25, 3)
        Player.sendmsgEx(actor, "��ϲ��ϰ��|[�����䵶]#249")
    end
end

function stdmodefunc308(actor, item)
    say(actor, [[
    <Img|reset=1|show=4|img=custom/public/hanhuabg.png|esc=1|bg=1|loadDelay=1|move=0>
    <Layout|x=570.0|y=24.0|width=80|height=80|link=@exit>
    <Button|x=589.0|y=41.0|nimg=public/1900000510.png|pimg=public/1900000511.png|link=@exit>
    <Input|x=64.0|y=78.0|width=483|height=32|mincount=2|maxcount=16|size=18|color=249|place="�����뺰������"|errortips=1|type=0|inputid=2>
    <Button|x=207.0|y=164.0|submitInput=2|size=18|nimg=custom/public/btn_queding.png|color=255|link=@onbroadcast>
]])
    stop(actor)
end

function onbroadcast(actor)
    if checkitems(actor, "��������#1", 0, 0) then
        local Strinfo = getconst(actor, "<$NPCINPUT(2)>")
        local name = getbaseinfo(actor, ConstCfg.gbase.name)


        local result1, result2 = exisitssensitiveword(Strinfo)
        if Strinfo == "" then
            messagebox(actor, string.format("[ϵͳ��ʾ]���㻹δ�����κ�����..."))
            return
        end
        if result1 then
            messagebox(actor, string.format("[ϵͳ��ʾ]������������ݴ���Υ����,����������..."))
            return
        else
            sendmovemsg(actor, 1, 255, 0, 200, 1,
                "{[����] /FCOLOR=251}{" .. name .. ": /FCOLOR=250}{" .. Strinfo .. " /FCOLOR=253}")
            takeitem(actor, "��������", 1, 0)
        end
    else
        Player.sendmsgEx(actor, "��ʾ#251|:#255|�������Ȳ���1��...")
    end
end

-- 401  ţ��װ[ʱװ]
function stdmodefunc401(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        ZhuangBan.AddFashionToVar(actor, 40167, VarCfg["T_ʱװ��¼"])
        ZhuangBan.SetCurrFashion(actor, 40167)
    end
end

-- 402  ��������[ʱװ]
function stdmodefunc402(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        ZhuangBan.AddFashionToVar(actor, 40127, VarCfg["T_ʱװ��¼"])
        ZhuangBan.SetCurrFashion(actor, 40127)
    end
end

-- 403  ��������[ʱװ]
function stdmodefunc403(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        ZhuangBan.AddFashionToVar(actor, 40122, VarCfg["T_ʱװ��¼"])
        ZhuangBan.SetCurrFashion(actor, 40122)
    end
end

-- 404  �á�����ħͯ����߸[ʱװ]
function stdmodefunc404(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        ZhuangBan.AddFashionToVar(actor, 1088, VarCfg["T_ʱװ��¼"])
        ZhuangBan.SetCurrFashion(actor, 1088)
    end
end

-- 405  ħ�����û�[ʱװ]
function stdmodefunc405(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        ZhuangBan.AddFashionToVar(actor, 40166, VarCfg["T_ʱװ��¼"])
        ZhuangBan.SetCurrFashion(actor, 40166)
    end
end

-- 406  ���ý���[ʱװ]
function stdmodefunc406(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        ZhuangBan.AddFashionToVar(actor, 26000, VarCfg["T_ʱװ��¼"])
        ZhuangBan.SetCurrFashion(actor, 26000)
    end
end

-- 407  ����̫���Ǿ�����[ʱװ]
function stdmodefunc407(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        ZhuangBan.AddFashionToVar(actor, 40150, VarCfg["T_ʱװ��¼"])
        ZhuangBan.SetCurrFashion(actor, 40150)
    end
end

-- 408  40155 �綾����[ʱװ]
function stdmodefunc408(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        ZhuangBan.AddFashionToVar(actor, 40155, VarCfg["T_ʱװ��¼"])
        ZhuangBan.SetCurrFashion(actor, 40155)
    end
end

-- 409   40158  �������[ʱװ]
function stdmodefunc409(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        ZhuangBan.AddFashionToVar(actor, 40158, VarCfg["T_ʱװ��¼"])
        ZhuangBan.SetCurrFashion(actor, 40158)
    end
end

-- 410   40159  ���������[ʱװ]
function stdmodefunc410(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        ZhuangBan.AddFashionToVar(actor, 40159, VarCfg["T_ʱװ��¼"])
        ZhuangBan.SetCurrFashion(actor, 40159)
    end
end

-- 411   40153  �������[ʱװ]
function stdmodefunc411(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        ZhuangBan.AddFashionToVar(actor, 40153, VarCfg["T_ʱװ��¼"])
        ZhuangBan.SetCurrFashion(actor, 40153)
    end
end

-- 412   40154  ����ǯ��[ʱװ]
function stdmodefunc412(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        ZhuangBan.AddFashionToVar(actor, 40154, VarCfg["T_ʱװ��¼"])
        ZhuangBan.SetCurrFashion(actor, 40154)
    end
end

-- 413   40160  ��è��ɮ[ʱװ]
function stdmodefunc413(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        ZhuangBan.AddFashionToVar(actor, 40160, VarCfg["T_ʱװ��¼"])
        ZhuangBan.SetCurrFashion(actor, 40160)
    end
end

-- 414   40157  ��͸�Ĵ���Ϻ[ʱװ]
function stdmodefunc414(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        ZhuangBan.AddFashionToVar(actor, 40157, VarCfg["T_ʱװ��¼"])
        ZhuangBan.SetCurrFashion(actor, 40157)
    end
end

-- 415   40156  ������ʿ[ʱװ]
function stdmodefunc415(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        ZhuangBan.AddFashionToVar(actor, 40156, VarCfg["T_ʱװ��¼"])
        ZhuangBan.SetCurrFashion(actor, 40156)
    end
end

-- 416   40161  ����սʿ[ʱװ]
function stdmodefunc416(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        ZhuangBan.AddFashionToVar(actor, 40161, VarCfg["T_ʱװ��¼"])
        ZhuangBan.SetCurrFashion(actor, 40161)
    end
end

-- 417   40128  �á�ʤ��Ů��[ʱװ]
function stdmodefunc417(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        ZhuangBan.AddFashionToVar(actor, 40128, VarCfg["T_ʱװ��¼"])
        ZhuangBan.SetCurrFashion(actor, 40128)
    end
end

-- 418   40121  �á�������Ů[ʱװ]
function stdmodefunc418(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        ZhuangBan.AddFashionToVar(actor, 40121, VarCfg["T_ʱװ��¼"])
        ZhuangBan.SetCurrFashion(actor, 40121)
    end
end

-- 419   40127  ��������[ʱװ]
function stdmodefunc419(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        ZhuangBan.AddFashionToVar(actor, 40127, VarCfg["T_ʱװ��¼"])
        ZhuangBan.SetCurrFashion(actor, 40127)
    end
end

-- 420   40123  ��սʤ��[ʱװ]
function stdmodefunc420(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        ZhuangBan.AddFashionToVar(actor, 40123, VarCfg["T_ʱװ��¼"])
        ZhuangBan.SetCurrFashion(actor, 40123)
    end
end

-- 421   40151  ��̳ʹ��[ʱװ]
function stdmodefunc421(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        ZhuangBan.AddFashionToVar(actor, 40151, VarCfg["T_ʱװ��¼"])
        ZhuangBan.SetCurrFashion(actor, 40151)
    end
end

-- 422   40152  ����ս��[ʱװ]
function stdmodefunc422(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        ZhuangBan.AddFashionToVar(actor, 40152, VarCfg["T_ʱװ��¼"])
        ZhuangBan.SetCurrFashion(actor, 40152)
    end
end

-- 423   40162  ����һͷСë¿[ʱװ]
function stdmodefunc423(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        ZhuangBan.AddFashionToVar(actor, 40162, VarCfg["T_ʱװ��¼"])
        ZhuangBan.SetCurrFashion(actor, 40162)
    end
end

-- 424   10508  Ӿװ����[ʱװ]
function stdmodefunc424(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        ZhuangBan.AddFashionToVar(actor, 1109, VarCfg["T_ʱװ��¼"])
        ZhuangBan.SetCurrFashion(actor, 1109)
    end
end

-- 424   10508  ��˿С����[ʱװ]
function stdmodefunc425(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then

    end
end

-- 426   40183  ��������[ʱװ]
function stdmodefunc426(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        ZhuangBan.AddFashionToVar(actor, 40183, VarCfg["T_ʱװ��¼"])
        ZhuangBan.SetCurrFashion(actor, 40183)
    end
end

function stdmodefunc427(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 10) then
        if not Bag.checkBagEmptyNum(actor, 5) then
            Player.sendmsgEx(actor, "��ı������Ӳ���,��������5���ո�!#249")
            stop(actor)
            return
        end
        local num = Bag.getItemNum(actor, idx)
        local num2 = math.floor(num / 10)
        takeitemex(actor, "ħ���û���Ƭ", num2 * 10, 0, "ħ���û��ϳ�")
        giveitem(actor, "ħ�����û�[ʱװ]", num2, ConstCfg.binding, "ħ�����û��ϳ�")
        Player.sendmsgEx(actor, string.format("��ʹ��|%d#249|��|ħ���û���Ƭ#249|�ɹ��ϳ�|%d#249|��|ħ�����û�[ʱװ]#249", num2 * 10, num2))
    else
        Player.sendmsgEx(actor, "������Ƭ#249|����|10#249|�޷��ϳ�")
    end
    stop(actor)
end

--����ˮ����
function stdmodefunc428(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        if Bag.checkItemNum(actor, idx, 1) then
            giveitem(actor, "����ˮ��", 500, ConstCfg.bangding, "QFʹ�û���ˮ�����")
        end
    end
end

--��ʯ��
function stdmodefunc429(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        if Bag.checkItemNum(actor, idx, 1) then
            giveitem(actor, "��ʯ", 30, ConstCfg.bangding, "QFʹ����ʯ��С")
        end
    end
end

-- 430   40200  �����ۡ���ɱ���gһ�е�[ʱװ]
function stdmodefunc430(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        setflagstatus(actor, VarCfg["F_�ռ�ʱװ��ʶ"], 1)
        ZhuangBan.AddFashionToVar(actor, 40200, VarCfg["T_ʱװ��¼"])
        ZhuangBan.SetCurrFashion(actor, 40200)
    end
end

-- 431  ��걦��(С)
function stdmodefunc431(actor, item)
    if checkkuafu(actor) then
        Player.sendmsgEx(actor, "��ر���ʹ��#249")
        stop(actor)
        return
    end
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        local items = { { "����֮��[��]", 1 }, { "��������[��]", 1 }, { "����ͷ��[��]", 1 }, { "��������[��]", 1 }, { "��������[��]", 1 }, { "����ָ��[��]", 1 } }
        local giveItem = { table.random(items) }
        Player.giveItemByTable(actor, giveItem, "��������", 1, true)
        local msgStr = getItemArrToStr(giveItem)
        messagebox(actor, string.format("[ϵͳ��ʾ]�� ��ʹ��[��걦��(С)]��ã�[%s]", msgStr))
    end
end

-- 432 ��걦��(��)
function stdmodefunc432(actor, item)
    if checkkuafu(actor) then
        Player.sendmsgEx(actor, "��ر���ʹ��#249")
        stop(actor)
        return
    end
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        local items = { { "����֮��[��]", 1 }, { "��������[��]", 1 }, { "����ͷ��[��]", 1 }, { "��������[��]", 1 }, { "��������[��]", 1 }, { "����ָ��[��]", 1 } }
        local giveItem = { table.random(items) }
        Player.giveItemByTable(actor, giveItem, "��������", 1, true)
        local msgStr = getItemArrToStr(giveItem)
        messagebox(actor, string.format("[ϵͳ��ʾ]�� ��ʹ��[��걦��(��)]��ã�[%s]", msgStr))
    end
end

-- 433 ��걦��(��)
function stdmodefunc433(actor, item)
    if checkkuafu(actor) then
        Player.sendmsgEx(actor, "��ر���ʹ��#249")
        stop(actor)
        return
    end
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        local items = { { "����֮��[��]", 1 }, { "��������[��]", 1 }, { "����ͷ��[��]", 1 }, { "��������[��]", 1 }, { "��������[��]", 1 }, { "����ָ��[��]", 1 } }
        local giveItem = { table.random(items) }
        Player.giveItemByTable(actor, giveItem, "��������", 1, true)
        local msgStr = getItemArrToStr(giveItem)
        messagebox(actor, string.format("[ϵͳ��ʾ]�� ��ʹ��[��걦��(��)]��ã�[%s]", msgStr))
    end
end

-- 434  ������[����]ѧϰ������
function stdmodefunc434(actor, item)
    if checkkuafu(actor) then
        Player.sendmsgEx(actor, "��ر���ʹ��#249")
        stop(actor)
        return
    end
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        if getskillinfo(actor, 71, 1) == 3 then
            Player.sendmsgEx(actor, "����ϰ��|[������]#249|�����ظ�ѧϰ")
            stop(actor)
            return
        end
        addskill(actor, 71, 3)
        Player.sendmsgEx(actor, "��ϲ��ϰ��|[������]#249")
    end
end

--��ҹս����Ͽ�[�ƺž�]
function stdmodefunc435(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        if Bag.checkItemNum(actor, idx, 1) then
            if checktitle(actor, "��ҹս����Ͽ�") then
                messagebox(actor, "[ϵͳ��ʾ]�����Ѿ�ӵ����ҹս����Ͽɳƺţ�")
                stop(actor)
                return
            else
                confertitle(actor, "��ҹս����Ͽ�")
                messagebox(actor, "[ϵͳ��ʾ]���ɹ������ҹս����Ͽɳƺţ�")
            end
        end
    end
end

--��Ӱ֮��[�㼣]
function stdmodefunc436(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        if getflagstatus(actor, VarCfg["F_��Ӱ֮���㼣���"]) == 1 then
            Player.sendmsgEx(actor, "���Ѿ�ӵ����Ӱ֮���㼣��")
            stop(actor)
            return
        end
        --��װ��
        ZhuangBan.AddFashionToVar(actor, 63135, VarCfg["T_�㼣��¼"])
        ZhuangBan.SetCurrFashion(actor, 63135)
        setflagstatus(actor, VarCfg["F_��Ӱ֮���㼣���"], 1)
        Player.setAttList(actor, "���Ը���")
    end
end

--ǧ��֮��[�ƺ�]
function stdmodefunc437(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        if Bag.checkItemNum(actor, idx, 1) then
            if checktitle(actor, "ǧ��֮��") then
                messagebox(actor, "[ϵͳ��ʾ]�����Ѿ�ӵ��ǧ��֮���ƺţ�")
                stop(actor)
                return
            else
                confertitle(actor, "ǧ��֮��")
                messagebox(actor, "[ϵͳ��ʾ]���ɹ����ǧ��֮���ƺţ�")
            end
        end
    end
end

-- ���¹���[�ƺž�]	31	0	0	438
-- ����֮��[�ƺž�]	31	0	0	439
-- 1500�������	31	0	0	440
-- 500�������	31	0	0	441
-- ���¹�������	31	0	0	442
-- ����֮�걦��	31	0	0	443

-- ���¹���[�ƺž�]
function stdmodefunc438(actor, item)
    if checkkuafu(actor) then
        Player.sendmsgEx(actor, "��ر���ʹ��#249")
        stop(actor)
        return
    end
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        if checktitle(actor, "���¹���") then
            messagebox(actor, "[ϵͳ��ʾ]�����Ѿ�ӵ�����¹����ƺţ�")
            stop(actor)
            return
        else
            confertitle(actor, "���¹���", 1)
            messagebox(actor, "[ϵͳ��ʾ]���ɹ�������¹����ƺţ�,��Ч��48Сʱ��")
        end
    end
end

-- ����֮��[�ƺž�]	31	0	0	439
function stdmodefunc439(actor, item)
    if checkkuafu(actor) then
        Player.sendmsgEx(actor, "��ر���ʹ��#249")
        stop(actor)
        return
    end
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        if checktitle(actor, "����֮��") then
            messagebox(actor, "[ϵͳ��ʾ]�����Ѿ�ӵ�в���֮��ƺţ�")
            stop(actor)
            return
        else
            confertitle(actor, "����֮��", 1)
            messagebox(actor, "[ϵͳ��ʾ]���ɹ���ò���֮��ƺ�,��Ч��48Сʱ��")
        end
    end
end

-- 1500�������	31	0	0	440
function stdmodefunc440(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        local kuaFuPiont = getplaydef(actor, VarCfg["U_�������"])
        setplaydef(actor, VarCfg["U_�������"], kuaFuPiont + 1500)
        messagebox(actor, "��ϲ����1500����,��ǰ����:" .. kuaFuPiont + 1500)
    end
end

-- 500�������	31	0	0	441
function stdmodefunc441(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        local kuaFuPiont = getplaydef(actor, VarCfg["U_�������"])
        setplaydef(actor, VarCfg["U_�������"], kuaFuPiont + 500)
        messagebox(actor, "��ϲ����500����,��ǰ����:" .. kuaFuPiont + 500)
    end
end

-- ���¹�������	31	0	0	442
function stdmodefunc442(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        local uid = Player.GetUUID(actor)
        Player.giveMailByTable(uid, 1, "���¹������佱��", "����ȡ[���¹�������]���佱��",
            { { "���¹���[�ƺž�]", 1 }, { "1500�������", 1 }, { "�����Ƭ", 10 } }, 1, true)
        Player.sendmsgEx(actor, "�����ѷ��͵����䣬��ע�����!")
    end
end

-- ����֮�걦��	31	0	0	443
function stdmodefunc443(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        local uid = Player.GetUUID(actor)
        Player.giveMailByTable(uid, 1, "����֮�걦�佱��", "����ȡ[����֮�걦��]���佱��", { { "����֮��[�ƺž�]", 1 }, { "500�������", 1 }, { "�����Ƭ", 3 } }, 1, true)
        Player.sendmsgEx(actor, "�����ѷ��͵����䣬��ע�����!")
    end
end

-- �����͠D[ʱװ] 1050
function stdmodefunc444(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        ZhuangBan.AddFashionToVar(actor, 1050, VarCfg["T_ʱװ��¼"])
        ZhuangBan.SetCurrFashion(actor, 1050)
    end
end
-- ��Ӱ֮��[ʱװ] 1054
function stdmodefunc445(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        ZhuangBan.AddFashionToVar(actor, 1054, VarCfg["T_ʱװ��¼"])
        ZhuangBan.SetCurrFashion(actor, 1054)
    end
end
-- �Ĺ�[ʱװ] 1048
function stdmodefunc446(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        ZhuangBan.AddFashionToVar(actor, 1048, VarCfg["T_ʱװ��¼"])
        ZhuangBan.SetCurrFashion(actor, 1048)
    end
end
-- ����ǹ��[ʱװ] 26001
function stdmodefunc447(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        ZhuangBan.AddFashionToVar(actor, 26001, VarCfg["T_ʱװ��¼"])
        ZhuangBan.SetCurrFashion(actor, 26001)
    end
end
-- ����[ʱװ] 26002
function stdmodefunc448(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        ZhuangBan.AddFashionToVar(actor, 26002, VarCfg["T_ʱװ��¼"])
        ZhuangBan.SetCurrFashion(actor, 26002)
    end
end
-- �����ɲ[ʱװ] 26003
function stdmodefunc449(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        ZhuangBan.AddFashionToVar(actor, 26003, VarCfg["T_ʱװ��¼"])
        ZhuangBan.SetCurrFashion(actor, 26003)
    end
end
-- ����[ʱװ] 26005
function stdmodefunc450(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        ZhuangBan.AddFashionToVar(actor, 26005, VarCfg["T_ʱװ��¼"])
        ZhuangBan.SetCurrFashion(actor, 26005)
    end
end
-- ����[ʱװ] 26006
function stdmodefunc451(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        ZhuangBan.AddFashionToVar(actor, 26006, VarCfg["T_ʱװ��¼"])
        ZhuangBan.SetCurrFashion(actor, 26006)
    end
end
-- �л�����[ʱװ] 26008
function stdmodefunc452(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        ZhuangBan.AddFashionToVar(actor, 26008, VarCfg["T_ʱװ��¼"])
        ZhuangBan.SetCurrFashion(actor, 26008)
    end
end
-- Ѫɱ֮��[ʱװ] 26010
function stdmodefunc453(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        ZhuangBan.AddFashionToVar(actor, 26010, VarCfg["T_ʱװ��¼"])
        ZhuangBan.SetCurrFashion(actor, 26010)
    end
end
-- ���ս��[ʱװ] 26011
function stdmodefunc454(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        ZhuangBan.AddFashionToVar(actor, 26011, VarCfg["T_ʱװ��¼"])
        ZhuangBan.SetCurrFashion(actor, 26011)
    end
end
-- ����ʥ��[ʱװ] 26013
function stdmodefunc455(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        ZhuangBan.AddFashionToVar(actor, 26013, VarCfg["T_ʱװ��¼"])
        ZhuangBan.SetCurrFashion(actor, 26013)
    end
end
-- ����֮��[ʱװ] 26021
function stdmodefunc456(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        ZhuangBan.AddFashionToVar(actor, 26021, VarCfg["T_ʱװ��¼"])
        ZhuangBan.SetCurrFashion(actor, 26021)
    end
end

-- ҹ��[ʱװ] 26022
function stdmodefunc457(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        ZhuangBan.AddFashionToVar(actor, 26022, VarCfg["T_ʱװ��¼"])
        ZhuangBan.SetCurrFashion(actor, 26022)
    end
end

-- ����[ʱװ] 26023
function stdmodefunc458(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        ZhuangBan.AddFashionToVar(actor, 26023, VarCfg["T_ʱװ��¼"])
        ZhuangBan.SetCurrFashion(actor, 26023)
    end
end

-- ����[ʱװ] 26020
function stdmodefunc459(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        ZhuangBan.AddFashionToVar(actor, 26020, VarCfg["T_ʱװ��¼"])
        ZhuangBan.SetCurrFashion(actor, 26020)
    end
end

-- ����[ʱװ] 26020
function stdmodefunc459(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        ZhuangBan.AddFashionToVar(actor, 26020, VarCfg["T_ʱװ��¼"])
        ZhuangBan.SetCurrFashion(actor, 26020)
    end
end

-- ʥ��ѩ��[ʱװ] 26028
function stdmodefunc460(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        ZhuangBan.AddFashionToVar(actor, 26028, VarCfg["T_ʱװ��¼"])
        ZhuangBan.SetCurrFashion(actor, 26028)
    end
end

-- ��������[ʱװ] 40181
function stdmodefunc461(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then  
        ZhuangBan.AddFashionToVar(actor, 40181, VarCfg["T_ʱװ��¼"])
        ZhuangBan.SetCurrFashion(actor, 40181)
    end
end

--��������[�㼣]
function stdmodefunc462(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        ZhuangBan.AddFashionToVar(actor, 63148, VarCfg["T_�㼣��¼"])
        ZhuangBan.SetCurrFashion(actor, 63148)
    end
end

--ʥ��ʱ��[�⻷]
function stdmodefunc463(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        ZhuangBan.AddFashionToVar(actor, 63151, VarCfg["T_�⻷��¼"])
        ZhuangBan.SetCurrFashion(actor, 63151)
    end
end

-- ʥ������[ʱװ] 26026
function stdmodefunc464(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then  
        ZhuangBan.AddFashionToVar(actor, 26026, VarCfg["T_ʱװ��¼"])
        ZhuangBan.SetCurrFashion(actor, 26026)
    end
end

-- ʥ��С��[ʱװ] 26027
function stdmodefunc465(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        ZhuangBan.AddFashionToVar(actor, 26027, VarCfg["T_ʱװ��¼"])
        ZhuangBan.SetCurrFashion(actor, 26027)
    end
end

--ʹ����
function stdmodefunc466(actor, item)
    if not item then
        return
    end
    local itemName = getiteminfo(actor, item, ConstCfg.iteminfo.name)
    local value = cfg_UseItem[itemName]
    if value then
        local itemNum = getiteminfo(actor, item, ConstCfg.iteminfo.overlap)
        if itemNum <= 0 then
            return
        end
        local makeId = getiteminfo(actor, item, ConstCfg.iteminfo.id)
        local total = value.value * itemNum
        local data = splitLargeNumber(2000000000, total)
        if #data > 0 then
            for _, v in ipairs(data) do
                changemoney(actor, 2, "+", v, "ʹ����Ʒ:" .. itemName, true)
            end
            delitembymakeindex(actor, makeId, itemNum, "ʹ����Ʒ")
        end
        Player.sendmsgEx(actor, string.format("[ϵͳ��ʾ]����ʹ��[%s*%d]��ã�|[Ԫ��%d]#249", itemName, itemNum, total))
    end
    stop(actor)
end

-- �������
function stdmodefunc467(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        giveitem(actor, "ʥ������",30, ConstCfg.binding, "�������")
        giveitem(actor, "ʥ��������",5, ConstCfg.binding, "�������")
    end
end
--���������Ŷ���[�ƺ�]
function stdmodefunc468(actor, item)
    if checkkuafu(actor) then
        Player.sendmsgEx(actor, "��ر���ʹ��#249")
        stop(actor)
        return
    end
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        if checktitle(actor, "���������Ŷ���") then
            messagebox(actor, "[ϵͳ��ʾ]�����Ѿ�ӵ�о��������Ŷ���ƺţ�")
            stop(actor)
            return
        else
            confertitle(actor, "���������Ŷ���", 1)
            messagebox(actor, "[ϵͳ��ʾ]���ɹ���þ��������Ŷ���ƺţ�")
        end
    end
end

--���˪�ۡ��������g���n��
function stdmodefunc469(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then  
        ZhuangBan.AddFashionToVar(actor, 26030, VarCfg["T_ʱװ��¼"])
        ZhuangBan.SetCurrFashion(actor, 26030)
        setflagstatus(actor,VarCfg["F_�ռ�ʱװ��ʶ1"],1)
    end
end

--����������ۡ��Ȼ�˻�����
function stdmodefunc470(actor, item)
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then  
        ZhuangBan.AddFashionToVar(actor, 26029, VarCfg["T_ʱװ��¼"])
        ZhuangBan.SetCurrFashion(actor, 26029)
        setflagstatus(actor,VarCfg["F_�ռ�ʱװ��ʶ2"],1)
    end
end

--���������Ŷ���[�ƺ�]
function stdmodefunc471(actor, item)
    if checkkuafu(actor) then
        Player.sendmsgEx(actor, "��ر���ʹ��#249")
        stop(actor)
        return
    end
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        if checktitle(actor, "������ڡ��������") then
            messagebox(actor, "[ϵͳ��ʾ]�����Ѿ�ӵ��������ڡ��������ƺţ�")
            stop(actor)
            return
        else
            confertitle(actor, "������ڡ��������", 1)
            messagebox(actor, "[ϵͳ��ʾ]���ɹ����������ڡ��������ƺţ�")
        end
    end
end

--���齵��[�ƺ�]
function stdmodefunc472(actor, item)
    if checkkuafu(actor) then
        Player.sendmsgEx(actor, "��ر���ʹ��#249")
        stop(actor)
        return
    end
    local titileName = "���齵��"
    local idx = getiteminfo(actor, item, ConstCfg.iteminfo.idx)
    if Bag.checkItemNum(actor, idx, 1) then
        if checktitle(actor, titileName) then
            messagebox(actor, "[ϵͳ��ʾ]�����Ѿ�ӵ��" .. titileName .. "�ƺţ�")
            stop(actor)
            return
        else
            confertitle(actor, titileName, 1)
            messagebox(actor, "[ϵͳ��ʾ]���ɹ����" .. titileName .. "�ƺţ�")
        end
    end
end