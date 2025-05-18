local TongGuanWenDie = {}
TongGuanWenDie.ID = "ͨ�����"
local config = include("QuestDiary/cfgcsv/cfg_TongGuanWenDie.lua") --����
local MainConditions = include("QuestDiary/game/R/GetJQMainConditions.lua")   --����
local cost = {{}}
local give = {{}}
local function allTrue(array)
    for i = 1, #array do
        local element = array[i]
        if type(element) == "table" then
            if #element == 2 then
                if element[1] < element[2] then
                    return false
                end
            else
                return false
            end
        elseif type(element) == "boolean" then
            if not element then
                return false
            end
        else
            return false
        end
    end
    return true
end
--��������
function TongGuanWenDie.Request(actor,index,npcID)
    -- release_print(npcID)
    local taskList = Player.getJsonTableByVar(actor,VarCfg["T_ͨ�������ȡ��¼"])
    local cfg = config[npcID]
    if not cfg then
        Player.sendmsgEx(actor, "��������1#249")
        return
    end
    if taskList[tostring(index)] then
        Player.sendmsgEx(actor, "����ȡ#249")
        return
    end
    local func = MainConditions[index]
    if not func then
        Player.sendmsgEx(actor, "��������#249")
        return
    end
    local data = MainConditions[index](actor)
    if not data then
        Player.sendmsgEx(actor, "��������#249")
        return
    end
    local bool = allTrue(data)
    if not bool then
        Player.sendmsgEx(actor, "��û�����ȫ����������,�޷���ȡ#249")
        return
    end
    taskList[tostring(index)] = 1
    Player.setJsonVarByTable(actor,VarCfg["T_ͨ�������ȡ��¼"],taskList)
    local userId = getbaseinfo(actor,ConstCfg.gbase.id)
    confertitle(actor, cfg.title, 1)
    Player.setAttList(actor,"���Ը���")
    Player.giveMailByTable(userId,1, "ͨ����뺽���-"..cfg.title,"����ȡ����ͨ����뺽���,�ƺ�["..cfg.title.."]���Զ�����!",cfg.reward, 1, true)
    Player.sendmsgEx(actor, string.format("[ϵͳ��ʾ]�� ��ȡ�ɹ��������ѷ��͵��ʼ�!"))
    TongGuanWenDie.SyncResponse(actor)
end
--ͬ����Ϣ
function TongGuanWenDie.SyncResponse(actor, logindatas)
    local data = Player.getJsonTableByVar(actor,VarCfg["T_ͨ�������ȡ��¼"])
    local _login_data = {ssrNetMsgCfg.TongGuanWenDie_SyncResponse, 0, 0, 0, data}
    if logindatas then
        table.insert(logindatas, _login_data)
    else
        Message.sendmsg(actor, ssrNetMsgCfg.TongGuanWenDie_SyncResponse, 0, 0, 0, data)
    end
end
--��¼����
local function _onLoginEnd(actor, logindatas)
    TongGuanWenDie.SyncResponse(actor, logindatas)
end
--�¼��ɷ�
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, TongGuanWenDie)
--ע��������Ϣ
function TongGuanWenDie.Sync1(actor, parentIndex, arg1, arg2, data)
    if not parentIndex or type(parentIndex) ~= "number" then
        Player.sendmsgEx(actor, "��������#249")
        return
    end
    local func = MainConditions[parentIndex]
    if not func then
        Player.sendmsgEx(actor, "��������#249")
        return
    end
    local data = func(actor)
    if not data then
        Player.sendmsgEx(actor, "��������#249")
        return
    end
    Message.sendmsg(actor, ssrNetMsgCfg.TongGuanWenDie_Sync1, parentIndex, 0, 0, data)
end
Message.RegisterNetMsg(ssrNetMsgCfg.TongGuanWenDie, TongGuanWenDie)
return TongGuanWenDie