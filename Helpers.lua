
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

function FontWrap(t,x,y,c)
	local d = gWhite
	PaletteMap(d,c) -- swaps white color with wanted color
	local w=font(t,x,y,0,6,8,true,1)
	PaletteMap(d,d) -- change it back
	return w
end

function StyleNone(t,x,y,c,fn,...)
	fn(t,x,y,c,...)
end

function StyleOutline(t,x,y,c,fn,c2,...)
	local w = fn(t,500,500,c,...)
	for dx = -1,1 do
		for dy = -1,1 do
			fn(t,x+dx,y+dy,c2,...)
		end
	end
	fn(t,x,y,c,...)
	return {w+2,10}
end

function StyleStripes(t,x,y,c,fn,...)
	for dy=0,8 do
		clip(0, y+dy, 240, 1)
		fn(t, x, y, c+dy, ...)
	end
	clip()
end

function StyleItalic(t,x,y,c,fn,...)
	for dy = 0,8 do
		clip(0,y+dy,240,1)
		fn(t,x+4-dy/2,y,c,...)
	end
	clip()
end

function StyleShadow(t, x, y, c, c2)
	dx = 2
	dy = 2
	print(t, x + dx, y + dy, c2)
	print(t, x, y, c)
end



function CreateParticleSystem()
	local ps = {x=50, y=70, parts={}, rate=500, rad=1, rot=-1, spread=0.2, tt=0, life1=0.7, life2=1.5, spd1=50, spd2=100, gx=0, gy=200 }
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
		p.tidx = rand(0,3)

		-- life
		p.life = rand2(_.life1,_.life2)
		p.age=0
		p.trail={}
		table.insert(_.parts, p)
	end
	ps.tic=function(_,dt)
		--[[
		local ml,mr
		_.x,_.y,ml,mr=mouse()
		if ml then _.rot=_.rot+dt*4 end
		]]--

		_.tt = clamp(_.tt+dt,0,1)
		if _.tt>0 then
			local nbnew = floor(_.rate*_.tt)
			for i=1,nbnew do
				_:Spawn()
				_.tt = _.tt - 1/_.rate
			end
		end

		for k,p in pairs(_.parts) do
			p.age = p.age+dt
			if p.age>=p.life or p.age<0 then
				table.remove(_.parts, k)
			else
				if dt~=0 then
					table.insert(p.trail,{p.x,p.y})
					if #p.trail>3 then 
						table.remove(p.trail, 1)
					end

					p.vx = p.vx+_.gx*dt
					p.vy = p.vy+_.gy*dt
					p.x = p.x+p.vx*dt
					p.y = p.y+p.vy*dt
				end
				local c = remap(p.age/p.life,0,1,4.9,1)

				local idx = min(#p.trail,p.tidx)
				if idx<=0 then 
					pix(p.x,p.y,c)
				else
					local xo = p.trail[idx][1]
					local yo = p.trail[idx][2]
					line(xo,yo,p.x,p.y, c)
				end
			end
		end
	end
	return ps
end
