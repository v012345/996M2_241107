function main(actor)
    local mapId = getbaseinfo(actor, 3)
    local myName = getbaseinfo(actor, 1)
    if mapId ~= myName.."最终试炼" then
        return
    end
    local newMapId = myName .. "地藏王的秘密世界"
    addmirrormap("02355", newMapId, "地藏王的秘密世界", 1800, "酆都", 010030, 200, 206)
    mapmove(actor, newMapId, 25, 29, 0)
    genmon(newMapId, 27, 29, "地藏王度化的恶念", 20, 40, 249)
end
