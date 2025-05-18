cfg_mail                = include("QuestDiary/cfgcsv/cfg_mail.lua")               --邮件配置
cfg_renwu               = include("QuestDiary/cfgcsv/cfg_renwu.lua")              --任务表
cfg_renwu_target        = include("QuestDiary/cfgcsv/cfg_renwu_target.lua")       --任务目标
cfg_renwu_touch         = include("QuestDiary/cfgcsv/cfg_renwu_touch.lua")        --任务点击行为
cfg_top_icon            = include("QuestDiary/cfgcsv/cfg_top_icon.lua")           --顶部图标配置
cfg_HuiShou             = include("QuestDiary/cfgcsv/cfg_HuiShou.lua")            --回收配置
-- cfg_hecheng             = include("QuestDiary/cfgcsv/cfg_hecheng.lua")         --合成配置
cfg_map_npc_mov         = include("QuestDiary/cfgcsv/cfg_map_npc_mov.lua")        --下图配置
-- cfg_shoubao             = include("QuestDiary/cfgcsv/cfg_ShouBao.lua")         --首曝配置
cfg_kuangbao            = include("QuestDiary/cfgcsv/cfg_kuangbao.lua")           --狂暴配置
cfg_fen_jie             = include("QuestDiary/cfgcsv/cfg_FenJie.lua")             --分解配置
cfg_ShiZhuangHeCheng    = include("QuestDiary/cfgcsv/cfg_ShiZhuangHeCheng.lua")   --时装合成
cfg_ShaLuYinJi          = include("QuestDiary/cfgcsv/cfg_ShaLuYinJi.lua")         --杀戮印记
cfg_BaoFengZhiLi          = include("QuestDiary/cfgcsv/cfg_BaoFengZhiLi.lua")     --暴风之力
cfg_BuZaoChengEWaiShangHai          = include("QuestDiary/cfgcsv/cfg_BuZaoChengEWaiShangHai.lua")     --不造成伤害外伤的怪物

-- include("QuestDiary/game/A/Task.lua")
include("QuestDiary/game/A/KuangBao.lua")                         --狂暴
include("QuestDiary/game/A/test.lua")                             --测试使用
include("QuestDiary/game/A/TopIcon.lua")
-- include("QuestDiary/game/A/CeShi.lua")
-- include("QuestDiary/game/A/XinRenJieDai.lua")
include("QuestDiary/game/A/Public.lua")
include("QuestDiary/game/A/HuiShou.lua")
-- include("QuestDiary/game/A/HeCheng.lua")
-- include("QuestDiary/game/A/MoneyExchange.lua")
-- include("QuestDiary/game/A/OtherAttr.lua")
-- include("QuestDiary/game/A/ShangHai.lua")
-- include("QuestDiary/game/A/MapNpc.lua")
-- include("QuestDiary/game/A/ShouBao.lua")
include("QuestDiary/game/A/GongShaChuanSong.lua")                 --攻沙
include("QuestDiary/game/A/KFGongShaChuanSong.lua")                 --攻沙
include("QuestDiary/game/A/ZongHeFuWu.lua")                       --综合服务
-- include("QuestDiary/game/A/FenJie.lua")                           --分解
include("QuestDiary/game/A/TiZhiXiuLian.lua")                     --体质修炼
include("QuestDiary/game/A/JiuXianLiBai.lua")                     --酒仙李白
include("QuestDiary/game/A/ShiZhuangHeCheng.lua")                 --时装合成
include("QuestDiary/game/A/ShaLuYinJi.lua")                       --杀戮印记
include("QuestDiary/game/A/BaoFengZhiLi.lua")                     --暴风之力
include("QuestDiary/game/A/KongJianFaShi.lua")                    --空间法师
include("QuestDiary/game/A/XiuXian.lua")                          --修仙
include("QuestDiary/game/A/TeShuHeCheng.lua")                     --特殊合成
include("QuestDiary/game/A/ShouChong.lua")                        --特殊合成
include("QuestDiary/game/A/FuWuBox.lua")                           --服务盒子
include("QuestDiary/game/A/TianMing.lua")                         --天命
include("QuestDiary/game/A/ZhuangBeiBuff.lua")                    --装备BUFF
include("QuestDiary/game/A/SendAbility.lua")                    --属性改变触发
include("QuestDiary/game/A/itemBaoLv.lua")                    --属性改变触发
include("QuestDiary/game/A/itemAttr.lua")                    --属性改变切割和属性改变
include("QuestDiary/game/A/itemGongSu.lua")                    --属性改变攻速
-- include("QuestDiary/game/A/FuHuoPeiZhi.lua")                    --复活配置
include("QuestDiary/game/A/MoHuaTianShiA.lua")                 --魔幻天使A（盾牌）
include("QuestDiary/game/A/MoHuaTianShiA.lua")                 --魔幻天使A（盾牌）
include("QuestDiary/game/A/JiLuShi.lua")                      --魔幻天使A（盾牌）
include("QuestDiary/game/A/XunHangGuaJi.lua")                 --巡航挂机
include("QuestDiary/game/A/XinMoLaoRen.lua")                 --巡航挂机
include("QuestDiary/game/A/VariableAdditionaAttributes.lua")                 --变量附加属性
include("QuestDiary/game/A/GuaXiangZhanBu.lua")                 --挂象占卜
include("QuestDiary/game/A/EnterDaLu.lua")                        --进入大陆
include("QuestDiary/game/A/LeftTop.lua")                        --左上方
include("QuestDiary/game/A/PostRank.lua")                        --上传排行数据
include("QuestDiary/game/A/Task.lua")                        --任务
include("QuestDiary/game/A/XinRenShangXian.lua")               --新人上线
include("QuestDiary/game/A/JiXianQianNeng.lua")               --极限潜能

include("QuestDiary/game/A/TanCePanel.lua")               --探测Panel
include("QuestDiary/game/A/onDaiYaoShengYao.lua")         --圣药附加触发
include("QuestDiary/game/A/ZhuangBan.lua")                --装扮
include("QuestDiary/game/A/ShaChengZhanShenBang.lua")     --沙城战神榜
include("QuestDiary/game/A/NiuMaZanZhu.lua")              --牛马赞助
include("QuestDiary/game/A/TeQuan.lua")                   --解绑特权
include("QuestDiary/game/A/ChongZhiZhongXin.lua")         --充值特权
include("QuestDiary/game/A/ShiJieDiTu.lua")               --世界地图
include("QuestDiary/game/A/CaiLiaoHuoZhan.lua")           --材料货栈

include("QuestDiary/game/A/YeShouZhiSen.lua")     --野兽之森
include("QuestDiary/game/A/TaoHuaLin.lua")     --桃花林
include("QuestDiary/game/A/LiuLiKuangDong.lua")     --琉璃矿洞
include("QuestDiary/game/A/TianYuanBianGuan.lua")     --天元边关
include("QuestDiary/game/A/YiWangGuJi.lua")     --遗忘古迹
include("QuestDiary/game/A/NiuMaNiXi.lua")         --牛马逆袭
include("QuestDiary/game/A/ShouJiRenWuWuPin.lua")         --收集任务
include("QuestDiary/game/A/FuLiDaTing.lua")     --福利大厅
include("QuestDiary/game/A/TianXuanZhiRen.lua")     --天选之人
include("QuestDiary/game/A/FuXingQiPan.lua")     --福星棋盘
include("QuestDiary/game/A/QuanMinHuaShui.lua")     --全民划水
include("QuestDiary/game/A/MoYuZhiWang.lua")     --摸鱼之王
include("QuestDiary/game/A/JiQingPaoDian.lua")     --激情泡点
include("QuestDiary/game/A/HuoDongDaTing.lua")     --活动大厅
include("QuestDiary/game/A/WorldBoosBuff.lua")     --世界Boos专属触发
include("QuestDiary/game/A/YuWaiZhanChang.lua")     --域外战场
include("QuestDiary/game/A/GuanMing.lua")     --冠名
include("QuestDiary/game/A/Pay.lua")     --冠名
include("QuestDiary/game/A/XianWangBaoZang.lua")     --仙王宝藏
include("QuestDiary/game/A/NiuMaKuangGong.lua")     --牛马旷工
include("QuestDiary/game/A/XianWangXuanShang.lua")     --仙王悬赏
include("QuestDiary/game/A/HuoBiDuiHuan.lua")     --货币兑换
include("QuestDiary/game/A/ShengMingShenZhu.lua")     --生命神柱
include("QuestDiary/game/A/YiJieMiCheng.lua")     --异界迷城
include("QuestDiary/game/A/MeiRiChongZhi.lua")     --每日充值
include("QuestDiary/game/A/KuaFuBuff.lua")     --每日充值
include("QuestDiary/game/A/GanEnHuiKui.lua")     --感恩回馈
include("QuestDiary/game/A/HunZhuangJieMian.lua")     --魂装界面
include("QuestDiary/game/A/CDKDuiHuan.lua")     --CDK兑换


include("QuestDiary/game/A/FenJinShiZhuangHe.lua")     --奋进时装盒
include("QuestDiary/game/A/ChaKanTaRenQiYun.lua")     --查看他人气运