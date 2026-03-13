
FxDisolve = function()
	local fx = { name = "Disolve" }
	
	fx.scan = function(_,t,x0,x1,y0,y1)
		for y=y0,y1 do
			for x=x0,x1 do
				local c=pix(x,y)
				if c~=0 then 
					table.insert(_.list, {x=x,y=y,c=c,r=0,t=t+2+3*invEase(rand())})
				end
			end
		end
	end

	fx.start = function(_)
		_.list={}
		_.txt={
			"Tpolm", "Abyss", "Desire", "Nah-Kolor", "Fairlight", "Razor1911", "Hoffman", 
			"ASD", "Spaceballs", "DeadLiners", "Conspiracy", "Logicoma", "Bomb", "Futuris", "LFT",
			"Skaven", "Cookie Collective", "IQ", "Oxygene", "Limp Ninja", "Farbrausch", "Monad", "Rebels", "Calodox",
			"Cocoon", "Ninjadev", "Mercury", "Loonies", "Altair", "TBL", "Still", "Satori",
		}
		_.iTxt=-1

		table.sort(_.txt)	-- sort ascending

		cls()
		_:scan(0,0,gSizeX-1,0,gSizeY-1)
	end

	fx.tic = function(_, t, dt)
		local it=floor(t*1.7)
		if it>_.iTxt and it<#_.txt then
			_.iTxt=it
			local c=_.iTxt%12+2
			local s=_.txt[(_.iTxt%#_.txt)+1]
			local w=print(s,-500,-500, c, false, 1)
			local border=10
			seed(_.iTxt)
			local x=remap(rand(),0,1, border, gSizeX-w-border)
			local y=remap(rand(),0,1, border, gSizeY-8-border)
			for ix=-1,1 do
				for iy=-1,1 do
					print(s, x+ix, y+iy, c+6, false, 1)
				end
			end
			print(s, x, y, c, false, 1)
			_:scan(t,x-1,x+w+1,y-1,y+8-1)
		end

--		local mx,my,ml,mm,mr=mouse()
--		local mx,my=remap(sin(t), -1, 1, 0, gSizeX),gSizeY+150
		local mx,my=gSizeX/2+2*gSizeX*sin(t/2), gSizeY/2+2*gSizeY*cos(t/2)

		for k,it in pairs(_.list) do 
			local x1=it.x
			local y1=it.y
			if dt>0 and t>it.t then
				if it.r<0.5 then it.r=it.r+0.0003 end
				local dx=x1-mx
				local dy=y1-my
				local l=sqrt(dx*dx+dy*dy)
				local x,y=rotate(dx, dy, it.r*100/max(l,60))
				it.x=x*0.992+mx
				it.y=y*0.992+my
			end

			line(x1,y1,it.x,it.y,it.c)
			if t>(it.t+10) then 
				_.list[k]=nil
			end
		end

		return t>20
	end

	return fx
end
