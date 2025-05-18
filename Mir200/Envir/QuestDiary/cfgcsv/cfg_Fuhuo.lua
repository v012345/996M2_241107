local config = {
	[1] = {
		Map = "n3",
		X = 330,
		Y = 330,
		Time = 20,
		Countdown = 5,
		Pay = {
			[1] = {
				[1] = "灵符",
				[2] = 50,
			},
		},
		onlyBack = {
			[1] = "dld",
			[2] = "yiyu",
			[3] = 3,
			[4] = "h0150",
		},
		Text = "<font color='#00FF00'>你被</font><font color='#FF0000'>[%s]</font><font color='#00FF00'>击败，君子报仇，十年不晚</font>",
		Mail = {
			[1] = 89,
			[2] = 91,
		},
	},
}
return config