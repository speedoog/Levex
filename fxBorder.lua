FxBorderLoading = function(c)
	local fx = { name = "Border", Start = function(_) poke(gAddBorderCol,c) end }
	fx.bdr = function(_, row)
		if row%2==0 then 
			poke(gAddPalette+(c*3), rand(256))
			poke(gAddPalette+(c*3)+1, rand(256))
			poke(gAddPalette+(c*3)+2, rand(256))
		end
	end
	return fx
end

FxBorderStop = function(c)
	return { name = "Border", Stop = function(_) poke(gAddBorderCol,c) end }
end
