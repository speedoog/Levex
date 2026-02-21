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
	paladr = 0x3fc0
	for k,v in pairs(pal) do
		poke(paladr,   v[1])
		poke(paladr+1, v[2])
		poke(paladr+2, v[3])
		paladr=paladr+3
	end
end

function PaletteGradiant(keys)
	local ret={}
	for i=0,15 do
		local k=CatmullRom(keys, 3, i)
		table.insert(ret, k)
	end
	return ret
end

function Hex2RGB(Hex)
	local r=Hex>>16
	local g=(Hex>>8)&0xFF
	local b=Hex&0xFF
	return {r,g,b}
end

fxTerrain = {
	name = "Terrain",
	_Distance = 1024,
	_h = 0.5,
	_map = {},
	GetMapValue = function(self, x, y)
		return self._map[(x & (self._Distance - 1)) + (y & (self._Distance - 1)) * self._Distance]
	end,
	SetMapValue = function(self, x, y, v)
		self._map[(x & (self._Distance - 1)) + (y & (self._Distance - 1)) * self._Distance] = v
	end,
	S = function(self, u, v)
		local I = self:GetMapValue(floor(u * self._Distance), floor(v * self._Distance))
		return 1 - I * I * 9
	end,
	start = function(self)
		seed(1)
		local _Random = function()
			return (2 * rand() - 1)
		end

		self._map = {}
		for i = 0, self._Distance * self._Distance do
			self._map[i] = 0
		end

		local l = .5
		local T = self._Distance
		while T > 1 do
			l = l / 2
			T = T / 2
			local M = T / 2
			if M < 1 then
				break
			end
			for j = 0, self._Distance, T do
				for i = 0, self._Distance, T do
					w = self:GetMapValue(i, j)
					x = self:GetMapValue(i + T, j)
					y = self:GetMapValue(i, j + T)
					z = self:GetMapValue(i + T, j + T)
					self:SetMapValue(i + M, j, (w + x) / 2 + _Random() * l)
					self:SetMapValue(i + M, j + T, (y + z) / 2 + _Random() * l)
					self:SetMapValue(i, j + M, (w + y) / 2 + _Random() * l)
					self:SetMapValue(i + T, j + M, (x + z) / 2 + _Random() * l)
					self:SetMapValue(i + M, j + M, (w + x + y + z) / 4 + _Random() * l)
				end
			end
		end

		--        Palette: Build palette here then add palette setter, ex pico8:
		--        palet="0000001d2b537e255383769cab5236008751ff004d5f574fff77a8ffa300c2c3c700e436ffccaa29adffffec27fff1e8"
		palettes = {
			{
				p = "1a1c2c5d275db13e53ef7d57ffcd75a7f07038b76425717929366f3b5dc941a6f673eff7f4f4f494b0c2566c86333c57",
				name = "sweetie16"
			},
			{
				p = "140c1c44243430346d4e4a4f854c30346524d04648757161597dced27d2c8595a16daa2cd2aa996dc2cadad45edeeed6",
				name = "classic tic80"
			},
			{
				p = "0000001d2b537e255383769cab5236008751ff004d5f574fff77a8ffa300c2c3c700e436ffccaa29adffffec27fff1e8",
				name = "pico8"
			},
			{
				p = "000000111111222222333333444444555555666666777777888888999999aaaaaabbbbbbccccccddddddeeeeeeffffff",
				name = "grayscale"
			},
			{
				p = "0000000000111111221111332222442222553333663333774444884444995555aa5555bb6666cc6666dd7777ee7777ff",
				name = "blueish"
			},
		}

		pal=PaletteLoadString(palettes[5].p)
		PaletteApply(pal)

--		palet = palettes[1].p

-- 		paladr = 0x3fc0
-- 		for i = 1, palet:len(), 2 do
-- --			if i % 3 == 2 then
-- 				poke(paladr, tonumber("0x" .. palet:sub(i, i) .. palet:sub(i + 1, i + 1)))
-- --			else
-- --				poke(paladr, tonumber("0x" .. palet:sub(i, i) .. palet:sub(i + 1, i + 1)) * 0.7)
-- --			end
-- 			paladr = paladr + 1
-- 		end
		
		local gradiant ={ 	{ 0, Hex2RGB(0x1a1c2c)},	-- black
						  	{ 2, Hex2RGB(0x5d275d)},	-- violet
						  	{ 5, Hex2RGB(0xb13e53)},	-- Red
							{ 11,Hex2RGB(0xef7d57)},	-- orange
							{ 15,Hex2RGB(0xffcd75)}		-- yellow
						 }
		local pal = PaletteGradiant(gradiant)
		PaletteApply(pal)

		-- 1a1c2c	
		-- 5d275d	
		-- b13e53	
		-- ef7d57	
		-- ffcd75	

		-- local p1 =	make_gradient_direct(0x1a,0x1c,0x2c, 0x5d,0x27,0x5d, 5)
		-- local p2 =	make_gradient_direct(0x5d,0x27,0x5d, 0xb1,0x3e,0x53, 5)
		-- local p3 =	make_gradient_direct(0xb1,0x3e,0x53, 0xef,0x7d,0x57, 5)
		-- local p4 =	make_gradient_direct(0xef,0x7d,0x57, 0xff,0xcd,0x75, 4)

		-- paladr = 0x3fc0
		-- poke(paladr, p1[1].r) poke(paladr+1, p1[1].g) poke(paladr+2, p1[1].b) paladr=paladr+3
		-- poke(paladr, p1[2].r) poke(paladr+1, p1[2].g) poke(paladr+2, p1[2].b) paladr=paladr+3
		-- poke(paladr, p1[3].r) poke(paladr+1, p1[3].g) poke(paladr+2, p1[3].b) paladr=paladr+3
		-- poke(paladr, p1[4].r) poke(paladr+1, p1[4].g) poke(paladr+2, p1[4].b) paladr=paladr+3
		-- poke(paladr, p1[5].r) poke(paladr+1, p1[5].g) poke(paladr+2, p1[5].b) paladr=paladr+3
		-- poke(paladr, p2[2].r) poke(paladr+1, p2[2].g) poke(paladr+2, p2[2].b) paladr=paladr+3
		-- poke(paladr, p2[3].r) poke(paladr+1, p2[3].g) poke(paladr+2, p2[3].b) paladr=paladr+3
		-- poke(paladr, p2[4].r) poke(paladr+1, p2[4].g) poke(paladr+2, p2[4].b) paladr=paladr+3
		-- poke(paladr, p2[5].r) poke(paladr+1, p2[5].g) poke(paladr+2, p2[5].b) paladr=paladr+3
		-- poke(paladr, p3[2].r) poke(paladr+1, p3[2].g) poke(paladr+2, p3[2].b) paladr=paladr+3
		-- poke(paladr, p3[3].r) poke(paladr+1, p3[3].g) poke(paladr+2, p3[3].b) paladr=paladr+3
		-- poke(paladr, p3[4].r) poke(paladr+1, p3[4].g) poke(paladr+2, p3[4].b) paladr=paladr+3
		-- poke(paladr, p3[5].r) poke(paladr+1, p3[5].g) poke(paladr+2, p3[5].b) paladr=paladr+3
		-- poke(paladr, p4[2].r) poke(paladr+1, p4[2].g) poke(paladr+2, p4[2].b) paladr=paladr+3
		-- poke(paladr, p4[3].r) poke(paladr+1, p4[3].g) poke(paladr+2, p4[3].b) paladr=paladr+3
		-- poke(paladr, p4[4].r) poke(paladr+1, p4[4].g) poke(paladr+2, p4[4].b) paladr=paladr+3


	end,
	tic = function(self, t, dt)
		local a_x = 0
		local a_y = 0
		local size_x = 240
		local size_y = 136

		local s_x = a_x
		local s_y = a_y
		local e_x = size_x
		local e_y = size_y
		-- mx,my=mouse()
		-- o_x=mx/size_x
		-- o_y=my/size_y
		-- o_z=0
		-- o_w=1

		-- L=function(x,a,c)
		--     return sqrt(1.-exp(-a*I*(1.-O)-c*O))
		-- end

		-- function sign(a)
		-- 	if a > 0 then
		-- 		return 1
		-- 	else
		-- 		return 0
		-- 	end
		-- end

		local h
		--        h = 0.6 +.15*cos(5+t*1.33)
		local ox = .025 * sin(t * .44) + .05 * t

		h = 10
		for d = 0, 1.5, 0.05 do
			h = min(h, self:S(.5 + ox + .05 * sin(30 * d), (t + d) * .3) - .25 + .15 * cos(5 + t * 1.33))
		end

		self._h = lerp2(self._h, h, 0.2, dt)

		local matrixSize = 8
		local matrixMask = 7
		local mat_max = matrixSize * matrixSize - 1

		local iFrame = floor(t * 60)
		for i = iFrame & 1, size_x, 2 do
			s_x = a_x + i
			e_x = a_x + i

			e_y = size_y
			s_y = size_y

			local w = (i / size_x) * 2 - 1

			---			for j = 40+.5*(iFrame&3), 350,0 do
			local inc = 1.5
			local j = 0 + .5 * (iFrame & 3)
			while j < 350 do
				j = j + inc
				local _z = j / 500.
				local z = _z * _z * 500

				local x = w * z
				local u = x / 200 + .5 + ox
				local v = z / 200 + t * .3

				local l = self:S(u, v)

				local y = (l - self._h) * 32

				if l > 0.9 then
					inc = remap(l, 0.9, 1, 1.5, 3)
				elseif l > 0.3 then
					inc = remap(l, 0.3, 0.9, 1, 1.5)
				else
					inc = remap(l, 0, 0.3, .5, 1)
				end

				-- if y<16 then inc = 0.5 else inc=4 end

				s_y = a_y + size_y * (y / (z + .1) + .25)
				if (s_y < e_y) then
					local I = l - self:S(u + .01, v + .005) + .02
					--					I = I * sign(I) * 30 + .2
					--O=1.0-exp(-z*3e-4);
					-- o_x = L(o_x,.6,2);
					-- o_y = L(o_y,.25,4);
					-- o_z = L(o_z,.15,10);

					--d->AddLine(s,e,ImColor(o));

					local color = clamp(I * 12 * 30 * clamp(6 / z, 0, 1), 0, 15)
					local icolor = floor(color)
					local fColorPart = mat_max * (color - icolor)
					for iy = floor(s_y), e_y do
						local threshold = Bayer8x8[(s_x & matrixMask) + 1][(iy & matrixMask) + 1]
						if fColorPart > threshold then
							pix(s_x, iy, color + 1)
						else
							pix(s_x, iy, color)
						end
					end
					--					line(s_x,s_y,e_x,e_y, color)
					--rect(s_x, s_y, 2, e_y - s_y + 1, color)

					e_y = s_y
				end
			end
			line(s_x, e_y, e_x, 0, 0)
		end
	end
}

--[[
_Distance 2048

float _map[_Distance*_Distance],I,O,w,x,y,z,h,u,v,l;

int q,i,j,T,M;
float& GetMapValue(int x,int y)
{
    return _map[(x&(_Distance-1))+(y&(_Distance-1))*_Distance];
}

float S(float x,float y)
{
    I=GetMapValue(x*_Distance,y*_Distance);
    return 1-I*I*9;
}

void L(float& x,float a,float c)
{
    x=sqrt(1.-exp(-a*I*(1.-O)-c*O));
}

#define _Random ((rand()%98)/49.-1)*l

void FX(ImDrawList*d,Vector2 a,Vector2 b,Vector2 size,ImVec4 o,float t)
{
    if(!q)
    {
        q=1;
        _map[0]=0;
        l=.5;
        for(T=_Distance;T>1;l=l/2,T=T/2)
        {
            M=T/2;
            for(j=0;j<_Distance;j+=T)
            {
                for(i=0;i<_Distance;i+=T)
                {
                    w=GetMapValue(i,j);
                    x=GetMapValue(i+T,j);
                    y=GetMapValue(i,j+T);
                    z=GetMapValue(i+T,j+T);
                    GetMapValue(i+M,j)=(w+x)/2+_Random;
                    GetMapValue(i+M,j+T)=(y+z)/2+_Random;
                    GetMapValue(i,j+M)=(w+y)/2+_Random;
                    GetMapValue(i+T,j+M)=(x+z)/2+_Random;
                    GetMapValue(i+M,j+M)=(w+x+y+z)/4+_Random;
                }
            }
        }
    }
    
    Vector2 s=a,e=size;
    o.w=1;
    for(i=64;i--;)
    {
        s.y=e.y;
        e.y=a.y+size.y*i/150;
        d->AddRectFilled(s,e,0xffff6000+i*771);
    }
    
    for(i=0;i<size.x;i++)
    {
        s.x=e.x=a.x+i;
        e.y=s.y=size.y;
        w=(i/size.x)*2-1;
        h=S(.5,t*.2)-.5;
        for(j=0;j<400;j++)
        {
            z=j/400.;
            z=z*z*500;
            x=w*z;
            u=x/300+.5;
            v=z/300+t*.2;
            l=S(u,v);
            y=(l-h)*32;
            s.y=a.y+size.y*(y/(z+.1)+.25);
            if (s.y<e.y)
            {
                I=l-S(u+.01,v+.005)+.01;
                I=I*(I>0)*30+.2;
                O=1.0-exp(-z*3e-4);
                L(o.x,.6,2);
                L(o.y,.25,4);
                L(o.z,.15,10);
                d->AddLine(s,e,ImColor(o));
                e.y=s.y;
            }
        }
    }
}
]]

--[[
Distance 2048

float m[Distance*Distance],I,O,w,x,y,z,h,u,v,l;

int q,i,j,T,M;
float& A(int x,int y)
{
    return m[(x&(Distance-1))+(y&(Distance-1))*Distance];
}

float S(float x,float y)
{
    I=A(x*Distance,y*Distance);
    return 1-I*I*9;
}

void L(float& x,float a,float c)
{
    x=sqrt(1.-exp(-a*I*(1.-O)-c*O));
}

#define _Random ((rand()%98)/49.-1)*l

void FX(ImDrawList*d,Vector2 a,Vector2 b,Vector2 B,ImVec4 o,float t)
{
    if(!q)
    {
        q=1;
        m[0]=0;
        l=.5;
        for(T=Distance;T>1;l=l/2,T=T/2)
        {
            M=T/2;
            for(j=0;j<Distance;j+=T)
            {
                for(i=0;i<Distance;i+=T)
                {
                    w=A(i,j);
                    x=A(i+T,j);
                    y=A(i,j+T);
                    z=A(i+T,j+T);
                    A(i+M,j)=(w+x)/2+_Random;
                    A(i+M,j+T)=(y+z)/2+_Random;
                    A(i,j+M)=(w+y)/2+_Random;
                    A(i+T,j+M)=(x+z)/2+_Random;
                    A(i+M,j+M)=(w+x+y+z)/4+_Random;
                }
            }
        }
    }
    
    Vector2 s=a,e=b;
    o.w=1;
    for(i=64;i--;)
    {
        s.y=e.y;
        e.y=a.y+B.y*i/150;
        d->AddRectFilled(s,e,0xffff6000+i*771);
    }
    
    for(i=0;i<B.x;i++)
    {
        s.x=e.x=a.x+i;
        e.y=s.y=b.y;
        w=(i/B.x)*2-1;
        h=S(.5,t*.2)-.5;
        for(j=0;j<400;j++)
        {
            z=j/400.;
            z=z*z*500;
            x=w*z;
            u=x/300+.5;
            v=z/300+t*.2;
            l=S(u,v);
            y=(l-h)*32;
            s.y=a.y+B.y*(y/(z+.1)+.25);
            if (s.y<e.y)
            {
                I=l-S(u+.01,v+.005)+.01;
                I=I*(I>0)*30+.2;
                O=1.0-exp(-z*3e-4);
                L(o.x,.6,2);
                L(o.y,.25,4);
                L(o.z,.15,10);
                d->AddLine(s,e,ImColor(o));
                e.y=s.y;
            }
        }
    }
}
]]

--[[
#define V ImVec2
#define F float
#define D 2048
F m[D*D],I,O,w,x,y,z,h,u,v,l;int q,i,j,T,M;F&A(int x,int y){return m[(x&(D-1))+(y&(D-1))*D];}
F S(F x,F y){I=A(x*D,y*D);return 1-I*I*9;}
void L(F& x,F a,F c){x=sqrt(1.-exp(-a*I*(1.-O)-c*O));}
#define R ((rand()%98)/49.-1)*l
void FX(ImDrawList*d,V a,V b,V B,ImVec4 o,F t){
if(!q){q=1;m[0]=0;l=.5;
for(T=D;T>1;l=l/2,T=T/2){M=T/2;for(j=0;j<D;j+=T){for(i=0;i<D;i+=T){w=A(i,j);x=A(i+T,j);y=A(i,j+T);z=A(i+T,j+T);
A(i+M,j)=(w+x)/2+R;A(i+M,j+T)=(y+z)/2+R;A(i,j+M)=(w+y)/2+R;A(i+T,j+M)=(x+z)/2+R;A(i+M,j+M)=(w+x+y+z)/4+R;}}}}
V s=a,e=b;o.w=1;for(i=64;i--;){s.y=e.y;e.y=a.y+B.y*i/150;d->AddRectFilled(s,e,0xffff6000+i*771);}
for(i=0;i<B.x;i++){s.x=e.x=a.x+i;e.y=s.y=b.y;w=(i/B.x)*2-1;h=S(.5,t*.2)-.5;
for(j=0;j<400;j++){z=j/400.;z=z*z*500;x=w*z;u=x/300+.5;v=z/300+t*.2;l=S(u,v);y=(l-h)*32;s.y=a.y+B.y*(y/(z+.1)+.25);
if(s.y<e.y){I=l-S(u+.01,v+.005)+.01;I=I*(I>0)*30+.2;O=1.0-exp(-z*3e-4);L(o.x,.6,2);L(o.y,.25,4);L(o.z,.15,10);d->AddLine(s,e,ImColor(o));e.y=s.y;}}}}
]]
