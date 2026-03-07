FxFadepal = function(paldest)
	local fx = {
		name = "Fadepal",
		cls=false,
		start = function(self)
			self.pal = PaletteCapture()
		end,
		tic = function(self, t, dt)
			pal={}
			local f=t/self.dur
			for k,v in pairs(self.pal) do
				pal[k]={}
				pal[k][1] = lerp(v[1],paldest[k][1],f)
				pal[k][2] = lerp(v[2],paldest[k][2],f)
				pal[k][3] = lerp(v[3],paldest[k][3],f)
			end
			PaletteApply(pal)
		end
	}
	return fx
end
