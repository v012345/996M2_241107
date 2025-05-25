local config = { 
	["天运丹"] = { 
		xls_id = "天运丹",
		buffId = 31040,
		desc = "总爆率",
		addNum = 5,
		time = 30,
	},
	["阳神丹"] = { 
		xls_id = "阳神丹",
		buffId = 31042,
		desc = "最大生命值",
		addNum = 10,
		attrs = {
			[1] = {
				[1] = 207,
				[2] = 10,
			},
		},
		time = 5,
	},
	["后土丹"] = { 
		xls_id = "后土丹",
		buffId = 31044,
		desc = "伤害吸收",
		addNum = 10,
		attrs = {
			[1] = {
				[1] = 26,
				[2] = 10,
			},
			[2] = {
				[1] = 27,
				[2] = 10,
			},
		},
		time = 5,
	},
	["九幽丹"] = { 
		xls_id = "九幽丹",
		buffId = 31043,
		desc = "鞭尸概率",
		addNum = 4,
		attrs = {
			[1] = {
				[1] = 201,
				[2] = 4,
			},
		},
		time = 30,
	},
	["破神丹"] = { 
		xls_id = "破神丹",
		buffId = 31041,
		desc = "神力倍攻",
		addNum = 10,
		time = 5,
	},
}
return config
