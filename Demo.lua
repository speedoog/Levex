

function mdKF(att, ...)
	local out,keys={},{...}
	out.call =function(self, fx)
		fx[att]=CatmullRom(keys, 1, fx.t)[1]
	end
	return out
end

function mdSin(att,a,f,o,p)
	local out={}
	if not p then p=0 end
	out.call =function(self, fx)
		fx[att]=o+a*sin(f*2*pi*fx.t+p*2*pi)
	end
	return out
end

RunningFx = { }
Sequence = 
{
	-- Boot sequence
--	{	s=0,	e=4,	vb=0, 	fx=FxSprite(96,24),mod={mdKF("y",0,-50,1,24,2,24,3,24,4,150)}},
--	{	s=1,	e=3, 	vb=0, 	fx=FxText(100,80,"TIC-80")},
--	{	s=1.2,	e=3, 	vb=0, 	fx=FxText(80,90,"tiny computer")},
--	{	s=4,	e=10, 	vb=0, 	fx=FxText(10,10,"TIC-80 tiny computer\nLua Version 5.3.6\n\nReady",4,30,2)},
--	{	s=6,	e=10, 	vb=0, 	fx=FxText(10,50,'Load "LEVEX"',13,5)},

--	{	s=0,	e=20, 	vb=1,	fx=fxCube			},
	
	{	s=0,	e=200,  vb=0,	fx=FxTerrain(),		mod={mdKF("alt",0,16,30,40), mdKF("mul",0,0,10,6,20,9,30,14) } },
--	{	s=0,	e=200,	vb=1, 	fx=FxBeziers()		},
--	{	s=0,	e=200,	vb=0,	fx=FxBalls()		},
--	{	s=4,	e=6.5,  vb=0,	fx=FxPowerOff()		},
--	{	s=1.8,	e=3,  	vb=0,	fx=FxBlower()		},

--	{	s=0,	e=600, 	fx=FxText(50,10,"Demo mode",gWhite), vb=1, mod={mdSin("x",40,0.5,120), mdKF("y",0,0,1,30,2,40,3,45) } },

--	{	s=0,	e=20, 	vb=0,	fx=fxScrollText		},
--	{	s=15,	e=25,	vb=1,	fx=fxDisolve		}
}

function Startfx(fx,sh)
	if fx.started then return end

	local vb,start=sh.vb,sh.s
	if vb==nil then vb=0 end
	vbank(vb)
	fx:start()
	table.insert(RunningFx, {fx=fx, start=start, vbank=vb, sh=sh})
	fx.started=true
	fx.t=0
	fx.dt=0
end

function Stopfx(fx)
	if fx.started~=true then return end
	for k,it in pairs(RunningFx) do 
		if it.fx==fx  then 
			RunningFx[k]=nil
			fx.started=false
		end
	end
end

-- ############## Demo ##############
gTime=0
gInfos=false
gPlay=true
gDeltaTime=0

function BOOT()
	for k,v in pairs(Sequence) do
		if v.fx.Init then
			v.fx:Init()
		end
	end
end

function main()

	local tStart=time()

 	if keyp(61,20,1) then
		if key(63) then
			gTime=gTime+10
		else
			if gPlay then
				gTime=gTime+1
			else	
				gTime=gTime+1/60
			end
		end
	end

	if keyp(60,20,1) then
		if key(63) then
			gTime=0
		else
			if gPlay then
			 	gTime=max(0,gTime-1)
			else
				gTime=gTime-1/60
			end
		end
	end
	if keyp(49) then gInfos=not gInfos end
	if keyp(48) then 
		gPlay=not gPlay
	end
	
	local vclear={true,true}
	
	for k,sh in pairs(Sequence) do 
		local shouldrun = inrange(gTime, sh.s, sh.e)
		local fx=sh.fx
		if shouldrun then
			if fx.started~=true then
				Startfx(fx, sh)
			end
			if (fx.cls==false) then
				vclear[sh.vb+1]=false
			end
		end
	end

	if vclear[1] then vbank(0) cls() end
	if vclear[2] then vbank(1) cls() end

	local i=0
	for k,fh in pairs(RunningFx) do 
		vbank(fh.vbank)
		local fx=fh.fx
		local oldt=fx.t
		fx.t=gTime-fh.start
		fx.dt=fx.t-oldt

		-- update modifiers
		local mod=fh.sh.mod
		if mod then
			for k,v in pairs(mod) do
				v:call(fx)
			end
			-- for i=1,#mod,2 do
			-- 	local att=mod[i]
			-- 	local keys=mod[i+1]
			-- 	local v=CatmullRom(keys, 1, fx.t)
			-- 	fx[att]=v[1]
			-- end
		end

		fh.fx:tic(fx.t,fx.dt)
		
		if gInfos then print(string.format("%.1f %s",fx.t,fx.name), 0, i*7, gWhite,true)  end
		i=i+1
	end

	for k,sh in pairs(Sequence) do 
		local shouldrun = inrange(gTime, sh.s, sh.e)
		local fx=sh.fx
		if not shouldrun and fx.started then
			Stopfx(fx)
		end
	end

	if gInfos then
		print(string.format("%.2f",gTime), 0, 130, gWhite)
		local tEnd=time()
		local tElapse=(tEnd-tStart)
		gDeltaTime=lerp(gDeltaTime,tElapse,.1)
		print(string.format("%.f %%",100*gDeltaTime/(1000/60) ), 215, 130, gWhite)
	end

	if gPlay then gTime=gTime+1/60 end

end
