

function plotCubicBezier(x0,y0,x1,y1,x2,y2,x3,y3)
--	DrawCrosshair(x0,y0)
--	DrawCrosshair(x1,y1)
--	DrawCrosshair(x2,y2)
--	DrawCrosshair(x3,y3)
	xa, ya = cubicBezier2(0,x0,y0,x1,y1,x2,y2,x3,y3)
	c=0
	local t=0
	while t<=1 do
		t=t+0.05
		xb=xa
		yb=ya
		xa, ya = cubicBezier2(t,x0,y0,x1,y1,x2,y2,x3,y3)
		line(xa,ya,xb,yb,c%8+1)
		c=c+1
	end
end

function plotbidule(t,l)
	local x0,x1,x2,x3,y0,y1,y2,y3
	x0=-20+t*sin(t*1.23)
	y0=50+t*cos(t*1.07)
	x1=100+60*sin(t*1.74)
	y1=70+60*cos(t*1.03)
	x2=100+60*sin(t*1.14)
	y2=70+60*cos(t*1.63)
	x3=gSizeX-20+60*sin(t*1.44)
	y3=70+60*cos(t*1.33)
	plotCubicBezier(x0,y0, x1*l,y1, x2*l,y2, x3*l,y3)
end

-- ############## FX Bezier ##############
fxBeziers={
	init = function()
	end
	, tic = function(self,t)
		local l=t/5
		plotbidule(t,l)
		plotbidule(t+1,l)
		plotbidule(t+2,l)
		plotbidule(t+3,l)
	end
}
