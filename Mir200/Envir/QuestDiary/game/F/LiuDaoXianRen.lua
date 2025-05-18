local LiuDaoXianRen = {}
local cost = {{"�������", 1},{"����Ѫ��", 1},{"�˵���ʯ", 1},{"�޻����", 1},{"����֮��", 1},{"����ҵ��ʯ", 1},{"Ԫ��", 888888}}

function liu_dao_lun_hui_chen_diaoluo(actor)
    setflagstatus(actor, VarCfg["F_�����ֻس�����"],1)
    return true
end

function LiuDaoXianRen.Request(actor)
    local name, num = Player.checkItemNumByTable(actor, cost)
    if name then
        Player.sendmsgEx(actor, string.format("��ʾ#251|:#255|���|%s#249|����|%d#249|ö,����ʧ��...", name, num))
        return
    end
    Player.takeItemByTable(actor, cost, "���븱������")
    local NowMapID = getbaseinfo(actor, ConstCfg.gbase.mapid)
    local NowX,NowY = getbaseinfo(actor, ConstCfg.gbase.x),getbaseinfo(actor, ConstCfg.gbase.y)
    local UserName = getconst(actor, "<$USERID>")
    local FormerMapId = "liudaomoyu"  --��ȡԭʼ��ͼID
    local NewMapId = FormerMapId..UserName --����ԭʼ��ͼid  �����µ�ͼID
    if checkmirrormap(NewMapId) then
        killmonsters(NewMapId, "*", 0, false)   --ɱ����ǰ��ͼ���й���
        delmirrormap(NewMapId)              --ɾ�������ͼ
        addmirrormap(FormerMapId, NewMapId, "��������[����]", 1800, NowMapID, nil, NowX, NowY)
    else
        addmirrormap(FormerMapId, NewMapId, "��������[����]", 1800, NowMapID, nil, NowX, NowY)
    end
    mapmove(actor, NewMapId, 60, 65, 5)
    --�����ͼˢ��
    genmon(NewMapId, 60, 65 ,"��Ͳľ���¡��������ˡ�", 0, 1, 249)
    setflagstatus(actor, VarCfg["F_�������˻���"],1)
    LiuDaoXianRen.SyncResponse(actor)
end

-- ͬ��һ����Ϣ
function LiuDaoXianRen.SyncResponse(actor)
    Message.sendmsg(actor, ssrNetMsgCfg.LiuDaoXianRen_SyncResponse, 0, 0, 0, nil)
end
Message.RegisterNetMsg(ssrNetMsgCfg.LiuDaoXianRen, LiuDaoXianRen)

return LiuDaoXianRen







