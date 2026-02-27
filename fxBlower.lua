FxBlower = function()
	local fx = {
		name = "Blower",
		start = function()
		end,
		tic = function(self, t, dt)
			local s = t * .6
			local t = (t / .15) % 10
			local a = 0
			for z = 0, 100, .1 do
				a = a + 2.5
				local z_ = (z + 20 * t)
				local x = s * sin(a + t) * z_
				local y = s * cos(a + t) * z_
				circ(x + gSizeX / 2, y + gSizeY / 2, z / 40, z)
			end
		end
	}
	return fx
end
