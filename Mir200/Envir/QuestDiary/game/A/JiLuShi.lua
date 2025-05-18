local JiLuShi = {}
local config = include("QuestDiary/cfgcsv/cfg_BuKeJiLuDiTu.lua") --���ɱ���¼��ͼ
--��¼����
function JiLuShi.Record(actor,avr1)
    local tab = {
        name = getbaseinfo(actor,ConstCfg.gbase.map_title),
        map = getbaseinfo(actor,ConstCfg.gbase.mapid),
        x = getbaseinfo(actor,ConstCfg.gbase.x),
        y = getbaseinfo(actor,ConstCfg.gbase.y)
    }
    local myName = getbaseinfo(actor, ConstCfg.gbase.name)
    if string.find(tab.map, myName) then
        Player.sendmsgEx(actor,"������ͼ��ֹ��¼#249")
        return
    end
    if config[tab.map] then
        Player.sendmsgEx(actor, "��ʾ#251|:#255|��ͼ|".. tab.name .."#249|�޷�����¼...")
        return
    end
    Player.setJsonVarByTable(actor, VarCfg["T_��¼ʯ".. avr1 ..""], tab)
    JiLuShi.SyncResponse(actor)
end

--��������
function JiLuShi.Move(actor,avr1)
    local tab = Player.getJsonTableByVar(actor, VarCfg["T_��¼ʯ".. avr1 ..""])
    if tab.map then
        if getbindmoney(actor, "���") >= 1 then
            mapmove(actor, tab.map, tab.x, tab.y, 0)
            Player.takeItemByTable(actor,{{"���",1}},"ʹ�ü�¼ʯ")
            GameEvent.push(EventCfg.onUseJiLuShi,actor)
        else
            Player.sendmsgEx(actor, "��ʾ#251|:#255|���|���#249����|1ö#249|����ʧ��...")
        end
    else
        Player.sendmsgEx(actor, "��ʾ#251|:#255|��δ��¼|��ͼ��Ϣ#249|����ʧ��...")      
    end
    Message.sendmsg(actor, ssrNetMsgCfg.JiLuShi_Move, 0, 0, 0, nil)
end

function JiLuShi.SyncResponse(actor)
    local tab1 = Player.getJsonTableByVar(actor, VarCfg["T_��¼ʯ1"])
    local tab2 = Player.getJsonTableByVar(actor, VarCfg["T_��¼ʯ2"])
    local tab3 = Player.getJsonTableByVar(actor, VarCfg["T_��¼ʯ3"])
    local tab4 = Player.getJsonTableByVar(actor, VarCfg["T_��¼ʯ4"])
    local tab5 = Player.getJsonTableByVar(actor, VarCfg["T_��¼ʯ5"])
    local tab6 = Player.getJsonTableByVar(actor, VarCfg["T_��¼ʯ6"])
    local data = { tab1, tab2, tab3, tab4, tab5, tab6 }
    Message.sendmsg(actor, ssrNetMsgCfg.JiLuShi_SyncResponse, 0, 0, 0, data)
end
--ע��������Ϣ
Message.RegisterNetMsg(ssrNetMsgCfg.JiLuShi, JiLuShi)


return JiLuShi