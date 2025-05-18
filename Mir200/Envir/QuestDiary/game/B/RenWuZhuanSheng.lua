local RenWuZhuanSheng = {}
local config = include("QuestDiary/cfgcsv/cfg_RenewLevelData.lua")
local RenewLevel_data = { [205]= 1, [310]= 2, [426]= 4, [518]= 5, [625]= 6, [711]= 7, [801]= 8}
local FaBaoNum = {["�߱�������"] = 1,["Ǭ��������"] = 2,["�Ź�������"] = 3,["ʮ�����ӡ"] = 4,["������ħ��"] = 5,["����������"] = 6,["����ʥ��ʯ"] = 7,["����������"] = 8,["���������"] = 9,["����������"] = 10,["����������"] = 11,["�������¯"] = 12,["�������յ"] = 13,["Ǳ������ʯ"] = 14}

function RenWuZhuanSheng.Request(actor, npcID)
    if not FCheckNPCRange(actor, npcID, 15) then
        Player.sendmsgEx(actor, "����PNC̫Զ!#249")
        return
    end
    local NowRenewLevel = getbaseinfo(actor,ConstCfg.gbase.renew_level)
    if npcID == 310 then
        if NowRenewLevel >= RenewLevel_data[npcID] + 1 then   --��������½��ת��
            Player.sendmsgEx(actor, "��ʾ#251|:#255|�Բ���,ת��|ʧ��#249|,��ǰ�����ߵȼ���½����...")
            return
        end
    else
        if NowRenewLevel >= RenewLevel_data[npcID] then
            Player.sendmsgEx(actor, "��ʾ#251|:#255|��ǰ��½|������#249|,��ǰ�����ߴ�½...")
            return
        end
    end
    local cfg = config[NowRenewLevel+1]  --��ȡ��ǰת������
    --����Ƿ�ﵽ�ȼ�
    local MyLevel = getbaseinfo(actor,ConstCfg.gbase.level)
    if MyLevel < cfg.Level then
        Player.sendmsgEx(actor, "��ʾ#251|:#255|�Բ���,��ĵȼ�����|".. cfg.Level .."��#249|,ת��ʧ��...")
        return
    end
    --��ⷨ���Ƿ�ﵽ�ȼ�
    local FaBaoName = getconst(actor,"<$SBUJUK>")
    local MyFaBao = FaBaoNum[FaBaoName] == nil and 0 or FaBaoNum[FaBaoName]
    local CheckFaBao = FaBaoNum[cfg.Equip]
    if MyFaBao < CheckFaBao then
        Player.sendmsgEx(actor, "��ʾ#251|:#255|�Բ���,��ķ�����δ�ﵽ|".. cfg.Equip .."#249|,ת��ʧ��...")
        return
    end
    --��⹥�����Ƿ�ﵽҪ��
    local MyMaxDC = getbaseinfo(actor,ConstCfg.gbase.dc2)
    if MyMaxDC < cfg.MaxDC - 20000 then
        Player.sendmsgEx(actor, "��ʾ#251|:#255|�Բ���,��Ĺ�������δ�ﵽ|".. cfg.MaxDC .."#249|,ת��ʧ��...")
        return
    end

    --���Ѫ���Ƿ�ﵽҪ��
    local MyMaxHP = getbaseinfo(actor,ConstCfg.gbase.maxhp)
    if MyMaxHP < cfg.MaxHP - 1000000 then
        Player.sendmsgEx(actor, "��ʾ#251|:#255|�Բ���,���Ѫ����δ�ﵽ|".. cfg.MaxHP .."#249|,ת��ʧ��...")
        return
    end

    --��������Ƿ�ﵽ����
    local unLockData = TianMing.GetLockState(actor)
    local MyQiYunNum = 0
    for i = 13, #unLockData do
        if unLockData[i] == 1 then
            MyQiYunNum = MyQiYunNum + 1
        end
    end
    if MyQiYunNum < cfg.QiYun then
        Player.sendmsgEx(actor, "��ʾ#251|:#255|�Բ���,��ĺ������˿�������|".. cfg.QiYun .."��#249|,ת��ʧ��...")
        return
    end
    --�������Ƿ��㹻
    local name, num = Player.checkItemNumByTable(actor, cfg.Cost)
    if name then
        Player.sendmsgEx(actor, string.format("[��ʾ]:#251|���#250|%s#249|����#250|%s#249|��", name, num))
        return
    end
    Player.takeItemByTable(actor, cfg.Cost, "ת���۳�����"..NowRenewLevel)

    --ִ��ת��1��
    renewlevel(actor, 1, MyLevel - cfg.DecLevel, 0)

    local NewRenewLevel = getbaseinfo(actor,ConstCfg.gbase.renew_level)
    Player.sendmsgEx(actor, "��ʾ#251|:#255|��ϲ��,ת���ɹ�,��ǰ|".. NewRenewLevel .."#249|ת...")

    --��������ֵ
    if cfg.IncXiuxian > 0 then
        XiuXian.addXiuXian(actor, cfg.IncXiuxian)
    end

    --���ӵȼ�
    if cfg.IncLevel > 0 then
        changelevel(actor, "+", cfg.IncLevel)
    end

    if NewRenewLevel >= 4 then
        Player.setAttList(actor, "��������")
    end
    Player.setAttList(actor, "���Ը���")

    -- ת�����¼��ɷ�
    GameEvent.push(EventCfg.onRenewlevelUP,actor,NewRenewLevel)
    RenWuZhuanSheng.SyncResponse(actor)
end

--���Ը���
local function _onCalcAttr(actor, attrs)
    local shuxing = {}
    local RenewLevel = getbaseinfo(actor,ConstCfg.gbase.renew_level)
    if RenewLevel == 0  then return end
    local cfg = config[RenewLevel]
    if cfg then
        for _, v in ipairs(cfg.Attr) do
            shuxing[v[1]] = v[2]
        end
        calcAtts(attrs, shuxing, "ת�����Ը���")
    end
end
GameEvent.add(EventCfg.onCalcAttr, _onCalcAttr, RenWuZhuanSheng)


--------------������Ϣ-------------
function RenWuZhuanSheng.SyncResponse(actor)
    Message.sendmsg(actor, ssrNetMsgCfg.RenWuZhuanSheng_SyncResponse)
end

--ע��������Ϣ
Message.RegisterNetMsg(ssrNetMsgCfg.RenWuZhuanSheng, RenWuZhuanSheng)

return RenWuZhuanSheng


