local XinMoLaoRen = {}

local XinMoAttrs = { 225, 275, 325 }
local msgbox = { "̰", "��", "��" }
local rankFonts = { "һ", "��", "��" }
local cost = { { { "�����", 588 } }, { { "����ר��ä��", 2 } }, { { "����ר��ä��", 1 } } }
local costXiuXianZhi = { 4000, 2000, 1000 }
local otherCost = { { "�����", 200 } }
local otherCostXiuXianZhi = 600
--��ħ����
function xin_mo_lao_ren_set_var(actor)
    setplaydef(actor, VarCfg["M_��ħ���˱�ʶ"], 1)
end

--�������ֵ����
local function AddXiuXianZhi(actor, value)
    if not value or type(value) ~= "number" then
        return
    end
    local currFaBaoExp = getplaydef(actor, VarCfg["U_������ǰ����"])
    local currValue = currFaBaoExp + value
    setplaydef(actor, VarCfg["U_������ǰ����"], currValue)
    local itemObj = linkbodyitem(actor, 43)
    if itemObj == "0" then
        return
    end
    local tbl = {
        ["cur"] = currValue,
    }
    setcustomitemprogressbar(actor, itemObj, 0, tbl2json(tbl))
    refreshitem(actor, itemObj)
end

--���ͽ������ʼ�
local function SendRewardToMail(actor, reward)
    local userId = getbaseinfo(actor, ConstCfg.gbase.id)
    Player.giveMailByTable(userId, 1, "��ħ����", "��ϲ����ս������ħ,����ȡ���Ľ���,����ֵ���Զ�����,�ɵ����ɽ���鿴!", reward, 1, 1)
end

--��ȡ��ħ��ս����
function XinMoLaoRen.getXinMoRank(actor)
    local rank = Player.getJsonTableByVar(nil, VarCfg["A_��ħ���������б�"])
    return #rank
end

--������ħ��ս����
function XinMoLaoRen.setXinMoRank(actor)
    local rank_list = Player.getJsonTableByVar(nil, VarCfg["A_��ħ���������б�"])
    if #rank_list < 3 then
        local myName = getbaseinfo(actor, ConstCfg.gbase.name)
        local current_time = os.date("*t")
        local year = current_time.year
        local month = current_time.month
        local day = current_time.day
        local hour = current_time.hour
        local min = current_time.min
        local sec = current_time.sec
        local currTime = string.format("%d-%d-%d\n%s:%s:%s", year, month, day, hour, min, sec)
        local tmpTbl = { myName, currTime }
        table.insert(rank_list, tmpTbl)
        Player.setJsonVarByTable(nil, VarCfg["A_��ħ���������б�"], rank_list)
    end
end

function XinMoLaoRen.Request(actor)
    local XinMoConut = getplaydef(actor, VarCfg["U_��ħ������ս����"]) + 1
    if XinMoConut > 3 then
        Player.sendmsgEx(actor, "���Ѿ������������ħ��ս!")
        return
    end
    --�̳�����
    local attr = XinMoAttrs[XinMoConut]
    local time = 3000
    local myName = getbaseinfo(actor, ConstCfg.gbase.name)
    local oldMapId = getbaseinfo(actor, ConstCfg.gbase.mapid)
    local x = getbaseinfo(actor, ConstCfg.gbase.x)
    local y = getbaseinfo(actor, ConstCfg.gbase.y)
    local newMapId = myName .. "����ħ����"
    delmirrormap(newMapId)
    addmirrormap("05385", newMapId, myName .. "����ħ����", time, oldMapId, 010075, x, y)
    mapmove(actor, newMapId, 44, 51, 0)
    delaygoto(actor, 1000, "xin_mo_lao_ren_set_var")
    Player.cloneSelfToHumanoid(actor, newMapId, 46, 49, myName .. "����ħ", "��ħ", 1, 249, attr)
    sendcentermsg(actor, 250, 0, "[��ħ����]��������ħ�Ѿ�Ǳ������ķ�����,а���������������,������ʼ��ս��ħ�������ע�⡭��", 0, 5)
    sendcentermsg(actor, 250, 0, "[��ħ����]��������ħ�Ѿ�Ǳ������ķ�����,а���������������,������ʼ��ս��ħ�������ע�⡭��", 0, 5)
    sendcentermsg(actor, 250, 0, "[��ħ����]��������ħ�Ѿ�Ǳ������ķ�����,а���������������,������ʼ��ս��ħ�������ע�⡭��", 0, 5)
end

--�����UI
function XinMoLaoRen.openUI(actor, arg1, arg2, arg3, data)
    local XinMoConut = getplaydef(actor, VarCfg["U_��ħ������ս����"])
    local data = {
        currTiaoZhan = XinMoConut,
        rankData = Player.getJsonTableByVar(nil, VarCfg["A_��ħ���������б�"]),
    }
    Message.sendmsg(actor, ssrNetMsgCfg.XinMoLaoRen_openUI, 0, 0, 0, data)
end

--ɱ�ִ���
local function _onKillMon(actor, monobj)
    local flag = getplaydef(actor, VarCfg["M_��ħ���˱�ʶ"])
    if flag == 1 then
        local myName = getbaseinfo(actor, ConstCfg.gbase.name)
        local currMapID = myName .. "����ħ����"
        if not FCheckMap(actor,currMapID) then
            return
        end
        local XinMoConut = getplaydef(actor, VarCfg["U_��ħ������ս����"])
        setplaydef(actor, VarCfg["U_��ħ������ս����"], XinMoConut + 1)
        local msgbox = msgbox[XinMoConut + 1]
        local currMapId = getbaseinfo(actor, ConstCfg.gbase.mapid)
        delmirrormap(currMapId)
        if XinMoConut + 1 >= 3 then
            local rank = XinMoLaoRen.getXinMoRank(actor)
            if rank <= 2 then
                XinMoLaoRen.setXinMoRank(actor)
                local reward = cost[rank + 1]
                local xiuXian = costXiuXianZhi[rank + 1]
                SendRewardToMail(actor, reward)
                AddXiuXianZhi(actor, xiuXian)
                messagebox(actor,
                    string.format("��ϲ�������ħ\"%s\"��ս,���ǵ�%sλ���������ս,�뵽�ʼ���ȡ���Ľ���,����ֵ���Զ�����!", msgbox, rankFonts[rank + 1] or ""))
                addhpper(actor,"=",100)
            else
                messagebox(actor, string.format("��ϲ�������ħ\"%s\"��ս,���Ѿ����������ħ��ս,�뵽�ʼ���ȡ���Ľ���,����ֵ���Զ�����!", msgbox))
                SendRewardToMail(actor, otherCost)
                AddXiuXianZhi(actor, otherCostXiuXianZhi)
                addhpper(actor,"=",100)
            end
        else
            messagebox(actor, string.format("��ϲ�������ħ\"%s\"��ս!", msgbox))
            addhpper(actor,"=",100)
        end
    end
end
GameEvent.add(EventCfg.onKillMon, _onKillMon, XinMoLaoRen)
Message.RegisterNetMsg(ssrNetMsgCfg.XinMoLaoRen, XinMoLaoRen)
return XinMoLaoRen
