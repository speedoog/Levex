FxText = function(x, y, txt, c, speed, fnt, cls)
	if cls==nil then cls=true end
	if fnt==nil then fnt=true end
	local fx = {
		name = "Text",
		x = x,
		y = y,
		text = txt,
		c = c,
		cls=cls,
		tic = function(self, t, dt)
			local e=#self.text
			if speed then e=floor(t*speed) end
			if fnt then
				font(self.text:sub(0,e), floor(self.x), floor(self.y), 0, 6, 8, true, 1, false)
			else
				print(self.text:sub(0,e), self.x, self.y, self.c)
			end
		end
	}
	return fx
end
