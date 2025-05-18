local MiLuBaoZang = {}
MiLuBaoZang.ID = "��¹����"
local npcID = 157
--local config = include("QuestDiary/cfgcsv/cfg_MiLuBaoZang.lua") --����
local cost = {{}}
local give = {{}}

--��ȡ����
function MiLuBaoZang.getVariableState(actor)
    local Num1 = getplaydef(actor, VarCfg["J_��¹���ؽ������"])
    local _Num2 = getplaydef(actor, VarCfg["Z_��¹���ؽ�������"])
    local Num2 = (_Num2 == "" and 3) or (_Num2 == nil and 3) or tonumber(_Num2)
    return Num1, Num2
end

--��������
function MiLuBaoZang.Request(actor, var)
    local Num1, Num2 = MiLuBaoZang.getVariableState(actor)
    if var == 1 then
        if Num1 >= Num2 then
            Player.sendmsgEx(actor, "��ʾ#251|:#255|�Բ���,|��������#249|�����Ӵ���...")
            return
        end
        setplaydef(actor, VarCfg["J_��¹���ؽ������"], Num1 + 1)
        MiLuBaoZang.SyncResponse(actor)

        local NowMapID = getbaseinfo(actor, ConstCfg.gbase.mapid)
        local NowX,NowY = getbaseinfo(actor, ConstCfg.gbase.x),getbaseinfo(actor, ConstCfg.gbase.y)
        local HuiChenginfo = {["NowMapID"] = NowMapID,["NowX"] = NowX,["NowY"] = NowY}
        Player.setJsonVarByTable(actor, VarCfg["T_���븱����¼�˳���Ϣ"] , HuiChenginfo)

        local UserName = getbaseinfo(actor, ConstCfg.gbase.name)
        local NewMapId = "heicibaoku"..UserName --����ԭʼ��ͼid  �����µ�ͼID
        local NewMapName = "��¹����".."[����]"
        if checkmirrormap(NewMapId) then
            killmonsters(NewMapId, "*", 0, false)   --ɱ����ǰ��ͼ���й���
            delmirrormap(NewMapId)              --ɾ�������ͼ
            addmirrormap("heicibaoku", NewMapId, NewMapName, 120, NowMapID, nil, NowX, NowY)
        else
            addmirrormap("heicibaoku", NewMapId, NewMapName, 120, NowMapID, nil, NowX, NowY)
        end

        killcopyself(actor) --ɱ�����з���
        local ncount = getbaseinfo(actor, 38)
        for i = 0, ncount - 1 do
            local mon = getslavebyindex(actor, i)
            killmonbyobj(actor, mon, false, false, true) --ɱ������
        end
        mapmove(actor, NewMapId, 25, 36, 2)
        senddelaymsg(actor, "��¹����ʣ��ʱ��:%s", 120, 250, 1)
        --ˢBoss
        genmon(NewMapId, 26, 35, "ʥ����¹", 1, 1, 249)
    end

    if var == 2 then
        if Num2 == 8 then
            Player.sendmsgEx(actor, "��ʾ#251|:#255|������Ѿ�����|5��#249|��,����������...")
            return
        end
        if querymoney(actor, 7) < 200 then
            Player.sendmsgEx(actor,"[��ʾ]:#251|�û�ʧ��,���|���#249|����|200ö#249|����ʧ��...")
            return
        end
        changemoney(actor, 7, "-", 200, "���������¹���ش���", true)
        setplaydef(actor, VarCfg["Z_��¹���ؽ�������"], Num2 + 1)
        MiLuBaoZang.SyncResponse(actor)
    end
end

--ͬ����Ϣ
function MiLuBaoZang.SyncResponse(actor, logindatas)
    local Num1, Num2 = MiLuBaoZang.getVariableState(actor)
    local data = {Num1, Num2}
    local _login_data = {ssrNetMsgCfg.MiLuBaoZang_SyncResponse, 0, 0, 0, data}
    if type(logindatas) == "table" then
        table.insert(logindatas, _login_data)
    else
        Message.sendmsg(actor, ssrNetMsgCfg.MiLuBaoZang_SyncResponse, 0, 0, 0, data)
    end
end

--��¼����
local function _onLoginEnd(actor, logindatas)
    MiLuBaoZang.SyncResponse(actor, logindatas)
end
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, MiLuBaoZang)

--��������
local function _onAttackMonster(actor, Target, Hiter, MagicId, qieGe, monName)
    if monName == "ʥ����¹" then
        local mapid = getbaseinfo(actor, ConstCfg.gbase.mapid)
        local x,y = getbaseinfo(Target, ConstCfg.gbase.x),getbaseinfo(Target, ConstCfg.gbase.y)
        local items = {
            ["500Ԫ��"] = math.random(1, 3),
            ["��Һ��(��)"] = math.random(1, 14),
        }

        if randomex(1, 80) then
            items["��¹������"] = 1
        end
        if randomex(1, 15) then
            items["ʥ������"] = 1
        end
        gendropitem(mapid,actor,x,y,tbl2json(items),nil)
        -- throwitem(actor, mapid, x, y, 1, "��ʯ", 1, 1, false, false)
    end
end
GameEvent.add(EventCfg.onAttackMonster, _onAttackMonster, MiLuBaoZang)

--ע��������Ϣ
Message.RegisterNetMsg(ssrNetMsgCfg.MiLuBaoZang, MiLuBaoZang)
return MiLuBaoZang