
function DrawCube()
	local projected = {}
	for i=1,#points do
		local pp=projectPoint2(points[i],a)
		projected[i] = pp
	end

	for k,it in pairs(lines) do 
		line(projected[it[1]][1]+w/2,projected[it[1]][2]+h/2
			,projected[it[2]][1]+w/2,projected[it[2]][2]+h/2,k)
	end

	for i=1,#points do
		local pp=projected[i]
--		z=pp[3]
		circ(pp[1]+w/2,pp[2]+h/2,r,12)
	end

end	

-- ############## Part 1 ##############
Part2={
	init = function()
		t=0
		points = {
			{{20},{20},{20}},
			{{-20},{20},{20}},
			{{-20},{-20},{20}},
			{{20},{-20},{20}},
			{{20},{20},{-20}},
			{{-20},{20},{-20}},
			{{-20},{-20},{-20}},
			{{20},{-20},{-20}}
		}

		lines = {}
		for i=1,3 do
			table.insert(lines, { i+0, i+1 })
			table.insert(lines, { i+4, i+5 })
		end
		table.insert(lines, { 1, 4 })
		table.insert(lines, { 5, 8 })
		for i=1,4 do
			table.insert(lines, { i, i+4 })
		end

		a = 0
		w = 240
		h = 136
		r = 2

	end
	, tic = function()
		t=t+1/60
		vbank(1)
		cls()
		DrawCube()
		a = a + 0.01
		vbank(0)
		return t>5
	end
}
