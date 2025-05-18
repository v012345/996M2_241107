local XianJiShiLian = {}
local cost = { { "���", 1888 } }
local subHp = { 2, 10 }
local addJinDu = { 1, 10 }
function XianJiShiLian.openUI(actor)
    local jinDu = getplaydef(actor, VarCfg["M_�׼�����"])
    Message.sendmsg(actor, ssrNetMsgCfg.XianJiShiLian_openUI, jinDu, 0, 0)
end

function xianjishixian_request(actor)
    local layerFlag = getplaydef(actor, VarCfg["M_�ز�����ʶ"])
    if layerFlag ~= 4 then
        Player.sendmsgEx(actor, "û�м�⵽���ڵ�ͼ��!")
        return
    end
    local jinDu = getplaydef(actor, VarCfg["M_�׼�����"])
    local _subHp = math.random(subHp[1], subHp[2])
    local _addJinDu = math.random(addJinDu[1], addJinDu[2])
    local currJinDu = jinDu + _addJinDu
    setplaydef(actor, VarCfg["M_�׼�����"], currJinDu)
    XianJiShiLian.SyncResponse(actor, currJinDu)
    addhpper(actor, "-", _subHp)
    Player.sendmsgEx(actor, string.format("���Ѫ������|%s%%#249|, �׼���������|%s%%#249|", _subHp, _addJinDu))
    if currJinDu >= 100 then
        Player.sendmsgEx(actor, "��ϲ���ɹ�����׼�����!")
        local mapId = getbaseinfo(actor, ConstCfg.gbase.mapid)
        delmirrormap(mapId)
        setplaydef(actor, VarCfg["U_�ز���������"], 4)
        Message.sendmsg(actor, ssrNetMsgCfg.DiZangWangDeShiLian_SyncResponse, 4, 1)
        delmirrormap(mapId)
    end
end

function XianJiShiLian.Request(actor)
    local currHpPer = Player.getHpPercentage(actor)
    if currHpPer <= 10 then
        messagebox(actor, "�㵱ǰ��Ѫ������10%,�����׼����ᱩ�ж���,ȷ������?", "@xianjishixian_request", "@exit")
        return
    else
        xianjishixian_request(actor)
    end
end

function XianJiShiLian.RequestHp(actor)
    local layerFlag = getplaydef(actor, VarCfg["M_�ز�����ʶ"])
    if layerFlag ~= 4 then
        Player.sendmsgEx(actor, "��������!")
        return
    end
    local name, num = Player.checkItemNumByTable(actor, cost)
    if name then
        Player.sendmsgEx(actor, string.format("���|%s#249|����|%s#249", name, num))
        return
    end
    Player.takeItemByTable(actor, cost, "�׼�����")
    addhpper(actor, "=", 100)
    Player.sendmsgEx(actor, "��ϲ����Ѫ��!")
end

--ͬ��һ����Ϣ
function XianJiShiLian.SyncResponse(actor, jinDu)
    Message.sendmsg(actor, ssrNetMsgCfg.XianJiShiLian_SyncResponse, jinDu, 0, 0)
end

Message.RegisterNetMsg(ssrNetMsgCfg.XianJiShiLian, XianJiShiLian)

return XianJiShiLian
