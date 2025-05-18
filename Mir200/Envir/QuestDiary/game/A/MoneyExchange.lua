local MoneyExchange = {}

function MoneyExchange.Request(actor,arg1,arg2)
    arg2 = math.floor(arg2)
    if MoneyExchange.detection(arg2) == false then
        return
    end
    local MoneyData = {{"��ʯ",arg2}}
    --�һ�Ԫ��
    if arg1 == 1 then
        MoneyExchange.Exchange(actor,MoneyData,arg2,2,50000,"Ԫ��")
    --�һ����
    elseif arg1 == 2 then
        MoneyExchange.Exchange(actor,MoneyData,arg2,5,20,"���")
    else
        Player.sendmsg(actor,"�һ���������")
    end
end

function MoneyExchange.detection(Num)
    if Num == "" or Num == nil then
        Player.sendmsg("������һ���������")
        return false
    end
    if type(Num) ~= "number" then
        Player.sendmsg("ֻ���������֣�")
        return false
    end
    if Num > 9999 then
        Player.sendmsg("�һ��������ܳ���9999!")
        return false
    end
    if Num < 1 then
        Player.sendmsg("�һ������������1")
        return false
    end
    return true
end

function MoneyExchange.Exchange(actor,MoneyData,MoneyMum,MoneyIdx,multiple,MoneyName)
    local name,num = Player.checkItemNumByTable(actor, MoneyData)
    if name then
        messagebox(actor, "�һ�ʧ�ܣ�����"..name.."����"..num..",�Ƿ��ֵһ�㣿", "@openrecharge", "@quxiao")
        return
    else
        Player.takeItemByTable(actor, MoneyData, "��ʯ�һ�"..MoneyName)
        local money = MoneyMum*multiple
        changemoney(actor,MoneyIdx,"+",money,"��ʯ�һ�"..MoneyName,true)
        local msgData = {
            {"#FFFFFF","��ϲ���ɹ��һ�"},
            {"#00FF00","["..tostring(money)..MoneyName.."]"}
        }
        Player.sendmsg(actor,msgData)
    end
end

--ע��������Ϣ
Message.RegisterNetMsg(ssrNetMsgCfg.MoneyExchange,MoneyExchange)

return MoneyExchange