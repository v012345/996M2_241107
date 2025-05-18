local RiYaoJieJie = {}
-- local config = include("QuestDiary/cfgcsv/cfg_TaiYangShengCheng_Mon.lua") -- ������Ϣ
local cost = {{"��ҫ����", 1},{"��֮ʥ��", 1},{"����֮��", 1},{"����ᾧ", 1},{"ʥ���Ż�", 1}}

function RiYaoJieJie.Request(actor,var1)
    




    local cfg = cost[var1]
    if not cfg then
        Player.sendmsgEx(actor, "��ʾ#251|:#255|��������,�ύʧ��...")
        return
    end
    local bool = getflagstatus(actor, VarCfg["F_�Ƴ���ҫ_�����ʶ".. var1 ..""])
    if bool == 1 then
        Player.sendmsgEx(actor, "��ʾ#251|:#255|�Բ���,�����ύ|".. cost[1][1] .."#249|��,�����ظ��ύ...")
        return
    end
    local name, num = Player.checkItemNumByTable(actor, {cost[var1]})
    if name then
        Player.sendmsgEx(actor, string.format("��ʾ#251|:#255|���|%s#249|����|%d#249|ö,�ύʧ��...", name, num))
        return
    end
    Player.takeItemByTable(actor, {cost[var1]}, "��ҫ����۳�")
    local AttNum = getplaydef(actor, VarCfg["U_��ҫ���_�˺�ѹ��"])
    setplaydef(actor, VarCfg["U_��ҫ���_�˺�ѹ��"],  AttNum + 18)
    setflagstatus(actor, VarCfg["F_�Ƴ���ҫ_�����ʶ".. var1 ..""], 1)
    if not checktitle(actor, "��ҫ�ս���") then
        local JiHuoNum = 0
        for i = 1, 5 do
            local _bool = getflagstatus(actor, VarCfg["F_�Ƴ���ҫ_�����ʶ".. i ..""])
            if _bool == 1 then
                JiHuoNum = JiHuoNum + 1
            end
        end
        if JiHuoNum == 5 then
            confertitle(actor, "��ҫ�ս���", 1)
            Player.setAttList(actor, "���Ը���")
        end
    end
    RiYaoJieJie.SyncResponse(actor)
end

-- ��������ǰ����
-- local function _onAttackDamageMonster(actor, Target, Hiter, MagicId, Damage, Model, attackDamageData)
--     local MonName = getbaseinfo(Target,ConstCfg.gbase.name)
--     local Mon = config[MonName]
--     if Mon then
--         local AttNum = getplaydef(actor, VarCfg["U_��ҫ���_�˺�ѹ��"])
--         AttNum = AttNum / 100 
--         attackDamageData.damage = attackDamageData.damage - Damage * (0.9 - AttNum)
--     end
-- end
-- GameEvent.add(EventCfg.onAttackDamageMonster, _onAttackDamageMonster, RiYaoJieJie)

--ע��������Ϣ
function RiYaoJieJie.SyncResponse(actor, logindatas)
    local bool1 = getflagstatus(actor, VarCfg["F_�Ƴ���ҫ_�����ʶ1"])
    local bool2 = getflagstatus(actor, VarCfg["F_�Ƴ���ҫ_�����ʶ2"])
    local bool3 = getflagstatus(actor, VarCfg["F_�Ƴ���ҫ_�����ʶ3"])
    local bool4 = getflagstatus(actor, VarCfg["F_�Ƴ���ҫ_�����ʶ4"])
    local bool5 = getflagstatus(actor, VarCfg["F_�Ƴ���ҫ_�����ʶ5"])
    local data ={ bool1,bool2,bool3,bool4,bool5 }

    local _login_data = { ssrNetMsgCfg.RiYaoJieJie_SyncResponse, 0, 0, 0, data }
    if logindatas then
        table.insert(logindatas, _login_data)
    else
        Message.sendmsg(actor, ssrNetMsgCfg.RiYaoJieJie_SyncResponse, 0, 0, 0, data)
    end
end
Message.RegisterNetMsg(ssrNetMsgCfg.RiYaoJieJie, RiYaoJieJie)


--��¼����
local function _onLoginEnd(actor, logindatas)
    RiYaoJieJie.SyncResponse(actor, logindatas)
end
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, RiYaoJieJie)


return RiYaoJieJie

