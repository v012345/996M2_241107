local config = { 
	["G1"] = { 
		xls_id = "G1",
		varTj = "<=",
		number = 125,
		act = "TianXuanZhiRen_RequestOpenUI",
		img = "res/custom/icon/17.png",
	},
	["G10"] = { 
		xls_id = "G10",
		varTj = "==",
		number = 0,
		act = "TianXuanZhiRen_RequestOpenUI",
		img = "res/custom/icon/gon1gneng/baoshi.png",
	},
	["G3"] = { 
		xls_id = "G3",
		varTj = "<=",
		number = 100,
		act = "TopIcon_SyncResponse",
		img = "res/custom/icon/gongn1eng/baoshi.png",
	},
}
return config
