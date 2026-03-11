
-- ############## MATHS ##############

sqrt,abs,sin,cos,tan,atan,pi,min,max,floor,exp=math.sqrt,math.abs,math.sin,math.cos,math.tan,math.atan,math.pi,math.min,math.max,math.floor,math.exp
rand,seed=math.random,math.randomseed

function square(x)
	return x*x
end

function remap( x, t1, t2, s1, s2 )
 local f = ( x - t1 ) / ( t2 - t1 )
 return f * ( s2 - s1 ) + s1
end

function clamp(x, l, h)
	if x<l then return l elseif x>h then return h else return x end
end

function lerp(a,b,r)
--	return a*(1-r)+b*r
	return a+(b-a)*r
end

function lerp2(a,b,f,dt)
	local r = 1.0 - f^dt;
	return a+(b-a)*r
end

-- wrap a number x between a range [a..b]
function wrap(x, a, b)
	local fRange = b - a
	if abs(fRange)>1e-6 then
		return x - fRange * floor((x - a) / fRange)
	else
		return a
	end
end

function cuberp(a,b,c,d,t)
	local A=d-c-a+b
	local B=a-b-A
	local C=c-a
	local D=b
	local T=t*t
	return A*t*T+B*T+C*t+D
end

function inrange(x,a,b)
	return x>=a and x<=b
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

-- ---------------------------------------------------------------------
-- 							Vector
-- ---------------------------------------------------------------------

-- dot product
function dot(v1, v2)
	return v1[1] * v2[1] + v1[2] * v2[2] + v1[3] * v2[3]
end

-- subtract 2 vectors
function sub(v1, v2)
	return {v1[1] - v2[1], v1[2] - v2[2], v1[3] - v2[3]}
end

-- cross product
function cross(v1, v2)
	x = (v1[2] * v2[3]) - (v1[3] * v2[2])
	y = (v1[3] * v2[1]) - (v1[1] * v2[3])
	z = (v1[1] * v2[2]) - (v1[2] * v2[1])
	return {x,y,z}
end

-- 1 if a poly is dead-on, 0 if parallel with camera, negative if facing away
function FaceOrient(v1, v2, v3)
	local a = cross(sub(v2, v1), sub(v3, v1))
	return a[3]
end

-- ---------------------------------------------------------------------
-- 							Matrix
-- ---------------------------------------------------------------------

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

function rotatexyz(a,b,c)
	local xrot,yrot,zrot
	zrot = {
		{cos(a),-sin(a),0},
		{sin(a),cos(a),0},
		{0,0,1}
	}
	yrot = {
		{cos(b),0,sin(b)},
		{0,1,0},
		{-sin(b), 0, cos(b)}
	}
	xrot = {
		{1,0,0},
		{0,cos(c),-sin(c)},
		{0,sin(c),cos(c)}
	}
	local pm = {{1,0,0},{0,1,0}, {0,0,1}}
	return matmul(matmul(matmul(pm, xrot),yrot),zrot)
end

function ToScreen(ww,p)
	local z = 5+p[3]
	local w = ww*10/(z)
	local x = (p[1]*w+1)*68+52
	local y = (p[2]*w+1)*68
	return {x,y,z}
end


-- ---------------------------------------------------------------------
-- 							Dithering
-- ---------------------------------------------------------------------

Bayer4x4 = {
	{0, 8, 2, 10},
	{12, 4, 14, 6},
	{3, 11, 1, 9},
	{15, 7, 13, 5},
	}

	
Bayer8x8 = {
	{0, 32, 8, 40, 2, 34, 10, 42},
	{48, 16, 56, 24, 50, 18, 58, 26},
	{12, 44, 4, 36, 14, 46, 6, 38},
	{60, 28, 52, 20, 62, 30, 54, 22},
	{3, 35, 11, 43, 1, 33, 9, 41},
	{51, 19, 59, 27, 49, 17, 57, 25},
	{15, 47, 7, 39, 13, 45, 5, 37},
	{63, 31, 55, 23, 61, 29, 53, 21},
}

-- ---------------------------------------------------------------------
-- 							CatmullRom
-- https://iquilezles.org/articles/minispline/
-- keys format : spline ={0,x0,y0,1,x1,y1,2,x2,y2,3,x3,y3}
-- ---------------------------------------------------------------------

CatmullRomCoefs = {
    { -1, 2,-1, 0},
    {  3,-5, 0, 2},
    { -3, 4, 1, 0},
    {  1,-1, 0, 0} }

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
		local t1=keys[1+(k-1)*size]
		local t2=keys[1+k*size]
	 	h=(t-t1)/(t2-t1)
	end

    -- add basis functions
    for i=1,4 do
        local kn = k+i-3;
		if kn<0 then
			kn=0
		elseif kn>(num-1) then
			kn=num-1
		end
		
		local co=CatmullRomCoefs[i]
        local b = 0.5*(((co[1]*h + co[2])*h + co[3])*h + co[4]);
        for j=1,dim do
			v[j] = v[j]+ b*keys[kn*size+j+1]
		end
    end
	return v
end

-- ---------------------------------------------------------------------
-- 						COLOR / Palette
-- ---------------------------------------------------------------------

-- Palette: Build palette here then add palette setter, ex pico8:
-- call PaletteApply(PaletteLoadString(gPalettes.blueish))
gPalettes = {
	sweetie16     = "1a1c2c5d275db13e53ef7d57ffcd75a7f07038b76425717929366f3b5dc941a6f673eff7f4f4f494b0c2566c86333c57",
	sweetie16mod  = "0000005d275db13e53ef7d57ffcd75a7f07038b76425717929366f3b5dc941a6f673eff7f4f4f494b0c2566c86333c57",
	classic_tic80 = "140c1c44243430346d4e4a4f854c30346524d04648757161597dced27d2c8595a16daa2cd2aa996dc2cadad45edeeed6",
	pico8         = "0000001d2b537e255383769cab5236008751ff004d5f574fff77a8ffa300c2c3c700e436ffccaa29adffffec27fff1e8",
	grayscale     = "000000111111222222333333444444555555666666777777888888999999aaaaaabbbbbbccccccddddddeeeeeeffffff",
	blueish       = "0000000000111111221111332222442222553333663333774444884444995555aa5555bb6666cc6666dd7777ee7777ff",
	black         = "000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
}

function rgbToHsv(r, g, b)
	r, g, b = r / 255, g / 255, b / 255
	local max, min = math.max(r, g, b), math.min(r, g, b)
	local h, s, v
	v = max
	local d = max - min
	if max == 0 then
		s = 0
	else
		s = d / max
	end
	if max == min then
		h = 0
	else
		if max == r then
			h = (g - b) / d
			if g < b then
				h = h + 6
			end
		elseif max == g then
			h = (b - r) / d + 2
		elseif max == b then
			h = (r - g) / d + 4
		end
		h = h / 6
	end
	return h, s, v
end

function hsvToRgb(h, s, v)
	local r, g, b
	local i = math.floor(h * 6)
	local f = h * 6 - i
	local p = v * (1 - s)
	local q = v * (1 - f * s)
	local t = v * (1 - (1 - f) * s)
	i = i % 6
	if i == 0 then
		r, g, b = v, t, p
	elseif i == 1 then
		r, g, b = q, v, p
	elseif i == 2 then
		r, g, b = p, v, t
	elseif i == 3 then
		r, g, b = p, q, v
	elseif i == 4 then
		r, g, b = t, p, v
	elseif i == 5 then
		r, g, b = v, p, q
	end
	return math.floor(r * 255), math.floor(g * 255), math.floor(b * 255)
end

function make_gradient(r1, g1, b1, r2, g2, b2, steps)
	steps = math.abs(steps)
	local out = {}
	local h1 = 0
	local s1 = 0
	local v1 = 0
	h1, s1, v1 = rgbToHsv(r1, g1, b1)
	local h2 = 0
	local s2 = 0
	local v2 = 0
	h2, s2, v2 = rgbToHsv(r2, g2, b2)
	local stepamount = 1 / (steps-1)
	local prog = 0
	local i = 0
	for i = 1, steps, 1 do
		local temph = lerp(h1, h2, prog)
		local temps = lerp(s1, s2, prog)
		local tempv = lerp(v1, v2, prog)
		out[i] = {}
		out[i].r, out[i].g, out[i].b = hsvToRgb(temph, temps, tempv)
		prog = prog + stepamount
	end
	return out
end
function make_gradient_direct(r1, g1, b1, r2, g2, b2, steps)
	steps = math.abs(steps)
	local out = {}
	local stepamount = 1 / (steps-1)
	local prog = 0
	local i = 0
	for i = 1, steps, 1 do
		out[i] = {}
		out[i].r = lerp(r1, r2, prog)
		out[i].g = lerp(g1, g2, prog)
		out[i].b = lerp(b1, b2, prog)
		prog = prog + stepamount
	end
	return out
end

function PaletteLoadString(s)
	local ret={}
	local i=1
	while i<s:len() do
		local r = tonumber("0x" .. s:sub(i, i) .. s:sub(i + 1, i + 1)) i=i+2
		local g = tonumber("0x" .. s:sub(i, i) .. s:sub(i + 1, i + 1)) i=i+2
		local b = tonumber("0x" .. s:sub(i, i) .. s:sub(i + 1, i + 1)) i=i+2
		table.insert(ret, {r,g,b})
	end
	return ret
end

function PaletteApply(pal)
	local p = gAddPalette
	for k,v in pairs(pal) do
		poke(p,   v[1])
		poke(p+1, v[2])
		poke(p+2, v[3])
		p=p+3
	end
end

function PaletteGradiant(keys)
	local tmp={}
	for i=1,#keys,2 do
		table.insert(tmp, keys[i])
		table.insert(tmp, keys[i+1][1])
		table.insert(tmp, keys[i+1][2])
		table.insert(tmp, keys[i+1][3])
	end
	local ret={}
	for i=0,15 do
		local k=CatmullRom(tmp, 3, i)
		table.insert(ret, k)
	end
	return ret
end

function PaletteCapture()
	local pal={}
	local p = gAddPalette
	for i=0,15 do
		local r,g,b
		r=peek(p)
		g=peek(p+1)
		b=peek(p+2)
		table.insert(pal, {r,g,b})
		p=p+3
	end
	return pal
end

function Hex2RGB(Hex)
	local r=Hex>>16
	local g=(Hex>>8)&0xFF
	local b=Hex&0xFF
	return {r,g,b}
end

