FxTunnel = function()
	local fx = { name = "Tunnel" }

	fx.tic = function(_, t)
		local w2=gSizeX2
		local h2=gSizeY2
		local inc=2
		for x = 0,gSizeX,inc do
			for y = 0,gSizeY,inc do
				local x_,y_,z_,zmax,z,ax,ay
				x_=x-w2
				y_=y-h2
				ax = abs(x_)
				ay = abs(y_)
				zmax=max(ax,ay)
				z=100/zmax
				z_=z+4*t

				if ax>ay then
					seed(floor(2*z_)*floor(4*y_/x_)+35)
				else
					seed(floor(2*z_)*floor(4*x_/y_)+17)
				end

				if z<10 and rand()>max(0.9+0.1*cos(t/6),0.8) then
					pix(x,y,min(zmax/20,2)+1)
				end
			end
		end
	end

	return fx
end
