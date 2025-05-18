local YingLingJiTan = {}
YingLingJiTan.ID = "Ӣ���̳"
local npcID = 234
local config = include("QuestDiary/cfgcsv/cfg_YingLingJiTan.lua") --����
local function delAllTitle(actor)
    for _, value in ipairs(config) do
        deprivetitle(actor, value.title)
    end
end
--��������
function YingLingJiTan.Request1(actor)
    local currIndex = getplaydef(actor, VarCfg["U_����_Ӣ���̳_�ƺ�"])
    local index = currIndex + 1
    local cfg = config[index]
    if not cfg then
        Player.sendmsgEx(actor, "[��ʾ]:#251|���Ӣ���ƺ��Ѿ�������#249")
        return
    end
    local name, num = Player.checkItemNumByTable(actor, cfg.cost)
    if name then
        Player.sendmsgEx(actor, string.format("[��ʾ]:#251|���|%s#249|����|%d#249", name, num))
        return
    end
    Player.takeItemByTable(actor, cfg.cost, "�����ƺ�����")
    delAllTitle(actor) --ȫ��ɾ��һ�η�ֹɾ����
    confertitle(actor, cfg.title, 1)
    Player.sendmsgEx(actor, string.format("[��ʾ]:#251|��ϲ���óƺ�|%s#249", cfg.title))
    setplaydef(actor, VarCfg["U_����_Ӣ���̳_�ƺ�"], index)
    if index == 1 then
        local taskPanelID = getplaydef(actor, VarCfg["U_��������������"])
        if taskPanelID == 15 then
            FCheckTaskRedPoint(actor)
        end
    end
    Player.setAttList(actor, "���ʸ���")
    Player.setAttList(actor, "���ٸ���")
    Player.setAttList(actor, "��������")
    --ͬ��һ����Ϣ
    YingLingJiTan.SyncResponse(actor)
end

function YingLingJiTan.Request2(actor)
    local currIndex = getplaydef(actor, VarCfg["U_����_Ӣ���̳_�ƺ�"])
    local index = currIndex + 1
    local cfg = config[index]
    if not cfg then
        Player.sendmsgEx(actor, "[��ʾ]:#251|���Ӣ���ƺ��Ѿ�������#249")
        return
    end
    local totalRecharge = getplaydef(actor, VarCfg["U_��ʵ��ֵ"])
    if totalRecharge < cfg.totalRecharge then
        Player.sendmsgEx(actor, string.format("[��ʾ]:#251|���|%s#249|����|%d#249", "�ۼƳ�ֵ", cfg.totalRecharge))
        return
    end
    delAllTitle(actor) --ȫ��ɾ��һ�η�ֹɾ����
    setflagstatus(actor, cfg.tuihuan, 1)
    confertitle(actor, cfg.title, 1)
    Player.sendmsgEx(actor, string.format("[��ʾ]:#251|��ϲ���óƺ�|%s#249", cfg.title))
    setplaydef(actor, VarCfg["U_����_Ӣ���̳_�ƺ�"], index)
    Player.setAttList(actor, "���ʸ���")
    Player.setAttList(actor, "���ٸ���")
    Player.setAttList(actor, "��������")
    --ͬ��һ����Ϣ
    YingLingJiTan.SyncResponse(actor)
end

--ͬ����Ϣ
function YingLingJiTan.SyncResponse(actor, logindatas)
    local count = getplaydef(actor, VarCfg["U_����_Ӣ���̳_�ƺ�"])
    local totalRecharge = getplaydef(actor, VarCfg["U_��ʵ��ֵ"])
    local data = {}
    local _login_data = { ssrNetMsgCfg.YingLingJiTan_SyncResponse, count, totalRecharge, 0, data }
    if logindatas then
        table.insert(logindatas, _login_data)
    else
        Message.sendmsg(actor, ssrNetMsgCfg.YingLingJiTan_SyncResponse, count, totalRecharge, 0, data)
    end
end

--��¼����
local function _onLoginEnd(actor, logindatas)
    YingLingJiTan.SyncResponse(actor, logindatas)
end
--�¼��ɷ�
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, YingLingJiTan)
--ע��������Ϣ

local function _onCalcAttackSpeed(actor, attackSpeeds)
    local count = getplaydef(actor, VarCfg["U_����_Ӣ���̳_�ƺ�"])
    local cfg = config[count]
    if not cfg then
        return
    end

    local gongSu = cfg.gongsu
    attackSpeeds[1] = attackSpeeds[1] + gongSu
end
--��������
GameEvent.add(EventCfg.onCalcAttackSpeed, _onCalcAttackSpeed, YingLingJiTan)

--��������
local function _onCalcBeiGong(actor, beiGongs)
    local count = getplaydef(actor, VarCfg["U_����_Ӣ���̳_�ƺ�"])
    local cfg = config[count]
    if not cfg then
        return
    end
    local beigong = cfg.beigong
    beiGongs[1] = beiGongs[1] + beigong
end
GameEvent.add(EventCfg.onCalcBeiGong, _onCalcBeiGong, YingLingJiTan)

--�����˴���
local function _onAttackPlayer(actor, Target, Hiter, MagicId)
    local count = getplaydef(actor, VarCfg["U_����_Ӣ���̳_�ƺ�"])
    local cfg = config[count]
    if not cfg then
        return
    end
    if cfg.zhansha then
        local count = getplaydef(actor, VarCfg["N$Ӣ���ƺŵ�������"])
        setplaydef(actor, VarCfg["N$Ӣ���ƺŵ�������"], count + 1)
        if count >= 12 then
            setplaydef(actor, VarCfg["N$Ӣ���ƺŵ�������"], 0)
            local calcHp = Player.getHpValue(Target, cfg.zhansha)
            humanhp(Target, "-", calcHp, 1, 0, actor)
            local myName = getbaseinfo(actor, ConstCfg.gbase.name)
            local targetName = getbaseinfo(Target, ConstCfg.gbase.name)
            Player.buffTipsMsg(actor, "[Ӣ���]:��նɱ�����[{" .. targetName .. "/FCOLOR=243}]{" .. cfg.zhansha .. "%/FCOLOR=243}��Ѫ��")
            Player.buffTipsMsg(Target, "[Ӣ���]:�㱻���[{" .. myName .. "/FCOLOR=243}]նɱ��{" .. cfg.zhansha .. "%/FCOLOR=243}��Ѫ��")
        end
    end
end
GameEvent.add(EventCfg.onAttackPlayer, _onAttackPlayer, YingLingJiTan)

Message.RegisterNetMsg(ssrNetMsgCfg.YingLingJiTan, YingLingJiTan)
return YingLingJiTan