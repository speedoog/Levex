FxRoll = function()
	local fx = {name = "Roll" }

	fx.Start = function(_)
		vbank(0)
		_.pal0 = PaletteCapture()
		_.pal0[15]={0,0,0}
		vbank(1)
		_.pal1 = PaletteCapture()
	end

	fx.Stop = function(_)
		vbank(0)
		poke(gAddScreenOffX,0)
		poke(gAddScreenOffY,0)
		PaletteApply(_.pal0)
		vbank(1)
		poke(gAddScreenOffX,0)
		poke(gAddScreenOffY,0)
		PaletteApply(_.pal1)
	end

	fx.tic = function(_,t)

		t=t+sin(t*2.5)
--		t=4*sin(t)

		_.r=remap(t,0,3,12,4)

		_.center = 50
		_.center = t*45-_.r-5

		_.liney = {}
		_.linex = {}
		_.linek = {}

		local rollfull = 2*pi*_.r
		local rollpart = 0.75*rollfull
		for row = 0,gSizeY-1 do

			if row < _.center then
				_.linek[row] = 0
				_.liney[row] = row
			elseif row<=(_.center+rollpart) then
				local f = ((row-_.center)/rollfull)
				local a = f*2*pi
				local oy = _.r*sin(a)
				local l=round(oy+_.center)
				_.liney[l] = row
				_.linex[l] = -(_.r/1.8)*(cos(a)-1)
				_.linek[l] = abs(cos(a-pi/2))
			end
		end
	end

	fx.bdr = function(_,row)

		row = row-4 --TOP BORDER
		if row<0 then return end

		local ox = 0
		local ix = _.linex[row]
		if ix then
			ox = ix
		end

		local oy = 135-row
		local iy=_.liney[row]
		if iy then
			oy = clamp(iy-row,0,135)
		end

		local ok = 0
		local ik = _.linek[row]
		if ik then
			ok = ik
		end

		local pal0 = PaletteBlend(_.pal0,gPalettes.black,ok*0.85)
		local pal1 = PaletteBlend(_.pal1,gPalettes.black,ok*0.85)

		vbank(0)
		poke(gAddScreenOffX,ox)
		poke(gAddScreenOffY,oy)
		if ik then
			PaletteApply(pal0)
		else
			PaletteApply(gPalettes.black)
		end

		vbank(1)
		poke(gAddScreenOffX,ox)
		poke(gAddScreenOffY,oy)
		if ik then
			PaletteApply(pal1)
		else
			PaletteApply(gPalettes.black)
		end
	end

	return fx
end
