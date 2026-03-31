function ComputeTotalPix(scene,clrColor)
	vbank(1)
	cls(clrColor)
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

FxDraw = function(file,speed,parts,full,clrColor)
	if clrColor==nil then clrColor=0 end
	local fx = { name = "Draw", speed = speed, parts=parts}

	fx.Init = function(_)
		_.scene = FS_LoadScene(file,clrColor)
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
		_.echo=false
		_:reset()
	end

	fx.reset=function(_)
		_.iCurItem=0
		_:next()
		_.iPix = 0
	end

	fx.next=function(_)
		_.iCurItem = _.iCurItem+1
		if _.iCurItem <= #_.scene.items then
			_.scene.items[_.iCurItem]:Init()
		end
	end

	fx.tic = function(_, t)

		if _.echo then
			local transform = function(pt,pivot,sc)
				local cx,cy = unpack(pivot)
				return {(pt[1]-cx)*sc+cx,(pt[2]-cy)*sc+cy}
			end
			for it=5,0,-1 do
				local tt = t-_.echot-it*0.05
				if tt<0 then tt=0 end
				local sc = exp(tt*2)
				local pivot={gSizeX2,gSizeY2+20}
				for i,item in pairs(_.scene.items) do
					for i=2,#item.pts do
						local pt1 = transform(item.pts[i-1],pivot,sc)
						local pt2 = transform(item.pts[i],pivot,sc)
						line(pt1[1],pt1[2],pt2[1],pt2[2], item.c+it*0.5)
					end
				end
			end
			return
		end

		if full then
			_:reset()
		end

		local PixTarget = t*_.speed
		local timeRatio=t/_.d

		local bComplete = false
		local bContinue
		local iTotalPix=_.scene.nPix
		--for k,item in pairs(_.scene.items) do
		while _.iCurItem<=#_.scene.items do
			local item = _.scene.items[_.iCurItem]
			bContinue = true

			while bContinue do
				if _.iPix >= PixTarget then
					bComplete = true
					bContinue = false
				else
					_.iPix = _.iPix+1
					local f = _.iPix/PixTarget

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

			_:next()
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
