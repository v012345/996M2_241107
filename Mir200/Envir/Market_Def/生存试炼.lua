function main(actor)
    local myName = getbaseinfo(actor, 1)
    local newMapId = myName .. "��������"
    setplaydef(actor, "U38", 2)
    --ͬ����Ϣ
    sendluamsg(actor, 97000, getplaydef(actor, "U38"), 1)
    delmirrormap(newMapId)
end