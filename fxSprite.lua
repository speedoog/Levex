CreateFxSprite = function(x, y)
	local fx = {
		name = "Sprite",
		x = x,
		y = y,
		c = c,
		start = function()
		end,
		tic = function(self, t, dt)
			local isp=0
			if wrap(t,0,1)>0.5 then isp=2 end
			spr(isp,self.x,self.y,14,3,0,0,2,2)
		end
	}
	return fx
end
