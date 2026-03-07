FxPalette = function(str)
	local fx = {
		name = "Palette",
		start = function(self)
			local pal=PaletteLoadString(str)
			PaletteApply(pal)
		end,
		tic = function(self, t, dt)
		end,
	}
	return fx
end
