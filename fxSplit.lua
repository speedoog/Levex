FxSplit = function()
	local fx = {
		name = "Split",
		cls=false,
		tic = function(_,t)
	t = floor(t*60)

	--[[
		if (t<20) then
			cls()
			seed(0)
			for i=0,50*t do
				circ(sx*rand(), sy*rand(), 0.5*t*rand(), 1+14*rand())
			end
		else]]
			local cnt=20
			local lx = floor(gSizeX/cnt)
			seed(1)
			for ix=0,cnt do
				local ox = ix*lx
				local st=300*rand()
				if t>st then
					local lctime = t-st

					if lctime<60 then

						local loops = (lctime*0.05)^2
						for l=0,loops do
							for py=gSizeY,0,-1 do
								for px=0,lx-1 do
									local gx = ox+px
									local c = pix(gx,py)
									pix(gx,py+1,c)
								end
							end
						end
					end

					line(ox,0,ox+lx-1,0,0)
				end
			end

		end
	}
	return fx
end
