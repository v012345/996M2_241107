local HongHuangZhiMen = {}
HongHuangZhiMen.ID = "���֮��"
local npcID = 501
--local config = include("QuestDiary/cfgcsv/cfg_HongHuangZhiMen.lua") --����
local cost = { { "�����ʯ", 88 } }
--��������
function go_shen_mo_zhi_ti(actor)
    opennpcshowex(actor, 217, 2, 2)
end

function go_hong_huang_zhi_li(actor)
    opennpcshowex(actor, 511, 2, 2)
end

function HongHuangZhiMen.Request1(actor)
    if getflagstatus(actor, VarCfg["F_����_���֮�ſ���"]) == 1 then
        Player.sendmsgEx(actor, "�Ѿ�������#249")
        return
    end
    if not checktitle(actor, "��ħ������") then
        messagebox(actor, "����ʧ��,��û��[��ħ������]�ƺ�,�Ƿ�ǰ����ȡ?", "@go_shen_mo_zhi_ti", "@quxiao")
        return
    end
    if not checktitle(actor, "���֮��") then
        messagebox(actor, "����ʧ��,��û��[���֮��]�ƺ�,�Ƿ�ǰ����ȡ?", "@go_hong_huang_zhi_li", "@quxiao")
        return
    end
    local name, num = Player.checkItemNumByTable(actor, cost)
    if name then
        Player.sendmsgEx(actor, string.format("���|%s#249|����|%d#249", name, num))
        return
    end
    Player.takeItemByTable(actor, cost, "���֮��")
    Player.sendmsgEx(actor,"�ɹ�������ͼ[���о�����]")
    -- setflagstatus(actor, VarCfg["F_����_���֮�ſ���"],1)
    FSetTaskRedPoint(actor, VarCfg["F_����_���֮�ſ���"], 46)
end

function HongHuangZhiMen.Request2(actor)
    if getflagstatus(actor, VarCfg["F_����_���֮�ſ���"]) == 1 then
        map(actor, "���о�����")
    else
        Player.sendmsgEx(actor, "����ʧ��,�㻹û������ͼ#249")
    end
end

--ͬ����Ϣ
function HongHuangZhiMen.SyncResponse(actor, logindatas)
    local data = {}
    local flag = getflagstatus(actor, VarCfg["F_����_���֮�ſ���"])
    local _login_data = { ssrNetMsgCfg.HongHuangZhiMen_SyncResponse, flag, 0, 0, data }
    if logindatas then
        table.insert(logindatas, _login_data)
    else
        Message.sendmsg(actor, ssrNetMsgCfg.HongHuangZhiMen_SyncResponse, flag, 0, 0, data)
    end
end

--��¼����
local function _onLoginEnd(actor, logindatas)
    HongHuangZhiMen.SyncResponse(actor, logindatas)
end
--�¼��ɷ�
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, HongHuangZhiMen)
--ע��������Ϣ
Message.RegisterNetMsg(ssrNetMsgCfg.HongHuangZhiMen, HongHuangZhiMen)
return HongHuangZhiMen
