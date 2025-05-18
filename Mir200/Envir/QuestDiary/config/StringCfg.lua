local StringCfg = {}
local stringTable = {
[1] = "天选之人",
[2] = "天选之人已经生效，避免装备：[%s]掉落。",
[3] = "超神飞升",
[4] = "飞升%s级，避免装备：[%s]掉落。"
}
function StringCfg.get(code, ...)
    return string.format(stringTable[code], ...)
end

return StringCfg