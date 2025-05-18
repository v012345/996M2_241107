local NiuMaNiXi = {}
local config = include("QuestDiary/cfgcsv/cfg_NiuMaNiXi_Data.lua") --С��ħ����
local QiRiNiXiCahce = {}

function NiuMaNiXi.Request1(actor, FenLei, XiaoJie)
    local SystemDayNum = getsysvar(VarCfg["G_��������"])

    if SystemDayNum < FenLei then return end
    ---------------------�������� ��֤ǰ������ ��������---------------------
    local verify = config[FenLei].Show[XiaoJie]
    if not verify then
        Player.sendmsgEx(actor, "��ʾ#251|:#255|�Ƿ�����#249|...")
        return
    end
    ---------------------�������� ��֤ǰ������ ��������---------------------
    local cfg = config[FenLei]
    local Cahce_Tbl = NiuMaNiXi.GetZhuangBanList(actor)
    local _XiaoJie = tostring(XiaoJie)

    if Cahce_Tbl[FenLei][_XiaoJie] == "����ȡ" then
        Cahce_Tbl[FenLei][_XiaoJie] = "����ȡ"
        local UserId = getconst(actor, "<$USERID>")
        sendmail(UserId, 5002, "ţ����Ϯ","��ϲ��,��ɵ�".. FenLei .."��["..verify.."]����","".. cfg.AwardMoney[1] .."#".. cfg.AwardMoney[2] .."")
        Player.setJsonVarByTable(actor, VarCfg["T_ţ����Ϯ".. FenLei .."��"], Cahce_Tbl[FenLei])
        NiuMaNiXi.SyncResponse(actor)
    elseif Cahce_Tbl[FenLei][_XiaoJie] == "����ȡ" then
        Player.sendmsgEx(actor, "��ʾ#251|:#255|�Բ���,���Ѿ�|��ȡ#249|,����������...")
        return
    else
        Player.sendmsgEx(actor, "��ʾ#251|:#255|�Բ���,�㻹δ|�������#249|,�޷���ȡ...")
        return
    end
end

function NiuMaNiXi.Request2(actor, FenLei)
    local title = { "ţ��ʵϰ��","ţ����Ա��","ţ��С�鳤","ţ���ܾ���","ţ��ɶ�","ţ���³�"}
    ---------------------�������� ��֤���� ��������---------------------
    local SystemDayNum = getsysvar(VarCfg["G_��������"])
    local _Cahce_Tbl = NiuMaNiXi.GetZhuangBanList(actor)
    local Cahce_Tbl = _Cahce_Tbl[FenLei]
    local cfg = config[FenLei]
    local AwardNum = 0
    
    if SystemDayNum < FenLei then return end
    if not cfg then return end
    ---------------------�������� ��֤�Ƿ����ȡ ��������---------------------
    for i = 1, #cfg.Show do
        if Cahce_Tbl[tostring(i)] == "����ȡ" then
            AwardNum  = AwardNum + 1
        end
    end

    if Cahce_Tbl["�ܽ���"] == "����ȡ" then
        Player.sendmsgEx(actor, "��ʾ#251|:#255|�Բ���,���Ѿ�|��ȡ#249|,�ý�����...")
        -- Cahce_Tbl["�ܽ���"] = nil
        -- Player.setJsonVarByTable(actor, VarCfg["T_ţ����Ϯ".. FenLei .."��"], Cahce_Tbl)
        -- NiuMaNiXi.SyncResponse(actor)
        return
    end

    if FenLei >= 2 then
        if _Cahce_Tbl[FenLei-1]["�ܽ���"] ~= "����ȡ" then
            Player.sendmsgEx(actor, "��ʾ#251|:#255|�Բ���,������ȡ|��".. FenLei-1 .."��#249|����...")
            return
        end
    end

    if AwardNum == #cfg.Show then
        if FenLei == 1 then
            local UserId = getconst(actor, "<$USERID>")
            sendmail(UserId, 5002, "ţ����Ϯ","��ϲ��,��ɵ�".. FenLei .."�յ�ȫ������","".. cfg.AwardItem[1] .."#".. cfg.AwardItem[2] .."")
            Cahce_Tbl["�ܽ���"] = "����ȡ"
            Player.setJsonVarByTable(actor, VarCfg["T_ţ����Ϯ".. FenLei .."��"], Cahce_Tbl)
            NiuMaNiXi.SyncResponse(actor)
            return
        elseif FenLei == 2 then
            local UserId = getconst(actor, "<$USERID>")
            sendmail(UserId, 5002, "ţ����Ϯ","��ϲ��,��ɵ�".. FenLei .."�յ�ȫ������","".. cfg.AwardItem[1] .."#".. cfg.AwardItem[2] .."")
            Cahce_Tbl["�ܽ���"] = "����ȡ"
            Player.setJsonVarByTable(actor, VarCfg["T_ţ����Ϯ".. FenLei .."��"], Cahce_Tbl)
            NiuMaNiXi.SyncResponse(actor)
            return
        elseif FenLei >= 3 and FenLei <= 7 then
            for _, v in ipairs(title) do
                deprivetitle(actor, v)
            end
            local TitleName = cfg.AwardItem[1]:gsub("%[�ƺ�%]", "")
            confertitle(actor,TitleName)
            Player.setAttList(actor, "���Ը���")



            Cahce_Tbl["�ܽ���"] = "����ȡ"
            Player.setJsonVarByTable(actor, VarCfg["T_ţ����Ϯ".. FenLei .."��"], Cahce_Tbl)
            NiuMaNiXi.SyncResponse(actor)
            return
        end
    else
        Player.sendmsgEx(actor, "��ʾ#251|:#255|��".. FenLei .."��,����|".. AwardNum .."/"..#cfg.Show .."#249|�ٽ�����...")
        return
    end
end

--��ȡţ����Ϯ��ȡ״̬�����淽ʽ
function NiuMaNiXi.GetZhuangBanList(actor)
    if QiRiNiXiCahce[actor] then
        return QiRiNiXiCahce[actor]
    end
    local result = {}
    result[1] = Player.getJsonTableByVar(actor, VarCfg["T_ţ����Ϯ1��"])
    result[2] = Player.getJsonTableByVar(actor, VarCfg["T_ţ����Ϯ2��"])
    result[3] = Player.getJsonTableByVar(actor, VarCfg["T_ţ����Ϯ3��"])
    result[4] = Player.getJsonTableByVar(actor, VarCfg["T_ţ����Ϯ4��"])
    result[5] = Player.getJsonTableByVar(actor, VarCfg["T_ţ����Ϯ5��"])
    result[6] = Player.getJsonTableByVar(actor, VarCfg["T_ţ����Ϯ6��"])
    result[7] = Player.getJsonTableByVar(actor, VarCfg["T_ţ����Ϯ7��"])
    QiRiNiXiCahce[actor] = result
    -- dump(result)
    return result
end

--��������
local Level_Tbl = {[100]={Day=1,Num="1"},[120]={Day=2,Num="1"},[160]={Day=3,Num="1"},[180]={Day=4,Num="1"},[200]={Day=5,Num="1"},[220]={Day=6,Num="1"},[240]={Day=7,Num="1"}}
local function _onPlayLevelUp(actor, cur_level)
    --release_print("sssssss ")
    local Cahce_Tbl = NiuMaNiXi.GetZhuangBanList(actor)
    if Level_Tbl[cur_level] then
        local Day, Num = Level_Tbl[cur_level].Day, Level_Tbl[cur_level].Num
        if not Cahce_Tbl[Day][Num] then
            Cahce_Tbl[Day][Num] = "����ȡ"
        end
        Player.setJsonVarByTable(actor, VarCfg["T_ţ����Ϯ".. Day .."��"], Cahce_Tbl[Day])
        NiuMaNiXi.SyncResponse(actor)
    end
    --release_print("sssssss ")
end
GameEvent.add(EventCfg.onPlayLevelUp, _onPlayLevelUp, NiuMaNiXi)

--��������װ������
local item_Tbl = {["��ħ����+5"]={Day=1,Num="2"},["�ָ��⻷+5"]={Day=1,Num="3"},["����֮��+5"]={Day=1,Num="4"},["���ػ�+5"]={Day=1,Num="5"},["�����ӡLv.7"]={Day=2,Num="2"},["ɱ¾��ӡLv.7"]={Day=2,Num="3"}}
local function _onTakeOnEx(actor, itemobj, where, itemname, makeid)
    local Cahce_Tbl = NiuMaNiXi.GetZhuangBanList(actor)
    if item_Tbl[itemname] then
        local Day, Num = item_Tbl[itemname].Day, item_Tbl[itemname].Num
        if not Cahce_Tbl[Day][Num] then
            Cahce_Tbl[Day][Num] = "����ȡ"
        end
        Player.setJsonVarByTable(actor, VarCfg["T_ţ����Ϯ".. Day .."��"], Cahce_Tbl[Day])
        NiuMaNiXi.SyncResponse(actor)
    end
end
GameEvent.add(EventCfg.onTakeOnEx, _onTakeOnEx, NiuMaNiXi)

--�ռ�װ��
local Skin_Tbl = {{Skin=4, Day=1,Num="6"}, {Skin=8, Day=3,Num="3"}}
local function _onUPSkin(actor,var)
    local Cahce_Tbl = NiuMaNiXi.GetZhuangBanList(actor)
    if var >= Skin_Tbl[1].Skin then
        local Day, Num = Skin_Tbl[1].Day, Skin_Tbl[1].Num
        if not Cahce_Tbl[Day][Num] then
            Cahce_Tbl[Day][Num] = "����ȡ"
        end
        Player.setJsonVarByTable(actor, VarCfg["T_ţ����Ϯ".. Day .."��"], Cahce_Tbl[Day])
        NiuMaNiXi.SyncResponse(actor)
    end

    if var >= Skin_Tbl[2].Skin then
        local Day, Num = Skin_Tbl[2].Day, Skin_Tbl[2].Num
        if not Cahce_Tbl[Day][Num] then
            Cahce_Tbl[Day][Num] = "����ȡ"
        end
        Player.setJsonVarByTable(actor, VarCfg["T_ţ����Ϯ".. Day .."��"], Cahce_Tbl[Day])
        NiuMaNiXi.SyncResponse(actor)
    end
end
GameEvent.add(EventCfg.onUPSkin, _onUPSkin, NiuMaNiXi)

--�����л�󴥷�
local function _onGuildAddMemberAfter(actor, guild, name)
    local Day, Num = 2, "4"
    local Cahce_Tbl = NiuMaNiXi.GetZhuangBanList(actor)
    if not Cahce_Tbl[Day][Num] then
        Cahce_Tbl[Day][Num] = "����ȡ"
        Player.setJsonVarByTable(actor, VarCfg["T_ţ����Ϯ".. Day .."��"], Cahce_Tbl[Day])
        NiuMaNiXi.SyncResponse(actor)
    end
end
GameEvent.add(EventCfg.onGuildAddMemberAfter, _onGuildAddMemberAfter, NiuMaNiXi)

--�����񱩴���
local function _OpenKuangBao(actor)
    local Day, Num = 2, "5"
    local Cahce_Tbl = NiuMaNiXi.GetZhuangBanList(actor)
    if not Cahce_Tbl[Day][Num] then
        Cahce_Tbl[Day][Num] = "����ȡ"
        Player.setJsonVarByTable(actor, VarCfg["T_ţ����Ϯ".. Day .."��"], Cahce_Tbl[Day])
        NiuMaNiXi.SyncResponse(actor)
    end
end
GameEvent.add(EventCfg.OpenKuangBao,_OpenKuangBao, NiuMaNiXi)

--��ħ��ɴ���
local function _onTiZhiXiuLianUP(actor)
    local Day, Num = 3, "2"
    local Cahce_Tbl = NiuMaNiXi.GetZhuangBanList(actor)
    if not Cahce_Tbl[Day][Num] then
        Cahce_Tbl[Day][Num] = "����ȡ"
        Player.setJsonVarByTable(actor, VarCfg["T_ţ����Ϯ".. Day .."��"], Cahce_Tbl[Day])
        NiuMaNiXi.SyncResponse(actor)
    end
end
GameEvent.add(EventCfg.onTiZhiXiuLianUP, _onTiZhiXiuLianUP, NiuMaNiXi)

--���ɾ���ﵽ���������
local XiuXianTbl = {["���������"]={Day=3,Num="4"},["�߱�������"]={Day=4,Num="4"},["Ǭ��������"]={Day=5,Num="4"},["�Ź�������"]={Day=6,Num="4"},["ʮ�����ӡ"]={Day=7,Num="4"}}
local function _onXiuXianUP(actor,itemname)
    local Cahce_Tbl = NiuMaNiXi.GetZhuangBanList(actor)
    if XiuXianTbl[itemname] then
        local Day, Num = XiuXianTbl[itemname].Day, XiuXianTbl[itemname].Num
        if not Cahce_Tbl[Day][Num] then
            Cahce_Tbl[Day][Num] = "����ȡ"
        end
        Player.setJsonVarByTable(actor, VarCfg["T_ţ����Ϯ".. Day .."��"], Cahce_Tbl[Day])
        NiuMaNiXi.SyncResponse(actor)
    end
end
GameEvent.add(EventCfg.onXiuXianUP, _onXiuXianUP, NiuMaNiXi)

--ϴ������
local XiLianTbl = {[2]={Day=3,Num="5"},[3]={Day=5,Num="5"}}
local function _onZhuangBeiXiLian(actor,setLevel)
    local Cahce_Tbl = NiuMaNiXi.GetZhuangBanList(actor)
    if XiLianTbl[setLevel] then
        local Day, Num = XiLianTbl[setLevel].Day, XiLianTbl[setLevel].Num
        if not Cahce_Tbl[Day][Num] then
            Cahce_Tbl[Day][Num] = "����ȡ"
        end
        Player.setJsonVarByTable(actor, VarCfg["T_ţ����Ϯ".. Day .."��"], Cahce_Tbl[Day])
        NiuMaNiXi.SyncResponse(actor)
    end
end
GameEvent.add(EventCfg.onZhuangBeiXiLian, _onZhuangBeiXiLian, NiuMaNiXi)

--����ǿ������
local function _onIntensifySkill(actor, skillname, skillleve)
    if skillname ~= "��ɱ����" then  return end
    if skillleve ~= 5 then  return end
    local Day, Num = 4, "3"
    local Cahce_Tbl = NiuMaNiXi.GetZhuangBanList(actor)
    if not Cahce_Tbl[Day][Num] then
        Cahce_Tbl[Day][Num] = "����ȡ"
        Player.setJsonVarByTable(actor, VarCfg["T_ţ����Ϯ".. Day .."��"], Cahce_Tbl[Day])
        NiuMaNiXi.SyncResponse(actor)
    end
end
GameEvent.add(EventCfg.onIntensifySkill,_onIntensifySkill, NiuMaNiXi)

--���ϴ������
local function _onKuangFengXiLian(actor,count)
    if count < 300000 then  return end
    local Day, Num = 4, "2"
    local Cahce_Tbl = NiuMaNiXi.GetZhuangBanList(actor)
    if not Cahce_Tbl[Day][Num] then
        Cahce_Tbl[Day][Num] = "����ȡ"
        Player.setJsonVarByTable(actor, VarCfg["T_ţ����Ϯ".. Day .."��"], Cahce_Tbl[Day])
        NiuMaNiXi.SyncResponse(actor)
    end
end
GameEvent.add(EventCfg.onKuangFengXiLian,_onKuangFengXiLian, NiuMaNiXi)

--���������ƺŴ���
local function _onJiangHuTitleUP(actor,title)

    if title ~= "�糾����" then  return end
    local Day, Num = 4, "5"
    local Cahce_Tbl = NiuMaNiXi.GetZhuangBanList(actor)
    if not Cahce_Tbl[Day][Num] then
        Cahce_Tbl[Day][Num] = "����ȡ"
        Player.setJsonVarByTable(actor, VarCfg["T_ţ����Ϯ".. Day .."��"], Cahce_Tbl[Day])
        NiuMaNiXi.SyncResponse(actor)
    end
end
GameEvent.add(EventCfg.onJiangHuTitleUP, _onJiangHuTitleUP, NiuMaNiXi)

--ת������
local function _onRenewlevelUP(actor, renewlevel)
    if renewlevel ~= 1 then return end
    local Day, Num = 5, "2"
    local Cahce_Tbl = NiuMaNiXi.GetZhuangBanList(actor)
    if not Cahce_Tbl[Day][Num] then
        Cahce_Tbl[Day][Num] = "����ȡ"
        Player.setJsonVarByTable(actor, VarCfg["T_ţ����Ϯ".. Day .."��"], Cahce_Tbl[Day])
        NiuMaNiXi.SyncResponse(actor)
    end
end
GameEvent.add(EventCfg.onRenewlevelUP, _onRenewlevelUP, NiuMaNiXi)

--���״�������
local function _onJianJiaCuLian(actor, Num)
    if Num ~= 5 then return end
    local Day, Num = 5, "3"
    local Cahce_Tbl = NiuMaNiXi.GetZhuangBanList(actor)
    if not Cahce_Tbl[Day][Num] then
        Cahce_Tbl[Day][Num] = "����ȡ"
        Player.setJsonVarByTable(actor, VarCfg["T_ţ����Ϯ".. Day .."��"], Cahce_Tbl[Day])
        NiuMaNiXi.SyncResponse(actor)
    end
end
GameEvent.add(EventCfg.onJianJiaCuLian, _onJianJiaCuLian, NiuMaNiXi)

--ǿ��װ������
local function _onZhuangBeiQiangHua(actor, level)
    if level ~= 4 then return end
    local Day, Num = 6, "2"
    local Cahce_Tbl = NiuMaNiXi.GetZhuangBanList(actor)
    if not Cahce_Tbl[Day][Num] then
        Cahce_Tbl[Day][Num] = "����ȡ"
        Player.setJsonVarByTable(actor, VarCfg["T_ţ����Ϯ".. Day .."��"], Cahce_Tbl[Day])
        NiuMaNiXi.SyncResponse(actor)
    end
end
GameEvent.add(EventCfg.onZhuangBeiQiangHua, _onZhuangBeiQiangHua, NiuMaNiXi)

--���׿��ⴥ��
local function _onJianJiaKaiGuan(actor, U_Num)
    if U_Num ~= 5 then return end
    local Day, Num = 6, "3"
    local Cahce_Tbl = NiuMaNiXi.GetZhuangBanList(actor)
    if not Cahce_Tbl[Day][Num] then
        Cahce_Tbl[Day][Num] = "����ȡ"
        Player.setJsonVarByTable(actor, VarCfg["T_ţ����Ϯ".. Day .."��"], Cahce_Tbl[Day])
        NiuMaNiXi.SyncResponse(actor)
    end
end
GameEvent.add(EventCfg.onJianJiaKaiGuan, _onJianJiaKaiGuan, NiuMaNiXi)

--������������
local function _onXingYunXiangLian(actor, xingYunCount)
    -- release_print("������������",xingYunCount)
    if xingYunCount < 4 then return end
    local Day, Num = 6, "5"
    local Cahce_Tbl = NiuMaNiXi.GetZhuangBanList(actor)
    if not Cahce_Tbl[Day][Num] then
        Cahce_Tbl[Day][Num] = "����ȡ"
        Player.setJsonVarByTable(actor, VarCfg["T_ţ����Ϯ".. Day .."��"], Cahce_Tbl[Day])
        NiuMaNiXi.SyncResponse(actor)
    end
end
GameEvent.add(EventCfg.onXingYunXiangLian, _onXingYunXiangLian, NiuMaNiXi)

--�������֮�Ÿ���
local function _onJinRuJiJiZhiMen(actor)
    local Day, Num = 7, "2"
    local Cahce_Tbl = NiuMaNiXi.GetZhuangBanList(actor)
    if not Cahce_Tbl[Day][Num] then
        Cahce_Tbl[Day][Num] = "����ȡ"
        Player.setJsonVarByTable(actor, VarCfg["T_ţ����Ϯ".. Day .."��"], Cahce_Tbl[Day])
        NiuMaNiXi.SyncResponse(actor)
    end
end
GameEvent.add(EventCfg.onJinRuJiJiZhiMen, _onJinRuJiJiZhiMen, NiuMaNiXi)

--��������Ǳ�ܴ���
local function _onOpenJiXianQianNeng(actor, qnnum)
    if qnnum ~= 3 then return end
    local Day, Num = 7, "3"
    local Cahce_Tbl = NiuMaNiXi.GetZhuangBanList(actor)
    if not Cahce_Tbl[Day][Num] then
        Cahce_Tbl[Day][Num] = "����ȡ"
        Player.setJsonVarByTable(actor, VarCfg["T_ţ����Ϯ".. Day .."��"], Cahce_Tbl[Day])
        NiuMaNiXi.SyncResponse(actor)
    end
end
GameEvent.add(EventCfg.onOpenJiXianQianNeng, _onOpenJiXianQianNeng, NiuMaNiXi)

--��������Ǳ�ܴ���
local function _onLongShenZhiLiUP(actor,currLevel)
    if currLevel ~= 3 then return end
    local Day, Num = 7, "5"
    local Cahce_Tbl = NiuMaNiXi.GetZhuangBanList(actor)
    if not Cahce_Tbl[Day][Num] then
        Cahce_Tbl[Day][Num] = "����ȡ"
        Player.setJsonVarByTable(actor, VarCfg["T_ţ����Ϯ".. Day .."��"], Cahce_Tbl[Day])
        NiuMaNiXi.SyncResponse(actor)
    end
end
GameEvent.add(EventCfg.onLongShenZhiLiUP, _onLongShenZhiLiUP, NiuMaNiXi)


--��¼���� ����ţ�����ҷ�
local DingDing_Title =  {
    {title="ţ��ʵϰ��",LL=10000,UL=50000},
    {title="ţ����Ա��",LL=50000,UL=100000},
    {title="ţ��С�鳤",LL=100000,UL=200000},
    {title="ţ���ܾ���",LL=200000,UL=500000},
    {title="ţ��ɶ�",LL=500000,UL=1000000},
    {title="ţ���³�",LL=1000000,UL=2000000}  }

local function _onLogin(actor)
    local state = getplaydef (actor,VarCfg["Z_������״̬"])
    if state == "����ȡ" then return end
    if state == "" then
        for _, v in ipairs(DingDing_Title) do
            if checktitle(actor, v.title) then
                local Num = math.random(v.LL, v.UL)
                setplaydef (actor,VarCfg["Z_������״̬"], Num)
                break
            end
        end
        addbuff(actor, 31050, 30)
        return
    end

    if tonumber(state) > 10000 then
        addbuff(actor, 31050, 30)
        return
    end
end
GameEvent.add(EventCfg.onLogin, _onLogin, NiuMaNiXi)
--���� buff �仯
local function _onBuffChange(actor, buffid, groupid, model)
    if checkkuafu(actor) then return end
    if model ~= 4 then return end
    if buffid == 31050 then
        local DingDing_Title =  {"ţ��ʵϰ��","ţ����Ա��","ţ��С�鳤","ţ���ܾ���","ţ��ɶ�","ţ���³�"}
        local Name = getbaseinfo(actor, ConstCfg.gbase.name)
        local Number = getplaydef (actor,VarCfg["Z_������״̬"])
        local TitleName = 0
        for k, v in ipairs(DingDing_Title) do
            if checktitle(actor, v) then
                TitleName = k
                break
            end
        end
    if TitleName == 0 then return end
    local ImageNum = math.random(1, 2)
    say(actor,
          [[<Img|x=0.0|y=-1.0|reset=1|esc=1|img=custom/DingDingDaKa/bg.png|show=4|loadDelay=1|move=0|bg=1>
            <Layout|x=648.0|y=22.0|width=80|height=81|link=@exit>
            <Button|x=662.0|y=41.0|nimg=custom/DingDingDaKa/close.png|link=@exit>
            <Img|x=122.0|y=9.0|img=custom/DingDingDaKa/nm]].. ImageNum ..[[.png>
            <Text|x=175.0|y=263.0|width=150|height=40|size=16|color=0|text=]].. Name ..[[>
            <Text|x=173.0|y=302.0|size=16|color=0|text=ţ������̫��>
            <Text|ax=0|ay=0.5|x=513.0|y=258.0|width=200|height=21|size=18|color=0|text=]].. Number ..[[���>
            <Img|x=142.0|y=162.0|width=128|height=85|img=custom/DingDingDaKa/title_]].. TitleName ..[[.png|esc=0>
            <Button|x=411.0|y=286.0|width=192|height=70|nimg=custom/DingDingDaKa/lq.png|link=@lingqudingdingdakajiangli>]])
    end
end
GameEvent.add(EventCfg.onBuffChange, _onBuffChange, NiuMaNiXi)

function lingqudingdingdakajiangli(actor)
    local state = getplaydef (actor,VarCfg["Z_������״̬"])
    if state == "����ȡ" then
        Player.sendmsgEx(actor, "��ʾ#251|:#255|���յ����ҷ��Ѿ���ȡ,��鿴�ʼ�...")
        return
    end
    if state == "" then return end
    if tonumber(state) > 10000 then
        local UserId = getconst(actor, "<$USERID>")
        sendmail(UserId, 20000, "������", "��ϲ��,����ա�ţ���š����ŵ����ҷ�[���]x".. state .."ö","�󶨽��#".. state .."")
        setplaydef(actor, VarCfg["Z_������״̬"], "����ȡ")
        Player.sendmsgEx(actor, "��ʾ#251|:#255|��ϲ��,��ȡ�������ҷ�|���x".. state .."#249|,ף����Ϸ���...")
    end
end

--ע��������Ϣ
function NiuMaNiXi.SyncResponse(actor, logindatas)
    local data = NiuMaNiXi.GetZhuangBanList(actor)
    local _login_data = { ssrNetMsgCfg.NiuMaNiXi_SyncResponse, getsysvar(VarCfg["G_��������"]), 0, 0, data }
    if logindatas then
        table.insert(logindatas, _login_data)
    else
        Message.sendmsg(actor, ssrNetMsgCfg.NiuMaNiXi_SyncResponse, getsysvar(VarCfg["G_��������"]), 0, 0, data)
    end
end

Message.RegisterNetMsg(ssrNetMsgCfg.NiuMaNiXi, NiuMaNiXi)
--����С�˴���--������
local function _onExitGame(actor)
    if NiuMaNiXi[actor] then
        NiuMaNiXi[actor] = nil
    end
end
GameEvent.add(EventCfg.onExitGame, _onExitGame, NiuMaNiXi)

--��¼����
local function _onLoginEnd(actor, logindatas)
    NiuMaNiXi.SyncResponse(actor, logindatas)
end

GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, NiuMaNiXi)

return NiuMaNiXi
