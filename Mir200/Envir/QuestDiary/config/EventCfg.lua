EventCfg = {}

--引擎事件
EventCfg.onTest                     = "onTest"                        --测试数据
EventCfg.onStartUp                  = "onStartUp"                     --m2启动
EventCfg.onNewHuman                 = "onNewHuman"                    --新角色第一次登录    (参数：actor)
EventCfg.onLogin                    = "onLogin"                       --登录    (参数：actor)
EventCfg.onLoginAttr                = "onLoginAttr"                   --登录附加属性    (参数：actor, 登录属性数据)
EventCfg.onOtherAttr                = "onOtherAttr"                   --登录附加属性    (参数：actor, 登录属性数据)
EventCfg.onLoginEnd                 = "onLoginEnd"                    --登录完成    (参数：actor, 登录同步数据)
EventCfg.onKFLogin                  = "onKFLogin"                    --跨服登陆触发
EventCfg.onKuaFuEnd                 = "onKuaFuEnd"                    --跨服回本服触发
EventCfg.onKillMon                  = "onKillMon"                     --任意地图杀怪    (参数：actor, 死亡怪物对象, 死亡怪物idx)
EventCfg.onkillplay                 = "onkillplay"                    --任意地图杀人
EventCfg.onkillplayQiYu             = "onkillplayQiYu"                --杀人奇遇触发
EventCfg.onPlaydie                  = "onPlaydie"                     --死亡触发
EventCfg.onPlaydieQiYu              = "onPlaydieQiYu"                 --死亡奇遇触发
EventCfg.onNextDie                 = "onNextDie"                     --复活前触发
EventCfg.onPlayLevelUp              = "onPlayLevelUp"                 --玩家升级    (参数：actor, 当前等级, 之前等级)
EventCfg.onTakeOnEx                 = "onTakeOnEx"                    --穿装备goPlayerVar
EventCfg.onTakeOffEx                = "onTakeOffEx"                   --脱装备
EventCfg.onPickUpItemfrontex        = "onPickUpItemfrontex"           --拾取道具前触发
EventCfg.onGuildAddMemberAfter      = "onGuildAddMemberAfter"         --行会添加成员后触发
EventCfg.onCloseGuild               = "onCloseGuild"                  --解散行会
EventCfg.onLoadGuild                = "onLoadGuild"                   --创建行会
EventCfg.onGuilddelMember           = "onGuilddelMember"              --退出行会时触发
EventCfg.onMondropItemex            = "onMondropItemex"               --怪物爆出装备触发
EventCfg.onAttackDamageBB           = "onAttackDamageBB"              --宝宝攻击前触发
EventCfg.onPlayItemExpired          = "onPlayItemExpired"             --玩家限时装备到期触发


EventCfg.Myonlookhuminfo            = "Myonlookhuminfo"               --查看装备触发--自己
EventCfg.Tgtonlookhuminfo           = "Tgtonlookhuminfo"              --查看装备触发--他人
EventCfg.onCheckDropUseItems        = "onCheckDropUseItems"           --死亡掉装备前触发

EventCfg.ReliveCountdown_1          = "ReliveCountdown_1"             --复活倒计时  （每秒执行1次） 定时器 101
EventCfg.ReliveCountdown_2          = "ReliveCountdown_2"             --复活倒计时  （每秒执行1次） 定时器 102
EventCfg.ReliveCountdown_3          = "ReliveCountdown_3"             --复活倒计时  （每秒执行1次） 定时器 103

EventCfg.onTakeOn0                  = "ontakeon0"                    --衣服位置----穿   (复活装备)
EventCfg.onTakeOff0                 = "onTakeOff0"                   --衣服位置----脱   (复活装备)

EventCfg.onTakeOn9                  = "onTakeOn9"                    --毒符位置----穿   (复活装备)
EventCfg.onTakeOff9                 = "onTakeOff9"                   --毒符位置----脱   (复活装备)
EventCfg.LongZhiXinUp               = "LongZhiXinUp"                   --龙之心升级

EventCfg.onTakeOn11                  = "onTakeOn11"                  --毒符位置----穿   (复活装备)
EventCfg.onTakeOff11                 = "onTakeOff11"                   --毒符位置----脱   (复活装备)


EventCfg.onTakeOn40                  = "onTakeOn40"                    --首饰盒位置11----穿   (龙族雕石)
EventCfg.onTakeOff40                 = "onTakeOff40"                   --首饰盒位置11----脱   (龙族雕石)


EventCfg.onTakeOn72                  = "onTakeOn72"                    --首饰盒位置72----穿   
EventCfg.onTakeOff72                 = "onTakeOff72"                   --首饰盒位置72----脱   


EventCfg.onTakeOn14                = "onTakeOn14"                    --穿疾风刻印
EventCfg.onTakeOff14               = "onTakeOff14"                   --脱疾风刻印
EventCfg.onTakeOn21                = "onTakeOn21"                    --穿时装头盔
EventCfg.onTakeOff21               = "onTakeOff21"                   --脱时装头盔
EventCfg.onTakeOn43                = "onTakeOn43"                    --法宝穿戴后
EventCfg.onBuffChange              = "onBuffChange"                  --Buff触发

EventCfg.onAddBag                   = "onAddBag"                      --物品进背包
EventCfg.onExitGame                 = "onExitGame"                    --小退或大退游戏
EventCfg.onTriggerChat              = "onTriggerChat"                 --聊天栏输入信息
EventCfg.onClicknpc                 = "onClicknpc"                    --点击某NPC
EventCfg.onRechargeBefore           = "onRechargeBefore"              --充值前触发,修改实充用(参数：actor, 充值rmb金额, 产品ID（保留）, 货币ID)
EventCfg.onRecharge                 = "onRecharge"                    --充值     (参数：actor, 充值rmb金额, 产品ID（保留）, 货币ID)
EventCfg.onVirtualRecharge          = "onVirtualRecharge"             --虚拟充值     (参数：actor, 充值rmb金额, 产品ID（保留）, 货币ID)
EventCfg.goEnterMap                 = "goEnterMap"                    --进入地图
EventCfg.goSwitchMap                = "goSwitchMap"                   --切换地图
EventCfg.goLeaveMap                 = "goLeaveMap"                    --离开地图
EventCfg.onMove                     = "onMove"                        --移动触发 (参数：actor, 0跑/1走)
EventCfg.onBeginMagic               = "onBeginMagic"                  --使用技能触发
EventCfg.onProHarm                  = "onProHarm"                     --玩家受到伤害触发 (参数：actor, 伤害值)

EventCfg.onAttackDamage             = "onAttackDamage"                --攻击前触发
EventCfg.onAttackDamagePlayer       = "onAttackDamagePlayer"          --攻击前人物
EventCfg.onAttackDamageMonster      = "onAttackDamageMonster"         --攻击前怪物

EventCfg.onAttack                   = "onAttack"                      --攻击触发
EventCfg.onAttackPlayer             = "onAttackPlayer"                --攻击人物触发触发
EventCfg.onAttackMonster            = "onAttackMonster"               --攻击怪物触发

EventCfg.onStruck                   = "onStruck"                      --被物理攻击触发
EventCfg.onStruckPlayer             = "onStruckPlayer"                --被人物攻击触发
EventCfg.onStruckMonster            = "onStruckMonster"               --被怪物攻击触发

EventCfg.onStruckDamage             = "onStruckDamage"                --被物理攻击前触发
EventCfg.onStruckDamagePlayer       = "onStruckDamagePlayer"          --被人物攻击前触发
EventCfg.onStruckDamageMonster      = "onStruckDamageMonster"         --被怪物攻击前触发

EventCfg.onEnterGroup               = "onEnterGroup"                  --进入队伍触发
EventCfg.onLeaveGroup               = "onLeaveGroup"                  --离开队伍触发
EventCfg.onSendAbility              = "onSendAbility"                 --属性改变触发

EventCfg.onAddSkillPower            = "onAddSkillPower"               --增加技能威力


EventCfg.goBill                     = "goBill"                        --充值相关(月卡功能用来扣除灵符并阻止累计充值)
EventCfg.onBagChange                = "onBagChange"                   --背包格子数发送变化
EventCfg.onRevive                   = "onRevive"                      --复活触发
EventCfg.onRecycling                = "onRecycling"                   --回收触发
EventCfg.onTakeOnNecklace           = "onTakeOnNecklace"              --穿项链前触发
EventCfg.onTakeOffNecklace          = "onTakeOffNecklace"             --脱项链前触发
EventCfg.onTakeOnWeapon             = "onTakeOnWeapon"                --穿武器前触发
EventCfg.onTakeOffWeapon            = "onTakeOffWeapon"               --脱武器前触发
EventCfg.onTakeOnDress              = "onTakeOnDress"                 --穿衣服前触发
EventCfg.onTakeOffDress             = "onTakeOffDress"                --脱衣服前触发
EventCfg.onGroupItemOnEx            = "onGroupItemOnEx"               --穿套装触发
EventCfg.onGroupItemOffEx           = "onGroupItemOffEx"              --脱套装触发

EventCfg.onShowFashion              = "onShowFashion"                 --时装外显触发
EventCfg.onNotShowFashion           = "onNotShowFashion"              --取消时装外显触发

--任务
EventCfg.onPickTask                 = "onPickTask"                    --接取任务触发
EventCfg.onClickNewTask             = "onClickNewTask"                --点击任务触发
EventCfg.onChangeTask               = "onChangeTask"                  --刷新任务触发
EventCfg.onCompleteTask             = "onCompleteTask"                --完成任务触发
EventCfg.onDeleteTask               = "onDeleteTask"                  --删除任务触发
EventCfg.onCollectTask              = "onCollectTask"                 --采集触发
EventCfg.onBeforerOute              = "onBeforerOute"                 --进入连接点(跳转点)前触发

--游戏事件
EventCfg.goPlayerVar                = "goPlayerVar"                   --声明个人变量    (参数：actor)
EventCfg.goZSLevelChange            = "goZSLevelChange"               --转生等级发生变化 (参数：actor, 当前转生等级， 之前的转生等级)
EventCfg.goBeforedawn               = "goBeforedawn"                  --机器人脚本每日凌晨触发  (参数：actor, 凌晨同步数据)
EventCfg.roBeforedawn               = "roBeforedawn"                  --机器人脚本每日凌晨触发 (已开服天数)
EventCfg.goDailyUpdate              = "goDailyUpdate"                 --每日更新(凌晨或每日第一次登录)(参数：actor, 是否每日第一次登录, 同步数据)
EventCfg.goCheckModule              = "goCheckModule"                 --检查是否有模块达到开启要求
EventCfg.goOpenModule               = "goOpenModule"                  --某模块达到开启要求(参数：actor, 模块ID)
EventCfg.goSetGem                   = "goSetGem"                      --镶嵌宝石(参数：actor)
EventCfg.goBaoWu                    = "goBaoWu"                       --宝物升级(参数：actor)
EventCfg.goNiTian                   = "goNiTian"                      --逆天改命升级(参数：actor)
EventCfg.goShenShou                 = "goShenShou"                    --神兽升级(参数：actor)
EventCfg.goKuangBao                 = "goKuangBao"                    --开启狂暴(参数：actor)
EventCfg.goPickUpItemEx             = "goPickUpItemEx"                --拾取物品后触发(参数：actor, item，--等待支持num)
EventCfg.goDropItemEx               = "goDropItemEx"                  --扔掉任意物品后触发
EventCfg.goCastlewarend             = "goCastlewarend"                --攻城结束时触发
EventCfg.gocastlewarstart           = "gocastlewarstart"              --攻城开始时触发
EventCfg.gocastlewaring             = "gocastlewaring"                --攻城中触发
EventCfg.gomapeventwalk             = "gomapeventwalk"                --沙巴克进皇宫走步触发
EventCfg.goGuild                    = "goGuild"                       --加入行会
EventCfg.goActivityState            = "goActivityState"               --活动开启或关闭展示红点(参数 活动idx,活动state)

EventCfg.goActivityMap              = "goActivityMap"                 --进入活动地图触发(清除任务栏的信息)
EventCfg.goBackMap                  = "goBackMap"                     --离开活动地图触发(刷新任务栏的信息)

EventCfg.onCreateGuiGuTaskBar       = "onCreateGuiGuTaskBar"          --创建鬼谷副本中的任务栏的信息
EventCfg.onClearGuiGuTaskBar        = "onClearGuiGuTaskBar"           --清除鬼谷副本中的任务栏的信息
EventCfg.onUpdataGuiGuTaskBar       = "onUpdataGuiGuTaskBar"           --刷新鬼谷副本中的任务栏的信息

EventCfg.goVIPlvelup                = "goVIPlvelup"                   --升级vip时触发触发(参数：1actor, 2viplevel)
EventCfg.goADDFashion               = "goADDFashion"                  --添加上自定义时装触发

EventCfg.goRongHe                   = "goRongHe"                      --装备融合(参数：actor)
EventCfg.goJinJie                   = "goJinJie"                      --装备进阶(参数：actor)
EventCfg.goJHMW                     = "goJHMW"                        --江湖名望/vip进阶(参数：actor)
EventCfg.goHecheng1                 = "goHecheng1"                    --复活合成
EventCfg.goHecheng2                 = "goHecheng2"                    --麻痹合成

EventCfg.goQuickAccess              = "goQuickAccess"                 --打开材料引导面板(itemidx)
EventCfg.goItemZXBX                 = "goItemZXBX"                    --打开宝箱选择面板(itemidx)

EventCfg.onLoserCar                 = "onLoserCar"                     --丢失镖车触发
EventCfg.onCarDie                   = "onCarDie"                       --镖车死亡触发
EventCfg.onSlaveDamage              = "onSlaveDamage"                  --镖车被攻击触发

EventCfg.onSelfKillSlave            = "onSelfKillSlave"                  --宝宝死亡触发


EventCfg.onProTakeOn                = "onProTakeOn"                   --穿装备触发/添加隐藏属性用
EventCfg.onProTakeOff               = "onProTakeOff"                  --脱装备触发/删除隐藏属性用
EventCfg.onProEquipDel              = "onProEquipDel"                 --合成时有销毁道具时触发/重置隐藏属性用

--其他技能
EventCfg["使用寂灭归墟"]             = "使用寂灭归墟"                   --使用寂灭归墟触发
EventCfg["使用十步一杀"]             = "使用十步一杀"                   --使用十步一杀
EventCfg["使用野蛮对人"]             = "使用野蛮对人"                   --使用野蛮对人
EventCfg["使用燃烧法则"]             = "使用燃烧法则"                   --使用燃烧法则
EventCfg["使用技能通用派发"]         = "使用技能通用派发"                --使用技能通用派发

-------------------------活动相关begin----------------------------------------------------
---活动定时器
EventCfg.gameEventTimer          = "gameEventTimer"               --游戏活动计时

---天选之人
EventCfg.goTXGetNumber              = "goTXGetNumber"                 --首充的获取号码
EventCfg.goTXTiming                 = "goTXTiming"                    --计时 用于计算下一轮的时间
EventCfg.goTXSendTongZhi            = "goTXSendTongZhi"               --首充的获取号码
EventCfg.goTXreward                 = "goTXreward"                    --发放奖励

---福星棋盘
EventCfg.onFXQPSendTongZhi          = "onFXQPSendTongZhi"               --发送开启通知
EventCfg.onFXQPStart                = "onFXQPStart"                     --活动开始
EventCfg.onFXQPResreshBoss          = "onFXQPResreshBoss"               --开始刷boss
EventCfg.onFXQPEnd                  = "onFXQPEnd"                       --活动结束
EventCfg.onFXQPReward               = "onFXQPReward"                    --福星棋盘每两秒奖励

--全民划水开始
EventCfg.onQMHSSendTongZhi         = "onQMHSSendTongZhi"              --全民划水开始
EventCfg.onQMHSStart               = "onQMHSStart"                    --全民划水开始
EventCfg.onQMHSEnd                 = "onQMHSEnd"                      --全民划水结束
EventCfg.onQMHTimer                = "onQMHTimer"                     --定时器

--激情泡点
EventCfg.onJQPDTongZhi             = "onJQPDTongZhi"                   --激情泡点通知
EventCfg.onJQPDStart               = "onJQPDStart"                     --激情泡点开始
EventCfg.onJQPDEnd                 = "onJQPDEnd"                       --激情泡点结束
EventCfg.onJQPDimer                = "onJQPDimer"                      --激情泡点定时器

--摸鱼之王
EventCfg.onMYZWimer                = "onMYZWimer"                      --摸鱼之王定时器
EventCfg.onMYZWTongZhi             = "onMYZWTongZhi"                   --摸鱼之王通知
EventCfg.onMYZWStart               = "onMYZWStart"                     --摸鱼之王开始
EventCfg.onMYZWEnd                 = "onMYZWEnd"                       --摸鱼之王结束


EventCfg.onXianWangBaoZangStart    = "onXianWangBaoZangStart"            --仙王宝藏开始
EventCfg.onXianWangBaoZangEnd      = "onXianWangBaoZangEnd"            --仙王宝藏结束

EventCfg.onYiJieLieChangStart      = "onYiJieLieChangStart"            --异界猎场开始
EventCfg.onYiJieLieChangEnd        = "onYiJieLieChangEnd"              --异界猎场结束

EventCfg.onNiuMaKuangGongStart      = "onNiuMaKuangGongStart"          --牛马旷工开始
EventCfg.onNiuMaKuangGongEnd        = "onNiuMaKuangGongEnd"            --牛马旷工结束

EventCfg.onYiJieMiChengStart       = "onYiJieMiChengStart"             --异界迷城开始
EventCfg.onYiJieMiChengEnd         = "onYiJieMiChengEnd"               --异界迷城结束

--双节活动
EventCfg.onShuangJieHuoDongStart   = "onShuangJieHuoDongStart"         --双节活动开始
EventCfg.onShuangJieHuoDongEnd     = "onShuangJieHuoDongEnd"           --双节活动结束
EventCfg.onKuangHuanXiaoZhenShuaGuai = "onKuangHuanXiaoZhenShuaGuai"     --狂欢小镇刷怪

---------------------------------跨服活动------------------------------------------
---跨服战将夺旗---------------
EventCfg.onKFZhanJiangDuoQiStart    = "onKFZhanJiangDuoQiStart"        --跨服战将夺旗开始
EventCfg.onKFZhanJiangDuoQiEnd      = "onKFZhanJiangDuoQiEnd"          --跨服战将夺旗结束
EventCfg.onKFZhanJiangDuoQi         = "onKFZhanJiangDuoQi"             --跨服战将夺旗
EventCfg.onKFZhanJiangDuoQiEnter    = "onKFZhanJiangDuoQiEnter"        --跨服战将进入
EventCfg.onKFZhanJiangDuoQiLeaveMap = "onKFZhanJiangDuoQiLeaveMap"      --跨服斩将夺旗离开地图
EventCfg.onKFZhanJiangDuoQiRlive    = "onKFZhanJiangDuoQiRlive"        --跨服战将夺旗复活
EventCfg.onKFZhanJiangDuoQiSync     = "onKFZhanJiangDuoQiSync"          --跨服战将夺旗每秒定时器
EventCfg.onKFZhanJiangDuoQiShowMap  = "onKFZhanJiangDuoQiShowMap"       --跨服战将夺旗同步小地图数据
EventCfg.onKFZhanJiangDuoQiGetRankData  = "onKFZhanJiangDuoQiGetRankData"       --跨服战将夺旗获取排行数据
EventCfg.onKFZhanJiangDuoQiGetHonorData  = "onKFZhanJiangDuoQiGetHonorData"     --获取荣誉数据
EventCfg.onKFZhanJiangDuoQiLingQu      = "onKFZhanJiangDuoQiLingQu"           --领取奖励
EventCfg.onKFZhanJiangDuoSendReward    = "onKFZhanJiangDuoSendReward"           --发送邮件奖励
---跨服天下第一------
EventCfg.onKFTianXiaDiYiStart      = "onKFTianXiaDiYiStart"        --跨服天下第一开始
EventCfg.onKFTianXiaDiYiEnd        = "onKFTianXiaDiYiEnd"          --跨服天下第一结束
EventCfg.onKFTianXiaDiYiEnter      = "onKFTianXiaDiYiEnter"        --跨服天下第一进入
EventCfg.onKFTianXiaDiYiSync       = "onKFTianXiaDiYiSync"         --跨服天下第一同步消息
EventCfg.onKFTianXiaDiYiPanelSync  = "onKFTianXiaDiYiPanelSync"    --跨服天下第一主面板同步数据
EventCfg.onKFTianXiaDiYiLingQu     = "onKFTianXiaDiYiLingQu"       --跨服天下第一领取奖励
EventCfg.onKFTianXiaDiYiLingQuBenFu = "onKFTianXiaDiYiLingQuBenFu"       --跨服天下第一到本服领取奖励

---跨服战神榜------
EventCfg.onKuaFuZhanShenBangToKuaFu  = "onKuaFuZhanShenBangToKuaFu" --本服到跨服执行
EventCfg.onKuaFuZhanShenBangToBenFu  = "onKuaFuZhanShenBangToBenFu" --跨服到本服执行
EventCfg.onKuaFuZhanShenBangSyncResponse  = "onKuaFuZhanShenBangSyncResponse" --请求同步一次数据

--跨服富甲天下---
EventCfg.onFuJiaTianXiaToKuaFu  =           "onFuJiaTianXiaToKuaFu" --本服到跨服执行
EventCfg.onFuJiaTianXiaToBenFu  =           "onFuJiaTianXiaToBenFu" --跨服到本服执行
EventCfg.onFuJiaTianXiaSyncResponse  =      "onFuJiaTianXiaSyncResponse" --请求同步一次数据

--神魂炼狱---
EventCfg.onShenHunLianYuKuaFu  =            "onShenHunLianYuKuaFu" --本服到跨服执行
EventCfg.onShenHunLianYuKuaFuEnter  =       "onShenHunLianYuKuaFuEnter" --下地图

--龙骸遗迹
EventCfg.onLongHaiYiJiEnter  =       "onLongHaiYiJiEnter" --到跨服执行下地图
EventCfg.onLongHaiYiJiSync   =        "onLongHaiYiJiSync" --到跨服执行同步数据


--装备buff 跨服到本服执行脚本
EventCfg.onKTBzhuangBeiBUffLevel    = "onKTBzhuangBeiBUffLevel"      --脱下装备时减等级触发
EventCfg.onKTBzhuangBeiBUffShuXing  = "onKTBzhuangBeiBUffShuXing"    --脱下装备时刷新属性
EventCfg.onKTBzhuangBeiBUffBeiGong  = "onKTBzhuangBeiBUffBeiGong"    --脱下装备刷新倍攻
EventCfg.onKTBzhuangBeiBUffHuiXue   = "onKTBzhuangBeiBUffHuiXue"     --脱下装备时回血
EventCfg.onKTBzhuangBeiBUffDelBuff  = "onKTBzhuangBeiBUffDelBuff"    --脱下装备时删除buff

--狂暴之力在跨服货币到本服增加
EventCfg.onKuangBaoZhiLiBenFu    = "onKuangBaoZhiLiBenFu"           --狂暴之力跨服到本服增加货币

-------------------------活动相关end----------------------------------------------------


EventCfg.onCalcAttr                 = "onCalcAttr"                    --计算属性
EventCfg.onCalcBeiGong              = "onCalcBeiGong"                 --计算倍功
EventCfg.onCalcBaoLv                = "onCalcBaoLv"                   --计算爆率
EventCfg.onCalcAttackSpeed          = "onCalcAttackSpeed"             --计算攻速




EventCfg.onStartingDark             = "onStartingDark"                --夜晚开始触发
EventCfg.onStartingDay              = "onStartingDay"                 --白天开始触发

EventCfg.onChangeBaoLv              = "onChangeBaoLv"                 --爆率改变触发
EventCfg.onChangeBaoLvAddtion       = "onChangeBaoLvAddtion"          --爆率加成改变触发

EventCfg.onXunHangOnTime            = "onXunHangOnTime"               --巡航挂机定时器触发

EventCfg.HaFaXiSiZhiMuOnTimer       = "HaFaXiSiZhiMuOnTimer"           --哈法西斯之墓定时器触发
EventCfg.HaFaXiSiJiTanOnTimer       = "HaFaXiSiJiTanOnTimer"           --哈法西斯祭坛定时器触发
EventCfg.LuckyEventinitVar          = "LuckyEventinitVar"              --触发奇遇后初始化局部变量



EventCfg.GetCastleRewards           = "GetCastleRewards"               --领取沙城奖励
EventCfg.OpenKuangBao               = "OpenKuangBao"                   --开启狂暴
EventCfg.OverloadBaoLv              = "OverloadBaoLv"                  --爆率计算完后----重载
EventCfg.OverloadPower              = "OverloadPower"                  --战力计算完后----重载
EventCfg.OverloadGongSu             = "OverloadGongSu"                 --攻速计算完后----重载
EventCfg.OverloadMoneyJinBi         = "OverloadMoneyJinBi"             --金币改变后----重载
EventCfg.OverloadMoneyYuanBao       = "OverloadMoneyYuanBao"           --元宝改变后----重载
EventCfg.OverloadMoneyLingFu        = "OverloadMoneyLingFu"            --灵符改变后----重载
EventCfg.OverloadMoneyJiFen         = "OverloadMoneyJiFen"             --充值积分改变后----重载
EventCfg.onHuiShouFinish            = "onHuiShouFinish"                --回收完成触发
EventCfg.onCostMoney                = "onCostMoney"                    --消耗货币触发
EventCfg.onUseJiLuShi               = "onUseJiLuShi"                   --使用记录石后触发
EventCfg.onUPSkin                   = "onUPSkin"                       --收集装扮触发
EventCfg.onOpenJiXianQianNeng       = "onOpenJiXianQianNeng"           --开启极限潜能触发
EventCfg.onNewDay                   = "onNewDay"                       --新的一天触发
EventCfg.onEntetMirrorMap           = "onEntetMirrorMap"               --进入镜像地图触发
EventCfg.onYunYouShangRneBuy        = "onYunYouShangRneBuy"            --在云游商人购买东西概率触发
EventCfg.onHeiShiShangRneBuy        = "onHeiShiShangRneBuy"            --在黑市商人购买东西概率触发
EventCfg.onQianZhuangLaoBanBuy      = "onQianZhuangLaoBanBuy"          --在钱庄老板购买东西概率触发
EventCfg.onUseHongMingQingXiKa      = "onUseHongMingQingXiKa"          --使用红名清洗卡触发
EventCfg.onUseGaiMingKa             = "onUseGaiMingKa"                 --使用改名卡后触发
EventCfg.onXiuXianUP                = "onXiuXianUP"                    --修仙提升触发
EventCfg.onShaLuKeYinMax            = "onShaLuKeYinMax"                --杀戮刻印达到满级
EventCfg.onJiFengKeYinMax           = "onJiFengKeYinMax"               --疾风刻印达到满级
EventCfg.onAddAchievementTitle      = "onAddAchievementTitle"          --添加奇遇称号触发
EventCfg.onContinuousKillPlayer     = "onContinuousKillPlayer"         --连续杀人触发
EventCfg.onZhuangBeiXiLian          = "onZhuangBeiXiLian"              --洗练属性触发
EventCfg.onDuJieOnTiemr             = "onDuJieOnTiemr"                 --渡劫派发
EventCfg.onClickTaskJieJiuShaoNv    = "onClickTaskJieJiuShaoNv"        --解救少女点击任务触发
EventCfg.onTiZhiXiuLianUP           = "onTiZhiXiuLianUP"               --体质修炼触发
EventCfg.onKuangFengXiLian          = "onKuangFengXiLian"              --狂风洗练
EventCfg.onIntensifySkill           = "onIntensifySkill"               --强化技能触发
EventCfg.onJiangHuTitleUP           = "onJiangHuTitleUP"               --江湖称号升级触发
EventCfg.onRenewlevelUP             = "onRenewlevelUP"                 --转生触发
EventCfg.onJianJiaCuLian            = "onJianJiaCuLian"                --二大路剑甲淬炼触发
EventCfg.onZhuangBeiQiangHua        = "onZhuangBeiQiangHua"            --三大路装备强化--全身等级触发
EventCfg.onJianJiaKaiGuan           = "onJianJiaKaiGuan"               --神龙帝国剑甲开启触发
EventCfg.onXingYunXiangLian         = "onXingYunXiangLian"             --幸运项链触发
EventCfg.onJinRuJiJiZhiMen          = "onJinRuJiJiZhiMen"              --进入晋级之门副本
EventCfg.onLongShenZhiLiUP          = "onLongShenZhiLiUP"              --龙神之力升级触发
EventCfg.onTimer104                 = "onTimer104"                     --定时器104触发
EventCfg.onRechargeEnd              = "onRechargeEnd"                  --充值完成触发
EventCfg.onGetTaskTitle             = "onGetTaskTitle"                 --任务获得称号触发
EventCfg.onTeQuankaiTong            = "onTeQuankaiTong"                --特权开通触发

EventCfg.onRliveNotice              = "onRliveNotice"                  --通知复活状态触发

--跨服相关
EventCfg.goKFGongShaSync            = "goKFGongShaSync"                --攻沙积分同步

EventCfg.onKFGongShaRewardSync      = "onKFGongShaRewardSync"          --攻沙奖励同步
EventCfg.onKFGongShaLinQu           = "onKFGongShaLinQu"               --攻沙领取奖励
-- 飓风之眼BUFF跨服传递
EventCfg.onJuFengZhiYanKF           = "onJuFengZhiYanKF"               --飓风之眼BUFF跨服传递
-- 山岳壁垒BUFF跨服传递
EventCfg.onShanYueBiLeiKF           = "onShanYueBiLeiKF"               --山岳壁垒BUFF跨服传递




return EventCfg