local ShenHunLianYu = {}
ShenHunLianYu.ID = "�������"
local npcID = 138
local config = include("QuestDiary/cfgcsv/cfg_ShenHunLianYu.lua") --����
local function _onShenHunLianYuKuaFuEnter(actor, mapID)
    local name = getbaseinfo(actor, ConstCfg.gbase.name)
    sendmsg("0", 2, '{"Msg":"[' .. name .. ']����' .. mapID .. '","FColor":251,"BColor":0,"Type":6,"Time":6,"SendName":"ϵͳ��","SendId":"123","X":"-300"}')
    map(actor, mapID)
end
GameEvent.add(EventCfg.onShenHunLianYuKuaFuEnter, _onShenHunLianYuKuaFuEnter, ShenHunLianYu)
--��������
function ShenHunLianYu.Request(actor, index)
    if not checkkuafu(actor) then
        return
    end
    local cfg = config[index]
    if not cfg then
        Player.sendmsgEx(actor, "��������!")
        return
    end
    local isKangBao = getflagstatus(actor, VarCfg.F_is_open_kuangbao) --�Ƿ�����֮��
    if isKangBao == 0 then
        Player.sendmsgEx(actor, "�����ͼʧ��,��û�п�����֮��!#249")
        return
    end
    local myLeve = Player.GetLevel(actor)
    if myLeve < cfg.tiaoJian1 then
        Player.sendmsgEx(actor, string.format("�����ͼʧ��,��ĵȼ�����%d,�޷�����!#249", cfg.tiaoJian1))
        return
    end
    local power = Player.GetPower(actor)
    if cfg.tiaoJian2 then
        if power < cfg.tiaoJian2 then
            Player.sendmsgEx(actor, string.format("�����ͼʧ��,���ս������%d,�޷�����!#249", cfg.tiaoJian2))
            return
        end
    end
    FBenFuToKuaFuEvent(actor, EventCfg.onShenHunLianYuKuaFuEnter, cfg.mapID)
end

local function _getMonData()
    local results = {}
    for _, value in ipairs(config) do
        local result = mapbossinfo(value.mapID, value.mobName, 0, 0)
        local str = result[1]
        local data = {}
        if str then
            local strs = string.split(str, "#")
            data = {
                [1] = tonumber(strs[3]), --ʣ��ˢ��ʱ��
                [2] = strs[6]            --����
            }
        end
        table.insert(results, data)
    end
    return results
end

local function _onShenHunLianYuKuaFu(actor)
    local data = _getMonData()
    Message.sendmsg(actor, ssrNetMsgCfg.ShenHunLianYu_OpenUI, 0, 0, 0, data)
end

GameEvent.add(EventCfg.onShenHunLianYuKuaFu, _onShenHunLianYuKuaFu, ShenHunLianYu)

function ShenHunLianYu.OpenUI(actor)
    FBenFuToKuaFuEvent(actor, EventCfg.onShenHunLianYuKuaFu, "")
end

--ͬ����Ϣ
-- function ShenHunLianYu.SyncResponse(actor, logindatas)
--     local data = {}
--     local _login_data = {ssrNetMsgCfg.ShenHunLianYu_SyncResponse, 0, 0, 0, data}
--     if logindatas then
--         table.insert(logindatas, _login_data)
--     else
--         Message.sendmsg(actor, ssrNetMsgCfg.ShenHunLianYu_SyncResponse, 0, 0, 0, data)
--     end
-- end
-- --��¼����
-- local function _onLoginEnd(actor, logindatas)
--     ShenHunLianYu.SyncResponse(actor, logindatas)
-- end
-- --�¼��ɷ�
-- GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, ShenHunLianYu)
--ע��������Ϣ
Message.RegisterNetMsg(ssrNetMsgCfg.ShenHunLianYu, ShenHunLianYu)
return ShenHunLianYu
