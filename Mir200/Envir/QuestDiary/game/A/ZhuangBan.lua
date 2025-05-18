ZhuangBan = {}
ZhuangBan.ID = "װ��"
local cfg_ZhuangBan = include("QuestDiary/cfgcsv/cfg_ZhuangBan.lua")       --����
local cfg_SetZhuangBan = include("QuestDiary/cfgcsv/cfg_SetZhuangBan.lua") --����
local cost = { {} }
local give = { {} }
local zhuangBanCahce = {}
--������ö���������ڲ��뻺��
local enumVarCfg = {
    [VarCfg["T_ʱװ��¼"]] = 1,
    [VarCfg["T_�㼣��¼"]] = 2,
    [VarCfg["T_�⻷��¼"]] = 3,
}
--�ж����Ƿ��ȡ�����װ�磬��ˢ
function ZhuangBan.IsHaveZhuangBan(actor, index)
    local result = false
    local list = ZhuangBan.GetZhuangBanList(actor)
    for _, value in ipairs(list) do
        result = table.contains(value, index)
        if result then
            break
        end
    end
    return result
end
--��������
function ZhuangBan.Request(actor,index)
    local cfg = cfg_ZhuangBan[index]
    if not cfg then
        Player.sendmsgEx(actor, "û���ҵ�װ��#249")
        return
    end
    if not ZhuangBan.IsHaveZhuangBan(actor, index) then
        Player.sendmsgEx(actor, "��û�����װ��#249")
        return
    end
    ZhuangBan.SetCurrFashion(actor, index)
    Player.sendmsgEx(actor,"�����ɹ�")
    --local name, num = Player.checkItemNumByTable(actor, cost)
    --if name then
    --Player.sendmsgEx(actor, string.format("���|%s#249|����|%d#249", name, num))
    --return
    --end
end
--��ȡ����װ�磬���淽ʽ
function ZhuangBan.GetZhuangBanList(actor)
    if zhuangBanCahce[actor] then
        return zhuangBanCahce[actor]
    end
    local result = {}
    result[1] = Player.getJsonTableByVar(actor, VarCfg["T_ʱװ��¼"])
    result[2] = Player.getJsonTableByVar(actor, VarCfg["T_�㼣��¼"])
    result[3] = Player.getJsonTableByVar(actor, VarCfg["T_�⻷��¼"])
    zhuangBanCahce[actor] = result
    return result
end

function ZhuangBan.GetZhuangBanTotalNum(actor)
    local zhuangBanList = ZhuangBan.GetZhuangBanList(actor)
    local num = 0
    for _, value in ipairs(zhuangBanList) do
        num = num + #value
    end
    return num
end
--ͬ����Ϣ
-- function ZhuangBan.SyncResponse(actor, logindatas)
--     local data = {}
--     local _login_data = {ssrNetMsgCfg.ZhuangBan_SyncResponse, 0, 0, 0, data}
--     if logindatas then
--         table.insert(logindatas, _login_data)
--     else
--         Message.sendmsg(actor, ssrNetMsgCfg.ZhuangBan_SyncResponse, 0, 0, 0, data)
--     end
-- end
-- --��¼����
local function _onLoginEnd(actor, logindatas)
    -- ZhuangBan.SyncResponse(actor, logindatas)
    local shizhuangEff = getplaydef(actor, VarCfg["U_ʱװ��ۼ�¼"])
    if shizhuangEff > 0 then
        setfeature(actor, 0, shizhuangEff, 655350, 0, 0)
        setfeature(actor, 1, 9999, 655350, 0, 0)
    end
    local zujiEff = getplaydef(actor, VarCfg["U_�㼣��ۼ�¼"])
    if zujiEff > 0 then
        setmoveeff(actor, zujiEff, 1)
    end
    local guanghuanEff = getplaydef(actor, VarCfg["U_�⻷��ۼ�¼"])
    if guanghuanEff > 0 then
        seticon(actor, ConstCfg.iconWhere.guangHuan, 1, guanghuanEff, 0, 0, 0, 0, 1)
    end
end
--�¼��ɷ�
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, ZhuangBan)
GameEvent.add(EventCfg.onKFLogin, _onLoginEnd, ZhuangBan)

function ZhuangBan.OpenUI(actor)
    local data = {}
    data.curr = {
        [1] = getplaydef(actor, VarCfg["U_ʱװ��ۼ�¼"]),
        [2] = getplaydef(actor, VarCfg["U_�㼣��ۼ�¼"]),
        [3] = getplaydef(actor, VarCfg["U_�⻷��ۼ�¼"]),
    }
    data.received = ZhuangBan.GetZhuangBanList(actor)
    Message.sendmsg(actor, ssrNetMsgCfg.ZhuangBan_OpenUI, 0, 0, 0, data)

end

--��¼װ���б�����
function ZhuangBan.AddFashionToVar(actor, index, Tvar)
    if not index or not Tvar then
        return
    end
    local list = Player.getJsonTableByVar(actor, Tvar)
    if not table.contains(list, index) then
        table.insert(list, index)
        Player.sendmsgEx(actor, "���һ����װ��,�ɵ�װ�����鿴")
    end

    --���װ���ʱ����µ�����
    local cacheIndex = enumVarCfg[Tvar]
    if zhuangBanCahce[actor] then
        zhuangBanCahce[actor][cacheIndex] = list
    end
    Player.setJsonVarByTable(actor, Tvar, list)
    Player.setAttList(actor,"���Ը���")
    
    --����װ����ȡȫ�����������¼��ɷ�
    local SkinNum = ZhuangBan.GetZhuangBanList(actor)
    local _Num = #SkinNum[1] + #SkinNum[2] + #SkinNum[3]
    GameEvent.push(EventCfg.onUPSkin, actor, _Num)
end

--���õ�ǰװ��
function ZhuangBan.SetCurrFashion(actor, index)
    if not index then
        return
    end
    if type(index) ~= "number" then
        return
    end
    local cfg = cfg_ZhuangBan[index]
    if cfg.type == 1 then --����ʱװ
        FIllusionAppearance(actor, cfg.Shape[1], cfg.sEffect[1])
    elseif cfg.type == 2 then --�����㼣
        FSetMoveEff(actor, cfg.Shape[1])
    elseif cfg.type == 3 then --���ù⻷
        FSetGuangHuan(actor, cfg.Shape[1])
    end
    Player.setAttList(actor,"���Ը���")
end

--��װ������
local function _onTakeOnEx(actor, itemobj, where, itemname, makeid)
    local cfg = cfg_SetZhuangBan[itemname]
    if cfg then
        for _, value in ipairs(cfg.Shape or {}) do
            ZhuangBan.AddFashionToVar(actor, value, cfg.Tvar)
        end
        ZhuangBan.SetCurrFashion(actor, cfg.Shape[1])
    end
end
GameEvent.add(EventCfg.onTakeOnEx, _onTakeOnEx, ZhuangBan)

local function _onTakeOffEx(actor, itemobj, where, itemname, makeid)

end
GameEvent.add(EventCfg.onTakeOffEx, _onTakeOffEx, ZhuangBan)


--��ʾʱװ����
local function _onShowFashion(actor)
    local shizhuangEff = getplaydef(actor, VarCfg["U_ʱװ��ۼ�¼"])
    if shizhuangEff > 0 then
        setfeature(actor, 0, shizhuangEff, 655350, 0, 0)
        setfeature(actor, 1, 9999, 655350, 0, 0)
    end
end
GameEvent.add(EventCfg.onShowFashion, _onShowFashion, ZhuangBan)

--ȡ����ʾʱװ����
local function _onNotShowFashion(actor)
    setfeature(actor, 0, -1, 655350, 0, 0)
    setfeature(actor, 1, -1, 655350, 0, 0)
end
GameEvent.add(EventCfg.onNotShowFashion, _onNotShowFashion, ZhuangBan)

--����С�˴���--������
local function _onExitGame(actor)
    if zhuangBanCahce[actor] then
        zhuangBanCahce[actor] = nil
    end
end
GameEvent.add(EventCfg.onExitGame, _onExitGame, ZhuangBan)

--ע��������Ϣ
Message.RegisterNetMsg(ssrNetMsgCfg.ZhuangBan, ZhuangBan)


--�������ַ���ת��������
local function attrStrToAtts(attrStr)
    local attrs = {}
    for _, value in ipairs(attrStr) do
        local tmpAttr = string.split(value, "#")
        attrs[tonumber(tmpAttr[1])] = tonumber(tmpAttr[2])
    end
    return attrs
end
local function _onCalcAttr(actor,attrs)
    --������װ��
    local zhuangBanIds = ZhuangBan.GetZhuangBanList(actor)
    local shuxing = {} -- ���Ա�
    for _, value in ipairs(zhuangBanIds or {}) do
        for _, v in ipairs(value) do
            local cfg = cfg_ZhuangBan[tonumber(v)]
            if cfg then
                if cfg.attrs then
                    local tmpAttrs = attrStrToAtts(cfg.attrs)
                    attsMerge(tmpAttrs, shuxing)
                end
            end
        end
    end
    calcAtts(attrs,shuxing,"װ������")
end

--���Ը��Ӵ���
GameEvent.add(EventCfg.onCalcAttr, _onCalcAttr, ZhuangBan)

return ZhuangBan
