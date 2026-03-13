FxFadepal = function(paldest,cls)
	if cls==nil then cls = false end
	local fx = { name = "Fadepal", cls=cls }

	fx.start = function(_)
		_.pal = PaletteCapture()
	end

	fx.tic = function(_, t)
		local f=t/_.dur
		local pal={}
		for k,v in pairs(_.pal) do
			pal[k]={}
			pal[k][1] = lerp(v[1],paldest[k][1],f)
			pal[k][2] = lerp(v[2],paldest[k][2],f)
			pal[k][3] = lerp(v[3],paldest[k][3],f)
		end
		PaletteApply(pal)
	end

	return fx
end
