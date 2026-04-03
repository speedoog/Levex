
FxModel = function(filename)
	local fx = { name = filename }
	fx.Init  = function(_)
		_.vtx 	= {}
		_.faces = {}

		local fStream = FS_Open(_.name)
		if fStream == nil then
			return
		end

		local lines=Split(fStream.str, string.char(0x0A))
		for k,line in pairs(lines) do
			local params = Split(line)
			local cmd=params[1]
			table.remove(params, 1)
			if cmd=="v" then
				table.insert(_.vtx,params)
			elseif cmd=="f" then
				table.insert(_.faces,params)
			end
		end

	end
	fx.Start = function(_)
		_.ox = 0 _.oy = 0 _.oz = 0
		_.rx = 0 _.ry = 0 _.rz = 0
		_.scale = 1
	end

	fx.tic = function(_,t,dt)
		local mRot = rotatexyz(_.rx,_.ry,_.rz)
		local proj = _:Proj(mRot)
		_:Draw(proj)
	end

	fx.Proj = function(_,mRot)
		local v33 = function(v) return {{v[1]},{v[2]},{v[3]}} end
		local proj = {}
		for i = 1,#_.vtx do
			local tmpxform = matrixMul(mRot,v33(_.vtx[i]))
			local pp = {tmpxform[1][1]*_.scale+_.ox,tmpxform[2][1]*_.scale-_.oy,tmpxform[3][1]*_.scale+_.oz}
			proj[i] = projScreen(0.13,pp)	-- fov
		end
		return proj
	end

	fx.Draw=function(_,proj)
		local bDots,bWireframe,bFaces = false,false,true

		if bWireframe then
			for k,it in pairs(_.lines) do
				line(proj[it[1]][1],proj[it[1]][2],proj[it[2]][1],proj[it[2]][2],gWhite)
			end
		end

		if bDots then
			for k,pp in pairs(proj) do
				circ(pp[1],pp[2],10*atan(1/pp[3]),gWhite)
			end
		end

		if bFaces then
			for k,face in pairs(_.faces) do
				local fa = face[1]
				local pa = proj[fa]
				local nTri=#face-2
				for i=1,nTri do
					local col = k%5+1
					local fb = face[i+1]
					local fc = face[i+2]
					local pb = proj[fb]
					local pc = proj[fc]
					if FaceOrient(pa,pb,pc) < 0 then
						tri(pa[1],pa[2],pb[1],pb[2],pc[1],pc[2],col)
					end
				end
			end
		end
	end

	return fx
end
