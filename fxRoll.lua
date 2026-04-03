FxRoll = function()
	local fx = {name = "Roll", r0=10,r1=3 }

	fx.Start = function(_)
		vbank(0)
		_.pal0 = PaletteCapture()
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

--		t=t+sin(t*2.5)

--		_.k=remap(t,0,10,-1,1)

		local unroll=false
		if _.k<0 then
			unroll = true
			_.r=remap(_.k,-1,0,_.r0,_.r1)
			_.center = remap(_.k,-1,0,-_.r-5, gSizeY+_.r+5)
		else
			unroll = false
			_.r = remap(_.k,0,1,_.r1,_.r0)
			_.center = remap(_.k,0,1,-_.r-5, gSizeY+_.r+5)
		end

--		_.center = t*45-_.r-5
--		_.center = 50 _.r=_.r0

		_.liney = {}
		_.linex = {}
		_.linek = {}

		_.rollfull = 2*pi*_.r
		local rollpart = 0.75*_.rollfull
		local maxx=6
		_.dx = min(0.4*_.r,maxx/2)

		if unroll then
			for row = 0,gSizeY-1 do
				if row < _.center then
					_.linek[row] = 1
				elseif row <= (_.center+rollpart) then
					_:FillLine(row)
				end
			end
		else
			for row = gSizeY-1,0,-1 do
				if row >= _.center then
					_.linek[row] = 1
				elseif row >= (_.center-rollpart) then
					_:FillLine(row)
				end
			end
		end
	end

	fx.FillLine=function(_,row)
		local f = ((row-_.center)/_.rollfull)
		local a = f*2*pi
		local oy = _.r*sin(a)
		local l = round(_.center+oy)
		if l >= 0 then
			_.liney[l] = row
			_.linex[l] = round(-_.dx*(cos(a)-1))
			if abs(f)<0.2 then
				_.linek[l] = 1
			else
				_.linek[l] = 1.5-abs(1.4*cos(a-pi/2))
			end
		end
	end

	fx.bdr = function(_,row)

		row = row-4 --TOP BORDER
		if row<0 or _.linex==nil then return end

		local ox = 0
		local ix = _.linex[row]
		if ix then
			ox = ix
		end

		local oy = 0
		local iy=_.liney[row]
		if iy then
			oy = iy-row
		end

		local ok = 0
		local ik = _.linek[row]
		if ik then
			ok = ik
		end

		
		vbank(0)
		poke(gAddScreenOffX,ox)
		poke(gAddScreenOffY,oy)

		local pal0
		if ok==0 then
			pal0=gPal.black
		elseif ok<=1 then
			pal0 = PaletteBlend(gPal.black,_.pal0,ok)
		else
			pal0 = PaletteBlend(_.pal0,gPal.white,ok-1)
			pal0[1]={0,0,0}
		end
		PaletteApply(pal0)
		
		vbank(1)
		poke(gAddScreenOffX,ox)
		poke(gAddScreenOffY,oy)

		local pal1
		if ok==0 then
			pal1=gPal.black
		elseif ok<=1 then
			pal1 = PaletteBlend(gPal.black,_.pal1,ok)
		else
			pal1 = PaletteBlend(_.pal1,gPal.white,ok-1)
		end
		PaletteApply(pal1)
	end

	return fx
end
