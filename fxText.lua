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
		tic = function(_, t)
			local e=#_.text
			if speed then e=floor(t*speed) end
			if fnt then
				font(_.text:sub(0,e), floor(_.x), floor(_.y), 0, 6, 8, true, 1, false)
			else
				print(_.text:sub(0,e), _.x, _.y, _.c)
			end
		end
	}
	return fx
end
