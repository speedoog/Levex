
function DrawCrosshair(mx, my)
	local max = 2
	local min = 1
	local color = gWhite
	line(mx-max, my, mx-min, my, color)
	line(mx+min, my, mx+max, my, color)
	line(mx, my-max, mx, my-min, color)
	line(mx, my+min, mx, my+max, color)
end


function plotCubicBezier(x0,y0,x1,y1,x2,y2,x3,y3)
--	DrawCrosshair(x0,y0)
--	DrawCrosshair(x1,y1)
--	DrawCrosshair(x2,y2)
--	DrawCrosshair(x3,y3)
	local xa, ya = cubicBezier2(0,x0,y0,x1,y1,x2,y2,x3,y3)
	local c=0
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

function plotBeziers(t)
	local l=min(t/10,0.5)
	l=l+0.25*sin(t)
	plotbidule(t,l)
	plotbidule(t+1,l)
	plotbidule(t+2,l)
	plotbidule(t+3,l)
end

coefs = {
    { -1, 2,-1, 0},
    {  3,-5, 0, 2},
    { -3, 4, 1, 0},
    {  1,-1, 0, 0} }

-- CatmullRom https://iquilezles.org/articles/minispline/

function CatmullRom(keys, dim, t)
	-- init result
	local v = {}			-- out
	for i=1,dim do
		v[i] = 0
	end

    local size = dim + 1;
	local num =floor(#keys/size)

    -- find key
    local k = 0
	while k<num and keys[1+k*size]<t do
		k=k+1;
	end

    -- interpolant
    local h
	if k<=0 then
		h=0
	elseif k>=num then
		h=1
	elseif k>0 then
	 	h=(t-keys[1+(k-1)*size])/(keys[1+k*size]-keys[1+(k-1)*size])
	end

    -- add basis functions
    for i=1,4 do
        local kn = k+i-3;
		if kn<0 then
			kn=0
		elseif kn>(num-1) then
			kn=num-1
		end
		
		local co=coefs[i]
        local b = 0.5*(((co[1]*h + co[2])*h + co[3])*h + co[4]);
        for j=1,dim do
			v[j] = v[j]+ b*keys[kn*size+j+1]
		end
    end
	return v
end

-- ############## FX Bezier ##############
fxBeziers={
	name = "Beziers"
	, start = function()	end
	, tic = function(self,t,dt)
--		plotBeziers(t)

		local x0=20+t*sin(t*1.23)
		local y0=50+t*cos(t*1.07)
		local x1=100+60*sin(t*1.74)
		local y1=70+60*cos(t*1.03)
		local x2=100+60*sin(t*1.14)
		local y2=70+60*cos(t*1.63)
		local x3=gSizeX-20+60*sin(t*1.44)
		local y3=70+60*cos(t*1.33)

		local spline ={0,x0,y0,1,x1,y1,2,x2,y2,3,x3,y3}
		
		local v,xa,ya,xb,yb
		local t=0
		local c=0
		while t<=4 do
			v = CatmullRom(spline, 2, t)
			xb, yb =v[1],v[2]
			if xa~=nil then
				line(xa,ya,xb,yb,c%8+1)
			end
			t=t+0.1;xa=xb;ya=yb;c=c+1
		end
		
		DrawCrosshair(x0,y0)
		DrawCrosshair(x1,y1)
		DrawCrosshair(x2,y2)
		DrawCrosshair(x3,y3)
		
	end
}
