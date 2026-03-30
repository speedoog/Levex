
function mdKF(att, ...)
	local out,keys={},{...}
	out.call =function(self, fx)
		fx[att]=CatmullRom(keys, 1, fx.t)[1]
	end
	return out
end

function mdSin(att,a,f,o,p)
	return { call =function(self, fx) fx[att]=o+a*sin(f*2*pi*fx.t+p*2*pi) end }
end

function mdBounce(att,y0,y1,toff,tscale)
	return {call = function(self,fx) fx[att] = y1-(y1-y0)*square(math.fmod(fx.t*tscale+toff,2)-1) end}
end

-- Source - https://stackoverflow.com/a/70096863
-- Posted by Paul Hilliar
-- Retrieved 2026-03-30, License - CC BY-SA 4.0

local function pairsByKeys(t,f)
	local a = {}
	for n in pairs(t) do table.insert(a,n) end
	table.sort(a,f)
	local i = 0              -- iterator variable
	local iter = function()  -- iterator function
		i = i+1
		if a[i] == nil then
			return nil
		else
			return a[i],t[a[i]]
		end
	end
	return iter
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

		for k,sh in pairs(part) do
			sh.s = sh.s+offset
			if sh.d then
				sh.e = sh.s+sh.d
				maxtime = max(maxtime,sh.e)
			end
			table.insert(_.data, sh)
		end

		--fix d & e
		for k,sh in pairs(part) do
			if sh.d==nil then
				sh.e = maxtime
				sh.d = maxtime-sh.s
			end
		end
		_.e=maxtime
	end
}

-- Boot
P0_Boot =
{
	{	s=0,	d=1, 	v=0, 	fx=FxPalette(gPal.sweetie16) },
	{	s=0,	d=1, 	v=1, 	fx=FxPalette(gPal.sweetie16) },

	{	s=0,	d=1, 	v=0, 	fx=FxColorRemplace(11,10) },
	{	s=0,	d=5, 	v=0, 	fx=FxText(7,77,"Unpacking data",13,print), 		set={speed=20} },
	{	s=1,	d=4, 	v=0, 	fx=FxText(90,77,'. . . . . . . . .',13,print), 	set={speed=4} },
	{	s=2,	d=3, 	v=0, 	fx=FxBorderLoading(11) },
	{	s=5,	d=1, 	v=0, 	fx=FxFadepal(gPal.black) },

	{	s=6,			v=0, 	fx=FxClsStart() },
	{	s=0,	d=6, 	v=0, 	fx=FxBorderStop(0)  },
	{	s=6,	d=1, 	v=0, 	fx=FxPalette(gPal.sweetie16mod) },
}

-- Tic logo
P1_TicLogo =
{
	{	s=0,	d=4,	v=0, 	fx=FxCls() },
	{	s=0,	d=4,	v=0, 	fx=FxSprite(96,24),mod={mdKF("y",0,-50,1,24,2,24,3,24,4,150)}},
	{	s=1,	d=2, 	v=0, 	fx=FxText(100,80,"TIC-80",gWhite)},
	{	s=1.2,	d=1.8, 	v=0, 	fx=FxText(80,90,"tiny computer",10)},
}

P_MountainVista =
{
	{	s=0, 	d=1,	v=1, 	fx=FxImage("MountainVista.c31") },
	-- {	s=0,	d=5,	v=0, 	fx=FxText(80,55,"31 Colors Test",14), set={fnStyle=StyleOutline, c2=0} },
	-- {	s=0,	d=5,	v=1, 	fx=FxText(80,55,"31 Colors Test",14), set={fnStyle=StyleOutline, c2=0} },
	{	s=0,	d=12,	v=0, 	fx=FxRoll(), mod={mdKF("k",0,-1, 2,-0.4, 4,-0.7, 5,0, 9,0, 10,0.1, 11,0.45, 12,1)}  },
	{	s=10,	d=1, 	v=0, 	fx=FxPalette(gPal.black) },
	{	s=10,	d=1, 	v=1, 	fx=FxPalette(gPal.black) },
	{	s=0,		 	v=0, 	fx=FxBorderStop(0)  },
}

P2_TxtMorning =
{
	{	s=0,			v=1,	fx=FxCls()},
	{	s=0,			v=0,	fx=FxCls()},
	{	s=0,			v=0,	fx=FxPalette(gPal.black)},
	{	s=0,	d=4, 	v=0, 	fx=FxFadepal(gPal.blueish) },
	{	s=0,			v=0,   fx=FxText(30,30,"Every morning",2), set={fnStyle=StyleStripes},mod={mdKF("c",0,0,2,6)} },
	{	s=2,			v=0,   fx=FxText(40,40,"you have two choices:",4), set={fnStyle=StyleStripes},mod={mdKF("c",0,0,2,6)} },
	{	s=4,			v=0,   fx=FxText(20,55,"Continue to sleep",gWhite),mod={mdKF("x",0,-102,1,-12,2,18)} },
	{	s=6,			v=0,   fx=FxText(125,55,"with your dreams",gWhite),mod={mdKF("x",0,245,1,155,2,125)} },
	{	s=8,			v=0,   fx=FxText(110,65,"or",gWhite)},
	{	s=8,			v=0,   fx=FxText(55,75,"wake up and chase them",14),mod={mdKF("y",0,140,2,75)} },
	{	s=10,			v=0,	fx={name = "col", tic=function(_) PaletteSetColor(15,0xFF*_.k,0xCD*_.k,0x75*_.k) end},mod={mdKF("k",0,0,1.5,1)} },
	{	s=10,	d=2,	v=0,   fx=FxText(63,100,"- Carmelo Anthony -",15), set={fnStyle=StyleItalic}},
}

P2_TxtMorning_ =
{
	{	s=0,	d=5.5,	v=0,   fx=FxSplit() },
}

P3_Tibet =
{
	{	s=0,	d=12,	v=0, 	fx=FxCls() },
	{	s=0,			v=1, 	fx=FxClsStart() },
	{	s=0,			v=0, 	fx=FxPalette(gPal.sweetie16mod) },
	{	s=0,			v=1, 	fx=FxPalette(gPal.sweetie16mod) },
	{	s=0,	d=12,	v=0, 	fx=FxDraw("Tibet.draw",200,true,true)},
	{	s=10,			v=1,	fx=FxBalls(),		mod={mdKF("scale",0,0,3,1,5,1,8,0)} },
	{	s=16,	d=2, 	v=1, 	fx=FxFadepal(gPal.black) },
	{	s=16,	d=2, 	v=0, 	fx=FxFadepal(gPal.black) },
}

P4_Dear =
{
--	{	s=0,			v=0, 	fx=FxPalette(gPal.sweetie16mod) },
--	{	s=0,			v=1, 	fx=FxPalette(gPal.sweetie16mod) },
	{	s=0,			v=0, 	fx=FxClsStart() },
	{	s=0,			v=1, 	fx=FxClsStart() },

	{	s=0,			v=1, 	fx=FxPalette(gPal.sweetie16mod) },
	{	s=0,	d=20,	v=1, 	fx=FxDraw("Dear.draw",300,false,false)},

	{	s=20,	d=2,	v=1, 	fx=FxDraw("Tunnel.draw",30,false,false, 1)},

	{	s=22,	d=2,	v=1, 	fx=FxZoom(), set={speed=2,ctx=111,cty=85} },

--	{	s=21,			v=1, 	fx=FxCls() },
--	{	s=21,	d=15, 	v=1, 	fx=FxTunnel() },
}

P4_Spectrals =
{
	{	s=0,	d=15, 	v=0, 	fx=FxPalette(gPal.sweetie16mod) },
	{	s=0,	d=15, 	v=1, 	fx=FxPalette(gPal.sweetie16) },
	{	s=0,			v=0, 	fx=FxCls() },
	{	s=6,			v=1, 	fx=FxCls() },

	{	s=6,	d=15, 	v=1, 	fx=FxDraw("Spectrals.draw",100,false,true) },
	{	s=6,	d=15,	v=1,	fx={name="black logo", Start = function() PaletteSetColor(15,0,0,0) end}},			-- black opaque interior logo

	{	s=18,	d=3, 	v=1, 	fx=FxFadepal(gPal.black) },
--	{	s=8,	d=7,	v=1, 	fx=FxBeziers()		},

	{	s=0,	d=21, 	v=0, 	fx=FxTunnel() },
	{	s=19,	d=2, 	v=0, 	fx=FxFadepal(gPal.black) },
}

P6_Levex =
{
	{	s=0,			v=0, 	fx=FxClsStart() },
	{	s=0,			v=1, 	fx=FxCls() },
	{	s=0,	d=10, 	v=1, 	fx=FxPalette(gPal.sweetie16mod) },
	{	s=0,	d=10, 	v=1, 	fx=FxDraw("Levex.draw",30,true,true), set={Hack=true} },
}

function Bounce()
--	return { mdKF("ox",0,15, 2,4, 4,2, 6,6, 8,-5), mdKF("rx",0,0, 10,-41), mdKF("rz",0,0, 10,61), mdKF("scale", 0,1, 7,1, 8,0), mdBounce("oy",-3,2,1.6,2) }
	return { mdKF("ox",0,12, 2,4, 4,2, 5,1, 6,-5), mdKF("rx",0,0, 10,-41), mdKF("rz",0,0, 10,61), mdKF("scale", 0,1, 5,1, 6,0), mdBounce("oy",-3.15,2,1.6,2) }
end

P7_Cube =
{
	{	s=0,		 	v=1, 	fx=FxPalette(gPal.sweetie16mod) },
	{	s=0,			v=1, 	fx=FxClsStart() },
	--	{	s=0,	d=30, 	v=1, 	fx=FxDraw("Rando.draw",200,false,true)},
	{	s=0,			v=1, 	fx=FxDraw("Rando.draw",150,false,false)},

	{	s=0,		 	v=0, 	fx=FxPalette(gPal.sweetie16mod) },
	{	s=0,			v=0, 	fx=FxCls() 	},
	{	s=0,	d=6, 	v=0,	fx=FxModel("cube.obj"), 		mod=Bounce() },
	{	s=4,	d=6, 	v=0,	fx=FxModel("tetrahedron.obj"), 	mod=Bounce() },
	{	s=8,	d=6, 	v=0,	fx=FxModel("octahedron.obj"), 	mod=Bounce() },
	{	s=12,	d=6, 	v=0,	fx=FxModel("pyramid.obj"), 		mod=Bounce() },
	{	s=16,	d=6, 	v=0,	fx=FxModel("cyl.obj"), 			mod=Bounce() },
	{	s=20,	d=6, 	v=0,	fx=FxModel("sphere.obj"), 		mod=Bounce() },
--	{	s=11.8,	d=1.4, 	v=1,	fx=FxBlower()},
}

-- Disolve
P8_Disolve =
{
	{	s=0,			v=1, 	fx=FxClsStart() 	},
	{	s=0,		 	v=0, 	fx=FxPalette(gPal.sweetie16mod) },
	{	s=0,			v=0, 	fx=FxCls() 	},
	{	s=0,	d=25,	v=0,	fx=FxDisolve()	},
}

-- Terrain
P9_Terrain =
{
	{	s=0,			v=1, 	fx=FxClsStart() 	},
	{	s=0,	d=1, 	v=0, 	fx=FxPalette(gPal.black) },
	{	s=0,	d=3, 	v=0, 	fx=FxFadepal(PaletteGradiant({0, Hex2RGB(0x000000), 15,Hex2RGB(0x2580ff) })) },
	{	s=10,	d=13, 	v=0, 	fx=FxFadepal(PaletteGradiant({0, Hex2RGB(0x101020 --[[0x1a1c2c]]), 4, Hex2RGB(0x5d275d), 7, Hex2RGB(0xb13e53), 11,Hex2RGB(0xef7d57), 15,Hex2RGB(0xffcd75) }) ) },

	{	s=0,	d=44,  	v=0,	fx=FxTerrain(),							mod={mdKF("alt",0,16,30,40), mdKF("mul",0,2,10,6,20,9,30,14) } },

	{	s=38,	d=5,	v=1, 	fx=FxCls() 	},
	{	s=38,	d=5, 	v=1, 	fx=FxText(50,50,"Code", gWhite), 		mod={mdKF("x",0,-100,1,50,4,50,5,-100), mdKF("y",0,-10,1,20,2,20,3,20,4,10,5,-10) } },
	{	s=38,	d=5, 	v=1, 	fx=FxText(50,50,"Speedman", gWhite),	mod={mdKF("x",0,350,1,150,4,150,5,350), mdKF("y",0,-10,1,20,2,20,3,20,4,10,5,-10) } },
}

-- End
P_End =
{
	{	s=0,	d=2.5,  v=0,	fx=FxPowerOff()	},
	{	s=0,			v=0, 	fx=FxClsStop() 	},
}

-- Sequence:Add(P0_Boot)
-- Sequence:Add(P1_TicLogo)
-- Sequence:Add(P2_TxtMorning)
-- Sequence:Add(P2_TxtMorning_)
-- Sequence:Add(P4_Dear)
-- Sequence:Add(P4_Spectrals,-3)
-- Sequence:Add(P3_Tibet)
-- Sequence:Add(P6_Levex)
Sequence:Add(P7_Cube)
Sequence:Add(P_MountainVista)
Sequence:Add(P8_Disolve)
Sequence:Add(P9_Terrain)
Sequence:Add(P_End,-1.5)

-- Sequence:Add({
-- 	{s = 0, v = 0,fx = FxCls()},
-- 	{s = 0, d = 600, v = 0,
-- 		fx = {
-- 			name = "parts",
-- 			Start = function(_) _.ps = CreateParticleSystem() end,
-- 			tic = function(
-- 				_)
-- 				_.ps:tic(_.dt)
-- 			end
-- 		}
-- 	},
-- }
-- )


function Startfx(sh)
	local fx=sh.fx
	if fx.started then return end

	if sh.set then
		for k,v in pairs(sh.set) do
			fx[k]=v
		end
	end

	vbank(sh.v)

	if fx.Start then fx:Start() end

	table.insert(RunningFx, sh)

	fx.started=true
	fx.t=0
	fx.dt=0
end

function Stopfx(sh)
	local fx = sh.fx
	if fx.started~=true then return end

	for k,it in pairsByKeys(RunningFx) do
		if it==sh  then 
			vbank(sh.v)
			if fx.Stop then fx:Stop() end
			RunningFx[k] = nil
			fx.started=false
			break
		end
	end
end

-- ############## Demo ##############

function BOOT()
	for k,v in pairs(Sequence.data) do
		v.fx.d=v.e-v.s
		if v.fx.Init then
			v.fx:Init()
		end
	end
end


RectInfo1,RectInfo2,RectInfo3 = {0,0},{0,0},{0,0}
function PlaybackControl(tStart)

	-- CPU usage
	local tEnd = time()
	local tElapse = (tEnd-tStart)
	gDeltaTime = lerp(gDeltaTime,tElapse,.1)
	local CpuUsage=100*gDeltaTime/(1000/60)

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

	local function Info(t,x,y,r)
		return StyleOutline(t,x,y,gWhite,print,gGrey,false,1,true)
	end

	-- CPU Warning
	local CPUWarning=false
	if CPUWarning then
		vbank(0)
		if gBorderWarning then
			poke(gAddBorderCol,0)
			gBorderWarning=false
		end
		if CpuUsage >= 95 then
			poke(gAddBorderCol,gTime*60)
			gBorderWarning=true
		end
	end

	-- infos
	vbank(1)
	if gInfos then
		-- global time
		rect(2,129,RectInfo1[1],RectInfo1[2], gBlack)
		RectInfo1=Info(string.format("%.1f",gTime),2,129)

		-- Fx
		local h=7
		rect(0,0,RectInfo2[1],RectInfo2[2],gBlack)
		local y=1
		for k,sh in pairsByKeys(RunningFx) do
			local fx=sh.fx
			Info(string.format("%.1f",fx.t),2,y)
			Info(string.format("-%.1f",fx.d-fx.t),20,y)
			Info(string.format("%s %d", fx.name, sh.v),40,y)
			y=y+h
		end
		RectInfo2={100, h*#RunningFx}

		-- CPU usage
		rect(225,128,RectInfo3[1],RectInfo3[2],gBlack)
		RectInfo3=Info(string.format("%.f %%",CpuUsage),225,129)
	end


end

function TIC()
	local tStart=time()
	vbank(1)

	-- Stop old
	for k,sh in pairsByKeys(RunningFx) do
		local fx=sh.fx
		local shouldrun = inrange(gTime, sh.s, sh.e)
		if not shouldrun then
			Stopfx(sh)
		end
	end

	-- Start new
	local vclear = {true,true}
	for k,sh in pairs(Sequence.data) do
		local shouldrun = inrange(gTime,sh.s,sh.e)
		local fx = sh.fx
		if shouldrun then
			Startfx(sh)
		end
	end

	for k,sh in pairsByKeys(RunningFx) do
		vbank(sh.v)
		local fx=sh.fx
		local oldt=fx.t
		fx.t=gTime-sh.s
		fx.dt=fx.t-oldt
		if sh.mod then 							-- update modifiers
			for k,md in pairs(sh.mod) do
				md:call(fx)
			end
		end

		if fx.tic then fx:tic(fx.t,fx.dt) end
	end

	PlaybackControl(tStart)

	if gPlay then gTime=gTime+(1/60) end

end

function BDR(row)
	local i=0
	for k,sh in pairs(RunningFx) do
--	for k,sh in pairsByKeys(RunningFx) do
		local fx=sh.fx
		if fx.bdr then
			vbank(sh.vbank)
			fx:bdr(row)
		end
	end
end
