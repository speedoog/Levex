FxImage = function(filename)
	local fx = { name="Image", pal0={}, l0={}, l1={}, pal1={}}
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
		local bytes=floor((nPix*5)/8)
		local iPix=0
		for i = 0,bytes-1,5 do
			local a=0
			for k = 1,5 do
				local a1 = fStream:Read()
				a = (a<<8)|a1
			end

			local tmp={}
			for k = 1,8 do
				local c=a&31
				a = a>>5
				table.insert(tmp, c)
			end

			for i=#tmp,1,-1 do
				local v = tmp[i]
				if v<=15 then
					_.l0[iPix]=v
				else
					_.l1[iPix] = (v+1)&0xFF
				end
				iPix = iPix+1
			end
		end

	end
	fx.Start = function(_,t)
		vbank(0)
		PaletteApply(_.pal0)
		vbank(1)
		PaletteApply(_.pal1)
	end
	fx.tic = function(_,t)
		vbank(0)
		local bk=14
		poke(gAddBorderCol,bk)
		cls(bk)
		vbank(1)
		cls()

		vbank(0)
		for y=0,_.height-1 do
			local yst=y*_.width
			for x=15,_.width-1 do
				local ipix = yst+x
				local v = _.l0[ipix]
				if v then
					poke4(ipix, v)
				end
			end
		end

		vbank(1)
		for y = 0,_.height-1 do
			local yst = y*_.width
			for x = 15,_.width-1 do
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
