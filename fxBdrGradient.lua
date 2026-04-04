FxBdrGradient = function(c)
local fx = { name = "BdrGradient", c=c, cBlack=Hex2RGB(0), cTarget=Hex2RGB(0x205080) }

fx.Start = function(_)
-- 	music(0,11,0)
	_.a=_.cBlack
	_.b=_.cTarget
	_.beat=0
end

fx.tic = function(_,t)
	_.a=Hex2RGB(0)
	local fd=0.5
	_.b=ColorBlend(_.cBlack, _.cTarget, ramp(t, fd,_.d-fd*2,fd))
	_.beat=-0.5*cos(ZIKtime*BPS*8*pi)+0.5
		  -0.7*cos(ZIKtime*BPS*4*pi)+0.5
end

fx.bdr = function(_, row)
	local r,mx,k,o=40,143,0
	if row<r then
		k=clamp(remap(row,0,r,1,0)-_.beat*0.3,0,1)
	elseif row>mx-r then
		k=clamp(remap(row,mx-r,mx,0,1)-_.beat*0.3,0,1)
	end

	o=ColorBlend(_.a,_.b, k)
	poke(gAddPalette+(c*3),   o[1])
	poke(gAddPalette+(c*3)+1, o[2])
	poke(gAddPalette+(c*3)+2, o[3])
end

return fx
end
