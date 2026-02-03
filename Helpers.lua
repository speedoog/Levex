
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
