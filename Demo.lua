
RunningFx = { }
Sequence = 
{
	{	0,		200, fxTerrain,		0},
--	{	0,		20, fxCPC,			1},
--	{	0,		20, fxCube,			1},
--	{	1.8,	3,  fxBlower,		0},
--	{	0,		20, fxScrollText,	0},
--	{	3,		15,	fxBeziers,		0},
--	{	15,		25,	fxDisolve,		0}
}

function Startfx(fx,vbank, start)
	if fx.started then return end
	fx:start()
	if vbank==nil then vbank=0 end
	table.insert(RunningFx, {fx=fx, start=start, vbank=vbank})
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

function main()

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
	
	vbank(1)
	cls()
	vbank(0)
	cls()

	for k,sh in pairs(Sequence) do 
		local shouldrun = inrange(gTime, sh[1], sh[2])
		local fx=sh[3]
		if shouldrun and fx.started~=true then
			Startfx(fx, sh[4], sh[1])
		end
	end

	local i=0
	for k,fh in pairs(RunningFx) do 
		vbank(fh.vbank)
		local fx=fh.fx
		local oldt=fx.t
		fx.t=gTime-fh.start
		fx.dt=fx.t-oldt
		fh.fx:tic(fx.t,fx.dt)
		
		if gInfos then print(string.format("%.1f %s",fx.t,fx.name), 0, i*7, gWhite,true)  end
		i=i+1
	end

	for k,sh in pairs(Sequence) do 
		local shouldrun = inrange(gTime, sh[1], sh[2])
		local fx=sh[3]
		if not shouldrun and fx.started then
			Stopfx(fx)
		end
	end

	if gInfos then print(string.format("%.2f",gTime), 0, 130, gWhite)  end

	if gPlay then gTime=gTime+1/60 end

end
