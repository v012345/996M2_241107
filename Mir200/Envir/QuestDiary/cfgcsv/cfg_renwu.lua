local config = {
	[1] = {
		Type = 1,
		Reward = 7600005,
		CompleteType = 1,
		CompleteNpc = 210,
		NextTask = {
			[1] = 2,
			[2] = 1000,
		},
		AutoTouchFinish = 1,
	},
	[2] = {
		Type = 1,
		Target = {
			[1] = 1,
		},
		Reward = 7600006,
		CompleteType = 3,
		NextTask = {
			[1] = 3,
		},
	},
	[3] = {
		Type = 1,
		Target = {
			[1] = 2,
		},
		Reward = 7600010,
		CompleteType = 3,
		NextTask = {
			[1] = 4,
		},
	},
	[4] = {
		Type = 1,
		Target = {
			[1] = 3,
		},
		Reward = 7600006,
		CompleteType = 3,
		NextTask = {
			[1] = 2000,
			[2] = 3000,
		},
	},
	[1000] = {
		Type = 2,
		Target = {
			[1] = 8,
		},
		Reward = 7600007,
		CompleteType = 3,
		NextTask = {
			[1] = 1001,
		},
	},
	[1001] = {
		Type = 2,
		Target = {
			[1] = 7,
		},
		Reward = 7600008,
		CompleteType = 3,
		NextTask = {
			[1] = 1002,
		},
	},
	[1002] = {
		Type = 2,
		Target = {
			[1] = 6,
		},
		Reward = 7600009,
		CompleteType = 3,
		NextTask = {
			[1] = 1003,
		},
	},
	[1003] = {
		Type = 2,
		Target = {
			[1] = 5,
		},
		Reward = 7600006,
		CompleteType = 3,
		NextTask = {
			[1] = 1004,
		},
	},
	[1004] = {
		Type = 2,
		Target = {
			[1] = 4,
		},
		Reward = 7600006,
		CompleteType = 3,
		NextTask = {
			[1] = 1005,
			[2] = 4000,
			[3] = 5000,
		},
	},
	[1005] = {
		Type = 2,
		Target = {
			[1] = 9,
		},
		Reward = 7600006,
		CompleteType = 3,
	},
	[4000] = {
		Type = 5,
		Target = {
			[1] = 10,
		},
		Reward = 7600006,
		CompleteType = 3,
	},
	[5000] = {
		Type = 6,
		Target = {
			[1] = 11,
		},
		Reward = 7600006,
		CompleteType = 3,
	},
	[2000] = {
		Type = 3,
		Target = {
			[1] = 100,
		},
		CompleteType = 2,
		NextTask = {
			[1] = 2001,
		},
	},
	[2001] = {
		Type = 3,
		Target = {
			[1] = 101,
		},
		CompleteType = 2,
		NextTask = {
			[1] = 2002,
		},
	},
	[2002] = {
		Type = 3,
		Target = {
			[1] = 102,
		},
		CompleteType = 2,
		NextTask = {
			[1] = 2003,
		},
	},
	[2003] = {
		Type = 3,
		Target = {
			[1] = 103,
		},
		CompleteType = 2,
		NextTask = {
			[1] = 2004,
		},
	},
	[2004] = {
		Type = 3,
		Target = {
			[1] = 104,
		},
		CompleteType = 2,
		NextTask = {
			[1] = 2005,
		},
	},
	[2005] = {
		Type = 3,
		Target = {
			[1] = 105,
		},
		CompleteType = 2,
		NextTask = {
			[1] = 2006,
		},
	},
	[2006] = {
		Type = 3,
		Target = {
			[1] = 106,
		},
		CompleteType = 2,
		NextTask = {
			[1] = 2007,
		},
	},
	[2007] = {
		Type = 3,
		Target = {
			[1] = 107,
		},
		CompleteType = 2,
		NextTask = {
			[1] = 2008,
		},
	},
	[2008] = {
		Type = 3,
		Target = {
			[1] = 108,
		},
		CompleteType = 2,
		NextTask = {
			[1] = 2009,
		},
	},
	[2009] = {
		Type = 3,
		Target = {
			[1] = 109,
		},
		CompleteType = 2,
		NextTask = {
			[1] = 2010,
		},
	},
	[2010] = {
		Type = 3,
		Target = {
			[1] = 110,
		},
		CompleteType = 2,
		NextTask = {
			[1] = 2011,
		},
	},
	[2011] = {
		Type = 3,
		Target = {
			[1] = 111,
		},
		CompleteType = 2,
		NextTask = {
			[1] = 2012,
		},
	},
	[2012] = {
		Type = 3,
		Target = {
			[1] = 112,
		},
		CompleteType = 2,
		NextTask = {
			[1] = 2013,
		},
	},
	[2013] = {
		Type = 3,
		Target = {
			[1] = 113,
		},
		CompleteType = 2,
		NextTask = {
			[1] = 2014,
		},
	},
	[2014] = {
		Type = 3,
		Target = {
			[1] = 114,
		},
		CompleteType = 2,
		NextTask = {
			[1] = 2015,
		},
	},
	[2015] = {
		Type = 3,
		Target = {
			[1] = 115,
		},
		CompleteType = 2,
		NextTask = {
			[1] = 2016,
		},
	},
	[2016] = {
		Type = 3,
		Target = {
			[1] = 116,
		},
		CompleteType = 2,
		NextTask = {
			[1] = 2017,
		},
	},
	[2017] = {
		Type = 3,
		Target = {
			[1] = 117,
		},
		CompleteType = 2,
	},
	[3000] = {
		Type = 4,
		Target = {
			[1] = 200,
		},
		CompleteType = 2,
		NextTask = {
			[1] = 3001,
		},
	},
	[3001] = {
		Type = 4,
		Target = {
			[1] = 201,
		},
		CompleteType = 2,
		NextTask = {
			[1] = 3002,
		},
	},
	[3002] = {
		Type = 4,
		Target = {
			[1] = 202,
		},
		CompleteType = 2,
		NextTask = {
			[1] = 3003,
		},
	},
	[3003] = {
		Type = 4,
		Target = {
			[1] = 203,
		},
		CompleteType = 2,
		NextTask = {
			[1] = 3004,
		},
	},
	[3004] = {
		Type = 4,
		Target = {
			[1] = 204,
		},
		CompleteType = 2,
		NextTask = {
			[1] = 3005,
		},
	},
	[3005] = {
		Type = 4,
		Target = {
			[1] = 205,
		},
		CompleteType = 2,
		NextTask = {
			[1] = 3006,
		},
	},
	[3006] = {
		Type = 4,
		Target = {
			[1] = 206,
		},
		CompleteType = 2,
		NextTask = {
			[1] = 3007,
		},
	},
	[3007] = {
		Type = 4,
		Target = {
			[1] = 207,
		},
		CompleteType = 2,
		NextTask = {
			[1] = 3008,
		},
	},
	[3008] = {
		Type = 4,
		Target = {
			[1] = 208,
		},
		CompleteType = 2,
		NextTask = {
			[1] = 3009,
		},
	},
	[3009] = {
		Type = 4,
		Target = {
			[1] = 209,
		},
		CompleteType = 2,
		NextTask = {
			[1] = 3010,
		},
	},
	[3010] = {
		Type = 4,
		Target = {
			[1] = 210,
		},
		CompleteType = 2,
		NextTask = {
			[1] = 3011,
		},
	},
	[3011] = {
		Type = 4,
		Target = {
			[1] = 211,
		},
		CompleteType = 2,
		NextTask = {
			[1] = 3012,
		},
	},
	[3012] = {
		Type = 4,
		Target = {
			[1] = 212,
		},
		CompleteType = 2,
		NextTask = {
			[1] = 3013,
		},
	},
	[3013] = {
		Type = 4,
		Target = {
			[1] = 213,
		},
		CompleteType = 2,
		NextTask = {
			[1] = 3014,
		},
	},
	[3014] = {
		Type = 4,
		Target = {
			[1] = 214,
		},
		CompleteType = 2,
		NextTask = {
			[1] = 3015,
		},
	},
	[3015] = {
		Type = 4,
		Target = {
			[1] = 215,
		},
		CompleteType = 2,
		NextTask = {
			[1] = 3016,
		},
	},
	[3016] = {
		Type = 4,
		Target = {
			[1] = 216,
		},
		CompleteType = 2,
		NextTask = {
			[1] = 3017,
		},
	},
	[3017] = {
		Type = 4,
		Target = {
			[1] = 217,
		},
		CompleteType = 2,
	},
}
return config