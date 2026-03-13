FxSprite = function(x,y)
	local fx = { name = "Sprite", x = x,y = y}
	fx.tic = function(_,t)
		local idx = 0
		if wrap(t,0,1) > 0.5 then idx = 2 end
		spr(idx,_.x,_.y,14,3,0,0,2,2)
	end
	return fx
end
