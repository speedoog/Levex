FxSprite = function(x,y)
	local fx = {
		name = "Sprite",
		x = x,
		y = y,
		c = c,
		tic = function(_,t)
			local isp = 0
			if wrap(t,0,1) > 0.5 then isp = 2 end
			spr(isp,_.x,_.y,14,3,0,0,2,2)
		end
	}
	return fx
end
