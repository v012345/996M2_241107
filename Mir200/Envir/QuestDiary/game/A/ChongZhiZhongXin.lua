local ChongZhiZhongXin = {}
local config = include("QuestDiary/cfgcsv/cfg_ChongZhiZhongXin.lua")

function ChongZhiZhongXin.Request1(actor, PayWay ,Sum)
    if Sum % 1 ~= 0 then return end

    if Sum < 10 then
        Player.sendmsgEx(actor, "��ʾ#251|:#255|��ͳ�ֵ|10Ԫ#249|,����������...")
        return
    end
    pullpay(actor,Sum,PayWay,7)
end

local function CheckAwardState(actor)
    local Num = 0
    for i = 1, 8 do
        local bool = getflagstatus(actor, VarCfg["F_�׳䷭����ʶ_".. i ..""])
        Num = Num + bool
    end
    if Num < 8 then return   end
    confertitle(actor, "�������", 1)
end

-- ֧����ʽ�������ţ�֧�����
function ChongZhiZhongXin.Request2(actor,PayWay,Sort,Sum)
    local bool = getflagstatus(actor, VarCfg["F_�׳䷭����ʶ_".. Sort ..""])
    local JiFenNum = getplaydef(actor, VarCfg["U_��������"])
    local cfg = config[Sort]
    if bool == 0  then
        if JiFenNum >= cfg.Sum then
            setflagstatus(actor, VarCfg["F_�׳䷭����ʶ_".. Sort ..""], 1)
            local JiFenNum = getplaydef(actor, VarCfg["U_��������"])
            JiFenNum = JiFenNum - cfg.Sum
            setplaydef(actor, VarCfg["U_��������"], JiFenNum)
            local award = cfg.award
            local JieShao = ""
            local JiangLi = ""
            for i, v in ipairs(award) do
                if i >= 2 then
                    JieShao = JieShao .. "\\���"..v[1].."x"..v[2]
                end
            end

            for i, v in ipairs(award) do
                if i >= 2 then
                    JiangLi = JiangLi .. "".. v[1] .."#"..v[2].."#51&"
                end
            end
            local UserId = getconst(actor, "<$USERID>")
            sendmail(UserId, 5001, cfg.Sum.."Ԫ��ֵ���",JieShao,JiangLi)
            Player.sendmsgEx(actor, "��ʾ#251|:#255|��ϲ��,��ȡ|"..  cfg.Sum .."Ԫ��ֵ���#249|,ף����Ϸ���...")
            ChongZhiZhongXin.SyncResponse(actor)
            CheckAwardState(actor)
        else
            pullpay(actor,Sum,PayWay,7)
        end
    else
        pullpay(actor,Sum,PayWay,7)
    end
    -- release_print("֧����ʽ",PayWay)
    -- release_print("������",Sort)
    -- release_print("֧�����",Sum)
end

--ע��������Ϣ
function ChongZhiZhongXin.SyncResponse(actor, logindatas)
    local data = { }
    for i = 1, 8 do
        local num = getflagstatus(actor, VarCfg["F_�׳䷭����ʶ_".. i ..""])
        table.insert(data, num)
    end
    local JiFenNum = getplaydef(actor, VarCfg["U_��������"])
    table.insert(data, JiFenNum)
    local LeiJiChongZhi = getplaydef(actor, VarCfg["U_��ʵ��ֵ"])
    table.insert(data, LeiJiChongZhi)

    local _login_data = { ssrNetMsgCfg.ChongZhiZhongXin_SyncResponse, 0, 0, 0, data }
    if logindatas then
        table.insert(logindatas, _login_data)
    else
        Message.sendmsg(actor, ssrNetMsgCfg.ChongZhiZhongXin_SyncResponse, 0, 0, 0, data)
    end
end
Message.RegisterNetMsg(ssrNetMsgCfg.ChongZhiZhongXin, ChongZhiZhongXin)

-- ��ֵ�ص�
-- gold: ��ֵ���һ�������
-- moneyid: ��ֵ��������
-- 7	���
-- 20	�����
local function _onRecharge(actor, gold, productid, moneyid)
    if moneyid ~= 7 and moneyid ~= 20 then return end
    -- local name = getbaseinfo(actor, ConstCfg.gbase.name)
    -- sendmsg(actor, 1, '{"Msg":"<font color=\'#ff0000\'>���'.. name ..'������</font>","Type":9}')
    -- sendmsg(actor, 1, '{"Msg":"<font color=\'#ff0000\'>����'.. moneyid ..'������</font>","Type":9}')
    -- sendmsg(actor, 1, '{"Msg":"<font color=\'#ff0000\'>����'.. gold ..'������</font>","Type":9}')
    -- sendmsg(actor, 1, '{"Msg":"<font color=\'#ff0000\'>NPC'.. productid ..'������</font>","Type":9}')
    changemoney(actor, 11, "+", gold, "��ֵ�ص�����", true)
    --------------����ÿ�ճ�ֵ--------------
    local RiChongNum = getplaydef(actor, VarCfg["J_�ճ��¼"])
    RiChongNum = RiChongNum + gold
    setplaydef(actor, VarCfg["J_�ճ��¼"], RiChongNum)
    --------------������ʵ��ֵ--------------
    local LeiJiChongZhi = getplaydef(actor, VarCfg["U_��ʵ��ֵ"])
    LeiJiChongZhi = LeiJiChongZhi + gold
    setplaydef(actor, VarCfg["U_��ʵ��ֵ"], LeiJiChongZhi)
    --------------�����������--------------
    if not checktitle(actor, "�������") then
        local JiFenNum = getplaydef(actor, VarCfg["U_��������"])
        JiFenNum = JiFenNum + gold
        setplaydef(actor, VarCfg["U_��������"], JiFenNum)
    end

    local OnTheList = false
    local AwardInfo = {}
    for i, v in ipairs(config) do
        if gold == v.Sum then
            local num = getflagstatus(actor, VarCfg["F_�׳䷭����ʶ_".. i ..""])
            if num == 0 then
                setflagstatus(actor, VarCfg["F_�׳䷭����ʶ_".. i ..""], 1)
                OnTheList = true
                AwardInfo = v
                ChongZhiZhongXin.SyncResponse(actor)
                break
            end
        end
    end

    if OnTheList then
        local JiFenNum = getplaydef(actor, VarCfg["U_��������"])
        JiFenNum = JiFenNum - AwardInfo.Sum
        setplaydef(actor, VarCfg["U_��������"], JiFenNum)
        local award = AwardInfo.award
        local JieShao = ""
        local JiangLi = ""

        for i, v in ipairs(award) do
            if i >= 2 then
                JieShao = JieShao .. "\\���"..v[1].."x"..v[2]
            end
        end

        for i, v in ipairs(award) do
            if i >= 2 then
                JiangLi = JiangLi .. "".. v[1] .."#"..v[2].."#51&"
            end
        end

        local UserId = getconst(actor, "<$USERID>")
        sendmail(UserId, 5001, AwardInfo.Sum.."Ԫ��ֵ���",JieShao,JiangLi)
        Player.sendmsgEx(actor, "��ʾ#251|:#255|��ϲ��,��ȡ|"..  AwardInfo.Sum .."Ԫ��ֵ���#249|,ף����Ϸ���...")
        ChongZhiZhongXin.SyncResponse(actor)
        CheckAwardState(actor)
    end
    ChongZhiZhongXin.SyncResponse(actor)
    GameEvent.push(EventCfg.onRechargeEnd, actor)

end
GameEvent.add(EventCfg.onRecharge, _onRecharge, ChongZhiZhongXin)

--��¼����
local function _onLoginEnd(actor, logindatas)
    ChongZhiZhongXin.SyncResponse(actor, logindatas)
end
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, ChongZhiZhongXin)

-- ɱ�ִ��� ��������  ÿɱ10ֻ������������1���и 
local function _onKillMon(actor, monobj)
    if checktitle(actor, "��������") then
        local KillMonNum = getplaydef(actor, VarCfg["N$��������_ɱ�ּ���"])
        KillMonNum = KillMonNum + 1
        setplaydef(actor, VarCfg["N$��������_ɱ�ּ���"], KillMonNum)
        if KillMonNum >= 10  then
            setplaydef(actor, VarCfg["N$��������_ɱ�ּ���"], 0)
            local num = getplaydef(actor, VarCfg["U_�������˲���"])
            num = num + 1
            setplaydef(actor, VarCfg["U_�������˲���"], num)
            setaddnewabil(actor,12,"=","3#200#".. num .."")
        end
    end
end
GameEvent.add(EventCfg.onKillMon, _onKillMon, ChongZhiZhongXin)



return ChongZhiZhongXin
