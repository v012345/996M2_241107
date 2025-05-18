
local CaiLiaoHuoZhan = {}
local config = include("QuestDiary/cfgcsv/cfg_CaiLiaoHuoZhan.lua") --���ɱ���¼��ͼ
function CaiLiaoHuoZhan.Request(actor,var)
    local J104 = getplaydef(actor, VarCfg["J_���ϻ�ջ��ȡ����"] )
    local BuyNumUL = 0
    if checktitle(actor, "ţ����Ȩ") then BuyNumUL = BuyNumUL + 2 end
    if checktitle(actor, "�򹤻ʵ�") then BuyNumUL = BuyNumUL + 5 end
    if checktitle(actor, "�������") then BuyNumUL = BuyNumUL + 20 end

    if J104 >= BuyNumUL then
        Player.sendmsgEx(actor, "��ʾ#251|:#255|�Բ���,�����|û����ȡ����#249|��,����������...")
        return
    end

    local cfg = config[var]
    if not cfg then
        Player.sendmsgEx(actor, "��ʾ#251|:#255|��������,������...")
        return
    end
    local cost = cfg.cost
    local name, num = Player.checkItemNumByTable(actor, cost)
    if name then
        Player.sendmsgEx(actor, string.format("��ʾ#251|:#255|�Բ���,���|%s#249|����|%d#249|,��ȡʧ��...", name, num))
        return
    end
    Player.takeItemByTable(actor, cost, "���ϻ�ջ��ȡ")
    Player.giveItemByTable(actor, cfg.give, "���ϻ�ջ��ȡ")
    J104 = J104 + 1
    setplaydef(actor, VarCfg["J_���ϻ�ջ��ȡ����"], J104)
    CaiLiaoHuoZhan.SyncResponse(actor)
end


--ע��������Ϣ
function CaiLiaoHuoZhan.SyncResponse(actor, logindatas)
    local J104 = getplaydef(actor, VarCfg["J_���ϻ�ջ��ȡ����"] )
    local BuyNumUL = 0
    if checktitle(actor, "ţ����Ȩ") then BuyNumUL = BuyNumUL + 2 end
    if checktitle(actor, "�򹤻ʵ�") then BuyNumUL = BuyNumUL + 5 end
    if checktitle(actor, "�������") then BuyNumUL = BuyNumUL + 20 end
    local data = { J104, BuyNumUL}
    local _login_data = { ssrNetMsgCfg.CaiLiaoHuoZhan_SyncResponse, 0, 0, 0, data }
    if logindatas then
        table.insert(logindatas, _login_data)
    else
        Message.sendmsg(actor, ssrNetMsgCfg.CaiLiaoHuoZhan_SyncResponse, 0, 0, 0, data)
    end
end
Message.RegisterNetMsg(ssrNetMsgCfg.CaiLiaoHuoZhan, CaiLiaoHuoZhan)

--��¼����
local function _onLoginEnd(actor, logindatas)
    CaiLiaoHuoZhan.SyncResponse(actor, logindatas)
end
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, CaiLiaoHuoZhan)

return CaiLiaoHuoZhan
