local PostRank = {}
local url = "http://159.75.153.98:880/api/Rank/setRank80704d6b19968d0a"
local globalUserData = {}
--��ȡ�û���������а���������
local function getUserData(actor)
    local UserID = getbaseinfo(actor, ConstCfg.gbase.id) or ""
    local Name = getbaseinfo(actor, ConstCfg.gbase.name) or ""
    local Server = getconst(actor, "<$SERVERNAME>") or ""
    local Value = Player.GetPower(actor) or ""
    local Level = getbaseinfo(actor, ConstCfg.gbase.level) or 0
    local GuildName = getbaseinfo(actor, ConstCfg.gbase.guild) or ""
    local postData = {}
    postData.UserID = UserID
    postData.Name = Name
    postData.Server = Server
    postData.Value = Value
    postData.Level = Level
    postData.GuildName = GuildName
    return postData
end

local function PostRankRequest(postData)
    --httppost(url, tbl2json(postData), '{sign:test123}')
end

--ÿ����Сʱͳ��һ�Σ������˽ű�
function rank_statistics()
    local Server = getconst("0", "<$SERVERNAME>")
    if Server ~= "" then
        local userList = getplayerlst(1)
        for _, value in ipairs(userList) do
            local level = getbaseinfo(value,ConstCfg.gbase.level)
            --����100��
            if level > 100 then
                table.insert(globalUserData, getUserData(value))
            end
        end
        grobaldelaygoto(1000, "rank_recursive_data_submit")
    end
end

--ϵͳ�ӳ��ύ����
function rank_recursive_data_submit()
    --ȡ��Ԫ�أ�ÿ������
    if #globalUserData > 0 then
        local count = math.min(2, #globalUserData)
        grobaldelaygoto(1000, "rank_recursive_data_submit")
        --�ύ����
        for i = 1, count do
            PostRankRequest(globalUserData[i])
        end
        --ɾ���ύ�������
        for i = 1, count do
            table.remove(globalUserData, 1)
        end
        --�����ݹ�
        grobaldelaygoto(1000, "rank_recursive_data_submit")
    end
end

--�����ӳ��ύ����֤׼ȷ��
function rank_delayed_submit(actor)
    local postData = getUserData(actor)
    PostRankRequest(postData)
end


function PostRank.Request(actor)
    if hasbuff(actor,31061) then
        local time = getbuffinfo(actor, 31061, 2)
        Player.sendmsgEx(actor, "������ȴ�У�ʣ��|"..time.."#249|��...")
        return
    end
    addbuff(actor,31061)
    rank_delayed_submit(actor)
end
--��½ͬ��һ����Ϣ
local function _onLoginEnd(actor, logindatas)
    local Server = getconst(actor, "<$SERVERNAME>")
    if Server ~= "" then
        delaygoto(actor, 5000, "rank_delayed_submit")
    end
end
--�¼��ɷ�
GameEvent.add(EventCfg.onLoginEnd, _onLoginEnd, PostRank)
Message.RegisterNetMsg(ssrNetMsgCfg.PostRank, PostRank)
return PostRank