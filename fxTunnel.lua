FxTunnel = function()
	local fx = {
		name = "Tunnel",
		tic = function(self, t, dt)
			w=240
			h=136
			i=2
			for x=0,w,i do
				for y=0+t,h,i do
					x_=x-w/2
					y_=y-h/2
					zmin=min(abs(x_),abs(y_))
					zmax=max(abs(x_),abs(y_))
					z=100/zmax
					z_=z+4*t
					
					if abs(x_)>abs(y_) then
						seed(floor(2*z_)*floor(5*y_/x_)+35)
					else
						seed(floor(2*z_)*floor(5*x_/y_)+17)
					end
					
--					rand();rand()
					if z<10 and rand()>max(0.9+0.1*cos(t/6),0.8) then
						pix(x,y,min(zmax/20,2)+1)
					end
		--   pix(x,y,z_%8+1)
				end
			end

		--[[
 loop=2
 s=t//loop
 seed(s)
 
 nb=10
 for i=0,nb do
 d=(t%loop+(i/nb))

---
	r=2*rand()-1
	if rand()>0.5 then
	 x=r
		if rand()>0.5 then
			y=-1
		else
		 y=1
		end
	else
		y=r
		if rand()>0.5 then
			x=-1
		else
		 x=1
		end
	end
	
	ox=(abs(x)==1)
	oy=(abs(y)==1)
	
	px=nil
	for a=0,1,0.05 do
		x=x*0.95
		y=y*0.95
		if rand()>0.8 then
		 if oy then
			 x=x*1.2
			else
			 y=y*1.2
			end
		end
		if abs(a-d)<0.01 then
 		circ(remap(x,-1,1,0,w)
							,remap(y,-1,1,0,h)
							,1.5,12)
		end
		if abs(a-d)<0.1 and px~=nil then
 		line(remap(px,-1,1,0,w)
							,remap(py,-1,1,0,h)
				   ,remap(x,-1,1,0,w)
							,remap(y,-1,1,0,h)
							,4)
		end
		px=x
		py=y
	end
end	
--	print(r)
--	line(
	
	tl = t%10
	if tl>3 then
		print("WE",min(50*(tl-3),50),50,13, false, 1.5)
	end
	
	if tl>5 then
		print("ARE",70 ,min(100*(tl-5),70),13, false, 2)
	end
	
	if tl>7 then
		print("MANY",90+2*sin(t*50)*sin(t*50),100,13, false, (tl-5))
	end
	
--]]
		end
	}
	return fx
end
