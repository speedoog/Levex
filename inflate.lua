
local rshift=function(x,n) return x>>n end
local lshift=function(x,n) return x<<n end
local band  =function(a,b) return a&b end

local ORDER = {17, 18, 19, 1, 9, 8, 10, 7, 11, 6, 12, 5, 13, 4, 14, 3, 15, 2, 16}
local NBT = {2, 3, 7}

-- *********** FOR STATIC ***********
local CNT  = {144, 112, 24, 8}
local DPT = {8, 9, 7, 8}
local STATIC_HUFFMAN = {[0] = 5, 261, 133, 389, 69, 325, 197, 453, 37, 293, 165, 421, 101, 357, 229, 485, 21, 277, 149, 405, 85, 341, 213, 469, 53, 309, 181, 437, 117, 373, 245, 501}
local STATIC_BITS = 5
-- *********** FOR STATIC ***********

local CHUNK_SIZE = 4096

local function peekBits(stream, int)
	local buffer, bits, count, position = stream.buffer, stream.bits, stream.count, stream.position
	while count < int do
		bits = bits+lshift(string.byte(buffer,position),count)
		position = position + 1
		count = count + 8
	end
	stream.bits = bits
	stream.position = position
	stream.count = count
	return band(bits, lshift(1, int) - 1)
end

local function getBits(stream, int)
	local result = peekBits(stream, int)
	stream.bits = rshift(stream.bits, int)
	stream.count = stream.count - int
	return result
end

local function getElement(stream, hufftable, int)
	local element = hufftable[peekBits(stream, int)]
	local length = band(element, 15)
	local result = rshift(element, 4)
	stream.bits = rshift(stream.bits, length)
	stream.count = stream.count - length
	return result
end

local function huffman(depths)
	local size = #depths
	local blocks, codes, hufftable = {[0] = 0}, {}, {}
	local bits, code = 1, 0
	for i = 1, size do
		local depth = depths[i]
		if depth > bits then
			bits = depth
		end
		blocks[depth] = (blocks[depth] or 0) + 1
	end
	for i = 1, bits do
		code = (code + (blocks[i - 1] or 0)) * 2
		codes[i] = code
	end
	for i = 1, size do
		local depth = depths[i]
		if depth > 0 then
			local element = (i - 1) * 16 + depth
			local rcode = 0
			for j = 1, depth do
				rcode = rcode + lshift(band(1, rshift(codes[depth], j - 1)), depth - j)
			end
			for j = 0, 2 ^ bits - 1, 2 ^ depth do
				hufftable[j + rcode] = element
			end
			codes[depth] = codes[depth] + 1
		end
	end
	return hufftable, bits
end

local function loop(output, stream, litTable, litBits, distTable, distBits)
	local index = #output + 1
	local lit
	repeat
		lit = getElement(stream, litTable, litBits)
		if lit < 256 then
			output[index] = lit
			index = index + 1
		elseif lit > 256 then
			local bits, size, dist = 0, 3, 1
			if lit < 265 then
				size = size + lit - 257
			elseif lit < 285 then
				bits = rshift(lit - 261, 2)
				size = size + lshift(band(lit - 261, 3) + 4, bits)
			else
				size = 258
			end
			if bits > 0 then
				size = size + getBits(stream, bits)
			end
			local element = getElement(stream, distTable, distBits)
			if element < 4 then
				dist = dist + element
			else
				bits = rshift(element - 2, 1)
				dist = dist + lshift(band(element, 1) + 2, bits) + getBits(stream, bits)
			end
			local position = index - dist
			repeat
				output[index] = output[position]
				index = index + 1
				position = position + 1
				size = size - 1
			until size == 0
		end
	until lit == 256
end

local function dynamic(output, stream)
	local lit, dist, length = 257 + getBits(stream, 5), 1 + getBits(stream, 5), 4 + getBits(stream, 4)
	local depths = {}
	for i = 1, length do
		depths[ORDER[i]] = getBits(stream, 3)
	end
	for i = length + 1, 19 do
		depths[ORDER[i]] = 0
	end
	local lengthTable, lengthBits = huffman(depths)
	local i = 1
	local total = lit + dist + 1
	repeat
		local element = getElement(stream, lengthTable, lengthBits)
		if element < 16 then
			depths[i] = element
			i = i + 1
		elseif element < 19 then
			local int = NBT[element  - 15]
			local count = 0
			local num = 3 + getBits(stream, int)
			if element == 16 then
				count = depths[i - 1]
			elseif element == 18 then
				num = num + 8
			end
			for _ = 1, num do
				depths[i] = count
				i = i + 1
			end
		end
	until i == total
	local litDepths, distDepths = {}, {}
	for j = 1, lit do
		litDepths[j] = depths[j]
	end
	for j = lit + 1, #depths do
		distDepths[#distDepths + 1] = depths[j]
	end
	local litTable, litBits = huffman(litDepths)
	local distTable, distBits = huffman(distDepths)
	loop(output, stream, litTable, litBits, distTable, distBits)
end

local function static(output, stream)
	local depths = {}
	for i = 1, 4 do
		local depth = DPT[i]
		for _ = 1, CNT[i] do
			depths[#depths + 1] = depth
		end
	end
	local litTable, litBits = huffman(depths)
	loop(output, stream, litTable, litBits, STATIC_HUFFMAN, STATIC_BITS)
end

local function uncompressed(output, stream)
	flushBits(stream, band(stream.count, 7))
	local length = getBits(stream, 16); getBits(stream, 16)
	local buffer, position = stream.buffer, stream.position
	for i = position, position + length - 1 do
		output[#output + 1] = string.byte(buffer, i, i)
	end
	stream.position = position + length
end

local function int2le(buffer, position)
	local a,b = string.byte(buffer,position,position+1)
	return b<<8|a
end

local function int4le(buffer, position)
	local a,b,c,d = string.byte(buffer,position,position+3)
	return (((((d<<8)|c)<<8)|b)<<8)|a
end

inflate = {}

local BitStream = {}
BitStream.__index = BitStream

function inflate.new(buffer)
	local EOCD
	local pos = 1
	repeat
		local i,j = string.find(buffer,'PK\5\6',pos,true)
		if i then
			EOCD = i
			pos = j + 1
		end
	until not i
	if EOCD then
		buffer = string.sub(buffer,1,EOCD+19)..'\0\0'
	end
	local object = {buffer = buffer, position = 0, bits = 0, count = 0}
	return setmetatable(object, BitStream)
end

function inflate.setChunkSize(size)
	CHUNK_SIZE = size
end

function BitStream:files()
	local buffer = self.buffer
	local position = int4le(buffer, #buffer - 5) + 1
	return function()
		if int4le(buffer, position) ~= 33639248 then
			return
		end
		local packed = int2le(buffer, position + 10) ~= 0
		local crc = int4le(buffer, position + 16)
		local length = int2le(buffer, position + 28)
		local offset = int4le(buffer, position + 42) + 1
		local name = string.sub(buffer,position+46,position+45+length)
		position = position + 46 + length + int2le(buffer, position + 30) + int2le(buffer, position + 32)
		return name, offset + 30 + length + int2le(buffer, offset + 28), int4le(buffer, offset + 18), packed, crc
	end
end

function BitStream:inflate(offset, crc)
	local output, buffer = {}, {}
	local last, typ
	self.bits = 0
	self.count = 0
	self.position = offset
	repeat
		last, typ = getBits(self, 1), getBits(self, 2)
		typ = typ == 0 and uncompressed(output, self) or typ == 1 and static(output, self) or typ == 2 and dynamic(output, self)
	until last == 1
	local size = #output
	for i = 1, size, CHUNK_SIZE do
		buffer[#buffer+1] = string.char(table.unpack(output,i,math.min(i+CHUNK_SIZE-1,size)))
	end
	local result = table.concat(buffer)
	-- if crc and crc ~= generateCrc32(result) then
	--     error("Checksum verification failed: the computed CRC does not match the expected value.", 2)
	-- end
	return result
end

function BitStream:extract(offset, size)
	return string.sub(self.buffer,offset,offset+size-1)
end
