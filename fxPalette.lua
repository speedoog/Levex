FxPalette = function(str)
	local fx = {
		name = "Palette",
		start = function(_)
			local pal=PaletteLoadString(str)
			PaletteApply(pal)
		end
	}
	return fx
end
