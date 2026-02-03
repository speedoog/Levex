
function connect()
	local projected = {}
	for i=1,#points do
		projected[i] = projectPoint(i,a)
	end
	for i=1,3 do
		line(projected[i][1][1]+w/2,projected[i][2][1]+h/2,projected[i+1][1][1]+w/2,projected[i+1][2][1]+h/2,12)
		line(projected[i+4][1][1]+w/2,projected[i+4][2][1]+h/2,projected[i+5][1][1]+w/2,projected[i+5][2][1]+h/2,12)
	end
	line(projected[1][1][1]+w/2,projected[1][2][1]+h/2,projected[4][1][1]+w/2,projected[4][2][1]+h/2,12)
	line(projected[5][1][1]+w/2,projected[5][2][1]+h/2,projected[8][1][1]+w/2,projected[8][2][1]+h/2,12)
	for i=1,4 do
		line(projected[i][1][1]+w/2,projected[i][2][1]+h/2,projected[i+4][1][1]+w/2,projected[i+4][2][1]+h/2,12)
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

		a = 0
		w = 240
		h = 136
		r = 2

	end
	, tic = function()
		t=t+1/60
		vbank(1)
		cls()
		connect()
		a = a + 0.01
		vbank(0)
		return t>5
	end
}
