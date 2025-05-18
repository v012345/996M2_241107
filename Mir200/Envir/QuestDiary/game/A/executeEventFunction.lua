local executeEventFunction = {}

executeEventFunction[1] = function(param)
    GameEvent.push(EventCfg.goTXTiming)  --天选之人开始计时
end

executeEventFunction[14] = function(param)
    GameEvent.push(EventCfg.onFXQPSendTongZhi)  --发送福星棋盘活动开始通知
end

executeEventFunction[15] = function(param)
    GameEvent.push(EventCfg.onFXQPStart)        --福星棋盘开始活动
end

executeEventFunction[20] = function(param)
    GameEvent.push(EventCfg.onFXQPResreshBoss)  --福星活动刷新BOSS
end

executeEventFunction[35] = function(param)
    GameEvent.push(EventCfg.onFXQPEnd)          --福星棋盘活动结束
end

executeEventFunction[25] = function(param)
    GameEvent.push(EventCfg.goTXSendTongZhi, 1) --发送天选之人第一轮通知
end

executeEventFunction[30] = function(param)
    GameEvent.push(EventCfg.goTXreward, 1)      --发送天选之人第一轮奖励
end

executeEventFunction[44] = function(param)
    GameEvent.push(EventCfg.onQMHSSendTongZhi)      --发送天选之人第一轮奖励
end

executeEventFunction[45] = function(param)
    GameEvent.push(EventCfg.onQMHSStart)            --全民划水开始
end


executeEventFunction[55] = function(param)
    GameEvent.push(EventCfg.goTXSendTongZhi)      --发送天选之人第二轮通知
    GameEvent.push(EventCfg.onQMHSEnd)            --全民划水结束
end

executeEventFunction[60] = function(param)
    GameEvent.push(EventCfg.goTXreward, 2)      --发送天选之人第二轮奖励
end

executeEventFunction[74] = function(param)
    GameEvent.push(EventCfg.onJQPDTongZhi)      --激情泡点通知
end

executeEventFunction[75] = function(param)
    GameEvent.push(EventCfg.onJQPDStart)      --激情泡点开始
end

executeEventFunction[85] = function(param)
    GameEvent.push(EventCfg.onJQPDEnd)      --激情泡点结束
    GameEvent.push(EventCfg.goTXSendTongZhi, 3) --发送天选之人第三轮通知
end

executeEventFunction[90] = function(param)
    GameEvent.push(EventCfg.goTXreward, 3)      --发送天选之人第三轮奖励
end

executeEventFunction[104] = function(param)
    GameEvent.push(EventCfg.onMYZWTongZhi)  --摸鱼之王通知
end

executeEventFunction[105] = function(param)
    GameEvent.push(EventCfg.onMYZWStart)  --摸鱼之王开始
end

executeEventFunction[115] = function(param)
    GameEvent.push(EventCfg.onMYZWEnd)  --摸鱼之王结束
    GameEvent.push(EventCfg.goTXSendTongZhi, 4) --发送天选之人第四轮通知
end

executeEventFunction[120] = function(param)
    GameEvent.push(EventCfg.goTXreward, 4)      --发送天选之人第四轮奖励
end

executeEventFunction[134] = function(param)
    GameEvent.push(EventCfg.onFXQPSendTongZhi)  --发送福星棋盘活动开始通知
end

executeEventFunction[135] = function(param)
    GameEvent.push(EventCfg.onFXQPStart)        --福星棋盘开始活动
end

executeEventFunction[140] = function(param)
    GameEvent.push(EventCfg.onFXQPResreshBoss)  --福星活动刷新BOSS
end

executeEventFunction[155] = function(param)
    GameEvent.push(EventCfg.onFXQPEnd)          --福星棋盘活动结束
end

return executeEventFunction