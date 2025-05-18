MapNpc = {}
local cfg = {}
--��������
for _, v in pairs(cfg_map_npc_mov) do
    cfg[v.mapId] = {position = v.position or nil,
                    type = v.type or nil,
                    level = v.level or nil,
                    reLevel = v.reLevel or nil,
                    money = v.money or nil,
                    flag = v.flag or nil,
                    var = v.var or nil,
                    title = v.title or nil,
                    equip = v.equip or nil,
                    baby = v.baby or nil
                    }
end

--�жϵȼ�
function MapNpc.level(actor, condition, conditionData)
    local boole = false
    local conditionDesc = conditionData[condition] or 0
    if conditionDesc == 0 then return true end
    local myLevel = getbaseinfo(actor,ConstCfg.gbase.level)
    if myLevel >= conditionDesc then
        boole = true
    else
        Player.sendmsgEx(actor, string.format("���ȼ�����%d��,�޷�����!#249", conditionDesc))
        boole = false
    end
    return boole
end

--�ж�ת��
function MapNpc.reLevel(actor, condition, conditionData)
    local boole = false
    local conditionDesc = conditionData[condition] or 0
    if conditionDesc == 0 then return true end
    local myLevel = getbaseinfo(actor,ConstCfg.gbase.renew_level)
    if myLevel >= conditionDesc then
        boole = true
    else
        Player.sendmsg(actor, "����ת���ȼ�����"..conditionDesc)
        boole = false
    end
    return boole
end

--�жϻ���
function MapNpc.money(actor, condition, conditionData)
    local boole = false
    local conditionDesc = conditionData[condition] or 0
    if conditionDesc == 0 then return true end
    local name, num = Player.checkItemNumByTable(actor, conditionDesc)
    if name then
        Player.sendmsg(actor, "�����ͼʧ�ܣ�����["..name.."]����"..num)
        boole = false
    else
        Player.takeItemByTable(actor,conditionDesc,"�����ͼ")
        boole = true
    end
    return boole
end

--�жϱ�ʶ
function MapNpc.flag(actor, condition, conditionData)
    local boole = false
    local conditionDesc = conditionData[condition] or 0
    if conditionDesc == 0 then return true end
    if type(conditionDesc) ~= "table" then
        Player.sendmsg(actor, "�����ͼʧ�ܣ���ϲ�㷢����һ��BUG������ϵ�ͷ���ȡ����^_^")
        return false
    end
    boole = true
    for _,v in ipairs(conditionDesc) do
        if getflagstatus(actor,v[1]) ~= v[2] then
            Player.sendmsg(actor, v[3])
            boole = false
            break
        end
    end
    return boole
end

--�жϱ���
function MapNpc.var(actor, condition, conditionData)
    local boole = false
    local conditionDesc = conditionData[condition] or 0
    if conditionDesc == 0 then return true end
    if type(conditionDesc) ~= "table" then
        Player.sendmsg(actor, "�����ͼʧ�ܣ���ϲ�㷢����һ��BUG������ϵ�ͷ���ȡ����^_^")
        return false
    end
    boole = true
    -- release_print(tbl2json(conditionDesc))
    for _,v in ipairs(conditionDesc) do
        if not compareValues(getplaydef(actor,v[1]), v[2], v[3]) then
            Player.sendmsg(actor, v[4])
            boole = false
            break
        end
    end
    return boole
end

--�жϳƺ�
function MapNpc.title(actor, condition, conditionData)
    local boole = false
    local conditionDesc = conditionData[condition] or 0
    if conditionDesc == 0 then return true end
    if type(conditionDesc) ~= "table" then
        Player.sendmsg(actor, "�����ͼʧ�ܣ���ϲ�㷢����һ��BUG������ϵ�ͷ���ȡ����^_^")
        return false
    end
    for index, value in ipairs(conditionDesc[1]) do
        if checktitle(actor, value) then
            return true
        end
    end
    Player.sendmsg(actor, conditionDesc[2])
    return boole
end

--�ж�װ��
function MapNpc.equip(actor, condition, conditionData)
    local boole = false
    local conditionDesc = conditionData[condition] or 0
    if conditionDesc == 0 then return true end
    if type(conditionDesc) ~= "table" then
        Player.sendmsg(actor, "�����ͼʧ�ܣ���ϲ�㷢����һ��BUG������ϵ�ͷ���ȡ����^_^")
        return false
    end
    local tblnum = #conditionDesc
    for i=1,tblnum - 1 do
        local equipWhereOBJ = linkbodyitem(actor,conditionDesc[i][1])
        if equipWhereOBJ == "0" then
            boole = false
        else
            local equipWhereId = getiteminfo(actor, equipWhereOBJ, 2) --���ϵ�װ��ID
            local itemIdx = getstditeminfo(conditionDesc[i][2],ConstCfg.stditeminfo.idx) --������װ��ID
            if equipWhereId >= itemIdx then
                boole = true
                break
            end
        end
    end
    if not boole then
        Player.sendmsg(actor, conditionDesc[tblnum])
    end
    return boole
end

--�жϱ���
function MapNpc.baby(actor, condition, conditionData)
    -- release_print("�жϱ���")
    return true
end

MapNpc.conditionFunc = {
    [1] = MapNpc.level,
    [2] = MapNpc.reLevel,
    [4] = MapNpc.money,
    [8] = MapNpc.flag,
    [16] = MapNpc.var,
    [32] = MapNpc.title,
    [64] = MapNpc.equip,
    [128] = MapNpc.baby,
}

--ִ����������
function MapNpc.executeFunctions(actor, combinedState, conditionData)
    local boole = true
    for i = 1, table.nums(MapNpc.conditionFunc) do
        local state = 2^(i-1)
        if BitAND(combinedState, state) == state then
            if not MapNpc.conditionFunc[state](actor, state, conditionData) then
                boole = false
                --break
            end
        end
    end
    return boole
end

--�µ�ͼ
function MapNpc.mapmove(actor,mapId)
    local mapCfg = cfg[mapId]
    if not mapCfg then
        Player.sendmsg(actor,"��ͼ���ô���")
        return
    end
    --��������
    local conditionData = {
        [1] = mapCfg.level,
        [2] = mapCfg.reLevel,
        [4] = mapCfg.money,
        [8] = mapCfg.flag,
        [16] = mapCfg.var,
        [32] = mapCfg.title,
        [64] = mapCfg.equip,
        [128] = mapCfg.baby,
    }
    local type = mapCfg.type or 0
    if type ~= 0 then
        local boole = MapNpc.executeFunctions(actor, type, conditionData)
        if not boole then
            return
        end
    end
    if mapCfg.position then
        mapmove(actor, mapId,mapCfg.position[1], mapCfg.position[2], mapCfg.position[3])
    else
        map(actor,mapId)
    end
    
    delaygoto(actor, 10, "entermapmsg,1")
    -- MapNpc.enterMapMsg(actor)
end

--����������Ϣ
function MapNpc.Request(actor,arg1)
    arg1 = tonumber(arg1)
    local mapCfg = cfg_map_npc_mov[arg1]
    if not mapCfg then
        return
    end
    MapNpc.mapmove(actor, mapCfg.mapId)
end


Message.RegisterNetMsg(ssrNetMsgCfg.MapNpc, MapNpc)

return MapNpc