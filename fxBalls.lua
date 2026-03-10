FxBalls = function()
	local fx = {
		name = "Balls",
		cls = false,
		scale = 1,
		tic = function(self, t, dt)
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

			for c = 1, 4 do
				for i = 0, 16 do
					local x, y, r
					x = 120 + 100 * sin(t*5.45 + 1.3 * c)
					y = 68 + 50 * sin(t*6.66 + c)
					r = self.scale * (6 + sin(t *6 + c) * 6)
					circ(x, y, r, c)
				end
			end
		end
	}
	return fx
end
