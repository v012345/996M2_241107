local ZongHeFuWu = {}
local demand = {{"����", 10}}
local checkreLevel = 1
function ZongHeFuWu.Request(actor,arg1,arg2,arg3,data)
    if arg1 == 1 then
        -- callscriptex(actor,"RestRenewLevel")
        -- renewlevel(actor,1)
        local flag = getflagstatus(actor, VarCfg.F_is_global_alerts) == 0 and 1 or 0
        setflagstatus(actor, VarCfg.F_is_global_alerts, flag)
        filterglobalmsg(actor, flag)
        if flag == 1 then
            Player.sendmsg(actor, "[ϵͳ��ʾ]:�Ѿ��ر���ȫ����Ϣ��ʾ!")
        else
            Player.sendmsg(actor, "[ϵͳ��ʾ]:�Ѿ�������ȫ����Ϣ��ʾ!")
        end

    elseif arg1 == 2 then
        local flag = getflagstatus(actor, VarCfg.F_is_global_alerts)
        if data[1] == "" or data[1] == nil then
            Player.sendmsg(actor, "�������ݲ���Ϊ��!")
            return
        end
        if GbkLength(data[1]) > 60 then
            Player.sendmsg(actor, "�ַ��������ܳ���60���ַ�!")
            return
        end
        local name, num = Player.checkItemNumByTable(actor, demand, 1)
        if name then
            local msgData = {
                {"","��Ǹ���"},
                {"#FF0000",name},
                {"","����"},
                {"#FF0000",num},
                {"","!"}
            }
            Player.sendmsg(actor, msgData)
            return
        end
        local myRelevel = getbaseinfo(actor, ConstCfg.gbase.renew_level)
        if myRelevel < checkreLevel then
            local msgData = {
                {"","��Ǹ���"},
                {"#FF0000","ת��"},
                {"","�ȼ�����"},
                {"#FF0000",checkreLevel},
                {"",",�޷�ʹ��"},
                {"#FF0000","ǧ�ﴫ��"},
                {"","!"}
            }
            Player.sendmsg(actor, msgData)
            return
        end
        Player.takeItemByTable(actor, demand, "ǧ�ﴫ��")
        local myName = getbaseinfo(actor, ConstCfg.gbase.name)
        -- if flag == 1 then
        --     filterglobalmsg(actor, 0)
        -- end
        sendmovemsg(actor,1,253,0,280,1,"<"..myName..":/FCOLOR=250>"..data[1])
        if flag == 1 then
            sendmovemsg(actor,0,253,0,280,1,"<"..myName..":/FCOLOR=250>"..data[1])
        end
    end
end
Message.RegisterNetMsg(ssrNetMsgCfg.ZongHeFuWu, ZongHeFuWu)

return ZongHeFuWu