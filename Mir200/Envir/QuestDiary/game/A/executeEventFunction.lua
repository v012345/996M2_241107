local executeEventFunction = {}

executeEventFunction[1] = function(param)
    GameEvent.push(EventCfg.goTXTiming)  --��ѡ֮�˿�ʼ��ʱ
end

executeEventFunction[14] = function(param)
    GameEvent.push(EventCfg.onFXQPSendTongZhi)  --���͸������̻��ʼ֪ͨ
end

executeEventFunction[15] = function(param)
    GameEvent.push(EventCfg.onFXQPStart)        --�������̿�ʼ�
end

executeEventFunction[20] = function(param)
    GameEvent.push(EventCfg.onFXQPResreshBoss)  --���ǻˢ��BOSS
end

executeEventFunction[35] = function(param)
    GameEvent.push(EventCfg.onFXQPEnd)          --�������̻����
end

executeEventFunction[25] = function(param)
    GameEvent.push(EventCfg.goTXSendTongZhi, 1) --������ѡ֮�˵�һ��֪ͨ
end

executeEventFunction[30] = function(param)
    GameEvent.push(EventCfg.goTXreward, 1)      --������ѡ֮�˵�һ�ֽ���
end

executeEventFunction[44] = function(param)
    GameEvent.push(EventCfg.onQMHSSendTongZhi)      --������ѡ֮�˵�һ�ֽ���
end

executeEventFunction[45] = function(param)
    GameEvent.push(EventCfg.onQMHSStart)            --ȫ��ˮ��ʼ
end


executeEventFunction[55] = function(param)
    GameEvent.push(EventCfg.goTXSendTongZhi)      --������ѡ֮�˵ڶ���֪ͨ
    GameEvent.push(EventCfg.onQMHSEnd)            --ȫ��ˮ����
end

executeEventFunction[60] = function(param)
    GameEvent.push(EventCfg.goTXreward, 2)      --������ѡ֮�˵ڶ��ֽ���
end

executeEventFunction[74] = function(param)
    GameEvent.push(EventCfg.onJQPDTongZhi)      --�����ݵ�֪ͨ
end

executeEventFunction[75] = function(param)
    GameEvent.push(EventCfg.onJQPDStart)      --�����ݵ㿪ʼ
end

executeEventFunction[85] = function(param)
    GameEvent.push(EventCfg.onJQPDEnd)      --�����ݵ����
    GameEvent.push(EventCfg.goTXSendTongZhi, 3) --������ѡ֮�˵�����֪ͨ
end

executeEventFunction[90] = function(param)
    GameEvent.push(EventCfg.goTXreward, 3)      --������ѡ֮�˵����ֽ���
end

executeEventFunction[104] = function(param)
    GameEvent.push(EventCfg.onMYZWTongZhi)  --����֮��֪ͨ
end

executeEventFunction[105] = function(param)
    GameEvent.push(EventCfg.onMYZWStart)  --����֮����ʼ
end

executeEventFunction[115] = function(param)
    GameEvent.push(EventCfg.onMYZWEnd)  --����֮������
    GameEvent.push(EventCfg.goTXSendTongZhi, 4) --������ѡ֮�˵�����֪ͨ
end

executeEventFunction[120] = function(param)
    GameEvent.push(EventCfg.goTXreward, 4)      --������ѡ֮�˵����ֽ���
end

executeEventFunction[134] = function(param)
    GameEvent.push(EventCfg.onFXQPSendTongZhi)  --���͸������̻��ʼ֪ͨ
end

executeEventFunction[135] = function(param)
    GameEvent.push(EventCfg.onFXQPStart)        --�������̿�ʼ�
end

executeEventFunction[140] = function(param)
    GameEvent.push(EventCfg.onFXQPResreshBoss)  --���ǻˢ��BOSS
end

executeEventFunction[155] = function(param)
    GameEvent.push(EventCfg.onFXQPEnd)          --�������̻����
end

return executeEventFunction