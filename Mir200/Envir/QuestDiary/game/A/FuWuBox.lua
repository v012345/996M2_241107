local FuWuBox = {}
local config = include("QuestDiary/cfgcsv/cfg_JingZhiXiaoHui.lua") --��ֹ����


--��Ʒ����
function FuWuBox.XiaoHuiWuPin(actor,arg1,arg2,arg3)
    if type(arg1) ~= "number" then
        Player.sendmsgEx(actor,"��������!")
        return
    end
    local itemName = Item.getNameMakeid(actor,arg1)
    if config[itemName] then
        Player.sendmsgEx(actor,"��".. itemName .."����ֹ����!#249")
        return
    end
    local isSuccess = delitembymakeindex(actor,tostring(arg1),0,"��Ʒ����")
    if not isSuccess then
        Player.sendmsgEx(actor,"��Ʒ����ʧ��,����!#249")
    else
        if itemName then
            Player.sendmsgEx(actor,"��".. itemName .."����Ʒ���ٳɹ�!")
        end
    end
end

--��Ϣ����
function FuWuBox.PingBiXiaoXi(actor)
    local state = getflagstatus(actor,VarCfg["F_����ȫ����Ϣ"])
    if state == 0 then
        filterglobalmsg(actor, 1)
        setflagstatus(actor,VarCfg["F_����ȫ����Ϣ"], 1)
        Player.sendmsgEx(actor,"��������ȫ��������ʾ��Ϣ��#249")
    else
        filterglobalmsg(actor, 0)
        setflagstatus(actor,VarCfg["F_����ȫ����Ϣ"], 0)
        Player.sendmsgEx(actor,"�رչ���ȫ��������ʾ��Ϣ��#249")
    end
end

--ע��������Ϣ
Message.RegisterNetMsg(ssrNetMsgCfg.FuWuBox, FuWuBox)
return FuWuBox
