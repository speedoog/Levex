

-- ############## Part 1 ##############
Part1={
	scan = function()
		for y=0,136 do
			for x=0,240 do
				c=pix(x,y)
				if c~=0 then 
					table.insert(list, {x=x,y=y,c=c,r=0,t=t+2+3*invEase(rand())})
				end
			end
		end
	end
	,init = function()
		list={}
		txt={"Hello", "Revision", "Welcome", "to", "my", "Demo"	}
		iTxt=-1
		t=0
		cls()

		PartCur.scan()

--		shuffle(list)
	end
	, tic = function()
		t=t+1/60
		cls()
		
		if floor(t)>iTxt then
			iTxt=floor(t)
			print(txt[(iTxt%#txt)+1], rand()*gSizeX, rand()*gSizeY, iTxt%16, false, 1)
			PartCur.scan()
		end

		local mx,my,ml,mm,mr=mouse()
		
		for k,it in pairs(list) do 
			x1=it.x
			y1=it.y
			if t>it.t then
				if it.r<0.5 then it.r=it.r+0.0003 end
				dx=x1-mx
				dy=y1-my
				l=sqrt(dx*dx+dy*dy)
				x,y=rotate(dx, dy, it.r*100/max(l,60))
				it.x=x*0.992+mx
				it.y=y*0.992+my
			end
			line(x1,y1,it.x,it.y,it.c)
			if t>(it.t+10) then 
				list[k]=nil
			end
		end

		return t>20
	end
}
