local WangHunTa = {}
local config = include("QuestDiary/cfgcsv/cfg_FengDuChengMon.lua")     --����
-- -- local config = include("QuestDiary/cfgcsv/cfg_WangHunTa.lua")     --����
WangHunTa.ID = "������"
function WangHunTa.Request(actor)
   if getflagstatus(actor,VarCfg.F_is_open_kuangbao) == 0 then
    Player.sendmsgEx(actor, "��ʾ#251|:#255|�㻹δ����|��֮��#249|�޷�����...")
    return
   end

   if not takeitem(actor, "������ʯ", 1, 0) then
    Player.sendmsgEx(actor, "��ʾ#251|:#255|�Բ���,���|������ʯ#249|����|1ö#249|�޷�����...")
    return
   end
   mapmove(actor, "������", 100, 100, 100)
end

--ע��������Ϣ
Message.RegisterNetMsg(ssrNetMsgCfg.WangHunTa, WangHunTa)

function WangHunTa.openUI(actor)
    local monnum = checkrangemoncount("������", "*", 100, 100, 100)
    local data = {monnum}
    Message.sendmsg(actor, ssrNetMsgCfg.WangHunTa_openUI, 0, 0, 0, data)
end

--ͬ������
function WangHunTa.SyncResponse(actor, num)
    local data
    Message.sendmsg(actor, ssrNetMsgCfg.WangHunTa_SyncResponse, 0, 0, 0, data)
end

--�����ͼ��ɱ���ﴥ��
function _onKillMon(actor, monobj, monName)
    local monname = monName
    if config[monname] then
        local monnum = checkrangemoncount("������", "*", 100, 100, 100)
        if monnum < 100 then
            if randomex(5, 100) then
                genmon("������", 100, 100, monname, 100, 1, 255)
                sendmsgnew(actor, 250,0, "<ϵͳ��ʾ/FCOLOR=251>��<".. monname .."/FCOLOR=249>�����������������������...", 1, 1)
            end
        end
    end
end
GameEvent.add(EventCfg.onKillMon, _onKillMon, WangHunTa)

--�л���ͼ����
local function _goSwitchMap(actor, cur_mapid, former_mapid)
    if cur_mapid == "������" then
        setplaydef(actor, VarCfg["M_����������"], 1)
        Player.setAttList(actor, "���ʸ���")
    elseif former_mapid == "������" then
        setplaydef(actor, VarCfg["M_����������"], 0)
        Player.setAttList(actor, "���ʸ���")
    end
end
GameEvent.add(EventCfg.goSwitchMap, _goSwitchMap, WangHunTa)

local function _onCalcBaoLv(actor, attrs)
    if getplaydef(actor, VarCfg["M_����������"]) == 1 then
        local shuxing = {
            [204] = 100
        }
        calcAtts(attrs, shuxing, "���ʸ���:�������������ͼ")
    end
end
GameEvent.add(EventCfg.onCalcBaoLv, _onCalcBaoLv, WangHunTa)


return WangHunTa
