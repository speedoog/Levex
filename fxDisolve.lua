
FxDisolve = function()
	local fx = { name = "Disolve" }

	fx.scan = function(_,t,x0,y0,x1,y1,i)
		for y=y0,y1 do
			for x=x0,x1 do
				local c=pix(x,y)
				if c~=0 then 
					table.insert(_.list, {i=i,x=x,y=y,c=c,r=0,t=t+2+3*invEase(rand())})
				end
			end
		end
	end

	fx.Start = function(_)
		_.list={}
		_.txt={
			"Tpolm", "Abyss", "Desire", "Nah-Kolor", "Fairlight", "Razor1911", "Hoffman", 
			"ASD", "Spaceballs", "DeadLiners", "Conspiracy", "Logicoma", "Bomb", "Futuris", "LFT",
			"Skaven", "Cookie Collective", "IQ", "Oxygene", "Limp Ninja", "Farbrausch", "Monad", "Rebels", "Calodox",
			"Cocoon","Ninjadev","Mercury","Loonies","Altair","TBL","Still","Satori","Spectrox","Rez","Scoopex","Holon",
			"MFX","TRSI","Orange","Alcatraz","Exist","psenough","Mars","RBBS","Joker","Arise","Nuance",
			"Lemon","Melon","Spreadpoint","NuSan"
		}
		_.iTxt=-1
		_.p0 = {3,4,5,11,12}
		_.p1 = {1,7,8,15}

		table.sort(_.txt)	-- sort ascending

		cls()
--		_:scan(0,0,gSizeX-1,0,gSizeY-1)
	end
	fx.print=function(_,sz)
		local c0 = _.p0[_.iTxt%#_.p0+1]
		local c1 = _.p1[_.iTxt%#_.p1+1]
		local s=_.txt[(_.iTxt%#_.txt)+1]
		local w=print(s,-500,-500, c0, false, 2)
		local border=0
		seed(_.iTxt)
		local w2=w/2
		local h2=8
		local x=remap(rand(),0,1, border+w2, gSizeX-w2-border)
		local y=remap(rand(),0,1, border+h2, gSizeY-h2-border)
		if sz==1 then
			w2=w2/2
			h2=h2/2
		end
		StyleOutline(s,x-w2,y-h2,c0,print,c1,false,sz)
		return x,y,w2,h2
	end

	fx.tic = function(_, t, dt)

		local it = floor(t*2*BPS)
		local bDrawBig=false
		if it==_.iTxt then
			bDrawBig=true
		elseif it>_.iTxt and it<#_.txt then
			_.iTxt=it
			local x,y,w2,h2=_:print(1)
			_:scan(t,x-w2-1,y-h2-1, x+w2+1,y+h2-1,it)
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

			if it.i~=_.iTxt then
				line(x1,y1,it.x,it.y,it.c)
			end

			if t>(it.t+10) then 
				_.list[k]=nil
			end
		end

		if bDrawBig then
			_:print(2)
		end

		return t>20
	end

	return fx
end
