local HeiDuTongDao = {}
local ItemCfg = {["��������α"]= true,["������־�"]= true,["������б�"]= true,["�������թ"]= true}
function HeiDuTongDao.Request(actor)
    local itemNum = 0
    for i = 77, 99 do
        local itemnane = getiteminfo(actor, linkbodyitem(actor, i), 7)
        if ItemCfg[itemnane] then
            itemNum = itemNum + 1
        end
    end
    if itemNum < 2 then
        Player.sendmsgEx(actor, "��ʾ#251|:#255|�Բ���,�������|����װ��#249|,����|2��#249|,����ʧ��...")
        return
    end

    local DianFengLevel = getplaydef(actor,VarCfg["U_�۷�ȼ�3"])
    if DianFengLevel < 5 then
        Player.sendmsgEx(actor, "��ʾ#251|:#255|�Բ���,��δ�ﵽ|�۷�����5#249|,����ʧ��...")
        return
    end


    map(actor,"�ڶ�ͨ��")

end

--ע��������Ϣ
Message.RegisterNetMsg(ssrNetMsgCfg.HeiDuTongDao, HeiDuTongDao)
return HeiDuTongDao
