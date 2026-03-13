-- ############## FX Bezier ##############
FxBeziers = function()
	local fx = { name = "Beziers" }
	
	fx.tic = function(_,t)
		PlotBeziers(t)

		-- for tt=0,3,0.1 do
		-- 	plotCatmullRom(t+tt)
		-- end
		-- plotCatmullRom(t)
	end

	function PlotCubicBezier(x0,y0,x1,y1,x2,y2,x3,y3)
		local xa,ya,xb,yb = cubicBezier2(0,x0,y0,x1,y1,x2,y2,x3,y3)
		local c = 0
		local t = 0
		while t <= 1 do
			t = t+0.05
			xb = xa
			yb = ya
			xa,ya = cubicBezier2(t,x0,y0,x1,y1,x2,y2,x3,y3)
			line(xa,ya,xb,yb,c%8+1)
			c = c+1
		end
	end

	function PlotCubicBezierMirror(x0,y0,x1,y1,x2,y2,x3,y3)
		PlotCubicBezier(gSizeX-x0,y0,
			gSizeX-x1,y1,
			gSizeX-x2,y2,
			gSizeX-x3,y3)
	end

	function PlotBidule(t,l)
		local x0,x1,x2,x3,y0,y1,y2,y3
		x0 = -20+t*sin(t*1.23)
		y0 = 50+t*cos(t*1.07)
		x1 = 100+60*sin(t*1.74)
		y1 = 70+60*cos(t*1.03)
		x2 = 100+60*sin(t*1.14)
		y2 = 70+60*cos(t*1.63)
		x3 = gSizeX-20+60*sin(t*1.44)
		y3 = 70+60*cos(t*1.33)
		PlotCubicBezier(x0,y0,x1*l,y1,x2*l,y2,x3*l,y3)
		PlotCubicBezierMirror(x0,y0,x1*l,y1,x2*l,y2,x3*l,y3)
	end

	function PlotBeziers(t)
		local l = min(t/10,0.5)
		l = l+0.25*sin(t)
		PlotBidule(t,l)
		PlotBidule(t+1,l)
		PlotBidule(t+2,l)
		PlotBidule(t+3,l)
	end

	-- UNUSED --
	function PlotCatmullRom(t)
		local x0 = 20+t*sin(t*1.23)
		local y0 = 50+t*cos(t*1.07)
		local x1 = 100+60*sin(t*1.74)
		local y1 = 70+60*cos(t*1.03)
		local x2 = 100+60*sin(t*1.14)
		local y2 = 70+60*cos(t*1.63)
		local x3 = gSizeX-20+60*sin(t*1.44)
		local y3 = 70+60*cos(t*1.33)

		local spline = {0,x0,y0,1,x1,y1,2,x2,y2,3,x3,y3}

		local v,xa,ya,xb,yb
		local t = 0
		local c = 0
		while t <= 4 do
			v = CatmullRom(spline,2,t)
			xb,yb = v[1],v[2]
			if xa ~= nil then
				line(xa,ya,xb,yb,c%8+1)
			end
			t = t+0.1
			xa = xb
			ya = yb
			c = c+1
		end

		DrawCrosshair(x0,y0)
		DrawCrosshair(x1,y1)
		DrawCrosshair(x2,y2)
		DrawCrosshair(x3,y3)
	end

	return fx
end
