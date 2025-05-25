local config = { 
	[7] = { 
		xls_id = 7,
		skillName = "攻杀剑术",
		effid = 0,
		cost = {
			[1] = {
				[1] = "书页",
				[2] = 20,
			},
			[2] = {
				[1] = "金币",
				[2] = 1000000,
			},
		},
		tips = "<font color='#00ff00' size='16'>攻杀剑术额外附加自身攻击上限35%的真实伤害</font>",
		effectid = 15,
		var = "U194",
	},
	[66] = { 
		xls_id = 66,
		skillName = "开天斩",
		effid = 5602,
		cost = {
			[1] = {
				[1] = "书页",
				[2] = 20,
			},
			[2] = {
				[1] = "金币",
				[2] = 5000000,
			},
		},
		tips = "<font color='#00ff00' size='16'>开天斩命中目标后，使目标5秒内降低20%的防御</font>",
		effectid = 11004,
		var = "U198",
	},
	[25] = { 
		xls_id = 25,
		skillName = "半月弯刀",
		effid = 2504,
		cost = {
			[1] = {
				[1] = "书页",
				[2] = 20,
			},
			[2] = {
				[1] = "金币",
				[2] = 2000000,
			},
		},
		tips = "<font color='#00ff00' size='16'>半月弯刀攻击目标时，有20%的几率使攻击速度+2.持续5秒</font>",
		effectid = 11003,
		var = "U196",
	},
	[12] = { 
		xls_id = 12,
		skillName = "刺杀剑术",
		effid = 1204,
		cost = {
			[1] = {
				[1] = "书页",
				[2] = 20,
			},
			[2] = {
				[1] = "金币",
				[2] = 2000000,
			},
		},
		tips = "<font color='#00ff00' size='16'>刺杀剑术有5%的几率时目标受到的伤害翻倍</font>",
		effectid = 11005,
		var = "U195",
	},
	[26] = { 
		xls_id = 26,
		skillName = "烈火剑法",
		effid = 2604,
		cost = {
			[1] = {
				[1] = "书页",
				[2] = 20,
			},
			[2] = {
				[1] = "金币",
				[2] = 3000000,
			},
		},
		tips = "<font color='#00ff00' size='16'>烈火剑法点燃被击中的目标3秒，没秒减少等同于释放者攻击上限20%的生命</font>",
		effectid = 11001,
		var = "U197",
	},
	[56] = { 
		xls_id = 56,
		skillName = "逐日剑法",
		effid = 6602,
		cost = {
			[1] = {
				[1] = "书页",
				[2] = 20,
			},
			[2] = {
				[1] = "金币",
				[2] = 5000000,
			},
		},
		tips = "<font color='#00ff00' size='16'>逐日剑法击中的目标为玩家时，有35%的几率使其额外减少当前HP10%的生命</font>",
		effectid = 11000,
		var = "U199",
	},
}
return config
