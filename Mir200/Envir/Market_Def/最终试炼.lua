function main(actor)
    local mapId = getbaseinfo(actor, 3)
    local myName = getbaseinfo(actor, 1)
    if mapId ~= myName.."��������" then
        return
    end
    local newMapId = myName .. "�ز�������������"
    addmirrormap("02355", newMapId, "�ز�������������", 1800, "ۺ��", 010030, 200, 206)
    mapmove(actor, newMapId, 25, 29, 0)
    genmon(newMapId, 27, 29, "�ز����Ȼ��Ķ���", 20, 40, 249)
end
