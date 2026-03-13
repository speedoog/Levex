FxPalette = function(str)
	local fx = {name = "Palette"}
	fx.start = function(_)
		PaletteApply(PaletteLoadString(str))
	end
	return fx
end
