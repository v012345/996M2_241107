local ChaoShenQiFeiSheng = {}
local config = include("QuestDiary/cfgcsv/cfg_ChaoShenQiFeiSheng.lua") --����


--��������
function ChaoShenQiFeiSheng.Request(actor,var)
    local itemobj = linkbodyitem(actor, var) --��ȡ��Ʒ����
    if itemobj == "0" then return end  --����Ϊ�� ����
    local itemname = getiteminfo(actor, itemobj, 7) --��ȡ��Ʒ����  
    local  StarNum = getitemaddvalue(actor, itemobj, 2, 3) --��ȡ��������
    if StarNum >= 5 then
        Player.sendmsgEx(actor, "��ʾ#251|:#255|�Բ���,���|".. itemname .."#249|�Ѿ�����|".. StarNum .."��#249|...")
        return
    end
    local cfg = config[itemname]
    -- ���۳�����
    local name, num = Player.checkItemNumByTable(actor, cfg["cost"..StarNum+1])
    if name then
        Player.sendmsgEx(actor, string.format("���|%s#249|����|%d#249|ö,����ʧ��...", name, num))
        return
    end
    Player.takeItemByTable(actor, cfg["cost"..StarNum+1],itemname.."�����۳�")
    setitemaddvalue(actor, itemobj, 2, 3, StarNum+1) --��������
    -- setitemaddvalue(actor, itemobj, 2, 3, 1) --��������
    local AttrCfg = config[StarNum+1]
    clearitemcustomabil(actor,itemobj,-1)
    local tbl = {
                ["abil"] = {
                    {
                        ["i"] = 0,
                        ["t"] = "[����������]",
                        ["c"] = 250,
                        ["v"] = {
                            --ȫ����
                            {0,208,AttrCfg.Attr1,0,78, 1,1},
                            {0,209,AttrCfg.Attr1,0,78, 1,2},
                            {0,210,AttrCfg.Attr1,0,78, 1,3},
                            {0,211,AttrCfg.Attr1,0,78, 1,4},
                            {0,212,AttrCfg.Attr1,0,78, 1,5},
                            {0,213,AttrCfg.Attr1,0,78, 1,6},
                            {0,214,AttrCfg.Attr1,0,78, 1,7},
                            --������
                            {0,210,AttrCfg.Attr2,0,79, 2,8},
                            --Ѫ��ֵ
                            {0,208,AttrCfg.Attr2,0,80, 3,9},

                        },
                    },
                },
            }
    setitemcustomabil(actor,itemobj,tbl2json(tbl))
    refreshitem(actor,itemobj)
    ChaoShenQiFeiSheng.SyncResponse(actor)
    Player.setAttList(actor, "���Ը���")
end

--���Ը��Ӵ���
local StarAttr = {
    [1] = {["��������"] = 5, ["�������"] = 5},
    [2] = {["��������"] = 10, ["�������"] = 8},
    [3] = {["��������"] = 15, ["�������"] = 12},
    [4] = {["��������"] = 30, ["�������"] = 18},
    [5] = {["��������"] = 50, ["�������"] = 25}
}

--����ˢ�´���
local function _onCalcAttr(actor,attrs)
    if getplaydef(actor,VarCfg["U_��¼��½"]) < 7 then return end
    --��ȡ��С�ȼ�
    local NumData = {}
    for i = 71, 76 do
        local itemobj = linkbodyitem(actor, i) --��ȡ��Ʒ����
        local  _StarNum = getitemaddvalue(actor, itemobj, 2, 3) --��ȡ��������
        local StarNum = (_StarNum < 0 and 0) or _StarNum
        table.insert(NumData, StarNum)
    end

    local min = math.min(NumData[1], NumData[2], NumData[3], NumData[4], NumData[5], NumData[6])
    if StarAttr[min] then
        setplaydef(actor,VarCfg["U_������װ�ȼ�"],min)
        local shuxing = {} -- ���Ա�
        shuxing[32] = StarAttr[min]["��������"]
        shuxing[229] = StarAttr[min]["�������"]
        shuxing[230] = StarAttr[min]["�������"]
        calcAtts(attrs,shuxing,"���������װ����")
    end
end
--���Ը��Ӵ���
GameEvent.add(EventCfg.onCalcAttr, _onCalcAttr, ChaoShenQiFeiSheng)

local ItemData = {["һ������"] = true, ["ĺ��"] = true, ["��ɫ������ʥ����"] = true, ["�����ݶ�"] = true, ["������"] = true, ["��Ӱ����"] = true}
--��װ������
local function _onTakeOnEx(actor, itemobj, where, itemname, makeid)
    if getplaydef(actor,VarCfg["U_��¼��½"]) < 7 then return end
    if ItemData[itemname] then
        Player.setAttList(actor, "���Ը���")
    end
end
GameEvent.add(EventCfg.onTakeOnEx, _onTakeOnEx, ChaoShenQiFeiSheng)

--��װ������
local function _onTakeOffEx(actor, itemobj, where, itemname, makeid)
    if getplaydef(actor,VarCfg["U_��¼��½"]) < 7 then return end
    if ItemData[itemname] then
        Player.setAttList(actor, "���Ը���")
    end
end
GameEvent.add(EventCfg.onTakeOffEx, _onTakeOffEx, ChaoShenQiFeiSheng)

--ע��������Ϣ
function ChaoShenQiFeiSheng.SyncResponse(actor, logindatas)
    Message.sendmsg(actor, ssrNetMsgCfg.ChaoShenQiFeiSheng_SyncResponse, 0, 0, 0, nil)
end
Message.RegisterNetMsg(ssrNetMsgCfg.ChaoShenQiFeiSheng, ChaoShenQiFeiSheng)


return ChaoShenQiFeiSheng
