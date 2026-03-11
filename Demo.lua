
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

pt1=6	-- boot
pt2=10	-- mountain draw + spectrals
pt3=20	-- balls + beziers
pt4=30	-- levex + moutain vector
pt5=40	-- cube 
pt6=50	-- greetz disolve
pt7=75  -- terrain
pt8=120 -- end

gTime=0	--pt7
gInfos=false
gPlay=true
gDeltaTime=0


RunningFx = { }
Sequence = 
{
	-- Boot sequence
	{	s=0,	e=1, 	vb=0, 	fx=FxPalette(gPalettes.sweetie16) },
	{	s=0,	e=1, 	vb=1, 	fx=FxPalette(gPalettes.sweetie16) },

	{	s=0,	e=1, 	vb=0, 	fx=FxColorRemplace(11,10) },
	{	s=0,	e=5, 	vb=0, 	fx=FxText(7,77,"Unpacking data",13,20, false, false) },
	{	s=1,	e=5, 	vb=0, 	fx=FxText(90,77,'. . . . . . . . .',13,4, false, false) },
	{	s=2,	e=5, 	vb=0, 	fx=FxBorder(11) },
	{	s=5,	e=6, 	vb=0, 	fx=FxFadepal(PaletteLoadString(gPalettes.black)) },

	{	s=6,	e=7, 	vb=0, 	fx={start=function() poke(gAddBorderCol,0) end }  },
	{	s=6,	e=7, 	vb=0, 	fx=FxPalette(gPalettes.sweetie16mod) },

	{	s=pt1+0,	e=pt1+10,	vb=0, 	fx=FxSprite(96,24),mod={mdKF("y",0,-50,1,24,2,24,3,24,4,150)}},
	{	s=pt1+1,	e=pt1+3, 	vb=0, 	fx=FxText(100,80,"TIC-80",gWhite)},
	{	s=pt1+1.2,	e=pt1+3, 	vb=0, 	fx=FxText(80,90,"tiny computer",gWhite)},

--	{	s=pt1+4,	e=pt1+10, 	vb=0, 	fx=FxText(10,10,"TIC-80 tiny computer\nLua Version 5.3.6\n\nReady",4,30,2)},
--	{	s=pt1+6,	e=pt1+10, 	vb=0, 	fx=FxText(10,50,'Load "LEVEX"',13,5)},

	{	s=pt2+0,	e=pt2+15, 	vb=1, 	fx=FxDraw("Spectrals.txt") },
	{	s=pt2+12,	e=pt2+15, 	vb=1, 	fx=FxFadepal(PaletteLoadString(gPalettes.black),true) },
	{	s=pt2+8,	e=pt3+5,	vb=1, 	fx=FxBeziers()		},

	{	s=pt2+0,	e=pt2+15, 	vb=0, 	fx=FxTunnel() },
	{	s=pt2+13,	e=pt2+15, 	vb=0, 	fx=FxFadepal(PaletteLoadString(gPalettes.black),true) },

	{	s=pt3+5,	e=pt3+6, 	vb=0, 	fx=FxFadepal(PaletteLoadString(gPalettes.sweetie16mod),true) },
	{	s=pt3+5,	e=pt3+10,	vb=0,	fx=FxBalls(),		mod={mdKF("scale",0,0.5,4,1)} },

	{	s=pt4+0,	e=pt5, 		vb=1, 	fx=FxPalette(gPalettes.sweetie16mod) },
	{	s=pt4+0,	e=pt5, 		fx=FxText(50,50,"PH logo Levex", gWhite), vb=1, mod={mdSin("x",40,0.5,120), mdKF("y",0,0,1,30,2,40,3,45) } },

	{	s=pt5+0,	e=pt6, 		vb=1,	fx=FxCube()			},
	{	s=pt5+1.8,	e=pt5+3,  	vb=0,	fx=FxBlower()		},
	
	{	s=pt6+0,	e=pt7,		vb=1,	fx=fxDisolve()		},

	{	s=pt7+0,	e=pt7+1, 	vb=0, 	fx=FxPalette(gPalettes.black) },
	{	s=pt7+0,	e=pt7+3, 	vb=0, 	fx=FxFadepal(PaletteGradiant({0, Hex2RGB(0x000000), 15,Hex2RGB(0x2580ff) })) },
	{	s=pt7+10,	e=pt7+13, 	vb=0, 	fx=FxFadepal(PaletteGradiant({0, Hex2RGB(0x101020 --[[0x1a1c2c]]), 4, Hex2RGB(0x5d275d), 7, Hex2RGB(0xb13e53), 11,Hex2RGB(0xef7d57), 15,Hex2RGB(0xffcd75) }) ) },

	{	s=pt7+0,	e=pt8,  	vb=0,	fx=FxTerrain(),		mod={mdKF("alt",0,16,30,40), mdKF("mul",0,2,10,6,20,9,30,14) } },
	{	s=pt8-5,	e=pt8, 		fx=FxText(50,50,"Code", gWhite), 		vb=1, mod={mdKF("x",0,-100,1,50,4,50,5,-100), mdKF("y",0,-10,1,20,2,20,3,20,4,10,5,-10) } },
	{	s=pt8-5,	e=pt8, 		fx=FxText(50,50,"Speedman", gWhite), 	vb=1, mod={mdKF("x",0,350,1,150,4,150,5,350), mdKF("y",0,-10,1,20,2,20,3,20,4,10,5,-10) } },

	{	s=pt8+0,	e=pt8+2.5,  vb=0,	fx=FxPowerOff()		},

--	{	s=0,	e=600, 	fx=FxText(50,10,"Demo mode",gWhite), vb=1, mod={mdSin("x",40,0.5,120), mdKF("y",0,0,1,30,2,40,3,45) } },
}

function Startfx(fx,sh)
	if fx.started then return end

	local vb,start=sh.vb,sh.s
	if vb==nil then vb=0 end
	vbank(vb)
	if fx.start then fx:start() end
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

function BOOT()
	for k,v in pairs(Sequence) do
		v.fx.fh=v
		v.fx.dur=v.e-v.s
		if v.fx.Init then
			v.fx:Init()
		end
	end
end

function PlaybackControl(tStart)
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
		   gTime=max(0,gTime-10)
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

	if gInfos then
		print(string.format("%.2f",gTime), 0, 130, gWhite)
		local tEnd=time()
		local tElapse=(tEnd-tStart)
		gDeltaTime=lerp(gDeltaTime,tElapse,.1)
		print(string.format("%.f %%",100*gDeltaTime/(1000/60) ), 215, 130, gWhite)
		
		local i=0
		for k,fh in pairs(RunningFx) do 
			local fx=fh.fx
			print(string.format("%.1f %s",fx.t,fx.name), 0, i*7, gWhite,true)
			i=i+1
		end
	end
end

function TIC()


	local tStart=time()
	
	-- Stop old
	for k,sh in pairs(Sequence) do 
		local shouldrun = inrange(gTime, sh.s, sh.e)
		local fx=sh.fx
		if not shouldrun and fx.started then
			Stopfx(fx)
		end
	end

	-- start new
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
		end

		if fx.tic then fx:tic(fx.t,fx.dt) end
		
		if gInfos then print(string.format("%.1f %s",fx.t,fx.name), 0, i*7, gWhite,true)  end
		i=i+1
	end

	PlaybackControl(tStart)

	if gPlay then gTime=gTime+1/60 end

end

function BDR(row)
	local i=0
	for k,fh in pairs(RunningFx) do 
		local fx=fh.fx
		if fx.bdr then
			vbank(fh.vbank)
			fx:bdr(row)
		end
	end
end
