local ShiJieDiTu = {}
local MapData = {
    {map="n3", x=330, y=330},
    {map="��Ԫ��½", x=126, y=153},
    {map="�����۹�", x=241, y=200},
    {map="ۺ��", x=191, y=221},
    {map="�����½", x=68, y=25},
    {map="̫��ʥ��", x=93, y=69},
    {map="����֮��", x=69, y=118},
    {map="��������", x=87, y=112},
    {map="ĺɫ����", x=57, y=47},
    {map="����ʥ��", x=92, y=97},
}
function ShiJieDiTu.Request(actor,var)
    if var == 65535 then
        FMapMoveKF(actor, "kuafu2", 136, 166, 5)
    end
    local MapNum = getplaydef(actor,VarCfg["U_��¼��½"])
    if MapNum < var then return end
    if hasbuff(actor, 10001) then
        local buffTime = getbuffinfo(actor, 10001, 2)
        Player.sendmsgEx(actor, string.format("����ս��[|%s#249|]������ʹ��", buffTime + 1))
        return
    end
    local taskID = getplaydef(actor, VarCfg["U_�����������"])
    if taskID < 7 then
        mapmove(actor, "��Դ��", 113, 249, 2)
        return
    end
    local cfg = MapData[var]
    mapmove(actor, cfg.map, cfg.x, cfg.y,3)
end

--ע��������Ϣ
Message.RegisterNetMsg(ssrNetMsgCfg.ShiJieDiTu, ShiJieDiTu)

return ShiJieDiTu
