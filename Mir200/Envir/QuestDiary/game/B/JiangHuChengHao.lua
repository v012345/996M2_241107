local JiangHuChengHao = {}
local config = include("QuestDiary/cfgcsv/cfg_JiangHuChengHao.lua") --ϴ��

local function delAllTitle(actor)
    for index, value in ipairs(config) do
        deprivetitle(actor, value.title)
    end
end

function JiangHuChengHao.Request(actor)
    local currIndex = getplaydef(actor, VarCfg["U_�����ƺ�"])
    local index = currIndex + 1
    local cfg = config[index]
    if not cfg then
        Player.sendmsgEx(actor, "[��ʾ]:#251|��ĳƺ��Ѿ�������#249")
        return
    end
    local name, num = Player.checkItemNumByTable(actor, cfg.cost)
    if name then
        Player.sendmsgEx(actor, string.format("[��ʾ]:#251|���|%s#249|����|%d#249", name, num))
        return
    end
    local currDaLu = getplaydef(actor,VarCfg["U_��¼��½"])
    if currDaLu < cfg.dalu then
        local chinaNumber = formatNumberToChinese(cfg.dalu)
        Player.sendmsgEx(actor, string.format("����|%s��½#249|����ܼ�������!", chinaNumber))
        return
    end
    Player.takeItemByTable(actor, cfg.cost, "�����ƺ�����")
    delAllTitle(actor) --ȫ��ɾ��һ�η�ֹɾ����
    confertitle(actor, cfg.title, 1)
    GameEvent.push(EventCfg.onGetTaskTitle, actor, cfg.title) --���񴥷�
    --�����ƺŴ���
    GameEvent.push(EventCfg.onJiangHuTitleUP, actor, cfg.title)

    setplaydef(actor, VarCfg["U_�����ƺ�"], index)
    Player.setAttList(actor, "���ʸ���")
    Player.setAttList(actor, "���Ը���")
    --ͬ��һ����Ϣ
    JiangHuChengHao.SyncResponse(actor)
end

-------------������Ϣ������--------------------------
Message.RegisterNetMsg(ssrNetMsgCfg.JiangHuChengHao, JiangHuChengHao)
function JiangHuChengHao.SyncResponse(actor, logindatas)
    local count = getplaydef(actor, VarCfg["U_�����ƺ�"])
    local _login_data = { ssrNetMsgCfg.JiangHuChengHao_SyncResponse, count }
    if logindatas then
        table.insert(logindatas, _login_data)
    else
        Message.sendmsg(actor, ssrNetMsgCfg.JiangHuChengHao_SyncResponse, count)
    end
end

--��¼����
local function _onLoginEnd(actor, logindatas)
    JiangHuChengHao.SyncResponse(actor, logindatas)
end
--�¼��ɷ�
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, JiangHuChengHao)

return JiangHuChengHao
