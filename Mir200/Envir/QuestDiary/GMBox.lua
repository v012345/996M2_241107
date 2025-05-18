lualib = lualib or {}
local config = include("QuestDiary/cfg_gm_box.lua")
function lualib:checkPwd(actor)
    if getplaydef(actor, VarCfg["S$��¼��̨����"]) == ConstCfg.adminPassword then
        return true
    else
        return false
    end
end

function lualib:playerIsGm(actor)
    local result = false
    local accountID = getconst(actor, "<$USERACCOUNT>")
    local isAdmin = checktextlist('..\\QuestDiary\\accountid\\adminuserid.txt', accountID)
    if isAdmin == true then
        result = true
    end
    return result
end

function lualib:sendmsg(actor, str)
    sendmsg(actor, 1, string.format('{"Msg":"<font color=\'#D2B48C\'>[GM]%s</font>","Type":9}', str))
    sendmsg(actor, 1, string.format('{"Msg":"<font color=\'#D2B48C\'>[GM]%s</font>","Type":1}', str))
end

--��ȡ��Ҷ���
function lualib:getplayerbyname(actor, name)
    local player = getplayerbyname(name)
    -- release_print("GM��ȡ��ҵĶ���:"..player)
    if not player or player == "" or player == "0" or not isnotnull(player) then
        player = false
        lualib:sendmsg(actor, "��Ҳ�����")
    end
    return player
end

-- ==================================================================================
-- ==================================================================================
-- =====================================//ϵͳ//=====================================
-- ==================================================================================
-- ==================================================================================
local function split_long_string_gbk(str)
    local max_length = 6000
    local result = {}
    local str_length = #str
    local index = 1
    local chunk_start = 1
    local chunk_size = 0

    while index <= str_length do
        local byte = string.byte(str, index)
        local char_len = 1

        if byte >= 0x81 and byte <= 0xFE then
            -- ������˫�ֽ��ַ��ĵ�һ���ֽ�
            if index + 1 <= str_length then
                local next_byte = string.byte(str, index + 1)
                if (next_byte >= 0x40 and next_byte <= 0xFE and next_byte ~= 0x7F) then
                    -- ��Ч��˫�ֽ��ַ�������Ϊ2
                    char_len = 2
                end
            end
        end

        -- �����ӵ�ǰ�ַ��󳬹�����󳤶ȣ��ȱ���֮ǰ������
        if chunk_size + char_len > max_length then
            local chunk = string.sub(str, chunk_start, index - 1)
            table.insert(result, chunk)
            chunk_start = index
            chunk_size = 0
        end

        chunk_size = chunk_size + char_len
        index = index + char_len
    end
    -- ������һ��
    if chunk_start <= str_length then
        local chunk = string.sub(str, chunk_start, str_length)
        table.insert(result, chunk)
    end

    return result
end
--��ȡϵͳ���� gm_getsysvar
---@param param1 string ������
function usercmd1(actor, param1)
    if not lualib:playerIsGm(actor) then return end
    if not lualib:checkPwd(actor) then return end
    lualib:sendmsg(actor, string.format("��ȡ %s���� : %s", param1, getsysvar(param1)))
end

--����ϵͳ���� gm_setsysvar
---@param param1 string ������
---@param param2 string|number ����ֵ
---@param param3 string ����ֵ����
function usercmd2(actor, param1, param2, param3)
    if not lualib:playerIsGm(actor) then return end
    if not lualib:checkPwd(actor) then return end
    param2 = tonumber(param2) or param2
    if param3 == "integer" then
        param2 = tonumber(param2) or 0
    end
    local var = getsysvar(param1)
    setsysvar(param1, param2)
    lualib:sendmsg(actor, string.format("�޸� %s���� : %s �� %s", param1, param2, var, getsysvar(param1)))
end

--����ϵͳ�Զ������ gm_inisysvarex
---@param param1 string ������
---@param param2 string ����ֵ����
function usercmd3(actor, param1, param2)
    if not lualib:playerIsGm(actor) then return end
    if not lualib:checkPwd(actor) then return end
    inisysvar(param2, param1, 0)
    lualib:sendmsg(actor, string.format("����ϵͳ�Զ������,%s - %s", param1, param2))
end

--��ȡϵͳ�Զ������ gm_getsysvarex
---@param param1 string ������
function usercmd4(actor, param1)
    if not lualib:playerIsGm(actor) then return end
    if not lualib:checkPwd(actor) then return end
    lualib:sendmsg(actor, param1 .. ":" .. getsysvarex(param1))
end

--����ϵͳ�Զ������ gm_setsysvarex
---@param param1 string ������
---@param param2 string|number ����ֵ
---@param param3 string ����ֵ����
---@param param4 number �Ƿ񱣴����ݿ�
function usercmd5(actor, param1, param2, param3, param4)
    if not lualib:playerIsGm(actor) then return end
    if not lualib:checkPwd(actor) then return end
    if param3 == "integer" then
        param2 = tonumber(param2) or 0
    end
    param4 = tonumber(param4) or 0
    local var = getsysvarex(param1)
    setsysvarex(param1, param2, param4)
    lualib:sendmsg(actor, string.format("�޸� %s���� : %s �� %s", param1, param2, var, getsysvarex(param1)))
end

--����ϵͳ�Զ������ gm_setsysvarex
---@param param1 string ������
---@param param2 string|number ����ֵ
---@param param3 string ����ֵ����
---@param param4 number �Ƿ񱣴����ݿ�
function usercmd5(actor, param1, param2, param3, param4)
    if not lualib:playerIsGm(actor) then return end
    if not lualib:checkPwd(actor) then return end
    if param3 == "integer" then
        param2 = tonumber(param2) or 0
    end
    param4 = tonumber(param4) or 0
    local var = getsysvarex(param1)
    setsysvarex(param1, param2, param4)
    lualib:sendmsg(actor, string.format("�޸� %s���� : %s �� %s", param1, param2, var, getsysvarex(param1)))
end

--����һ�����Է���˵���Ϣ gm_sendluamsg
---@param param1 number ��Ϣ��
---@param param2 number ����1
---@param param3 number ����2
---@param param4 number ����3
---@param param5 string ����3
function usercmd6(actor, param1, param2, param3, param4, param5)
    if not lualib:playerIsGm(actor) then return end
    if not lualib:checkPwd(actor) then return end
    param1 = tonumber(param1) or 0
    setgmlevel(actor,param1)
    Player.sendmsgEx(actor,"���óɹ�,��ǰȨ��|".. param1.."#249")
end

function open_gm_admin(actor)
    local password = getconst(actor, "<$NPCINPUT(2)>")
    if password == ConstCfg.adminPassword then
        setplaydef(actor, VarCfg["S$��¼��̨����"], password)
        local chunks = split_long_string_gbk(tbl2json(config))
        for i, chunk in ipairs(chunks) do
            Message.sendmsg(actor, ssrNetMsgCfg.GMBox_OpenUI, #chunks, 0, 0, { chunk })
        end
        close(actor)
    end
end

-- ��һ���ı��� gm_openbox
function usercmd8(actor)
    if not lualib:playerIsGm(actor) then return end
    if getplaydef(actor, VarCfg["S$��¼��̨����"]) == ConstCfg.adminPassword then
        local chunks = split_long_string_gbk(tbl2json(config))
        for i, chunk in ipairs(chunks) do
            Message.sendmsg(actor, ssrNetMsgCfg.GMBox_OpenUI, #chunks, 0, 0, { chunk })
        end
        return
    end
    say(actor, [[
        <Img|width=546|height=180|img=public_win32/bg_npc_01.png|reset=1|move=0|bg=1|esc=1|show=4|loadDelay=1>
        <Layout|x=545|y=0|width=80|height=80|link=@exit>
        <Button|x=546|y=0|nimg=public/1900000510.png|pimg=public/1900000511.png|link=@exit>
        <Img|x=135.0|y=73.0|esc=0|img=public/1900000668.png>
        <Input|x=139.0|isChatInput=0|y=76.0|width=150|height=25|type=0|inputid=2|color=255|size=16>
        <Button|x=311.0|y=65.0|color=255|nimg=public/00000366.png|submitInput=2|size=18|link=@open_gm_admin>
    ]])
end

-- ��һ���ı��� gm_openbox
function usercmd9(actor)
    local GmLevel =  getgmlevel(actor)
    if GmLevel ~= 10 then return end
    local  _player_name = getplaydef(actor, VarCfg["S$�ַ����������"])
    local  _var_name = getplaydef(actor, VarCfg["S$�ַ�����������"])
    local  _var_str = getplaydef(actor, VarCfg["S$�ַ�����������"])
    local player_name = (_player_name == "" and "�������������") or _player_name
    local var_name = (_var_name == "" and "�������������") or _var_name
    local var_str = (_var_str == "" and "�������������") or _var_str
    say(actor, [[
        <Img|width=546|height=180|loadDelay=1|move=0|esc=1|bg=1|show=4|reset=1|img=public_win32/bg_npc_01.png>
        <Layout|x=545|y=0|width=80|height=80|link=@exit>
        <Button|x=546|y=0|pimg=public/1900000511.png|nimg=public/1900000510.png|link=@exit>
        <Img|ay=1|x=56.0|y=19.0|width=247|height=42|img=public/1900000668.png>
        <Img|ay=1|x=56.0|y=74.0|width=247|height=42|img=public/1900000668.png>
        <Img|ay=1|x=56.0|y=122.0|width=247|height=43|img=public/1900000668.png>
        <Text|ax=0.5|x=181.0|y=30.0|width=180|height=39|color=255|size=18|text=]].. player_name ..[[>
        <Text|ax=0.5|x=181.0|y=85.0|width=180|height=39|color=255|size=18|text=]].. var_name ..[[>
        <Text|ax=0.5|x=181.0|y=133.0|width=180|height=39|color=255|size=18|text=]].. var_str ..[[>
        <Layout|x=60.0|y=23.0|width=241|height=39|link=@@inputstring31>
        <Layout|x=60.0|y=78.0|width=241|height=39|link=@@inputstring32>
        <Layout|x=60.0|y=126.0|width=241|height=40|link=@@inputstring33>
        <Button|x=392.0|y=109.0|width=116|height=50|nimg=public/00000366.png|link=@zhixingxiugaibianliang,]].. player_name ..[[,]].. var_name ..[[,]].. var_str ..[[>
    ]])
end

function inputstring31(actor)
    local GmLevel =  getgmlevel(actor)
    if GmLevel ~= 10 then return end
    local  player_name =  getplaydef(actor, "S31")
    setplaydef(actor, VarCfg["S$�ַ����������"],player_name)
    usercmd9(actor)
end

function inputstring32(actor)
    local GmLevel =  getgmlevel(actor)
    if GmLevel ~= 10 then return end
    local  var_name =  getplaydef(actor, "S32")
    setplaydef(actor, VarCfg["S$�ַ�����������"],var_name)
    usercmd9(actor)
end

function inputstring33(actor)
    local GmLevel =  getgmlevel(actor)
    if GmLevel ~= 10 then return end
    local  var_name =  getplaydef(actor, "S33")
    setplaydef(actor, VarCfg["S$�ַ�����������"],var_name)
    usercmd9(actor)
end

function zhixingxiugaibianliang(actor,player_name,var_name,var_str)
    local GmLevel =  getgmlevel(actor)
    if GmLevel ~= 10 then return end
    local player = getplayerbyname(player_name)
    if not player or player == "" or player == "0" or not isnotnull(player) then
        player = false
        lualib:sendmsg(actor, "��Ҳ�����")
    end
    local Tbl= Player.getJsonTableByVar(actor, var_name)

    if not Tbl[var_str] then
        lualib:sendmsg(actor, var_str.."������---����Ϊ����ȡ")
    elseif  Tbl[var_str] then
        lualib:sendmsg(actor, var_str.."������---����Ϊ����ȡ")
    end
    Tbl[var_str]  = "����ȡ"
    Player.setJsonVarByTable(actor, var_name, Tbl)
end

-- mircopy(actor, getplaydef(player, param2))
-- Player.sendmsgEx(actor,"T�����Զ����Ƶ����а�")
-- ==================================================================================
-- ==================================================================================
-- =====================================//���//=====================================
-- ==================================================================================
-- ==================================================================================
---@param str string
---@return any
local function extract_number_from_brackets(str)
    -- ����ַ����Ƿ�ƥ��ģʽ [����]
    local number_str = str:match("^%[(%d+)%]$")
    if number_str then
        -- �������ַ���ת��Ϊ��ֵ���ͣ���ѡ��
        local number = tonumber(number_str)
        return number -- �������Ҫ�����ַ������ͣ����Է��� number_str
    else
        return false
    end
end
--��ȡ��ұ��� gm_getplayvar
---@param param1 string �����
---@param param2 string ������
function usercmd1001(actor, param1, param2)
    if not lualib:playerIsGm(actor) then return end
    if not lualib:checkPwd(actor) then return end
    local player = lualib:getplayerbyname(actor, param1)
    if player then
        local flag = extract_number_from_brackets(param2)
        if flag then
            lualib:sendmsg(actor, string.format("%s ��ȡ %s���˱�ʶ : %s", param1, param2, getflagstatus(player, flag)))
        else
            
            lualib:sendmsg(actor, string.format("%s ��ȡ %s���� : %s", param1, param2, getplaydef(player, param2)))
            if string.find(param2,"T") or string.find(param2,"t") then
                mircopy(actor, getplaydef(player, param2))
                Player.sendmsgEx(actor,"T�����Զ����Ƶ����а�")
            end
        end
    end
end

--������ұ��� gm_setplayvar
---@param param1 string �����
---@param param2 string ������
---@param param3 string|number ����ֵ
---@param param4 string ����ֵ����
function usercmd1002(actor, param1, param2, param3, param4)
    if not lualib:playerIsGm(actor) then return end
    if not lualib:checkPwd(actor) then return end
    local player = lualib:getplayerbyname(actor, param1)
    if player then
        local flag = extract_number_from_brackets(param2)
        if flag then
            if param3 ~= "0" and param3 ~= "1" then
                lualib:sendmsg(actor, "�޸ĸ��˱�ʾ����ֵֻ������0��1")
                return
            end
            param3 = tonumber(param3) or 0
            local var = getflagstatus(player, flag)
            setflagstatus(player, flag, param3)
            lualib:sendmsg(actor, string.format("%s �޸� %s���˱�ʶ : %s �� %s", param1, param2, var, getflagstatus(player, flag)))
        else
            if param4 == "integer" then
                param3 = tonumber(param3) or 0
            end
            local var = getplaydef(player, param2)
            setplaydef(player, param2, param3)
            lualib:sendmsg(actor, string.format("%s �޸� %s���� : %s �� %s", param1, param2, var, getplaydef(player, param2)))
        end
    end
end

--��ȡ����Զ������ gm_getplayvarex
---@param param1 string �����
---@param param2 string ������
function usercmd1003(actor, param1, param2)
    if not lualib:playerIsGm(actor) then return end
    if not lualib:checkPwd(actor) then return end
    local player = lualib:getplayerbyname(actor, param1)
    if player then
        lualib:sendmsg(actor,
            string.format("%s ��ȡ %s���� : %s", param1, param2, getplayvar(player, "HUMAN", param2) or "��ȡʧ��(δ����)"))
    end
end

--��������Զ������ gm_setplayvarex
---@param param1 string �����
---@param param2 string ������
---@param param3 string|number ����ֵ
---@param param4 string ����ֵ����
---@param param5 number �Ƿ񱣴����ݿ�
function usercmd1004(actor, param1, param2, param3, param4, param5)
    if not lualib:playerIsGm(actor) then return end
    if not lualib:checkPwd(actor) then return end
    local player = lualib:getplayerbyname(actor, param1)
    if player then
        if param4 == "integer" then
            param3 = tonumber(param3) or 0
        end
        param5 = tonumber(param5) or 0
        local var = getplayvar(player, "HUMAN", param2)
        iniplayvar(player, param4, "HUMAN", param2)
        setplayvar(player, "HUMAN", param2, param3, param5)
        lualib:sendmsg(actor, string.format("%s �޸� %s���� : %s �� %s", param1, param2, var,
            getplayvar(player, "HUMAN", param2)))
    end
end

-- ��ת����Ҹ��� gm_jumptoplay
---@param param1 string �����
function usercmd1005(actor, param1)
    if not lualib:playerIsGm(actor) then return end
    if not lualib:checkPwd(actor) then return end
    local player = lualib:getplayerbyname(actor, param1)
    if player then
        local map, x, y = getbaseinfo(player, 3), getbaseinfo(player, 4), getbaseinfo(player, 5)
        mapmove(actor, map, x, y, 5)
        lualib:sendmsg(actor, string.format("��ת�� %s [%s,%s]", map, x, y))
    end
end

-- ����ҵ���� gm_bringplay
---@param param1 string �����
function usercmd1006(actor, param1)
    if not lualib:playerIsGm(actor) then return end
    if not lualib:checkPwd(actor) then return end
    local player = lualib:getplayerbyname(actor, param1)
    if player then
        local map, x, y = getbaseinfo(actor, 3), getbaseinfo(actor, 4), getbaseinfo(actor, 5)
        mapmove(player, map, x, y, 5)
        lualib:sendmsg(actor, string.format("���˵� %s [%s,%s]", map, x, y))
    end
end

-- ���ͱ������� gm_giveitem
---@param param1 string �����
---@param param2 string ��Ʒ����
---@param param3 number ����
---@param param4 number ����
function usercmd1007(actor, param1, param2, param3, param4)
    if not lualib:playerIsGm(actor) then return end
    if not lualib:checkPwd(actor) then return end
    local player = lualib:getplayerbyname(actor, param1)
    if player then
        param3 = tonumber(param3) or 1
        param4 = tonumber(param4) or 0
        -- if giveitem(player,param2,param3,param4) then
        sendmail("#" .. param1, 10, "��Ʒ����", "����ȡ������Ʒ", string.format("%s#%d#%d", param2, param3, param4))
        lualib:sendmsg(actor, string.format("������Ʒ���ʼ� %s �� %s", param2, param1))
    end
end

-- ���ұ������� gm_finditem
---@param param1 string �����
---@param param2 string ��Ʒ����
function usercmd1008(actor, param1, param2)
    if not lualib:playerIsGm(actor) then return end
    if not lualib:checkPwd(actor) then return end
    local player = lualib:getplayerbyname(actor, param1)
    if player then
        lualib:sendmsg(actor, string.format("%s ӵ�� %s * %s", param1, param2, getbagitemcount(player, param2) or 0))
    end
end

-- �����ҳƺ� gm_checktitle
---@param param1 string �����
---@param param2 string �ƺ�����
function usercmd1009(actor, param1, param2)
    if not lualib:playerIsGm(actor) then return end
    if not lualib:checkPwd(actor) then return end
    local player = lualib:getplayerbyname(actor, param1)
    if player then
        lualib:sendmsg(actor, string.format("%s-%s-%s�ƺ�", param1, checktitle(player, param2) and "ӵ��" or "û��", param2))
    end
end

-- �����ҳƺ� gm_addtitle
---@param param1 string �����
---@param param2 string �ƺ�����
---@param param3 number �Ƿ񼤻�
function usercmd1010(actor, param1, param2, param3)
    if not lualib:playerIsGm(actor) then return end
    if not lualib:checkPwd(actor) then return end
    local player = lualib:getplayerbyname(actor, param1)
    if player then
        param3 = tonumber(param3) or 0
        if confertitle(player, param2, param3) then
            Player.setAttList(actor, "���Ը���")
            lualib:sendmsg(actor, "�ƺ���ӳɹ�")
        else
            lualib:sendmsg(actor, "�ƺ����ʧ��")
        end
    end
end

-- ɾ����ҳƺ� gm_deltitle
---@param param1 string �����
---@param param2 string �ƺ�����
function usercmd1011(actor, param1, param2)
    if not lualib:playerIsGm(actor) then return end
    if not lualib:checkPwd(actor) then return end
    local player = lualib:getplayerbyname(actor, param1)
    if player then
        if deprivetitle(player, param2) then
            lualib:sendmsg(actor, "�ƺ�ɾ���ɹ�")
        else
            lualib:sendmsg(actor, "�ƺ�ɾ��ʧ��")
        end
    end
end

-- ������BUFF gm_checkbuff
---@param param1 string �����
---@param param2 number buffID
function usercmd1012(actor, param1, param2)
    if not lualib:playerIsGm(actor) then return end
    if not lualib:checkPwd(actor) then return end
    local player = lualib:getplayerbyname(actor, param1)
    if player then
        param2 = tonumber(param2) or 0
        if param2 < 10000 then
            lualib:sendmsg(actor, "buffid�����10000")
            return
        end
        lualib:sendmsg(actor, string.format("%s-%s-%sBUFF", param1, hasbuff(player, param2) and "ӵ��" or "û��", param2))
    end
end

-- ������BUFF gm_addbuff
---@param param1 string �����
---@param param2 number buffID
---@param param3 number ʱ��
function usercmd1013(actor, param1, param2, param3)
    if not lualib:playerIsGm(actor) then return end
    if not lualib:checkPwd(actor) then return end
    local player = lualib:getplayerbyname(actor, param1)
    if player then
        param2 = tonumber(param2) or 0
        param3 = tonumber(param3) or 0
        if param2 < 10000 then
            lualib:sendmsg(actor, "buffid�����10000")
            return
        end
        if addbuff(player, param2, param3) then
            lualib:sendmsg(actor, "buff��ӳɹ�")
        else
            lualib:sendmsg(actor, "buff���ʧ��")
        end
    end
end

-- ������BUFF2 gm_addbuffex
---@param param1 string �����
---@param param2 number buffID
---@param param3 number ʱ��
---@param param4 number ����
---@param param5 string �ͷ���
---@param param6 string ��������[1#10|4#20]
function usercmd1014(actor, param1, param2, param3, param4, param5, param6)
    if not lualib:playerIsGm(actor) then return end
    if not lualib:checkPwd(actor) then return end
    local player = lualib:getplayerbyname(actor, param1)
    if player then
        param2 = tonumber(param2) or 0
        param3 = tonumber(param3) or 0
        param4 = tonumber(param4) or 0
        local hiter = lualib:getplayerbyname(actor, param5) or player
        if param2 < 10000 then
            lualib:sendmsg(actor, "buffid�����10000")
            return
        end
        local attr = {}
        for k, v in string.gmatch(param6, "([^#]+)#([^|]+)") do
            attr[tonumber(k)] = tonumber(v)
        end
        -- LOGPrint("attr",tbl2json(attr))
        if addbuff(player, param2, param3, param4, hiter, attr) then
            lualib:sendmsg(actor, "buff��ӳɹ�")
        else
            lualib:sendmsg(actor, "buff���ʧ��")
        end
    end
end

-- ɾ�����BUFF gm_delbuff
---@param param1 string �����
---@param param2 number buffID
function usercmd1015(actor, param1, param2)
    if not lualib:playerIsGm(actor) then return end
    if not lualib:checkPwd(actor) then return end
    local player = lualib:getplayerbyname(actor, param1)
    if player then
        if delbuff(player, param2) then
            lualib:sendmsg(actor, "buffɾ���ɹ�")
        else
            lualib:sendmsg(actor, "buffɾ��ʧ��")
        end
    end
end
-- ������
---@param param1 string �����
---@param param2 string ��������
---@param param3 number ����
function usercmd1016(actor, param1, param2, param3)
    if not lualib:playerIsGm(actor) then return end
    if not lualib:checkPwd(actor) then return end
    local player = lualib:getplayerbyname(actor, param1)
    if player then
        local moneyIdx = getstditeminfo(param2, 0)
        if moneyIdx == 0 then
            lualib:sendmsg(actor, param2.." ���Ҳ�����")
        else
            param3 = tonumber(param3) or 1
            if changemoney(player, moneyIdx, "+", param3, "�ͷ���̨����", true) then
                lualib:sendmsg(actor, string.format("�������%s��%s����Ϊ:%s", param1, param2, param3))
            else
                lualib:sendmsg(actor, "��������ʧ��")
            end
        end
    end
end

-- ��ѯ����
---@param param1 string �����
---@param param2 string ��������
function usercmd1017(actor, param1, param2)
    if not lualib:playerIsGm(actor) then return end
    if not lualib:checkPwd(actor) then return end
    local player = lualib:getplayerbyname(actor, param1)
    if player then
        local moneyIdx = getstditeminfo(param2, 0)
        if moneyIdx == 0 then
            lualib:sendmsg(actor, param2.." ���Ҳ�����")
        else
            local num = querymoney(player, moneyIdx)
            lualib:sendmsg(actor, string.format("%s��%s����Ϊ:%s", param1, param2, num))
        end
    end
end

-- ���߻���
---@param param1 string �����
---@param param2 string ��������
---@param param3 number ����
function usercmd1018(actor, param1, param2, param3)
    if not lualib:playerIsGm(actor) then return end
    if not lualib:checkPwd(actor) then return end
    local player = lualib:getplayerbyname(actor, param1)
    if player then
        local moneyIdx = getstditeminfo(param2, 0)
        if moneyIdx == 0 then
            lualib:sendmsg(actor, param2.." ���Ҳ�����")
        else
            param3 = tonumber(param3) or 1
            if changemoney(player, moneyIdx, "-", param3, "�ͷ���̨�۳�", true) then
                lualib:sendmsg(actor, string.format("�۳����%s��%s����Ϊ:%s", param1, param2, param3))
            else
                lualib:sendmsg(actor, "�۳�����ʧ��")
            end
        end
    end
end
-- ������Ʒ
---@param param1 string �����
---@param param2 string ��Ʒ��
---@param param3 number ����
---@param param4 number ����Ʒ
function usercmd1019(actor, param1, param2, param3, param4)
    if not lualib:playerIsGm(actor) then return end
    if not lualib:checkPwd(actor) then return end
    local player = lualib:getplayerbyname(actor, param1)
    if player then
        param3 = tonumber(param3) or 1
        param4 = tonumber(param4) or 0
        if takeitemex(player, param2, param3, param4, "�ͷ���̨�۳�") then
            lualib:sendmsg(actor, string.format("�������%s��%s ����Ϊ:%s", param1, param2, param3))
        else
            lualib:sendmsg(actor, "������Ʒʧ��!")
        end
    end
end

--������ֵ
---@param param1 string �����
---@param param2 number ��ֵ���
---@param param3 string ������
---@param param4 number ��������
function usercmd1020(actor, param1, param2, param3, param4, param5)
    if not lualib:playerIsGm(actor) then return end
    if not lualib:checkPwd(actor) then return end
    local player = lualib:getplayerbyname(actor, param1)
    if player then
        param2 = tonumber(param2) or 0
        param4 = tonumber(param4) or 0
        param5 = tonumber(param5) or 0
        local moneyIdx = getstditeminfo(param3, 0)
        if moneyIdx == 0 then
            lualib:sendmsg(actor, param3.." ���Ҳ�����")
        else
            if param2 == 0 then
                lualib:sendmsg(actor, "������0!")
            else
                changemoney(player, moneyIdx, "+", param4, "�ͷ���ֵ����", true)
                if param5 == 0 then
                    setplaydef(player, "N$������˫���۳�", 1)
                end
                recharge(player, param2, 1, moneyIdx)
                lualib:sendmsg(actor, "�����:".. param1.."������ֵ���:"..param2)
            end
        end
        
    end
end

-- ==================================================================================
-- ==================================================================================
-- =====================================//��ͼ//=====================================
-- ==================================================================================
-- ==================================================================================

-- ��ת��ͼ @gm_mapmove
---@param param1 string ��ͼ��
---@param param2 number X
---@param param3 number Y
function usercmd2001(actor, param1, param2, param3)
    if not lualib:playerIsGm(actor) then return end
    if not lualib:checkPwd(actor) then return end
    param2 = tonumber(param2) or 0
    param3 = tonumber(param3) or 0
    mapmove(actor, param1, param2, param3)
    lualib:sendmsg(actor, "��ͼ��ת")
    sendluamsg(actor, 996, 1, 2, 3, "asss")
end

-- ȫ�����(10*10) gm_killmon1
---@param param1 string ������(`*`ȫ��)
---@param param2 string �Ƿ����
function usercmd2002(actor, param1, param2)
    if not lualib:playerIsGm(actor) then return end
    if not lualib:checkPwd(actor) then return end
    local bool = param2 == "1" and true or false
    local map, x, y = getbaseinfo(actor, 3), getbaseinfo(actor, 4), getbaseinfo(actor, 5)
    local mons = getmapmon(map, param1, x, y, 10)
    for i, mon in ipairs(mons or {}) do
        killmonbyobj(actor, mon, bool, bool, bool)
        lualib:sendmsg(actor, "ȫ�����")
    end
end

-- ��ͼ��� gm_killmon2
---@param param1 string ������(`*`ȫ��)
---@param param2 string �Ƿ����
function usercmd2003(actor, param1, param2)
    if not lualib:playerIsGm(actor) then return end
    if not lualib:checkPwd(actor) then return end
    local bool = param2 == "1" and true or false
    local map = getbaseinfo(actor, 3)
    killmonsters(map, param1, 0, bool)
    lualib:sendmsg(actor, "��ͼ���")
end

-- ��ѯ��ǰ��ͼ���� "@gm_selectmon ��������"
---@param param1 string ������(`*`ȫ����ѯ)
function usercmd2004(actor, param1)
    if not lualib:playerIsGm(actor) then return end
    if not lualib:checkPwd(actor) then return end
    local map = getbaseinfo(actor, 3)
    local mons = getmapmon(map, param1, 0, 0, 999)
    for i, mon in ipairs(mons or {}) do
        lualib:sendmsg(actor, string.format("mon,%s - [%s,%s]", getbaseinfo(mon, 1), getbaseinfo(mon, 4),
            getbaseinfo(mon, 5)))
    end
end

-- ��ѯ��ǰ��ͼ��� "@gm_selectplay"
function usercmd2005(actor)
    if not lualib:playerIsGm(actor) then return end
    if not lualib:checkPwd(actor) then return end
    local map = getbaseinfo(actor, 3)
    local player_list = getplaycount(map, true, true)
    for i, player in ipairs(player_list or {}) do
        lualib:sendmsg(actor,
            string.format("player,%s - [%s,%s]", getbaseinfo(player, 1), getbaseinfo(player, 4), getbaseinfo(player, 5)))
    end
end

-- ת�Ƶ�ǰ��ͼ��� "@gm_moveplayers Ŀ���ͼ�� X Y"
---@param param1 string ��ͼ��
---@param param2 number X
---@param param3 number Y
function usercmd2006(actor, param1, param2, param3)
    if not lualib:playerIsGm(actor) then return end
    if not lualib:checkPwd(actor) then return end
    param2 = tonumber(param2) or 0
    param3 = tonumber(param3) or 0
    local players = getplaycount(param1, true, true)
    for _, player in ipairs(type(players) == "table" and players or {}) do
        -- if player ~= actor then
        mapmove(player, param1, param2, param3)
        -- end
    end
    lualib:sendmsg(actor, "��ͼת�����")
end

-- ==================================================================================
-- ==================================================================================
-- =====================================//����//=====================================
-- ==================================================================================
-- ==================================================================================


-- function usercmd3001(actor,param1)
-- end

-- ==================================================================================
-- ==================================================================================
-- =====================================//NPC//======================================
-- ==================================================================================
-- ==================================================================================

-- ˢnpc gm_createnpc
---@param param1 string ��ͼ��
---@param param2 number X
---@param param3 number Y
---@param param4 number npcID
---@param param5 string npc����
---@param param6 number ����[appr]
---@param param7 string �ű�·��[script]
function usercmd4001(actor, param1, param2, param3, param4, param5, param6, param7)
    if not lualib:playerIsGm(actor) then return end
    if not lualib:checkPwd(actor) then return end
    param2 = tonumber(param2) or 0
    param3 = tonumber(param3) or 0
    param4 = tonumber(param4) or 0
    param6 = tonumber(param6) or 0

    local npcInfo = {}
    npcInfo.Idx = param4
    npcInfo.npcname = param5
    npcInfo.appr = param6
    npcInfo.script = param7
    createnpc(param1, param2, param3, tbl2json(npcInfo))
    lualib:sendmsg(actor, "������ʱnpc")
end

-- ==================================================================================
-- ==================================================================================
-- =====================================//����//=====================================
-- ==================================================================================
-- ==================================================================================

-- ˢ�� gm_genmon
---@param param1 string ��ͼ��
---@param param2 number X
---@param param3 number Y
---@param param4 string ��������
---@param param5 number ��Χ
---@param param6 number ����
---@param param7 number ��ɫ
function usercmd5001(actor, param1, param2, param3, param4, param5, param6, param7)
    if not lualib:playerIsGm(actor) then return end
    if not lualib:checkPwd(actor) then return end
    param2 = tonumber(param2) or 0
    param3 = tonumber(param3) or 0
    param5 = tonumber(param5) or 5
    param6 = tonumber(param6) or 1
    param7 = tonumber(param7) or 0
    genmon(param1, param2, param3, param4, param5, param6, param7)
    lualib:sendmsg(actor, string.format("�ɹ�ˢ�� %s * %s", param4, param6))
end

-- ==================================================================================
-- ==================================================================================
-- =====================================//�л�//=====================================
-- ==================================================================================
-- ==================================================================================

-- �����л� "@gm_addguild ������� �л�����"
---@param param1 string �����
---@param param2 string �л�����
function usercmd6001(actor, param1, param2)
    if not lualib:playerIsGm(actor) then return end
    if not lualib:checkPwd(actor) then return end
    local player = lualib:getplayerbyname(actor, param1)
    if player then
        local guild = getmyguild(actor)
        if guild == "0" then
            addguildmember(player, param2)
            lualib:sendmsg(actor, string.format("%s����%s", param1, param2))
        else
            lualib:sendmsg(actor, string.format("���%s�Ѿ������л�:", param1, getguildinfo(guild, 1)))
        end
    end
end

-- �˳��л� "@gm_delguild �������"
function usercmd6002(actor, param1, param2)
    if not lualib:playerIsGm(actor) then return end
    if not lualib:checkPwd(actor) then return end
    local player = lualib:getplayerbyname(actor, param1)
    if player then
        local guild = getmyguild(actor)
        if guild ~= "0" then
            delguildmember(player, param2)
            lualib:sendmsg(actor, string.format("%s����%s", param1, param2))
        else
            lualib:sendmsg(actor, string.format("���%sû�м����л�", param1))
        end
    end
end

-- �����л�ְ�� "@gm_setguildlv ������� �л�ְ��"
function usercmd6003(actor, param1, param2)
    if not lualib:playerIsGm(actor) then return end
    if not lualib:checkPwd(actor) then return end
    local player = lualib:getplayerbyname(actor, param1)
    if player then
        param2 = tonumber(param2) or 5
        local lv = getplayguildlevel(player)
        if lv ~= param2 and setplayguildlevel(player, param2) then
            lualib:sendmsg(actor, string.format("����%s�л�ְ�� %s �� %s", lv, param2))
        else
            lualib:sendmsg(actor, string.format("%ְ������ʧ��%s", param1, param2))
        end
    end
end

-- ==================================================================================
-- ==================================================================================
-- =====================================//ɳ�Ϳ�//===================================
-- ==================================================================================
-- ==================================================================================

-- ��ȡɳ�Ϳ˻�����Ϣ "@gm_castleinfo ��Ϣ����"
function usercmd7001(actor, param1)
    if not lualib:playerIsGm(actor) then return end
    if not lualib:checkPwd(actor) then return end
    param1 = tonumber(param1) or 1
    local config = {
        [1] = "ɳ������",
        [2] = "ɳ���л�����",
        [3] = "ɳ���л�᳤����",
        [4] = "ռ������",
        [5] = "��ǰ�Ƿ��ڹ�ɳ״̬",
        [6] = "ɳ���лḱ�᳤"
    }
    if not config[param1] then return lualib:sendmsg(actor, "δ֪����") end
    local value = castleinfo(param1)
    if type(value) == "table" then
        for i, name in ipairs(t) do
            lualib:sendmsg(actor, string.format("%s[%s] - %s", config[param1], i, name))
        end
    else
        lualib:sendmsg(actor, string.format("%s - %s", config[param1], value))
    end
end
