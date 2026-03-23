
gSizeX = 240
gSizeY = 136
gSizeX2 = gSizeX / 2
gSizeY2 = gSizeY / 2

gBlack = 0
gRed = 2
gWhite = 12
gGrey = 15

gAddPalette = 0x3FC0
gAddPalMap 	= 0x3FF0
gAddBorderCol = 0x3FF8
gAddScreenOffX = 0x3FF9
gAddScreenOffY = 0x3FFA
gAddBlitSegment = 0x3FFC --https://github.com/nesbox/TIC-80/wiki/Bits-Per-Pixel
gAddMap = 0x8000

-- keys (https://skyelynwaddell.github.io/tic80-manual-cheatsheet/)
gKeySpace = 48
gKeyTab = 49
gKeyUp = 58
gKeyDown = 59
gKeyLeft = 60
gKeyRight = 61
gKeyCtrl = 63

function printoutline(t, x, y, c, c2)
	local s=2
	for dx=-s,s do
		for dy=-s,s do
			print(t, x+dx, y+dy, c2)
		end
	end
	print(t, x, y, c)
end

function Outline(t,x,y,c,c2,fn,...)
	local w = print(t,500,500,c,...)
	local s = 1
	for dx = -s,s do
		for dy = -s,s do
			fn(t,x+dx,y+dy,c2,...)
		end
	end
	fn(t,x,y,c,...)
	return {w+2,10}
end

function printshadow(t, x, y, c, c2)
	dx = 2
	dy = 2
	print(t, x + dx, y + dy, c2)
	print(t, x, y, c)
end

function printstripes(t, x, y)
	for dy = 0, 8 do
		clip(0, y + dy, 240, 1)
		print(t, x, y, dy + 2)
	end
	clip()
end
