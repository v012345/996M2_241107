local ShouYeRen = {}
ShouYeRen.cost = {{"�ϴ峤�Ļ���",1},{"�칤֮��",1888},{"����ʯ",1888}}
ShouYeRen.give = {{"��ҹ��֮��",1}}
function ShouYeRen.Request(actor)
    local name,num = Player.checkItemNumByTable(actor,ShouYeRen.cost)
    if name then
        Player.sendmsgEx(actor, string.format("[��ʾ]:#251|��ı���û��|%s*%d#249", name, num))
        return
    end
    Player.takeItemByTable(actor,ShouYeRen.cost,"��ҹ������")
    Player.giveItemByTable(actor,ShouYeRen.give)
    FSetTaskRedPoint(actor, VarCfg["F_��ҹ�����"], 14)
    Player.sendmsgEx(actor, string.format("[��ʾ]:#251|��ϲ����#250|%s#249", ShouYeRen.give[1][1]))
    Message.sendmsg(actor,ssrNetMsgCfg.ShouYeRen_SyncResponse)
end

-----ע��������Ϣ
Message.RegisterNetMsg(ssrNetMsgCfg.ShouYeRen, ShouYeRen)

return ShouYeRen
