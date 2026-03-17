
function mdKF(att, ...)
	local out,keys={},{...}
	out.call =function(self, fx)
		fx[att]=CatmullRom(keys, 1, fx.t)[1]
	end
	return out
end

function mdConst(att,v)
	local out = {call = function(self,fx) fx[att] = v end }
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

gTime=0
gInfos=false
gPlay=true
gDeltaTime=0


RunningFx = { }
Sequence = {
	data = {},
	e=0,
	Add=function(_, part, offset)
		local maxtime=0
		if offset==nil then
			offset=0
		end
		offset = _.e+offset

		for k,v in pairs(part) do
			if v.d then
				v.s = v.s+offset
				v.e = v.s+v.d
			end
			maxtime = max(maxtime,v.e)
			table.insert(_.data, v)
		end
		part.e=maxtime
		_.e=maxtime
	end
}

-- Boot
P0_Boot =
{
	{	s=0,	d=1, 	vb=0, 	fx=FxPalette(gPalettes.sweetie16) },
	{	s=0,	d=1, 	vb=1, 	fx=FxPalette(gPalettes.sweetie16) },

	{	s=0,	d=1, 	vb=0, 	fx=FxColorRemplace(11,10) },
	{	s=0,	d=5, 	vb=0, 	fx=FxText(7,77,"Unpacking data",13,20, false, false) },
	{	s=1,	d=4, 	vb=0, 	fx=FxText(90,77,'. . . . . . . . .',13,4, false, false) },
	{	s=2,	d=3, 	vb=0, 	fx=FxBorder(11) },
	{	s=5,	d=1, 	vb=0, 	fx=FxFadepal(PaletteLoadString(gPalettes.black)) },

	{	s=6,	d=1, 	vb=0, 	fx={name="border reset", start=function() poke(gAddBorderCol,0) end }  },
	{	s=6,	d=1, 	vb=0, 	fx=FxPalette(gPalettes.sweetie16mod) },
}

-- Tic logo
P1_TicLogo =
{
	{	s=0,	d=4,	vb=0, 	fx=FxSprite(96,24),mod={mdKF("y",0,-50,1,24,2,24,3,24,4,150)}},
	{	s=1,	d=2, 	vb=0, 	fx=FxText(100,80,"TIC-80",gWhite)},
	{	s=1.2,	d=1.8, 	vb=0, 	fx=FxText(80,90,"tiny computer",gWhite)},
	{	s=4, 	d=2,	vb=1, 	fx=FxImage("test.tga") },
}

-- spectrals + tunnel
P2_Spectrals =
{
	{	s=0,	d=15, 	vb=0, 	fx=FxPalette(gPalettes.sweetie16mod) },
	{	s=0,	d=15, 	vb=1, 	fx=FxPalette(gPalettes.sweetie16) },
	{	s=0,	d=15, 	vb=1, 	fx=FxDraw("Spectrals.txt") },
	{	s=0,	d=15,	vb=1,	fx={start = function() PaletteSetColor(15,0,0,0) end}},			-- black opaque interior logo

	{	s=12,	d=3, 	vb=1, 	fx=FxFadepal(PaletteLoadString(gPalettes.black),true) },
	{	s=8,	d=7,	vb=1, 	fx=FxBeziers()		},

	{	s=0,	d=15, 	vb=0, 	fx=FxTunnel() },
	{	s=13,	d=2, 	vb=0, 	fx=FxFadepal(PaletteLoadString(gPalettes.black),true) },
}

-- balls
P3_Balls =
{
	{	s=0,	d=1, 	vb=0, 	fx=FxFadepal(PaletteLoadString(gPalettes.sweetie16mod),true) },
	{	s=0,	d=5,	vb=0,	fx=FxBalls(),		mod={mdKF("scale",0,0.5,4,1)} },
}

-- Levex
P4_Levex =
{
	{	s=0,	d=10, 	vb=1, 	fx=FxPalette(gPalettes.sweetie16mod) },
	{	s=0,	d=10, 	vb=1, 	fx=FxDraw("Levex.txt"), mod={mdConst("speed", 30), mdConst("Hack", true) } },
}

-- Cube
P5_Cube =
{
	{	s=0,	d=10, 	vb=1,	fx=FxCube()			},
	{	s=1.8,	d=3,  	vb=0,	fx=FxBlower()		},
}

-- Disolve
P6_Disolve =
{
	{	s=0,	d=25,		vb=1,	fx=FxDisolve()	},
}

-- Terrain
P7_Terrain =
{
	{	s=0,	d=1, 	vb=0, 	fx=FxPalette(gPalettes.black) },
	{	s=0,	d=3, 	vb=0, 	fx=FxFadepal(PaletteGradiant({0, Hex2RGB(0x000000), 15,Hex2RGB(0x2580ff) })) },
	{	s=10,	d=13, 	vb=0, 	fx=FxFadepal(PaletteGradiant({0, Hex2RGB(0x101020 --[[0x1a1c2c]]), 4, Hex2RGB(0x5d275d), 7, Hex2RGB(0xb13e53), 11,Hex2RGB(0xef7d57), 15,Hex2RGB(0xffcd75) }) ) },

	{	s=0,	d=45,  	vb=0,	fx=FxTerrain(),							mod={mdKF("alt",0,16,30,40), mdKF("mul",0,2,10,6,20,9,30,14) } },
	{	s=40,	d=5, 	vb=1, 	fx=FxText(50,50,"Code", gWhite), 		mod={mdKF("x",0,-100,1,50,4,50,5,-100), mdKF("y",0,-10,1,20,2,20,3,20,4,10,5,-10) } },
	{	s=40,	d=5, 	vb=1, 	fx=FxText(50,50,"Speedman", gWhite),	mod={mdKF("x",0,350,1,150,4,150,5,350), mdKF("y",0,-10,1,20,2,20,3,20,4,10,5,-10) } },
}

-- End
P8_End =
{
	{	s=0,	d=2.5,  vb=0,	fx=FxPowerOff()	},
}

Sequence:Add(P0_Boot)
Sequence:Add(P1_TicLogo)
Sequence:Add(P2_Spectrals)
Sequence:Add(P3_Balls)
Sequence:Add(P4_Levex)
Sequence:Add(P5_Cube)
Sequence:Add(P6_Disolve)
Sequence:Add(P7_Terrain)
Sequence:Add(P8_End,-1)

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
			if fx.stop then fx:stop() end
			RunningFx[k] = nil
			fx.started=false
		end
	end
end

-- ############## Demo ##############

function BOOT()
	for k,v in pairs(Sequence.data) do
		v.fx.fh=v
		v.fx.d=v.e-v.s
		if v.fx.Init then
			v.fx:Init()
		end
	end
end

function PlaybackControl(tStart)
	if keyp(gKeyRight,20,1) then
		if key(gKeyCtrl) then
		   gTime=gTime+10
	   else
		   if gPlay then
			   gTime=gTime+1
		   else	
			   gTime=gTime+1/60
		   end
	   end
	end

	if keyp(gKeyLeft,20,1) then
		if key(gKeyCtrl) then
		   gTime=max(0,gTime-10)
	   else
		   if gPlay then
				gTime=max(0,gTime-1)
		   else
			   gTime=gTime-1/60
		   end
	   end
	end

	if keyp(gKeyTab) 	then gInfos = not gInfos end
	if keyp(gKeySpace) 	then gPlay  = not gPlay	 end

	if gInfos then
		vbank(1)
		printoutline(string.format("%.1f",gTime), 0, 130, gWhite,gBlack)
		local tEnd=time()
		local tElapse=(tEnd-tStart)
		gDeltaTime=lerp(gDeltaTime,tElapse,.1)
		printoutline(string.format("%.f %%",100*gDeltaTime/(1000/60)),215,130,gWhite,gBlack)

		local i=0
		for k,fh in pairs(RunningFx) do 
			local fx=fh.fx
			printoutline(string.format("%.1f %s",fx.t,fx.name),0,i*7,gWhite,gBlack)
			i=i+1
		end
		vbank(0)
	end
end

function TIC()
	local tStart=time()

	-- Stop old
	for k,sh in pairs(Sequence.data) do 
		local shouldrun = inrange(gTime, sh.s, sh.e)
		local fx=sh.fx
		if not shouldrun and fx.started then
			Stopfx(fx)
		end
	end

	-- start new
	local vclear = {true,true}
	for k,sh in pairs(Sequence.data) do
		local shouldrun = inrange(gTime,sh.s,sh.e)
		local fx = sh.fx
		if shouldrun then
			if fx.started ~= true then
				Startfx(fx,sh)
			end
			if (fx.cls == false) then
				vclear[sh.vb+1] = false
			end
		end
	end

	if vclear[1] then
		vbank(0)
		cls()
	end
	if vclear[2] then
		vbank(1)
		cls()
	end

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
