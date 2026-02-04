
function rotatexyz(a)
	zrot = {
		{math.cos(a),-math.sin(a),0},
		{math.sin(a),math.cos(a),0},
		{0,0,1}
	}
	yrot = {
		{math.cos(a),0,math.sin(a)},
		{0,1,0},
		{-math.sin(a), 0, math.cos(a)}
	}
	xrot = {
		{1,0,0},
		{0,math.cos(a),-math.sin(a)},
		{0,math.sin(a),math.cos(a)}
	}
	pm = {{1,0,0},{0,1,0}, {0,0,1}}
	return matmul(matmul(matmul(pm, xrot),yrot),zrot)
end

function projectPoint2(point,a)
	local tmp = rotatexyz(a)
	local projected = matmul(tmp,point)
	return { projected[1][1], projected[2][1], projected[3][1]}
end

function to_screen(ww,p)
	local z = 5+p[3]
	local w = ww*10/(z)
	local x = (p[1]*w+1)*68+52
	local y = (p[2]*w+1)*68
	return {x,y,z}
end

-- ///////////////////////////
-- dot product
function dot(v1, v2)
	return v1[1] * v2[1] + v1[2] * v2[2] + v1[3] * v2[3]
end

-- subtract 2 vectors
function minus(v1, v2)
	return {v1[1] - v2[1], v1[2] - v2[2], v1[3] - v2[3]}
end

-- cross product
function cross(v1, v2)
	x = (v1[2] * v2[3]) - (v1[3] * v2[2])
	y = (v1[3] * v2[1]) - (v1[1] * v2[3])
	z = (v1[1] * v2[2]) - (v1[2] * v2[1])
	return {x,y,z}
end

-- 1 if a poly is dead-on, 0 if parallel with camera, negative if facing away
function FaceOrient(v1, v2, v3)
	local a = cross(minus(v2, v1), minus(v3, v1))
	return a[3]
end

-- ///////////////////////////


function DrawCube()
	local projected = {}

	local tmp = rotatexyz(a)

	for i=1,#points do
		local tmpxform = matmul(tmp,points[i])
		local pp = { tmpxform[1][1], tmpxform[2][1], tmpxform[3][1]}
		local xy=to_screen(0.1, pp)
		projected[i] = xy
	end

	-- for k,it in pairs(lines) do 
	-- 	line(projected[it[1]][1],projected[it[1]][2]
	-- 		,projected[it[2]][1],projected[it[2]][2],k)
	-- end

	-- for i=1,#points do
	-- 	local pp=projected[i]
	-- 	z=pp[3]
	-- 	circ(pp[1],pp[2],5*atan(1/z),12)
	-- end

	for i=1,#tris do
		local col = 1+i%4
		local tria=tris[i]
		local a = projected[tria[1]]
		local b = projected[tria[2]]
		local c = projected[tria[3]]
		if  FaceOrient(a,b,c) < 0 then
			tri(a[1],a[2],b[1],b[2],c[1],c[2],col)
			line(a[1],a[2],b[1],b[2], 11)
			line(b[1],b[2],c[1],c[2], 11)
			line(c[1],c[2],a[1],a[2], 11)
		end
	end

end	

function v3(x,y,z)
	return {{x},{y},{z}}
end

-- ############## Part 1 ##############
Part2={
	init = function()
		t=0

		points={v3(-1,-1,-1),v3(-1,1,-1),v3(1,1,-1),v3(1,-1,-1),v3(-1,-1,1),v3(-1,1,1),v3(1,1,1),v3(1,-1,1)}
		lines={	{1,2},{2,3},{3,4},{4,1},	-- bot
				{5,6},{6,7},{7,8},{8,5},	-- top
				{1,5},{2,6},{3,7},{4,8}}	-- verticals
		tris={
		{3,7,8},
		{3,8,4},
		{1,5,6},
		{1,6,2},
		{7,3,2},
		{7,2,6},
		{4,8,5},
		{4,5,1},
		{8,7,6},
		{8,6,5},
		{3,4,1},
		{3,1,2}}

		a=0
		r = 2
	end
	, tic = function()
		t=t+1/60
--		vbank(1)
		cls()
		DrawCube()
--		a = a + 0.02*(1.5+sin(t)) --0.01
		a = a + 0.04
--		vbank(0)

		return t>10
	end
}
