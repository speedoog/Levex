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

FxDraw = function(file,parts)
	local fx = { name = "Draw", speed = 100, parts=parts}

	fx.Init = function(_)
		_.scene = FS_LoadScene(file)
	end

	fx.Start = function(_)
		if parts then
			_.ps = CreateParticleSystem()
			_.ps.rate = 200
			_.ps.spread = 2*pi
			_.ps.spd1 = 20
			_.ps.spd2 = 40
			_.ps.rad = 2
		end
	end

	fx.tic = function(_, t)

		local PixTarget = t*_.speed
		local timeRatio=t/_.d

		local iPix = 0
		local bComplete = false
		local bContinue
		local iTotalPix=_.scene.nPix
		for k,item in pairs(_.scene.items) do
			bContinue = true
			item:Init()
			while bContinue do
				if iPix >= PixTarget then
					bComplete = true
					bContinue = false
				else
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
						local xf=lerp(x1,x,k2)
						local yf=lerp(y1,y,k2)
						_.ext = {xf,yf}
						pix(round(xf),round(yf),c)
					end

					local fnPixBase = function(x,y,c)
						_.ext = {x,y}
						pix(x,y,c)
					end

					if _.Hack then 
						bContinue = item:Draw(fnPixHack) > 0
					else
						bContinue = item:Draw(fnPixBase) > 0
					end
				end
			end
			if bComplete then
				break
			end
		end

		-- particles
		if _.ps then
			if _.ext then 
				_.ps.x = _.ext[1]
				_.ps.y = _.ext[2]
			end
			if PixTarget>=iTotalPix then
				_.ps.rate=0
			else
				_.ps.rate = 200
			end
			_.ps:tic(_.dt)
		end

	end

	return fx
end
