FxStarField = function(c)
local fx = { name = "StarField",stars = {}, starZLimit = 1024 }

fx.AddStar=function(_)
	local starXYLimit = _.starZLimit*gSizeX2
	local star={ rand2(-starXYLimit, starXYLimit),
				 rand2(-starXYLimit, starXYLimit),
				 rand()*_.starZLimit}
	_.stars[#_.stars+1] = star
end

fx.Start = function(_)
	local starXYLimit = _.starZLimit*gSizeX2
	local starCount = 0
	for i = 1, starCount do
		_:AddStar()
	end
end

fx.tic = function(_,t)
	seed(time())
	local starPS = 200
	local starTarget=clamp(t*starPS,0,2000)
	local starDiff=floor(starTarget-#_.stars)

	if starDiff>0 then
		for i=1,starDiff do
			_:AddStar()
		end
	else
		starDiff=-starDiff
		for i=1,starDiff do
			_.stars[#_.stars] = nil
		end
	end
	
	local speed = 500*sqrt(t)
	for i = 1,#_.stars do
		local star=_.stars[i]
		if star then
			local oldZ = star[3]
			local newZ = oldZ - speed*_.dt
			star[3] = newZ > 0 and newZ or _.starZLimit
			--		pix(gSizeX2 + _.stars[i][1]/_.stars[i][3], gSizeY2 + _.stars[i][2]/_.stars[i][3],16-(15*_.stars[i][3])/_.starZLimit)
			
			if star[3]==newZ then
				line(gSizeX2+star[1]/oldZ, gSizeY2+star[2]/oldZ,
				gSizeX2+star[1]/newZ, gSizeY2+star[2]/newZ,
				16-(15*star[3])/_.starZLimit)
			end
		end
	end
end

return fx
end
