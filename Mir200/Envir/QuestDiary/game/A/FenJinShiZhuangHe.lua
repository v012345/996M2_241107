local FenJinShiZhuangHe = {}
FenJinShiZhuangHe.ID = "�ܽ�ʱװ��"
local cost = {{"�ܽ�ʱװ��", 1}}
local ItemData= {["�����͠D[ʱװ]"] = true,["��Ӱ֮��[ʱװ]"] = true,["�Ĺ�[ʱװ]"] = true,["����ǹ��[ʱװ]"] = true,["����[ʱװ]"] = true,["�����ɲ[ʱװ]"] = true,
                 ["����[ʱװ]"] = true,["����[ʱװ]"] = true,["�л�����[ʱװ]"] = true,["Ѫɱ֮��[ʱװ]"] = true,["���ս��[ʱװ]"] = true,["����ʥ��[ʱװ]"] = true,
                 ["����֮��[ʱװ]"] = true,["ҹ��[ʱװ]"] = true,["����[ʱװ]"] = true,["����[ʱװ]"] = true}
--��������
function FenJinShiZhuangHe.Request(actor,var1,var2,var3,data)
    local itemname = data[1]
    if not ItemData[itemname] then
        Player.sendmsgEx(actor, "��ʾ#251|:#255|����Der?,�ٵ㱨��#249|...")
        return
    end
    local name, num = Player.checkItemNumByTable(actor, cost)
    if name then
        Player.sendmsgEx(actor, string.format("���|%s#249|����|%d#249|��,��ȡʧ��...", name, num))
        return
    end
    Player.takeItemByTable(actor, cost, "�ܽ�ʱװ����ȡ�۳�")
    giveitem(actor,itemname,1,ConstCfg.binding,"�ܽ�ʱװ�и���")
end

--ע��������Ϣ
Message.RegisterNetMsg(ssrNetMsgCfg.FenJinShiZhuangHe, FenJinShiZhuangHe)
return FenJinShiZhuangHe