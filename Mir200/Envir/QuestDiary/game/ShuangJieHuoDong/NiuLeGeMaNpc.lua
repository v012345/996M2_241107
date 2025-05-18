local NiuLeGeMaNpc = {}
NiuLeGeMaNpc.ID = "ţ�˸���NPC"
local npcID = 156
local config = include("QuestDiary/cfgcsv/cfg_NiuLeGeMaNpc.lua") --����
local cost = {{}}
local give = {{}}
--��������
function NiuLeGeMaNpc.Request(actor)
    --local name, num = Player.checkItemNumByTable(actor, cost)
    --if name then
        --Player.sendmsgEx(actor, string.format("���|%s#249|����|%d#249", name, num))
        --return
    --end
end
--ͬ����Ϣ
function NiuLeGeMaNpc.SyncResponse(actor, logindatas)
    local ranks = Player.getJsonTableByVar(nil, VarCfg["A_ţ�˸������а�"])
    Message.sendmsg(actor, ssrNetMsgCfg.NiuLeGeMaNpc_SyncResponse, 0, 0, 0, ranks)
end
-- --��¼����
-- local function _onLoginEnd(actor, logindatas)
--     NiuLeGeMaNpc.SyncResponse(actor, logindatas)
-- end
-- --�¼��ɷ�
-- GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, NiuLeGeMaNpc)
local function _onBeforedawn(openday)
    local ranks = Player.getJsonTableByVar(nil, VarCfg["A_ţ�˸������а�"])
    local ranksSort = {}
    for k, v in pairs(ranks) do
        table.insert(ranksSort, { name = k, time = v })
    end
    table.sort(ranksSort, function(a, b)
        return a.time < b.time
    end)
    --ȡǰ����
    local top3 = {}
    for i = 1, 3 do
        if ranksSort[i] then
            top3[i] = ranksSort[i]
        end
    end
    --��ǰ��������
    for i, v in ipairs(top3) do
        local rankChinese = formatNumberToChinese(i)
        local mailTitle = string.format("ţ�˸����%s������", rankChinese)
        local mailContent = string.format("��ϲ����ţ�˸����%s��������ȡ���Ľ�����", rankChinese)
        local t = config[i].give
        local isbind = true
        local mailRewards = {}
        for _, item in ipairs(t) do
            local items = {}
            if item[3] or isbind then
                items = { item[1], item[2] * 1, ConstCfg.binding }
            else
                items = { item[1], item[2] * 1 }
            end
            table.insert(mailRewards, table.concat(items, "#"))
        end
        local mailRewardStr = table.concat(mailRewards, "&")
        sendmail("#"..v.name, 1, mailTitle, mailContent, mailRewardStr)
    end
    Player.setJsonVarByTable(nil, VarCfg["A_ţ�˸������а�"], {})
end
GameEvent.add(EventCfg.roBeforedawn, _onBeforedawn, NiuLeGeMaNpc)
--ע��������Ϣ
Message.RegisterNetMsg(ssrNetMsgCfg.NiuLeGeMaNpc, NiuLeGeMaNpc)
return NiuLeGeMaNpc