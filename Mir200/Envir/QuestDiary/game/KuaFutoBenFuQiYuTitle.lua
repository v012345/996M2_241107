local KuaFutoBenFuQiYuTitle = {}

--������װ��ǰ����
KuaFutoBenFuQiYuTitle["onCheckDropUseItems"] = function(actor, arg1)
    GameEvent.push(EventCfg.onCheckDropUseItems, actor, arg1)
end
--�����ƺ���������
KuaFutoBenFuQiYuTitle["onPlaydieQiYu"] = function(actor, arg1)
    GameEvent.push(EventCfg.onPlaydieQiYu, actor)
end

--�����ƺŻ�ɱ����
KuaFutoBenFuQiYuTitle["onkillplayQiYu"] = function(actor, arg1)
    GameEvent.push(EventCfg.onkillplayQiYu, actor)
end

return KuaFutoBenFuQiYuTitle