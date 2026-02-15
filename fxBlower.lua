fxBlower = {
    name = "Blower",
    start = function() end,
    tic = function(self, t, dt)
		s=t*.6
		t=(t/.15)%10

        a = 0
        for z = 0, 100, .1 do
            a = a + 2.5
            z_ = (z + 20 * t)
            x = s * sin(a + t) * z_
            y = s * cos(a + t) * z_
            circ(x + gSizeX / 2, y + gSizeY / 2, z/40, z)
        end
    end
}
