local ZongHeFuWu = {}
local demand = {{"大米", 10}}
local checkreLevel = 1
function ZongHeFuWu.Request(actor,arg1,arg2,arg3,data)
    if arg1 == 1 then
        -- callscriptex(actor,"RestRenewLevel")
        -- renewlevel(actor,1)
        local flag = getflagstatus(actor, VarCfg.F_is_global_alerts) == 0 and 1 or 0
        setflagstatus(actor, VarCfg.F_is_global_alerts, flag)
        filterglobalmsg(actor, flag)
        if flag == 1 then
            Player.sendmsg(actor, "[系统提示]:已经关闭了全服信息提示!")
        else
            Player.sendmsg(actor, "[系统提示]:已经开启了全服信息提示!")
        end

    elseif arg1 == 2 then
        local flag = getflagstatus(actor, VarCfg.F_is_global_alerts)
        if data[1] == "" or data[1] == nil then
            Player.sendmsg(actor, "输入内容不能为空!")
            return
        end
        if GbkLength(data[1]) > 60 then
            Player.sendmsg(actor, "字符数量不能超过60个字符!")
            return
        end
        local name, num = Player.checkItemNumByTable(actor, demand, 1)
        if name then
            local msgData = {
                {"","抱歉你的"},
                {"#FF0000",name},
                {"","不足"},
                {"#FF0000",num},
                {"","!"}
            }
            Player.sendmsg(actor, msgData)
            return
        end
        local myRelevel = getbaseinfo(actor, ConstCfg.gbase.renew_level)
        if myRelevel < checkreLevel then
            local msgData = {
                {"","抱歉你的"},
                {"#FF0000","转生"},
                {"","等级不足"},
                {"#FF0000",checkreLevel},
                {"",",无法使用"},
                {"#FF0000","千里传音"},
                {"","!"}
            }
            Player.sendmsg(actor, msgData)
            return
        end
        Player.takeItemByTable(actor, demand, "千里传音")
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