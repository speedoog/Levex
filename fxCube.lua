
function rotatexyz(a,b,c)
	zrot = {
		{cos(a),-sin(a),0},
		{sin(a),cos(a),0},
		{0,0,1}
	}
	yrot = {
		{cos(b),0,sin(b)},
		{0,1,0},
		{-sin(b), 0, cos(b)}
	}
	xrot = {
		{1,0,0},
		{0,cos(c),-sin(c)},
		{0,sin(c),cos(c)}
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


function DrawCube(ox,oy,oz,rx,ry,rz)
	local projected = {}

	local tmp = rotatexyz(rx,ry,rz)

	for i=1,#points do
		local tmpxform = matmul(tmp,points[i])
		local pp = { tmpxform[1][1]+ox, tmpxform[2][1]-oy, tmpxform[3][1]+oz}
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
	-- 	circ(pp[1],pp[2],10*atan(1/z),10)
	-- end

	for i=1,#tris do
		local col = (1+i)//2
		local tria=tris[i]
		local a = projected[tria[1]]
		local b = projected[tria[2]]
		local c = projected[tria[3]]
		if  FaceOrient(a,b,c) < 0 then
			tri(a[1],a[2],b[1],b[2],c[1],c[2],col)
			line(a[1],a[2],b[1],b[2], 12)
			line(b[1],b[2],c[1],c[2], 12)
--			line(c[1],c[2],a[1],a[2], 11)
		end
	end

end	

function v3(x,y,z)
	return {{x},{y},{z}}
end

-- ############## Part 1 ##############
fxCube={
	name = "Cube"
	, start = function(self)
		points={v3(-1,-1,-1),v3(-1,1,-1),v3(1,1,-1),v3(1,-1,-1),v3(-1,-1,1),v3(-1,1,1),v3(1,1,1),v3(1,-1,1)}
		lines={	{1,2},{2,3},{3,4},{4,1},	-- bot
				{5,6},{6,7},{7,8},{8,5},	-- top
				{1,5},{2,6},{3,7},{4,8}}	-- verticals
		tris={
		{3,7,8},
		{8,4,3},
		{1,5,6},
		{6,2,1},
		{7,3,2},
		{2,6,7},
		{4,8,5},
		{5,1,4},
		{8,7,6},
		{6,5,8},
		{3,4,1},
		{1,2,3}
		}

		r = 5
		self.ox=0
		self.oy=0
		self.oz=0
		self.rx=0
		self.ry=0
		self.rz=0
	end
	, tic = function(self,t,dt)
		local at=dt*3

		if t<2 then
			self.ox=0
			self.oy=0
			self.oz=remap(t, 0, 2, 10, 0)^1.5
			self.rx=0
			self.ry=0
			self.rz=3*t
		elseif t<4 then
			self.ox=0
			self.oy=0
			self.oz=0
			self.rx=3*(cos(t-2)-1)
			self.ry=0
			self.rz=3*t
		else
			self.ox=5.5*sin(t-4)
			local _t=math.fmod(t*2+1.6, 2)-1
			self.oy=2-4*_t*_t
			self.oz=0
			self.rx=self.rx+at
			self.ry=self.ry+at*1.123
			self.rz=self.rz+at*1.478
		end

		DrawCube(self.ox,self.oy,self.oz,self.rx,self.ry,self.rz)

	end
}
