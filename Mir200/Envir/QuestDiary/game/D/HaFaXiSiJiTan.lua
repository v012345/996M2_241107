local HaFaXiSiJiTan = {}
local cost = {{"��ʿ֮��",4}}
local mirrorMapId2 = "������˹֮Ĺ(����)"
local monName1 = "������˹֮��"
function HaFaXiSiJiTan.Request(actor)
    local myName = getbaseinfo(actor,ConstCfg.gbase.name)
    if not FCheckMap(actor, myName..mirrorMapId2) then
        -- Player.sendmsg(actor,"fuck you.")
        return
    end
    local name,num = Player.checkItemNumByTable(actor,cost)
    if name then
        Player.sendmsgEx(actor,string.format("[��ʾ]:#251|���|%s#249|����|%d#249|,�޷��ٻ�!",name,num))
        return
    end
    setofftimer(actor, 173)
    Player.takeItemByTable(actor,cost,"������˹֮Ĺ")
    local mapId = getbaseinfo(actor, ConstCfg.gbase.mapid)
    genmon(mapId, 49, 49, monName1, 0, 1, 249)
    sendcentermsg(actor, 250, 0, "[ϵͳ��ʾ]���Ѿ����ѹ��ϵĹ�����˹֮�꣡��ɱ����ٻ���������������˹���־�֮����", 0, 5)
    sendcentermsg(actor, 250, 0, "[ϵͳ��ʾ]���Ѿ����ѹ��ϵĹ�����˹֮�꣡��ɱ����ٻ���������������˹���־�֮����", 0, 5)
    sendcentermsg(actor, 250, 0, "[ϵͳ��ʾ]���Ѿ����ѹ��ϵĹ�����˹֮�꣡��ɱ����ٻ���������������˹���־�֮����", 0, 5)
end
Message.RegisterNetMsg(ssrNetMsgCfg.HaFaXiSiJiTan, HaFaXiSiJiTan)
return HaFaXiSiJiTan
