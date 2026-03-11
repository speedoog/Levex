FxBorder = function(c)
	local fx = {
		name = "Border",
		cls=false,
		start = function(_)
			poke(gAddBorderCol,c)		-- set border color
		end,
		bdr = function(_, row)
			if row%2==0 then 
				poke(gAddPalette+(c*3), rand(256))
				poke(gAddPalette+(c*3)+1, rand(256))
				poke(gAddPalette+(c*3)+2, rand(256))
			end
		end
	}
	return fx
end
