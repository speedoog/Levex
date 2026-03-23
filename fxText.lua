FxText = function(x,y,txt,c,fnt)
	if fnt == nil then fnt = true end
	if c==nil then c=gWhite end
	local fx = {name = "Text",x = x,y = y,text = txt,c = c}

	fx.tic = function(_,t)
		local e = #_.text
		if _.speed then e = floor(t*_.speed) end
		if fnt then
			local d=gWhite
			PaletteMap(d,c) -- swaps white color with wanted color
			font(_.text:sub(0,e),floor(_.x),floor(_.y),0,6,8,true,1,false)
			PaletteMap(d,d) -- change it back
		else
			print(_.text:sub(0,e),_.x,_.y,_.c)
		end
	end

	return fx
end
