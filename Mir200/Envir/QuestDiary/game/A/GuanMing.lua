local GuanMing = {}
GuanMing.ID = "����"
local npcID = 117
GuanMing.config = include("QuestDiary/cfgcsv/cfg_GuanMing.lua") --����
local cost = {{}}
local give = {{}}
--��������
function GuanMing.Request(actor)
    local receive = getflagstatus(actor,VarCfg["F_������ȡ"])
    if receive == 1 then
        Player.sendmsgEx(actor, "��ʾ#251|:#255|���Ѿ���ȡ��������!")
        return ""
    end

    if getplaydef(actor,VarCfg["U_��ʵ��ֵ"] ) < GuanMing.config[1].need then
        Player.sendmsgEx(actor, "��ʾ#251|:#255|����ۼƳ�ֵ����"..GuanMing.config[1].need.."Ԫ���޷���ȡ!")
        return ""
    end

    if getbagblank(actor) < 10 then
        Player.sendmsgEx(actor, "��ʾ#251|:#255|����������㹻��λ�ã�����ȡ!")
        return ""
    end

    --if not checktitle(actor,GuanMing.config[1].title) then
    --    confertitle(actor,GuanMing.config[1].title,1)
    --end
    --release_print(tbl2json(GuanMing.config[1].give[2]))
    sendmail("#"..getbaseinfo(actor,1),1,"��������","��ϲ��ù����������ƺ�ֱ��������˴�ֻ����ʱװ",GuanMing.config[1].give[1][1].."#"..GuanMing.config[1].give[1][2].."#307&"..GuanMing.config[1].give[2][1].."#"..GuanMing.config[1].give[2][2].."#307")
    --Player.giveItemByTable(actor, {GuanMing.config[1].give[2]}, "��������", 1, true)
    setflagstatus(actor,VarCfg["F_������ȡ"],1)
    Player.sendmsgEx(actor, "��ʾ#251|:#255|��ȡ�����ɹ�!")
    return ""
end
--ͬ����Ϣ
 function GuanMing.SyncResponse(actor, logindatas)
     local data = {}
     local _login_data = {ssrNetMsgCfg.GuanMing_SyncResponse, 0, 0, 0, data}
     if logindatas then
         table.insert(logindatas, _login_data)
     else
         Message.sendmsg(actor, ssrNetMsgCfg.GuanMing_SyncResponse, 0, 0, 0, data)
     end
 end
--��¼����
local function _onLoginEnd(actor, logindatas)
 GuanMing.SyncResponse(actor, logindatas)
end
-- --�¼��ɷ�
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, GuanMing)
--ע��������Ϣ
Message.RegisterNetMsg(ssrNetMsgCfg.GuanMing, GuanMing)
return GuanMing