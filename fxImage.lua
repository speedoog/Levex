FxImage = function()
	local fx = { name = "Image", img={} }
	fx.Init = function(_)
		local f = FS_Open("test.tga")

		local nPix=240*136
		local bytes=floor((nPix*8)/5)
		local iPix=0
		for i=0,f.size,5 do

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
--				poke(i,c)
				iPix = iPix+1
			end

			for i=#tmp,1,-1 do
				table.insert(_.img,tmp[i])
			end

		end

	end
	fx.tic = function(_,t)
		for k,v in pairs(_.img) do
			poke4(k,v)
		end
	end
	return fx
end
