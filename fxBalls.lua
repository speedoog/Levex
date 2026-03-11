FxBalls = function()
	local fx = {
		name = "Balls",
		cls = false,
		scale = 1,
		tic = function(self, t, dt)
			local x,y,c,r
			for i = 0, 10000 do
				x = rand(240) - 1
				y = rand(136) - 1
				if rand() > 0.7 then
					c = 0
				else
					c = pix(x, y - 3 * rand())
				end
				pix(x, y, c)
			end

			for b = 1, 4 do
				for i = 0, 16 do
					x = 120 + 100 * sin(t*5.45 + 1.3 * b)
					y = 68 + 50 * sin(t*6.66 + b)
					r = self.scale * (6 + sin(t *6 + b) * 6)
					circ(x, y, r, b)
				end
			end
		end
	}
	return fx
end
