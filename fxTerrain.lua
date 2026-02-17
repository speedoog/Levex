fxTerrain = {
	name = "Terrain",
	_Distance = 1024,
	_map = {},
	GetMapValue = function(self, x, y)
		return self._map[(x & (self._Distance - 1)) + (y & (self._Distance - 1)) * self._Distance]
	end,
	SetMapValue = function(self, x, y, v)
		self._map[(x & (self._Distance - 1)) + (y & (self._Distance - 1)) * self._Distance] = v
	end,
	S = function(self, x, y)
		I = self:GetMapValue(floor(x * self._Distance), floor(y * self._Distance))
		return 1 - I * I * 9
	end,
	start = function(self)
		seed(1)
		_Random = function()
			return (2 * rand() - 1) * l
		end

		self._map = {}
		for i = 0, self._Distance * self._Distance do
			self._map[i] = 0
		end

		l = .5
		T = self._Distance
		while T > 1 do
			l = l / 2
			T = T / 2
			M = T / 2
			if M < 1 then
				break
			end
			for j = 0, self._Distance, T do
				for i = 0, self._Distance, T do
					w = self:GetMapValue(i, j)
					x = self:GetMapValue(i + T, j)
					y = self:GetMapValue(i, j + T)
					z = self:GetMapValue(i + T, j + T)
					self:SetMapValue(i + M, j, (w + x) / 2 + _Random())
					self:SetMapValue(i + M, j + T, (y + z) / 2 + _Random())
					self:SetMapValue(i, j + M, (w + y) / 2 + _Random())
					self:SetMapValue(i + T, j + M, (x + z) / 2 + _Random())
					self:SetMapValue(i + M, j + M, (w + x + y + z) / 4 + _Random())
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
			}
		}
		palet = palettes[4].p

		paladr = 0x3fc0
		for i = 1, palet:len(), 2 do
			poke(paladr, tonumber("0x" .. palet:sub(i, i) .. palet:sub(i + 1, i + 1)))
			paladr = paladr + 1
		end

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

		function sign(a)
			if a > 0 then
				return 1
			else
				return 0
			end
		end

		for i = 0, size_x do
			s_x = a_x + i
			e_x = a_x + i

			e_y = size_y
			s_y = size_y

			local w = (i / size_x) * 2 - 1

			local h = 0.7 --self:S(.5,t*.2)-.5;

			for j = 30, 200,1.5 do
				local _z = j / 500.
				local z = _z * _z * 500

				local x = w * z
				local u = x / 200 + .5
				local v = z / 200 + t * .4

				local l = self:S(u, v)

				local y = (l - h) * 32
				s_y = a_y + size_y * (y / (z + .1) + .25)
				if (s_y < e_y) then
					I = l - self:S(u + .01, v + .005) + .01
					I = I * sign(I) * 30 + .2
					--O=1.0-exp(-z*3e-4);
					-- o_x = L(o_x,.6,2);
					-- o_y = L(o_y,.25,4);
					-- o_z = L(o_z,.15,10);

					--d->AddLine(s,e,ImColor(o));

					line(s_x,s_y,e_x,e_y,  clamp(I*8*clamp(8/z,0,1),0,15) )
					--rect(s_x, s_y, 2, e_y - s_y + 1, clamp(I * 4, 0, 15))

					e_y = s_y
				end
			end
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
