KuangBao = {}
KuangBao.ID = 30900
local configKB = cfg_kuangbao[1]
--���뼼��
function KuangBao.addsKill(actor)
    local skillId = getskillindex(configKB.skill)
    addskill(actor, skillId, 1)
end

--ɾ������
function KuangBao.delsKill(actor)
    local skillId = getskillindex(configKB.skill)
    delskill(actor, skillId)
end

function KuangBao.Request(actor)
    local isKangBao = getflagstatus(actor, VarCfg.F_is_open_kuangbao) --�Ƿ�����֮��
    if isKangBao == 1 then
        Player.sendmsgEx(actor, "���ѿ�����֮����#249")
        local isShiBu = getskillinfo(actor,configKB.skill,1)
        if not isShiBu then
            KuangBao.addsKill(actor)
        end
        return
    end

    if not configKB.cost then
        Player.sendmsgEx(actor, "��֮�����ô���#249")
        return
    end

    if querymoney(actor, 7) < 100 then
        Player.sendmsgEx(actor, "��ʾ#251|:#255|����������|100ö#249|����ʧ��...")
        return
    end
    changemoney(actor, 7, "-", 100, "�񱩿۳�", true)
    --���ñ�ʶ
    setflagstatus(actor, VarCfg.F_is_open_kuangbao, 1)
    --���ƺ�
    confertitle(actor, configKB.title, 1)
    --������
    KuangBao.addsKill(actor)
    Player.sendmsgEx(actor, "������֮���ɹ���")
    local userName = Player.GetNameEx(actor)
    sendcentermsg(actor, 249, 0,
        string.format("��ϵͳ�������[%s]�����˿�֮����ɱ�������Ի��%s%s������", userName, configKB.diaoluo[1][1], configKB.diaoluo[1][2]), "1",
        8)
    --������֮��
    if getflagstatus(actor, VarCfg["F_������֮��"]) == 1 then
        addattlist(actor, "��֮��", "=", "3#3#50|3#4#50|3#5#50|3#6#50|3#7#50|3#8#50", 1)
        Player.buffTipsMsg(actor, "[��֮��]:���������֮�����ԣ�")
    end

    Player.setAttList(actor, "���ʸ���")
    Player.setAttList(actor, "���Ը���")
    GameEvent.push(EventCfg.OpenKuangBao, actor)
end

Message.RegisterNetMsg(ssrNetMsgCfg.KuangBao, KuangBao) --ע��������Ϣ

------------------------------������ ��Ϸ�¼� ������---------------------------------------

--��֮�� ���ɾ��
function kuang_bao_check_shan_chu(actor)
    --�����ʶ������  ��ɾ��һ�ο�
    if getflagstatus(actor, VarCfg.F_is_open_kuangbao) == 0 then
        if checktitle(actor, "��֮��") then
            deprivetitle(actor, "��֮��")
        end
        KuangBao.delsKill(actor)
    end
end

local function KuangBaoLongin(actor, logindatas)
    if getflagstatus(actor, VarCfg.F_is_open_kuangbao) == 1 then
        seticon(actor, ConstCfg.iconWhere.kuangbao, 1, 15000)
    end
    if not checkkuafu(actor) then
        delaygoto(actor, 9000, "kuang_bao_check_shan_chu")
    end
end

local function _onKuangBaoZhiLiBenFu(actor)
    Player.giveItemByTable(actor, configKB.diaoluo, "��ɱӵ�п񱩵����")
end
GameEvent.add(EventCfg.onKuangBaoZhiLiBenFu, _onKuangBaoZhiLiBenFu, KuangBao)

--1������ 2��ɱ��
local function _playerkillplay(play, actor)
    --�ж��Ƿ�ɳʱ�䣬��ɳ������
    local isGongSha = castleinfo(5)
    if isGongSha then
        return
    end
    if actor == "0" or play == "0" then
        return
    end
    local mapguid = 0
    if not getbaseinfo(actor, -1) then return end --����ǹ��ﲻִ���κβ���
    if not getbaseinfo(play, -1) then return end  --����ǹ��ﲻִ���κβ���

    local map = Player.GetVarMap(actor)
    --�жϰ�ȫ��ͼ
    for _, value in ipairs(configKB.mapid) do
        if map == value then
            mapguid = 1
            break
        end
    end
    if mapguid == 1 then
        return
    end
    if getflagstatus(play, VarCfg.F_is_open_kuangbao) == 1 then
        --��������֮��   ��20%���� ������
        if checkitemw(play, "����֮��", 1) then
            if randomex(20) then
                messagebox(play, "��ϲ:����֮�������˱�ɱ������!")
                messagebox(actor, "����ɱ��Ҵ�����[����֮��]������BUFF,�����û�л�ý���!")
                return
            end
        end
        if checkkuafu(actor) then
            FKuaFuToBenFuEvent(actor,EventCfg.onKuangBaoZhiLiBenFu, "")
        else
            Player.giveItemByTable(actor, configKB.diaoluo, "��ɱӵ�п񱩵����")
        end
        setflagstatus(play, VarCfg.F_is_open_kuangbao, 0)
        --release_print("�۱���������1  "..getflagstatus(actor,VarCfg["F_�����۱���"]))
        --�۱���
        if getflagstatus(actor, VarCfg["F_�����۱���"]) == 1 then
            local num = getplaydef(actor, VarCfg["J_�۱�������"])
            --release_print("�۱���������"..num)
            if num < 50 then
                setplaydef(actor, VarCfg["J_�۱�������"], num + 1)
                --release_print("�۱���������"..num+1)
                addattlist(actor, "�۱���", "=", "3#216#" .. (num + 1), 1)
                Player.buffTipsMsg(actor, "[�۱���]:��ɱ����һ��1%���ձ���...")
            end
        end
        --����-��֮��
        delattlist(actor, "��֮��")
        --���񱩺��ڱ���ɾ���ƺ�
        if checkkuafu(play) then
            FKuaFuToBenFuDelTitle(play, "��֮��", "")
        else
            deprivetitle(play, "��֮��")
        end
        --ɾ����
        KuangBao.delsKill(play)
        seticon(play, ConstCfg.iconWhere.kuangbao, -1)
        local msgData = {
            { "", "��ɱ��ӵ��" },
            { "FF0000", "��֮��" },
            { "", "����ң����" },
            { "FF0000", configKB.diaoluo[1][2] .. configKB.diaoluo[1][1] },
        }
        Player.sendmsg(actor, msgData)
        sendcentermsg(play, 250, 249, "ս������" ..
            Player.GetNameEx(actor) .. "���ɵ���ӵ�С���֮������[" ..
            Player.GetNameEx(play) .. "]���" .. configKB.diaoluo[1][2] .. configKB.diaoluo[1][1] .. "��������", 1, 5)
        Player.setAttList(play, "���ʸ���")
        Player.setAttList(play, "���Ը���")
    end
end

--ʹ��ʮ��һɱ �Ե͵ȼ��İٷְ����
local function _onShiBuYiShan(actor, target)
    local MyLevel = getbaseinfo(actor, ConstCfg.gbase.level)
    local TgtLevel = getbaseinfo(target, ConstCfg.gbase.level)
    if MyLevel > TgtLevel then
        addbuff(target, 31078)
    end
end
GameEvent.add(EventCfg["ʹ��ʮ��һɱ"], _onShiBuYiShan, KuangBao)

--������������
GameEvent.add(EventCfg.onPlaydie, _playerkillplay, KuangBao)

--�����¼��ɴ���
GameEvent.add(EventCfg.onLoginEnd, KuangBaoLongin, KuangBao)
--�����¼����
GameEvent.add(EventCfg.onKFLogin, KuangBaoLongin, KuangBao)

-- ----------------------------������ �ⲿ���� ������---------------------------------------
--��ȡ��ǰ�Ƿ�����
function KuangBao.isOpenKB(actor)
    local kbbiaoji = getflagstatus(actor, VarCfg.F_is_open_kuangbao)
    return kbbiaoji == 1
end

return KuangBao
