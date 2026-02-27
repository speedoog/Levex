
--[[
function shuffle( array )
   local returnArray = {}
   for i = #array, 1, -1 do
      local j = math.random(i)
      array[i], array[j] = array[j], array[i]
      table.insert(returnArray, array[i])
   end
   return returnArray
end
]]--

gSizeX	=240
gSizeY	=136
gSizeX2	=gSizeX/2
gSizeY2	=gSizeY/2
gBlack	=0
gWhite	=12
gGrey 	=15

function DrawCrosshair(mx, my)
	local min,max,c = 1,2,gWhite
	line(mx-max, my, mx-min, my, c)
	line(mx+min, my, mx+max, my, c)
	line(mx, my-max, mx, my-min, c)
	line(mx, my+min, mx, my+max, c)
end
