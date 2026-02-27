FxText = function(x, y, txt, c, speed,incol)
	local fx = {
		name = "Text",
		x = x,
		y = y,
		text = txt,
		c = c,
		start = function()
		end,
		tic = function(self, t, dt)
			local e=#self.text
			if  speed then e=floor(t*speed) end
--			print(self.text:sub(0,e), self.x, self.y, self.c)
			font(self.text:sub(0,e), floor(self.x), floor(self.y), 0, 6, 8, true, 1, false)

		end
	}
	return fx
end
