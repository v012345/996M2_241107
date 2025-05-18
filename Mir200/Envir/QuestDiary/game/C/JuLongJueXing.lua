JuLongJueXing = {}
local config = include("QuestDiary/cfgcsv/cfg_JuLongJueXing.lua")
local itemdata = { "�����ʯ[δ����]", "�����ʯ[һ�׾���]", "�����ʯ[���׾���]", "�����ʯ[���׾���]", "�����ʯ[�Ľ׾���]", "�����ʯ[��׾���]" }

local indexMap = {
    ["�����ʯ[һ�׾���]"]=1,
    ["�����ʯ[���׾���]"]=2,
    ["�����ʯ[���׾���]"]=3,
    ["�����ʯ[�Ľ׾���]"]=4,
    ["�����ʯ[��׾���]"]=5 
}

--�ж��Ƿ��Ѿ��ﵽ130��
function JuLongJueXing.checklevel(actor)
    local level = getbaseinfo(actor, ConstCfg.gbase.level)
    if level < 130 then
        return true
    else
        return false
    end
end

function JuLongJueXing.ButtonLink1(actor, arg1, arg2, arg3, data)
    if JuLongJueXing.checklevel(actor) then
        Player.sendmsgEx(actor, "��ʾ#251|:#255|��ĵȼ�����|130��#249|��ﵽ�ȼ�������...")
        return
    end
    local data = json2tbl(getplaydef(actor, VarCfg["T_�����ʯ����"]))
    if data["cur"] >= 39888 then
        Player.sendmsgEx(actor, "��ʾ#251|:#255|���|���ɾ���#249|�Ѿ�|�ﵽ��ֵ#249|����ʧ��...")
        return
    end
    if takeitem(actor, "����ˮ��", 5, 0) then
        local num = math.random(10, 15)
        local nownum
        if data["cur"] + num > 39888 then
            nownum = 39888
        else
            nownum = data["cur"] + num 
        end
        local str = {
            ["cur"] = nownum,
            ["max"] = data["max"],
            ["name"] = data["name"]
        }
        setplaydef(actor, VarCfg["T_�����ʯ����"], tbl2json(str))
        FSetTaskRedPoint(actor, VarCfg["F_�����������"], 15)
        JuLongJueXing.SyncResponse(actor) --����������Ϣ
        return
    end
    Player.sendmsgEx(actor, "��ʾ#251|:#255|���|����ˮ��#249|����|5��#249|����ʧ��...")
end

function JuLongJueXing.ButtonLink2(actor, arg1, arg2, arg3, data)
    if JuLongJueXing.checklevel(actor) then
        Player.sendmsgEx(actor, "��ʾ#251|:#255|��ĵȼ�����|130��#249|��ﵽ�ȼ�������...")
        return
    end
    local data = json2tbl(getplaydef(actor, VarCfg["T_�����ʯ����"]))
    if data["cur"] >= 39888 then
        Player.sendmsgEx(actor, "��ʾ#251|:#255|���|���ɾ���#249|�Ѿ�|�ﵽ��ֵ#249|����ʧ��...")
        return
    end
    if getbindmoney(actor, "Ԫ��") >= 40000 then
        consumebindmoney(actor, "Ԫ��", 40000, "�۳�Ԫ��")
        local num = math.random(38, 188)
        local nownum
        if data["cur"] + num > 39888 then
            nownum = 39888
        else
            nownum = data["cur"] + num
        end
        local str = {
            ["cur"] = nownum,
            ["max"] = data["max"],
            ["name"] = data["name"]
        }
        setplaydef(actor, VarCfg["T_�����ʯ����"], tbl2json(str))
        FSetTaskRedPoint(actor, VarCfg["F_�����������"], 15)
        JuLongJueXing.SyncResponse(actor) --����������Ϣ
        return
    end
    Player.sendmsgEx(actor, "��ʾ#251|:#255|���|Ԫ��#249|����|40000ö#249|����ʧ��...")
end

function JuLongJueXing.ButtonLink3(actor, arg1, arg2, arg3, data)
    if JuLongJueXing.checklevel(actor) then
        Player.sendmsgEx(actor, "��ʾ#251|:#255|��ĵȼ�����|130��#249|��ﵽ�ȼ�������...")
        return
    end
    local data = json2tbl(getplaydef(actor, VarCfg["T_�����ʯ����"]))
    if data["cur"] > 39888 then
        Player.sendmsgEx(actor, "��ʾ#251|:#255|���|���ɾ���#249|�Ѿ�|�ﵽ��ֵ#249|����ʧ��...")
        return
    end
    if data["cur"] >= data["max"] then
        local itemobj = linkbodyitem(actor, 89)
        local itemname = getiteminfo(actor, itemobj, 7)
        local _itemname
        local itemexp

        if itemobj == "0" then return end --װ��λ��Ϊ�� ֱ�ӽ���

        for i = 1, #itemdata do
            if itemdata[i] == itemname then
                _itemname = itemdata[i + 1] --��һ��װ������
                break
            end
        end
        -- local takestate = takeitem(actor, "��ʯ", 10, 0)

        -- if not takestate then
        --     Player.sendmsgEx(actor, "��ʾ#251|:#255|���|��ʯ#249|����|20ö#249|����ʧ��...")
        --     return
        -- end

        local cfg = config[_itemname]
        if not cfg then
            Player.sendmsgEx(actor,"��������#249")
            return
        end
        local cost = cfg.cost
        local name, num = Player.checkItemNumByTable(actor, cost)
        if name then
            Player.sendmsgEx(actor, string.format("[��ʾ]:#251|����ʧ��,���|%s#249|����|%d#249", name, num))
            return
        end
        local state1 = getflagstatus(actor,VarCfg["F_������ӡ1"])
        local state2 = getflagstatus(actor,VarCfg["F_������ӡ2"])
        local state3 = getflagstatus(actor,VarCfg["F_������ӡ3"])
        local flagTbl = {state1,state2,state3}
        local state = true
        for _, v in ipairs(flagTbl) do
            if v == 1 then
                state = false
                break
            end
        end

        if state then
            Player.takeItemByTable(actor, cost, "��������")
            giveonitem(actor, 89, _itemname, 1, 0, "������һ��װ��")
        else
            --�����Զ������Ժ�ɾ��װ��
            local itemobj = linkbodyitem(actor, 89)
            clearitemcustomabil(actor, itemobj,0)
            Player.takeItemByTable(actor, cost, "��������")

            --����װ��
            giveonitem(actor, 89, _itemname, 1, 0, "������һ��װ��")
            local itemobj = linkbodyitem(actor, 89)
            local Attrnum = (flagTbl[1] == 1 and 37) or (flagTbl[2] == 1 and 38) or (flagTbl[3] == 1 and 39)
            changecustomitemtext(actor, itemobj, "[������ӡ]", 0)
            changecustomitemtextcolor(actor, itemobj, 253, 0)
            changecustomitemabil(actor,itemobj,0,1,174,0) --��ʵ����
            changecustomitemabil(actor,itemobj,0,2,Attrnum,0) --��ʾ����
            changecustomitemabil(actor,itemobj,0,4,0,0)   --��ʾλ��(0~9)
            changecustomitemvalue(actor,itemobj,0,"=",1,0)
            refreshitem(actor,itemobj)
        end




        -- setflagstatus(actor,VarCfg["F_�����������"],1)
        
        takeitem(actor, itemname, 1, 0)

        if _itemname ~= "�����ʯ[��׾���]" then
            for i = 1, #itemdata do
                if itemdata[i] == _itemname then
                    itemexp = itemdata[i + 1] --��һ��װ������
                    local str = {
                        ["cur"] = data["cur"] - config[_itemname].leveliexp,
                        ["max"] = config[itemexp].leveliexp,
                        ["name"] = _itemname
                    }
                    setplaydef(actor, VarCfg["T_�����ʯ����"], tbl2json(str))
                    JuLongJueXing.SyncResponse(actor) --����������Ϣ
                    break
                end
            end
        end

        if _itemname == "�����ʯ[��׾���]" then
            local str = {
                ["cur"] = 9999999,
                ["max"] = 9999999,
                ["name"] = "�����ʯ[��׾���]"
            }
            setplaydef(actor, VarCfg["T_�����ʯ����"], tbl2json(str))
            JuLongJueXing.SyncResponse(actor) --����������Ϣ
        end
    end
end

--����������Ϣ
function JuLongJueXing.SyncResponse(actor, logindatas)
    local data = json2tbl(getplaydef(actor, VarCfg["T_�����ʯ����"]))
    local max = data["max"]
    local cur = data["cur"]
    local name = data["name"]
    local _data = { cur, max, name }

    local _login_data = { ssrNetMsgCfg.JuLongJueXing_SyncResponse, 0, 0, 0, _data }
    if logindatas then
        table.insert(logindatas, _login_data)
    else
        Message.sendmsg(actor, ssrNetMsgCfg.JuLongJueXing_SyncResponse, 0, 0, 0, _data)
    end
end

--��������
local function _onTakeOn40(actor, itemobj)
    -- local Clienttype = getconst(actor, "<$CLIENTFLAG>")
    -- local itemobj = linkbodyitem(actor, 40)
    -- local itemname = getiteminfo(actor, itemobj, 7)
    -- if itemobj == "0" then return end --װ��λ��Ϊ�� ֱ�ӽ���

    -- if getflagstatus(actor, VarCfg["F_����_����ѧԺ��ʶ"]) == 1 then
    --     local JingYan = 0
    --     for i = 1, #itemdata do
    --         if itemname == itemdata[i] then
    --             JingYan = 8 * (i - 1)
    --             addattlist(actor, "���徭��", "=", "3#203#" .. JingYan .. "", 1)
    --             break
    --         end
    --     end
    -- end

end
GameEvent.add(EventCfg.onTakeOn40, _onTakeOn40, JuLongJueXing)

--�ѵ�����
local function _onTakeOff40(actor, itemobj)
    -- delattlist(actor, "���徭��")
end
GameEvent.add(EventCfg.onTakeOff40, _onTakeOff40, JuLongJueXing)

--��¼����
local function _onLoginEnd(actor, logindatas)
    JuLongJueXing.SyncResponse(actor, logindatas) --ͬ����Ϣ
end
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, JuLongJueXing)

--���Ը���
local function _onCalcAttr(actor,attrs)
    if getflagstatus(actor, VarCfg["F_����_����ѧԺ��ʶ"]) == 1 then
        local itemobj = linkbodyitem(actor, 89)
        if itemobj == "0" then return end --װ��λ��Ϊ�� ֱ�ӽ���
        local itemname = getiteminfo(actor, itemobj, 7)
        local shuxing = {}
        if indexMap[itemname] then
            shuxing[203] = 8 * indexMap[itemname]
            setplaydef(actor,VarCfg["N$����ѧԺ����ӳ�"], 8 * indexMap[itemname])
        end
        calcAtts(attrs,shuxing,"�������Ѿ���ӳ�")
    end
end

--����
GameEvent.add(EventCfg.onCalcAttr, _onCalcAttr, JuLongJueXing)
Message.RegisterNetMsg(ssrNetMsgCfg.JuLongJueXing, JuLongJueXing)
return JuLongJueXing
