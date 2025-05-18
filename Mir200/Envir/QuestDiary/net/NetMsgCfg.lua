local ssrNetMsgCfg = {}

local cfg_ssrNetMsg = include("QuestDiary/cfgcsv/cfg_ssrNetMsg.lua") --∞Û∂®Õ¯¬Áœ˚œ¢≈‰÷√

for k, v in pairs(cfg_ssrNetMsg) do
    ssrNetMsgCfg[k] = v.value
end

local t = {}
for msgName,msgID in pairs(ssrNetMsgCfg) do
    t[msgName] = msgID
    t[msgID] = msgName
end
ssrNetMsgCfg = t
return ssrNetMsgCfg




















