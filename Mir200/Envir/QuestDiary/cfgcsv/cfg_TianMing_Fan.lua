local config = { 
	[1] = { 
		xls_id = 1,
		attDesc = "生命值+100",
		attr = {
			[1] = {
				[1] = 1,
				[2] = 100,
			},
		},
		name = "坚韧之息",
		fontDesc = "如磐石般的坚韧，生命力顽强，不屈不挠。",
		TMtype = 2,
	},
	[2] = { 
		xls_id = 2,
		attDesc = "魔法值+200",
		attr = {
			[1] = {
				[1] = 2,
				[2] = 100,
			},
		},
		name = "灵气之息",
		fontDesc = "汲取天地灵气，魔法能量源源不断，充盈全身。",
		TMtype = 2,
	},
	[3] = { 
		xls_id = 3,
		attDesc = "攻击+50",
		attr = {
			[1] = {
				[1] = 4,
				[2] = 50,
			},
		},
		name = "力量涌动",
		fontDesc = "力量涌入全身，攻击力小幅提升。",
		TMtype = 2,
	},
	[4] = { 
		xls_id = 4,
		attDesc = "防御+50",
		attr = {
			[1] = {
				[1] = 10,
				[2] = 50,
			},
		},
		name = "铁壁防线",
		fontDesc = "如同坚不可摧的铁壁，牢固守护，无懈可击。防御力小幅提升",
		TMtype = 2,
	},
	[5] = { 
		xls_id = 5,
		attDesc = "每秒恢复50点生命和魔法",
		attr = {
			[1] = {
				[1] = 71,
				[2] = 50,
			},
			[2] = {
				[1] = 91,
				[2] = 50,
			},
		},
		name = "回春术",
		fontDesc = "借助自然之力，让万物恢复生机，焕发新的生命。",
		TMtype = 2,
	},
	[6] = { 
		xls_id = 6,
		attDesc = "夜间攻魔道防+80-80",
		value = 50,
		name = "月光之力",
		fontDesc = "沐浴在月光之下，获得神秘力量的庇佑，夜晚战力大增。",
		TMtype = 3,
	},
	[7] = { 
		xls_id = 7,
		attDesc = "对怪伤害+5%",
		attr = {
			[1] = {
				[1] = 75,
				[2] = 500,
			},
		},
		name = "野兽之力",
		fontDesc = "释放内在野性的力量，击杀怪物时伤害小幅提升。",
		TMtype = 2,
	},
	[8] = { 
		xls_id = 8,
		attDesc = "受到怪物伤害降低5%",
		attr = {
			[1] = {
				[1] = 82,
				[2] = 500,
			},
		},
		name = "初学者",
		fontDesc = "受到做为初学者的关照，受到怪物伤害减少。",
		TMtype = 2,
	},
	[9] = { 
		xls_id = 9,
		attDesc = "生命值+130.魔法值+130",
		attr = {
			[1] = {
				[1] = 1,
				[2] = 130,
			},
			[2] = {
				[1] = 2,
				[2] = 130,
			},
		},
		name = "书香门第",
		fontDesc = "承载家族文脉，身心俱修，生命与魔法之力获得增幅。",
		TMtype = 2,
	},
	[10] = { 
		xls_id = 10,
		attDesc = "双防上限+3%",
		attr = {
			[1] = {
				[1] = 213,
				[2] = 3,
			},
			[2] = {
				[1] = 214,
				[2] = 3,
			},
		},
		name = "不动如山",
		fontDesc = "如山岳般稳固，防御力无懈可击，双防小幅提升。",
		TMtype = 2,
	},
	[11] = { 
		xls_id = 11,
		attDesc = "忽视防御+3%",
		attr = {
			[1] = {
				[1] = 28,
				[2] = 3,
			},
		},
		name = "鹰眼",
		fontDesc = "锐利如鹰的目光，洞悉敌人弱点。",
		TMtype = 2,
	},
	[12] = { 
		xls_id = 12,
		attDesc = "杀怪经验+10%",
		attr = {
			[1] = {
				[1] = 203,
				[2] = 10,
			},
		},
		name = "武道世家",
		fontDesc = "传承武道精髓，修行有成，击败怪物经验增加。",
		TMtype = 2,
	},
	[13] = { 
		xls_id = 13,
		attDesc = "全属性增加30-30",
		attr = {
			[1] = {
				[1] = 1,
				[2] = 30,
			},
			[2] = {
				[1] = 4,
				[2] = 30,
			},
			[3] = {
				[1] = 10,
				[2] = 30,
			},
		},
		name = "灵光一闪",
		fontDesc = "瞬间顿悟，智慧与力量骤增，全属性小幅提升。",
		TMtype = 2,
	},
	[14] = { 
		xls_id = 14,
		attDesc = "攻击增加0-20，暴击率+4%",
		attr = {
			[1] = {
				[1] = 4,
				[2] = 20,
			},
			[2] = {
				[1] = 21,
				[2] = 4,
			},
		},
		name = "猎杀者",
		fontDesc = "精准如猎人，攻击力增强，暴击率提升。",
		TMtype = 2,
	},
	[15] = { 
		xls_id = 15,
		attDesc = "每次攻击怪物恢复20点生命值",
		attackType = 3,
		name = "嗜血狂徒",
		buffId = 3000,
		fontDesc = "以战养身，每次攻击怪物汲取生命力，快速恢复体力。",
		TMtype = 1,
	},
	[16] = { 
		xls_id = 16,
		attDesc = "复活后增加15%移动速度.持续5S",
		attackType = 13,
		name = "溜之大吉",
		buffId = 13000,
		fontDesc = "复活后迅捷如风，移动速度激增，快速脱离险境。",
		TMtype = 1,
	},
	[17] = { 
		xls_id = 17,
		attDesc = "对PK值高于100的玩家额外造成50点伤害",
		attackType = 2,
		name = "正义使者",
		buffId = 2000,
		fontDesc = "挥洒正义之力，对恶名昭著的玩家造成额外伤害。",
		TMtype = 1,
	},
	[18] = { 
		xls_id = 18,
		attDesc = "装备回收增加5%",
		attr = {
			[1] = {
				[1] = 216,
				[2] = 5,
			},
		},
		name = "发财喽！",
		fontDesc = "好运加身，装备回收收益增加，财源滚滚而来。",
		TMtype = 2,
	},
	[19] = { 
		xls_id = 19,
		attDesc = "PK时伤害增加5%",
		attr = {
			[1] = {
				[1] = 76,
				[2] = 500,
			},
		},
		name = "打死你个龟孙",
		fontDesc = "这是一句源自江湖的狂妄誓言，蕴含着不可遏制的怒火与决心",
		TMtype = 2,
	},
	[20] = { 
		xls_id = 20,
		attDesc = "狂暴之子",
		value = 233,
		name = "狂暴之子",
		fontDesc = "开启狂暴时额外增加50点攻魔道",
		TMtype = 3,
	},
}
return config
