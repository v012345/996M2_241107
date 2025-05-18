local FuLiDaTing = {}
FuLiDaTing.ID = "��������"
local npcID = 0
FuLiDaTing.configCache = include("QuestDiary/cfgcsv/cfg_FuLiDaTing.lua")            --����
FuLiDaTing.shouShaConfig = include("QuestDiary/cfgcsv/cfg_GeRenShouSha.lua")        --���ø�����ɱ
FuLiDaTing.geRenShouBaoConfig = include("QuestDiary/cfgcsv/cfg_GeRenShouBao.lua")   --���ø����ױ�
FuLiDaTing.quanFuShouBaoConfig = include("QuestDiary/cfgcsv/cfg_QuanQuShouBao.lua") --����ȫ���ױ�
local cost = { {} }
local give = { {} }

FuLiDaTing.Cache = {}

FuLiDaTing.config = {}
local function CopyTable(tab) --���
    function _copy(obj)
        if type(obj) ~= "table" then
            return obj
        end
        local new_table = {}
        for k, v in pairs(obj) do
            new_table[_copy(k)] = _copy(v)
        end
        return setmetatable(new_table, getmetatable(obj))
    end

    return _copy(tab)
end

for k, v in pairs(FuLiDaTing.configCache) do
    if type(k) == "number" then
        if FuLiDaTing.config[v.type] == nil then
            FuLiDaTing.config[v.type] = {}
        end

        if FuLiDaTing.config[v.type][v.number] == nil then
            local tb = CopyTable(v)
            tb.number = nil
            tb.type = nil
            FuLiDaTing.config[v.type][v.number] = tb
        end
    end
end
--ͬ�����ݺ�򿪽���
function FuLiDaTing.SyncResponse(actor)
    --release_print("ͬ�����ݺ�򿪽���")
    Message.sendmsg(actor, ssrNetMsgCfg.FuLiDaTing_Submit1, 0, 0, 0, FuLiDaTing.getContentData(actor))
    Message.sendmsg(actor, ssrNetMsgCfg.FuLiDaTing_Submit2, 0, 0, 0, FuLiDaTing.getGeRenShouBaoData(actor))
    Message.sendmsg(actor, ssrNetMsgCfg.FuLiDaTing_Submit3, 0, 0, 0, FuLiDaTing.getGeRenShouShaData(actor))
    Message.sendmsg(actor, ssrNetMsgCfg.FuLiDaTing_OpenUI, 0, 0, 0, nil)
end

--��������
function FuLiDaTing.UpdateResponse(actor)
    Message.sendmsg(actor, ssrNetMsgCfg.FuLiDaTing_Submit1, 0, 0, 0, FuLiDaTing.getContentData(actor))
    Message.sendmsg(actor, ssrNetMsgCfg.FuLiDaTing_Submit2, 0, 0, 0, FuLiDaTing.getGeRenShouBaoData(actor))
    Message.sendmsg(actor, ssrNetMsgCfg.FuLiDaTing_Submit3, 0, 0, 0, FuLiDaTing.getGeRenShouShaData(actor))
    Message.sendmsg(actor, ssrNetMsgCfg.FuLiDaTing_Update, 0, 0, 0, nil)
end

--��������
function FuLiDaTing.Request(actor, param1, param2)
    local page = tonumber(param1)
    if page == 1 then
        FuLiDaTing.ZaiXian(actor, tonumber(param2))
    elseif page == 2 then
        FuLiDaTing.ShaGuai(actor, tonumber(param2))
    elseif page == 3 then
        FuLiDaTing.ChongJi(actor, tonumber(param2))
    elseif page == 4 then
        FuLiDaTing.GeRenShouBao(actor, tonumber(param2))
    elseif page == 5 then
        FuLiDaTing.GeRenShouSha(actor, tonumber(param2))
    elseif page == 6 then

    elseif page == 7 then
        FuLiDaTing.XunHuan(actor,tonumber(param2))
    end
end

--���߽���
function FuLiDaTing.ZaiXian(actor, page)
    if page < 1 or page > #FuLiDaTing.config[1] then
        return ""
    end

    local times = getplaydef(actor, VarCfg["J_����ʱ��"])
    local receive = getplaydef(actor, VarCfg["J_����ʱ����ȡ"])
    if receive + 1 ~= page then
        Player.sendmsgEx(actor, "��ʾ#251|:#255|�밴˳����ȡ����!")
        return ""
    end
    if times < FuLiDaTing.config[1][page].need then
        Player.sendmsgEx(actor, "��ʾ#251|:#255|����ʱ�䲻���޷���ȡ!")
        return ""
    end
    if receive >= #FuLiDaTing.config[1] then
        Player.sendmsgEx(actor, "��ʾ#251|:#255|�Ѿ������������߽�����!")
        return ""
    end

    Player.giveItemByTable(actor, FuLiDaTing.config[1][page].award, page .. "���߽�����ȡ", 1, true)
    setplaydef(actor, VarCfg["J_����ʱ����ȡ"], receive + 1)
    Player.sendmsgEx(actor, "��ʾ#251|:#255|��ȡ�ɹ�!")
    local flag = FuLiDaTing.UpdateRedPoint(actor)
    if getplaydef(actor, "N$�����������") ~= flag then
        setplaydef(actor, "N$�����������", flag)
    end
    FuLiDaTing.UpdateResponse(actor)
    return ""
end

--ÿ��ɱ��
function FuLiDaTing.ShaGuai(actor, page)
    if page < 1 or page > #FuLiDaTing.config[2] then
        return ""
    end

    local num = getplaydef(actor, VarCfg["J_ÿ��ɱ������"])
    local receive = getplaydef(actor, VarCfg["J_ÿ��ɱ��������ȡ"])
    if receive + 1 ~= page then
        Player.sendmsgEx(actor, "��ʾ#251|:#255|�밴˳����ȡ����!")
        return ""
    end

    if num < FuLiDaTing.config[2][page].need then
        Player.sendmsgEx(actor, "��ʾ#251|:#255|ÿ��ɱ�ֲ����޷���ȡ!")
        return ""
    end

    if receive >= #FuLiDaTing.config[2] then
        Player.sendmsgEx(actor, "��ʾ#251|:#255|�Ѿ���������ÿ��ɱ����!")
        return ""
    end

    Player.giveItemByTable(actor, FuLiDaTing.config[2][page].award, page .. "���߽�����ȡ", 1, true)
    setplaydef(actor, VarCfg["J_ÿ��ɱ��������ȡ"], receive + 1)
    Player.sendmsgEx(actor, "��ʾ#251|:#255|��ȡ�ɹ�!")
    local flag = FuLiDaTing.UpdateRedPoint(actor)
    if getplaydef(actor, "N$�����������") ~= flag then
        setplaydef(actor, "N$�����������", flag)
    end
    FuLiDaTing.UpdateResponse(actor)
    return ""
end

--�������
function FuLiDaTing.ChongJi(actor, page)
    if page < 1 or page > #FuLiDaTing.config[3] then
        return ""
    end
    local _data = FuLiDaTing.getDengJiJiangLiData(actor)
    if _data[2][page] == 1 then
        Player.sendmsgEx(actor, "��ʾ#251|:#255|���Ѿ���ȡ���ý���!")
        return ""
    end

    if type(FuLiDaTing.config[3][page].num) == "number" then
        if FuLiDaTing.config[3][page].num - _data[3][page] < 1 then
            Player.sendmsgEx(actor, "��ʾ#251|:#255|�ý����Ѿ���ȫ����ȡ��!")
            return ""
        end
    end

    if _data[1] < FuLiDaTing.config[3][page].need then
        Player.sendmsgEx(actor, "��ʾ#251|:#255|��ĵȼ����㣬�޷���ȡ�ý���!")
        return ""
    end
    _data[2][page] = 1
    _data[3][page] = _data[3][page] + 1
    setplaydef(actor, VarCfg["T_�ȼ�����"], tbl2json(_data[2]))
    setsysvar(VarCfg["A_ȫ���ȼ�����"], tbl2json(_data[3]))
    Player.sendmsgEx(actor, "��ʾ#251|:#255|��ȡ�ɹ�!")
    Player.giveItemByTable(actor, FuLiDaTing.config[3][page].award, "�弶������ȡ", 1, true)
    local flag = FuLiDaTing.UpdateRedPoint(actor)
    if getplaydef(actor, "N$�����������") ~= flag then
        setplaydef(actor, "N$�����������", flag)
    end
    FuLiDaTing.UpdateResponse(actor)
    return ""
end

--�����ױ�
function FuLiDaTing.GeRenShouBao(actor, page)
    local idx = tonumber(page)
    local _data = FuLiDaTing.getGeRenShouBaoData(actor)
    local flag = 0
    for i = 1, #FuLiDaTing.geRenShouBaoConfig do
        if getstditeminfo(FuLiDaTing.geRenShouBaoConfig[i].name, 0) == idx then
            flag = i
            break
        end
    end

    if flag == 0 then
        Player.sendmsgEx(actor, "��ʾ#251|:#255|�õ���û���ױ�����!")
        return ""
    end

    if _data[tostring(idx)] == nil then
        Player.sendmsgEx(actor, "��ʾ#251|:#255|���ȱ���" .. FuLiDaTing.geRenShouBaoConfig[flag].name .. "!")
        return ""
    end

    if _data[tostring(idx)] == 2 then
        Player.sendmsgEx(actor, "��ʾ#251|:#255|���Ѿ���ȡ����!")
        return ""
    end

    _data[tostring(idx)] = 2
    if FuLiDaTing.Cache[actor] == nil then
        FuLiDaTing.Cache[actor] = {}
    end

    FuLiDaTing.Cache[actor]["��������"] = _data
    --release_print(tbl2json(FuLiDaTing.Cache[actor]["��������"]),tbl2json(_data))
    setplaydef(actor, VarCfg["T_�����ױ�"], tbl2json(_data))
    Player.sendmsgEx(actor, "��ʾ#251|:" .. FuLiDaTing.geRenShouBaoConfig[flag].name .. "#255|��ȡ�ɹ�!")
    Player.giveItemByTable(actor, FuLiDaTing.geRenShouBaoConfig[flag].give,
        FuLiDaTing.geRenShouBaoConfig[flag].name .. "�����ױ�������ȡ", 1, true)
    FuLiDaTing.UpdateResponse(actor)
    local flag = FuLiDaTing.UpdateRedPoint(actor)
    if getplaydef(actor, "N$�����������") ~= flag then
        setplaydef(actor, "N$�����������", flag)
    end
    return ""
end

--������ɱ
function FuLiDaTing.GeRenShouSha(actor, page)
    local idx = tonumber(page)

    local _data = FuLiDaTing.getGeRenShouShaData(actor)
    local flag = 0
    for i = 1, #FuLiDaTing.shouShaConfig do
        if FuLiDaTing.shouShaConfig[i].id == idx then
            flag = i
            break
        end
    end

    if flag == 0 then
        Player.sendmsgEx(actor, "��ʾ#251|:#255|�ù���û����ɱ����!")
        return ""
    end

    if _data[tostring(idx)] == nil then
        Player.sendmsgEx(actor, "��ʾ#251|:#255|���Ȼ�ɱ" .. FuLiDaTing.shouShaConfig[flag].name .. "!")
        return ""
    end

    if _data[tostring(idx)] == 2 then
        Player.sendmsgEx(actor, "��ʾ#251|:#255|���Ѿ���ȡ����!")
        return ""
    end

    _data[tostring(idx)] = 2
    setplaydef(actor, VarCfg["T_������ɱ"], tbl2json(_data))
    Player.giveItemByTable(actor, FuLiDaTing.shouShaConfig[flag].give, page .. "���߽�����ȡ", 1, true)
    FuLiDaTing.UpdateResponse(actor)
    local flag = FuLiDaTing.UpdateRedPoint(actor)
    if getplaydef(actor, "N$�����������") ~= flag then
        setplaydef(actor, "N$�����������", flag)
    end
    return ""
end

--ѭ�����
function FuLiDaTing.XunHuan(actor,sign)
    -- local flag = FuLiDaTing.UpdateRedPoint(actor)
    -- release_print(flag,getplaydef(actor,"N$�����������"))
    -- if getplaydef(actor,"N$�����������") ~= flag then
    --     setplaydef(actor,"N$�����������",flag)
    -- end
    if FuLiDaTing.config[7][sign] == nil then
        release_print("�޸Ŀͻ�������")
        return ""
    end
    
    local money = querymoney(actor, 11) ---����
    if money < FuLiDaTing.config[7][sign].need then
        Player.sendmsgEx(actor, "��ʾ#251|:#255|��ĳ�ֵ���ֲ���" .. FuLiDaTing.config[7][sign].need .. "!")
        return ""
    end

    changemoney(actor, 11, "-", FuLiDaTing.config[7][sign].need, "��ȡѭ�����", true)
    Player.giveItemByTable(actor, FuLiDaTing.config[7][sign].award, "��ȡѭ�����", 1, true)
    Player.sendmsgEx(actor, "��ʾ#251|:#255|��ȡ�ɹ�!")
    FuLiDaTing.UpdateResponse(actor)
    local flag = FuLiDaTing.UpdateRedPoint(actor)
    if getplaydef(actor, "N$�����������") ~= flag then
        setplaydef(actor, "N$�����������", flag)
    end
    return ""
end

--��õȼ���������
function FuLiDaTing.getDengJiJiangLiData(actor)
    local data = { getbaseinfo(actor, 6), {}, {} }
    local lv = getplaydef(actor, VarCfg["T_�ȼ�����"])
    local all = getsysvar(VarCfg["A_ȫ���ȼ�����"])

    if lv == "" then
        data[2] = { 0, 0, 0, 0, 0 }
    else
        data[2] = json2tbl(lv)
    end

    if all == "" then
        data[3] = { 0, 0, 0, 0, 0 }
    else
        data[3] = json2tbl(all)
    end

    return data
end

--��ø����ױ�����
function FuLiDaTing.getGeRenShouBaoData(actor)
    local data = getplaydef(actor, VarCfg["T_�����ױ�"])
    if data == "" then
        data = {}
    else
        data = json2tbl(data)
    end

    return data
end

--���ȫ���ױ�����
function FuLiDaTing.getQuanQuShouBaoData(actor)
    local data = getsysvar(VarCfg["A_ȫ���ױ�"])
    if data == "" then
        data = {}
    else
        data = json2tbl(data)
    end
    return data
end

--��ȡ������ɱ����
function FuLiDaTing.getGeRenShouShaData(actor)
    local data = getplaydef(actor, VarCfg["T_������ɱ"])
    if data == "" then
        data = {}
    else
        data = json2tbl(data)
    end

    return data
end

--�ͻ�������
function FuLiDaTing.getContentData(actor)
    local data = {}
    data[1] = { getplaydef(actor, VarCfg["J_����ʱ��"]), getplaydef(actor, VarCfg["J_����ʱ����ȡ"]) } --����ʱ��
    data[2] = { getplaydef(actor, VarCfg["J_ÿ��ɱ������"]), getplaydef(actor, VarCfg["J_ÿ��ɱ��������ȡ"]) } --ɱ������
    data[3] = FuLiDaTing.getDengJiJiangLiData(actor) --�ȼ�
    data[4] = {} --FuLiDaTing.getGeRenShouBaoData(actor)        --�����ױ�
    data[5] = {} --FuLiDaTing.getGeRenShouShaData(actor)        --������ɱ
    data[6] = FuLiDaTing.getQuanQuShouBaoData(actor) --ȫ���ױ�
    data[7] = querymoney(actor, 11) --��ֵ����
    return data
end

----��¼����
local function _onLoginEnd(actor, logindatas)
    FuLiDaTing.UpdateRedPoint(actor)
    --�������ػ���
    FuLiDaTing.onCache(actor)
end

local function _ClearVar(actor)
    FuLiDaTing.Cache[actor] = nil
end
--ɱ�ִ���
local function _onKillMon(actor, monobj, monName)
    --release_print(getplaydef(actor,VarCfg["U_ɱ������"]))
    local num = getplaydef(actor, VarCfg["J_ÿ��ɱ������"])
    setplaydef(actor, VarCfg["J_ÿ��ɱ������"], num + 1)

    if getplaydef(actor, "N$�����������") == 0 then
        local receive = getplaydef(actor, VarCfg["J_ÿ��ɱ��������ȡ"])
        if receive < #FuLiDaTing.config[2] then
            if FuLiDaTing.config[2][receive + 1].need <= num + 1 then
                setplaydef(actor, "N$�����������", 1)
            end
        end
    end

    if FuLiDaTing.shouShaConfig[monName] ~= nil then
        local _data = FuLiDaTing.getGeRenShouShaData(actor)
        local idx = getdbmonfieldvalue(monName, "idx")
        if _data[tostring(idx)] == nil then
            _data[tostring(idx)] = 1
            if getplaydef(actor, "N$�����������") == 0 then
                setplaydef(actor, "N$�����������", 1)
            end
            setplaydef(actor, VarCfg["T_������ɱ"], tbl2json(_data))
            Player.sendmsgEx(actor, "��ʾ#251|:#255|���|" .. monName .. "#249|��ɱ����...")
        end
    end
end
--���ػ���
function FuLiDaTing.onCache(actor)
    if FuLiDaTing.Cache[actor] == nil then
        FuLiDaTing.Cache[actor] = {}
    end
    FuLiDaTing.Cache[actor]["��������"] = FuLiDaTing.getGeRenShouBaoData(actor)
end

--ע���¼�

--�������ߴ���
local function _goPickUpItemEx(actor, itemobj, itemID, itemMakeIndex, ItemName)
    if FuLiDaTing.geRenShouBaoConfig[ItemName] ~= nil then
        --release_print(tbl2json(FuLiDaTing.Cache[actor]["��������"]))
        if FuLiDaTing.Cache[actor] == nil then
            --release_print("����Ϊ��")
            FuLiDaTing.onCache(actor)
        end

        local _data = FuLiDaTing.Cache[actor]["��������"] --FuLiDaTing.getGeRenShouBaoData(actor)
        if _data[tostring(itemID)] == nil then
            _data[tostring(itemID)] = 1
            if getplaydef(actor, "N$�����������") == 0 then
                setplaydef(actor, "N$�����������", 1)
            end

            if FuLiDaTing.geRenShouBaoConfig[ItemName].zd == 1 then
                scenevibration(actor, 0, 1, 1)
            end

            FuLiDaTing.Cache[actor]["��������"] = _data
            -- dump(FuLiDaTing.Cache[actor]["��������"])
            setplaydef(actor, VarCfg["T_�����ױ�"], tbl2json(_data))
            Player.sendmsgEx(actor, "��ʾ#251|:#255|���|" .. ItemName .. "#249|�ױ�����...")
        end
    end

    if FuLiDaTing.quanFuShouBaoConfig[ItemName] ~= nil then
        local _data = FuLiDaTing.getQuanQuShouBaoData(actor)
        if _data[tostring(itemID)] == nil then
            local name = getbaseinfo(actor, 1)
            _data[tostring(itemID)] = name
            scenevibration(actor, 0, 1, 1)
            setsysvar(VarCfg["A_ȫ���ױ�"], tbl2json(_data))
            --sendmovemsg(actor,1)
            --��ϲ***����***װ������ ��ȡ���ؽ���***���
            sendmail("#" .. name, 1, "ȫ���ױ�����", "��ϲ��á�" .. ItemName .. "��ȫ���ױ�����",
                FuLiDaTing.quanFuShouBaoConfig[ItemName].give[1][1] ..
                "#" .. FuLiDaTing.quanFuShouBaoConfig[ItemName].give[1][2])
            Player.sendmsgEx(actor, "��ʾ#251|:#255|���|" .. ItemName .. "#249|ȫ���ױ������ѷ����ʼ�...")
            sendmovemsg(actor, 1, 251, 0, 100, 1,
                "{����ϲ����/FCOLOR=250}{��" ..
                name ..
                "��/FCOLOR=249}{�ɹ�ʰȡ/FCOLOR=250}{��" ..
                ItemName ..
                "�� ��ȡ/FCOLOR=249} {���ؽ���/FCOLOR=250}{" ..
                FuLiDaTing.quanFuShouBaoConfig[ItemName].give[1][2] .. "���/FCOLOR=249}")
            sendmovemsg(actor, 1, 251, 0, 130, 1,
                "{����ϲ����/FCOLOR=250}{��" ..
                name ..
                "��/FCOLOR=249}{�ɹ�ʰȡ/FCOLOR=250}{��" ..
                ItemName ..
                "�� ��ȡ/FCOLOR=249} {���ؽ���/FCOLOR=250}{" ..
                FuLiDaTing.quanFuShouBaoConfig[ItemName].give[1][2] .. "���/FCOLOR=249}")
            sendmovemsg(actor, 1, 251, 0, 160, 1,
                "{����ϲ����/FCOLOR=250}{��" ..
                name ..
                "��/FCOLOR=249}{�ɹ�ʰȡ/FCOLOR=250}{��" ..
                ItemName ..
                "�� ��ȡ/FCOLOR=249} {���ؽ���/FCOLOR=250}{" ..
                FuLiDaTing.quanFuShouBaoConfig[ItemName].give[1][2] .. "���/FCOLOR=249}")
        end
    end
end
--�������
function FuLiDaTing.UpdateRedPoint(actor)
    local num = getplaydef(actor, "N$�����������")
    --
    local flag = 0
    local data = FuLiDaTing.getContentData(actor)
    --release_print(tbl2json(data))
    if data[1][2] < #FuLiDaTing.config[1] then
        if FuLiDaTing.config[1][data[1][2] + 1].need <= data[1][1] then
            flag = 1
        end
    end
    -- release_print("��������_1_"..flag)
    if flag == 1 then
        setplaydef(actor, "N$�����������", 1)
        --Message.sendmsg(actor, ssrNetMsgCfg.FuLiDaTing_UpdateRedPoint, 1, 0, 0, nil)
        return flag
    end

    if data[2][2] < #FuLiDaTing.config[2] then
        if FuLiDaTing.config[2][data[2][2] + 1].need <= data[2][1] then
            flag = 1
        end
    end
    -- release_print("��������_2_"..flag)
    if flag == 1 then
        setplaydef(actor, "N$�����������", 1)
        -- Message.sendmsg(actor, ssrNetMsgCfg.FuLiDaTing_UpdateRedPoint, 1, 0, 0, nil)
        return flag
    end

    for i = 1, #FuLiDaTing.config[3] do
        if type(FuLiDaTing.config[3][i].num) == "number" then
            if data[3][2][i] == 0 then
                if data[3][3][i] < FuLiDaTing.config[3][i].num then
                    if data[3][1] >= FuLiDaTing.config[3][i].need then
                        flag = 1
                        break
                    end
                end
            end
        else
            if data[3][2][i] == 0 then
                if data[3][1] >= FuLiDaTing.config[3][i].need then
                    flag = 1
                    break
                end
            end
        end
    end
    -- release_print("��������_3_"..flag)
    if flag == 1 then
        setplaydef(actor, "N$�����������", 1)
        --Message.sendmsg(actor, ssrNetMsgCfg.FuLiDaTing_UpdateRedPoint, 1, 0, 0, nil)
        return flag
    end

    data[4] = FuLiDaTing.getGeRenShouBaoData(actor)
    for i = 1, #FuLiDaTing.geRenShouBaoConfig do
        local idx = getstditeminfo(FuLiDaTing.geRenShouBaoConfig[i].name, 0)
        if data[4][tostring(idx)] == 1 then
            flag = 1
            break
        end
    end
    -- release_print("��������_4_"..flag)
    if flag == 1 then
        setplaydef(actor, "N$�����������", 1)
        --Message.sendmsg(actor, ssrNetMsgCfg.FuLiDaTing_UpdateRedPoint, 1, 0, 0, nil)
        return flag
    end

    data[5] = FuLiDaTing.getGeRenShouShaData(actor)
    for i = 1, #FuLiDaTing.shouShaConfig do
        local idx = FuLiDaTing.shouShaConfig[i].id
        if data[5][tostring(idx)] == 1 then
            flag = 1
            break
        end
    end
    -- release_print("��������_5_"..flag)
    if flag == 1 then
        setplaydef(actor, "N$�����������", 1)
        --Message.sendmsg(actor, ssrNetMsgCfg.FuLiDaTing_UpdateRedPoint, 1, 0, 0, nil)
        return flag
    end

    if data[7] >= FuLiDaTing.config[7][1].need then
        flag = 1
    end
    -- release_print("��������_7_"..flag)
    if flag == 1 then
        setplaydef(actor, "N$�����������", 1)
        --Message.sendmsg(actor, ssrNetMsgCfg.FuLiDaTing_UpdateRedPoint, 1, 0, 0, nil)
        return flag
    end

    return flag
end

--��������
local function _onLevelUp(actor, cur_level, before_level)
    --release_print("222222")
    --release_print(before_level.."�ȼ�"..getplaydef(actor,"N$�����������"))
    if getplaydef(actor, "N$�����������") == 0 then
        local data = FuLiDaTing.getDengJiJiangLiData(actor)
        for i = 1, #FuLiDaTing.config[3] do
            if type(FuLiDaTing.config[3][i].num) == "number" then
                if data[2][i] == 0 then
                    if data[3][i] < FuLiDaTing.config[3][i].num then
                        if data[1] >= FuLiDaTing.config[3][i].need then
                            setplaydef(actor, "N$�����������", 1)
                            break
                        end
                    end
                end
            else
                if data[2][i] == 0 then
                    if data[1] >= FuLiDaTing.config[3][i].need then
                        setplaydef(actor, "N$�����������", 1)
                        break
                    end
                end
            end
        end
    end
    --release_print("2222221")
end
--��ֵ���ָı�
local function _OverloadMoneyJiFen(actor, num)
    if getplaydef(actor, "N$�����������") == 0 then
        -- release_print(num,FuLiDaTing.config[7][1].need)
        if num > FuLiDaTing.config[7][1].need then
            setplaydef(actor, "N$�����������", 1)
        end
    end
end

local function _onTimer104(actor)
    --release_ptint("_onTimer104")
    --release_print("��ʱ������_onTimer104")
    if getplaydef(actor, "N$�����������") == 0 then
        local data = { getplaydef(actor, VarCfg["J_����ʱ��"]), getplaydef(actor, VarCfg["J_����ʱ����ȡ"]) }
        if data[2] < #FuLiDaTing.config[1] then
            if FuLiDaTing.config[1][data[2] + 1].need <= data[1] then
                setplaydef(actor, "N$�����������", 1)
            end
        end
    end
end

-- --�¼��ɷ�
GameEvent.add(EventCfg.onExitGame, _ClearVar, FuLiDaTing)
GameEvent.add(EventCfg.onTriggerChat, _ClearVar, FuLiDaTing)
GameEvent.add(EventCfg.onTimer104, _onTimer104, FuLiDaTing)
GameEvent.add(EventCfg.OverloadMoneyJiFen, _OverloadMoneyJiFen, FuLiDaTing)
GameEvent.add(EventCfg.onPlayLevelUp, _onLevelUp, FuLiDaTing)
GameEvent.add(EventCfg.goPickUpItemEx, _goPickUpItemEx, FuLiDaTing)
GameEvent.add(EventCfg.onKillMon, _onKillMon, FuLiDaTing)
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, FuLiDaTing)
--ע��������Ϣ
Message.RegisterNetMsg(ssrNetMsgCfg.FuLiDaTing, FuLiDaTing)
return FuLiDaTing
