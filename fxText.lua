CreateFxText = function(x, y, txt, c, speed,incol)
	local fxText = {
		name = "Text",
		x = x,
		y = y,
		text = txt,
		c = c,
		start = function()
		end,
		tic = function(self, t, dt)
			local e=floor(t*speed)
--			print(self.text:sub(0,e), self.x, self.y, self.c)
			font(self.text:sub(0,e), self.x, self.y, self.c, 6, 8, true, 1, false)

		end
	}
	return fxText
end
