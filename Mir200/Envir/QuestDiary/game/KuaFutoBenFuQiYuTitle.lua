local KuaFutoBenFuQiYuTitle = {}

--ËÀÍöµô×°±¸Ç°´¥·¢
KuaFutoBenFuQiYuTitle["onCheckDropUseItems"] = function(actor, arg1)
    GameEvent.push(EventCfg.onCheckDropUseItems, actor, arg1)
end
--ÆæÓö³ÆºÅËÀÍö´¥·¢
KuaFutoBenFuQiYuTitle["onPlaydieQiYu"] = function(actor, arg1)
    GameEvent.push(EventCfg.onPlaydieQiYu, actor)
end

--ÆæÓö³ÆºÅ»÷É±´¥·¢
KuaFutoBenFuQiYuTitle["onkillplayQiYu"] = function(actor, arg1)
    GameEvent.push(EventCfg.onkillplayQiYu, actor)
end

return KuaFutoBenFuQiYuTitle