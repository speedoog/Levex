FxColorRemplace = function(c1, c2)
	local fx = { name = "ColorRemplace", cls=false }
	fx.start = function(_)
		for y=0,gSizeY do
			for x=0,gSizeX do
				if pix(x,y)==c1
					then pix(x,y,c2)
				end
			end
		end
	end
	return fx
end
