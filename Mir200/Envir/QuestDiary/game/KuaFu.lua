local KuaFutoBenFuBuffList = include("QuestDiary/game/KuaFutoBenFuBuffList.lua") --���
local BenFutoKuaFuRunScript = include("QuestDiary/game/BenFutoKuaFuRunScript.lua") --���
local KuaFutoBenFuQiYuTitle = include("QuestDiary/game/KuaFutoBenFuQiYuTitle.lua") --���

--����������
function kflogin(actor)
    --ͬ������
    local logindatas = {}
    GameEvent.push(EventCfg.onKFLogin, actor, logindatas)
    Message.sendmsg(actor, ssrNetMsgCfg.sync, nil, nil, nil, logindatas)

    --������������ٶ�
    local currSpeed = (getplaydef(actor, VarCfg["U_�����ٶ�"]) - 100) / 2
    if currSpeed > 0 then
        callscriptex(actor, "ChangeSpeedEX", 2, currSpeed)
    else
        callscriptex(actor, "ChangeSpeedEX", 2, 0)
    end
    --�������ʰȡС����
    pickupitems(actor, 0, 10, 500)
    --���ñ���
    local beigong = getplaydef(actor, VarCfg["U_�����¼����"])
    powerrate(actor, beigong, 655350)
    setflagstatus(actor,VarCfg["F_�Ƿ��������"],1)

end
--���������Ҫ�����buff
local function kuafuendDelBuff(actor)
    local buffList = {30099,10001,30087,31056}
    for _, value in ipairs(buffList) do
        delbuff(actor,value)
    end
end
--���ر�������
function kuafuend(actor)
    GameEvent.push(EventCfg.onKuaFuEnd, actor)
    kuafuendDelBuff(actor)
    Player.setAttList(actor,"���Ը���")
end

--����֪ͨ���
function bfsyscall1(actor, arg1, arg2)

end

function bfsyscall2(actor, arg1, arg2)

end

function bfsyscall3(actor, arg1, arg2)

end

function bfsyscall4(actor, arg1, arg2)

end

function bfsyscall5(actor, arg1, arg2)

end

function bfsyscall6(actor, arg1, arg2)

end

function bfsyscall7(actor, arg1, arg2)

end

function bfsyscall8(actor, arg1, arg2)

end

function bfsyscall9(actor, arg1, arg2)

end

function bfsyscall10(actor, arg1, arg2)

end

function bfsyscall11(actor, arg1, arg2)

end

function bfsyscall12(actor, arg1, arg2)

end

function bfsyscall13(actor, arg1, arg2)

end

function bfsyscall14(actor, arg1, arg2)

end

function bfsyscall15(actor, arg1, arg2)

end

function bfsyscall16(actor, arg1, arg2)

end

function bfsyscall17(actor, arg1, arg2)

end

function bfsyscall18(actor, arg1, arg2)

end

function bfsyscall19(actor, arg1, arg2)

end

function bfsyscall20(actor, arg1, arg2)

end

function bfsyscall21(actor, arg1, arg2)

end

function bfsyscall22(actor, arg1, arg2)

end

function bfsyscall23(actor, arg1, arg2)

end

function bfsyscall24(actor, arg1, arg2)

end

function bfsyscall25(actor, arg1, arg2)

end

function bfsyscall26(actor, arg1, arg2)

end

function bfsyscall27(actor, arg1, arg2)

end

function bfsyscall28(actor, arg1, arg2)

end

function bfsyscall29(actor, arg1, arg2)

end

--���֪ͨ��������ս���
function bfsyscall30(actor, arg1, arg2)
    local rankStr = arg1
end

--���õ�һ��Ѫ�ı���
function bfsyscall31(actor, arg1, arg2)
    setsysvar(VarCfg["A_��һ��Ѫ�������"], arg1)
end

--�������������
local cfg_JinZhiChuanSong = include("QuestDiary/cfgcsv/cfg_JinZhiChuanSong.lua")     --��ֹ���͵ĵ�ͼ
function bfsyscall32(actor, arg1, arg2)
    local mapid = getbaseinfo(actor,ConstCfg.gbase.mapid)
    if mapid == "ն������" then
        Player.sendmsgEx(actor,string.format("����ǰ��(%s,%s)",arg1,arg2))
        return
    end
    local isBanChuanSong = cfg_JinZhiChuanSong[mapid]
    if isBanChuanSong then
        Player.sendmsgEx(actor,"��ǰ��ͼ��ֹ����#249")
        return
    end
    mapmove(actor, mapid, arg1, arg2)
end

--������ִ�нű�
function bfsyscall33(actor, arg1, arg2)
    local index = tonumber(arg1) or 0
    local func = BenFutoKuaFuRunScript[index]
    if func then
        func(actor, arg2)
    end
end

--����BUFF�����ִ��
function bfsyscall34(actor, arg1, arg2)
    local buffid = tonumber(arg1) or 0
    local time = tonumber(arg2) or 0
    if not buffid or buffid == 0 then
        return
    end
    --���ʱ�䲻����
    if not time or time == 0 then
        addbuff(actor, buffid)
    else
        addbuff(actor, buffid, time)
    end
end

--���������ִ���¼��ɷ�
function bfsyscall35(actor, arg1, arg2)
    GameEvent.push(arg1, actor, arg2)
end

--���������ִ���¼��ɷ� ϵͳִ��
function bfsyscall36(arg1, arg2)
    GameEvent.push(arg1, arg2)
end


--���֪ͨ����
function kfsyscall1(actor, arg1, arg2)

end

function kfsyscall2(actor, arg1, arg2)

end

function kfsyscall3(actor, arg1, arg2)

end

function kfsyscall4(actor, arg1, arg2)

end

function kfsyscall5(actor, arg1, arg2)

end

function kfsyscall6(actor, arg1, arg2)

end

function kfsyscall7(actor, arg1, arg2)

end

function kfsyscall8(actor, arg1, arg2)

end

function kfsyscall9(actor, arg1, arg2)

end

function kfsyscall10(actor, arg1, arg2)

end

function kfsyscall11(actor, arg1, arg2)

end

function kfsyscall12(actor, arg1, arg2)

end

function kfsyscall13(actor, arg1, arg2)

end

function kfsyscall14(actor, arg1, arg2)

end

function kfsyscall15(actor, arg1, arg2)

end

function kfsyscall16(actor, arg1, arg2)

end

function kfsyscall17(actor, arg1, arg2)

end

function kfsyscall18(actor, arg1, arg2)

end

function kfsyscall19(actor, arg1, arg2)

end

function kfsyscall20(actor, arg1, arg2)

end

function kfsyscall21(actor, arg1, arg2)

end

function kfsyscall22(actor, arg1, arg2)

end

function kfsyscall23(actor, arg1, arg2)

end

function kfsyscall24(actor, arg1, arg2)

end

function kfsyscall25(actor, arg1, arg2)

end

function kfsyscall26(actor, arg1, arg2)

end

function kfsyscall27(actor, arg1, arg2)

end

function kfsyscall28(actor, arg1, arg2)

end

function kfsyscall29(actor, arg1, arg2)

end

function kfsyscall30(actor, arg1, arg2)

end
--װ�����ۿ������
function kfsyscall49(actor, arg1, arg2)
    local equipName = arg1
    local touBaoCount = arg2
    local mailTitle = "װ��Ͷ����ֹ����֪ͨ"
    local mailContent = "��װ����" .. equipName .. "����ʹ����Ͷ�����ܣ��ѷ�ֹ����1�Σ�ʣ��" .. touBaoCount .."�Ρ�"
    local uid = Player.GetUUID(actor)
    sendmail(uid, 1, mailTitle, mailContent)
end

--���buff�ر���ִ��
--[[
    arg1 = buffID
    arg2 = time
]]
function kfsyscall50(actor, arg1, arg2)
    local buffid = tonumber(arg1) or 0
    local time = tonumber(arg2) or 0
    if not buffid or buffid == 0 then
        return
    end
    --���ʱ�䲻����
    if not time or time == 0 then
        addbuff(actor, buffid)
    else
        addbuff(actor, buffid, time)
    end
end

--������ִ�нű�
function kfsyscall51(actor, arg1, arg2)
    local index = tonumber(arg1) or 0
    local func = KuaFutoBenFuBuffList[index]
    if func then
        func(actor, arg2)
    end
end

--���������ִ��ɾ���ƺ� ��
function kfsyscall52(actor, arg1, arg2)
    local titleName = arg1
    if titleName == "" then
        return
    end
    --ɾ������
    local skillId = getskillindex("ʮ��һɱ")
    delskill(actor, skillId)
    deprivetitle(actor, titleName)
end

--���������ִ�������ƺ�
function kfsyscall53(actor, arg1, arg2)
    local index = arg1
    local func = KuaFutoBenFuQiYuTitle[index]
    if func then
        func(actor,arg2)
    end
end
--�����ʼ�--ɳ�Ϳ˽���
function kfsyscall54(actor, arg1, arg2)
    local baoXiang = ""
    if arg1 == "ɳ�Ϳ�ʤ��������" then
        baoXiang = "&���¹�������#1#371"
    else
        baoXiang = "&����֮�걦��#1#371"
    end
    local userid = getbaseinfo(actor,ConstCfg.gbase.id)
    sendmail(userid, 1, arg1, "����ȡ����ɳ�Ϳ˽���", arg2..baoXiang)
    if arg1 == "ɳ�Ϳ�ʤ��������" then
        GameEvent.push(EventCfg.GetCastleRewards, actor)
    end
end

--���������ִ���¼��ɷ� 
function kfsyscall55(actor, arg1, arg2)
    GameEvent.push(arg1, actor, arg2)
end

--���������ִ���¼��ɷ� ϵͳ����
function kfsyscall56(obj, arg1, arg2)
    GameEvent.push(arg1, arg2)
end
