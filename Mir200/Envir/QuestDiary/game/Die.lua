Die                  = {}
-- cfg_Fuhuo            = include("QuestDiary/cfgcsv/cfg_Fuhuo.lua") --��������
function die_fu_huo(actor)
    setflagstatus(actor,VarCfg["F_��������"],0)
    realive(actor)
    FBackZone(actor)
    addhpper(actor,"=",100)
    local time = getplaydef(actor, "S$����_time")
    local map_title = getplaydef(actor, "S$����_map_title")
    local map_id = getplaydef(actor, "S$����_map_id")
    local x = getplaydef(actor, "S$����_x")
    local y = getplaydef(actor, "S$����_y")
    local hitername = getplaydef(actor, "S$����_hitername")
    -- release_print(map_id)
    if map_id == "n3" or map_id == "new0150" then
        return
    end
    if hasbuff(actor, 31064) then
        return
    end
    --���������ʹ��������
    if checkkuafu(actor) then
        return
    end
    --������  ��������ʱ�Զ���¼(��ǰ��������) ������ѡ��ɻذ����ֳ�[CD120S]
    if getflagstatus(actor, VarCfg["F_������"]) == 1 then
        addbuff(actor, 31064)
        say(actor, [[
                <Img|loadDelay=0|move=0|bg=1|img=custom/shengsipu/jm_01.png|show=4|esc=1|reset=1>
                <Text|ax=0.5|x=405.0|y=170.0|rotate=0|color=255|size=16|text=]] .. time .. [[>
                <Text|ax=0.5|x=309.0|y=200.0|rotate=0|color=146|size=16|text=]] ..
            map_title .. [[[]] .. x .. [[,]] .. y .. [[]>
                <Text|ax=0.5|x=480.0|y=200.0|rotate=0|color=249|size=16|text=]] .. hitername .. [[>
                <COUNTDOWN|id=5|x=372.0|y=300.0|count=1|size=16|color=250|time=12|link=@guanbishengsipu>
                <Button|x=200.0|y=285.0|nimg=custom/shengsipu/an_1.png|link=@exit>
                <Button|x=419.0|y=285.0|nimg=custom/shengsipu/an_2.png|link=@shiyongshengsipu,]] ..
            map_id .. [[,]] .. x .. [[,]] .. y .. [[>
                ]])
    end
end

--���󸴻�
function Die.RequestRevive(actor, time, map_title, map_id, x, y, hitername)
    --�жϵ�ǰ�Ƿ�����״̬
    if checkkuafu(actor) then
        --�����ն����ȡ����
        if FCheckMap(actor,"ն������") then
            GameEvent.push(EventCfg.onKFZhanJiangDuoQiRlive, actor)
            return
        end
    end
    if not getbaseinfo(actor, ConstCfg.gbase.isdie) then return end
    setplaydef(actor, "S$����_time", time)
    setplaydef(actor, "S$����_map_title", map_title)
    setplaydef(actor, "S$����_map_id", map_id)
    setplaydef(actor, "S$����_x", x)
    setplaydef(actor, "S$����_y", y)
    setplaydef(actor, "S$����_hitername", hitername)
    setflagstatus(actor,VarCfg["F_��������"],1)
    showprogressbardlg(actor, 3, "@die_fu_huo", "���ڸ���%d...", 0)
end
--�ر�����������
function guanbishengsipu(actor)
    close(actor)
end
--��ֹʹ��������
local ssbBan = {
    ["��ҹ����"] = true,
    ["��С��"] = true
}
--ʹ��������
function shiyongshengsipu(actor, map_id, x, y)
    local myName = getbaseinfo(actor, ConstCfg.gbase.name)
    if string.find(map_id, myName) then
        Player.sendmsgEx(actor,"������ͼ��ֹʹ��!#249")
        return
    end
    if ssbBan[map_id] then
        local map_titile = getmapname(map_id)
        Player.sendmsgEx(actor,string.format("%s��ֹʹ��������#249",map_titile))
        return
    end
    mapmove(actor, map_id, x, y, 1)
end
Message.RegisterNetMsg(ssrNetMsgCfg.Die, Die)

return Die
