local JiHanZhiXin = {}
-- local cost = { { "����֮��", 1 }, { "���", 18800000 } }
local cost = { { "����֮��", 1 }, { "���", 1 } }

local function heChengSuccess(actor)
    giveitem(actor, "����ᾧ", 1, ConstCfg.binding)
    setflagstatus(actor, VarCfg["F_����ᾧ�ɹ�"], 1)
    Player.sendmsgEx(actor, "��ʾ#251|:#255|��ϲ��ϳ�|����ᾧ#249|�ɹ�...")
end
function JiHanZhiXin.Request(actor)
    local name, num = Player.checkItemNumByTable(actor, cost)
    if name then
        Player.sendmsgEx(actor, string.format("��ʾ#251|:#255|���|%s#249|����|%d#249|ö,����ʧ��...", name, num))
        return
    end
    Player.takeItemByTable(actor, cost, "����ᾧ�۳�����")
    local _Num = getplaydef(actor, VarCfg["T_����֮�ĺϳɴ���"])
    local Num = (_Num == "" and 0) or tonumber(_Num)
    setplaydef(actor, VarCfg["T_����֮�ĺϳɴ���"], Num + 1)
    if Num + 1 <= 6 then
        if randomex(5) then
            heChengSuccess(actor)
        else
            Player.sendmsgEx(actor, "��ʾ#251|:#255|�Բ���,�ϳ�|����ᾧ#249|ʧ��...")
        end
    elseif Num + 1 >= 7 then
        heChengSuccess(actor)
    end
    JiHanZhiXin.SyncResponse(actor)
end

-- ͬ��һ����Ϣ
function JiHanZhiXin.SyncResponse(actor)
    Message.sendmsg(actor, ssrNetMsgCfg.JiHanZhiXin_SyncResponse, 0, 0, 0, nil)
end

Message.RegisterNetMsg(ssrNetMsgCfg.JiHanZhiXin, JiHanZhiXin)

return JiHanZhiXin
