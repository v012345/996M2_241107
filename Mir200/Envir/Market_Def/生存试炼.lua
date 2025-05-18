function main(actor)
    local myName = getbaseinfo(actor, 1)
    local newMapId = myName .. "生存试炼"
    setplaydef(actor, "U38", 2)
    --同步消息
    sendluamsg(actor, 97000, getplaydef(actor, "U38"), 1)
    delmirrormap(newMapId)
end