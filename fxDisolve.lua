

-- ############## Part 1 ##############
fxDisolve={
	name = "Disolve"
	, scan = function(self,t)
		for y=0,136 do
			for x=0,240 do
				local c=pix(x,y)
				if c~=0 then 
					table.insert(self.list, {x=x,y=y,c=c,r=0,t=t+2+3*invEase(rand())})
				end
			end
		end
	end
	,start = function(self)
		self.list={}
		txt={"Hello", "Revision", "Welcome", "to", "my", "Demo"	}
		iTxt=-1

		cls()
		self:scan(0)
	end
	, tic = function(self, t, dt)
		
		if floor(t)>iTxt then
			iTxt=floor(t)
			print(txt[(iTxt%#txt)+1], rand()*gSizeX, rand()*gSizeY, iTxt%16, false, 1)
			self:scan(t)
		end

		local mx,my,ml,mm,mr=mouse()
		
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
