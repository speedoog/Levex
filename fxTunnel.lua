FxTunnel = function()
	local fx = { name = "Tunnel" }

	fx.tic = function(_, t)
		local w2=gSizeX2
		local h2=gSizeY2
		local inc=1
		for x = 10,gSizeX-10,inc do
			for y = 5,gSizeY-5,inc do
				local x_,y_,z_,zmax,z,ax,ay
				x_=x-w2
				y_=y-h2
				ax = abs(x_)
				ay = abs(y_)

				if (ax>15 or ay>15) and ax~=ay then
					zmax=max(ax,ay)
					z=100/zmax
					z_=z+4*t
					if ax>ay then
						seed(floor(3*z_)*floor(5*y_/x_)*37)
					else
						seed(floor(3*z_)*floor(5*x_/y_)*17)
					end

					if z<10 and rand()>max(0.91+0.1*cos(z_/24),0.9) then
						local rc = zmax/12
						if rc>=0 and rc<=15 then
							local c = floor(rc)
							local k=rc-c
							if Bayer8x8:IsAbove(k,x,y) then
								c=c+1
							end
							pix(x,y,c)
						end
					end
				end
			end
		end
	end

	return fx
end
