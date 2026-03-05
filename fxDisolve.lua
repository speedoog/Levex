

-- ############## Part 1 ##############
fxDisolve = function()
	local fx = {
		name = "Disolve",
		scan = function(self,t)
			for y=0,136 do
				for x=0,240 do
					local c=pix(x,y)
					if c~=0 then 
						table.insert(self.list, {x=x,y=y,c=c,r=0,t=t+2+3*invEase(rand())})
					end
				end
			end
		end,
		start = function(self)
			self.list={}
			txt={
				"Tpolm", "Abyss", "Desire", "Nah-Kolor", "Fairlight", "Razor1911", "Hoffman", 
				"ASD", "Spaceballs", "DeadLiners", "Conspiracy", "Logicoma", "Bomb", "Futuris", "LFT",
				"Skaven", "Cookie Collective", "IQ", "Oxygene", "Limp Ninja", "Farbrausch", "Monad", "Rebels", "Calodox",
				"Cocoon", "Ninjadev", "Mercury", "Loonies", "Altair", "TBL", "Still", "Satori",
			}
			iTxt=-1

			table.sort(txt)	-- sort ascending

			cls()
			self:scan(0)
		end,
		tic = function(self, t, dt)
			local it=floor(t*1.3)
			if it>iTxt and it<#txt then
				iTxt=it
				local c=iTxt%12+2
				local s=txt[(iTxt%#txt)+1]
				local w=print(s,-500,-500, c, false, 1)
				local b=10
				seed(iTxt)
				local x=remap(rand(),0,1, b, gSizeX-w-b)
				local y=remap(rand(),0,1, b, gSizeY-8-b)
				for a=-1,1 do
					for b=-1,1 do
						print(s, x+a, y+b, c+6, false, 1)
					end
				end
				print(s, x, y, c, false, 1)
				self:scan(t)
			end

--			local mx,my,ml,mm,mr=mouse()
--			local mx,my=remap(sin(t), -1, 1, 0, gSizeX),gSizeY+150
			local mx,my=gSizeX/2+2*gSizeX*sin(t/2), gSizeY/2+2*gSizeY*cos(t/2)
			
			for k,it in pairs(self.list) do 
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
					self.list[k]=nil
				end
			end

			return t>20
		end
	}
	return fx
end
