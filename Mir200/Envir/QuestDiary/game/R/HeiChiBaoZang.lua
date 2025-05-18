local HeiChiBaoZang = {}
HeiChiBaoZang.ID = "�ڳݱ���"
local npcID = 230
local config = { "�ġ�̤����", "����", "����ָ��", "����սѥ", "��ն���ˡ�", "���硤֮��", "�������硵", "��֮��������", "��֮��������", "ʥ֮������", "��ħ����", "����Ӱ֮��",
    "����", "������׹", "��������", "����֮��", "����ͼ�کg", "�������", "����֮��", "��ڤ����", "�Ͽ�֮��", "ǧ��֮��", "ħ��ָ��", "ҹɫɱ������", "����֮��", "�¹��ֻ�",
    "�¹�ӡ��", "���ս����ս�", "����ӡ�Ĺײ�" }
--��������
function open_hei_chi_bao_zang(actor)
    setplaydef(actor, VarCfg["J_�ڳݱ���"], 1)
    local openCount = getplaydef(actor, VarCfg["U_����_�ڳݱ���_��������"])
    if openCount >= 3 then
        Player.sendmsgEx(actor, "�ڳݱ������ֻ�ܿ���|3#249|��")
        return
    end
    if not Bag.checkBagEmptyNum(actor, 5) then
        Player.sendmsgEx(actor, "��ı������Ӳ���,��������5���ո�!#249")
        stop(actor)
    end
    setplaydef(actor, VarCfg["U_����_�ڳݱ���_��������"], openCount + 1)
    local taskPanelID = getplaydef(actor, VarCfg["U_��������������"])
    if taskPanelID == 9 then
        FCheckTaskRedPoint(actor)
    end
    local randomNum = math.random(#config)
    local itemName = config[randomNum]
    giveitem(actor, itemName, 1, ConstCfg.binding)
    messagebox(actor, string.format("�㿪����[�ڳݱ���],���[%s]", itemName))
    local myName = getbaseinfo(actor, ConstCfg.gbase.name)
    Player.sendmsgnewEx(actor, 0, 0, string.format("���|%s#253|������|[�ڳݱ���]#249|���ר��װ��|[%s]#249", myName, itemName))
    HeiChiBaoZang.SyncResponse(actor)
end

function open_hei_chi_bao_zang_end(actor)
    Player.sendmsgEx(actor, "�����ڳݱ��䱻�����!")
end

function HeiChiBaoZang.Request(actor)
    if not FCheckNPCRange(actor, npcID, 15) then
        Player.sendmsgEx(actor, "����PNC̫Զ!#249")
        return
    end
    local openCount = getplaydef(actor, VarCfg["U_����_�ڳݱ���_��������"])
    if openCount >= 3 then
        Player.sendmsgEx(actor, "�ڳݱ������ֻ�ܿ���|3#249|��")
        return
    end
    local flag = getplaydef(actor, VarCfg["J_�ڳݱ���"])
    if flag > 0 then
        Player.sendmsgEx(actor, "�������Ѿ���������,������0���Ժ�����!")
        return
    end
    showprogressbardlg(actor, 5, "@open_hei_chi_bao_zang", "���ڿ����ڳݱ���%d..", 1, "@open_hei_chi_bao_zang_end")
end

--ͬ����Ϣ
function HeiChiBaoZang.SyncResponse(actor)
    local data = {}
    local flag = getplaydef(actor, VarCfg["J_�ڳݱ���"])
    local openCount = getplaydef(actor, VarCfg["U_����_�ڳݱ���_��������"])
    Message.sendmsg(actor, ssrNetMsgCfg.HeiChiBaoZang_SyncResponse, flag, openCount, 0, data)
end
-- --��¼����
-- local function _onLoginEnd(actor, logindatas)
--     HeiChiBaoZang.SyncResponse(actor, logindatas)
-- end
-- --�¼��ɷ�
-- GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, HeiChiBaoZang)
--ע��������Ϣ
Message.RegisterNetMsg(ssrNetMsgCfg.HeiChiBaoZang, HeiChiBaoZang)
return HeiChiBaoZang
