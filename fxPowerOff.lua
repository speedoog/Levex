CreateFxPowerOff = function()
	local fx = {
		name = "PowerOff",
		cls = false,
		start = function()
		end,
		tic = function(self, t, dt)
			local w,h=gSizeX,gSizeY
			mx = min(40 * t * t * t, h / 2)
			for i = 0, mx do
				line(0, i, w, i, 0)
				line(0, h - i, w, h - i, 0)
			end
			line(0, mx, w, mx, 12)
			line(0, h - mx, w, h - mx, 12)
		end
	}
	return fx
end
