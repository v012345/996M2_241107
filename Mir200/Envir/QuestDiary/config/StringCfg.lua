local StringCfg = {}
local stringTable = {
[1] = "��ѡ֮��",
[2] = "��ѡ֮���Ѿ���Ч������װ����[%s]���䡣",
[3] = "�������",
[4] = "����%s��������װ����[%s]���䡣"
}
function StringCfg.get(code, ...)
    return string.format(stringTable[code], ...)
end

return StringCfg