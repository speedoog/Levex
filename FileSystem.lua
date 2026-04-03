
function MemStream(ptr)
	local ms = {add = ptr,offset = 0}
	ms.Read = function(_)
		local data = peek(_.add+_.offset)
		_.offset = _.offset+1
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

function StringStream(str)
	local ss = {str = str,offset = 1, size=#str}
	ss.Read = function(_)
		local data = string.byte(_.str, _.offset)
		_.offset = _.offset+1
		return data
	end
	ss.ReadTable = function(_,n)
		local data = {}
		for i = 1,n do
			table.insert(data,_:Read())
		end
		return data
	end
	return ss
end

function FS_Load()
	local ms = MemStream(gAddMap)
	local Zipsize = ms:Read()<<8|ms:Read()

	local data = string.char(table.unpack(ms:ReadTable(Zipsize)))

	return inflate.new(data)
end

FS = FS_Load()

function FS_Open(fn)
	for name,offset,size,packed,crc in FS:files() do
		if name==fn then
			local content
			if packed then
				content = FS:inflate(offset,crc)
			else
				content = FS:extract(offset,size)
			end
			return StringStream(content)
		end
	end
	return nil
end

function FS_LoadScene(filename,clrColor)
	local scene = {npix = 0,items = {}}

	local fStream = FS_Open(filename)
	if fStream == nil then
		return scene
	end

	while true do
		local b = fStream:Read()
		if b == 0 then -- EOF
			break
		end

		local item
		local cmd = string.char(b)

		item = CreateItem(cmd)

		if item then
			local count = fStream:Read()
			local params = fStream:ReadTable(count)
			item:Load(params)
			table.insert(scene.items,item)
		end
	end

	ComputeTotalPix(scene,clrColor)
	return scene
end
