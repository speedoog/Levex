


function plotCubicBezier(x0,y0,x1,y1,x2,y2,x3,y3)
--	DrawCrosshair(x0,y0)
--	DrawCrosshair(x1,y1)
--	DrawCrosshair(x2,y2)
--	DrawCrosshair(x3,y3)
	xa, ya = cubicBezier2(0,x0,y0,x1,y1,x2,y2,x3,y3)
	c=0
	for t = 0,1,0.05 do
		xb=xa
		yb=ya
		xa, ya = cubicBezier2(t,x0,y0,x1,y1,x2,y2,x3,y3)
		line(xa,ya,xb,yb,c%8+1)
		c=c+1
	end
end

function plotbidule(t)
	x0=70+t*sin(t*1.23)
	y0=70+t*cos(t*1.07)
	x1=100+60*sin(t*1.74)
	y1=70+60*cos(t*1.03)
	x2=100+60*sin(t*1.14)
	y2=70+60*cos(t*1.63)
	x3=120+60*sin(t*1.44)
	y3=70+60*cos(t*1.33)
	plotCubicBezier(x0,y0, x1,y1, x2,y2, x3,y3)
end


-- ############## FX Bezier ##############
FxBezier={
	init = function()
		t=0
	end
	, tic = function()
		t=t+1/30
		cls()
		plotbidule(t)
		plotbidule(t+1)
		plotbidule(t+2)
		plotbidule(t+3)
		return t>20
	end
}
