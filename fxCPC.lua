fxCPC = {
	name = "CPC",
	Text = [[Amstrad 64k Microcomputer (v2)

©1985 Amstrad Consumer Electronics plc
]],
	start = function() end,
	tic = function(self, t, dt)
        cls(0)
		print(self.Text, 0, 0, 4)
	end
}
