
RunningFx = { }
Sequence = 
{
	{	0,	20, fxCube,		1},
	{	3,	15,	fxBeziers,	0},
	{	15,	25,	fxDisolve,	0}
}

function Startfx(fx,vbank)
	if fx.started then return end
	fx:init()
	if vbank==nil then vbank=0 end
	table.insert(RunningFx, {fx=fx, start=gTime,vbank=vbank})
	fx.started=true
	fx.t=0
	fx.dt=0
end

function Stopfx(fx)
	if fx.started~=true then return end
	for k,it in pairs(RunningFx) do 
		if it.fx==fx  then 
			RunningFx[k]=nil
		end
	end
end

-- ############## Demo ##############
gTime=0

function main()
	
	vbank(1)
	cls()
	vbank(0)
	cls()

	for k,sh in pairs(Sequence) do 
		local shouldrun = inrange(gTime, sh[1], sh[2])
		local fx=sh[3]
		if shouldrun and fx.started~=true then
			Startfx(fx, sh[4])
		end
	end

	for k,fh in pairs(RunningFx) do 
		vbank(fh.vbank)
		local fx=fh.fx
		local oldt=fx.t
		fx.dt=gTime-oldt
		fx.t=gTime-fh.start
		fh.fx:tic(fx.t)
	end

	for k,sh in pairs(Sequence) do 
		local shouldrun = inrange(gTime, sh[1], sh[2])
		local fx=sh[3]
		if not shouldrun and fx.started then
			Stopfx(fx)
		end
	end

	gTime=gTime+1/60

end
