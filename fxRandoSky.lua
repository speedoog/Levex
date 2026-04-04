FxRandoSky = function()
local fx = { name = "BdrGradient2", c=0, cBlack=Hex2RGB(0), keys={},k=0 }

fx.appendkey=function(_,l,h)
	_:append(l)
	local c=Hex2RGB(h)
	_:append(c[1]*0.25)
	_:append(c[2]*0.25)
	_:append(c[3]*0.25)
end

fx.append=function(_,v)
	_.keys[#_.keys+1]=v
end

fx.Start = function(_)
	_:appendkey(0, 	0)
	_:appendkey(36,	0x453c6b)
	_:appendkey(72,	0x65384b)
	_:appendkey(108,0xb64f3b)
	_:appendkey(143,0xfed01f)

	local bdrColorIdx=13
	poke(0x03FF8,bdrColorIdx)	-- border color index
	PaletteSetColor(bdrColorIdx, 0,0,0)
end

fx.Stop = function(_)
	poke(0x03FF8,fo,0)	-- border colir1
end

fx.tic=function(_,t)
	local fi,fo=3,05
	_.k=ramp(t, fi,_.d-fi-fo,fo)
end

fx.bdr = function(_, row)
	local c,o=0,CatmullRom(_.keys, 3, row)
	poke(gAddPalette+(c*3),   o[1]*_.k)
	poke(gAddPalette+(c*3)+1, o[2]*_.k)
	poke(gAddPalette+(c*3)+2, o[3]*_.k)
end

return fx
end
