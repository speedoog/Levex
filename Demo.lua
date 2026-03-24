
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
	{	s=0,	d=1, 	vb=0, 	fx=FxPalette(gPalettes.sweetie16) },
	{	s=0,	d=1, 	vb=1, 	fx=FxPalette(gPalettes.sweetie16) },

	{	s=0,	d=1, 	vb=0, 	fx=FxColorRemplace(11,10) },
	{	s=0,	d=5, 	vb=0, 	fx=FxText(7,77,"Unpacking data",13,false), 		set={speed=20} },
	{	s=1,	d=4, 	vb=0, 	fx=FxText(90,77,'. . . . . . . . .',13,false), 	set={speed=4} },
	{	s=2,	d=3, 	vb=0, 	fx=FxBorder(11) },
	{	s=5,	d=1, 	vb=0, 	fx=FxFadepal(gPalettes.black) },

	{	s=6,			vb=0, 	fx=FxClsStart() },
	{	s=6,	d=1, 	vb=0, 	fx={name="border reset", start=function() poke(gAddBorderCol,0) end }  },
	{	s=6,	d=1, 	vb=0, 	fx=FxPalette(gPalettes.sweetie16mod) },
}

-- Tic logo
P1_TicLogo =
{
	{	s=0,	d=4,	vb=0, 	fx=FxCls() },
	{	s=0,	d=4,	vb=0, 	fx=FxSprite(96,24),mod={mdKF("y",0,-50,1,24,2,24,3,24,4,150)}},
	{	s=1,	d=2, 	vb=0, 	fx=FxText(100,80,"TIC-80",gWhite)},
	{	s=1.2,	d=1.8, 	vb=0, 	fx=FxText(80,90,"tiny computer",gRed)},
}

P_Imagec31 =
{
	{	s=0, 	d=2,	vb=1, 	fx=FxImage("test.c31") },
	{	s=0,			vb=0, 	fx=FxClsStop() },
	{	s=0,			vb=1, 	fx=FxClsStop() },
}

-- Tibet
P11_Tibet =
{
	{	s=0,			vb=0, 	fx=FxCls() },
	{	s=0,	d=15, 	vb=0, 	fx=FxPalette(gPalettes.sweetie16mod) },
	{	s=0,	d=15, 	vb=0, 	fx=FxDraw("Tibet.draw"), set={speed=200} },

	{	s=13,	d=2, 	vb=0, 	fx=FxFadepal(gPalettes.black) },
}


-- spectrals + tunnel
P2_Spectrals =
{
	{	s=0,	d=15, 	vb=0, 	fx=FxPalette(gPalettes.sweetie16mod) },
	{	s=0,	d=15, 	vb=1, 	fx=FxPalette(gPalettes.sweetie16) },
	{	s=0,			vb=0, 	fx=FxCls() },
	{	s=0,			vb=1, 	fx=FxCls() },

	{	s=0,	d=15, 	vb=1, 	fx=FxDraw("Spectrals.draw") },
	{	s=0,	d=15,	vb=1,	fx={name="black logo", start = function() PaletteSetColor(15,0,0,0) end}},			-- black opaque interior logo

	{	s=12,	d=3, 	vb=1, 	fx=FxFadepal(gPalettes.black) },
	{	s=8,	d=7,	vb=1, 	fx=FxBeziers()		},

	{	s=0,	d=15, 	vb=0, 	fx=FxTunnel() },
	{	s=13,	d=2, 	vb=0, 	fx=FxFadepal(gPalettes.black) },
}

-- balls
P3_Balls =
{
	{	s=0,			vb=1, 	fx=FxPalette(gPalettes.sweetie16mod) },
	{	s=0,			vb=1, 	fx=FxClsStart() },
	{	s=0,	d=1, 	vb=0, 	fx=FxFadepal(gPalettes.sweetie16mod) },
	{	s=0,	d=5,	vb=0,	fx=FxBalls(),		mod={mdKF("scale",0,0.5,4,1)} },
}

-- Levex
P4_Levex =
{
	{	s=0,			vb=0, 	fx=FxClsStart() },
	{	s=0,			vb=1, 	fx=FxCls() },
	{	s=0,	d=10, 	vb=1, 	fx=FxPalette(gPalettes.sweetie16mod) },
	{	s=0,	d=10, 	vb=1, 	fx=FxDraw("Levex.draw"), set={speed=30, Hack=true} },
}

-- Cube
P5_Cube =
{
	{	s=0,			vb=0, 	fx=FxCls() 	},
	{	s=0,			vb=1, 	fx=FxCls() 	},
	{	s=0,	d=10, 	vb=1,	fx=FxCube()	},
	{	s=1.8,	d=1.4, 	vb=0,	fx=FxBlower()},
}

-- Disolve
P6_Disolve =
{
	{	s=0,			vb=1, 	fx=FxCls() 	},
	{	s=0,	d=25,	vb=1,	fx=FxDisolve()	},
}

-- Terrain
P7_Terrain =
{
	{	s=0,			vb=1, 	fx=FxClsStart() 	},
	{	s=0,	d=1, 	vb=0, 	fx=FxPalette(gPalettes.black) },
	{	s=0,	d=3, 	vb=0, 	fx=FxFadepal(PaletteGradiant({0, Hex2RGB(0x000000), 15,Hex2RGB(0x2580ff) })) },
	{	s=10,	d=13, 	vb=0, 	fx=FxFadepal(PaletteGradiant({0, Hex2RGB(0x101020 --[[0x1a1c2c]]), 4, Hex2RGB(0x5d275d), 7, Hex2RGB(0xb13e53), 11,Hex2RGB(0xef7d57), 15,Hex2RGB(0xffcd75) }) ) },

	{	s=0,	d=44,  	vb=0,	fx=FxTerrain(),							mod={mdKF("alt",0,16,30,40), mdKF("mul",0,2,10,6,20,9,30,14) } },

	{	s=38,	d=5,	vb=1, 	fx=FxCls() 	},
	{	s=38,	d=5, 	vb=1, 	fx=FxText(50,50,"Code", gWhite), 		mod={mdKF("x",0,-100,1,50,4,50,5,-100), mdKF("y",0,-10,1,20,2,20,3,20,4,10,5,-10) } },
	{	s=38,	d=5, 	vb=1, 	fx=FxText(50,50,"Speedman", gWhite),	mod={mdKF("x",0,350,1,150,4,150,5,350), mdKF("y",0,-10,1,20,2,20,3,20,4,10,5,-10) } },
}

-- End
P8_End =
{
	{	s=0,	d=2.5,  vb=0,	fx=FxPowerOff()	},
	{	s=0,			vb=0, 	fx=FxClsStop() 	},
}

-- Sequence:Add(P0_Boot)
-- Sequence:Add(P1_TicLogo)
-- Sequence:Add(P_Imagec31)
-- Sequence:Add(P11_Tibet)
-- Sequence:Add(P2_Spectrals)
-- Sequence:Add(P3_Balls)
-- Sequence:Add(P4_Levex)
-- Sequence:Add(P5_Cube)
-- Sequence:Add(P6_Disolve)
-- Sequence:Add(P7_Terrain)
-- Sequence:Add(P8_End,-1.5)


-- Levex
PartSys =
{
	{	s=0,			vb=0, 	fx=FxCls() 	},
	{	s=0,	d=600,	vb=0,	fx={name="parts", start = function(_) _.ps=CreatePart() end, tic=function(_) _.ps:tic(_.dt) end}},
}
Sequence:Add(PartSys)

function Startfx(sh)
	local fx=sh.fx
	if fx.started then return end

	if sh.set then
		for k,v in pairs(sh.set) do
			fx[k]=v
		end
	end

	vbank(sh.vb)

	if fx.start then fx:start() end

	table.insert(RunningFx, sh)

	fx.started=true
	fx.t=0
	fx.dt=0
end

function Stopfx(sh)
	local fx = sh.fx
	if fx.started~=true then return end

	for k,it in pairs(RunningFx) do 
		if it==sh  then 
			vbank(sh.vb)
			if fx.stop then fx:stop() end
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
		return Outline(t,x,y,gWhite,gGrey,print,false,1,true)
	end

	if gInfos then
		vbank(1)

		-- global time
		rect(2,129,RectInfo1[1],RectInfo1[2], gBlack)
		RectInfo1=Info(string.format("%.1f",gTime),2,129)

		-- Fx
		local h=7
		rect(0,0,RectInfo2[1],RectInfo2[2],gBlack)
		local y=1
		for k,sh in pairs(RunningFx) do 
			local fx=sh.fx
			Info(string.format("%.1f",fx.t),2,y)
			Info(string.format("-%.1f",fx.d-fx.t),20,y)
			Info(string.format("%s %d", fx.name, sh.vb),40,y)
			y=y+h
		end
		RectInfo2={100, h*#RunningFx}

		-- CPU usage
		local tEnd=time()
		local tElapse=(tEnd-tStart)
		gDeltaTime=lerp(gDeltaTime,tElapse,.1)
		rect(225,128,RectInfo3[1],RectInfo3[2],gBlack)
		RectInfo3=Info(string.format("%.f %%",100*gDeltaTime/(1000/60)),225,129)
	end
end

function TIC()
	local tStart=time()
	vbank(1)

	-- Stop old
	for k,sh in pairs(RunningFx) do
		local fx=sh.fx
		local shouldrun = inrange(gTime, sh.s, sh.e)
		if not shouldrun then
			Stopfx(sh)
		end
	end

	-- start new
	local vclear = {true,true}
	for k,sh in pairs(Sequence.data) do
		local shouldrun = inrange(gTime,sh.s,sh.e)
		local fx = sh.fx
		if shouldrun then
			Startfx(sh)
			-- if (fx.cls == false) then
			-- 	vclear[sh.vb+1] = false
			-- end
		end
	end

	-- if vclear[1] then
	-- 	vbank(0)
	-- 	cls()
	-- end
	-- if vclear[2] then
	-- 	vbank(1)
	-- 	cls()
	-- end

	for k,sh in pairs(RunningFx) do 
		vbank(sh.vb)
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
		local fx=sh.fx
		if fx.bdr then
			vbank(sh.vbank)
			fx:bdr(row)
		end
	end
end
