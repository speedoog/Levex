
function ComputeTotalPix(scene)
	scene.npix = 0
	for k,item in pairs(scene.items) do
		item:Init()
		item.npix = 0
		local iPix = 1
		while iPix > 0 do
			iPix = item:Draw()
			item.npix = item.npix+iPix
		end
		scene.npix = scene.npix+item.npix
	end
end


FxDraw = function(file)
	local fx = { name = "Draw", speed = 100}

	fx.Init = function(self)
		self.scene = FS_LoadScene(file)
	end

	fx.tic = function(_, t)
		local PixTarget = t*_.speed

		local iPix = 0
		local bComplete = false
		local bContinue
		for k, item in pairs(_.scene.items) do
			bContinue = true
			item:Init()
			while bContinue do
				iPix = iPix + 1
				bContinue =item:Draw(function(x, y, c) pix(x, y, c) end) > 0
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
