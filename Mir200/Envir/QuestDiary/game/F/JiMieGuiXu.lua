local JiMieGuiXu = {}
local cost = {{"�ڰ�����", 288},{"��ҳ", 3888}}
function JiMieGuiXu.Request(actor)
    local skillinfo = getskillinfo(actor,2023,1)
    if skillinfo then
        Player.sendmsgEx(actor, "��ʾ#251|:#255|���Ѿ�ѧϰ|�������#249|�����ظ�ѧϰ...")
        setflagstatus(actor,VarCfg["F_ѧϰ��į����"],1)
        return
    end

    local name, num = Player.checkItemNumByTable(actor, cost)
    if name then
        Player.sendmsgEx(actor, string.format("��ʾ#251|:#255|���|%s#249|��������|%d#249|,ѧϰʧ��...", name, num))
        return
    end
    Player.takeItemByTable(actor, cost, "�������ѧϰ")
    setflagstatus(actor,VarCfg["F_ѧϰ��į����"],1)
    addskill(actor, 2023,3)
    Player.sendmsgEx(actor, "��ʾ#251|:#255|��ϲ��,ѧϰ|�������#249|�ɹ�...")

    JiMieGuiXu.SyncResponse(actor)
end

--ʹ�ü��ܴ���
local function _onJiMieGuiXu(actor, target)
    if not Player.IsPlayer(target) then return end
    local MyLevel = getbaseinfo(actor,ConstCfg.gbase.level)
    local TgtLevel = getbaseinfo(target,ConstCfg.gbase.level)
    local x, y = Player.GetX(target),Player.GetY(target)
    if randomex(1,2) then
        rangeharm(actor, x, y, 3, 0, 6, getbaseinfo(actor,ConstCfg.gbase.dc2))    -- ����2*2��Χ�ڵ���1��
        if MyLevel > TgtLevel then           --�Եȼ����������Ҹ��ʽ������2S
            rangeharm(actor, x, y, 3, 0, 2, 2, 0, 1)    -- ����2*2��Χ�ڵ���1��
        else                                 --�Եȼ����������Ҹ��ʼ���2S.
            rangeharm(actor, x, y, 3, 0, 7, 2, 0, 1)    -- ����2*2��Χ�ڵ���2��
        end
    end
end
GameEvent.add(EventCfg["ʹ�ü������"], _onJiMieGuiXu, JiMieGuiXu)

--ע��������Ϣ
function JiMieGuiXu.SyncResponse(actor, logindatas)
    Message.sendmsg(actor, ssrNetMsgCfg.JiMieGuiXu_SyncResponse, 0, 0, 0, nil)
end
Message.RegisterNetMsg(ssrNetMsgCfg.JiMieGuiXu, JiMieGuiXu)

--��¼����
local function _onLoginEnd(actor, logindatas)
    JiMieGuiXu.SyncResponse(actor, logindatas)
end
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, JiMieGuiXu)

return JiMieGuiXu
