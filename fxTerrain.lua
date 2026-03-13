FxTerrain = function()
	local _Distance = 1024
	local _DistanceMask = 1024-1
	local fx = {
		name = "Terrain",
		cls = false,
		alt = 32,
		mul = 9,
		hi = 0.5,
		map = {},
		GetMapValue = function(_,x,y) return _.map[(x&_DistanceMask)+(y&_DistanceMask)*_Distance+1] end,
		SetMapValue = function(_,x,y,v) _.map[(x&_DistanceMask)+(y&_DistanceMask)*_Distance+1] = v end,
		Surface = function(_,u,v) return 1-_:GetMapValue(floor(u*_Distance),floor(v*_Distance))*_.mul end,
		--		SurfaceOG = function(_, u, v)		local I = _:GetMapValue(floor(u * _Distance), floor(v * _Distance)) return 1 - I * I * _.mul end,
		--		Surface = function(_, u, v)			return (1.2*sin(19*u)*cos(19*v)+(sin(11*u)*cos(11*v)))* _.mul/9 end,
		--		Surface = function(_, u, v)			return u*v end,
	}

	fx.Init = function(_)
		seed(1)
		local _Random = function()
			return (2*rand()-1)
		end

		_.map = {}
		for i = 0,_Distance*_Distance do
			_.map[i+1] = 0
		end

		local l,T = .5,_Distance
		while T > 1 do
			l = l/2
			T = T/2
			local M = T/2
			if M < 1 then
				M = 1
			end
			for j = 0,_Distance-1,T do
				for i = 0,_Distance-1,T do
					local w = _:GetMapValue(i,j)
					local x = _:GetMapValue(i+T,j)
					local y = _:GetMapValue(i,j+T)
					local z = _:GetMapValue(i+T,j+T)
					_:SetMapValue(i+M,j,(w+x)/2+_Random()*l)
					_:SetMapValue(i+M,j+T,(y+z)/2+_Random()*l)
					_:SetMapValue(i,j+M,(w+y)/2+_Random()*l)
					_:SetMapValue(i+T,j+M,(x+z)/2+_Random()*l)
					_:SetMapValue(i+M,j+M,(w+x+y+z)/4+_Random()*l)
				end
			end
		end

		for j = 0,_Distance-1 do
			for i = 0,_Distance-1 do
				local x = _:GetMapValue(i,j)
				_:SetMapValue(i,j,x*x)
			end
		end
	end

	fx.start = function(_)
		_.hi = 0.5
	end

	fx.tic = function(_,t,dt)
		local border = 0

		local a_x = 0+border
		local a_y = 0+border
		local size_x = 240-border*2
		local size_y = 136-border*2

		local s_x = a_x
		local s_y = a_y
		local e_x = size_x
		local e_y = size_y

		local h
		local ox = .025*sin(t*.44)+.09*t

		h = 10
		for d = 0,1.5,0.05 do
			h = min(h,_:Surface(.5+ox+.05*sin(30*d),(t+d)*.3)-.25+.15*cos(5+t*1.33))
		end

		_.hi = lerp2(_.hi,h,0.2,max(0,dt))

		local matrixSize = 8
		local matrixMask = 7
		local mat_max = matrixSize*matrixSize-1

		local iFrame = floor(t*60)
		for i = iFrame&1,size_x,2 do
			s_x = a_x+i
			e_x = a_x+i

			e_y = size_y+a_y
			s_y = size_y+a_y

			local w = (i/size_x)*2-1

			---			for j = 40+.5*(iFrame&3), 350,0 do
			local inc = 1
			local j = 0+.5*(iFrame&3)
			while j < 350 do
				j = j+inc
				local _z = j/500.
				local z = _z*_z*500

				local x = w*z
				local u = x/200+.5+ox
				local v = z/200+t*.3

				local l = _:Surface(u,v)

				local y = (l-_.hi)*_.alt

				-- TODO remplace by table from catmullrom curve
				if l > 0.9 then
					inc = remap(l,0.9,1,1.5,3)
				elseif l > 0.0 then
					inc = remap(l,0,0.9,.5,1.5)
				else
					inc = 0.5
				end

				-- if y<16 then inc = 0.5 else inc=4 end

				s_y = floor(a_y+size_y*(y/(z+.1)+.25))

				if s_y < a_y then
					s_y = a_y
				end

				if (s_y < e_y) then
					local I = l-0.96*_:Surface(u+.01,v+.005)+.02
					--					I = I * sign(I) * 30 + .2
					--O=1.0-exp(-z*3e-4);
					-- o_x = L(o_x,.6,2);
					-- o_y = L(o_y,.25,4);
					-- o_z = L(o_z,.15,10);

					--d->AddLine(s,e,ImColor(o));

					local color = clamp(I*12*30*clamp(6/z,0,1),0,15)
					local icolor = floor(color)
					local fColorPart = mat_max*(color-icolor)
					local bayer_x = Bayer8x8[(s_x&matrixMask)+1]
					for iy = s_y,e_y do
						local threshold = bayer_x[(iy&matrixMask)+1]
						if fColorPart > threshold then
							pix(s_x,iy,color+1)
						else
							pix(s_x,iy,color)
						end
					end
					--					line(s_x,s_y,e_x,e_y, color)
					--rect(s_x, s_y, 2, e_y - s_y + 1, color)

					e_y = s_y
				end
			end
			line(s_x,e_y,e_x,a_y,0)
		end
	end

	return fx
end
