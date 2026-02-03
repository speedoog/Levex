
-- ############## MATHS ##############

sqrt,abs,sin,cos,tan,pi,min,max,floor=math.sqrt,math.abs,math.sin,math.cos,math.tan,math.pi,math.min,math.max,math.floor
rand,seed=math.random,math.randomseed

function remap( x, t1, t2, s1, s2 )
 local f = ( x - t1 ) / ( t2 - t1 )
 return f * ( s2 - s1 ) + s1
end

function clamp(x, l, h)
	if x<l then return l elseif x>h then return h else return x end
end

function lerp(a,b,r)
	return a*(1-r)+b*r
end

function cuberp(a,b,c,d,t)
	local A=d-c-a+b
	local B=a-b-A
	local C=c-a
	local D=b
	local T=t*t
	return A*t*T+B*T+C*t+D
end

function overlap(x,y,x0,x1,y0,y1)
   if x<x0 or x>x1 or y<y0 or y>y1 then return false end
   return true
end

function distance(x0,y0,x1,y1)
	local dx=x0-x1
	local dy=y0-y1
	return sqrt(dx*dx+dy*dy)
end

function rad2deg( r )
	return r/math.pi*180
end

function deg2rad( d )
	return d/180*math.pi
end

function cubicBezier(t, p0, p1, p2, p3)
	return (1 - t)^3*p0 + 3*(1 - t)^2*t*p1 + 3*(1 - t)*t^2*p2 + t^3*p3
end

function cubicBezier2(t,x0,y0,x1,y1,x2,y2,x3,y3)
	return cubicBezier(t,x0,x1,x2,x3),cubicBezier(t,y0,y1,y2,y3)
end

function easeInOutCubic(x)
	if x < 0.5 then
		return 4 * x * x * x
	else
--		return 1 - Math.pow(-2 * x + 2, 3) / 2
		return 1 - ((-2*x+2)^3) / 2
	end
end

function invEase(x)
	x2=x*x
	x3=x2*x
	m0=2
	m1=2
	return(x3-2*x2+x)*m0 + (-2*x3+3*x2) + (x3-x2)*m1
end

function rotate(x, y, angle)
	c=cos(angle)
	s=sin(angle)
	return x*c-y*s, x*s+y*c
end


-- ///////////////////////////////////
function matmul(a,b)
	local dot = {}
	local rr = #a
	local rc = #b[1]
	for i = 1,rr do
		dot[i] = {}
		for j = 1,rc do
			local num = a[i][1] * b[1][j]
			for n = 2,#a[1] do
				num = num + a[i][n] * b[n][j]
			end
			dot[i][j] = num
		end
	end
	return dot
end

function rotatexyz(a)
	zrot = {
		{math.cos(a),-math.sin(a),0},
		{math.sin(a),math.cos(a),0},
		{0,0,1}
	}
	yrot = {
		{math.cos(a),0,math.sin(a)},
		{0,1,0},
		{-math.sin(a), 0, math.cos(a)}
	}
	xrot = {
		{1,0,0},
		{0,math.cos(a),-math.sin(a)},
		{0,math.sin(a),math.cos(a)}
	}
	pm = {{1,0,0},{0,1,0}}
	return matmul(matmul(matmul(pm, xrot),yrot),zrot)
end

function projectPoint(i,a)
	point = points[i]
	projected = matmul(rotatexyz(a),point)
	circ(projected[1][1]+w/2,projected[2][1]+h/2,r,12)
	return projected
end