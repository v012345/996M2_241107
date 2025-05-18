local WuXuKongJian = {}
WuXuKongJian.ID = "����ռ�"
local npcID = 829
local config = include("QuestDiary/cfgcsv/cfg_WuXuKongJian.lua") --����
--��������
function WuXuKongJian.Request(actor)
    local data = Player.getJsonTableByVar(actor, VarCfg["T_���ȿռ�"])
    local condition1 = data["bai"] or 0
    local condition2 = data["hui"] or 0
    if condition1 < 300 then
        Player.sendmsgEx(actor, "�����ͼʧ��,������°���BOSS��ɱ����300!#249")
        return
    end
    if condition2 < 50 then
        Player.sendmsgEx(actor, "�����ͼʧ��,������»���������ɱ����50!#249")
        return
    end
    map(actor, "����ռ�")
end

function WuXuKongJian.OpenUI(actor)
    local data = Player.getJsonTableByVar(actor, VarCfg["T_���ȿռ�"])
    Message.sendmsg(actor, ssrNetMsgCfg.WuXuKongJian_OpenUI, 0, 0, 0, data)
end

--ͬ����Ϣ
-- function WuXuKongJian.SyncResponse(actor, logindatas)
--     local data = {}
--     local _login_data = {ssrNetMsgCfg.WuXuKongJian_SyncResponse, 0, 0, 0, data}
--     if logindatas then
--         table.insert(logindatas, _login_data)
--     else
--         Message.sendmsg(actor, ssrNetMsgCfg.WuXuKongJian_SyncResponse, 0, 0, 0, data)
--     end
-- end
-- --��¼����
-- local function _onLoginEnd(actor, logindatas)
--     WuXuKongJian.SyncResponse(actor, logindatas)
-- end
-- --�¼��ɷ�
-- GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, WuXuKongJian)
--ɱ�ִ���
local function _onKillMon(actor, monobj, monName)
    local cfg = config[monName]
    if cfg then
        local data = Player.getJsonTableByVar(actor, VarCfg["T_���ȿռ�"])
        -- ������
        if cfg.value == 1 then
            if (data["bai"] or 0) >= 300 then
                return
            end
            if not data["bai"] then
                data["bai"] = 1
            else
                data["bai"] = data["bai"] + 1
            end
        else -- ������
            if (data["hui"] or 0) >= 50 then
                return
            end
            if not data["hui"] then
                data["hui"] = 1
            else
                data["hui"] = data["hui"] + 1
            end
        end
        Player.setJsonVarByTable(actor, VarCfg["T_���ȿռ�"], data)
    end
end
GameEvent.add(EventCfg.onKillMon, _onKillMon, WuXuKongJian)
--ע��������Ϣ
Message.RegisterNetMsg(ssrNetMsgCfg.WuXuKongJian, WuXuKongJian)
return WuXuKongJian
