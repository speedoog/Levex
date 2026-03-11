-- -----------------------------------------------
--                      FS
-- -----------------------------------------------
MEM_Map = 0x08000

FS = {}

function FS_Load(FS)
	ptr = MEM_Map
	local count = peek(ptr)
	ptr = ptr + 1
	for ifile = 0, count - 1 do
		local f = {}
		name = ""
		while peek(ptr) ~= 0 do
			c = peek(ptr)
			ptr = ptr + 1
			name = name .. string.char(c)
		end
		ptr = ptr + 1
		szlo = peek(ptr)
		ptr = ptr + 1
		szhi = peek(ptr)
		ptr = ptr + 1
		szfull = szhi * 256 + szlo
		f.name = name
		f.size = szfull
		table.insert(FS, f)
	end

	baseAddress = ptr
	for k, f in pairs(FS) do
		f.add = baseAddress
		baseAddress = baseAddress + f.size
		c = peek(f.add)
	end
end

FS_Load(FS)

function Pop(address, count)
	local params = {}
	for i = 0, count - 1 do
		table.insert(params, peek(address + i))
	end
	return address + count, params
end

function FS_FindFile(fn)
	for k, f in pairs(FS) do
		if f.name == fn then
			return f
		end
	end
	return nil
end

function AppendItem(scene, item)
	if item ~= nil then
		table.insert(scene.items, item)
	end
end

function ComputeTotalPix(scene)
	scene.npix = 0
	for k, item in pairs(scene.items) do
		item:Init()
		item.npix = 0
		local iPix = 1
		while iPix > 0 do
			iPix = item:Draw()
			item.npix = item.npix + iPix
		end
		scene.npix = scene.npix + item.npix
	end
end

function FS_LoadScene(file)
	local scene = {}
	scene.npix = 0
	scene.items = {}

	local f = FS_FindFile(file)
	if f == nil then
		return scene
	end

	ptr = f.add
	while true do
		b = peek(ptr)
		ptr = ptr + 1
		if b == 0 then
			break
		end

		item = nil
		cmd = string.char(b)
		if cmd == "l" then
			ptr, item = CreateLineMem(ptr)
		-- elseif cmd == "e" then
		-- 	ptr, item = CreateEllipseMem(ptr)
		-- elseif cmd == "c" then
		-- 	ptr, item = CreateCircleMem(ptr)
		-- elseif cmd == "f" then
		-- 	ptr, item = CreateFillMem(ptr)
		end

		if item ~= nil then
			AppendItem(scene, item)
		end
	end

	ComputeTotalPix(scene)
	return scene
end

-- -----------------------------------------------
--                      Line
-- -----------------------------------------------

function CreateLineMem(ptr)
	local p, item
	ptr, p = Pop(ptr, 5)
	item = CreateLine(p[1], p[2], p[3], p[4], p[5])
	return ptr, item
end

function CreateLine(x0, y0, x1, y1, c)
	if c == nil then
		c = 10
	end

	local line = {}

	function line:Init()
		self.x = x0
		self.y = y0
		self.dx = abs(x1 - x0)
		self.dy = -abs(y1 - y0)

		if x0 < x1 then
			line.sx = 1
		else
			line.sx = -1
		end
		if y0 < y1 then
			line.sy = 1
		else
			line.sy = -1
		end

		self.err = self.dx + self.dy -- error value e_xy
		self.e2 = self.err
	end

	-- return pix drawn
	function line:Draw(fnPix)
		if fnPix ~= nil then
			fnPix(self.x, self.y, c)
		end

		if self.x == x1 and self.y == y1 then
			return 0
		end

		self.e2 = 2 * self.err

		if self.e2 >= self.dy then -- e_xy+e_x > 0
			self.err = self.err + self.dy
			self.x = self.x + self.sx
		end

		if self.e2 <= self.dx then -- e_xy+e_y < 0
			self.err = self.err + self.dx
			self.y = self.y + self.sy
		end

		return 1
	end

	return line
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
