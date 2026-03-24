
gSizeX = 240
gSizeY = 136
gSizeX2 = gSizeX / 2
gSizeY2 = gSizeY / 2

gBlack = 0
gRed = 2
gWhite = 12
gGrey = 15

gAddPalette = 0x3FC0
gAddPalMap 	= 0x3FF0
gAddBorderCol = 0x3FF8
gAddScreenOffX = 0x3FF9
gAddScreenOffY = 0x3FFA
gAddBlitSegment = 0x3FFC --https://github.com/nesbox/TIC-80/wiki/Bits-Per-Pixel
gAddMap = 0x8000

-- keys (https://skyelynwaddell.github.io/tic80-manual-cheatsheet/)
gKeySpace = 48
gKeyTab = 49
gKeyUp = 58
gKeyDown = 59
gKeyLeft = 60
gKeyRight = 61
gKeyCtrl = 63

function Outline(t,x,y,c,c2,fn,...)
	local w = print(t,500,500,c,...)
	for dx = -1,1 do
		for dy = -1,1 do
			fn(t,x+dx,y+dy,c2,...)
		end
	end
	fn(t,x,y,c,...)
	return {w+2,10}
end

function printshadow(t, x, y, c, c2)
	dx = 2
	dy = 2
	print(t, x + dx, y + dy, c2)
	print(t, x, y, c)
end

function printstripes(t, x, y)
	for dy = 0, 8 do
		clip(0, y + dy, 240, 1)
		print(t, x, y, dy + 2)
	end
	clip()
end

function CreatePart()
	local ps={x=50,y=70,parts={},rate=500,rad=1,rot=-1,spread=0.2,tt=0,life1=4,life2=6,spd1=2,spd2=4,gx=0,gy=5}
	ps.Spawn=function(_)
		local p = {}

		-- pos
		local rr = _.rad*sqrt(rand())
		local theta = rand()*2*pi
		p.x = _.x+rr*cos(theta)
		p.y = _.y+rr*sin(theta)
		p.xo = p.x
		p.yo = p.y

		-- dir
		local dir = _.rot + 0.5*rand2(-_.spread,_.spread)
		local rndSpd=rand2(_.spd1,_.spd2)
		p.vx = cos(dir)*rndSpd;
		p.vy = sin(dir)*rndSpd;

		-- life
		p.life = rand2(_.life1,_.life2)
		p.age=0
		table.insert(_.parts, p)
	end
	ps.tic=function(_,dt)
		local ml,mr
		_.x,_.y,ml,mr=mouse()
		if ml then _.rot=_.rot+dt*4 end

		if mr then 
			_.tt = _.tt+dt
			while _.tt>0 do
				_:Spawn()
				_.tt = _.tt-(1/_.rate)
			end
		end

		for k,p in pairs(_.parts) do
			p.age = p.age+dt
			if p.age>=p.life then
				table.remove(_.parts, k)
			else
				p.xo = p.x
				p.yo = p.y

				p.vx = p.vx+_.gx*dt
				p.vy = p.vy+_.gy*dt
				p.x = p.x+p.vx
				p.y = p.y+p.vy

				line(p.xo,p.yo,p.x,p.y, lerp(1,15,p.age/p.life) )
			end
		end
	end
	return ps
end