FxImage = function(filename)
	local fx = { name = "Image", cls=false, img={} }
	fx.Init = function(_)
		local f = FS_Open(filename)
		if f==nil then return end

		local nColors = f:Read()
		_.pal0 = {}
		_.pal1 = {}
--		_.pal1[1]={0,0,0}
		for i = 1,nColors,1 do
			local rgb = {f:Read(),f:Read(),f:Read()}
			if i<=16 then
				_.pal0[i] = rgb
			else
				_.pal1[(i&0xF)+1] = rgb
			end
		end
		_.width =f:Read()
		_.height =f:Read()
		local nPix=_.width*_.height
		local bytes=floor((nPix*5)/8)
		local iPix=0
		for i = 0,bytes-1,5 do
			local a=0
			for k = 1,5 do
				local a1 = f:Read()
				a = (a<<8)|a1
			end

			local tmp={}
			for k = 1,8 do
				local c=a&31
				a = a>>5
				table.insert(tmp, c)
				iPix = iPix+1
			end

			for i=#tmp,1,-1 do
				table.insert(_.img,tmp[i])
			end

		end

	end
	fx.start = function(_,t)
		vbank(0)
		PaletteApply(_.pal0)
		vbank(1)
		PaletteApply(_.pal1)
	end
	fx.tic = function(_,t)
		vbank(1)
		cls()

		local ipix=1
		for y=0,_.height-1 do
			for x=0,_.width-1 do
				local v = _.img[ipix]
				if y<136*t and x<240*t then 
					if v<=15 then
						vbank(0)
						pix(x,y,v)
					else
						vbank(1)
						pix(x,y,v+1)
					end
				end
				ipix = ipix+1
			end
		end
	end
	return fx
end
