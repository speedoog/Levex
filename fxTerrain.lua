FxTerrain = function()
	local fx = {
	name = "Terrain",
    cls = false,
	_Distance = 1024,
	_h = 0.5,
	_map = {},
	GetMapValue = function(self, x, y) 		return self._map[(x & (self._Distance - 1)) + (y & (self._Distance - 1)) * self._Distance] 	end,
	SetMapValue = function(self, x, y, v)	self._map[(x & (self._Distance - 1)) + (y & (self._Distance - 1)) * self._Distance] = v		end,
	S = function(self, u, v)				local I = self:GetMapValue(floor(u * self._Distance), floor(v * self._Distance)) return 1 - I * I * 9 end,
	Init = function(self)
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
	end,
	start = function(self)
		local gradiant ={ 	 0, Hex2RGB(0x1a1c2c),	-- black
						  	 4, Hex2RGB(0x5d275d),	-- violet
						  	 7, Hex2RGB(0xb13e53),	-- Red
							 11,Hex2RGB(0xef7d57),	-- orange
							 15,Hex2RGB(0xffcd75)	-- yellow
						 }
		local pal = PaletteGradiant(gradiant)
		PaletteApply(pal)
	end,
	tic = function(self, t, dt)

--		local border=max(0,floor((136/2)-10*t))
		local border=0

		local a_x = 0+border
		local a_y = 0+border
		local size_x = 240-border*2
		local size_y = 136-border*2

		local s_x = a_x
		local s_y = a_y
		local e_x = size_x
		local e_y = size_y

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
		local ox = .025 * sin(t * .44) + .09 * t

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

			e_y = size_y+a_y
			s_y = size_y+a_y

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
					local I = l - 0.96*self:S(u + .01, v + .005) + .02
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
			line(s_x, e_y, e_x, a_y, 0)
		end
	end
}
return fx
end

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
