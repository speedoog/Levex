function ComputeTotalPix(scene)
	vbank(1)
	cls()
	scene.nPix = 0
	for k,item in pairs(scene.items) do
		item:Init()
		item.nPix = 0
		local iPix = 1
		while iPix > 0 do
			iPix = item:Draw(pix)
			item.nPix = item.nPix+iPix
		end
		scene.nPix = scene.nPix+item.nPix
	end
	cls()
end

FxDraw = function(file)
	local fx = { name = "Draw", speed = 100}

	fx.Init = function(self)
		self.scene = FS_LoadScene(file)
	end

	fx.tic = function(_, t)

		local PixTarget = t*_.speed
		local timeRatio=t/_.dur

		local iPix = 0
		local bComplete = false
		local bContinue
		local iTotalPix=_.scene.nPix
		for k,item in pairs(_.scene.items) do
			bContinue = true
			item:Init()
			while bContinue do
				iPix = iPix+1
				local f = iPix/PixTarget

				local fnPixHack=function(x,y,c)
					local x1 = gSizeX2+gSizeX2*sin(4.121*(t+2*f))
					local y1 = gSizeX2+gSizeY2*cos(3.171*(t+2*f))
					local k2=min(timeRatio+(0.5-f*0.2),1)
					c=2
					if f > 0.90 then c = c+1 end
					if f > 0.95 then c = c+1 end
					if f > 0.98 then c = c+1 end
					pix(round(lerp(x1,x,k2)),round(lerp(y1,y,k2)),c)
			 	end

				if _.Hack then 
					bContinue = item:Draw(fnPixHack) > 0
				else
					bContinue = item:Draw(pix) > 0
				end

				if iPix >= PixTarget then
					bComplete = true
					bContinue = false
				end
			end
			if bComplete then
				break
			end
		end

	end

	return fx
end
