local config = {
	["天运丹"] = {
		buffId = 31040,
		time = 30,
		desc = "总爆率",
		addNum = 5,
	},
	["破神丹"] = {
		buffId = 31041,
		time = 5,
		desc = "神力倍攻",
		addNum = 10,
	},
	["阳神丹"] = {
		buffId = 31042,
		attrs = {
			[1] = {
				[1] = 207,
				[2] = 10,
			},
		},
		time = 5,
		desc = "最大生命值",
		addNum = 10,
	},
	["九幽丹"] = {
		buffId = 31043,
		attrs = {
			[1] = {
				[1] = 201,
				[2] = 4,
			},
		},
		time = 30,
		desc = "鞭尸概率",
		addNum = 4,
	},
	["后土丹"] = {
		buffId = 31044,
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
		desc = "伤害吸收",
		addNum = 10,
	},
}
return config