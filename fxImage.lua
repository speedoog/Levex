FxImage = function(filename)
	local fx = { name="Image", pal0={}, l0={}, l1={}, pal1={}, x0=0, y0=0, x1=gSizeX-1, y1=gSizeY-1}
	fx.Init = function(_)
		local fStream = FS_Open(filename)
		if fStream==nil then return end

		local nColors = fStream:Read()
		for i = 1,nColors,1 do
			local rgb = {fStream:Read(),fStream:Read(),fStream:Read()}
			if i<=16 then
				_.pal0[i] = rgb
			else
				_.pal1[(i&0xF)+1] = rgb
			end
		end
		_.width =fStream:Read()
		_.height =fStream:Read()
		local nPix=_.width*_.height
		for i = 0,nPix-1 do
			local v = fStream:Read()
			if v<=15 then
				_.l0[i]=v
			else
				_.l1[i] = (v+1)&0xFF
			end
		end

		-- temp hack
		_.x0 = 6

	end
	fx.Start = function(_,t)
		vbank(0)
		PaletteApply(_.pal0)
		vbank(1)
		PaletteApply(_.pal1)
	end
	fx.tic = function(_,t)
		vbank(0)
		local bk=0
		poke(gAddBorderCol,bk)
		cls(bk)
		vbank(1)
		cls()

		vbank(0)
		for y=_.y0,_.y1 do
			local yst=y*_.width
			for x=_.x0,_.x1 do
				local ipix = yst+x
				local v = _.l0[ipix]
				if v then
					poke4(ipix, v)
				end
			end
		end

		vbank(1)
		for y=_.y0,_.y1 do
			local yst = y*_.width
			for x=_.x0,_.x1 do
				local ipix = yst+x
				local v = _.l1[ipix]
				if v then
					poke4(ipix,v)
				end
			end
		end

	end
	return fx
end
