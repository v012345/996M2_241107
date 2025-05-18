local SheChaoJinDi = {}
SheChaoJinDi.ID = "�߳�����"
local npcID = 453
--local config = include("QuestDiary/cfgcsv/cfg_SheChaoJinDi.lua") --����
local cost = { { "����ˮ��", 188 }, { "Ԫ��", 100000 } }
local give = { {} }
function she_chao_jin_di_end(actor)

end

function she_chao_jin_di(actor)
    senddelaymsg(actor, "1����֮��ɱ����ֻ[��Ԩ֮������ͷ��]���ɻ�ý���,ʣ��ʱ��:%s", 1799, 250, 1, "@she_chao_jin_di_end", 0)
end

function jiu_tou_she_shua_guai(actor, x, y)
    local myName = getbaseinfo(actor, ConstCfg.gbase.name)
    local newMapId = myName .. "�߳�����"
    genmon(newMapId, tonumber(x), tonumber(y), "��Ԩ֮������ͷ��", 0, 1, 249)
end

--��������
function SheChaoJinDi.Request(actor)
    if not FCheckNPCRange(actor, npcID, 15) then
        Player.sendmsgEx(actor, "����PNC̫Զ!#249")
        return
    end

    local name, num = Player.checkItemNumByTable(actor, cost)
    if name then
        Player.sendmsgEx(actor, string.format("���|%s#249|����|%d#249", name, num))
        return
    end
    Player.takeItemByTable(actor, cost, "�߳�����")
    local time = 1800
    local myName = getbaseinfo(actor, ConstCfg.gbase.name)
    local oldMapId = getbaseinfo(actor, ConstCfg.gbase.mapid)
    local x = getbaseinfo(actor, ConstCfg.gbase.x)
    local y = getbaseinfo(actor, ConstCfg.gbase.y)
    local newMapId = myName .. "�߳�����"
    delmirrormap(newMapId)
    addmirrormap("zhixu", newMapId, "�߳�����", time, oldMapId, 010380, x, y)
    mapmove(actor, newMapId, 44, 51, 0)
    delaygoto(actor, 1000, "she_chao_jin_di")
    genmon(newMapId, 34, 40, "��Ԩ֮������ͷ��", 0, 1, 249)
    genmon(newMapId, 34, 15, "��Ԩ֮������ͷ��", 0, 1, 249)
    genmon(newMapId, 41, 28, "��Ԩ֮������ͷ��", 0, 1, 249)
    genmon(newMapId, 50, 32, "��Ԩ֮������ͷ��", 0, 1, 249)
    genmon(newMapId, 44, 49, "��Ԩ֮������ͷ��", 0, 1, 249)
    genmon(newMapId, 24, 59, "��Ԩ֮������ͷ��", 0, 1, 249)
    genmon(newMapId, 18, 32, "��Ԩ֮������ͷ��", 0, 1, 249)
    genmon(newMapId, 27, 29, "��Ԩ֮������ͷ��", 0, 1, 249)
    genmon(newMapId, 44, 60, "��Ԩ֮������ͷ��", 0, 1, 249)
end

--ͬ����Ϣ
-- function SheChaoJinDi.SyncResponse(actor, logindatas)
--     local data = {}
--     local _login_data = {ssrNetMsgCfg.SheChaoJinDi_SyncResponse, 0, 0, 0, data}
--     if logindatas then
--         table.insert(logindatas, _login_data)
--     else
--         Message.sendmsg(actor, ssrNetMsgCfg.SheChaoJinDi_SyncResponse, 0, 0, 0, data)
--     end
-- end
-- --��¼����
-- local function _onLoginEnd(actor, logindatas)
--     SheChaoJinDi.SyncResponse(actor, logindatas)
-- end
-- --�¼��ɷ�
-- GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, SheChaoJinDi)
--ɱ�ִ���
local function _onKillMon(actor, monobj, monName)
    local myName = getbaseinfo(actor, ConstCfg.gbase.name)
    local newMapId = myName .. "�߳�����"
    if FCheckMap(actor, newMapId) then
        local monName = monName
        if monName == "��Ԩ֮������ͷ��" then
            local x = getbaseinfo(monobj, ConstCfg.gbase.x)
            local y = getbaseinfo(monobj, ConstCfg.gbase.y)
            delaygoto(actor, 60000, string.format("jiu_tou_she_shua_guai,%s,%s", x, y))
            local monIdx = getdbmonfieldvalue("��Ԩ֮������ͷ��", "idx")
            local num = getmoncount(newMapId, monIdx, true)
            if num > 0 then
                Player.sendmsgEx(actor, "���ɱ��|��Ԩ֮������ͷ��#249|һ���Ӻ󸴻�,1������ͬʱ��ɱ�ſ��Ի�ý���!")
            else
                Player.sendmsgEx(actor, "��ͷ����ȫ������,��ý���!")
                additemtodroplist(actor, monobj, "�̲�������")
                cleardelaygoto(actor)
                confertitle(actor, "�������")
                -- setflagstatus(actor, VarCfg["F_�߳�����_���"], 1)
                FSetTaskRedPoint(actor, VarCfg["F_�߳�����_���"], 38)
            end
        end
    end
end
GameEvent.add(EventCfg.onKillMon, _onKillMon, SheChaoJinDi)

--ע��������Ϣ
Message.RegisterNetMsg(ssrNetMsgCfg.SheChaoJinDi, SheChaoJinDi)
return SheChaoJinDi
