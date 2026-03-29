FxZoom = function()
	local fx = { name="Zoom", img={}, ctx=100, cty=88, speed=1}
	fx.Start = function(_)
		for i=0,gSizeX*gSizeY-1 do
			_.img[i]=peek4(i)
		end
	end

	fx.tic = function(_,t)
		cls()
		-- lerp center
		local cl=clamp(remap(t,0,_.d/2.5,0,1),0,1)
		local cx=lerp(gSizeX2, _.ctx, cl)
		local cy=lerp(gSizeY2, _.cty, cl)
		local scale = exp(t*_.speed)

		local sx=gSizeX2/scale
		local sy=gSizeY2/scale
		local x0,x1,y0,y1	--=u,gSizeX-u,u,gSizeY-u
		x0 = cx-sx
		x1 = cx+sx
		y0 = cy-sy
		y1 = cy+sy
		for y = 0,gSizeY-1 do
			local yy=round(remap(y,0,gSizeY-1,y0,y1))
			for x=0,gSizeX-1 do
				local xx=round(remap(x,0,gSizeX-1,x0,x1))
				local idx=yy*gSizeX+xx
				local c=_.img[idx]
				pix(x,y,c)
			end
		end
	end

	return fx
end
