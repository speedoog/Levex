FxBlower = function()
	local fx = { name = "Blower" }

	fx.tic = function(_, t)
		local s = t * .6
		local t2 = (t / .15) % 10
		local a = 0
		for i = 0, 100, .1 do
			a = a + 2.5
			local z2 = (i + 20 * t2)
			local x = s * sin(a + t2) * z2
			local y = s * cos(a + t2) * z2
			circ(x + gSizeX2, y + gSizeY2, i / 40, i)
		end
	end

	return fx
end
