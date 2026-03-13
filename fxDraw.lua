-- -----------------------------------------------
--                      FS
-- -----------------------------------------------
FS = {}

function MemStream(ptr)
	local ms={add=ptr,offset=0}

	ms.Ptr=function(_) return _.add+_.offset end
	ms.Inc=function(_) _.offset = _.offset+1 end
	ms.Read = function(_)
		local data = peek(_:Ptr())
		_:Inc()
		return data
	end
	ms.ReadTable = function(_,n)
		local data = {}
		for i = 1,n do
			table.insert(data,_:Read())
		end
		return data
	end
	return ms
end

function FS_Load(FS)
	local ms = MemStream(gAddMap)
	local nFileCount = ms:Read()
	for ifile = 0,nFileCount-1 do
		local f = MemStream()
		f.name = ""
		while true do
			local c = ms:Read()
			if c==0 then break end
			f.name = f.name .. string.char(c)
		end

		local szlo = ms:Read()
		local szhi = ms:Read()
		f.size = (szhi<<8)+szlo

		table.insert(FS,f)
	end

	local baseAddress = ms:Ptr()
	for k, f in pairs(FS) do
		f.add = baseAddress
		baseAddress = baseAddress + f.size
	end
end

FS_Load(FS)

function Pop(address, count)
	if count==nil then
		local data=peek(address)
		return address+1, data
	else
		local params = {}
		for i = 0, count - 1 do
			table.insert(params, peek(address + i))
		end
		return address + count, params
	end
end

function FS_Open(fn)
	for k,f in pairs(FS) do
		if f.name == fn then
			f.offset=0
			return f
		end
	end
	return nil
end

function FS_LoadScene(file)
	local scene = {npix = 0, items = {}}

	local f = FS_Open(file)
	if f == nil then
		return scene
	end

	local Factory = {
		["l"] = CreatePolyLine,
		["s"] = CreateSpline,
	}

	while true do
		local b = f:Read()
		if b == 0 then		-- EOF
			break
		end

		local item
		local cmd = string.char(b)

		local fnCreate = Factory[cmd]
		if fnCreate then
			item = fnCreate()
		end

		if item then
			local count = f:Read()
			local params=f:ReadTable(count)
			item:Load(params)
			table.insert(scene.items,item)
		end
	end

	ComputeTotalPix(scene)
	return scene
end

function ComputeTotalPix(scene)
	scene.npix = 0
	for k,item in pairs(scene.items) do
		item:Init()
		item.npix = 0
		local iPix = 1
		while iPix > 0 do
			iPix = item:Draw()
			item.npix = item.npix+iPix
		end
		scene.npix = scene.npix+item.npix
	end
end

-- -----------------------------------------------
--                      Line
-- -----------------------------------------------

function PlotLine(x0,y0,x1,y1,c,fn)
	if fn == nil then fn = pix end

	local dx = abs(x1-x0)
	local dy = -abs(y1-y0)

	local sx,sy
	if x0 < x1 then sx = 1 else sx = -1 end
	if y0 < y1 then sy = 1 else sy = -1 end

	local err = dx+dy -- error value e_xy
	local e2 = err
	local b = true
	local iPix = 0
	while (b) do
		iPix = iPix+1
		fn(x0,y0,c)
		e2 = 2*err
		if e2 >= dy then -- e_xy+e_x > 0
			if x0 == x1 then b = false end
			err = err+dy
			x0 = x0+sx
		end
		if e2 <= dx then -- e_xy+e_y < 0
			if y0 == y1 then b = false end
			err = err+dx
			y0 = y0+sy
		end
	end
	return iPix
end

function CreatePolyLine(c)
	if c == nil then c = 10 end

	local item =
	{
		nPix = 0,
		type = "l",
		c = c,
		pts = {},
		i = 1
	}

	function item.Load(_,p)
		_.c = p[1]
		local ptcount = (#p-1)>>1
		for i = 1,ptcount do
			_.pts[i] = {p[i*2],p[1+i*2]}
		end
	end

	function item.Save(_)
		local s = {}
		table.insert(s,_.c)
		for k,v in pairs(_.pts) do
			table.insert(s,v[1])
			table.insert(s,v[2])
		end
		return s
	end

	function item.InitSeg(_,i)
		_.i = i

		if #_.pts < 2 then return end

		local p0 = _.pts[i]
		local p1 = _.pts[i+1]
		_.x = p0[1]
		_.y = p0[2]
		_.x1 = p1[1]
		_.y1 = p1[2]
		_.dx = abs(_.x1-_.x)
		_.dy = -abs(_.y1-_.y)

		if _.x < _.x1 then _.sx = 1 else _.sx = -1 end
		if _.y < _.y1 then _.sy = 1 else _.sy = -1 end

		_.err = _.dx+_.dy -- error value e_xy
		_.e2 = _.err
	end

	function item.Init(_)
		_:InitSeg(1)
	end

	function item.Draw(_,fnPix)
		if fnPix ~= nil then
			fnPix(_.x,_.y,_.c)
		end

		while _.x == _.x1 and _.y == _.y1 do -- completed line ?
			local i = _.i+1
			if i >= #_.pts then
				return 0 -- was last segment
			else
				_:InitSeg(i) -- next segment
			end
		end

		_.e2 = 2*_.err

		if _.e2 >= _.dy then -- e_xy+e_x > 0
			_.err = _.err+_.dy
			_.x = _.x+_.sx
		end

		if _.e2 <= _.dx then -- e_xy+e_y < 0
			_.err = _.err+_.dx
			_.y = _.y+_.sy
		end

		return 1
	end

	return item
end

function CreateSpline(c)
	if c == nil then c = 10 end

	local item =
	{
		nPix = 0,
		c = c,
		pts = {},
		type = "s",
		t = 0,
		i = 0,
		tend = 0,
		keys = {},
	}

	function item.Load(_,p)
		_.c = p[1]
		local ptcount = (#p-1)>>1
		for i = 1,ptcount do
			_.pts[i] = {p[i*2],p[1+i*2]}
		end
	end

	function item.Save(_)
		local s = {}
		table.insert(s,_.c)
		for k,v in pairs(_.pts) do
			table.insert(s,v[1])
			table.insert(s,v[2])
		end
		return s
	end

	function item.Init(_)
		_.i = 0
		_.t = 0
		_.keys = {} -- build up CatmullRom keys
		local t = 0
		local x1,y1,x2,y2
		for k,v in pairs(_.pts) do
			x2 = v[1]
			y2 = v[2]
			if x1 ~= nil then
				t = t+distance(x1,y1,x2,y2)
			end
			table.insert(_.keys,t)
			table.insert(_.keys,x2)
			table.insert(_.keys,y2)
			x1 = x2
			y1 = y2
		end
		_.tend = t
	end

	function item.Draw(_,fnPix)
		local dt = 3
		local tprev = _.t
		_.t = _.t+dt
		_.i = _.i+1

		if _.t > _.tend then
			_.t = _.tend
		end

		local v0 = CatmullRom(_.keys,2,tprev)
		local v1 = CatmullRom(_.keys,2,_.t)
		local iPix = 0
		if fnPix ~= nil then
			PlotLine(floor(v0[1]),floor(v0[2]),floor(v1[1]),floor(v1[2]),_.c,fnPix) -- c+2*(_.i&1)
		end

		if _.t < _.tend then
			return 1
		else
			return 0
		end
	end

	return item
end


FxDraw = function(file)
	local fx = {
		name = "Draw",
		speed = 100,
		Init = function(self)
			self.scene = FS_LoadScene(file)
		end,
		start = function()
		end,
		tic = function(_, t)
			local PixTarget = t*_.speed

			local iPix = 0
			local bComplete = false
			local bContinue
			for k, item in pairs(_.scene.items) do
				bContinue = true
				item:Init()
				while bContinue do
					iPix = iPix + 1
					bContinue =item:Draw(function(x, y, c) pix(x, y, c) end) > 0
					if iPix >= PixTarget then
						bComplete = true
						bContinue = false
					end
				end
				if bComplete then
					break
				end
			end
		end
	}
	return fx
end
