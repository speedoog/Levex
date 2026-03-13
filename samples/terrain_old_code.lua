--[[
_Distance 2048

float map[_Distance*_Distance],I,O,w,x,y,z,h,u,v,l;

int q,i,j,T,M;
float& GetMapValue(int x,int y)
{
    return map[(x&(_Distance-1))+(y&(_Distance-1))*_Distance];
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
        map[0]=0;
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
