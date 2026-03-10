function v3(x,y,z)
	return {{x},{y},{z}}
end

FxCube = function()
	local fx = {
		name = "Cube",
		start = function(_)
			_.points = {v3(-1,-1,-1),v3(-1,1,-1),v3(1,1,-1),v3(1,-1,-1),v3(-1,-1,1),v3(-1,1,1),v3(1,1,1),v3(1,-1,1)}
			_.lines = {{1,2},{2,3},{3,4},{4,1}, -- bot
				{5,6},{6,7},{7,8},{8,5}, -- top
				{1,5},{2,6},{3,7},{4,8}} -- verticals
			_.tris = {{3,7,8},{8,4,3},{1,5,6},{6,2,1},{7,3,2},{2,6,7},{4,8,5},{5,1,4},{8,7,6},{6,5,8},{3,4,1},{1,2,3}}
			_.ox = 0
			_.oy = 0
			_.oz = 0
			_.rx = 0
			_.ry = 0
			_.rz = 0
		end,
		tic = function(_,t,dt)
			local at = dt*3

			if t < 2 then
				_.ox = 0
				_.oy = 0
				_.oz = remap(t,0,2,10,0)^1.5
				_.rx = 0
				_.ry = 0
				_.rz = 3*t
			elseif t < 4 then
				_.ox = 0
				_.oy = 0
				_.oz = 0
				_.rx = 3*(cos(t-2)-1)
				_.ry = 0
				_.rz = 3*t
			else
				_.ox = 5.5*sin(t-4)
				local _t = math.fmod(t*2+1.6,2)-1
				_.oy = 2-4*_t*_t
				_.oz = 0
				_.rx = _.rx+at
				_.ry = _.ry+at*1.123
				_.rz = _.rz+at*1.478
			end

			_:DrawCube()
		end,
		DrawCube = function(_)
			local mRot = rotatexyz(_.rx,_.ry,_.rz)

			local proj = {}
			for i = 1,#_.points do
				local tmpxform = matmul(mRot,_.points[i])
				local pp = {tmpxform[1][1]+_.ox,tmpxform[2][1]-_.oy,tmpxform[3][1]+_.oz}
				local xy = ToScreen(0.1,pp)
				proj[i] = xy
			end

			-- for k,it in pairs(_.lines) do
			-- 	line(projected[it[1]][1],projected[it[1]][2]
			-- 		,projected[it[2]][1],projected[it[2]][2],k)
			-- end

			-- for i=1,#_.points do
			-- 	local pp=projected[i]
			-- 	z=pp[3]
			-- 	circ(pp[1],pp[2],10*atan(1/z),10)
			-- end

			for i = 1,#_.tris do
				local col = (1+i)//2
				local tria = _.tris[i]
				local a = proj[tria[1]]
				local b = proj[tria[2]]
				local c = proj[tria[3]]
				if FaceOrient(a,b,c) < 0 then
					tri(a[1],a[2],b[1],b[2],c[1],c[2],col)
					line(a[1],a[2],b[1],b[2],12)
					line(b[1],b[2],c[1],c[2],12)
--				line(c[1],c[2],a[1],a[2], 11)
				end
			end
		end

	}

	return fx
end
